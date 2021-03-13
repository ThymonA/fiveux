using 'events'
using 'ratelimit'
using 'object'

events:on('playerJoined', function(player)
    local playerData = {
        source = ensure(player.source, 0),
        name = ensure(player.name, 'Unknown'),
        wallets = ensure(player.wallets, {}),
        items = ensure(player.items, {}),
        position = ensure(player.position, vec(-206.79, -1015.12, 29.14)),
        group = ensure(player.group, 'user'),
        job = object:convert('job', player.job),
        job2 = object:convert('job', player.job2),
        inventory = object:convert('location', ensure(player.locations, {}).inventory),
        needsToSpawn = ensure(player.needsToSpawn, false),
        weapons = object:convert('storage_weapons', ensure(player.locations, {}).inventory)
    }

    TriggerNet('update:playerData', player.source, playerData)
    
    players:setNeedsToSpawn(player.source, false)
end)

events:on('playerSpawned', function(player, ped, position)
    local inventory = ensure(ensure(player.locations, {}).inventory, {})
    local weapons = ensure(inventory.weapons, {})

    RemoveAllPedWeapons(ped, true)

    for _, weapon in pairs(weapons) do
        GiveWeaponToPed(ped, weapon.hash, 0, false, false)
        SetPedAmmo(ped, weapon.hash, weapon.bullets)

        local attachments = ensure(weapon.attachments, {})
        local components = ensure(weapon.components, {})

        for _, attachment in pairs(attachments) do
            for _, component in pairs(components) do
                if (component.name == attachment) then
                    GiveWeaponComponentToPed(ped, weapon.hash, component.hash)
                end
            end
        end

        weapon.loaded = true
    end

    players:setNeedsToSpawn(player.source, false)
end)

RegisterPublicNet('players:position', function(pos)
    local src = ensure(source, 0)
    local position = ensure(pos, vec(-206.79, -1015.12, 29.14))
    local player = players:get(src)

    if (player ~= nil) then
        player.position = position
    end
end)

RegisterPublicNet('players:ammo', function(bullets)
    local src = ensure(source, 0)
    local ammos = ensure(bullets, {})
    local player = players:get(src)

    if (player ~= nil) then
        local inventory = ensure(ensure(player.locations, {}).inventory, {})
        local weapons = ensure(inventory.weapons, {})

        for k, weapon in pairs(weapons) do
            local weapon_name = ensure(weapon.name, 'weapon_unknown')
            local weapon_ammo = ensure(weapon.bullets, 0)
            local weapon_loaded = ensure(weapon.loaded, false)

            if (weapon_loaded) then
                player.locations.inventory.weapons[k].bullets = ensure(ammos[weapon_name], weapon_ammo)
            end
        end
    end
end)