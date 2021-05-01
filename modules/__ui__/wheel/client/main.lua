--- Local storage
local __id = 0
local __ready = false
local data = {}

---@class wheels
wheels = {}

--- Create a option wheel
---@return wheel
function wheels:create()
    __id = __id + 1

    ---@class wheel
    local wheel = {
        id = __id,
        items = {},
        visible = false,
        events = {},
        params = {}
    }

    --- Add a item to your wheel
    ---@param name string Name of item (will be retuned on `select` events)
    ---@param lib string Icon library to show
    ---@param icon string Icon to show
    function wheel:addItem(name, lib, icon)
        local id = #self.items + 1

        name = ensure(name, 'unknown')
        lib = ensure(lib, 'las')
        icon = ensure(icon, 'la-stop')

        if (id <= 8) then
            table.insert(self.items, { name = name, lib = lib, icon = icon, id = id })
        end
    end

    --- Add multiple items to wheel
    function wheel:addItems(...)
        local items = { ... }

        for _, item in pairs(items) do
            local name = ensure(item.name, 'unknown')
            local lib = ensure(item.lib, 'las')
            local icon = ensure(item.icon, 'la-stop')

            self:addItem(name, lib, icon)
        end
    end

    --- Reset wheel items
    function wheel:resetItems()
        self.items = {}
    end

    --- Show current wheel
    ---@param x number Location where wheel needs to be
    ---@param y number Location where wheel needs to be
    function wheel:show(x, y)
        SendNUIMessage({
            action = 'SHOW',
            id = ensure(self.id, 'unknown'),
            items = ensure(self.items, {}),
            x = ensure(x, 0),
            y = ensure(y, 0)
        })
    end

    --- Hide current wheel
    function wheel:hide()
        if (self.visible) then
            SendNUIMessage({
                action = 'HIDE'
            })
        end
    end

    --- Add a parameter that will be given in `select` event
    ---@param input any Parameter
    function wheel:addParam(input)
        self.params = ensure(self.params, {})
        
        table.insert(self.params, input)
    end

    --- Reset wheel parameters
    function wheel:resetParams()
        self.params = {}
    end

    --- Register a event to wheel
    ---@param event string Name of wheel
    ---@param callback function Callback to execute
    function wheel:on(event, callback)
        event = ensure(event, 'unknown')
        callback = ensure(callback, function() end)

        if (self.events == nil) then self.events = {} end
        
        self.events[event] = callback
    end

    data[wheel.id] = wheel

    return wheel
end

RegisterNUICallback('ready', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    __ready = true

    callback('ok')
end)

RegisterNUICallback('show', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)

    if (data ~= nil and data[id] ~= nil) then
        data[id].visible = true

        local events = ensure(data[id].events, {})
        local cb = ensure(events['show'], function() end)

        SetNuiFocus(true, true)

        cb()
    end

    callback('ok')
end)

RegisterNUICallback('hide', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    SetNuiFocus(false, false)

    for id, _ in pairs(data) do
        if (data[id].visible) then
            local events = ensure(data[id].events, {})
            local cb = ensure(events['hide'], function() end)

            cb()
        end

        data[id].visible = false
    end
end)

RegisterNUICallback('select', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)
    local chosen = ensure(info.chosen, 0)

    if (data == nil or data[id] == nil) then
        callback('ok')
        return
    end

    if (chosen <= 0) then
        data[id].visible = false
    else
        local items = ensure(data[id].items, {})
        local item = ensure(items[chosen], {})
        local events = ensure(data[id].events, {})
        local cb = ensure(events['select'], function() end)
        local params = ensure(data[id].params, {})

        cb(ensure(item.name, 'unknown'), table.unpack(params))
    end

    SetNuiFocus(false, false)

    callback('ok')
end)

--- Export wheels
export('wheels', wheels)