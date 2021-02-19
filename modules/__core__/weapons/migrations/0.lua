--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['locations'] = 0
}

--
-- Create a `weapons` table table for you
--
migration.query = [[
    CREATE TABLE `weapons` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `uuid` BINARY(16) NOT NULL,
        `location_id` INT DEFAULT NULL,
        `model` VARCHAR(50) NOT NULL DEFAULT 'unknown',
        `bullets` INT NOT NULL DEFAULT 50,
        `components` LONGTEXT NOT NULL,

        CONSTRAINT `weapons_unique_uuid` UNIQUE (`uuid`),
        CONSTRAINT `fk_weapons_location_id` FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`),
        PRIMARY KEY (`id`)
    );
]]