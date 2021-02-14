--
-- Create a `identifiers` table table for you
--
migration.query = [[
    CREATE TABLE `identifiers` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `steam` VARCHAR(255) NULL DEFAULT NULL,
        `license` VARCHAR(255) NULL DEFAULT NULL,
        `license2` VARCHAR(255) NULL DEFAULT NULL,
        `xbl` VARCHAR(255) NULL DEFAULT NULL,
        `live` VARCHAR(255) NULL DEFAULT NULL,
        `discord` VARCHAR(255) NULL DEFAULT NULL,
        `fivem` VARCHAR(255) NULL DEFAULT NULL,
        `ip` VARCHAR(255) NULL DEFAULT NULL,

        PRIMARY KEY (`id`)
    );
]]