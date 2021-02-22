local ready = false
local data = {}
local callbacks = {}

ui = {}

function ui:onReady(cb)
    cb = ensure(cb, function() end)

    if (ready) then
        cb()
    else
        Citizen.CreateThread(function()
            repeat Citizen.Wait(0) until ready == true

            cb()
        end)
    end
end

function ui:create(category, module, file, visible)
    category = ensure(category, 'global')
    module = ensure(module, 'global')
    file = ensure(file, 'html/index.html')
    visible = ensure(visible, false)

    local url = ('nui://%s/modules/%s/%s/%s'):format(RESOURCE_NAME, category, module, file)
    local frame = {
        category = category,
        module = module,
        file = file,
        url = url
    }

    data[module] = frame

    self:onReady(function()
        SendNUIMessage({ action = 'create_frame', name = module, url = url, visible = visible })
    end)
end

function ui:registerNuiCallback(module, name, callback)
    module = ensure(module, 'global')
    name = ensure(name, 'unknown')
    callback = ensure(callback, function(_, cb) cb() end)

    if (callbacks[module] == nil) then callbacks[module] = {} end

    callbacks[module][name] = callback
end

RegisterNUICallback('nui_ready', function(_, cb)
    ready = true
    cb = ensure(cb, function() end)

    cb('ok')
end)