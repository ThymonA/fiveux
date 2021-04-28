---@alias vector2 table Vector2
---@alias vector3 table Vector3
---@alias vector4 table Vector4

--- Globals
local pi = print_info
local pe = print_error
local pw = print_warning
local ps = print_success
local cs = constants

--- Framework current resource name
_G.RESOURCE_NAME = ensure(GetCurrentResourceName(), 'fiveux')
--- Framework execution environment (client/server)
_G.ENVIRONMENT = IsDuplicityVersion() and 'server' or 'client'
--- Name of current category
_G.NAME = 'global'
--- Primary license type (steam/license/xbl/live/discord etc...)
_G.PRIMARY = 'license'
--- Custom Trigger Events
_G.TriggerLocal = TriggerEvent
_G.TriggerRemote = ENVIRONMENT == 'server' and TriggerClientEvent or TriggerServerEvent
_G.MarkEventAsGlobal = RegisterNetEvent
_G.RegisterEvent = AddEventHandler

--- Bootable class
---@class bootable
---
local bootable = {}
---@type table<string, module>
local __modules = {}
local __exports = {}
local __configs = {}
local __events = {}
local __nui_pages = {}
local __keyPressed = {}
local __keyPressedTimes = {}
local __translations = {}
local __sharedTranslations = {}
local __loaded = false
local __nuiLoaded = false
local __nuiCallbacks = {}
local __nuiFocus = {}
local __clientCallbacks = {}

--- Create a new environment
---@param self bootable
---@param globals table List of globals
---@return table Generated environment
function bootable:createEnvironment(globals)
    globals = ensure(globals, {})

    local env = {}

    for k, v in pairs(_G) do env[k] = v end
    for k, v in pairs(_ENV) do env[k] = v end

    env.RESOURCE_NAME = RESOURCE_NAME
    env.ENVIRONMENT = ENVIRONMENT
    env.NAME = NAME
    env.PRIMARY = PRIMARY
    env.constants = cs

    for k, v in pairs(globals) do env[k] = v end

    local mt = setmetatable(env, {
        __newindex = function(t, k, v)
            rawset(env, k, v)
            rawset(t, k, v)
        end,
        __index = function(t, k)
            if (t ~= nil) then
                local result = rawget(t, k)

                if (result ~= nil) then return result end
            end

            if (env ~= nil) then
                local result = rawget(env, k)

                if (result ~= nil) then return result end
            end

            if (_G ~= nil and _G[k] ~= nil) then return _G[k] end

            return nil
        end
    })

    env._ENV = mt

    return mt
end

