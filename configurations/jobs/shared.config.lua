--- aces
local aces = constants.aces.job

--- Unemployed job
config.unemployed = {
    name = 'unemployed',
    allowed = {},
    denied = {
        aces.all
    },
    publicAllowed = {},
    grades = {
        {
            grade = 0,
            name = 'unemployed',
            denied = {
                aces.all
            }
        }
    },
    categories = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    buyables = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    sellables = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    clothes = {},
    vehicles = {},
    blips = {}
}

--- Bratva job
config.bratva = {
    name = 'bratva',
    allowed = {
        aces.all
    },
    denied = {
    },
    publicAllowed = {},
    grades = {
        {
            grade = 0,
            name = 'restap',
            denied = {
                aces.buy.all,
                aces.sell.all,
                aces.safe.item.remove,
                aces.safe.weapon.remove,
                aces.safe.wallet.remove
            }
        },
        {
            grade = 1,
            name = 'obshchak',
            denied = {
                aces.buy.all,
                aces.sell.all,
                aces.safe.wallet.remove
            }
        },
        {
            grade = 2,
            name = 'sovietnik',
            denied = {
                aces.buy.all
            }
        },
        {
            grade = 3,
            name = 'boss',
            denied = {}
        }
    },
    categories = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    buyables = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    sellables = {
        weapons = {},
        items = {},
        vehicles = {}
    },
    clothes = {},
    vehicles = {},
    blips = {}
}