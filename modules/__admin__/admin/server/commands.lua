import 'commands'

--- Command to spawn vehicles on player location
commands:add('car', { groups = { 'superadmin', 'admin' } }, {}, function(player, vehicle)
    vehicle = ensureHash(vehicle)

    local source = ensure(player:getSource(), 0)

    if (source > 0) then
        local playerPed = GetPlayerPed(source)
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local vehicle = CreateVehicle(vehicle, coords.x, coords.y, coords.z, heading, true, false)

        if (vehicle == nil) then return end

        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    end
end)

--- Command to delete vehicles of player
commands:add('dv', { groups = { 'superadmin', 'admin' } }, {}, function(player)
    local source = ensure(player:getSource(), 0)

    if (source > 0) then
        local playerPed = GetPlayerPed(source)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if (vehicle ~= nil) then
            DeleteEntity(vehicle)
        end
    end
end)