import 'db'
import 'vehicles'
import 'markers'
import 'game'
import 'players'

--- Default values
local default_vector4 = vector4(0, 0, 0, 0)
local default_marker = markers:getDefaultStyle()
local default_marker_add = vector4(0, 0, 0.4, 0)

--- Delete vehicles when not owned by player
db:execute('DELETE FROM `vehicles` WHERE `fxid` IS NULL')

--- Local storage
---@type table<string, parking>
local data = {}
---@type table<string, table>
local plateParkings = {}
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
    local spawn = ensure(info.spawn, default_vector4)
    local spots = ensure(info.spots, {})

    ---@class parking
    local parking = {
        name = name,
        whitelist = whitelist,
        blacklist = blacklist,
        spawn = spawn,
        ---@type table<string, parkingSpot>
        spots = {}
    }

    function parking:save(spotName)
        spotName = ensure(spotName, 'unknown')

        self.spots = ensure(self.spots, {})

        if (spotName == 'unknown') then
            for spot, _ in pairs(self.spots) do
                self:save(spot)
            end

            return
        end

        if (self.spots[spotName] == nil) then return end

        ---@type parkingSpot
        local spot = ensure(self.spots[spotName], {})

        if (spot.vehicle == nil) then
            db:execute('UPDATE `parkings` SET `vehicle` = NULL, `parkedBy` = \'unknown\' WHERE `parking` = :parking AND `spot` = :spot LIMIT 1', {
                ['parking'] = self.name,
                ['spot'] = spot.index
            })
        else
            local vehicleId = ensure(spot.vehicle.id, 0)

            db:execute('UPDATE `parkings` SET `vehicle` = :vehicle, `parkedBy` = :parkedBy WHERE `parking` = :parking AND `spot` = :spot LIMIT 1', {
                ['vehicle'] = vehicleId,
                ['parkedBy'] = ensure(spot.parkedBy, 'unknown'),
                ['parking'] = ensure(self.name, 'unknown'),
                ['spot'] = ensure(spot.index, 0)
            })
        end
    end

    function parking:updateSpot(spotName)
        local parkingName = ensure(self.name, 'unknown')

        spotName = ensure(spotName, 'unknown')

        if (self.spots == nil) then self.spots = {} end
        if (self.spots[spotName] == nil) then return end

        ---@type parkingSpot
        local spot = ensure(self.spots[spotName], {})
        local available = ensure(spot.available, false)

        if (available and spot.marker == nil) then
            if (self.spots[spotName].vehicle ~= nil) then
                local vehicle = ensure(self.spots[spotName].vehicle, {})
                local plate = ensure(vehicle.plate, 'XXXXXXX')

                if (plateParkings == nil) then plateParkings = {} end
                if (plate ~= 'XXXXXXX' and plateParkings[plate] ~= nil) then
                    plateParkings[plate] = nil
                end
            end

            self.spots[spotName].vehicle = nil
            self.spots[spotName].marker = markers:add(
                'parking:spot',
                self.whitelist,
                self.blacklist,
                spot.position + default_marker_add,
                markerAvailable,
                { parking = name, index = spot.index, name = spotName })
        elseif (not available and spot.vehicle == nil) then
            if (self.spots[spotName].marker ~= nil) then
                self.spots[spotName].marker:remove()
                self.spots[spotName].marker = nil
            end

            local dbResult = db:fetchFirst('SELECT `vehicle` FROM `parkings` WHERE `parking` = :parking AND `spot` = :spot LIMIT 1', {
                ['parking'] = parkingName,
                ['spot'] = spot.index
            })
            local vehicleId = ensure(dbResult.vehicle, 0)
            local veh = vehicles:getById(vehicleId)

            plateParkings[veh.plate] = { parking = name, spot = spotName }

            self.spots[spotName].vehicle = veh
        end

        local vehicle = ensure(spot.vehicle, {})

        TriggerRemote('parkings:updateSpot', -1, parkingName, spotName, {
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
            parkedBy = spot.parkedBy,
            ownedBy = ensure(vehicle.fxid, 'unknown')
        })

        self:save(spotName)
    end

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
            parkingSpot.marker = markers:add(
                'parking:spot',
                whitelist,
                blacklist,
                parkingSpot.position + default_marker_add,
                markerAvailable,
                { parking = name, index = index, name = spotName })
        else
            local vehicleId = ensure(dbResult.vehicle, 0)
            local veh = vehicles:getById(vehicleId)

            plateParkings[veh.plate] = { parking = name, spot = spotName }

            parkingSpot.vehicle = veh
        end

        parking.spots[spotName] = parkingSpot
    end

    data[parking.name] = parking
end

MarkEventAsGlobal('parkings:spawnVehicle')
RegisterEvent('parkings:spawnVehicle', function(plate)
    local source = ensure(source, 0)

    plate = ensure(plate, 'XXXXXXX')

    if (plate == 'XXXXXXX') then return end

    if (plateParkings == nil) then plateParkings = {} end
    if (plateParkings[plate] == nil) then return end

    local info = ensure(plateParkings[plate], {})
    local parkingName = ensure(info.parking, 'unknown')
    local spotName = ensure(info.spot, 'unknown')

    if (parkingName == 'unknown' or spotName == 'unknown') then return end
    if (data[parkingName] == nil) then return end

    ---@type parking
    local parking = ensure(data[parkingName], {})

    if (parking.spots == nil or parking.spots[spotName] == nil) then return end

    ---@type parkingSpot
    local spot = ensure(parking.spots[spotName], {})

    if (spot.vehicle == nil) then return end

    ---@type vehicle
    local vehicle = ensure(spot.vehicle, {})
    local spawn = ensure(parking.spawn, default_vector4)
    local parkedBy = ensure(spot.parkedBy, 'unknown')
    local vehicleOwner = ensure(vehicle.fxid, 'unknown')
    local player = players:loadBySource(source)

    if (player == nil) then return end
    if (player.fxid ~= parkedBy and player.fxid ~= vehicleOwner) then return end

    local veh = game:spawnVehicle(vehicle.model, spawn, spawn.w)

    if (veh == nil) then return end

    local playerPed = GetPlayerPed(source)

    data[parkingName].spots[spotName].available = true
    data[parkingName].spots[spotName].vehicle = nil
    plateParkings[plate] = nil

    parking:updateSpot(spotName)

    TaskWarpPedIntoVehicle(playerPed, veh, -1)

    local props = ensure(vehicle.vehicle, {})

    props.info = ensure(props.info, {})
    props.info.plate = plate

    TriggerRemote('parkings:setEntityProps', source, vehicle.model, veh, props)
end)

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
            spawn = parking.spawn,
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
                parkedBy = spot.parkedBy,
                ownedBy = ensure(vehicle.fxid, 'unknown')
            }
        end
    end

    TriggerRemote('parkings:update', playerSrc, results)
end

RegisterEvent('player:group:set', updateParkings)
RegisterEvent('player:job:set', updateParkings)
RegisterEvent('player:job2:set', updateParkings)

on('playerJoined', updateParkings)