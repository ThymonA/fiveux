Citizen.CreateThread(function()
    while true do
        if (NetworkIsPlayerActive(PlayerId())) then
            TriggerNet('playerJoined')
            return
        end
    end
end)