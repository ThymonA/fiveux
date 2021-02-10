local data = {}

config = {}

function config:load(module)
    module = ensure(module, 'general')

    if (data == nil) then data = {} end
    if (data[module] ~= nil) then return data[module] end

    local shared_path = ('configs/%s/shared.config.lua'):format(module)
    local config_path = ('configs/%s/%s.config.lua'):format(module, ENVIRONMENT)
    local env = self:createEnvironment()
    local shared_data = LoadResourceFile(RESOURCE_NAME, shared_path)
    local config_data = LoadResourceFile(RESOURCE_NAME, config_path)

    if (shared_data ~= nil) then
        local fn = load(shared_data, ('configs:shared:%s'):format(module), 't', env)

        if (fn) then
            local ok = xpcall(fn, function(err)
                print_error(('Failed to load config (shared/%s): %s'):format(module, err), 'config')
            end)
        end
    end

    if (config_data ~= nil) then
        local fn = load(config_data, ('configs:%s:%s'):format(ENVIRONMENT, module), 't', env)

        if (fn) then
            local ok = xpcall(fn, function(err)
                print_error(('Failed to load config (%s/%s): %s'):format(ENVIRONMENT, module, err), 'config')
            end)
        end
    end

    local configuration = ensure(env.config, {})

    data[module] = configuration

    return configuration
end

function config:createEnvironment()
    local env = {}

    for k, v in pairs(_G) do env[k] = v end
    for k, v in pairs(_ENV) do env[k] = v end

    env.config = {}

    return env
end