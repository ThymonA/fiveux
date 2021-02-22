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
end

function modules:load(name, env, ...)
    name = ensure(name, 'unknown')
    env = setmetatable(ensure(env, {}), { __index = _G, __newindex = _G})

    if (name == 'unknown') then return end
    if (data == nil) then data = {} end

    local low_name = name:lower()
    local module = data[low_name] or nil
    local m_name = ensure(env.__NAME__, 'global')

    if (module == nil) then return nil end

    local func = ensure(module, function() end)
    local done, result = xpcall(func, function(err)
        print_error(("Couldn't load module '~x~%s~s~': %s"):format(low_name, err), 'modules')
    end, ...)

    env[name] = done and result or nil
end

function modules:get(name, ...)
    name = ensure(name, 'unknown'):lower()

    if (name == 'unknown') then return end
    if (data == nil) then data = {} end

    local module = data[name] or nil
    local m_name = ensure(__NAME__, 'global')

    if (module == nil) then return nil end

    local func = ensure(module, function() end)
    local done, result = xpcall(func, function(err)
        print_error(("Couldn't load module '~x~%s~s~': %s"):format(name, err), 'modules')
    end, ...)

    return done and result or nil
end