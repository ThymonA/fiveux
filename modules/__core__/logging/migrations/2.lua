migration.query = [[
    CREATE TABLE `vehicle_logs` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `plate` VARCHAR(100) NOT NULL,
        `action` VARCHAR(100) NOT NULL DEFAULT 'none',
        `arguments` LONGTEXT NOT NULL,
        PRIMARY KEY (`id`)
    );
]]