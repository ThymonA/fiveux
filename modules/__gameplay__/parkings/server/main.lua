import 'db'

--- Default values
local default_vector4 = vector4(0, 0, 0, 0)

--- Delete vehicles when not owned by player
db:execute('DELETE FROM `vehicles` WHERE `fxid` IS NULL')

--- Local storage
---@type table<string, parking>
local data = {}
local parkingCfgs = config('parkings')
local dbParkings = db:fetchAll('SELECT * FROM `parkings`')

---@class parkings
parkings = {}

--- Load all parkings
for name, info in pairs(parkingCfgs) do
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
        spots = {}
    }

    local index = 0

    for _, spot in pairs(spots) do
        index = index + 1

        local key = index < 10 and ('00%s'):format(index) or index < 100 and ('0%s'):format(index) or ('%s'):format(index)
        local spotName = ('%s_%s'):format(name, key)
        local position = ensure(spot, default_vector4)
        local available = false
        local model = 'unknown'
        local vehicle = {}
        local owner = 'unknown'

        parking.spots[spotName] = {
            name = spotName,
            index = index,
            key = key,
            position = position,
            available = available,
            model = model,
            vehicle = vehicle,
            owner = owner
        }
    end

    data[parking.name] = parking
end