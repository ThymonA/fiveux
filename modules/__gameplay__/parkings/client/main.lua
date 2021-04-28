import 'game'

--- Default values
local default_vector3 = vector3(0, 0, 0)
local default_vector4 = vector4(0, 0, 0, 0)

--- Local storage
local cfg = config('parkings')
local data = {}
local drawParkings = {}
local anyParkingClose = false
local anyParkingDrawed = false
local marker = nil

on('marker:enter', 'parking:spot', function(m)
    marker = m

    local addon = ensure(marker.addon, {})
    local parking = ensure(addon.parking, 'unknown')
    local index = ensure(addon.index, 0)
    local name = ensure(addon.name, 'unknown')
end)

on('marker:leave', 'parking:spot', function(m)
    marker = nil
end)

--- Search for parkings in range of player
Citizen.CreateThread(function()
    while true do
        drawParkings = {}
        anyParkingClose = false

        if (PlayerJoined()) then
            local playerPed = PlayerPedId()
            local currentPosition = GetEntityCoords(playerPed)

            for _, parking in pairs(data) do
                parking = ensure(parking, {})

                local id = ensure(parking.id, 0)
                local spots = ensure(parking.spots, {})

                for _, spot in pairs(spots) do
                    local name = ensure(spot.name, 'unknown')
                    local position = ensure(spot.position, default_vector3)
                    local rangeToShow = ensure(cfg.rangeToShow, 10.0)

                    if (#(position - currentPosition) <= rangeToShow) then
                        anyParkingClose = true
                        drawParkings[name] = spot
                    end
                end
            end
        end

        Citizen.Wait(500)
    end
end)

--- Draw all parkings from list `drawParkings`
Citizen.CreateThread(function()
    while true do
        anyParkingDrawed = false

        if (PlayerJoined()) then
            for _, parking in pairs(drawParkings) do
                local available = ensure(parking.available, true)

                if (not available) then
                    anyParkingDrawed = true
                    parking = ensure(parking, {})

                    local position = ensure(parking.position, default_vector4)
                    local searchCoords = ensure(parking.position, default_vector3)
                    local vehicle = ensure(parking.vehicle, {})
                    local model = ensure(vehicle.model, 'unknown')
                    local hash = GetHashKey(model)
                    local vehicleData = ensure(vehicle.vehicle, {})
                    local plate = ensure(vehicle.plate, 'XXXXXXX')
                    local entity, closestDistance = game:getClosestVehicle(searchCoords)

                    if (closestDistance < 1 and DoesEntityExist(entity)) then
                        local entityPlate = ensure(GetVehicleNumberPlateText(entity), 'XXXXXXX'):replace(' ', '-')
                        local entityHash = GetEntityModel(entity)

                        if (entityPlate ~= plate or entityHash ~= hash) then
                            game:deleteVehicle(entity)
                            entity = nil
                        end
                    else
                        entity = nil
                    end

                    print(encode(vehicleData))

                    if (entity == nil) then
                        entity = game:spawnLocalVehicle(model, searchCoords, position.w)

                        if (DoesEntityExist(entity)) then
                            vehicleData.plate = plate

                            game:setVehicleProperties(entity, vehicleData, true)

                            PlaceObjectOnGroundProperly(entity)
                            SetVehicleOnGroundProperly(entity)
                            FreezeEntityPosition(entity, true)
                            SetVehicleCanBeLockedOn(entity, false, false)
                            SetVehicleCanBeTargetted(entity, false)
                            SetVehicleCanBeVisiblyDamaged(entity, false)
                            SetVehicleCanLeakOil(entity, false)
                            SetVehicleCanLeakPetrol(entity, false)
                            SetVehicleDirtLevel(entity, 0)
                            SetVehicleDisableTowing(entity, true)
                            SetVehicleDoorsLocked(entity, 2)
                            SetVehicleDoorsLockedForAllPlayers(entity, true)
                            SetVehicleDoorsLockedForNonScriptPlayers(entity, true)
                            SetVehicleUndriveable(entity, true)
                        end
                    end
                end
            end
        end

        Citizen.Wait(250)
    end
end)

--- Update parking information
MarkEventAsGlobal('parkings:update')
RegisterEvent('parkings:update', function(parkings)
    data = ensure(parkings, {})
end)