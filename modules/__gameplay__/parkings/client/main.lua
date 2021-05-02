import 'game'
import 'wheels'
import 'streaming'

--- Default values
local default_vector3 = vector3(0, 0, 0)
local default_vector4 = vector4(0, 0, 0, 0)

--- Local storage
local cfg = config('parkings')
local data = {}
local drawParkings = {}
local vehicleHistory = {}
local anyParkingClose = false
local anyParkingDrawed = false
local marker = nil
local closestVehicle = nil
local closestDistance = nil
local closestParking = nil
local closestSet = false
local currentVehicle = nil
local currentParking = nil
local currentCoords = nil
local eventVehicle = nil
local wheel = wheels:create()

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

            if (vehicleHistory == nil) then vehicleHistory = {} end

            for _, parking in pairs(data) do
                parking = ensure(parking, {})

                local id = ensure(parking.id, 0)
                local spots = ensure(parking.spots, {})

                for _, spot in pairs(spots) do
                    local spawn = ensure(parking.spawn, default_vector4)
                    local name = ensure(spot.name, 'unknown')
                    local position = ensure(spot.position, default_vector3)
                    local rangeToShow = ensure(cfg.rangeToShow, 10.0)

                    spot.spawn = spawn

                    if (#(position - currentPosition) <= rangeToShow) then
                        anyParkingClose = true
                        drawParkings[name] = spot

                        if (vehicleHistory[name] == nil) then
                            vehicleHistory[name] = {
                                entity = nil,
                                spawned = false
                            }
                        end
                    elseif (vehicleHistory[name] ~= nil and vehicleHistory[name].entity ~= nil) then
                        game:deleteVehicle(vehicleHistory[name].entity)
                        vehicleHistory[name].entity = nil
                        vehicleHistory[name].spawned = false
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
        closestSet = false

        if (PlayerJoined()) then
            local playerPed = PlayerPedId()
            local currentPosition = GetEntityCoords(playerPed)

            for _, parking in pairs(drawParkings) do
                local name = ensure(parking.name, 'unknown')
                local available = ensure(parking.available, true)

                if (not available) then
                    local history = ensure(vehicleHistory[name], {})
                    local spawned = ensure(history.spawned, false)
                    local position = ensure(parking.position, default_vector4)

                    anyParkingDrawed = true
                    parking = ensure(parking, {})

                    local searchCoords = ensure(parking.position, default_vector3)
                    local distance = #(searchCoords - currentPosition)

                    if (not spawned or not DoesEntityExist(history.entity)) then
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

                        if (entity == nil) then
                            entity = game:spawnLocalVehicle(model, searchCoords, position.w)

                            if (DoesEntityExist(entity)) then
                                vehicleData.info.plate = plate

                                game:setVehicleProperties(entity, vehicleData)

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
                            end
                        end

                        vehicleHistory[name] = {
                            entity = entity,
                            spawned = true
                        }
                    end

                    if (history ~= nil) then
                        SetVehicleEngineHealth(history.entity, 1000)
                        SetVehicleFixed(history.entity)
                        SetVehicleDirtLevel(history.entity, 0.0)
                        SetEntityCoords(history.entity, position.x, position.y, position.z)
                        SetEntityHeading(history.entity, position.w)
                        PlaceObjectOnGroundProperly(history.entity)
                        FreezeEntityPosition(history.entity, true)
                        StopEntityFire(history.entity)
                    end

                    if (closestVehicle == nil and history ~= nil) then
                        closestVehicle = history.entity
                        closestDistance = distance
                        closestParking = parking
                        closestSet = true
                    elseif (history ~= nil and distance < closestDistance) then
                        closestVehicle = history.entity
                        closestDistance = distance
                        closestParking = parking
                        closestSet = true
                    end
                end
            end
        end

        if (not closestSet) then
            closestVehicle = nil
            closestDistance = nil
        end

        Citizen.Wait(250)
    end
end)

