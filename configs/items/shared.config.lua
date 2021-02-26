--
-- Wallets
--
config.cash = {
    type = constants.itemTypes.cash,
    label = T('wallet_cash'),
    image = 'wallets/cash.png',
    weight = 0.01,
    limit = -1,
    price = 0,
    defaultAmount = 0,
    required = true,
    savable = false
}

config.crime = {
    type = constants.itemTypes.cash,
    label = T('wallet_crime'),
    image = 'wallets/crime.png',
    weight = 0.01,
    limit = -1,
    price = 0,
    defaultAmount = 0,
    required = true,
    savable = false
}

config.bank = {
    type = constants.itemTypes.wallet,
    label = T('wallet_bank'),
    image = 'wallets/bank.png',
    weight = 0.01,
    limit = 1,
    price = 0,
    defaultAmount = 0,
    required = true,
    savable = false
}

--
-- Foods
--
config.hamburger = {
    type = constants.itemTypes.food,
    label = T('item_hamburger'),
    image = 'foods/hamburger.png',
    weight = 0.15,
    limit = 10,
    price = 7.50,
    defaultAmount = 0,
    required = false,
    savable = true
}

--
-- Drinks
--
config.tequila = {
    type = constants.itemTypes.drink,
    label = T('item_tequila'),
    image = 'drinks/tequila.png',
    weight = 0.5,
    limit = 5,
    price = 12.50,
    defaultAmount = 0,
    required = false,
    savable = true
}

--
-- Documents
--
config.idcard = {
    type = constants.itemTypes.document,
    label = T('item_idcard'),
    image = 'documents/idcard.png',
    weight = 0.05,
    limit = 1,
    price = 75.00,
    defaultAmount = 1,
    required = true,
    savable = true
}

--
-- Weapons
--
local weapons = load 'weapons'

for _, weapon in pairs(weapons) do
    local name = ensure(weapon.name, 'unknown')
    local category = ensure(weapon.category, 'unknown')
    local price = ensure(weapon.price, 0)
    local weight = ensure(constants.gunWeights[category], 1.0)
    local image_name = name:gsub('gadget_', ''):gsub('weapon_', '')

    config[name] = {
        type = constants.itemTypes.weapon,
        label = T(name),
        image = ('weapons/%s.png'):format(image_name),
        weight = weight,
        limit = 1,
        price = ensure(price, 0),
        required = false,
        savable = false
    }
end