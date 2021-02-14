m('events')

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