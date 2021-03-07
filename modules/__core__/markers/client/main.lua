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
    noDrawMarkers = 250
}

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

RegisterPublicNet('update:markers', function(data)
    markers = ensure(data, {})
end)