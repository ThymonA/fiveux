local data = {}

events = {}

local function onEvent(module, event, name, func)
    module = ensure(module, 'unknown')
    event = ensure(event, 'unknown')
    name = ensure(name, typeof(name) == 'table' and {} or 'unknown')

    if (typeof(name) == 'table') then
        for k, v in pairs(name) do
            if (typeof(v) == 'string') then
                onEvent(module, event, v, func)
            end
        end

        return
    end

    event = event:lower()
    name = (name ~= 'unknown' and name:lower()) or nil

    if (data == nil) then data = {} end
    if (data[event] == nil) then data[event] = { funcs = {}, params = {} } end

    if (name == nil) then
        table.insert(data[event].funcs, {
            module = module,
            func = func
        })
    else
        if (data[event].func[name] == nil) then
            data[event].func[name] = {}
        end

        table.insert(data[event].func[name], {
            module = module,
            func = func
        })
    end
end

local function filterArguments(...)
    local name, names, callback = nil, nil, nil
    local name_i, names_i, index = 999, 999, 0
    local arguments = {...}

    for k, v in pairs(arguments) do
        index = index + 1

        local t = typeof(v)

        if (t == 'function' and callback == nil) then
            callback = v
        elseif (t == 'table' and names == nil) then
            for nk, nv in pairs(v) do
                local n = ensure(nv, 'unknown')

                if (n ~= 'unknown') then
                    if (names == nil) then
                        names = {}
                        names_i = index
                    end

                    table.insert(names, n)
                end
            end
        elseif (name == nil) then
            local n = ensure(v, 'unknown')

            if (n ~= 'unknown') then
                name = n
                name_i = index
            end
        end
    end

    if (name ~= nil and callback ~= nil and name_i < names_i) then
        return callback, name
    elseif (names ~= nil and callback ~= nil and names_i < name_i) then
        return callback, names
    elseif (callback ~= nil) then
        return callback, nil
    end

    return nil, nil
end

function events:on(event, ...)
    event = ensure(event, 'unknown')

    local module = ensure(getInvokingModule(), NAME or 'unknown')
    local callback, name = filterArguments(...)

    if (callback == nil) then return end

    onEvent(module, event, name, callback)
end

function events:getEventRegistered(event, param)
    local registered_events = {}

    event = ensure(event, 'unknown')
    event = string.lower(event)

    if (event == 'unknown' or data == nil) then return {} end

    if (data[event] ~= nil) then
        for k, v in pairs(data[event].funcs) do
            local f = ensure(v.func, function() end)

            table.insert(registered_events, f)
        end

        if (param ~= nil and typeof(param) ~= 'function') then
            local param_s = ensure(param, 'none')

            for k, v in pairs(data[event].params) do
                local p = ensure(k, 'unknown')
                local i = ensure(k, param, true)

                if (i == param or p == param_s) then
                    local f = ensure(v.func, function() end)

                    table.insert(registered_events, f)
                end
            end
        end
    end

    return registered_events
end

function events:triggerOnEvent(event, name, ...)
    local registered_events = self:getEventRegistered(event, name)
    local params = table.pack(...)

    for k, v in pairs(registered_events) do
        Citizen.CreateThread(function()
            v = ensure(v, function() end)

            try(function()
                v(table.unpack(params))
            end, print_error)
        end)
    end
end

register('events', events)