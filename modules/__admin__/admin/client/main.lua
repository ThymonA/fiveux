import 'SendNUI'

MarkEventAsGlobal('fiveux:nui:reload')
RegisterEvent('fiveux:nui:reload', function(name)
    SendNUI({ action = 'reload_frame', name = name })
end)