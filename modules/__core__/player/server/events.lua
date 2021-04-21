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

--- Add player skin
MarkEventAsGlobal('player:skin:add')
RegisterEvent('player:skin:add', function(name, model, skin, active)
    local src = ensure(source, 0)

    name = ensure(name, 'unknown')
    model = ensure(model, 'mp_m_freemode_01')
    skin = ensure(skin, {})
    active = ensure(active, false)

    local player = players:loadBySource(src)

    if (player == nil) then return end

    player:addSkin(name, model, skin, active)
end)

on('playerJoined', function(player, source)
    local src = ensure(source, 0)
    local player = players:loadBySource(src)

    if (player == nil) then return end

    local skin = ensure(player:getActiveSkin(), {})
    local model = ensure(skin.model, 'unknown')
    local data = ensure(skin.skin, {})

    TriggerRemote('fiveux:spawn', src, model, player.position, data)
end)