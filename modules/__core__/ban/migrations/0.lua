migration.query = [[
    CREATE TABLE `player_bans` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `fxid` VARCHAR(255) DEFAULT NULL,
        `username` VARCHAR(255) DEFAULT NULL,
        `steam` VARCHAR(255) DEFAULT NULL,
        `license` VARCHAR(255) DEFAULT NULL,
        `license2` VARCHAR(255) DEFAULT NULL,
        `live` VARCHAR(255) DEFAULT NULL,
        `xbl` VARCHAR(255) DEFAULT NULL,
        `discord` VARCHAR(255) DEFAULT NULL,
        `fivem` VARCHAR(255) DEFAULT NULL,
        `ip` VARCHAR(255) DEFAULT NULL,
        `reason` TEXT DEFAULT NULL,
        `expire` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `bannedBy` VARCHAR(255) NOT NULL DEFAULT 'system',
        `parentBan` INT DEFAULT NULL,
        CONSTRAINT `fk_player_bans_parentBan` FOREIGN KEY (`parentBan`) REFERENCES `player_bans`(`id`),
        PRIMARY KEY (`id`)
    );
]]