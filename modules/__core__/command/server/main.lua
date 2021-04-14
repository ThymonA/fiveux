import 'players'

--- Local storage
---@type table<string, command>
local data = {}

---@class commands
commands = {}

--- Register a command
---@param name string Name of command
---@param whitelist table Whitelist of command
---@param blacklist table Blacklist of command
---@param callback function Callback to execute
function commands:add(name, whitelist, blacklist, callback)
    name = ensure(name, 'unknown'):replace(' ', '_')
    whitelist = ensureWhitelist(whitelist)
    blacklist = ensureWhitelist(blacklist)
    callback = ensure(callback, function() end)

    ---@class command
    local command = {
        name = name,
        whitelist = whitelist,
        blacklist = blacklist,
        callback = callback
    }

    --- Checks if player is allowed to execute command
    ---@param source number Player source ID
    ---@return boolean Player is allowed to execute command
    function command:allowed(source)
        source = ensure(source, 0)

        if (source <= 0) then return false end

        return IsPlayerAceAllowed(source, ('command.%s'):format(self.name))
    end

    if (data == nil) then data = {} end
    if (data[name] ~= nil) then
        local prevCommand = ensure(data[name], {})
        local prevWhitelist = ensure(prevCommand.whitelist, {})
        local prevBlacklist = ensure(prevCommand.blacklist, {})

        --- Remove command permissions
        self:removePermissions(name, prevWhitelist, 'allow')
        self:removePermissions(name, prevBlacklist, 'deny')
    end

    --- Set command permissions
    self:addPermissions(name, whitelist, 'allow')
    self:addPermissions(name, blacklist, 'deny')

    data[name] = command

    RegisterCommand(name, function(source, args, raw)
        source = ensure(source, 0)
        args = ensure(args, {})

        local cmd = ensure(name, 'unknown'):replace(' ', '_')
        local command = ensure(data[cmd], {}, true)

        if (command == nil) then return end

        local player = players:loadBySource(source)

        if (not command:allowed(source) or player == nil) then return end

        player:log({
            arguments = { command = cmd, args = args },
            action = 'command.execute',
            logDiscord = false
        })

        xpcall(command.callback, print_error, table.unpack(args))
    end)
end

--- Add command permissions based on given `list` and `type`
---@param name string Command
---@param list table List of permissions
---@param type string Type like: `allow` and `deny`
function commands:addPermissions(name, list, type)
    name = ensure(name, 'unknown'):replace(' ', '_')
    list = ensureWhitelist(list)
    type = ensure(type, 'allow'):lower()

    if (isWhitelistAll(list)) then
        if (type == 'allow') then
            ExecuteCommand(('add_ace builtin.everyone command.%s %s'):format(name, type))
        end
    else
        for _, group in pairs(list.groups) do
            ExecuteCommand(('add_ace group.%s command.%s %s'):format(group, name, type))
        end

        for _, job in pairs(list.jobs) do
            ExecuteCommand(('add_ace job.%s command.%s %s'):format(job, name, type))
        end
    end
end

--- Remove command permissions based on given `list` and `type`
---@param name string Command
---@param list table List of permissions
---@param type string Type like: `allow` and `deny`
function commands:removePermissions(name, list, type)
    name = ensure(name, 'unknown'):replace(' ', '_')
    list = ensureWhitelist(list)
    type = ensure(type, 'allow'):lower()

    if (isWhitelistAll(list)) then
        if (type == 'allow') then
            ExecuteCommand(('remove_ace builtin.everyone command.%s %s'):format(name, type))
        end
    else
        for _, group in pairs(list.groups) do
            ExecuteCommand(('remove_ace group.%s command.%s %s'):format(group, name, type))
        end

        for _, job in pairs(list.jobs) do
            ExecuteCommand(('remove_ace job.%s command.%s %s'):format(job, name, type))
        end
    end
end

--- Export commands
export('commands', commands)