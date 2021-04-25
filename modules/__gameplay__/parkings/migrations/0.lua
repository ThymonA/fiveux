migration.requirements = {
    ['vehicle'] = 0
}

migration.query = [[
    CREATE TABLE `parkings` (
        `vehicle` INT DEFAULT NULL,
        `parking` VARCHAR(50) NOT NULL DEFAULT 'unknown',
        `spot` INT NOT NULL DEFAULT 0,
        `parkedBy` VARCHAR(255) NOT NULL DEFAULT 'system',
        CONSTRAINT `parkings_unique_parking` UNIQUE (`parking`, `spot`),
        CONSTRAINT `fk_parkings_vehicle` FOREIGN KEY (`vehicle`) REFERENCES `vehicles`(`id`)
    );
]]