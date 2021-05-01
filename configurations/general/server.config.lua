--- Name of your datebase.
config.databaseName = 'fiveux'

--- Ban new matching identifiers
config.banNewIdentifiers = true

--- Default player group
config.defaultGroup = 'user'

--- Default player job
config.defaultJob = { name = 'unemployed', grade = 0 }

--- Default player job2
config.defaultJob2 = { name = 'unemployed', grade = 0 }

--- Default wallets (player/jobs)
config.defaultWallets = {
    ['cash'] = 7500,
    ['bank'] = 32500,
    ['crime'] = 0,
    ['wash'] = 0
}

--- Save all players interval
--- [ Time in minutes ]
config.savePlayersInterval = 1

--- Save all jobs interval
--- [ Time in minutes ]
config.saveJobsInterval = 1

--- Available groups
config.groups = {
    'superadmin',
    'admin',
    'user'
}

--- X means letters like: A,B,C,D etc..
--- 9 means digit like: 1,2,3,4 etc..
config.plateFormats = {
    'XX-99-99',
    '99-99-XX',
    '99-XX-99',
    'XX-99-XX',
    'XX-XX-99',
    '99-XX-XX',
    '99-XXX-9',
    '9-XXX-99',
    'XX-999-X',
    'X-999-XX',
    'XXX-99-X',
    '9-XX-999',
    '999-XX-9'
}