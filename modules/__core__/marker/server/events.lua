on('playerJoined', function(player, playerSrc)
    playerSrc = ensure(playerSrc, 0)

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
end)