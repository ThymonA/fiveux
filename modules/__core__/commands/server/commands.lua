using 'players'
using 'logging'

local data = {}

commands = {}

local function getCommand(raw)
    while (raw:startsWith('/')) do
        raw = raw:sub(2)
    end

    local arguments = ensureStringList(raw:split(' '))

    return ensure(arguments[1], '')
end

local function execute(source, arguments, raw)
    source = ensure(source, 0)
    arguments = ensure(arguments, {})

    local name = getCommand(raw)
    
    if (data[name]) then
        local cmd = ensure(data[name], {})
        local player = players:get(source)

        if (source == 0 and not cmd.console) then
            print_error(T('console_not_allowed', name))
            return
        end

        if (not player:allowed(('cmd.%s'):format(name))) then
            player:error(T('player_not_allowed', name))
            return
        end

        try(function()
            cmd.func(player, table.unpack(arguments))
        end, print_error)

        local logger = logging:get(player)

        if (logger == nil) then
            return
        end

        logger:log({
            action = 'command.executed',
            arguments = arguments,
            discord = false
        })
    end
end

function commands:register(name, whitelist, callback)
    name = ensure(name, 'unknown')
    whitelist = ensure(whitelist, {})
    callback = ensure(callback, function() end)

    if (name == 'unknown') then
        return
    end

    if (data[name]) then
        local jobs = ensure(data[name].jobs, {})
        local groups = ensure(data[name].groups, {})

        for i = 1, #jobs, 1 do
            ExecuteCommand(('remove_principal job.%s cmd.%s'):format(ensure(jobs[i], 'unemployed'), name))
        end

        for i = 1, #groups, 1 do
            ExecuteCommand(('remove_principal group.%s cmd.%s'):format(ensure(groups[i], 'user'), name))
        end
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

    local ace = ('cmd.%s'):format(name)

    for i = 1, #command.jobs, 1 do
        ExecuteCommand(('add_principal job.%s cmd.%s'):format(ensure(command.jobs[i], 'unemployed'), name))
    end

    for i = 1, #command.groups, 1 do
        ExecuteCommand(('add_principal group.%s cmd.%s'):format(ensure(command.groups[i], 'user'), name))
    end

    debug(("Register command '~x~%s~s~' for module '~x~%s~s~'"):format(command.name, command.module))

    RegisterCommand(name, execute)
end

register('commands', commands)