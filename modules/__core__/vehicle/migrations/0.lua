migration.query = [[
    CREATE TABLE `vehicles` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `fxid` VARCHAR(255) NOT NULL,
        `plate` VARCHAR(50) NOT NULL DEFAULT 'XXXXXXX',
        `vehicle` TEXT NOT NULL,
        `model` VARCHAR(50) NOT NULL DEFAULT 'unknown',
        `hash` INT NOT NULL DEFAULT 0,
        `status` INT NOT NULL DEFAULT 0,
        `distance` INT NOT NULL DEFAULT 0,
        `price` INT NOT NULL DEFAULT 0,
        `forSale` INT(1) NOT NULL DEFAULT 0,
        `saleLocation` VARCHAR(50) NOT NULL DEFAULT 'unknown',
        CONSTRAINT `vehicles_unique_plate` UNIQUE (`plate`),
        PRIMARY KEY (`id`)
    );
]]