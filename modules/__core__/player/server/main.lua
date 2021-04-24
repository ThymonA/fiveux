import 'db'
import 'logs'
import 'wallets'
import 'jobs'

--- Configuration
local cfg = ensure(config('general'), {})
local groups = ensure(cfg.groups, {})

--- Local storage
local data = {}
local ids = {}
local sources = {}
local saveInterval = ensure(cfg.savePlayersInterval, 1)

--- Defaults
local default_player = {
    group = ensure(cfg.defaultGroup, 'user'),
    job = ensure(ensure(cfg.defaultJob, {}).name, 'unemployed'),
    grade = ensure(ensure(cfg.defaultJob, {}).grade, 0),
    job2 = ensure(ensure(cfg.defaultJob2, {}).name, 'unemployed'),
    grade2 = ensure(ensure(cfg.defaultJob2, {}).grade, 0),
    spawn = ensure(cfg.defaultSpawn, vec(-206.79, -1015.12, 29.14))
}

---@class players
players = {}

--- Load a player based on given `source`
---@param source number player source
---@return player
function players:loadBySource(source)
    source = ensure(source, 0)

    if (source < 0) then return nil end

    if (source == 0) then
        sources[0] = 'system'
        ids['system'] = 0

        return self:loadByFx('system', 'system')
    end

    local name = ensure(GetPlayerName(source), 'unknown')

    if (sources == nil) then sources = {} end
    if (sources[source] ~= nil) then
        local fxid = ensure(sources[source], 'unknown')

        if (fxid ~= 'unknown') then
            ids[fxid] = source

            return self:loadByFx(fxid, name)
        end
    end

    local rawIdentifiers = ensure(GetPlayerIdentifiers(source), {})
    local identifiers = playerIdentifiers(rawIdentifiers)

    if (identifiers.fxid == nil or identifiers.fxid == 'unknown') then return nil end

    ids[identifiers.fxid] = source
    sources[source] = identifiers.fxid

    return self:loadByFx(identifiers.fxid, name)
end

--- Load a player based on given `identifier`
---@param identifier string primary identifier
---@param name string Name of player
---@return player
function players:loadByIdentifier(identifier, name)
    identifier = ensure(identifier, 'unknown')
    name = ensure(name, 'unknown')

    if (identifier == 'unknown') then return nil end

    local fxid = generateCitizenId(identifier)

    if (fxid == nil or fxid == 'unknown') then return nil end

    return self:loadByFx(fxid, name)
end

