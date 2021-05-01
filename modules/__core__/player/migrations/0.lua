migration.query = [[
    CREATE TABLE `players` (
        `fxid` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL,
        `group` VARCHAR(50) NOT NULL DEFAULT 'user',
        `job` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
        `grade` INT NOT NULL DEFAULT 0,
        `job2` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
        `grade2` INT NOT NULL DEFAULT 0,
        `stats` VARCHAR(255) NOT NULL DEFAULT '{ "health": 100, "armor": 0, "stamina": 100, "thirst": 100, "hunger": 100 }',
        `position` VARCHAR(100) NULL DEFAULT '[-206.79,-1015.12,29.14]',
        CONSTRAINT `players_unique_fxid` UNIQUE (`fxid`)
    );

    CREATE TABLE `player_tokens` (
        `fxid` VARCHAR(255) NOT NULL,
        `prefix` INT(10) NOT NULL DEFAULT 0,
        `value` VARCHAR(100) NULL DEFAULT NULL,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT `player_tokens_unique_values` UNIQUE (`fxid`, `prefix`, `value`)
    );

    CREATE TABLE `player_identifiers` (
        `fxid` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL,
        `steam` VARCHAR(50) NULL DEFAULT NULL,
        `license` VARCHAR(50) NULL DEFAULT NULL,
        `license2` VARCHAR(50) NULL DEFAULT NULL,
        `xbl` VARCHAR(50) NULL DEFAULT NULL,
        `live` VARCHAR(50) NULL DEFAULT NULL,
        `discord` VARCHAR(50) NULL DEFAULT NULL,
        `fivem` VARCHAR(50) NULL DEFAULT NULL,
        `ip` VARCHAR(50) NULL DEFAULT NULL,
        `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
]]