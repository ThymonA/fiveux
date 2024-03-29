--- Configuration
local markerCfg = config('marker')

--- Default values
local default_vector3 = vec(0, 0, 0)
local default_vector4 = vec(0, 0, 0, 0)
local default_style = {
    rangeToShow = ensure(markerCfg.defaultRangeToShow, 5.0),
    direction = ensure(markerCfg.defaultDirection, default_vector3),
    rotation = ensure(markerCfg.defaultRotation, default_vector3),
    size = ensure(markerCfg.defaultSize, default_vector3),
    color = ensure(markerCfg.defaultColor, default_vector4),
    type = ensure(markerCfg.defaultType, 1),
    bobUpAndDown = ensure(markerCfg.defaultBobUpAndDown, false),
    faceCamera = ensure(markerCfg.defaultFaceCamera, false),
    rotate = ensure(markerCfg.defaultRotate, false),
    drawOnEnts = ensure(markerCfg.defaultDrawOnEnts, false)
}

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

    local num = GetNumPlayerIndices()

    for i = 0, num - 1 do
        local src = ensure(GetPlayerFromIndex(i), 0)

        if (src ~= 0 and marker:allowed(src)) then
            TriggerRemote('markers:add', src, {
                id = marker.id,
                event = marker.event,
                whitelist = marker.whitelist,
                blacklist = marker.blacklist,
                position = marker.position,
                style = marker.style,
                addon = marker.addon
            })
        end
    end

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

    TriggerRemote('markers:remove', -1, id)
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
            ExecuteCommand(('add_ace builtin.everyone marker.x%s %s'):format(id, type))
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
            ExecuteCommand(('remove_ace builtin.everyone marker.x%s %s'):format(id, type))
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

--- Returns default style
---@return table Default marker style
function markers:getDefaultStyle()
    return default_style
end

--- Export markers
export('markers', markers)