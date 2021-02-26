--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['player'] = 0
}

--
-- Create a `player_wallets` table table for you
--
migration.query = [[
    CREATE TABLE `player_items` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `player_id` INT NOT NULL,
        `name` VARCHAR(50) NOT NULL DEFAULT 'unknown',
        `amount` INT NOT NULL DEFAULT 0,

        CONSTRAINT `player_items_unique_name` UNIQUE (`player_id`, `name`),
        CONSTRAINT `fk_player_items_player_id` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`),
        PRIMARY KEY (`id`)
    );
]]