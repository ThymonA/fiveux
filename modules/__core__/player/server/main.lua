using 'events'
using 'ratelimit'
using 'object'

events:on('playerJoined', function(player)
    local playerData = {
        source = ensure(player.source, 0),
        name = ensure(player.name, 'Unknown'),
        wallets = ensure(player.wallets, {}),
        items = ensure(player.items, {}),
        position = ensure(player.position, vector3(-206.79, -1015.12, 29.14)),
        group = ensure(player.group, 'user'),
        job = object:convert('job', player.job),
        job2 = object:convert('job', player.job2)
    }

    TriggerNet('update:playerData', player.source, playerData)
end)

ratelimit:registerNet('players:position', function(src, position)
    src = ensure(src, 0)
    position = ensure(position, vector3(-206.79, -1015.12, 29.14))

    local player = players:get(src)

    if (player ~= nil) then
        player.position = position
    end
end, 250, 0)