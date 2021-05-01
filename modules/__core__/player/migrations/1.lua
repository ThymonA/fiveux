migration.query = [[
    CREATE TABLE `player_skins` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `fxid` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL,
        `model` VARCHAR(255) NOT NULL,
        `skin` TEXT NOT NULL,
        `active` INT NOT NULL DEFAULT 1,
        PRIMARY KEY (`id`)
    );
]]