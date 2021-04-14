Citizen.CreateThread(function()
    while not PlayerJoined() do Citizen.Wait(0) end

    while true do
        Citizen.Wait(5000)

        local playerPed = PlayerPedId()
        local position = GetEntityCoords(playerPed)

        TriggerRemote('player:position', position)
    end
end)