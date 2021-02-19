using 'db'
using 'bans'
using 'wallets'

local data = {}

players = {}

function players:load(source)
    source = ensure(source, -1)

    if (source < 0) then return nil end

    local player
    local identifier = self:getPrimaryIdentifier(source)
    local key = ('players:%s'):format(identifier)

    if (cache:exists(key)) then
        player = cache:read(key)
        player.source = source
        player.identifiers = self:getPlayerIdentifiers(source)
        player.tokens = self:getPlayerTokens(source)
    else
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
            wallets = {}
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

            player.id = db:insert('INSERT INTO `players` (`citizen`, `name`, `job`, `grade`, `job2`, `grade2`) VALUES (:citizen, :name, :job, :grade, :job2, :grade2)', {
                ['citizen'] = player.citizen,
                ['name'] = player.name,
                ['job'] = jobName,
                ['grade'] = jobGrade,
                ['job2'] = jobName,
                ['grade2'] = jobGrade
            })

            player.job = { name = jobName, grade = jobGrade }
            player.job2 = { name = jobName, grade = jobGrade }

            print_success(T('player_created', player.name))
        else
            local dbPlayer = ensure(dbPlayers[1], {})

            player.id = ensure(dbPlayer.id, 0)
            player.job = { name = ensure(dbPlayer.job, 'unemployed'), grade = ensure(dbPlayer.grade, 'unemployed') }
            player.job2 = { name = ensure(dbPlayer.job2, 'unemployed'), grade = ensure(dbPlayer.grade2, 'unemployed') }
        end
    end

    player.banned, player.banInfo = bans:updateBanStatus(player.identifiers, player.name)
    player.wallets = wallets:getPlayerWallets(player.id)

    cache:write(key, player)

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

register('players', players)