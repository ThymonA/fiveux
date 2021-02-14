m('presentCard')
m('db')

local function generateSelectQuery(player)
    local queryParams = {}
    local selectQuery = 'SELECT COUNT(*) FROM `identifiers` WHERE'

    if (player.identifiers.steam) then
        queryParams['steam'] = player.identifiers.steam
        selectQuery = ('%s `steam` = :steam AND'):format(selectQuery)
    else
        selectQuery = ('%s `steam` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.license) then
        queryParams['license'] = player.identifiers.license
        selectQuery = ('%s `license` = :license AND'):format(selectQuery)
    else
        selectQuery = ('%s `license` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.license2) then
        queryParams['license2'] = player.identifiers.license2
        selectQuery = ('%s `license2` = :license2 AND'):format(selectQuery)
    else
        selectQuery = ('%s `license2` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.xbl) then
        queryParams['xbl'] = player.identifiers.xbl
        selectQuery = ('%s `xbl` = :xbl AND'):format(selectQuery)
    else
        selectQuery = ('%s `xbl` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.live) then
        queryParams['live'] = player.identifiers.live
        selectQuery = ('%s `live` = :live AND'):format(selectQuery)
    else
        selectQuery = ('%s `live` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.discord) then
        queryParams['discord'] = player.identifiers.discord
        selectQuery = ('%s `discord` = :discord AND'):format(selectQuery)
    else
        selectQuery = ('%s `discord` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.fivem) then
        queryParams['fivem'] = player.identifiers.fivem
        selectQuery = ('%s `fivem` = :fivem AND'):format(selectQuery)
    else
        selectQuery = ('%s `fivem` IS NULL AND'):format(selectQuery)
    end

    if (player.identifiers.ip) then
        queryParams['ip'] = player.identifiers.ip
        selectQuery = ('%s `ip` = :ip'):format(selectQuery)
    else
        selectQuery = ('%s `ip` IS NULL'):format(selectQuery)
    end

    return selectQuery, queryParams
end

AddEventHandler('playerConnecting', function(player, _, _, deferrals)
    deferrals.defer()

    if (player == nil or player.identifier == nil) then
        deferrals.done(T(('identifier_%s_required'):format(__PRIMARY__:lower())))
        return
    end

    local registered_events = events:getEventRegistered('playerConnecting')
    local card = presentCard:init(deferrals)

    card:update()

    local query, params = generateSelectQuery(player)
    local identifierCount = db:fetchScalar(query, params)

    identifierCount = ensure(identifierCount, 0)

    if (identifierCount == 0) then
        db:insert([[
            INSERT INTO `identifiers` (`steam`, `license`, `license2`, `xbl`, `live`, `discord`, `fivem`, `ip`)
            VALUES (:steam, :license, :license2, :xbl, :live, :discord, :fivem, :ip)
        ]], {
            ['steam'] = player.identifiers.steam,
            ['license'] = player.identifiers.license,
            ['license2'] = player.identifiers.license2,
            ['xbl'] = player.identifiers.xbl,
            ['live'] = player.identifiers.live,
            ['discord'] = player.identifiers.discord,
            ['fivem'] = player.identifiers.fivem,
            ['ip'] = player.identifiers.ip
        })
    end

    if (#registered_events <= 0) then
        deferrals.done()
        return
    end

    for k, v in pairs(registered_events) do
        local continue, canConnect, rejectMessage = false, false, nil

        card:reset()

        local func = ensure(v, function(_, done, _) done() end)
        local ok = xpcall(func, print_error, player, function(msg)
            msg = ensure(msg, '')
            canConnect = ensure(msg == '', false)

            if (not canConnect) then
                rejectMessage = msg
            end

            continue = true
        end, card)

        repeat Citizen.Wait(0) until continue == true

        if (not ok) then
            canConnect = false
            rejectMessage = rejectMessage or T('connecting_error')
        end

        if (not canConnect) then
            deferrals.done(rejectMessage)
            return
        end
    end

    deferrals.done()
end)