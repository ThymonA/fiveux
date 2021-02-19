using 'db'

local data = {}

wallets = {}

function wallets:getPlayerWallets(playerId)
    playerId = ensure(playerId, 0)

    if (playerId == 0) then
        return {}
    end

    local results, walletBalances = {}, {}
    local dbWallets = db:fetchAll("SELECT * FROM `player_wallets` WHERE `player_id` = :playerId", {
        ['playerId'] = playerId
    })

    dbWallets = ensure(dbWallets, {})

    for k, v in pairs(dbWallets) do
        walletBalances[ensure(v.name, 'unknown')] = ensure(v.balance, 0)
    end

    local cfg = config('general')
    local defaultWallets = ensure(cfg.wallets, {})

    for name, default in pairs(defaultWallets) do
        name = ensure(name, 'unknown')
        default = ensure(default, 0)

        if (walletBalances[name]) then
            results[name] = ensure(walletBalances[name], default)
        else
            db:insert('INSERT INTO `player_wallets` (`player_id`, `name`, `balance`) VALUES (:playerId, :name, :balance)', {
                ['playerId'] = playerId,
                ['name'] = name,
                ['balance'] = default
            })

            results[name] = default
        end
    end

    return results
end

register('wallets', wallets)