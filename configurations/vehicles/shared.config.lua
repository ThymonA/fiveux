config.vehicles = {
    ['adder'] = {
    },
    ['eldorado68'] = {
    },
    ['apache58'] = {
    },
    ['fleet72'] = {
    },
    ['fleet78'] = {
    },
    ['fleet78low'] = {
    }
}

config.vehicleHashes = {}

for key, _ in pairs(config.vehicles) do
    local hash = GetHashKey(key)

    config.vehicleHashes[hash] = key
end