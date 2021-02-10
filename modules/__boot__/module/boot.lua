_G.RESOURCE_NAME = ensure(GetCurrentResourceName(), 'fiveux')
_G.ENVIRONMENT = IsDuplicityVersion() and 'server' or 'client'
_G.__NAME__ = 'global'

boot = {}

function boot:loaded()
    if (cache:exists('boot:loaded')) then
        return true
    end

    return false
end

function boot:load()
    if (self:loaded()) then return end

    local categories = self:getCategories()
    
    for _, category in pairs(categories) do
        local modules = self:getCategoryModules(category)

        for _, module in pairs(modules) do
            self:startModule(category, module)
        end
    end

    debug:info(__NAME__, 'Framework loaded!')
    cache:write('boot:loaded', true, true)
end

function boot:getCategories()
    local key = 'boot:categories'

    if (cache:exists(key)) then
        return cache:read(key)
    end

    local raw = ensure(LoadResourceFile(RESOURCE_NAME, 'modules/categories.json'), '[]')
    local data = ensure(json.decode(raw), {})

    cache:write(key, data, true)

    return data
end

function boot:getCategoryModules(category)
    category = ensure(category, 'unknown')

    if (category == 'unknown') then return {} end

    local key = ('boot:%s:modules'):format(category)

    if (cache:exists(key)) then
        return cache:read(key)
    end

    local categories = self:getCategories()

    if (not any(category, categories, 'value')) then
        return {}
    end

    local raw = ensure(LoadResourceFile(RESOURCE_NAME, ('modules/%s/modules.json'):format(category)), '[]')
    local data = ensure(json.decode(raw), {})

    cache:write(key, data, true)

    return data
end

function boot:getModuleInfo(category, module)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')

    if (category == 'unknown' or module == 'unknown') then return {} end

    local key = ('boot:%s:%s:info'):format(category, module)

    if (cache:exists(key)) then
        return cache:read(key)
    end

    local modules = self:getCategoryModules(category)

    if (not any(module, modules, 'value')) then
        return {}
    end

    local raw = ensure(LoadResourceFile(RESOURCE_NAME, ('modules/%s/%s/module.json'):format(category, module)), '[]')
    local data = ensure(json.decode(raw), {})

    cache:write(key, data, true)

    return data
end

function boot:startModule(category, module)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')

    debug:info(__NAME__, ("Starting module '%s'"):format(module))

    try(function()
        local env = environment:create(category, module, ('modules/%s/%s'):format(category, module))
        local moduleInfo = self:getModuleInfo(category, module)
        local sharedFiles = ensure(moduleInfo.shared, {})
        local envFiles = ensure(moduleInfo[ENVIRONMENT], {})

        for k, v in pairs(sharedFiles) do
            self:executeFile(category, module, v, env)
        end

        for k, v in pairs(envFiles) do
            self:executeFile(category, module, v, env)
        end
    end, function(e)
        print_error(e, module)
    end)
end

function boot:executeFile(category, module, file, env)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')
    file = ensure(file, 'unknown')
    env = ensure(env, {})

    if (category == 'unknown' or module == 'unknown') then return false end

    local directory = ensure(env.__DIRECTORY__, file)
    local file_path =  ('%s/%s'):format(directory, file)
    local file_data = LoadResourceFile(RESOURCE_NAME, file_path)

    if (file_data == nil) then return false end

    debug:info(module, ("Executing file '%s'"):format(file))

    local fn = load(file_data, ('@%s:%s:%s/%s'):format(RESOURCE_NAME, category, module, file), 't', env)

    if (fn) then
        local ok = xpcall(fn, function(err)
            print_error(("Failed to load file '%s': %s"):format(file, err), module)
        end)

        if (ok) then
            return true
        else
            print_error(("Failed to load file '%s'"):format(file), module)
            return false
        end
    else
        print_error(("Failed to load file '%s'"):format(file), module)
        return false
    end
end

Citizen.CreateThread(function()
    debug:info(__NAME__, 'Starting FiveUX Framework....')
    boot:load()
end)