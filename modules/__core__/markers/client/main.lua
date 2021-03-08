local anyMarkerDrawed = false
local anyMarkerClose = false
local inAnyMarker = nil
local currentMarker = nil
local lastMarker = nil

local markers = {}
local drawMarkers = {}

local waitTimers = {
    drawCheck = 750,
    drawMarkers = 1,
    noDrawMarkers = 250,
    triggerCheck = 25,
    noTriggerCheck = 250
}

---
--- Search for closest markers to draw and put them in the list of `drawMarkers`
---
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local currentPos = GetEntityCoords(playerPed)

        drawMarkers = {}
        anyMarkerClose = false

        for _, marker in pairs(markers) do
            if (marker ~= nil and marker.position ~= nil) then
                local name = ensure(marker.name, 'unknown')
                local position = ensure(marker.position, vec(0, 0, 0))
                local rangeToShow = ensure(marker.rangeToShow, 25.0)

                if (#(position - currentPos) <= rangeToShow) then
                    anyMarkerClose = true

                    drawMarkers[name] = marker
                end
            end
        end

        Citizen.Wait(waitTimers.drawCheck)
    end
end)

---
--- Draws all the markers from list `drawMarkers`
---
Citizen.CreateThread(function()
    while true do
        anyMarkerDrawed = false

        for _, marker in pairs(drawMarkers) do
            if (marker ~= nil and marker.position ~= nil) then
                anyMarkerDrawed = true

                local type = ensure(marker.type, 1)
                local position = ensure(marker.position, vec(0, 0, 0))
                local direction = ensure(marker.direction, vec(0, 0, 0))
                local rotation = ensure(marker.rotation, vec(0, 0, 0))
                local scale = ensure(marker.scale, vec(1, 1, 0.8))
                local rgba = ensure(marker.rgba, vec(255, 255, 255, 100))
                local bobUpAndDown = ensure(marker.bobUpAndDown, false)
                local faceCamera = ensure(marker.faceCamera, false)
                local textureDict = ensure(marker.textureDict, 'unknown')
                local textureName = ensure(marker.textureName, 'unknown')

                DrawMarker(
                    type,
                    position.x,
                    position.y,
                    position.z,
                    direction.x,
                    direction.y,
                    direction.z,
                    rotation.x,
                    rotation.y,
                    rotation.z,
                    scale.x,
                    scale.y,
                    scale.z,
                    rgba.x,
                    rgba.y,
                    rgba.z,
                    rgba.w,
                    bobUpAndDown,
                    faceCamera,
                    2,
                    false,
                    (textureDict ~= 'unknown' and textureDict or nil),
                    (textureName ~= 'unknown' and textureName or nil),
                    false
                )
            end
        end

        Citizen.Wait(anyMarkerClose and waitTimers.drawMarkers or waitTimers.noDrawMarkers)
    end
end)

---
--- Checks if player is in any of those markers drawned from `drawMarkers`
---
Citizen.CreateThread(function()
    while true do
        inAnyMarker = false

        if (anyMarkerDrawed and anyMarkerClose) then
            local playerPed = PlayerPedId()
            local currentPos = GetEntityCoords(playerPed)

            for _, marker in pairs(drawMarkers) do
                if (marker ~= nil and marker.position ~= nil and not inAnyMarker) then
                    local position = ensure(marker.position, vec(0, 0, 0))
                    local scale = ensure(marker.scale, vec(1, 1, 0.8))
                    local mustTrigger = currentMarker == nil

                    if (#(position - currentPos) < scale.x) then
                        inAnyMarker = true
                        currentMarker = marker
                        lastMarker = marker

                        if (mustTrigger) then
                            TriggerLocal('marker:enter', ensure(marker.event, 'unknown'), marker)
                            TriggerLocal(('marker:%s:enter'):format(ensure(marker.event, 'unknown')), marker)
                        end
                    end
                end
            end
        end

        if (not inAnyMarker) then
            currentMarker = nil
        end

        if (currentMarker == nil and lastMarker ~= nil) then
            TriggerLocal('marker:leave', ensure(lastMarker.event, 'unknown'), lastMarker)
            TriggerLocal(('marker:%s:leave'):format(ensure(lastMarker.event, 'unknown')), lastMarker)

            lastMarker = nil
        end

        Citizen.Wait((anyMarkerDrawed and anyMarkerClose) and waitTimers.triggerCheck or waitTimers.noTriggerCheck)
    end
end)

---
--- Public thread to update all the markers inside this module
---
RegisterPublicNet('update:markers', function(data)
    markers = ensure(data, {})
end)

register('marker_addon_data', function()
    if (currentMarker ~= nil) then
        local marker = ensure(currentMarker, {})
        
        return ensure(marker.addon_data, {})
    end

    if (lastMarker ~= nil) then
        local marker = ensure(lastMarker, {})
        
        return ensure(marker.addon_data, {})
    end

    return nil
end)