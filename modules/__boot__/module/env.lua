local _print = print
local _json = json
local _config = config
local _debug = debug
local _modules = modules
local data = {}

environment = {}

function environment:create(category, module, directory)
    category = ensure(category, 'global'):lower()
    module = ensure(module, 'unknown'):lower()
    directory = ensure(directory, ('modules/%s/%s'):format(category, module)):lower()

    if (module == 'unknown') then return nil end
    
    local key = ('env:%s:%s'):format(category, module)

    if (data == nil) then data = {} end
    if (data[key] ~= nil) then return data[key] end

    local env = {}
    local envType = IsDuplicityVersion() and 'server' or 'client'

    for k, v in pairs(_G) do env[k] = v end
    for k, v in pairs(_ENV) do env[k] = v end

    env.__CATEGORY__ = category
    env.__NAME__ = module
    env.__MODULE__ = module
    env.__DIRECTORY__ = directory
    env._ENV = setmetatable(env, { __index = _G, __newindex = _G })
    env.ENVIRONMENT = envType

    env.print = function(...)
        local args = { ... }
        local message = ('^1> ^4info^7(^4%s^7/^4%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)

        _print(message)
    end

    env.print_success = function(...)
        local args = { ... }
        local message = ('^1> ^2success^7(^2%s^7/^2%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)

        _print(message)
    end

    env.print_warning = function(...)
        local args = { ... }
        local message = ('^1> ^3warning^7(^3%s^7/^3%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)

        _print(message)
    end

    env.print_error = function(...)
        local args = { ... }
        local message = ('^1> ^1error^7(^1%s^7/^1%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)

        _print(message)
    end

    env.config = function(name)
        name = ensure(name, module)

        return _config:load(name)
    end

    env.debug = function(...)
        local name = ensure(module, env.__NAME__)

        return _debug:info(name, ...)
    end

    env.m = function(name, ...)
        return _modules:load(name, env, ...)
    end

    env.register = function(name, input)
        return _modules:register(name, input)
    end

    env.json = _json
    env.json.encode = encode

    data[key] = env

    return env
end