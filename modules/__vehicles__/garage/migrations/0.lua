--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['player'] = 0
}

--
-- Create a `player_vehicles` table table for you
--
migration.query = [[
    CREATE TABLE `player_vehicles` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `player_id` INT,
        `plate` VARCHAR(10) NOT NULL,
        `spawnCode` VARCHAR(100) NOT NULL DEFAULT 'unknown',
        `type` VARCHAR(10) NOT NULL DEFAULT 'car',
        `vehicle` LONGTEXT  NOT NULL,
        CONSTRAINT `player_vehicles_unique_plate` UNIQUE (`plate`),
        CONSTRAINT `fk_player_vehicles_player` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`)
    );
]]