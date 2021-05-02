--- Default values
local default_vector3 = vec(0, 0, 0)

---@class game_server
game = {}

--- Spawn vehicle (sync)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@return number|nil Vehicle entity
function game:spawnVehicle(model, coords, heading)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)

    if (vehicle == nil) then return nil end

    while not DoesEntityExist(vehicle) do Citizen.Wait(0) end

    return vehicle
end

--- Export game
export('game', game)