--- Load a player based on given `fxid`
---@param fxid string FiveUX ID
---@param name string Name of player
---@return player
function players:loadByFx(fxid, name)
    fxid = ensure(fxid, 'unknown')
    name = ensure(name, 'unknown')

    if (fxid == 'unknown') then return nil end
    if (data == nil) then data = {} end
    if (data[fxid] ~= nil) then return data[fxid] end

    local playerExists = self:fxExists(fxid)
    local playerData = nil

    if (not playerExists) then
        playerData = self:createPlayer(fxid, name)
    else
        playerData = self:getPlayer(fxid)
    end

    if (playerData == nil) then return nil end

    local identifiers = self:loadIdentifiersByFx(fxid)
    local job = jobs:loadByName(playerData.job)
    local job2 = jobs:loadByName(playerData.job2)

    if (job == nil) then
        if (playerData.job == default_player.job) then
            print_error(T('default_job_not_exists', default_player.job))
            return nil
        else
            job = jobs:loadByName(default_player.job)

            if (job == nil) then
                print_error(T('default_job_not_exists', default_player.job))
                return nil
            end
        end
    end

    if (job2 == nil) then
        if (playerData.job2 == default_player.job2) then
            print_error(T('default_job_not_exists', default_player.job2))
            return nil
        else
            job2 = jobs:loadByName(default_player.job2)

            if (job2 == nil) then
                print_error(T('default_job_not_exists', default_player.job2))
                return nil
            end
        end
    end

    local grade = job.grades[playerData.grade]

    if (grade == nil) then grade = job.grades[0] end
    if (grade == nil) then
        print_error(T('default_grade_not_exists', job.name))
        return nil
    end

    local grade2 = job2.grades[playerData.grade2]
    if (grade2 == nil) then grade2 = job2.grades[0] end
    if (grade2 == nil) then
        print_error(T('default_grade_not_exists', job2.name))
        return nil
    end

    ---@class player
    local player = {
        fxid = fxid,
        name = playerData.name,
        group = playerData.group,
        job = job,
        grade = grade,
        job2 = job2,
        grade2 = grade2,
        stats = playerData.stats,
        position = playerData.position,
        identifier = identifiers[PRIMARY],
        identifiers = identifiers,
        tokens = self:loadTokensByFx(fxid),
        variables = {},
        logger = logs:create('player', playerData.name, identifiers),
        wallets = wallets:loadAllByIdentifier(fxid),
        skins = db:fetchAll('SELECT * FROM `player_skins` WHERE `fxid` = :fxid', { ['fxid'] = fxid })
    }

    function player:getSource()
        local fxid = ensure(self.fxid, 'unknown')

        return ensure(ids[fxid], 0)
    end

    function player:triggerLocal(event, ...)
        return TriggerEvent(event, self, ...)
    end

    function player:triggerEvent(event, ...)
        local source = self:getSource()

        if (source <= 0 or source >= 65535) then return end

        return TriggerClientEvent(event, source, ...)
    end

    function player:updatePosition(coords)
        self.position = ensure(coords, self.position)
    end

    function player:kick(reason)
        reason = ensure(reason, T('no_reason'))

        local source = self:getSource()

        if (source > 0) then
            return DropPlayer(source, reason)
        end
    end
    
    function player:setGroup(group)
        group = ensure(group, 'user')

        if (not any(group, groups, 'value')) then return end

        self:removePrincipal(('group.%s'):format(self.group))
        self:log({
            arguments = { prev = self.group, new = group },
            action = 'group.set',
            discord = false
        })

        self.group = group
        self:addPrincipal(('group.%s'):format(self.group))
    end

    function player:getWallet(name)
        name = ensure(name, 'unknown')

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            return self.wallets[name].balance
        end
    end

    function player:setWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:setBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('player:wallet:set', name, self.wallets[name].balance, amount)
            self:triggerEvent('player:wallet:set', name, self.wallets[name].balance, amount)
            self:logWallet('set', name, amount, prevBalance, newBalance)
        end
    end

    function player:addWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:addBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('player:wallet:add', name, self.wallets[name].balance, amount)
            self:triggerEvent('player:wallet:add', name, self.wallets[name].balance, amount)
            self:logWallet('add', name, amount, prevBalance, newBalance)
        end
    end

    function player:removeWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:removeBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('player:wallet:remove', name, newBalance, amount)
            self:triggerEvent('player:wallet:remove', name, newBalance, amount)
            self:logWallet('remove', name, amount, prevBalance, newBalance)
        end
    end

    function player:setJob(name, grade)
        name = ensure(name, 'unknown')
        grade = ensure(grade, 0)

        if (name == 'unknown') then return end

        local newJob = jobs:loadByName(name)

        if (newJob == nil) then return end

        local newJobGrade = newJob.grades[grade]

        if (newJobGrade == nil) then return end

        self:removePrincipal(('job.%s'):format(self.job.name))
        self:removePrincipal(('job.%s'):format(self.job2.name))
        self:removePrincipal(('job.%s:%s'):format(self.job.name, self.grade.name))
        self:removePrincipal(('job.%s:%s'):format(self.job2.name, self.grade2.name))

        self:log({
            arguments = { prevJob = self.job.name, newJob = newJob.name, prevGrade = self.grade.grade, newGrade = newJobGrade.grade },
            action = 'job.set',
            discord = false
        })

        self.job = newJob
        self.grade = newJobGrade

        self:addPrincipal(('job.%s'):format(self.job.name))
        self:addPrincipal(('job.%s'):format(self.job2.name))
        self:addPrincipal(('job.%s:%s'):format(self.job.name, self.grade.name))
        self:addPrincipal(('job.%s:%s'):format(self.job2.name, self.grade2.name))
    end

    function player:setJob2(name, grade)
        name = ensure(name, 'unknown')
        grade = ensure(grade, 0)

        if (name == 'unknown') then return end

        local newJob = jobs:loadByName(name)

        if (newJob == nil) then return end

        local newJobGrade = newJob.grades[grade]

        if (newJobGrade == nil) then return end

        self:removePrincipal(('job.%s'):format(self.job.name))
        self:removePrincipal(('job.%s'):format(self.job2.name))
        self:removePrincipal(('job.%s:%s'):format(self.job.name, self.grade.name))
        self:removePrincipal(('job.%s:%s'):format(self.job2.name, self.grade2.name))

        self:log({
            arguments = { prevJob = self.job2.name, newJob = newJob.name, prevGrade = self.grade2.grade, newGrade = newJobGrade.grade },
            action = 'job2.set',
            discord = false
        })

        self.job2 = newJob
        self.grade2 = newJobGrade

        self:addPrincipal(('job.%s'):format(self.job.name))
        self:addPrincipal(('job.%s'):format(self.job2.name))
        self:addPrincipal(('job.%s:%s'):format(self.job.name, self.grade.name))
        self:addPrincipal(('job.%s:%s'):format(self.job2.name, self.grade2.name))
    end

    function player:logWallet(type, name, amount, prevBalance, newBalance)
        type = ensure(type, 'add')
        name = ensure(name, 'unknown')
        amount = ensure(amount, 0)
        prevBalance = ensure(prevBalance, 0)
        newBalance = ensure(newBalance, 0)

        self:log({
            arguments = { amount = amount, name = name, prev = prevBalance, new = newBalance },
            action = ('wallet.%s.%s'):format(name, type),
            discord = false
        })
    end

    function player:setVariable(key, value)
        key = ensure(key, 'unknown')

        if (key == 'unknown') then return end

        self.variables = ensure(self.variables, {})
        self.variables[key] = value
    end

    function player:getVariable(key)
        key = ensure(key, 'unknown')

        if (key == 'unknown') then return nil end

        self.variables = ensure(self.variables, {})

        return self.variables[key]
    end

    function player:addSkin(name, model, skin, active)
        name = ensure(name, 'unknown')
        model = ensure(model, 'mp_m_freemode_01')
        skin = encode(ensure(skin, {}), false, 0)
        active = ensure(ensure(active, false), 0)
        
        local id = db:insert('INSERT INTO `player_skins` (`fxid`, `name`, `model`, `skin`, `active`) VALUES (:fxid, :name, :model, :skin, :active)', {
            ['fxid'] = self.fxid,
            ['name'] = name,
            ['model'] = model,
            ['skin'] = skin,
            ['active'] = active
        })

        table.insert(self.skins, {
            id = id,
            fxid = self.fxid,
            name = name,
            model = model,
            skin = skin,
            active = active
        })

        if (active) then
            self:makeSkinActive(#self.skins)
        end
    end

    function player:getActiveSkin()
        if (#self.skins <= 0) then return nil end
        
        for _, skin in pairs(self.skins) do
            if (ensure(skin.active, false)) then
                return {
                    id = ensure(skin.id, 0),
                    fxid = ensure(skin.fxid, self.fxid),
                    name = ensure(skin.name, 'unknown'),
                    model = ensure(skin.model, 'mp_m_freemode_01'),
                    skin = json.decode(ensure(skin.skin, '[]')),
                    active = true
                }
            end
        end

        self:makeSkinActive(1)

        return {
            id = ensure(self.skins[1].id, 0),
            fxid = ensure(self.skins[1].fxid, self.fxid),
            name = ensure(self.skins[1].name, 'unknown'),
            model = ensure(self.skins[1].model, 'mp_m_freemode_01'),
            skin = json.decode(ensure(self.skins[1].skin, '[]')),
            active = true
        }
    end

    function player:getSkinById(id)
        id = ensure(id, 0)

        if (#self.skins <= 0) then return nil end

        for _, skin in pairs(self.skins) do
            if (ensure(skin.id, 0) == id) then
                return {
                    id = ensure(skin.id, 0),
                    fxid = ensure(skin.fxid, self.fxid),
                    name = ensure(skin.name, 'unknown'),
                    model = ensure(skin.model, 'mp_m_freemode_01'),
                    skin = json.decode(ensure(skin.skin, '[]')),
                    active = ensure(skin.active, false)
                }
            end
        end

        return nil
    end

    function player:makeSkinActive(index)
        index = ensure(index, 0)

        if (#self.skins <= 0) then return end

        for i, _ in pairs(self.skins) do
            self.skins[i].active = i == index
        end
    end

    function player:log(object)
        if (self.logger == nil) then return nil end

        return self.logger:log(object)
    end

    function player:save()
        local name = ensure(self.name, 'unknown')

        db:execute('UPDATE `players` SET `name` = :name, `group` = :group, `job` = :job, `grade` = :grade, `job2` = :job2, `grade2` = :grade2, `stats` = :stats, `position` = :position WHERE `fxid` = :fxid', {
            ['name'] = name,
            ['group'] = ensure(self.group, default_player.group),
            ['job'] = ensure(self.job.name, default_player.job),
            ['grade'] = ensure(self.grade.grade, default_player.grade),
            ['job2'] = ensure(self.job2.name, default_player.job2),
            ['grade2'] = ensure(self.grade2.grade, default_player.grade2),
            ['stats'] = ensure(self.stats, '[]'),
            ['position'] = ensure(self.position, '[0, 0, 0]'),
            ['fxid'] = ensure(self.fxid, 'unknown')
        })

        for _, wallet in pairs(ensure(self.wallets, {})) do
            if (wallet ~= nil) then
                wallet:save()
            end
        end

        for _, skin in pairs(ensure(self.skins, {})) do
            if (skin ~= nil) then
                db:execute('UPDATE `player_skins` SET `name` = :name, `model` = :model, `skin` = :skin, `active` = :active WHERE `id` = :id', {
                    ['name'] = ensure(skin.name, 'unknown'),
                    ['model'] = ensure(skin.model, 'mp_m_freemode_01'),
                    ['skin'] = encode(ensure(skin.skin, {}), false, 0),
                    ['active'] = ensure(skin.active, 0),
                    ['id'] = ensure(skin.id, 0)
                })
            end
        end

        print_success(T('player_saved', name))
    end

    function player:addPrincipal(principal)
        principal = ensure(principal, 'unknown')

        if (self.identifier ~= nil and self.identifier ~= 'unknown') then
            ExecuteCommand(('add_principal identifier.%s:%s %s'):format(PRIMARY, self.identifier, principal))
        end

        ExecuteCommand(('add_principal identifier.fxid:%s %s'):format(self.fxid, principal))
    end

    function player:removePrincipal(principal)
        principal = ensure(principal, 'unknown')

        if (self.identifier ~= nil and self.identifier ~= 'unknown') then
            ExecuteCommand(('remove_principal identifier.%s:%s %s'):format(PRIMARY, self.identifier, principal))
        end

        ExecuteCommand(('remove_principal identifier.fxid:%s %s'):format(self.fxid, principal))
    end

    player:addPrincipal(('group.%s'):format(player.group))
    player:addPrincipal(('job.%s'):format(player.job.name))
    player:addPrincipal(('job.%s'):format(player.job2.name))
    player:addPrincipal(('job.%s:%s'):format(player.job.name, player.grade.name))
    player:addPrincipal(('job.%s:%s'):format(player.job2.name, player.grade2.name))

    data[fxid] = player

    return player
end

--- Checks if a player with given `fxid` exists in database
---@param fxid string FiveUX ID
---@return boolean If given `fxid` exists
function players:fxExists(fxid)
    fxid = ensure(fxid, 'unknown')

    if (fxid == 'unknown') then return false end

    local dbResult = db:fetchScalar('SELECT COUNT(*) FROM `players` WHERE `fxid` = :fxid LIMIT 1', { ['fxid'] = fxid })

    return ensure(dbResult, 0) == 1
end

--- Load player data from database
---@param fxid string FiveUX ID
---@return table Player information
function players:getPlayer(fxid)
    fxid = ensure(fxid, 'unknown')

    if (fxid == 'unknown') then return nil end

    local dbResults = db:fetchAll('SELECT * FROM `players` WHERE `fxid` = :fxid LIMIT 1', {
        ['fxid'] = fxid
    })

    dbResults = ensure(dbResults, {})

    if (#dbResults >= 1) then
        local dbPlayer = ensure(dbResults[1], {})
        local player = {
            fxid = fxid,
            name = ensure(dbPlayer.name, 'unknown'),
            group = ensure(dbPlayer.group, 'user'),
            job = ensure(dbPlayer.job, 'unemployed'),
            grade = ensure(dbPlayer.grade, 0),
            job2 = ensure(dbPlayer.job2, 'unemployed'),
            grade2 = ensure(dbPlayer.grade2, 0),
            stats = ensure(dbPlayer.stats, { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 }),
            position = ensure(dbPlayer.position, default_player.spawn)
        }

        return player
    end
    
    return nil
end

--- Create a new player object in database
---@param fxid string FiveUX ID
---@param name string Name of player
---@return table Player information
function players:createPlayer(fxid, name)
    fxid = ensure(fxid, 'unknown')
    name = ensure(name, 'unknown')

    local defaultGroup = ('%s'):format(default_player.group)

    if (fxid == 'unknown') then return nil end
    if (fxid == 'system') then defaultGroup = 'superadmin' end

    local player = {
        fxid = fxid,
        name = name,
        group = defaultGroup,
        job = default_player.job,
        grade = default_player.grade,
        job2 = default_player.job2,
        grade2 = default_player.grade2,
        stats = { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 },
        position = default_player.spawn
    }

    local done = db:execute('INSERT INTO `players` (`fxid`, `name`, `group`, `job`, `grade`, `job2`, `grade2`, `stats`, `position`) VALUES (:fxid, :name, :group, :job, :grade, :job2, :grade2, :stats, :position)', {
        ['fxid'] = player.fxid,
        ['name'] = player.name,
        ['group'] = player.group,
        ['job'] = player.job,
        ['grade'] = player.grade,
        ['job2'] = player.job2,
        ['grade2'] = player.grade2,
        ['stats'] = encode(player.stats),
        ['position'] = encode(player.position)
    })

    return player
end

--- Returns a list of tokens
---@param source number player source
---@return table List of tokens
function players:loadTokensBySource(source)
    source = ensure(source, 0)

    if (source <= 0) then return {} end

    local tokens = {}
    local nums = ensure(GetNumPlayerTokens(source), 0)

    for i = 0, (nums - 1) do
        local token = ensure(GetPlayerToken(source, i), '0:unknown')
        local prefix = ensure(token:sub(1, 1), 0)
        local suffix = ensure(token:sub(3), 'unknown')

        if (suffix ~= 'unknown') then
            if (token[prefix] == nil) then tokens[prefix] = {} end

            table.insert(tokens[prefix], suffix)
        end
    end

    return tokens
end

--- Load player tokens from datatabse
---@param identifier string primary identifier
---@return table List of tokens
function players:loadTokensByIdentifier(identifier)
    identifier = ensure(identifier, 'unknown')

    if (identifier == 'unknown') then return {} end

    local fxid = generateCitizenId(identifier)

    if (fxid == nil or fxid == 'unknown') then return {} end

    return self:loadTokensByFx(fxid)
end

--- Load player tokens from datatabse
---@param fxid string FiveUX ID
---@return table List of tokens
function players:loadTokensByFx(fxid)
    fxid = ensure(fxid, 'unknown')

    if (fxid == 'unknown') then return {} end
    if (fxid == 'system') then return {} end

    local dbResults = db:fetchAll('SELECT * FROM `player_tokens` WHERE `fxid` = :fxid AND `date` = (SELECT `date` FROM `player_tokens` WHERE `fxid` = :fxid GROUP BY `date` ORDER BY `date` DESC LIMIT 1)', { ['fxid'] = fxid })

    dbResults = ensure(dbResults, {})

    local tokens = {}

    if (#dbResults > 0) then
        for _, token in pairs(dbResults) do
            token = ensure(token, {})

            local prefix = ensure(token.prefix, 0)
            local value = ensure(token.value, 'unknown')

            if (value ~= 'unknown') then
                if (tokens == nil) then tokens = {} end
                if (tokens[prefix] == nil) then tokens[prefix] = {} end

                table.insert(tokens[prefix], value)
            end
        end
    end

    return tokens
end

--- Load player identifiers from database
---@param identifier string player primary identifier
---@return table List of identifiers
function players:loadIdentifiersByIdentifier(identifier)
    identifier = ensure(identifier, 'unknown')

    if (identifier == 'unknown') then return playerIdentifiers({}) end

    local fxid = generateCitizenId(identifier)

    if (fxid == nil or fxid == 'unknown') then return playerIdentifiers({}) end

    return self:loadIdentifiersByFx(fxid)
end

--- Load player identifiers from database
---@param fxid string FiveUX ID
---@return table List of identifiers
function players:loadIdentifiersByFx(fxid)
    fxid = ensure(fxid, 'unknown')

    local identifiers = {
        steam = nil,
        license = nil,
        license2 = nil,
        xbl = nil,
        live = nil,
        discord = nil,
        fivem = nil,
        ip = nil,
        fxid = nil
    }

    if (fxid == 'unknown') then return identifiers end
    if (fxid == 'system') then
        identifiers.steam = 'system'
        identifiers.license = 'system'
        identifiers.license2 = 'system'
        identifiers.xbl = 'system'
        identifiers.live = 'system'
        identifiers.discord = 'system'
        identifiers.fivem = 'system'
        identifiers.ip = '127.0.0.1'
        identifiers.fxid = 'system'
        
        return identifiers
    end

    local dbResults = db:fetchAll('SELECT * FROM `player_identifiers` WHERE `fxid` = :fxid ORDER BY `date` DESC LIMIT 1', { ['fxid'] = fxid })

    dbResults = ensure(dbResults, {})

    if (#dbResults > 0) then
        local dbResult = ensure(dbResults[1], {})

        identifiers.steam = dbResult.steam
        identifiers.license = dbResult.license
        identifiers.license2 = dbResult.license2
        identifiers.xbl = dbResult.xbl
        identifiers.live = dbResult.live
        identifiers.discord = dbResult.discord
        identifiers.fivem = dbResult.fivem
        identifiers.ip = dbResult.ip
        identifiers.fxid = dbResult.fxid
    end

    return identifiers
end

--- Update all player related data in database
---@param source number player source
---@return boolean update succeed
function players:updatePlayerBySource(source)
    source = ensure(source, 0)

    if (source <= 0) then return false end

    local name = ensure(GetPlayerName(source), 'unknown')
    local rawIdentifiers = ensure(GetPlayerIdentifiers(source), {})
    local identifiers = playerIdentifiers(rawIdentifiers)

    if (identifiers.fxid == nil or identifiers.fxid == 'unknown') then return false end

    db:execute('UPDATE `players` SET `name` = :name WHERE `fxid` = :fxid', { ['name'] = name, ['fxid'] = identifiers.fxid })

    local timestamp = db:fetchScalar('SELECT CURRENT_TIMESTAMP')
    local tokens = self:loadTokensBySource(source)

    for _prefix, _tokens in pairs(tokens) do
        _prefix = ensure(_prefix, 0)
        _tokens = ensure(_tokens, {})

        for _, _token in pairs(_tokens) do
            _token = ensure(_token, 'unknown')

            if (_token ~= 'unknown') then
                local dbResult = db:fetchScalar('SELECT COUNT(*) FROM `player_tokens` WHERE `fxid` = :fxid AND `prefix` = :prefix AND `value` = :value LIMIT 1', {
                    ['fxid'] = identifiers.fxid,
                    ['prefix'] = _prefix,
                    ['value'] = _token
                })
                
                if (ensure(dbResult, 0) == 1) then
                    db:execute('UPDATE `player_tokens` SET `date` = :date WHERE `fxid` = :fxid AND `prefix` = :prefix AND `value` = :value', {
                        ['date'] = timestamp,
                        ['fxid'] = identifiers.fxid,
                        ['prefix'] = _prefix,
                        ['value'] = _token
                    })
                else
                    db:insert('INSERT INTO `player_tokens` (`fxid`, `prefix`, `value`, `date`) VALUES (:fxid, :prefix, :value, :date)', {
                        ['fxid'] = identifiers.fxid,
                        ['prefix'] = _prefix,
                        ['value'] = _token,
                        ['date'] = timestamp
                    })
                end
            end
        end
    end

    db:insert('INSERT INTO `player_identifiers` (`fxid`, `name`, `steam`, `license`, `license2`, `xbl`, `live`, `discord`, `fivem`, `ip`, `date`) VALUES (:fxid, :name, :steam, :license, :license2, :xbl, :live, :discord, :fivem, :ip, :date)', {
        ['fxid'] = identifiers.fxid,
        ['name'] = name,
        ['steam'] = identifiers.steam,
        ['license'] = identifiers.license,
        ['license2'] = identifiers.license2,
        ['xbl'] = identifiers.xbl,
        ['live'] = identifiers.live,
        ['discord'] = identifiers.discord,
        ['fivem'] = identifiers.fivem,
        ['ip'] = identifiers.ip,
        ['date'] = timestamp
    })

    return true
end

--- Save all players
function players:saveAll()
    for fxid, playerSource in pairs(ids) do
        if (playerSource ~= nil) then
            playerSource = ensure(playerSource, 0)

            if (playerSource > 0 and playerSource < 5565) then
                local player = self:loadBySource(playerSource)

                if (player ~= nil) then
                    player:save()
                end
            end
        end
    end

    print_success(T('players_saved'))
end

--- Load console player by default
Citizen.CreateThread(function()
    while db:hasMigration(NAME) do
        Citizen.Wait(0)
    end

    players:loadBySource(0)
end)

--- Thread to save players every `x` time
Citizen.CreateThread(function()
    while db:hasMigration(NAME) do
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(round(saveInterval * (60 * 1000)))

        players:saveAll()
    end
end)

--- Will be triggered when a player disconnects from the server
on('playerDropped', function(p, s, r)
    p = ensure(p, {})

    local fxid = ensure(p.fxid, 'unknown')
    local name = ensure(p.name, 'unknown')
    local player = players:loadByFx(fxid, name)

    if (player == nil) then return end

    --- Save player data
    player:save()

    --- Remove cached source
    ids[fxid] = nil
end)

--- Export players
export('players', players)