using 'db'
using 'bans'
using 'wallets'
using 'jobs'
using 'locations'
using 'events'
using 'threads'
using 'items'

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
    local defaultSpawn = ensure(cfg.defaultSpawn, vector3(-206.79, -1015.12, 29.14))
    local defaultGroup = ensure(cfg.defaultGroup, 'user')

    if (cache:exists(key)) then
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
            locations = {}
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
    end

    player.banned, player.banInfo = bans:updateBanStatus(player.identifiers, player.name)

    cache:write(key, player)

    function player:save()
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
            ['position'] = encode(ensure(self.position, vector3(-206.79, -1015.12, 29.14))),
            ['id'] = playerId
        })

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

        print_success(T('player_saved', ensure(self.name, 'Unknown')))
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

    data[player.source]:save()
    data[player.source] = nil
end)

register('players', players)