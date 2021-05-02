--- Configuration
local markerCfg = config('marker')

--- Default values
local default_vector3 = vec(0, 0, 0)
local default_vector4 = vec(0, 0, 0, 0)
local default_style = {
    rangeToShow         = ensure(markerCfg.defaultRangeToShow,      5.0),
    direction           = ensure(markerCfg.defaultDirection,        default_vector3),
    rotation            = ensure(markerCfg.defaultRotation,         default_vector3),
    size                = ensure(markerCfg.defaultSize,             default_vector3),
    color               = ensure(markerCfg.defaultColor,            default_vector4),
    type                = ensure(markerCfg.defaultType,             1),
    bobUpAndDown        = ensure(markerCfg.defaultBobUpAndDown,     false),
    faceCamera          = ensure(markerCfg.defaultFaceCamera,       false),
    rotate              = ensure(markerCfg.defaultRotate,           false),
    drawOnEnts          = ensure(markerCfg.defaultDrawOnEnts,       false)
}

--- Local storage
local data              = {}
local drawMarkers       = {}
local currentMarker     = nil
local lastMarker        = nil

--- Local booleans
local anyMarkerClose    = false
local anyMarkerDrawed   = false
local inAnyMarker       = false

--- Search for markers in range of player
Citizen.CreateThread(function()
    while true do
        drawMarkers = {}
        anyMarkerClose = false

        if (PlayerJoined()) then
            local playerPed         = PlayerPedId()
            local currentPosition   = GetEntityCoords(playerPed)

            for _, marker in pairs(data) do
                marker              = ensure(marker,            {})

                local id            = ensure(marker.id,         0)
                local position      = ensure(marker.position,   default_vector3)
                local style         = ensure(marker.style,      {})
                local rangeToShow   = ensure(style.rangeToShow, 5.0)

                if (#(position - currentPosition) <= rangeToShow) then
                    anyMarkerClose  = true
                    drawMarkers[id] = marker
                end
            end
        end

        Citizen.Wait(500)
    end
end)

--- Draw all markers from list `drawMarkers`
Citizen.CreateThread(function()
    while true do
        anyMarkerDrawed = false
        
        if (PlayerJoined()) then
            for _, marker in pairs(drawMarkers) do
                anyMarkerDrawed     = true
                marker              = ensure(marker, {})

                local position      = ensure(marker.position,       default_vector3)
                local style         = ensure(marker.style,          {})
                local type          = ensure(style.type,            default_style.type)
                local direction     = ensure(style.direction,       default_style.direction)
                local rotation      = ensure(style.rotation,        default_style.rotation)
                local size          = ensure(style.size,            default_style.size)
                local color         = ensure(style.color,           default_style.color)
                local rangeToShow   = ensure(style.rangeToShow,     default_style.rangeToShow)
                local bobUpAndDown  = ensure(style.bobUpAndDown,    default_style.bobUpAndDown)
                local faceCamera    = ensure(style.faceCamera,      default_style.faceCamera)
                local rotate        = ensure(style.rotate,          default_style.rotate)
                local textureDict   = ensure(style.textureDict,     'unknown')
                local textureName   = ensure(style.textureName,     'unknown')
                local drawOnEnts    = ensure(style.drawOnEnts,      default_style.drawOnEnts)

                if (textureDict == 'unknown') then textureDict = nil end
                if (textureName == 'unknown') then textureName = nil end

                DrawMarker(type, position.x, position.y, position.z, direction.x, direction.y, direction.z, rotation.x, rotation.y, rotation.z, size.x, size.y, size.z, color.x, color.y, color.z, color.w, bobUpAndDown, faceCamera, 2, rotate, textureDict, textureName, drawOnEnts)
            end
        end

        Citizen.Wait(anyMarkerClose and 1 or 250)
    end
end)

--- Checks if player is any of those drawned markers
Citizen.CreateThread(function()
    while true do
        inAnyMarker = false

        if (anyMarkerClose and anyMarkerDrawed) then
            local playerPed         = PlayerPedId()
            local currentPosition   = GetEntityCoords(playerPed)

            for _, marker in pairs(drawMarkers) do
                marker              = ensure(marker, {})

                local event         = ensure(marker.event, 'unknown')
                local position      = ensure(marker.position, default_vector3)
                local style         = ensure(marker.style, {})
                local size          = ensure(style.size, default_style.size)
                local needsTrigger  = currentMarker == nil

                if (#(position - currentPosition) < size.x) then
                    inAnyMarker     = true
                    currentMarker   = marker
                    lastMarker      = marker

                    if (needsTrigger) then
                        emit('marker:enter', event, marker)
                    end
                end
            end
        end

        if (not inAnyMarker) then currentMarker = nil end

        if (currentMarker == nil and lastMarker ~= nil) then
            local marker = ensure(lastMarker, {})
            local event = ensure(marker.event, 'unknown')

            emit('marker:leave', event, marker)

            lastMarker = nil
        end

        Citizen.Wait(anyMarkerDrawed and anyMarkerClose and 25 or 250)
    end
end)

---@class markers_client
markers = {}

--- Returns current marker if any
---@return table|nil Current marker or nil
function markers:currentMarker()
    return ensure(currentMarker, {}, true)
end

--- Export markers
export('markers', markers)

--- Update marker storage
MarkEventAsGlobal('markers:update')
RegisterEvent('markers:update', function(markers)
    data = ensure(markers, {})
end)

MarkEventAsGlobal('markers:add')
RegisterEvent('markers:add', function(marker)
    marker = ensure(marker, {})
    data = ensure(data, {})

    local id = ensure(marker.id, 0)

    if (id ~= 0) then
        data[id] = marker
    end
end)

MarkEventAsGlobal('markers:remove')
RegisterEvent('markers:remove', function(markerId)
    markerId = ensure(markerId, 0)
    data = ensure(data, {})

    if (markerId ~= 0 and data[markerId] ~= nil) then
        data[markerId] = nil
    end
end)