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

--- Bootable class
---@class bootable
---
local bootable = {}
local __modules = {}
local __exports = {}
local __configs = {}
local __translations = {}
local __sharedTranslations = {}
local __loaded = false

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
    category = ensure(category, 'global')
    module = ensure(module, 'unknown')
    version = ensure(version, '1.0.0')

    local env = self:createEnvironment({
        NAME = module,
        MODULE = module,
        CATEGORY = category,
        VERSION = version,
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
        end
    })

    env.import = function(name, ...)
        name = ensure(name, 'unknown')

        if (__exports == nil or __exports[name] == nil) then
            print_warning(('Module "~x~%s~s~" not found'):format(name), module)
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
        local fallback = ('translation(%s/%s)'):format(module, key)
        local translation = ensure(translations[key], fallback)

        if (translation:len() <= 0) then translation = fallback end

        return translation:format(...)
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
        local m_dependencies = ensure(module.dependencies, {})
        local m_category = ensure(module.category, 'unknown')
        local m_category_description = ensure(module.category_description, '')
        local m_environment = self:createModuleEnvironment(m_category, m_name, m_version)

        __modules[m_name] = {
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

    if (#modules == 0) then return end

    local remaining = #modules
    local results = {}

    for i = 1, #modules, 1 do
        Citizen.CreateThread(function()
            local raw_module = ensure(modules[i], {})
            local raw_name = ensure(raw_module.name, 'unknown')
            local module = ensure(__modules[raw_name], {})
            local m_name = ensure(module.name, 'unknown')

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

        __loaded = true
    end)
end

--- Execute this function to start framework
local function bootFramework()
    Citizen.CreateThread(function()
        bootable:init()
    end)
end

--- Prevent players to connect when framework hasn't been loaded
if (ENVIRONMENT == 'server') then
    AddEventHandler('playerConnecting', function(_, _, deferrals)
        deferrals.defer()

        local playerSrc = ensure(source, 0)

        if (not __loaded) then
            deferrals.done(bootable:T('framework_not_loaded'))
        end

        local players = bootable:loadExport('players')
        
        if (players ~= nil and playerSrc > 0) then
            players:updatePlayerBySource(playerSrc)
        end

        local player = players:loadBySource(playerSrc)

        if (player == nil or player.identifier == nil or player.identifier == 'unknown') then
            deferrals.done(bootable:T(('identifier_%s_required'):format(PRIMARY)))
        end

        deferrals.done()
    end)
end

--- Start framework
bootFramework()