using 'events'

events:on('playerConnecting', function(player, doneCallback, card)
    local logger = logging:create(player.source)

    if (logger == nil) then
        doneCallback(T('unknown_error'))
        return
    end

    logger:log({
        action = 'connection.connecting',
        color = constants.colors.blue,
        title = T('player_connecting_title'),
        message = T('player_connecting_message')
    })
    
    doneCallback()
end)

events:on('playerJoined', function(player)
    local logger = logging:get(player)

    if (logger == nil) then
        return
    end

    logger:log({
        action = 'connection.connected',
        color = constants.colors.green,
        title = T('player_joined_title'),
        message = T('player_joined_message'),
        arguments = { source = player.source }
    })
end)

events:on('playerDropped', function(player, reason)
    local logger = logging:get(player)

    if (logger == nil) then
        return
    end

    logger:log({
        action = 'connection.disconnected',
        color = constants.colors.red,
        title = T('player_disconnect_title'),
        message = T('player_disconnect_message', reason),
        arguments = { reason = reason }
    })
end)

--- Create a `console` logging object
logging:create(0)