--
-- Create a `logs` table table for you
--
migration.query = [[
    CREATE TABLE `logs` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `identifier` VARCHAR(100) NOT NULL,
        `name` VARCHAR(100) NOT NULL,
        `action` VARCHAR(100) NOT NULL DEFAULT 'none',
        `arguments` LONGTEXT NOT NULL,

        PRIMARY KEY (`id`)
    );
]]