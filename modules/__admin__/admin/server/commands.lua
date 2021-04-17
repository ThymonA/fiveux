import 'commands'
import 'modules'

--- Command to spawn vehicles on player location
---@example /car adder
---@see /car {vehicle}
commands:add('car', function(player, vehicle)
    vehicle = ensureHash(vehicle)

    local source = ensure(player:getSource(), 0)

    if (source > 0) then
        local playerPed = GetPlayerPed(source)
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local vehicle = CreateVehicle(vehicle, coords.x, coords.y, coords.z, heading, true, false)

        if (vehicle == nil) then return end

        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    end
end)

--- Command to delete vehicles of player
---@example /dv
---@see /dv
commands:add('dv', function(player)
    local source = ensure(player:getSource(), 0)

    if (source > 0) then
        local playerPed = GetPlayerPed(source)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if (vehicle ~= nil) then
            DeleteEntity(vehicle)
        end
    end
end)

--- Command to add money to wallet
---@example /add_wallet cash 5000
---@example /add_wallet 1 cash 5000
---@see /add_wallet {wallet} {amount}
---@see /add_wallet {source} {wallet} {amount}
commands:add('add_wallet', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local targetId = ensure(source, 0)
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetPlayer = player

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetId = ensure(arguments[1], targetId)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetId ~= source) then
        targetPlayer = players:loadBySource(targetId)
    end

    if (targetPlayer == nil) then return end

    targetPlayer:addWallet(targetWallet, targetAmount)
end)

--- Command to set balance of wallet
---@example /set_wallet cash 5000
---@example /set_wallet 1 cash 5000
---@see /set_wallet {wallet} {amount}
---@see /set_wallet {source} {wallet} {amount}
commands:add('set_wallet', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local targetId = ensure(source, 0)
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetPlayer = player

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetId = ensure(arguments[1], targetId)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetId ~= source) then
        targetPlayer = players:loadBySource(targetId)
    end

    if (targetPlayer == nil) then return end

    targetPlayer:setWallet(targetWallet, targetAmount)
end)

--- Command to remove balance from wallet
---@example /remove_wallet cash 5000
---@example /remove_wallet 1 cash 5000
---@see /remove_wallet {wallet} {amount}
---@see /remove_wallet {source} {wallet} {amount}
commands:add('remove_wallet', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local targetId = ensure(source, 0)
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetPlayer = player

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetId = ensure(arguments[1], targetId)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetId ~= source) then
        targetPlayer = players:loadBySource(targetId)
    end

    if (targetPlayer == nil) then return end

    targetPlayer:removeWallet(targetWallet, targetAmount)
end)

--- Reload NUI
---@example /reload_nui ui wheel
---@see /reload_nui {category} {module}
commands:add('reload_nui', function(player, category, module)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')

    for _, module in pairs(modules) do
        if (module.category == category and module.name == module) then
            local key = ('%s:%s:%s'):format(module.category, module.name, module.ui_page)

            TriggerRemote('fiveux:nui:reload', key)
        end
    end
end)