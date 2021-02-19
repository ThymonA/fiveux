m('players')
m('logging')

local data = {}

commands = {}

local function getCommand(raw)
    while (raw:startsWith('/')) do
        raw = raw:sub(2)
    end

    local arguments = ensureStringList(raw:split(' '))

    return ensure(arguments[1], '')
end

function commands:register(name, whitelist, callback)
    name = ensure(name, 'unknown')
    whitelist = ensure(whitelist, {})
    callback = ensure(callback, function() end)

    if (name == 'unknown') then
        return
    end

    local command = {
        name = name,
        groups = ensureStringList(whitelist.groups),
        jobs = ensureStringList(whitelist.jobs),
        console = ensure(whitelist.console, true),
        func = callback,
        module = getInvokingModule()
    }

    data[name] = command

    debug(("Register command '~x~%s~s~' for module '~x~%s~s~'"):format(command.name, command.module))

    RegisterCommand(name, function(source, arguments, raw)
        source = ensure(source, 0)
        arguments = ensure(arguments, {})

        local name = getCommand(raw)
        
        if (data[name]) then
            local cmd = ensure(data[name], {})
            local player = players:load(source)

            if (source == 0 and not console) then
                print_error(T('console_not_allowed', name))
                return
            end

            try(function()
                cmd.func(player, msgpack.unpack(arguments))
            end, print_error)

            local logger = logging:create(source)

            logger:log({
                action = 'command.executed',
                arguments = arguments,
                discord = false
            })
        end
    end)
end

register('commands', commands)