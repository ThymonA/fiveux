--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['player'] = 0,
    ['jobs'] = 0
}

--
-- Create a `player_wallets` table table for you
--
migration.query = [[
    CREATE TABLE `locations` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `player_id` INT DEFAULT NULL,
        `job_id` INT DEFAULT NULL,
        `name` VARCHAR(50) NOT NULL DEFAULT 'unknown',

        CONSTRAINT `locations_unique_name` UNIQUE (`player_id`, `job_id`, `name`),
        CONSTRAINT `fk_locations_player_id` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`),
        CONSTRAINT `fk_locations_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs`(`id`),
        PRIMARY KEY (`id`)
    );
]]