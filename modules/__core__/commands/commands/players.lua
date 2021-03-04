using 'players'

commands:register('wallet', { groups = { 'superadmin' } }, function(player, action, target, name, amount)
    action = ensure(action, 'unknown')
    target = ensure(target, 0)
    name = ensure(name, 'unknown')
    amount = ensure(amount, 0)

    if (not any(action, { 'set', 'add', 'remove' }, 'value')) then
        player:error(T('invalid_wallet_action', { 'set', 'add', 'remove' }))
        return
    end

    local targetPlayer = players:get(target)

    if (target <= 0 or targetPlayer == nil) then
        player:error(T('invalid_target', target))
        return
    end

    if (action == 'set') then
        targetPlayer:setWallet(name, amount)
    elseif (action == 'add') then
        targetPlayer:addWallet(name, amount)
    elseif (action == 'remove') then
        targetPlayer:removeWallet(name, amount)
    end
end)