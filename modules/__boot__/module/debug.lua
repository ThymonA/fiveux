debug = {}

function debug:info(module, ...)
    module = ensure(module, 'general')

    local cfg = config:load('general')
    local args = { ... }
    local message = ('^1> ^6debug^7(^6%s^7/^6%s^7):'):format(ENVIRONMENT, module)
    local enabled = ensure(cfg.debugEnabled, false)

    if (not enabled) then return end

    for i = 1, #args, 1 do
        message = ('%s %s'):format(message, ensure(args[i], typeof(args[i])))
    end

    message = ('%s^7'):format(message)

    print(message)
end