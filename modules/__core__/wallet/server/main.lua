import 'db'

local data = {}

---@class wallets
wallets = {}

--- Load all wallets for specific identifier
---@param identifier string Identifier to load wallets for
---@return table<string, wallet> Wallets
function wallets:loadAllByIdentifier(identifier)
    identifier = ensure(identifier, 'unknown')

    if (identifier == 'unknown') then return {} end
    if (data == nil) then data = {} end
    if (data[identifier] ~= nil) then return data[identifier] end

    local dbResults = db:fetchAll('SELECT * FROM `wallets` WHERE `identifier` = :identifier', { ['identifier'] = identifier })

    dbResults = ensure(dbResults, {})

    local results = {}

    for _, dbWallet in pairs(dbResults) do
        ---@class wallet
        local wallet = {
            identifier = ensure(dbWallet.identifier, 'unknown'),
            name = ensure(dbWallet.name, 'unknown'),
            balance = ensure(dbWallet.balance, 0)
        }

        --- Add x `amount` to current wallet
        ---@param amount number Amount to add
        function wallet:addBalance(amount)
            amount = ensure(amount, 0)

            if (amount > 0) then
                local newBalance = round(self.balance + amount)

                if (newBalance <= -2147483647) then newBalance = -2147483647 end
                if (newBalance >= 2147483647) then newBalance = 2147483647 end

                self.balance = newBalance
            end
        end

        --- Remove x `amount` from current wallet
        ---@param amount number Amount to remove
        function wallet:removeBalance(amount)
            amount = ensure(amount, 0)

            if (amount > 0) then
                local newBalance = round(self.balance - amount)

                if (newBalance <= -2147483647) then newBalance = -2147483647 end
                if (newBalance >= 2147483647) then newBalance = 2147483647 end

                self.balance = newBalance
            end
        end

        --- Set `amount` for current wallet
        ---@param amount number Amount to set
        function wallet:setBalance(amount)
            amount = ensure(amount, 0)

            if (amount > 0) then
                local newBalance = round(amount)

                if (newBalance <= -2147483647) then newBalance = -2147483647 end
                if (newBalance >= 2147483647) then newBalance = 2147483647 end

                self.balance = newBalance
            end
        end

        --- Save current wallet
        function wallet:save()
            local identifier = ensure(self.identifier, 'unknown')
            local name = ensure(self.name, 'unknown')
            local balance = ensure(self.balance, 0)

            if (identifier == 'unknown' or name == 'unknown') then return end

            balance = round(balance)

            if (balance <= -2147483647) then balance = -2147483647 end
            if (balance >= 2147483647) then balance = 2147483647 end

            db:execute('UPDATE `wallets` SET `balance` = :balance WHERE `identifier` = :identifier AND `name` = :name', {
                ['balance'] = balance,
                ['identifier'] = identifier,
                ['name'] = name
            })
        end

        results[wallet.name] = wallet
    end

    local cfg = config('general')
    local defaultWallets = ensure(cfg.defaultWallets, {})
    local missingWallet = false

    for wallet, saldo in pairs(defaultWallets) do
        wallet = ensure(wallet, 'unknown')
        saldo = round(ensure(saldo, 0))

        if (saldo <= -2147483647) then saldo = -2147483647 end
        if (saldo >= 2147483647) then saldo = 2147483647 end

        if (results[wallet] == nil and wallet ~= 'unknown') then
            db:execute('INSERT INTO `wallets` (`identifier`, `name`, `balance`) VALUES (:identifier, :name, :balance)', {
                ['identifier'] = identifier,
                ['name'] = wallet,
                ['balance'] = saldo
            })

            missingWallet = true
        end
    end

    if (missingWallet) then
        return self:loadAllByIdentifier(identifier)
    end

    data[identifier] = results

    return results
end

export('wallets', wallets)