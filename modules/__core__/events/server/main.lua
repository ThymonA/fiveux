m('presentCard')

AddEventHandler('playerConnecting', function(player, _, _, deferrals)
    deferrals.defer()

    if (player == nil or player.identifier == nil) then
        deferrals.done(_('identifier_%s_required'):format(__PRIMARY__))
        return
    end

    local registered_events = events:getEventRegistered('playerConnecting')
    local card = presentCard:init(deferrals)

    card:update()

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
            rejectMessage = rejectMessage or _('connecting_error')
        end

        if (not canConnect) then
            deferrals.done(rejectMessage)
            return
        end
    end

    deferrals.done()
end)