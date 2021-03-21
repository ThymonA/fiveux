using 'threads'

local ui_mounted, ui_loaded, player_loaded = false, false, false
local cfg = config('general')
local language = ensure(cfg.language, 'en')
local locale = ensure(cfg.locale, 'en-EN')

RegisterNUICallback('mounted', function(info, cb)
    info = ensure(info, {})
    cb = ensure(cb, function() end)

    ui_mounted = true

    cb('ok')
end)

RegisterNUICallback('loaded', function(info, cb)
    info = ensure(info, {})
    cb = ensure(cb, function() end)

    ui_loaded = true

    cb('ok')
end)

threads:addTask(function()
    if (ui_loaded) then return end

    while not ui_mounted do Citizen.Wait(0) end
    while not player_loaded do Citizen.Wait(0) end

    
end)

RegisterLocalEvent('update:player', function(data)
    player_loaded = true
end)