local function onSelect(value, entity)
    entity = ensure(entity, 0)
    value = ensure(value, 'unknown')

    if (not DoesEntityExist(entity)) then return end

    if (value == 'take_vehicle') then
        local coords = ensure(currentCoords, default_vector4)
        local parking = ensure(currentParking, {})
        local vehicle = ensure(parking.vehicle, {})
        local plate = ensure(vehicle.plate, 'XXXXXXX')
        local spawn = ensure(parking.spawn, default_vector4)

        if (coords == default_vector4 or spawn == default_vector4) then return end

        TriggerRemote('parkings:spawnVehicle', plate)
    end
end

wheel:on('select', onSelect)

local function onRaycastHit(entity, coords)
    if (currentVehicle == nil or currentVehicle ~= entity) then return end

    local playerData = get('playerdata')
    local parking = ensure(currentParking, {})
    local parkedBy = ensure(parking.parkedBy, 'system')
    local ownedBy = ensure(parking.ownedBy, 'system')
    local fxid = ensure(playerData.fxid, 'unknown')

    if (fxid ~= parkedBy and fxid ~= ownedBy) then return end

    wheel:resetItems()
    wheel:resetParams()
    wheel:addParam(entity)
    wheel:addItem('take_vehicle', 'las', 'la-car')
    wheel:show(GetNuiCursorPosition())
end

--- Check if any parking is close
Citizen.CreateThread(function()
    while true do
        if (PlayerJoined()) then
            local playerData = get('playerdata')

            if (playerData ~= nil) then
                local fxid = ensure(playerData.fxid, 'unknown')
                local rangeToInteract = ensure(cfg.rangeToInteract, 5.0)

                if (closestDistance ~= nil and closestDistance <= rangeToInteract) then
                    local parking = ensure(closestParking, {})
                    local parkedBy = ensure(parking.parkedBy, 'system')
                    local ownedBy = ensure(parking.ownedBy, 'system')

                    if (ownedBy == fxid or parkedBy == fxid) then
                        currentVehicle = closestVehicle
                        currentParking = parking
                        currentCoords = ensure(parking.position, default_vector4)

                        onOnce('raycast:hit', closestVehicle, onRaycastHit)
                    end
                else
                    if (currentVehicle ~= nil) then
                        onRemove('raycast:hit')
                    end

                    currentVehicle = nil
                    currentParking = nil
                    currentCoords = nil
                end
            end
        end

        Citizen.Wait(100)
    end
end)

--- Update parking information
MarkEventAsGlobal('parkings:update')
RegisterEvent('parkings:update', function(parkings)
    data = ensure(parkings, {})
end)

MarkEventAsGlobal('parkings:updateSpot')
RegisterEvent('parkings:updateSpot', function(parkingName, spotName, info)
    parkingName = ensure(parkingName, 'unknown')
    spotName = ensure(spotName, 'unknown')
    info = ensure(info, {})

    if (parkingName == 'unknown' or spotName == 'unknown') then return end
    if (data == nil) then data = {} end
    if (data[parkingName] == nil or data[parkingName].spots == nil or data[parkingName].spots[spotName] == nil) then return end
    if (vehicleHistory == nil) then vehicleHistory = {} end
    if (vehicleHistory[spotName] ~= nil) then
        local history = ensure(vehicleHistory[spotName], {})
        local entity = ensure(history.entity, 0)

        if (entity ~= 0 and DoesEntityExist(entity)) then
            game:deleteVehicle(entity)
        end
    end

    drawParkings = {}
    data[parkingName].spots[spotName] = info
end)

MarkEventAsGlobal('parkings:setEntityProps')
RegisterEvent('parkings:setEntityProps', function(model, entity, props)
    model = ensure(model, 'unknown')
    entity = ensure(entity, 0)
    props = ensure(props, {})

    streaming:requestModel(model)

    if (entity == nil) then return end

    if (not DoesEntityExist(entity)) then
        local playerPed = PlayerPedId()

        while not IsPedInAnyVehicle(playerPed, false) do Citizen.Wait(0) end

        entity = GetVehiclePedIsIn(playerPed, false)
    end

    entity = ensure(entity, 0)

    if (entity > 0 and DoesEntityExist(entity)) then
        game:setVehicleProperties(entity, props)
    end
end)