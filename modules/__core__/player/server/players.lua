using 'db'
using 'bans'
using 'wallets'
using 'jobs'
using 'locations'
using 'events'
using 'threads'
using 'items'
using 'object'

local data = {}

players = {}

function players:get(source)
    source = ensure(source, 0)

    if (source < 0) then return nil end

    return data[source]
end

function players:load(source)
    source = ensure(source, -1)

    if (source < 0) then return nil end

    local player
    local identifier = self:getPrimaryIdentifier(source)
    local key = ('players:%s'):format(identifier)
    local cfg = config('general')
    local defaultSpawn = ensure(cfg.defaultSpawn, vec(-206.79, -1015.12, 29.14))
    local defaultGroup = ensure(cfg.defaultGroup, 'user')
    
    if (source == 0) then
        player = {
            id = 0,
            source = 0,
            name = 'Console',
            citizen = 'system',
            identifier = 'console',
            identifiers = self:getPlayerIdentifiers(source),
            tokens = self:getPlayerTokens(source),
            banned = false,
            banInfo = {},
            wallets = {},
            locations = {},
            items = {}
        }
    elseif (cache:exists(key)) then
        player = cache:read(key)
        player.source = source
        player.identifiers = self:getPlayerIdentifiers(source)
        player.tokens = self:getPlayerTokens(source)
    else
        if (wallets == nil) then using 'wallets' end
        if (locations == nil) then using 'locations' end
        if (jobs == nil) then using 'jobs' end
        if (items == nil) then using 'items' end

        player = {
            id = 0,
            source = source,
            name = ensure(GetPlayerName(source), 'Unknown'),
            citizen = self:generateCitizenId(identifier),
            identifier = identifier,
            identifiers = self:getPlayerIdentifiers(source),
            tokens = self:getPlayerTokens(source),
            banned = false,
            banInfo = {},
            wallets = {},
            locations = {},
            items = {}
        }

        if (identifier == nil) then
            player.banned = true
            
            return player
        end

        local dbPlayers = db:fetchAll('SELECT * FROM `players` WHERE `citizen` = :citizen LIMIT 1', {
            ['citizen'] = player.citizen
        })

        dbPlayers = ensure(dbPlayers, {})

        if (#dbPlayers <= 0) then
            local cfg = config('general')
            local defaultJob = ensure(cfg.defaultJob, {})
            local jobName = ensure(defaultJob.name, 'unemployed')
            local jobGrade = ensure(defaultJob.grade, 'unemployed')
            local jobId, gradeId = jobs:getJobIdWithGrade(jobName, jobGrade)

            player.id = db:insert('INSERT INTO `players` (`citizen`, `name`, `group`, `job`, `grade`, `job2`, `grade2`, `position`) VALUES (:citizen, :name, :group, :job, :grade, :job2, :grade2, :position)', {
                ['citizen'] = player.citizen,
                ['name'] = player.name,
                ['group'] = defaultGroup,
                ['job'] = jobId,
                ['grade'] = gradeId,
                ['job2'] = jobId,
                ['grade2'] = gradeId,
                ['position'] = ensure(defaultSpawn, '[-206.79,-1015.12,29.14]')
            })

            player.job = jobs:getJobWithGrade(jobId, gradeId)
            player.job2 = jobs:getJobWithGrade(jobId, gradeId)
            player.group = defaultGroup
            player.position = defaultSpawn
            player.stats = { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 }

            print_success(T('player_created', player.name))
        else
            local dbPlayer = ensure(dbPlayers[1], {})

            player.id = ensure(dbPlayer.id, 0)
            player.job = jobs:getJobWithGrade(ensure(dbPlayer.job, 0), ensure(dbPlayer.grade, 0))
            player.job2 = jobs:getJobWithGrade(ensure(dbPlayer.job2, 0), ensure(dbPlayer.grade2, 0))
            player.group = ensure(dbPlayer.group, defaultGroup)
            player.position = ensure(dbPlayer.position, defaultSpawn)
            player.stats = ensure(dbPlayer.stats, { health = 100, armor = 0, stamina = 100, thirst = 100, hunger = 100 })
        end

        player.wallets = wallets:getPlayerWallets(player.id)
        player.locations = locations:getPlayerLocations(player.citizen)
        player.items = items:getPlayerItems(player.id)

        ExecuteCommand(('add_principal identifier.citizen:%s group.%s'):format(player.citizen, player.group))
        ExecuteCommand(('add_principal identifier.%s:%s group.%s'):format(__PRIMARY__, player.identifier, player.group))
        ExecuteCommand(('add_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(self.job, {}).name, 'unemployed')))
        ExecuteCommand(('add_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(self.job2, {}).name, 'unemployed')))
        ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(self.job, {}).name, 'unemployed')))
        ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(self.job2, {}).name, 'unemployed')))
    end

    if (source > 0) then
        player.banned, player.banInfo = bans:updateBanStatus(player.identifiers, player.name)
    end

    cache:write(key, player)

    function player:log(object)
        return log_queue(ensure(self.source, 0))(object)
    end

    function player:kick(msg)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        msg = encode(msg, true)

        local source = ensure(self.source, 0)

        if (source > 0) then
            DropPlayer(source, msg)
        end
    end

    function player:triggerEvent(event, ...)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        event = ensure(event, 'unknown')

        local source = ensure(self.source, 0)

        if (source > 0) then
            TriggerNet(event, source, ...)
        end
    end

    function player:save()
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        local playerId = ensure(self.id, 0)
        local job = ensure(self.job, {})
        local job_grade = ensure(job.grade, {})
        local job2 = ensure(self.job2, {})
        local job2_grade = ensure(job.grade, {})

        db:execute([[
            UPDATE `players` SET `name` = :name, `group` = :group, `job` = :job, `grade` = :grade, `job2` = :job2, `grade2` = :grade2, `stats` = :stats, `position` = :position
            WHERE `id` = :id
        ]], {
            ['name'] = ensure(self.name, 'Unknown'),
            ['group'] = ensure(self.group, 'user'),
            ['job'] = ensure(job.id, 0),
            ['grade'] = ensure(job_grade.grade, 0),
            ['job2'] = ensure(job2.id, 0),
            ['grade2'] = ensure(job2_grade.grade, 0),
            ['stats'] = encode(ensure(self.stats, {})),
            ['position'] = encode(ensure(self.position, vec(-206.79, -1015.12, 29.14))),
            ['id'] = playerId
        })

        self:saveWallets()
        self:saveItems()

        print_success(T('player_saved', ensure(self.name, 'Unknown')))
    end

    function player:saveWallets()
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        local playerId = ensure(self.id, 0)
        local wallets = ensure(self.wallets, {})

        for name, balance in pairs(wallets) do
            name = ensure(name, 'unknown')
            balance = ensure(balance, 0)

            db:execute("UPDATE `player_wallets` SET `balance` = :balance WHERE `name` = :name AND `player_id` = :id", {
                ['balance'] = balance,
                ['name'] = name,
                ['id'] = playerId
            })
        end
    end

    function player:saveItems()
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        local playerId = ensure(self.id, 0)
        local item_info = ensure(items:getInfo(), {})
        local items = ensure(self.items, {})

        for name, amount in pairs(items) do
            name = ensure(name, 'unknown')
            amount = ensure(amount, 0)

            local itemInfo = ensure(item_info[name], {})
            local savable = ensure(itemInfo.savable, true)

            if (savable) then
                db:execute("UPDATE `player_items` SET `amount` = :amount WHERE `name` = :name AND `player_id` = :id", {
                    ['amount'] = amount,
                    ['name'] = name,
                    ['id'] = playerId
                })
            end
        end
    end

    function player:setWallet(name, amount)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        name = ensure(name, 'unknown')
        amount = ensure(amount, 0)

        if (self.wallets and self.wallets[name]) then
            local prevBalance = ensure(self.wallets[name], 0)
            local newBalance = amount

            self.wallets[name] = newBalance
            self:triggerEvent('update:wallet', name, newBalance, prevBalance)
            self:log({
                action = 'wallet.set',
                arguments = { newBalance = newBalance, prevBalance = prevBalance, name = name },
                discord = false
            })
        end
    end

    function player:addWallet(name, amount)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        name = ensure(name, 'unknown')
        amount = ensure(amount, 0)

        if (self.wallets and self.wallets[name] and amount >= 0) then
            local prevBalance = ensure(self.wallets[name], 0)
            local newBalance = prevBalance + amount

            self.wallets[name] = newBalance
            self:triggerEvent('update:wallet', name, newBalance, prevBalance)
            self:log({
                action = 'wallet.add',
                arguments = { newBalance = newBalance, prevBalance = prevBalance, name = name },
                discord = false
            })
        end
    end

    function player:removeWallet(name, amount)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        name = ensure(name, 'unknown')
        amount = ensure(amount, 0)

        if (self.wallets and self.wallets[name] and amount >= 0) then
            local prevBalance = ensure(self.wallets[name], 0)
            local newBalance = prevBalance - amount

            self.wallets[name] = newBalance
            self:triggerEvent('update:wallet', name, newBalance, prevBalance)
            self:log({
                action = 'wallet.remove',
                arguments = { newBalance = newBalance, prevBalance = prevBalance, name = name },
                discord = false
            })
        end
    end

    function player:setGroup(group)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        local oldGroup = ensure(self.group, 'user')
        local newGroup = ensure(group, 'user')

        if (not any(newGroup, constants.groups, 'value')) then
            return
        end

        ExecuteCommand(('remove_principal identifier.citizen:%s group.%s'):format(self.citizen, oldGroup))
        ExecuteCommand(('remove_principal identifier.%s:%s group.%s'):format(__PRIMARY__, self.identifier, oldGroup))
        ExecuteCommand(('add_principal identifier.citizen:%s group.%s'):format(self.citizen, newGroup))
        ExecuteCommand(('add_principal identifier.%s:%s group.%s'):format(__PRIMARY__, self.identifier, newGroup))

        self.group = newGroup;
        self:triggerEvent('update:group', newGroup, oldGroup)
        self:log({
            action = 'group.set',
            arguments = { oldGroup = oldGroup, newGroup = newGroup },
            discord = false
        })
    end

    function player:setJob(name, grade)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        name = ensure(name, 'unemployed')
        grade = ensure(grade, 0)

        local jobId, gradeId = jobs:getJobIdWithGrade(name, grade)

        if (jobId ~= nil and gradeId ~= nil) then
            local prevJob = ensure(self.job, {})
            local newJob = jobs:getJobWithGrade(jobId, gradeId)

            if (job ~= nil) then
                ExecuteCommand(('remove_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(prevJob, {}).name, 'unemployed')))
                ExecuteCommand(('remove_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(prevJob, {}).name, 'unemployed')))
                ExecuteCommand(('add_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(newJob, {}).name, 'unemployed')))
                ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(newJob, {}).name, 'unemployed')))

                self.job = newJob
                self:triggerEvent('update:job', object:convert('job', newJob),  object:convert('job', prevJob))
                self:log({
                    action = 'job.set',
                    arguments = { prevJob = prevJob.name, newJob = newJob.name },
                    discord = false
                })
            end
        end
    end

    function player:setJob2(name, grade)
        if (ensure(self.citizen, 'unknown') == 'system') then return end

        name = ensure(name, 'unemployed')
        grade = ensure(grade, 0)

        local jobId, gradeId = jobs:getJobIdWithGrade(name, grade)

        if (jobId ~= nil and gradeId ~= nil) then
            local prevJob = ensure(self.job2, {})
            local newJob = jobs:getJobWithGrade(jobId, gradeId)

            if (job ~= nil) then
                ExecuteCommand(('remove_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(prevJob, {}).name, 'unemployed')))
                ExecuteCommand(('remove_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(prevJob, {}).name, 'unemployed')))
                ExecuteCommand(('add_principal identifier.citizen:%s job.%s'):format(player.citizen, ensure(ensure(newJob, {}).name, 'unemployed')))
                ExecuteCommand(('add_principal identifier.%s:%s job.%s'):format(__PRIMARY__, player.identifier, ensure(ensure(newJob, {}).name, 'unemployed')))

                self.job2 = newJob
                self:triggerEvent('update:job2', object:convert('job', newJob),  object:convert('job', prevJob))
                self:log({
                    action = 'job2.set',
                    arguments = { prevJob = prevJob.name, newJob = newJob.name },
                    discord = false
                })
            end
        end
    end

    function player:error(...)
        if (ensure(self.citizen, 'unknown') == 'system') then print_error(...) return end
    end

    function player:allowed(ace)
        if (ensure(self.citizen, 'unknown') == 'system') then return true end

        ace = ensure(ace, 'unknown')

        local source = ensure(self.source, 0)
        local playerAllowed = IsPlayerAceAllowed(source, ace)

        if (playerAllowed) then return true end

        local group = ensure(self.group, 'user')
        local groupAllowed = IsPrincipalAceAllowed(('group.%s'):format(group), ace)

        if (groupAllowed) then return true end

        local job = ensure(ensure(self.job, {}).name, 'unemployed')
        local jobAllowed = IsPrincipalAceAllowed(('job.%s'):format(job), ace)

        if (jobAllowed) then return true end

        local job2 = ensure(ensure(self.job2, {}).name, 'unemployed')
        local job2Allowed = IsPrincipalAceAllowed(('job.%s'):format(job2), ace)

        if (job2Allowed) then return true end

        return false
    end

    data[player.source] = player

    return player
end

function players:getPrimaryIdentifier(source)
    source = ensure(source, -1)

    if (source < 0) then return nil end
    if (source == 0) then return 'console' end

    local num = GetNumPlayerIdentifiers(source)

    for i = 0, (num - 1), 1 do
        local identifier = ensure(GetPlayerIdentifier(source, i), 'unknown')

        if (identifier:startsWith(('%s:'):format(__PRIMARY__))) then
            return identifier:sub(#__PRIMARY__ + 2)
        end
    end

    return nil
end

function players:getPlayerIdentifiers(source)
    source = ensure(source, -1)

    local identifiers = {
        steam = nil,
        license = nil,
        license2 = nil,
        xbl = nil,
        live = nil,
        discord = nil,
        fivem = nil,
        ip = nil,
        citizen = nil
    }

    if (source < 0) then return identifiers end

    if (source > 0) then
        local num = GetNumPlayerIdentifiers(source)

        for i = 0, (num - 1), 1 do
            local identifier = ensure(GetPlayerIdentifier(source, i), 'unknown')

            for k, v in pairs(constants.identifierTypes) do
                local prefix = ('%s:'):format(v)

                if (identifier:startsWith(prefix)) then
                    identifiers[v] = identifier:sub(#prefix + 1)
                end
            end
        end

        identifiers.citizen = self:generateCitizenId(identifiers[__PRIMARY__:lower()])

        return identifiers
    end

    for k, v in pairs(identifiers) do
		if (k == 'ip') then
			identifiers[k] = '127.0.0.1'
		elseif (k == 'citizen') then
			identifiers[k] = 'system'
		else
			identifiers[k] = 'console'
		end
	end

    return identifiers
end

function players:getPlayerTokens(source)
    source = ensure(source, -1)

    if (source <= 0) then return {} end
    
    local tokens = {}
    local nums = GetNumPlayerTokens(source)

    for i = 0, (nums - 1) do
        local playerTokens = ensure(GetPlayerToken(source, i), '0:unknown')
        local prefix = ensure(playerTokens:sub(1, 1), 0)
        local suffix = ensure(playerTokens:sub(3), 'unknown')

        if (suffix ~= 'unknown') then
            if (tokens[prefix] == nil) then tokens[prefix] = {} end

            table.insert(tokens[prefix], suffix)
        end
    end

    return tokens
end

function players:generateCitizenId(identifier)
    identifier = ensure(identifier, 'unknown')
    
    if (identifier == 'unknown') then return 'unknown' end
	if (identifier == 'console') then return 'system' end

	if (__PRIMARY__ == 'steam' or __PRIMARY__ == 'license' or __PRIMARY__ == 'license2') then
		local rawPrefix = tonumber(identifier, 16)
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	elseif (__PRIMARY__ == 'xbl' or __PRIMARY__ == 'live' or __PRIMARY__ == 'discord' or __PRIMARY__ == 'fivem') then
		local rawPrefix = tonumber(identifier)
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	elseif (__PRIMARY__ == 'ip') then
		local rawPrefix = tonumber(identifier:gsub('[.]', ''))
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	end

	return 'unknown'
end

events:on('playerDropped', function(player)
    if (player == nil or player.source == nil or player.source > 65535 or data[player.source] == nil) then
        return
    end

    local src = ensure(player.source, 0)
    local identifier = ensure(player.identifier, 'unknown')
    local key = ('players:%s'):format(identifier)

    data[src]:save()
    data[src] = nil

    player.source = nil

    cache:setProp(key, 'source', nil)
end)

--- Load `console` as player
players:load(0)

--- Register `players` as module
register('players', players)

--- Interval Time
local saveInterval = ensure(ensure(config('general'), {}).saveInterval, 60 * 1000)

--- Execute this func every x time to save all players to the database
local StartDBSync = function()
    function savePlayers()
        for _, player in pairs(data) do
            if (player ~= nil and player.source ~= nil and player.source > 1 and player.source <= 65535) then
                player:save()
            end
        end

        SetTimeout(saveInterval, savePlayers)
    end

    SetTimeout(saveInterval, savePlayers)
end

--- Trigger func to start timeout and auto save
StartDBSync()