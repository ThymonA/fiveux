RegisterNUICallback('mounted', function(info, cb)
    info = ensure(info, {})
    cb = ensure(cb, function() end)

    local cfg = config('general')
    local serverName = ensure(cfg.serverName, 'FiveUX Framework')
    local locale = ensure(cfg.locale, 'en-EN')

    SendNUIMessage({
        action = 'INIT',
        job = {
            name = 'UWV',
            grade = 'Werkloos'
        },
        job2 = {
            name = 'UWV',
            grade = 'Werkloos'
        },
        name = serverName,
        locale = locale,
        cash = 500000,
        crime = 10000
    })

    cb('ok')
end)