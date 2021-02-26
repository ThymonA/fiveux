--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['player'] = 0
}

--
-- Create a `players` table table for you
--
migration.query = [[
    ALTER TABLE `players` ADD COLUMN `stats` VARCHAR(100) NOT NULL DEFAULT '{ "health": 100, "armor": 0, "stamina": 100, "thirst": 100, "hunger": 100 }' COLLATE 'utf8_general_ci' AFTER `grade2`;
]]