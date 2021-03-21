--
-- EXAMPLE MIGRATION
--

--
-- Load global configuration
--
local generalCfg = config('general')
local database = ensure(generalCfg.databaseName, 'FiveUX')

--
-- Execute this migration after `key` (module) and `value`
-- (minimal version) has been executed.
-- Example: { ['db'] = 0 }
-- (update after module 'db' migration 0 has been executed).
--
migration.requirements = {}

--
-- This query will be executed in your database
--
migration.query = "CREATE DATABASE IF NOT EXISTS `:database`"

--
-- Migration paramaters to execute on query
--
migration.params = {
    ['database'] = database
}