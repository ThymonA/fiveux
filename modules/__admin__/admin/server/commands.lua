import 'commands'
import 'modules'
import 'players'
import 'jobs'
import 'vehicles'

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

--- Command to add money to wallet
---@example /add_job_wallet cash 5000
---@example /add_job_wallet bratva cash 5000
---@see /add_job_wallet {wallet} {amount}
---@see /add_job_wallet {job} {wallet} {amount}
commands:add('add_job_wallet', function(player, ...)
    local arguments = { ... }
    local targetJobName = 'unknown'
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetJob = player.job

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetJobName = ensure(arguments[1], targetJobName)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetJobName ~= targetJob.name) then
        targetJob = jobs:loadByName(targetJobName)
    end

    if (targetJob == nil) then return end

    targetJob:addWallet(targetWallet, targetAmount)
end)

--- Command to set balance of wallet
---@example /set_job_wallet cash 5000
---@example /set_job_wallet bratva cash 5000
---@see /set_job_wallet {wallet} {amount}
---@see /set_job_wallet {job} {wallet} {amount}
commands:add('set_job_wallet', function(player, ...)
    local arguments = { ... }
    local targetJobName = 'unknown'
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetJob = player.job

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetJobName = ensure(arguments[1], targetJobName)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetJobName ~= targetJob.name) then
        targetJob = jobs:loadByName(targetJobName)
    end

    if (targetJob == nil) then return end

    targetJob:setWallet(targetWallet, targetAmount)
end)

--- Command to remove balance from wallet
---@example /remove_job_wallet cash 5000
---@example /remove_job_wallet bratva cash 5000
---@see /remove_job_wallet {wallet} {amount}
---@see /remove_job_wallet {job} {wallet} {amount}
commands:add('remove_job_wallet', function(player, ...)
    local arguments = { ... }
    local targetJobName = 'unknown'
    local targetWallet = 'unknown'
    local targetAmount = 0
    local targetJob = player.job

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetWallet = ensure(arguments[1], targetWallet)
        targetAmount = ensure(arguments[2], targetAmount)
    elseif (#arguments >= 3) then
        targetJobName = ensure(arguments[1], targetJobName)
        targetWallet = ensure(arguments[2], targetWallet)
        targetAmount = ensure(arguments[3], targetAmount)
    end

    if (targetJobName ~= targetJob.name) then
        targetJob = jobs:loadByName(targetJobName)
    end

    if (targetJob == nil) then return end

    targetJob:removeWallet(targetWallet, targetAmount)
end)

--- Set primary job of player
---@example /setjob unemployed 0
---@example /setjob 1 unemployed 0
---@see /setjob {job} {grade}
---@see /setjob {source} {job} {grade}
commands:add('setjob', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local targetId = ensure(source, 0)
    local targetJob = 'unknown'
    local targetGrade = 0
    local targetPlayer = player

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetJob = ensure(arguments[1], targetJob)
        targetGrade = ensure(arguments[2], targetGrade)
    elseif (#arguments >= 3) then
        targetId = ensure(arguments[1], targetId)
        targetJob = ensure(arguments[2], targetJob)
        targetGrade = ensure(arguments[3], targetGrade)
    end

    if (targetId ~= source) then
        targetPlayer = players:loadBySource(targetId)
    end

    if (targetPlayer == nil) then return end

    targetPlayer:setJob(targetJob, targetGrade)
end)

--- Set secondary job of player
---@example /setjob2 unemployed 0
---@example /setjob2 1 unemployed 0
---@see /setjob2 {job} {grade}
---@see /setjob2 {source} {job} {grade}
commands:add('setjob2', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local targetId = ensure(source, 0)
    local targetJob = 'unknown'
    local targetGrade = 0
    local targetPlayer = player

    if (#arguments < 2) then return end

    if (#arguments == 2) then
        targetJob = ensure(arguments[1], targetJob)
        targetGrade = ensure(arguments[2], targetGrade)
    elseif (#arguments >= 3) then
        targetId = ensure(arguments[1], targetId)
        targetJob = ensure(arguments[2], targetJob)
        targetGrade = ensure(arguments[3], targetGrade)
    end

    if (targetId ~= source) then
        targetPlayer = players:loadBySource(targetId)
    end

    if (targetPlayer == nil) then return end

    targetPlayer:setJob2(targetJob, targetGrade)
end)

--- Add a vehicle to garage
---@example /addgarage
---@see /addgarage
commands:add('addgarage', function(player, ...)
    local arguments = { ... }
    local source = ensure(player:getSource(), 0)
    local vehicle, props = requestClientInfo('fiveux:admin:requestVehicle', source)
    local player = players:loadBySource(source)

    if (vehicle == nil or player == nil) then return end

    local vehicleCfg = config('vehicles')
    local vehicleHashes = ensure(vehicleCfg.vehicleHashes, {})

    if (vehicleHashes == nil or vehicleHashes[vehicle] == nil) then return end

    local model = ensure(vehicleHashes[vehicle], 'unknown')
    local veh = vehicles:add(player.fxid, model, props)
end)