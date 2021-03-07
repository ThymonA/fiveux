using 'presentCard'
using 'db'
using 'sqlquery'
using 'players'
using 'ratelimit'

local whitelistedIps = nil

AddEventHandler('playerConnecting', function(_, _, deferrals)
    deferrals.defer()

    local playerSrc = ensure(source, 0)
    local card = presentCard:create(deferrals)
    local player = players:load(playerSrc)

    if (player == nil or player.identifier == nil) then
        local message = T(('identifier_%s_required'):format(__PRIMARY__:lower()))

        deferrals.done(serverMessage(message))
        return
    end

    local registered_events = events:getEventRegistered('playerConnecting')
    local query, params = sqlquery.events:select(player.identifiers)
    local identifierCount = db:fetchScalar(query, params)

    identifierCount = ensure(identifierCount, 0)

    if (identifierCount == 0) then
        db:insert([[
            INSERT INTO `identifiers` (`steam`, `license`, `license2`, `xbl`, `live`, `discord`, `fivem`)
            VALUES (:steam, :license, :license2, :xbl, :live, :discord, :fivem)
        ]], {
            ['steam'] = player.identifiers.steam,
            ['license'] = player.identifiers.license,
            ['license2'] = player.identifiers.license2,
            ['xbl'] = player.identifiers.xbl,
            ['live'] = player.identifiers.live,
            ['discord'] = player.identifiers.discord,
            ['fivem'] = player.identifiers.fivem
        })
    end

    local cfg = config('general')
    local vpnEnabled = ensure(cfg.vpnEnabled, true)
    local dateTimeFormat = ensure(cfg.dateTimeFormat, '%Y-%m-%d %H:%M:%S')
    local allowedCountries = ensure(cfg.allowedCountries, {})

    if (vpnEnabled) then
        local allowedToConnect = false
        local playerIP = ensure(player.identifiers.ip, '127.0.0.1')

        whitelistedIps = ensure(whitelistedIps or readData('whitelist_ips.json'), {})

        for k, whitelistedIp in pairs(whitelistedIps) do
            if (whitelistedIp == playerIP) then
                allowedToConnect = true
            end
        end

        if (not allowedToConnect) then
            local code, country = getIPHubInfo(playerIP)

            if (code == 1) then
                local message = T('connecting_vpn_block', playerIP, country)

                deferrals.done(serverMessage(message))
				return
            end

            if (not any(country, allowedCountries, 'value')) then
                local message = T('connecting_country_block', playerIP, country)

                deferrals.done(serverMessage(message))
				return
            end
        end
    end

    if (player.banned) then
        local banInfo = ensure(player.banInfo, {})
        local reason = ensure(banInfo.reason, T('default_ban_reason'))
        local expire = ensure(banInfo.expire, T('unknown'))
        local now = os ~= nil and os.time() or 0
        local expireTime = dateTimeToTime(expire)
        local expireFormatted = os.date(dateTimeFormat, expireTime)
        local remain, label = timeToString(expireTime - now)
        local remainLabel = boldText(('%s %s'):format(remain, T(label)))
        local message = T('connecting_banned', reason, expireFormatted, remainLabel, player.citizen)

        deferrals.done(serverMessage(message))
        return
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

AddEventHandler('playerDropped', function(reason)
    reason = ensure(reason, '')

    local playerSrc = ensure(source, 0)
    local player = players:get(playerSrc)

    if (player == nil or player.identifier == nil) then
        return
    end

    local registered_events = events:getEventRegistered('playerDropped')

    if (#registered_events <= 0) then
        return
    end

    for k, v in pairs(registered_events) do
        local func = ensure(v, function() end)
        local ok = xpcall(func, print_error, player, reason)

        repeat Citizen.Wait(0) until ok ~= nil
    end
end)

ratelimit:registerNet('playerJoining', function()
    local playerSrc = ensure(source, 0)
    local player = players:load(playerSrc)

    if (player == nil or player.identifier == nil) then
        return
    end

    local registered_events = events:getEventRegistered('playerJoining')

    if (#registered_events <= 0) then
        return
    end

    for k, v in pairs(registered_events) do
        local func = ensure(v, function() end)
        local ok = xpcall(func, print_error, player)

        repeat Citizen.Wait(0) until ok ~= nil
    end
end, 0, 1)

RegisterPublicNet('playerJoined', function()
    local playerSrc = ensure(source, 0)
    local player = players:load(playerSrc)

    if (player == nil or player.identifier == nil) then
        return
    end

    local registered_events = events:getEventRegistered('playerJoined')

    if (#registered_events <= 0) then
        return
    end

    for k, v in pairs(registered_events) do
        local func = ensure(v, function() end)
        local ok = xpcall(func, print_error, player)

        repeat Citizen.Wait(0) until ok ~= nil
    end
end, 0, 0)

RegisterPublicNet('player:spawned', function(position)
    local playerSrc = ensure(source, 0)
    local player = players:get(playerSrc)

    if (player == nil or player.identifier == nil) then
        return
    end

    local registered_events = events:getEventRegistered('playerSpawned')

    if (#registered_events <= 0) then
        return
    end

    local playerPed = GetPlayerPed(playerSrc)

    for k, v in pairs(registered_events) do
        local func = ensure(v, function() end)
        local ok = xpcall(func, print_error, player, playerPed, position)

        repeat Citizen.Wait(0) until ok ~= nil
    end
end)