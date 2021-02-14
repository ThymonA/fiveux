m('events')

events:on('playerConnecting', function(player, doneCallback, card)
    local logger = logging:create(player.source)

    if (logger == nil) then
        doneCallback(_('unknown_error'))
        return
    end

    logger:log({
        action = 'connection.connecting',
        color = constants.colors.blue,
        title = _('player_connecting_title'),
        message = _('player_connecting_message')
    })
    
    doneCallback()
end)