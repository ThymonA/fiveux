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
        inventory = object:convert('location', ensure(player.locations, {}).inventory)
    }

    TriggerNet('update:playerData', player.source, playerData)
end)

events:on('playerSpawned', function(player, ped, position)
    local inventory = ensure(ensure(player.locations, {}).inventory, {})
    local weapons = ensure(inventory.weapons, {})

    for _, weapon in pairs(weapons) do
        GiveWeaponToPed(ped, weapon.hash, weapon.bullets, false, false)

        local attachments = ensure(weapon.attachments, {})
        local components = ensure(weapon.components, {})

        for _, attachment in pairs(attachments) do
            for _, component in pairs(components) do
                if (component.name == attachment) then
                    GiveWeaponComponentToPed(ped, weapon.hash, component.hash)
                end
            end
        end
    end
end)

ratelimit:registerNet('players:position', function(src, position)
    src = ensure(src, 0)
    position = ensure(position, vec(-206.79, -1015.12, 29.14))

    local player = players:get(src)

    if (player ~= nil) then
        player.position = position
    end
end, 250, 0)