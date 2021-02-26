using 'events'
using 'ratelimit'

events:on('playerJoined', function(player)
    local job = ensure(player.job, {})
    local job_grade = ensure(job.grade, {})
    local job2 = ensure(player.job2, {})
    local job2_grade = ensure(job2.grade, {})
    local playerData = {
        source = ensure(player.source, 0),
        name = ensure(player.name, 'Unknown'),
        wallets = ensure(player.wallets, {}),
        items = ensure(player.items, {}),
        position = ensure(player.position, vector3(-206.79, -1015.12, 29.14)),
        group = ensure(player.group, 'user'),
        job = {
            name = ensure(job.name, 'unemployed'),
            label = ensure(job.label, 'Unemployed'),
            permissions = ensure(job.allowed, {}),
            grade_name = ensure(job_grade.name, 'unemployed'),
            grade_label = ensure(job_grade.label, 'unemployed'),
            grade_permissions = ensure(job_grade.permissions, {})
        },
        job2 = {
            name = ensure(job2.name, 'unemployed'),
            label = ensure(job2.label, 'Unemployed'),
            permissions = ensure(job2.allowed, {}),
            grade_name = ensure(job2_grade.name, 'unemployed'),
            grade_label = ensure(job2_grade.label, 'unemployed'),
            grade_permissions = ensure(job2_grade.permissions, {})
        }
    }

    TriggerNet('fiveux:playerData', player.source, playerData)
end)

ratelimit:registerNet('players:position', function(src, position)
    src = ensure(src, 0)
    position = ensure(position, vector3(-206.79, -1015.12, 29.14))

    local player = players:get(src)

    if (player ~= nil) then
        player.position = position
    end
end, 500, 0)