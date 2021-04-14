--- Default values
local default_vector3 = vec(0, 0, 0)
local default_vector4 = vec(0, 0, 0, 0)

--- Local storage
local id = 0
---@type table<number, marker>
local data = {}

---@class markers
markers = {}

--- Add a marker to framework
---@param event string Name of event to execute
---@param whitelist table Whitelist allowed to see marker
---@param blacklist table Blacklist to deny marker access
---@param position vector3 Position of marker
---@param style table Marker style
---@param addon table Additonal information of marker
---@return marker Generated marker
function markers:add(event, whitelist, blacklist, position, style, addon)
    local cfg = config('general')
    local defaultRange = ensure(cfg.markerRangeToShow, 5.0)

    id = id + 1
    event = ensure(event, 'unknown')
    whitelist = ensureWhitelist(whitelist)
    blacklist = ensureWhitelist(blacklist)
    position = ensure(position, default_vector3)
    style = ensure(style, {})
    addon = ensure(addon, {})

    ---@class marker
    local marker = {
        id = id,
        event = event,
        whitelist = whitelist,
        blacklist = blacklist,
        position = position,
        style = style,
        addon = addon
    }

    --- Set marker permissions
    self:addPermissions(marker.id, whitelist, 'allow')
    self:addPermissions(marker.id, blacklist, 'deny')

    --- Check if player is allowed to see marker
    ---@param source number Player Source ID
    ---@return boolean Player is allowed to see marker
    function marker:allowed(source)
        source = ensure(source, 0)

        if (source <= 0) then return false end

        return IsPlayerAceAllowed(source, ('marker.x%s'):format(self.id))
    end

    --- Remove current marker from framework
    function marker:remove()
        return markers:remove(self.id)
    end

    data[marker.id] = marker

    return marker
end

--- Remove marker from framework
---@param id number Marker ID
function markers:remove(id)
    id = ensure(id, 0)

    if (data == nil) then return end

    local marker = data[id]

    if (marker == nil) then return end

    --- Remove marker permissions
    self:removePermissions(id, marker.whitelist, 'allow')
    self:removePermissions(id, marker.blacklist, 'deny')

    --- Remove marker from data
    data[id] = nil
end

local EC = ExecuteCommand

local function ExecuteCommand(cmd)
    cmd = ensure(cmd, '')

    print(cmd)

    EC(cmd)
end

--- Add marker permissions based on given `list` and `type`
---@param id number Marker ID
---@param list table List of permissions
---@param type string Type like: `allow` and `deny`
function markers:addPermissions(id, list, type)
    id = ensure(id, 0)
    list = ensureWhitelist(list)
    type = ensure(type, 'allow'):lower()

    if (isWhitelistAll(list)) then
        if (type == 'allow') then
            ExecuteCommand(('add_ace builtin.everyone marker.x%s allow'):format(id))
        end
    else
        for _, group in pairs(list.groups) do
            ExecuteCommand(('add_ace group.%s marker.x%s %s'):format(group, id, type))
        end

        for _, job in pairs(list.jobs) do
            ExecuteCommand(('add_ace job.%s marker.x%s %s'):format(job, id, type))
        end
    end
end

--- Remove marker permissions based on given `list` and `type`
---@param id number Marker ID
---@param list table List of permissions
---@param type string Type like: `allow` and `deny`
function markers:removePermissions(id, list, type)
    id = ensure(id, 0)
    list = ensureWhitelist(list)
    type = ensure(type, 'allow'):lower()

    if (isWhitelistAll(list)) then
        if (type == 'allow') then
            ExecuteCommand(('remove_ace builtin.everyone marker.x%s allow'):format(id))
        end
    else
        for _, group in pairs(list.groups) do
            ExecuteCommand(('remove_ace group.%s marker.x%s %s'):format(group, id, type))
        end

        for _, job in pairs(list.jobs) do
            ExecuteCommand(('remove_ace job.%s marker.x%s %s'):format(job, id, type))
        end
    end
end

--- Returns a list of markers allowed for given source
---@param source number Player source ID
---@return table<number, marker> List of markers
function markers:getAllPlayerMarkers(source)
    source = ensure(source, 0)

    local results = {}

    for id, marker in pairs(data) do
        if (marker:allowed(source)) then
            results[id] = marker
        end
    end

    return results
end

--- Export markers
export('markers', markers)