--
-- Create a `players` table table for you
--
migration.query = [[
    CREATE TABLE `players` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `citizen` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL,
        `job` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
        `grade` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
        `job2` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
        `grade2` VARCHAR(50) NOT NULL DEFAULT 'unemployed',

        CONSTRAINT `players_unique_citizen` UNIQUE (`citizen`),
        PRIMARY KEY (`id`)
    );
]]