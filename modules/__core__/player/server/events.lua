--- Default values
local default_vector3 = vec(0, 0, 0)

--- Update player position
MarkEventAsGlobal('player:position')
RegisterEvent('player:position', function(position)
    local src = ensure(source, 0)

    position = ensure(position, default_vector3)

    local player = players:loadBySource(src)

    if (player == nil) then return end

    player:updatePosition(position)
end)

on('playerJoined', function(player, source)
    local src = ensure(source, 0)
    local player = players:loadBySource(src)

    if (player == nil) then return end

    TriggerRemote('fiveux:spawn', src, player.position)
end)