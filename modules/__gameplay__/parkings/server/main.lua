import 'db'
import 'vehicles'
import 'markers'

--- Default values
local default_vector4 = vector4(0, 0, 0, 0)
local default_marker = markers:getDefaultStyle()

--- Delete vehicles when not owned by player
db:execute('DELETE FROM `vehicles` WHERE `fxid` IS NULL')

--- Local storage
---@type table<string, parking>
local data = {}
local parkingCfgs = config('parkings')
local parkingLocations = ensure(parkingCfgs.parkings, {})
local parkingMarkers = ensure(parkingCfgs.markers, {})
local rawAvailableStyle = ensure(parkingMarkers.available, {})
local markerAvailable = {}

--- Make sure style has the right values
for key, default in pairs(default_marker) do
    markerAvailable[key] = ensure(rawAvailableStyle[key], default)
end

---@class parkings
parkings = {}

function parkings:getDBResults()
    local results = {}
    local dbResults = db:fetchAll('SELECT * FROM `parkings`')

    dbResults = ensure(dbResults, {})

    for _, dbResult in pairs(dbResults) do
        dbResult = ensure(dbResult, {})

        local vehicleId = ensure(dbResult.vehicle, 0)
        local parking = ensure(dbResult.parking, 'unknown')
        local spot = ensure(dbResult.spot, 0)
        local parkedBy = ensure(dbResult.parkedBy, 'system')

        if (results == nil) then results = {} end
        if (results[parking] == nil) then results[parking] = {} end
        
        results[parking][spot] = {
            vehicle = vehicleId,
            available = vehicleId <= 0,
            parking = parking,
            spot = spot,
            parkedBy = parkedBy
        }
    end

    return results
end

--- DbResults
local dbResults = parkings:getDBResults()

--- Load all parkings
for name, info in pairs(parkingLocations) do
    name = ensure(name, 'unknown')
    info = ensure(info, {})

    local whitelist = ensureWhitelist(info.whitelist)
    local blacklist = ensureWhitelist(info.blacklist)
    local spots = ensure(info.spots, {})

    ---@class parking
    local parking = {
        name = name,
        whitelist = whitelist,
        blacklist = blacklist,
        ---@type table<string, parkingSpot>
        spots = {}
    }

    local index = 0

    for _, spot in pairs(spots) do
        index = index + 1

        local dbResult = ensure(dbResults[name], {})[index]

        if (dbResult == nil) then
            db:execute('INSERT INTO `parkings` (`parking`, `spot`, `parkedBy`) VALUES (:parking, :spot, :parkedBy)', {
                ['parking'] = name,
                ['spot'] = index,
                ['parkedBy'] = 'unknown'
            })

            dbResult = {
                vehicle = 0,
                available = true,
                parking = name,
                spot = index,
                parkedBy = 'unknown'
            }
        end

        local key = index < 10 and ('00%s'):format(index) or index < 100 and ('0%s'):format(index) or ('%s'):format(index)
        local spotName = ('%s_%s'):format(name, key)
        local position = ensure(spot, default_vector4)
        local available = dbResult.available

        ---@class parkingSpot
        local parkingSpot = {
            name = spotName,
            index = index,
            key = key,
            position = position,
            available = available,
            parkedBy = dbResult.parkedBy,
            vehicle = nil,
            marker = nil
        }

        if (parkingSpot.available) then
            local add = vector4(0, 0, 0.4, 0)

            parkingSpot.marker = markers:add(
                'parking:spot',
                whitelist,
                blacklist,
                parkingSpot.position + add,
                markerAvailable,
                { parking = name, index = index, name = spotName })
        else
            local vehicleId = ensure(dbResult.vehicle, 0)
            
            parkingSpot.vehicle = vehicles:getById(vehicleId)
        end

        parking.spots[spotName] = parkingSpot
    end

    data[parking.name] = parking
end

local function updateParkings(player)
    local playerSrc = ensure(player:getSource(), 0)

    if (playerSrc <= 0) then return end

    local results = {}

    for id, parking in pairs(data) do
        results[id] = {
            id = id,
            name = parking.name,
            whitelist = parking.whitelist,
            blacklist = parking.blacklist,
            spots = {}
        }

        for name, spot in pairs(parking.spots) do
            local vehicle = ensure(spot.vehicle, {})

            results[id].spots[name] = {
                name = spot.name,
                index = spot.index,
                key = spot.key,
                position = spot.position,
                available = spot.available,
                vehicle = {
                    model = ensure(vehicle.model, 'unknown'),
                    vehicle = ensure(vehicle.vehicle, {}),
                    plate = ensure(vehicle.plate, 'XXXXXXX')
                },
                parkedBy = spot.parkedBy
            }
        end
    end

    TriggerRemote('parkings:update', playerSrc, results)
end

RegisterEvent('player:group:set', updateParkings)
RegisterEvent('player:job:set', updateParkings)
RegisterEvent('player:job2:set', updateParkings)

on('playerJoined', updateParkings)