local ready = false
local data = {}
local callbacks = {}
local created = {}

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

    created[module] = false
    data[module] = frame

    self:onReady(function()
        local done = false

        while not done do
            Citizen.Wait(0)

            SendNUIMessage({ action = 'create_frame', name = module, url = url, visible = visible })

            Citizen.Wait(50)

            done = ensure(created[module], false)
        end
    end)
end

function ui:registerNuiCallback(module, name, callback)
    module = ensure(module, 'global')
    name = ensure(name, 'unknown')
    callback = ensure(callback, function(_, cb) cb() end)

    if (callbacks[module] == nil) then callbacks[module] = {} end

    callbacks[module][name] = callback

    RegisterNUICallback(('%s:%s'):format(module, name), callbacks[module][name])
end

function ui:sendNuiMessage(module, info)
    module = ensure(module, 'global')

    info = ensure(info, {})
    info.source = module

    SendNUIMessage(info)
end

RegisterNUICallback('nui_ready', function(_, cb)
    ready = true
    cb = ensure(cb, function() end)

    cb('ok')
end)

RegisterNUICallback('nui_created', function(info, cb)
    info = ensure(info, {})
    cb = ensure(cb, function() end)

    local name = ensure(info.name, 'unknown')

    created[name] = true

    cb('ok')
end)