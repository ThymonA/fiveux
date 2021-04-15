import 'streaming'

--- Default values
local default_vector3 = vec(0, 0, 0)

---@class game
game = {}

--- Spawn vehicle (async)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@param callback function Callback to execute
function game:spawnVehicleAsync(model, coords, heading, callback)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)
    callback = ensure(callback, function() end)

    Citizen.CreateThread(function()
        if (streaming:requestModel(model)) then
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z + 1.0, heading, true, false)

            SetVehicleNeedsToBeHotwired(vehicle, false)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleIsStolen(vehicle, false)
            SetVehicleIsWanted(vehicle, false)
            SetVehRadioStation(vehicle, 'OFF')

            callback(vehicle)
        else
            callback(nil)
        end
    end)
end

--- Spawn vehicle (sync)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@return number|nil Vehicle entity
function game:spawnVehicle(model, coords, heading)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)

    local veh, finished = nil, false

    self:spawnVehicleAsync(model, coords, heading, function(vehicle)
        veh = vehicle
        finished = true
    end)

    repeat Citizen.Wait(0) until finished == true

    return veh
end

--- Delete given vehicle
---@param entity any Vehicle entity to delete
function game:deleteVehicle(entity)
    SetEntityAsMissionEntity(entity, false, true)
    DeleteVehicle(entity)
end

--- Request control of entity (async)
---@param entity any Entity to get control of
---@param attempts number Number of attempts, default: 0
---@param callback function Callback to execute
function game:requestControlOfEntityAsync(entity, attempts, callback)
    attempts = ensure(attempts, 0)
    callback = ensure(callback, function() end)

    Citizen.CreateThread(function()
        local attempt = 0

        while not NetworkHasControlOfEntity(entity) and (attempts == 0 or attempt < attempts) and DoesEntityExist(entity) do
            attempt = attempt + 1
            NetworkRequestControlOfEntity(entity)
            Citizen.Wait(50)
        end

        if (DoesEntityExist(entity) and NetworkHasControlOfEntity(entity)) then
            callback(true)
        else
            callback(false)
        end
    end)
end

--- Request control of entity (sync)
---@param entity any Entity to get control of
---@param attempts number Number of attempts, default: 0
---@return boolean Has control of entity
function game:requestControlOfEntity(entity, attempts)
    attempts = ensure(attempts, 0)

    local res, finished = nil, false

    self:requestControlOfEntityAsync(entity, attempts, function(result)
        res = result
        finished = true
    end)

    repeat Citizen.Wait(0) until finished == true

    return res
end

--- Export game
export('game', game)