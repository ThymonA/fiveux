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