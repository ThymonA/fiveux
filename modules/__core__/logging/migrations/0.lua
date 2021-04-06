migration.query = [[
    CREATE TABLE `player_logs` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `fxid` VARCHAR(100) NOT NULL,
        `name` VARCHAR(100) NOT NULL,
        `action` VARCHAR(100) NOT NULL DEFAULT 'none',
        `arguments` LONGTEXT NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `module_logs` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `name` VARCHAR(100) NOT NULL,
        `action` VARCHAR(100) NOT NULL DEFAULT 'none',
        `arguments` LONGTEXT NOT NULL,
        PRIMARY KEY (`id`)
    );
]]