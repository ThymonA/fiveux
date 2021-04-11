import 'db'
import 'logs'

local data = {}
local ids = {}
local sources = {}

--- @class players
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

    ---@class player
    local player = {
        fxid = fxid,
        name = playerData.name,
        group = playerData.group,
        job = playerData.job,
        grade = playerData.grade,
        job2 = playerData.job2,
        grade2 = playerData.grade2,
        stats = playerData.stats,
        position = playerData.position,
        identifier = identifiers[PRIMARY],
        identifiers = identifiers,
        tokens = self:loadTokensByFx(fxid),
        variables = {},
        logger = logs:create('player', playerData.name, identifiers)
    }

    function player:getSource()
        local fxid = ensure(self.fxid, 'unknown')

        return ensure(ids[fxid], 0)
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
    end
    
    function player:setGroup(group)
        group = ensure(group, 'user')
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

    function player:log(object)
        if (self.logger == nil) then return nil end

        return self.logger:log(object)
    end

    if (player.identifier ~= nil and player.identifier ~= 'unknown') then
        ExecuteCommand(('add_principal identifier.%s:%s group.%s'):format(PRIMARY, player.identifier, player.group))
        ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(PRIMARY, player.identifier, player.job))
        ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(PRIMARY, player.identifier, player.job2))
    end

    ExecuteCommand(('add_principal identifier.fxid:%s group.%s'):format(player.fxid, player.group))
    ExecuteCommand(('add_principal identifier.fxid:%s job.%s'):format(player.fxid, player.job))
    ExecuteCommand(('add_principal identifier.fxid:%s job.%s'):format(player.fxid, player.job2))

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
        local cfg = ensure(config('general'), {})
        local defaultSpawn = ensure(cfg.defaultSpawn, vec(-206.79, -1015.12, 29.14))
        local player = {
            fxid = fxid,
            name = ensure(dbPlayer.name, 'unknown'),
            group = ensure(dbPlayer.group, 'user'),
            job = ensure(dbPlayer.job, 'unemployed'),
            grade = ensure(dbPlayer.grade, 0),
            job2 = ensure(dbPlayer.name, 'unemployed'),
            grade2 = ensure(dbPlayer.grade, 0),
            stats = ensure(dbPlayer.stats, { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 }),
            position = ensure(dbPlayer.position, defaultSpawn)
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

    if (fxid == 'unknown') then return nil end

    local cfg = ensure(config('general'), {})
    local defaultGroup = ensure(cfg.defaultGroup, 'user')
    local defaultJob = ensure(cfg.defaultJob, {})
    local defaultJob2 = ensure(cfg.defaultJob2, {})
    local defaultSpawn = ensure(cfg.defaultSpawn, vec(-206.79, -1015.12, 29.14))

    if (fxid == 'system') then defaultGroup = 'superadmin' end

    local player = {
        fxid = fxid,
        name = name,
        group = defaultGroup,
        job = ensure(defaultJob.name, 'unemployed'),
        grade = ensure(defaultJob.grade, 0),
        job2 = ensure(defaultJob2.name, 'unemployed'),
        grade2 = ensure(defaultJob2.grade, 0),
        stats = { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 },
        position = defaultSpawn
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

--- Load console player by default
Citizen.CreateThread(function()
    while db:hasMigration(NAME) do
        Citizen.Wait(0)
    end

    players:loadBySource(0)
end)

export('players', players)