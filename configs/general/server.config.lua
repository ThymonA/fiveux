--
-- Name of your datebase. You also need
-- to define `mysql_connection_string`
-- in your `server.cfg`
--
config.databaseName = 'dobberdam'

--
-- Check all conecting player if they using
-- a untrusted IP or VPN.
--
config.vpnEnabled = true

--
-- When a players connects, ban all new
-- identifiers not already banned.
--
config.banNewIdentifiers = true

--
-- List of all allowed countries to
-- connect from (when vpnEnabled = true)
--
config.allowedCountries = {
    'NL', 'BE', 'DE', 'LU', 'GB'
}

--
-- Default player group
--
config.defaultGroup = 'user'

--
-- Default job for both (1st and 2de)
--
config.defaultJob = {
    name = 'unemployed',
    grade = 'unemployed'
}

--
-- Available wallets and default saldo
--
config.wallets = {
    bank = 12500,
    cash = 500,
    crime = 0
}

--
-- Available locations
--
config.defaultLocations = {
    inventory = {
        constants.types.player
    },
    safe = {
        constants.types.player,
        constants.types.jobs
    }
}

config.inheritGroupList = {
    [constants.groups.superadmin] = {
        constants.groups.admin,
        constants.groups.supermod,
        constants.groups.mod,
        constants.groups.superuser,
        constants.groups.user
    },
    [constants.groups.admin] = {
        constants.groups.supermod,
        constants.groups.mod,
        constants.groups.superuser,
        constants.groups.user
    },
    [constants.groups.supermod] = {
        constants.groups.mod,
        constants.groups.superuser,
        constants.groups.user
    },
    [constants.groups.mod] = {
        constants.groups.superuser,
        constants.groups.user
    },
    [constants.groups.superuser] = {
        constants.groups.user
    },
    [constants.groups.user] = {
    }
}

--
-- Number of clips on create
--
config.numberOfClips = 2

--
-- Save player data every x time
--
config.saveInterval = (60 * 1000) * 2.5 -- every 2.5 minutes