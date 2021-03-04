local playerData = {}
local loaded = false

RegisterPublicNet('update:playerData', function(data)
    playerData = ensure(data, {})
    loaded = true
end)

RegisterPublicNet('update:job', function(job) playerData.job = job end)
RegisterPublicNet('update:job2', function(job2) playerData.job2 = job2 end)
RegisterPublicNet('update:group', function(group) playerData.group = group end)
RegisterPublicNet('update:wallet', function(name, balance)
    if (playerData.wallets and playerData.wallets[name]) then
        playerData.wallets[name] = balance
    end
end)

register('player', function() return playerData end)