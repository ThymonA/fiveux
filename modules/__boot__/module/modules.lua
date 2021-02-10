local data = {}

modules = {}

function modules:register(name, input)
    name = ensure(name, 'unknown'):lower()
    env = ensure(env, {})

    if (name == 'unknown') then return end
    if (data == nil) then data = {} end

    if (typeof(input) == 'function') then
        data[name] = ensure(input, function() return nil end)
    else
        data[name] = function() return input end
    end

    debug:info(__NAME__, ("Module '%s' has been registered"):format(name))
end

function modules:load(name, env, ...)
    name = ensure(name, 'unknown'):lower()
    env = setmetatable(ensure(env, {}), { __index = _G, __newindex = _G})

    if (name == 'unknown') then return end
    if (data == nil) then data = {} end

    local module = data[name] or nil
    local m_name = ensure(env.__NAME__, 'global')

    if (module == nil) then return nil end

    debug:info(m_name, ("Loading module '%s' for '%s'"):format(name, m_name))

    local func = ensure(module, function() end)
    local done, result = xpcall(func, function(err)
        print_error(("Couldn't load module '%s': %s"):format(name, err), 'modules')
    end, ...)

    env[name] = done and result or nil

    debug:info(m_name, ("Module '%s' has been loaded for '%s'"):format(name, m_name))
end