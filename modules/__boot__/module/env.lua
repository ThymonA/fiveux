local _print = print
local _json = json
local _config = config
local _debug = debug
local _modules = modules
local _translations = translations
local _AddEventHandler = AddEventHandler
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

    for k, v in pairs(_ENV) do env[k] = v end

    env.__CATEGORY__ = category
    env.__NAME__ = module
    env.__MODULE__ = module
    env.__DIRECTORY__ = directory
    env.__PRIMARY__ = __PRIMARY__
    env.__TRANSLATIONS__ = _translations:load(category, module)
    env._ENV = env
    env.ENVIRONMENT = envType
    env.RESOURCE_NAME = RESOURCE_NAME

    env.print = function(...)
        local args = { ... }
        local message = ('^1> ^4info^7(^4%s^7/^4%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)
        message = message:gsub('%~x~', '^4')
        message = message:gsub('%~s~', '^7')

        _print(message)
    end

    env.print_success = function(...)
        local args = { ... }
        local message = ('^1> ^2success^7(^2%s^7/^2%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)
        message = message:gsub('%~x~', '^2')
        message = message:gsub('%~s~', '^7')

        _print(message)
    end

    env.print_warning = function(...)
        local args = { ... }
        local message = ('^1> ^3warning^7(^3%s^7/^3%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)
        message = message:gsub('%~x~', '^3')
        message = message:gsub('%~s~', '^7')

        _print(message)
    end

    env.print_error = function(...)
        local args = { ... }
        local message = ('^1> ^1error^7(^1%s^7/^1%s^7):'):format(envType, module)

        for i = 1, #args, 1 do
            message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
        end

        message = ('%s^7'):format(message)
        message = message:gsub('%~x~', '^1')
        message = message:gsub('%~s~', '^7')

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

    env.AddEventHandler = function(name, callback)
        name = ensure(name, 'unknown')

        if (name == 'unknown') then return end

        return _AddEventHandler(name, function(...)
            local cb = ensure(callback, function() end)
            local playerSource = ensure(source, -1)
            local playersModule = _modules:get('players')

            if (playersModule == nil) then
                error("'players' module is missing")
                return
            end

            local playerData = playersModule:load(playerSource)

            env.source = playerSource

            cb(playerData or playerSource, ...)
        end)
    end

    env._ = function(key, ...)
        key = ensure(key, 'unknown')

        local trans = ensure(env.__TRANSLATIONS__, {})
        local translation = ensure(trans[key], ('missing(translation/%s)'):format(key))

        return translation:format(...)
    end

    env.json = _json
    env.json.encode = encode

    data[key] = env

    return env
end