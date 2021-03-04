using 'threads'

local hud_loaded = false
local playerData = {}
local cfg = config('general')
local serverName = ensure(cfg.serverName, 'FiveUX Framework')
local locale = ensure(cfg.locale, 'en-EN')

local function UpdatePlayerData(force)
    force = ensure(force, false)

    if (not hud_loaded and not force) then
        return
    end

    local job = ensure(playerData.job, {})
    local job2 = ensure(playerData.job2, {})
    local wallets = ensure(playerData.wallets, {})

    SendNUIMessage({
        action = 'INIT',
        job = {
            name = ensure(job.label, 'Unemployed'),
            grade = ensure(job.grade_label, 'Unemployed'),
        },
        job2 = {
            name = ensure(job2.label, 'Unemployed'),
            grade = ensure(job2.grade_label, 'Unemployed'),
        },
        name = serverName,
        locale = locale,
        cash = ensure(wallets['cash'], 0),
        crime = ensure(wallets['crime'], 0)
    })
end

RegisterNUICallback('mounted', function(info, cb)
    info = ensure(info, {})
    cb = ensure(cb, function() end)

    UpdatePlayerData(true)

    hud_loaded = true

    cb('ok')
end)

threads:addTask(function()
    if (hud_loaded) then
        local playerPed = PlayerPedId()

        SendNUIMessage({
            action = 'UPDATE_STATS',
            updates = {
                health = round(GetEntityHealth(playerPed) - 100),
                armor = round(GetPedArmour(playerPed))
            }
        })
    end
end, 25)

RegisterPublicNet('update:playerData', function(data)
    playerData = ensure(data, {})

    UpdatePlayerData()
end)

RegisterPublicNet('update:job', function(job)
    playerData.job = job

    SendNUIMessage({
        action = 'UPDATE_JOB',
        name = ensure(job.label, 'Unemployed'),
        grade = ensure(job.grade_label, 'Unemployed')
    })
end)

RegisterPublicNet('update:job2', function(job2)
    playerData.job2 = job2

    SendNUIMessage({
        action = 'UPDATE_JOB2',
        name = ensure(job2.label, 'Unemployed'),
        grade = ensure(job2.grade_label, 'Unemployed')
    })
end)

RegisterPublicNet('update:group', function(group)
    playerData.group = group
end)

RegisterPublicNet('update:wallet', function(name, balance)
    name = ensure(name, 'unknown')
    balance = ensure(balance, 0)

    if (playerData.wallets and playerData.wallets[name]) then
        playerData.wallets[name] = balance

        SendNUIMessage({
            action = 'UPDATE_WALLET',
            name = name,
            balance = balance
        })
    end
end)