local _print = print
local _boot = boot
local _json = json
local _config = config
local _debug = debug
local _debugger = debugger
local _modules = modules
local _translations = translations
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

        return _debugger:info(name, ...)
    end

    env.m = function(name, ...)
        return _modules:load(name, env, ...)
    end

    env.register = function(name, input)
        return _modules:register(name, input)
    end

    env.PublicEventHandler = function(name)
        local envType = ensure(env.ENVIRONMENT, 'client')

        if (envType == 'client') then
            RegisterNetEvent(name)
        elseif (envType == 'server') then
            RegisterServerEvent(name)
        end
    end

    env.T = function(key, ...)
        key = ensure(key, 'unknown')

        local trans = ensure(env.__TRANSLATIONS__, {})
        local translation = ensure(trans[key], ('missing(translation/%s)'):format(key))

        if (translation:len() <= 0) then
            translation = ('missing(translation/%s)'):format(key)
        end

        return translation:format(...)
    end

    env.serverMessage = function(message, footer)
        message = ensure(message, '')
        footer = ensure(footer, '')
    
        local cfg = env.config('general')
        local name = ensure(cfg.serverName, 'FiveUX')
        local template = '\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n%s\n\n%s\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n%s'
    
        if (footer:len() <= 0) then
            local discordUrl = ensure(cfg.discordUrl, '...')
    
            footer = env.T('default_footer', discordUrl)
        end
    
        name = boldText(name)
    
        return template:format(name, message, footer)
    end

    env.getInvokingModules = function()
        _boot = _boot or boot

        local modules = _boot:getModules()
        local index, current_debug, invkoing_modules = 0, nil, {}

        while (index <= 0 or current_debug ~= nil) do
            index = index + 1

            current_debug = _debug.getinfo(index)

            if (current_debug ~= nil) then
                local s = current_debug.source ~= nil and ensure(current_debug.source, 'unknown')

                if (s ~= 'unknown') then
                    while (s:sub(1, 1) == '@') do
                        s = s:sub(2)
                    end

                    local prefix = ('%s:'):format(RESOURCE_NAME)

                    if (s:sub(1, #prefix) == prefix) then
                        local module = s:sub(#prefix + 1)

                        for k, v in pairs(modules) do
                            local startStr = ('%s:%s'):format(ensure(v, 'global'), ensure(k, 'global'))

                            if (module:startsWith(startStr)) then
                                table.insert(invkoing_modules, ensure(k, 'global'))
                            end
                        end
                    end
                end
            end

            if (#invkoing_modules >= 2) then
                return invkoing_modules
            end
        end

        return invkoing_modules
    end

    env.getInvokingModule = function()
        local invoking_modules = ensure(env.getInvokingModules(), {})

        if (#invoking_modules > 0) then
            local idx = 1

            if (#invoking_modules >= 2) then idx = 2 end

            local invoking_module = invoking_modules[idx]

            return ensure(invoking_module, 'global')
        end

        return 'global'
    end

    env.getWebhooks = function(action, fallback)
        local results = {}
        local webhooksCfg = ensure(_config:load('webhooks'), {})
        local cfgFallback = ensure(webhooksCfg.fallback, {})

        action = ensure(action, 'unknown')
        fallback = ensure(fallback, cfgFallback)

        if (webhooksCfg[action] ~= nil) then
            local webhooksList = ensureStringList(ensure(webhooksCfg[action], {}))

            for k, v in pairs(webhooksList) do
                if (v:startsWith('https://') or v:startsWith('http://')) then
                    table.insert(results, v)
                end
            end
    
            return results
        end

        local actionParts = ensure(action:split('.'), {})

        if (#actionParts > 2) then
            local newAction = ensure(actionParts[1], 'unknown')

            for i = 2, (#actionParts - 1), 1 do
                newAction = ('%s%s%s'):format(newAction, (i == 2 and '' or '.'), ensure(actionParts[i], 'unknown'))
            end

            return env.getWebhooks(newAction, fallback)
        elseif (#actionParts == 2) then
            return env.getWebhooks(ensure(actionParts[1], 'unknown'), fallback)
        end

        local fallbackList = ensureStringList(fallback)

        for k, v in pairs(fallbackList) do
            if (v:startsWith('https://') or v:startsWith('http://')) then
                table.insert(results, v)
            end
        end

        return results
    end

    data[key] = env

    return env
end