local generalCfg = config('general')
local garageCfg = config('garage')
local serverName = ensure(generalCfg.serverName, 'FiveUX')
local menuColor = ensure(garageCfg.rgb, vec(255, 0, 0))
local garageMenu = MenuV:CreateMenu(T('garage_title'), T('garage_subtitle', serverName), 'topleft', menuColor.x, menuColor.y, menuColor.z, 'size-125', 'default', 'menuv', 'garage_menu')

RegisterLocalEvent('marker:garage_spawn:enter', function(marker)
    local data = ensure(get('marker_addon_data'), {})
    local vehicleType = ensure(data.type, 'car')
    local spawnLocation = ensure(data.location, vec(0, 0, 0), true)

    if (spawnLocation == nil) then
        return
    end

    garageMenu:Open()
end)

RegisterLocalEvent('marker:garage_spawn:leave', function(marker)
    garageMenu:Close()
end)