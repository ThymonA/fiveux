import 'SendNUI'
import 'game'

RegisterClientCallback('fiveux:admin:requestVehicle', function(callback)
    callback = ensure(callback, function() end)

    local playerPed = PlayerPedId()
    local vehicle = nil
    local data = {}
    
    if (IsPedInAnyVehicle(playerPed, false)) then
        vehicle = GetVehiclePedIsIn(playerPed, false)

        if (DoesEntityExist(vehicle)) then
            data = game:getVehicleProperties(vehicle, true, true, true, true)
        end
    end

    callback(vehicle ~= nil and GetEntityModel(vehicle) or nil, data)
end)