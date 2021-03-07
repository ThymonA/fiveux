using 'weapons'

local playerData = {}
local loaded = false

RegisterPublicNet('update:playerData', function(data)
    if (weapons == nil) then using 'weapons' end

    local weapon_data = weapons:getInfo()

    playerData = ensure(data, {})
    playerData.inventory = ensure(playerData.inventory, {})

    local list = {}

    for name, data in pairs(playerData.inventory) do
        local weaponData = ensure(weapon_data[name], {})

        weaponData.uuid = ensure(data.uuid, 'unknown')
        weaponData.bullets = ensure(data.bullets, 0)
        weaponData.attachments = ensure(data.attachments, {})

        list[name] = weaponData
    end

    playerData.inventory.weapons = list

    loaded = true

    TriggerLocal('update:player', playerData)
end)

RegisterPublicNet('update:job', function(job)
    playerData.job = job

    TriggerLocal('update:player', playerData)
end)

RegisterPublicNet('update:job2', function(job2)
    playerData.job2 = job2

    TriggerLocal('update:player', playerData)
end)

RegisterPublicNet('update:group', function(group)
    playerData.group = group

    TriggerLocal('update:player', playerData)
end)

RegisterPublicNet('update:wallet', function(name, balance)
    if (playerData.wallets and playerData.wallets[name]) then
        playerData.wallets[name] = balance

        TriggerLocal('update:player', playerData)
    end
end)

register('player', function() return playerData end)