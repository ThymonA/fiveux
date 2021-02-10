local data = {}

players = {}

function players:load(source)
    source = ensure(source, -1)

    if (source < 0) then return nil end

    local cfg = config:load('general')
    local key = ('players:source:%s'):format(source)

    if (cache:exists(key)) then
        return cache:read(key)
    end

    local player = {
        source = source,
        name = ensure(GetPlayerName(source), 'Unknown'),
        identifier = self:getPrimaryIdentifier(source),
        identifiers = self:getPlayerIdentifiers(source),
        tokens = self:getPlayerTokens(source)
    }

    cache:write(key, player)

    return player
end

function players:getPrimaryIdentifier(source)
    source = ensure(source, -1)

    if (source < 0) then return nil end
    if (source == 0) then return 'console' end

    local num = GetNumPlayerIdentifiers(source)

    for i = 0, (num - 1), 1 do
        local identifier = ensure(GetPlayerIdentifier(source, i), 'none')

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
        ip = nil
    }

    if (source < 0) then return identifiers end

    if (source > 0) then
        local num = GetNumPlayerIdentifiers(source)

        for i = 0, (num - 1), 1 do
            local identifier = ensure(GetPlayerIdentifier(source, i), 'none')

            for k, v in pairs(constants.identifierTypes) do
                if (identifier:startsWith(('%s:'):format(v))) then
                    identifiers[v] = identifier:sub(#v + 2)
                end
            end
        end

        return identifiers
    end

    for k, v in pairs(identifiers) do
        identifiers[k] = 'console'
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

register('players', players)