--- Load configuration from <root>/configurations
---@param self bootable
---@param configuration string Name of configuration
---@return table Configuration
function bootable:loadConfiguration(configuration)
    configuration = ensure(configuration, 'unknown')

    if (__configs == nil) then __configs = {} end
    if (__configs[configuration] ~= nil) then return __configs[configuration] end

    local shared_path = ('configurations/%s/shared.config.lua'):format(configuration)
    local env_path = ('configurations/%s/%s.config.lua'):format(configuration, ENVIRONMENT)
    local environment = self:createEnvironment({
        config = {},
        vec = function(...)
            local arguments = { ... }
    
            if (#arguments == 0) then
                return nil
            elseif (#arguments == 1) then
                return vector(ensure(arguments[1], 0))
            elseif (#arguments == 2) then
                return vector2(ensure(arguments[1], 0), ensure(arguments[2], 0))
            elseif (#arguments == 3) then
                return vector3(ensure(arguments[1], 0), ensure(arguments[2], 0), ensure(arguments[3], 0))
            elseif (#arguments >= 4) then
                return vector4(ensure(arguments[1], 0), ensure(arguments[2], 0), ensure(arguments[3], 0), ensure(arguments[4], 0))
            end
    
            return nil
        end
    })
    local shared_data = LoadResourceFile(RESOURCE_NAME, shared_path)
    local env_data = LoadResourceFile(RESOURCE_NAME, env_path)

    if (shared_data ~= nil) then
        local fn = load(shared_data, ('fiveux:config:%s:shared.config.lua'):format(configuration), 't', environment)

        if (fn) then
            local ok = xpcall(fn, function(err)
                return print_error(err, 'config')
            end)
        end
    end

    if (env_data ~= nil) then
        local fn = load(env_data, ('fiveux:config:%s:%s.config.lua'):format(configuration, ENVIRONMENT), 't', environment)

        if (fn) then
            local ok = xpcall(fn, function(err)
                return print_error(err, 'config')
            end)
        end
    end

    local cfg = ensure(environment.config, {})

    __configs[configuration] = cfg

    return cfg
end

--- Load modules translations
---@param self bootable
---@param category string Name of category
---@param module string Name of module
---@return table List of translations
function bootable:loadTranslations(category, module)
    category = ensure(category, 'shared')
    module = ensure(module, 'shared')

    local key = ('%s:%s'):format(category, module)
    local cfg = self:loadConfiguration('general')
    local language = ensure(cfg.language, 'en')

    if (__translations == nil) then __translations = {} end
    if (__translations[key] ~= nil) then return __translations[key] end

    local translation_path = ('modules/__%s__/%s/translations/%s.lua'):format(category, module, language)

    if (category == 'shared' and module == 'shared') then
        translation_path = ('shared/translations/%s.lua'):format(language)
    end

    local translation_data = LoadResourceFile(RESOURCE_NAME, translation_path)
    local environment = self:createEnvironment({ translations = {} })

    if (translation_data) then
        local fn = load(translation_data, ('fiveux:translations:%s:%s:%s.lua'):format(category, module, language), 't', environment)

        if (fn) then
            local ok = xpcall(fn, function(err)
                return print_error(err, 'config')
            end)
        end
    end

    local translations = ensure(environment.translations, {})

    __translations[key] = translations

    return translations
end

--- Returns a list of executable categories
---@param self bootable
---@return table List of categories to execute
function bootable:getAllCategories()
    local category_names = {}
    local data = LoadResourceFile(RESOURCE_NAME, 'modules/fxmodules.lua')

    if (data ~= nil) then
        local env = self:createEnvironment({
            category = function(name)
                name = ensure(name, 'unknown')
        
                if (name ~= 'unknown') then
                    table.insert(category_names, name)
                end
            end,
            categories = function(t)
                t = ensure(t, {})
        
                for i = 1, #t, 1 do
                    local name = ensure(t[i], 'unknown')
        
                    if (name ~= 'unknown') then
                        table.insert(category_names, name)
                    end
                end
            end
        })

        local fn = load(data, ('fiveux:fxmodules.lua'), 't', env)

        if (fn) then
            local ok = xpcall(fn, function(err) print_error(err, NAME) end)

            while ok == nil do Citizen.Wait(0) end
        end
    end

    local categories = {}

    for i = 1, #category_names, 1 do
        local data = LoadResourceFile(RESOURCE_NAME, ('modules/__%s__/fxcategory.lua'):format(category_names[i]))

        if (data ~= nil) then
            local m_name = 'unknown'
            local m_description = 'unknown'
            local m_modules = {}

            local env = self:createEnvironment({
                name = function(n)
                    m_name = ensure(n, 'unknown')
                end,
                description = function(d)
                    m_description = ensure(d, 'unknown')
                end,
                module = function(mt)
                    mt = ensure(mt, {})

                    local mn = ensure(mt.name, 'unknown')
                    local mr = ensure(mt.required, false)

                    if (mn ~= 'unknown') then
                        table.insert(m_modules, {
                            name = mn,
                            required = mr
                        })
                    end
                end,
                modules = function(m)
                    m = ensure(m, {})

                    for i2 = 1, #m, 1 do
                        local mt = ensure(m[i2], {})
                        local mn = ensure(mt.name, 'unknown')
                        local mr = ensure(mt.required, false)

                        if (mn ~= 'unknown') then
                            table.insert(m_modules, {
                                name = mn,
                                required = mr
                            })
                        end
                    end
                end
            })

            local fn = load(data, ('fiveux:%s:fxcategory.lua'):format(category_names[i]), 't', env)

            if (fn) then
                local ok = xpcall(fn, function(err) print_error(err, NAME) end)

                while ok == nil do Citizen.Wait(0) end
            end

            if (m_name ~= 'unknown') then
                table.insert(categories, { name = m_name, description = m_description, modules = m_modules })
            end
        end
    end

    return categories
end

--- Returns a list of executable modules
---@param self bootable
---@return table List of executable modules
function bootable:getAllModules()
    local categories = self:getAllCategories()
    local modules = {}

    for i = 1, #categories, 1 do
        local category = ensure(categories[i], {})
        local c_name = ensure(category.name, 'unknown')
        local c_description = ensure(category.description, '')
        local c_modules = ensure(category.modules, {})

        for i2 = 1, #c_modules, 1 do
            local c_module = ensure(c_modules[i2], {})
            local cm_name = ensure(c_module.name, 'unknown')
            local cm_required = ensure(c_module.required, false)
            local cm_data = LoadResourceFile(RESOURCE_NAME, ('modules/__%s__/%s/fxmodule.lua'):format(c_name, cm_name))

            if (cm_data == nil and cm_required) then
                print_error(('Module "~x~%s~s~/~x~%s~s~" is required but "~x~fxmodule.lua~s~" doesn\'t exists!'):format(c_name, cm_name), NAME)
                
                if (ENVIRONMENT == 'server') then
                    print_info('Shutdown server because of critical exception')
                    ExecuteCommand('quit')
                end

                return
            elseif (cm_data ~= nil) then
                local _cm_name = 'unknown'
                local _cm_version = '1.0.0'
                local _cm_description = ''
                local _cm_license = 'none'
                local _cm_client_scripts = {}
                local _cm_server_scripts = {}
                local _cm_shared_scripts = {}
                local _cm_ui_page = nil
                local _cm_dependencies = {}
                local env = self:createEnvironment({
                    name = function(n)
                        _cm_name = ensure(n, 'unknown')
                    end,
                    version = function(v)
                        _cm_version = ensure(v, '1.0.0')
                    end,
                    description = function(d)
                        _cm_description = ensure(d, '')
                    end,
                    license = function(l)
                        _cm_license = ensure(l, 'none')
                    end,
                    client_script = function(s)
                        s = ensure(s, 'unknown')

                        if (s ~= 'unknown') then
                            table.insert(_cm_client_scripts, s)
                        end
                    end,
                    client_scripts = function(st)
                        st = ensure(st, {})

                        for i3 = 1, #st, 1 do
                            local s = ensure(st[i3], 'unknown')

                            if (s ~= 'unknown') then
                                table.insert(_cm_client_scripts, s)
                            end
                        end
                    end,
                    server_script = function(s)
                        s = ensure(s, 'unknown')

                        if (s ~= 'unknown') then
                            table.insert(_cm_server_scripts, s)
                        end
                    end,
                    server_scripts = function(st)
                        st = ensure(st, {})

                        for i3 = 1, #st, 1 do
                            local s = ensure(st[i3], 'unknown')

                            if (s ~= 'unknown') then
                                table.insert(_cm_server_scripts, s)
                            end
                        end
                    end,
                    shared_script = function(s)
                        s = ensure(s, 'unknown')

                        if (s ~= 'unknown') then
                            table.insert(_cm_shared_scripts, s)
                        end
                    end,
                    shared_scripts = function(st)
                        st = ensure(st, {})

                        for i3 = 1, #st, 1 do
                            local s = ensure(st[i3], 'unknown')

                            if (s ~= 'unknown') then
                                table.insert(_cm_shared_scripts, s)
                            end
                        end
                    end,
                    ui_page = function(s)
                        s = ensure(s, 'unknown')

                        if (s ~= 'unknown') then
                            _cm_ui_page = s
                        end
                    end,
                    dependency = function(d)
                        d = ensure(d, 'unknown')

                        if (d ~= 'unknown') then
                            table.insert(_cm_dependencies, d)
                        end
                    end,
                    dependencies = function(dt)
                        dt = ensure(dt, {})

                        for i3 = 1, #dt, 1 do
                            local d = ensure(dt[i3], 'unknown')

                            if (d ~= 'unknown') then
                                table.insert(_cm_dependencies, d)
                            end
                        end
                    end
                })

                local fn = load(cm_data, ('fiveux:%s:%s:fxmodule.lua'):format(c_name, cm_name), 't', env)

                if (fn) then
                    local ok = xpcall(fn, function(err) print_error(err, NAME) end)
    
                    while ok == nil do Citizen.Wait(0) end
                end

                if (_cm_name ~= 'unknown') then
                    table.insert(modules, {
                        name = _cm_name,
                        version = _cm_version,
                        description = _cm_description,
                        required = cm_required,
                        license = _cm_license,
                        client_scripts = _cm_client_scripts,
                        server_scripts = _cm_server_scripts,
                        shared_scripts = _cm_shared_scripts,
                        ui_page = _cm_ui_page,
                        dependencies = _cm_dependencies,
                        category = c_name,
                        category_description = c_description
                    })
                end
            end
        end
    end

    return modules
end

--- Load a exported module
---@param name string Name of module
function bootable:loadExport(name, ...)
    name = ensure(name, 'unknown')

    if (__exports == nil or __exports[name] == nil) then
        print_warning(('Module "~x~%s~s~" not found'):format(name), NAME)
        return nil
    end

    if (typeof(__exports[name]) == 'function') then
        return __exports[name](...)
    else
        return __exports[name]
    end
end

--- Generate a new environment for given module
---@param self bootable
---@param category string Name of category
---@param module string Name of module
---@param version string Version of module
---@return table Module environment
function bootable:createModuleEnvironment(category, module, version)
    local cfg = self:loadConfiguration('general')
    local serverName = ensure(cfg.serverName, 'FiveUX Framework')
    local discordUrl = ensure(cfg.discordUrl, 'https://github.com/ThymonA/fiveux/')

    category = ensure(category, 'global')
    module = ensure(module, 'unknown')
    version = ensure(version, '1.0.0')

    local env = self:createEnvironment({
        NAME = module,
        MODULE = module,
        CATEGORY = category,
        VERSION = version,
        SERVER_NAME = serverName,
        DISCORD_URL = discordUrl,
        DIRECTORY = ('modules/__%s__/%s/'):format(category, module),
        __translations = {},
        print = function(...)
            return pi(argumentsToString(...), module)
        end,
        print_success = function(...)
            return ps(argumentsToString(...), module)
        end,
        print_warning = function(...)
            return pw(argumentsToString(...), module)
        end,
        print_error = function(...)
            return pe(argumentsToString(...), module)
        end,
        export = function(name, func)
            name = ensure(name, 'unknown')
            func = func or {}

            if (__modules ~= nil and __modules[module] ~= nil) then
                __modules[module].exports[name] = func
            end
        end,
        config = function(name)
            name = ensure(name, 'unknown')

            return self:loadConfiguration(name)
        end,
        vec = function(...)
            local arguments = { ... }
    
            if (#arguments == 0) then
                return nil
            elseif (#arguments == 1) then
                return vector(ensure(arguments[1], 0))
            elseif (#arguments == 2) then
                return vector2(ensure(arguments[1], 0), ensure(arguments[2], 0))
            elseif (#arguments == 3) then
                return vector3(ensure(arguments[1], 0), ensure(arguments[2], 0), ensure(arguments[3], 0))
            elseif (#arguments >= 4) then
                return vector4(ensure(arguments[1], 0), ensure(arguments[2], 0), ensure(arguments[3], 0), ensure(arguments[4], 0))
            end
    
            return nil
        end,
        src = function(url)
            url = ensure(url, '')

            return ('modules/__%s__/%s/%s'):format(category, module, url)
        end
    })

    env.import = function(name, ...)
        name = ensure(name, 'unknown')

        if (__exports == nil or __exports[name] == nil) then
            print_warning(('Module "~x~%s~s~" not found'):format(name), env.MODULE)
            return
        end

        if (typeof(__exports[name]) == 'function') then
            env[name] = __exports[name](...)
        else
            env[name] = __exports[name]
        end
    end

    env.T = function(key, ...)
        key = ensure(key, 'unknown')

        local translations = ensure(env.__translations, {})
        local fallback = ('translation(%s/%s)'):format(env.MODULE, key)
        local translation = ensure(translations[key], fallback)

        if (translation:len() <= 0) then translation = fallback end

        return translation:format(...)
    end

    env.on = function(event, ...)
        event = ensure(event, 'unknown')
        
        local module = ensure(env.MODULE, NAME)

        return self:on(module, event, ...)
    end

    env.emit = function(event, name, ...)
        event = ensure(event, 'unknown')
        name = ensure(name, 'unknown')

        return bootable:emit(event, name, ...)
    end

    env.serverMessage = function(message, footer)
        local serverName = ensure(env.SERVER_NAME, 'FiveUX Framework')
        local discordUrl = ensure(env.DISCORD_URL, 'https://github.com/ThymonA/fiveux/')

        message = ensure(message, '')
        footer = ensure(footer, self:T('join_our_discord', discordUrl))

        if (footer:len() < 1) then
            footer = self:T('join_our_discord', discordUrl)
        end

        local template = '\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n%s\n\n%s\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n%s'

        return template:format(boldText(serverName), message, footer)
    end

    if (ENVIRONMENT == 'client') then
        env.addControl = function(name, description, type, key)
            local module = ensure(env.NAME, NAME)

            name = ensure(name, 'unknown')
            description = ensure(description, self:T('default_key_description', module, name))
            type = ensure(type, 'keyboard')
            key = ensure(key, 'e')

            return self:registerKeybind(module, name, description, type, key)
        end

        env.isControlPressed = function(name)
            name = ensure(name, 'unknown')

            if (name == 'unknown') then return false end

            return self:isControlPressed(name)
        end

        env.isControlJustPressed = function(name)
            name = ensure(name, 'unknown')

            if (name == 'unknown') then return false end

            return self:isControlJustPressed(name)
        end

        env.isControlReleased = function(name)
            name = ensure(name, 'unknown')

            if (name == 'unknown') then return true end

            return self:isControlReleased(name)
        end

        env.NUI = function()
            local module_name = ensure(env.NAME, 'unknown')
            local module_category = ensure(env.CATEGORY, 'unknown')

            if (__modules == nil or __modules[module_name] == nil) then return end

            local module_info = ensure(__modules[module_name], {})
            local module_page = ensure(module_info.ui_page, 'unknown')
            local nui_key = ('%s:%s:%s'):format(module_category, module_name, module_page)

            if (__nui_pages == nil or __nui_pages[nui_key] == nil) then return end

            return __nui_pages[nui_key]
        end

        env.SendNUIMessage = function(data)
            local nui = env.NUI()
            
            if (nui == nil) then return end

            return nui:sendMessage(data)
        end

        env.RegisterNUICallback = function(name, callback)
            name = ensure(name, 'unknown')
            callback = ensure(callback, function(_, cb) cb('ok') end)

            local nui = env.NUI()
            
            if (nui == nil) then return end
            if (__nuiCallbacks == nil) then __nuiCallbacks = {} end
            if (__nuiCallbacks[nui.name] == nil) then __nuiCallbacks[nui.name] = {} end
            
            __nuiCallbacks[nui.name][name] = callback
        end

        env.HideNUI = function()
            local nui = env.NUI()
            
            if (nui == nil) then return end

            return nui:hide()
        end

        env.ShowNUI = function()
            local nui = env.NUI()
            
            if (nui == nil) then return end

            return nui:show()
        end

        env.DestroyNUI = function()
            local nui = env.NUI()
            
            if (nui == nil) then return end

            return nui:destroy()
        end

        env.CreateNUI = function()
            local nui = env.NUI()
            
            if (nui == nil) then return end

            return nui:create()
        end

        env.SetNuiFocus = function(hasFocus, hasCursor)
            hasFocus = ensure(hasFocus, false)
            hasCursor = ensure(hasCursor, false)

            local nui = env.NUI()

            if (nui == nil) then return end

            __nuiFocus[nui.name] = { hasFocus, hasCursor }
        end

        env.RegisterClientCallback = function(event, callback)
            if (__clientCallbacks == nil) then __clientCallbacks = {} end

            event = ensure(event, 'unknown')
            callback = ensure(callback, function() end)

            __clientCallbacks[event] = callback
        end
    end

    if (ENVIRONMENT == 'server') then
        env.requestClientInfoAsync = function(event, source, callback, ...)
            event = ensure(event, 'unknown')
            source = ensure(source, 0)
            callback = ensure(callback, function() end)

            if (__clientCallbacks == nil) then __clientCallbacks = {} end
            if (__clientCallbacks[source] == nil) then
                __clientCallbacks[source] = { requestId = 1, callbacks = {} }
            end

            local requestId = __clientCallbacks[source].requestId

            __clientCallbacks[source].callbacks[requestId] = callback

            TriggerRemote('fiveux:triggerClientCallback', source, event, requestId, ...)

            if requestId < 65535 then
                __clientCallbacks[source].requestId = __clientCallbacks[source].requestId + 1
            else
                __clientCallbacks[source].requestId = 1
            end
        end

        env.requestClientInfo = function(event, source, ...)
            event = ensure(event, 'unknown')
            source = ensure(source, 0)

            local done, results = false, msgpack.pack(nil)

            env.requestClientInfoAsync(event, source, function(...)
                results = msgpack.pack(...)
                done = true
            end, ...)

            repeat Citizen.Wait(0) until done == true

            return msgpack.unpack(results)
        end
    end

    return env
end

--- Set all modules as global variable
---@param self bootable
---@param modules table List of modules
function bootable:setGlobalModules(modules)
    modules = ensure(modules, {})

    for i = 1, #modules, 1 do
        local module = ensure(modules[i], {})
        local m_name = ensure(module.name, 'unknown')
        local m_version = ensure(module.version, '1.0.0')
        local m_description = ensure(module.description, '')
        local m_required = ensure(module.required, false)
        local m_license = ensure(module.license, 'none')
        local m_client_scripts = ensure(module.client_scripts, {})
        local m_server_scripts = ensure(module.server_scripts, {})
        local m_shared_scripts = ensure(module.shared_scripts, {})
        local m_ui_page = ensure(module.ui_page, 'unknown')
        local m_dependencies = ensure(module.dependencies, {})
        local m_category = ensure(module.category, 'unknown')
        local m_category_description = ensure(module.category_description, '')
        local m_environment = self:createModuleEnvironment(m_category, m_name, m_version)

        ---@class module
        local __module = {
            loaded = false,
            failed = false,
            failed_message = nil,
            name = m_name,
            version = m_version,
            description = m_description,
            required = m_required,
            license = m_license,
            directory = ('modules/__%s__/%s/'):format(m_category, m_name),
            client_scripts = m_client_scripts,
            server_scripts = m_server_scripts,
            shared_scripts = m_shared_scripts,
            ui_page = m_ui_page,
            dependencies = m_dependencies,
            category = m_category,
            category_description = m_category_description,
            environment = m_environment,
            exports = setmetatable({}, {
                __newindex = function(t, k, v)
                    rawset(t, k, v)
                    rawset(__exports, k, v)
                end
            })
        }

        __modules[m_name] = __module
    end
end

--- Check if given module is executable
---@param self bootable
---@param module string Name of module
---@return boolean Module is executable
---@return boolean Module has failed
function bootable:moduleIsExecutable(module)
    module = ensure(module, 'unknown')

    if (__modules == nil or __modules[module] == nil) then
        return false, false
    end

    local m = ensure(__modules[module], {})
    local m_loaded = ensure(m.loaded, false)
    local m_dependencies = ensure(m.dependencies, {})

    if (m_loaded) then return false, false end
    if (#m_dependencies == 0) then return true, false end

    for i = 1, #m_dependencies, 1 do
        local d_name = ensure(m_dependencies[i], 'unknown')

        if (__modules[d_name] == nil) then
            __modules[module].failed = true
            __modules[module].failed_message = ('Module "~x~%s~s~" not found'):format(d_name)
            return false, true
        end

        if (module == d_name) then
            __modules[module].failed = true
            __modules[module].failed_message = ('Module "~x~%s~s~" refers to module itself'):format(d_name)
            return false, true
        end

        local dm = ensure(__modules[d_name], {})
        local dm_loaded = ensure(dm.loaded, false)
        local dm_failed = ensure(dm.failed, false)
        local dm_errMsg = ensure(dm.failed_message, '')

        if (not dm_loaded and dm_failed) then
            __modules[module].failed = true
            __modules[module].failed_message = ('Module "~x~%s~s~" throw an exception:\n%s'):format(d_name, dm_errMsg)
            return false, true
        end

        if (not dm_loaded and not dm_failed) then
            return false, false
        end
    end

    return true, false
end

--- Shutdown server because framework failed to load
---@param self bootable
---@param m_category string Name of category
---@param m_name string Name of module
function bootable:shutdown(m_category, m_name)
    local msg = ensure(__modules[m_name].failed_message, 'unknown')

    print_error(('Module "~x~%s~s~/~x~%s~s~" is required but throw an exception:\n%s'):format(m_category, m_name, msg), NAME)
    
    if (ENVIRONMENT == 'server') then
        print_info('Shutdown server because of critical exception')
        ExecuteCommand('quit')
    end
end

--- Load shared translation from `__sharedTranslations`
---@param key string Key of translation
---@return string Translated label or fallback
function bootable:T(key, ...)
    key = ensure(key, 'unknown')

    local translations = ensure(__sharedTranslations, {})
    local fallback = ('translation(%s/%s)'):format(NAME, key)
    local translation = ensure(translations[key], fallback)

    if (translation:len() <= 0) then translation = fallback end

    return translation:format(...)
end

--- Add a event to `__events`
---@param module string Name of module
---@param event string Name of event
---@param name string|table Name of entity / object / type etc.
---@param func function Function to execute when event is triggered
function bootable:onEvent(module, event, name, func)
    module = ensure(module, NAME)
    event = ensure(event, 'unknown')
    name = ensure(name, typeof(name) == 'table' and {} or 'unknown')
    func = ensure(func, function() end)

    if (typeof(name) == 'table') then
        for k, v in pairs(name) do
            self:onEvent(module, event, ensure(v, 'unknown'), func)
        end

        return
    end

    event = event:lower()
    name = name:lower()

    if (event == 'unknown') then return end
    if (__events == nil) then __events = {} end
    if (__events[event] == nil) then __events[event] = { funcs = {}, params = {} } end

    if (name == 'unknown') then
        table.insert(__events[event].funcs, {
            module = module,
            func = func
        })

        return
    end

    if (__events[event].params[name] == nil) then __events[event].params[name] = {} end

    table.insert(__events[event].params[name], {
        module = module,
        func = func
    })
end

--- Filter arguments based on type
--- @return function|nil Function to execute
--- @return string|table|nil Name or List to add trigger for
function bootable:filterEventArguments(...)
    local name, names, callback = nil, nil, nil
    local name_i, names_i, index = 999, 999, 0
    local arguments = { ... }

    for key, argument in pairs(arguments) do
        index = index + 1

        local type = typeof(argument)

        if (type == 'function' and callback == nil) then
            callback = argument
        elseif (type == 'table' and names == nil) then
            for k, v in pairs(argument) do
                local n = ensure(v, 'unknown')

                if (n ~= 'unknown') then
                    if (names == nil) then
                        names = {}
                        names_i = index
                    end

                    table.insert(names, n)
                end
            end
        elseif (name == nil) then
            local n = ensure(argument, 'unknown')

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

--- Returns a list of registered events
---@param event string Name of event
---@param name string|table Name of entity / object / type etc.
---@return table List of registered events
function bootable:getRegisteredEvents(event, name)
    event = ensure(event, 'unknown')
    name = ensure(name, 'unknown')

    if (event == 'unknown') then return {} end

    event = event:lower()
    name = name:lower()

    if (__events == nil or __events[event] == nil) then return {} end

    local results = {}
    local events = ensure(__events[event], {})
    local global_funcs = ensure(events.funcs, {})
    
    for k, v in pairs(global_funcs) do table.insert(results, v) end

    if (name == 'unknown') then
        return results
    end

    local named_funcs = ensure(events.params[name], {})

    for k, v in pairs(named_funcs) do table.insert(results, v) end

    return results
end

--- Register an event
---@param module string Name of module
---@param event string Name of event
function bootable:on(module, event, ...)
    event = ensure(event, 'unknown')
    module = ensure(module, NAME)

    local callback, name = self:filterEventArguments(...)

    if (callback == nil) then return end

    self:onEvent(module, event, name, callback)
end

--- Trigger event
---@param event string Name of event
---@param name string Name of object/entity/type etc.
function bootable:emit(event, name, ...)
    event = ensure(event, 'unknown')
    name = ensure(name, 'unknown')

    local events = self:getRegisteredEvents(event, name)
    local arguments = msgpack.pack(...)

    for k, v in pairs(events) do
        Citizen.CreateThread(function()
            local module = ensure(v.module, NAME)
            local func = ensure(v.func, function() end)

            try(function()
                func(msgpack.unpack(arguments))
            end, function(msg)
                return print_error(msg, module)
            end)
        end)
    end
end

--- Create a new `presentCard` object
---@param deferrals table Deferrals
---@param title string Title of current `presentCard`
---@param description string Description of current `presentCard`
---@param banner string Banner of current `presentCard`
---@return presentCard Generated `presentCard`
function bootable:createPresentCard(deferrals, title, description, banner)
    local cfg = self:loadConfiguration('general')
    local serverName = ensure(cfg.serverName, 'FiveUX Framework')
    local discordUrl = ensure(cfg.discordUrl, 'https://github.com/ThymonA/fiveux/')
    local bannerUrl = ensure(cfg.bannerUrl, 'https://i.imgur.com/C7iadzZ.png')

    title = ensure(title, self:T('card_title', serverName))
    description = ensure(description, self:T('card_description', serverName))
    banner = ensure(banner, bannerUrl)

    ---@class presentCard
    local presentCard = {
        title = title,
        description = description,
        banner = banner,
        deferrals = deferrals,
        serverName = serverName,
        bannerUrl = bannerUrl,
        discordUrl = discordUrl
    }

    --- Generate json based on current `presentCard`
    ---@return string Json data
    function presentCard:generate()
        local _serverName = ensure(self.serverName, 'FiveUX Framework')
        local _title = ensure(self.title, bootable:T('card_title', _serverName))
        local _description = ensure(self.description, bootable:T('card_description', _serverName))
        local _banner = ensure(self.bannerUrl, 'https://i.imgur.com/C7iadzZ.png')
        local _discordUrl = ensure(self.discordUrl, 'https://github.com/ThymonA/fiveux/')
        local card = {
            ['type'] = 'AdaptiveCard',
            ['body'] = {
                { type = "Image", url = _banner },
                { type = "TextBlock", size = "Medium", weight = "Bolder", text = _title, horizontalAlignment = "Center" },
                { type = "TextBlock", text = _description, wrap = true, horizontalAlignment = "Center" }
            },
            ['actions'] = {
                {
                    type = "Action.OpenUrl",
                    title = bootable:T('join_discord'),
                    url = _discordUrl,
                    iconUrl = "https://i.imgur.com/kI5A9ES.png",
                    style = "default"
                }
            },
            ['$schema'] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ['version'] = "1.3"
        }

        return encode(card)
    end

    --- Force to update current `presentCard` with `deferrals`
    function presentCard:update()
        local data = self:generate()
        
        return self.deferrals.presentCard(data)
    end

    --- Change `presentCard`'s title
    ---@param title string Title
    ---@param update boolean Update `presentCard` after title change
    function presentCard:setTitle(title, update)
        title = ensure(title, 'unknown')
        update = ensure(update, true)

        if (title == 'unknown') then title = nil end

        self.title = title

        if (update) then self:update() end
    end

    --- Change `presentCard`'s description
    ---@param description string Description
    ---@param update boolean Update `presentCard` after description change
    function presentCard:setDescription(description, update)
        description = ensure(description, 'unknown')
        update = ensure(update, true)

        if (description == 'unknown') then description = nil end

        self.description = description

        if (update) then self:update() end
    end

    --- Change `presentCard`'s banner
    ---@param banner string Banner
    ---@param update boolean Update `presentCard` after banner change
    function presentCard:setBanner(banner, update)
        banner = ensure(banner, 'unknown')
        update = ensure(update, true)

        if (banner == 'unknown') then banner = nil end

        self.banner = banner

        if (update) then self:update() end
    end

    --- Reset current `presentCard` to default title, description and banner
    ---@param update boolean Update `presentCard` after reset
    function presentCard:reset(update)
        update = ensure(update, true)

        self.title = nil
        self.description = nil
        self.banner = nil

        if (update) then self:update() end
    end

    --- Override current `presentCard` by your own
    ---@param card string Json data
    function presentCard:override(card, ...)
        self.deferrals.presentCard(card, ...)
    end

    presentCard:update()

    return presentCard
end

--- Create a nui object for given module
---@param module module
function bootable:createNUI(module)
    local ui_page = ensure(module.ui_page, 'unknown')

    if (ui_page == 'unknown') then return end

    ---@class nui
    local nui = {
        name = ('%s:%s:%s'):format(module.category, module.name, ui_page),
        url = ('https://cfx-nui-%s/modules/__%s__/%s/%s'):format(RESOURCE_NAME, module.category, module.name, ui_page),
        loaded = false,
        destroyed = false,
        visible = false,
        focus = false,
        cursor = false
    }

    function nui:sendMessage(info, internal)
        internal = ensure(internal, false)

        while not __nuiLoaded do Citizen.Wait(0) end

        if (internal) then
            local data = ensure(info, {})

            data.source = '__fxinternal'

            return SendNUIMessage(data)
        end

        while not self.loaded do Citizen.Wait(0) end

        local data = {}

        data.target = ensure(self.name, 'unknown')
        data.data = ensure(info, {})

        return SendNUIMessage(data)
    end

    function nui:show()
        while not __nuiLoaded do Citizen.Wait(0) end
        while not self.loaded do Citizen.Wait(0) end

        self.visible = true
        self:sendMessage({ action = 'show_frame', name = self.name }, true)
    end

    function nui:hide()
        while not __nuiLoaded do Citizen.Wait(0) end
        while not self.loaded do Citizen.Wait(0) end

        self.visible = false
        self.focus = false
        self.cursor = false
        self:sendMessage({ action = 'hide_frame', name = self.name }, true)
    end

    function nui:_focus()
        while not __nuiLoaded do Citizen.Wait(0) end
        while not self.loaded do Citizen.Wait(0) end

        self.focus = true
        self:sendMessage({ action = 'focus_frame', name = self.name }, true)
    end

    function nui:destroy()
        while not __nuiLoaded do Citizen.Wait(0) end
        while not self.loaded do Citizen.Wait(0) end

        self.loaded = false
        self.destroyed = true
        self.visible = false
        self.focus = false
        self.cursor = false
        self:sendMessage({ action = 'destroy_frame', name = self.name }, true)
    end

    function nui:create()
        while not __nuiLoaded do Citizen.Wait(0) end

        self.loaded = ensure(self.loaded, false)
        self.destroyed = false
        self.visible = true
        self.focus = false
        self.cursor = false
        self:sendMessage({ action = 'create_frame', name = self.name, url = self.url, visible = self.visible }, true)
    end

    __nui_pages[nui.name] = nui
    __nuiFocus[nui.name] = { false, false }

    Citizen.CreateThread(function()
        local name = ensure(nui.name, 'unknown')

        while not __nuiLoaded do Citizen.Wait(0) end

        if (__nui_pages == nil or __nui_pages[name] == nil) then return end

        __nui_pages[name]:create()
    end)
end

--- Load all modules
---@param self bootable
function bootable:init()
    local generalConfig = ensure(self:loadConfiguration('general'), {})
    local primaryIdentifier = ensure(generalConfig.primaryIdentifier, 'license')

    if (not any(primaryIdentifier, constants.identifierTypes, 'value')) then
        primaryIdentifier = 'license'
    end

    _G.PRIMARY = primaryIdentifier

    __sharedTranslations = self:loadTranslations()

    local modules = self:getAllModules()

    __exports['modules'] = modules

    self:setGlobalModules(modules)

    if (modules == nil or #modules == 0) then return end

    local remaining = #modules
    local results = {}

    if (ENVIRONMENT == 'client') then
        __exports['SendNUI'] = function(data)
            data = ensure(data, {})
            data.source = '__fxinternal'

            return SendNUIMessage(data)
        end
    end

    for i = 1, #modules, 1 do
        Citizen.CreateThread(function()
            local raw_module = ensure(modules[i], {})
            local raw_name = ensure(raw_module.name, 'unknown')
            local module = ensure(__modules[raw_name], {})
            local m_name = ensure(module.name, 'unknown')

            if (ENVIRONMENT == 'client') then
                bootable:createNUI(module)
            end

            local function m_func()
                local m_category = ensure(module.category, 'unknown')
                local m_directory = ensure(module.directory, 'unknown')
                local m_required = ensure(module.required, false)
                local m_env = ensure(module.environment, {})
                local m_shared_scripts = ensure(module.shared_scripts, {})
                local m_env_scripts = {}
                local m_translations = {}
                local m_module_translations = self:loadTranslations(m_category, m_name)

                for k, v in pairs(__sharedTranslations) do m_translations[k] = v end
                for k, v in pairs(m_module_translations) do m_translations[k] = v end

                m_env.__translations = m_translations

                if (__modules[m_name].loaded) then
                    return true
                end

                local executable, hasFailed = self:moduleIsExecutable(m_name)

                if (hasFailed and m_required) then
                    self:shutdown(m_category, m_name)
                    return true
                end

                if (hasFailed) then
                    return true
                end

                if (not executable) then
                    Citizen.Wait(25)
                    return m_func()
                end

                if (ENVIRONMENT == 'server') then m_env_scripts = ensure(module.server_scripts, {}) end
                if (ENVIRONMENT == 'client') then m_env_scripts = ensure(module.client_scripts, {}) end

                for i2 = 1, #m_shared_scripts, 1 do
                    local ms_script = ensure(m_shared_scripts[i2], 'unknown')
                    local ms_path = ('%s/%s'):format(m_directory, ms_script)
                    local ms_data = LoadResourceFile(RESOURCE_NAME, ms_path)

                    if (ms_data == nil) then
                        __modules[m_name].failed = true
                        __modules[m_name].failed_message = ('File "~x~%s~s~" not found'):format(ms_script)
                        return true
                    end

                    local fn, err = load(ms_data, ('fiveux:%s:%s:%s'):format(m_category, m_name, ms_script), 't', m_env)

                    if (fn) then
                        local ok = xpcall(fn, function(err)
                            __modules[m_name].failed = true
                            __modules[m_name].failed_message = err
                        end)

                        while ok == nil do Citizen.Wait(0) end

                        if (not ok) then
                            __modules[m_name].failed = true
                            return true
                        end
                    else
                        __modules[m_name].failed = true
                        __modules[m_name].failed_message = err
                        return true
                    end

                    if (__modules[m_name].failed and m_required) then
                        self:shutdown(m_category, m_name)
                        return true
                    end
                end

                for i2 = 1, #m_env_scripts, 1 do
                    local me_script = ensure(m_env_scripts[i2], 'unknown')
                    local me_path = ('%s/%s'):format(m_directory, me_script)
                    local me_data = LoadResourceFile(RESOURCE_NAME, me_path)

                    if (me_data == nil) then
                        __modules[m_name].failed = true
                        __modules[m_name].failed_message = ('File "~x~%s~s~" not found'):format(me_script)
                        return true
                    end

                    local fn, err = load(me_data, ('fiveux:%s:%s:%s'):format(m_category, m_name, me_script), 't', m_env)

                    if (fn) then
                        local ok = xpcall(fn, function(err)
                            __modules[m_name].failed = true
                            __modules[m_name].failed_message = err
                        end)

                        while ok == nil do Citizen.Wait(0) end

                        if (not ok) then
                            __modules[m_name].failed = true
                            return true
                        end
                    else
                        __modules[m_name].failed = true
                        __modules[m_name].failed_message = err
                        return true
                    end

                    if (__modules[m_name].failed and m_required) then
                        self:shutdown(m_category, m_name)
                        return true
                    end
                end

                if (__modules[m_name].failed and m_required) then
                    self:shutdown(m_category, m_name)
                    return true
                end

                return true
            end

            local done = m_func()

            while done == nil or not done do Citizen.Wait(0) end

            if (not __modules[m_name].failed) then
                __modules[m_name].loaded = true
            end

            remaining = remaining - 1
        end)
    end

    Citizen.CreateThread(function()
        while remaining > 0 do
            Citizen.Wait(50)
        end

        local errorCount = 0
        local errorMessages = ''

        for _, module in pairs(__modules) do
            local m = ensure(module, {})
            local failed = ensure(m.failed, false)
            local required = ensure(m.required, false)

            if (failed) then
                local m_name = ensure(m.name, 'unknown')
                local m_category = ensure(m.category, 'unknown')
                local m_errMsg = ensure(m.failed_message, 'unknown')

                if (required) then
                    self:shutdown(m_category, m_name)
                    return
                end

                errorCount = errorCount + 1
                errorMessages = ('%s\n~x~> ~s~%s'):format(errorMessages, ('[~x~%s~s~] %s'):format(m_name, m_errMsg))
            end
        end

        if (errorCount == 0) then
            print_success('FiveUX framework has been loaded!', NAME)
        else
            print_error(('FiveUX framework has been loaded with exceptions: %s'):format(errorMessages), NAME)
        end

        if (ENVIRONMENT == 'server' and __exports ~= nil and __exports.logs ~= nil) then
            local logs = ensure(__exports.logs, {})
            local logger = logs:create('module', 'global')
            
            if (logger ~= nil) then
                logger:log({
                    action = 'system.started',
                    color = constants.colors.green,
                    message = 'FiveUX framework has been loaded!',
                    title = 'FiveUX framework started',
                    username = 'FiveUX framework'
                })
            end
        end

        if (ENVIRONMENT == 'server') then
            ---@type ratelimits
            local ratelimits = bootable:loadExport('ratelimits')

            if (ratelimits ~= nil) then
                ratelimits:addEvent('playerJoining', function()
                    local playerSrc = ensure(source, 0)
                    local players = bootable:loadExport('players')
            
                    if (players == nil or playerSrc <= 0) then return end

                    ---@type player
                    local player = players:loadBySource(playerSrc)

                    if (player == nil or player.identifier == nil or player.identifier == 'unknown') then return end

                    bootable:emit('playerJoining', nil, player, playerSrc)
                end, 0, 1)

                ratelimits:addEvent('playerJoined', function()
                    local playerSrc = ensure(source, 0)
                    local players = bootable:loadExport('players')
            
                    if (players == nil or playerSrc <= 0) then return end

                    ---@type player
                    local player = players:loadBySource(playerSrc)

                    if (player == nil or player.identifier == nil or player.identifier == 'unknown') then return end

                    player:log({
                        action = 'connection.joined',
                        color = constants.colors.green,
                        message = bootable:T('joined_player', player.name, player.fxid, player.identifier, playerSrc),
                        title = bootable:T('joined_player_title'),
                        arguments = { source = playerSrc }
                    })

                    bootable:emit('playerJoined', nil, player, playerSrc)
                end, 0, 1)
            end
        end

        __loaded = true
    end)
end

if (ENVIRONMENT == 'client') then
    --- Returns if given control is pressed
    ---@param name string Name of control
    ---@return boolean Control is pressed
    function bootable:isControlPressed(name)
        name = ensure(name, 'unknown')

        if (name == 'unknown') then return false end

        name = name:replace(' ', '')
        name = name:lower()

        __keyPressed = ensure(__keyPressed, {})

        return ensure(__keyPressed[name], false)
    end

    --- Returns if given control is pressed
    ---@param name string Name of control
    ---@return boolean Control is pressed
    function bootable:isControlJustPressed(name)
        name = ensure(name, 'unknown')

        if (name == 'unknown') then return false end

        name = name:replace(' ', '')
        name = name:lower()

        __keyPressed = ensure(__keyPressed, {})
        __keyPressedTimes = ensure(__keyPressedTimes, {})

        local pressed = ensure(__keyPressed[name], false)
        local currentTimer = GetGameTimer()
        local timer = ensure(__keyPressedTimes[name], 0)
        local difference = currentTimer - timer

        return difference > 0 and difference < 10 and pressed
    end

    --- Returns if given control is released
    ---@param name string Name of control
    ---@return boolean Control is released
    function bootable:isControlReleased(name)
        name = ensure(name, 'unknown')

        if (name == 'unknown') then return true end

        name = name:replace(' ', '')
        name = name:lower()

        __keyPressed = ensure(__keyPressed, {})

        return not ensure(__keyPressed[name], false)
    end

    --- Register new keybind
    ---@param module string Name of module
    ---@param name string Name of keybind
    ---@param description string Description of keybind
    ---@param type string Default key mapper ID
    ---@param default string Default key
    function bootable:registerKeybind(module, name, description, type, default)
        module = ensure(module, NAME)
        name = ensure(name, 'unknown')
        description = ensure(description, self:T('default_key_description', module, name))
        type = ensure(type, 'keyboard'):upper()
        default = ensure(default, 'e'):upper()

        if (not any(type, constants.mapperIds, 'value')) then
            print_warning(('Key mapper id doesn\'t exists (%s)'):format(type), module)
            return
        end

        __keyPressed[name] = false
        __keyPressedTimes[name] = 0

        RegisterKeyMapping(('+%s'):format(name), description, type, default)
        RegisterCommand(('+%s'):format(name), function()
            __keyPressed[name] = true
            __keyPressedTimes[name] = GetGameTimer()
        end)
        RegisterCommand(('-%s'):format(name), function()
            __keyPressed[name] = false
            __keyPressedTimes[name] = GetGameTimer()
        end)
    end

    RegisterNUICallback('nui_ready', function(info, callback)
        info = ensure(info, {})
        callback = ensure(callback, function() end)
        
        __nuiLoaded = true
        
        callback('ok')
    end)

    RegisterNUICallback('frame_load', function(info, callback)
        info = ensure(info, {})
        callback = ensure(callback, function() end)

        local name = ensure(info.name, 'unknown')

        if (__nui_pages == nil or __nui_pages[name] == nil) then
            callback('ok')
            return
        end

        __nui_pages[name].loaded = true

        callback('ok')
    end)

    RegisterNUICallback('frame_message', function(info, callback)
        info = ensure(info, {})
        callback = ensure(callback, function() end)

        local event = ensure(info.event, 'unknown')
        local name = ensure(info.name, 'unknown')
        local message = ensure(info.msg, {})

        if (__nuiCallbacks == nil) then __nuiCallbacks = {} end
        if (__nuiCallbacks[name] == nil) then __nuiCallbacks[name] = {} end

        if (__nuiCallbacks[name][event] ~= nil) then
            return __nuiCallbacks[name][event](message, callback)
        end
        
        callback('ok')
    end)

    --- Handles `SetNuiFocus`
    Citizen.CreateThread(function()
        while true do
            local __hasFocus = false
            local __hasCursor = false

            if (__nuiFocus == nil) then __nuiFocus = {} end
            
            for nui_key, focus in pairs(__nuiFocus) do
                nui_key = ensure(nui_key, 'unknown')
                focus = ensure(focus, {})

                local hasFocus = ensure(focus[1], false)
                local hasCursor = ensure(focus[2], false)

                if (hasCursor) then __hasCursor = true end
                if (hasFocus) then
                    __hasFocus = true

                    if (__nui_pages ~= nil or __nui_pages[nui_key] ~= nil) then
                        __nui_pages[nui_key]:_focus()
                    end
                end
            end

            SetNuiFocus(__hasFocus, __hasCursor)

            if (not __hasFocus) then
                SendNUIMessage({ action = 'reset_focus', source = '__fxinternal' });
            end

            Citizen.Wait(25)
        end
    end)
end

if (ENVIRONMENT == 'server') then
    RegisterEvent('playerConnecting', function(_, _, deferrals)
        deferrals.defer()

        local card = bootable:createPresentCard(deferrals)
        local playerSrc = ensure(source, 0)

        if (not __loaded) then
            deferrals.done(bootable:T('framework_not_loaded'))
        end

        local players = bootable:loadExport('players')
        
        if (players ~= nil and playerSrc > 0) then
            players:updatePlayerBySource(playerSrc)
        end

        ---@type player
        local player = players:loadBySource(playerSrc)

        if (player == nil or player.identifier == nil or player.identifier == 'unknown') then
            deferrals.done(bootable:T(('identifier_%s_required'):format(PRIMARY)))
        end

        local events = bootable:getRegisteredEvents('playerConnecting')

        if (#events <= 0) then
            deferrals.done()
            return
        end

        for _, event in pairs(events) do
            local continue, canConnect, rejectMessage = false, false, nil

            card:reset()

            local module = ensure(event.module, NAME)
            local func = ensure(event.func, function(_, done, _) done() end)
            local ok = xpcall(func, function(msg) return print_error(msg, module) end, player, function(msg)
                msg = ensure(msg, '')
                canConnect = msg:len() <= 0

                if (not canConnect) then
                    rejectMessage = msg
                end

                continue = true
            end, card)

            repeat Citizen.Wait(0) until continue == true

            if (not ok) then
                canConnect = false
                rejectMessage = ensure(rejectMessage, T('connecting_error'))
            end

            if (not canConnect) then
                deferrals.done(rejectMessage)
                return
            end
        end

        player:log({
            action = 'connection.connecting',
            color = constants.colors.blue,
            message = bootable:T('connecting_player', player.name, player.fxid, player.identifier, player.identifiers.ip),
            title = bootable:T('connecting_player_title')
        })

        deferrals.done()
    end)

    RegisterEvent('playerDropped', function(reason)
        reason = ensure(reason, bootable:T('no_reason'))

        local playerSrc = ensure(source, 0)
        local players = bootable:loadExport('players')
        
        if (players == nil or playerSrc <= 0) then return end

        ---@type player
        local player = players:loadBySource(playerSrc)

        if (player == nil or player.identifier == nil or player.identifier == 'unknown') then return end

        player:log({
            action = 'connection.disconnected',
            color = constants.colors.red,
            message = bootable:T('disconnected_player', player.name, player.fxid, player.identifier, reason),
            title = bootable:T('disconnected_player_title'),
            arguments = { reason = reason }
        })

        bootable:emit('playerDropped', nil, player, playerSrc, reason)
    end)

    MarkEventAsGlobal('fiveux:status')
    RegisterEvent('fiveux:status', function()
        local playerSrc = ensure(source, 0)
        
        TriggerRemote('fiveux:status', playerSrc, ensure(__loaded, false))
    end)

    MarkEventAsGlobal('playerSpawned')
    RegisterEvent('playerSpawned', function()
        local playerSrc = ensure(source, 0)
        local players = bootable:loadExport('players')
        
        if (players == nil or playerSrc <= 0) then return end

        ---@type player
        local player = players:loadBySource(playerSrc)

        if (player == nil or player.identifier == nil or player.identifier == 'unknown') then return end

        bootable:emit('playerSpawned', nil, player, playerSrc)
    end)

    MarkEventAsGlobal('fiveux:triggerClientCallback')
    RegisterEvent('fiveux:triggerClientCallback', function(requestId, ...)
        local requestId = ensure(requestId, 0)
        local source = ensure(source, 0)

        if (__clientCallbacks == nil) then __clientCallbacks = {} end
        if (__clientCallbacks[source] == nil) then
            __clientCallbacks[source] = { requestId = 1, callbacks = {} }
        end
        if (__clientCallbacks[source].callbacks == nil or
            __clientCallbacks[source].callbacks[requestId] == nil) then return end

        __clientCallbacks[source].callbacks[requestId](...)
        __clientCallbacks[source].callbacks[requestId] = nil
    end)
end

--- Execute this function to start framework
local function bootFramework()
    Citizen.CreateThread(function()
        bootable:init()
    end)
end

--- Checks if framework has loaded
---@return boolean Framework loaded
_G.FrameworkLoaded = function()
    return ensure(__loaded, false)
end

--- Load export
---@param name string Name of export
---@return any Returns nil or founded export
_G.GetExport = function(name, ...)
    name = ensure(name, 'unknown')

    if (__exports == nil or __exports[name] == nil) then
        return nil
    end

    if (typeof(__exports[name]) == 'function') then
        return __exports[name](...)
    else
        return __exports[name]
    end

    return nil
end

--- Load configuration
---@param name string Name of configuration
---@return table Founded configuration
_G.GetConfiguration = function(name)
    name = ensure(name, 'unknown')

    return bootable:loadConfiguration(name)
end

_G.GetClientCallbacks = function()
    return __clientCallbacks
end

--- Start framework
bootFramework()