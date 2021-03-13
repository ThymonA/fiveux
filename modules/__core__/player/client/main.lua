using 'threads'

local weapons = {}

threads:addTask(function()
    TriggerNet('players:position', GetEntityCoords(PlayerPedId()))
end, 1000)

threads:addTask(function()
    local pedId = PlayerPedId()
    local data = get('player')
    local results = {}

    for k, v in pairs(weapons) do
        local name = ensure(v.name, 'weapon_unknown')
        local hash = ensure(v.hash, -1)
        local ammo = ensure(GetAmmoInPedWeapon(pedId, hash), 0)

        results[name] = ammo
    end

    TriggerNet('players:ammo', results)
end, 1000)

RegisterLocalEvent('update:player', function(data)
    local playerData = ensure(data, {})
    
    weapons = ensure(playerData.weapons, {})
end)