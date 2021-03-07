using 'jobs'

commands:register('job', permissions.commands.job, function(player, action, target, name, grade)
    action = ensure(action, 'unknown')
    target = ensure(target, 0)
    name = ensure(name, 'unknown')
    grade = ensure(grade, 0)

    if (not any(action, { 'set' }, 'value')) then
        player:error(T('invalid_wallet_action', { 'set', 'add', 'remove' }))
        return
    end

    local targetPlayer = players:get(target)

    if (target <= 0 or targetPlayer == nil) then
        player:error(T('invalid_target', target))
        return
    end

    if (action == 'set') then
        targetPlayer:setJob(name, grade)
    end
end)

commands:register('job2', permissions.commands.job2, function(player, action, target, name, grade)
    action = ensure(action, 'unknown')
    target = ensure(target, 0)
    name = ensure(name, 'unknown')
    grade = ensure(grade, 0)

    if (not any(action, { 'set' }, 'value')) then
        player:error(T('invalid_wallet_action', { 'set', 'add', 'remove' }))
        return
    end

    local targetPlayer = players:get(target)

    if (target <= 0 or targetPlayer == nil) then
        player:error(T('invalid_target', target))
        return
    end

    if (action == 'set') then
        targetPlayer:setJob2(name, grade)
    end
end)