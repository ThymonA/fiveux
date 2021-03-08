using 'db'
using 'players'

garage = {}
vehicle_info = config('vehicles')
garage_config = config('garage')

local function parseResults(dbResults)
    dbResults = ensure(dbResults, {})

    local vehicles = {}

    for k, v in pairs(dbResults) do
        local vehicle = ensure(v, {})
        local vehicleId = ensure(vehicle.id, 0)
        local vehicleOwnerId = ensure(vehicle.player_id, 0)
        local vehicleOwner = players:getById(vehicleOwnerId)
        local vehiclePlate = ensure(vehicle.plate, 'unknown')
        local vehicleName = ensure(vehicle.spawnCode, 'unknown')
        local vehicleType = ensure(vehicle.type, 'unknown')
        local vehicleRaw = ensure(vehicle.vehicle, '[]')
        local vehicleData = json.decode(vehicleRaw)
        
        vehicles[vehiclePlate] = {
            id = vehicleId,
            playerId = vehicleOwnerId,
            player = vehicleOwner,
            plate = vehiclePlate,
            name = vehicleName,
            type = vehicleType,
            data = vehicleData
        }
    end

    return vehicles
end

function garage:getAllPlayerVehicles(playerId)
    playerId = ensure(playerId, 0)

    local dbResults = db:fetchAll("SELECT * FROM `player_vehicles` WHERE `player_id` = :id", {
        ['id'] = id
    })

    return parseResults(dbResults)
end

function garage:getPlayerVehiclesByType(playerId, vehicleType)
    playerId = ensure(playerId, 0)
    vehicleType = ensure(vehicleType, 'car')

    if (not any(vehicleType, constants.vehicleTypes, 'value')) then
        return {}
    end

    local dbResults = db:fetchAll("SELECT * FROM `player_vehicles` WHERE `player_id` = :id AND `type` = :type", {
        ['id'] = id,
        ['type'] = vehicleType
    })

    return parseResults(dbResults)
end

--- Register all markers from `configs/garage`
local registeredMarkers = {}
local styles = ensure(garage_config.styles, {})
local locations = ensure(garage_config.locations, {})

for name, data in pairs(locations) do
    name = ensure(name, 'unknown')
    name = ('garage_%s'):format(name)
    data = ensure(data, {})

    registeredMarkers[name] = {}

    local style = ensure(styles[ensure(data.garageType, 'car')], {})

    if (data.spawn ~= nil and data.location ~= nil) then
        local sName = ('%s_spawn'):format(name)
        local sStyle = ensure(style.spawn, {})

        registeredMarkers[name].spawn = marker(sName) {
            name = sName,
            event = 'garage_spawn',
            position = data.location,
            whitelist = data.whitelist,
            type = sStyle.type,
            rgba = sStyle.rgba,
            scale = sStyle.scale,
            rangeToShow = sStyle.rangeToShow,
            addon_data = {
                location = ensure(data.spawn, vec(0, 0, 0)),
                type = ensure(data.garageType, 'car')
            }
        }
    end

    if (data.delete ~= nil) then
        local dName = ('%s_delete'):format(name)
        local dStyle = ensure(style.delete, {})

        registeredMarkers[name].delete = marker(dName) {
            name = dName,
            event = 'garage_delete',
            position = data.delete,
            whitelist = data.whitelist,
            type = dStyle.type,
            rgba = dStyle.rgba,
            scale = dStyle.scale,
            rangeToShow = dStyle.rangeToShow,
            addon_data = {
                type = ensure(data.garageType, 'car')
            }
        }
    end
end