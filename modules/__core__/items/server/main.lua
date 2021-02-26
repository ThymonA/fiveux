using 'wallets'

function items:getPlayerItems(playerId)
    playerId = ensure(playerId, 0)

    if (playerId == 0) then
        return {}
    end

    local playerWallets = wallets:getPlayerWallets(playerId)
    local results, itemAmounts = {}, {}
    local dbItems = db:fetchAll("SELECT * FROM `player_items` WHERE `player_id` = :playerId", {
        ['playerId'] = playerId
    })

    dbItems = ensure(dbItems, {})

    for k, v in pairs(dbItems) do
        itemAmounts[ensure(v.name, 'unknown')] = ensure(v.amount, 0)
    end

    for itemName, itemInfo in pairs(item_info) do
        itemName = ensure(itemName, 'unknown')
        itemInfo = ensure(itemInfo, {})

        local required = ensure(itemInfo.required, false)
        local default = ensure(itemInfo.defaultAmount, 0)
        local savable = ensure(itemInfo.savable, false)

        if (itemAmounts[itemName] ~= nil) then
            results[itemName] = ensure(itemAmounts[itemName], default)
        elseif (required) then
            local type = ensure(itemInfo.type, 'unknown')

            if (type == constants.itemTypes.cash or type == constants.itemTypes.wallet) then
                results[itemName] = ensure(playerWallets[itemName], default)
            else
                results[itemName] = default
            end

            if (savable) then
                db:insert('INSERT INTO `player_items` (`player_id`, `name`, `amount`) VALUES (:playerId, :name, :amount)', {
                    ['playerId'] = playerId,
                    ['name'] = itemName,
                    ['amount'] = results[itemName]
                })
            end
        end
    end

    return results
end

register('items', items)