local function updateMarkers(player)
    local playerSrc = ensure(player:getSource(), 0)

    if (playerSrc <= 0) then return end

    local markers = markers:getAllPlayerMarkers(playerSrc)
    local results = {}

    for id, marker in pairs(markers) do
        results[id] = {
            id = id,
            event = marker.event,
            whitelist = marker.whitelist,
            blacklist = marker.blacklist,
            position = marker.position,
            style = marker.style,
            addon = marker.addon
        }
    end

    TriggerRemote('markers:update', playerSrc, results)
end

RegisterEvent('player:group:set', updateMarkers)
RegisterEvent('player:job:set', updateMarkers)
RegisterEvent('player:job2:set', updateMarkers)

on('playerJoined', updateMarkers) 