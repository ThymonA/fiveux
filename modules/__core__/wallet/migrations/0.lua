migration.query = [[
    CREATE TABLE `wallets` (
        `identifier` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL DEFAULT 'bank',
        `balance` INT NOT NULL DEFAULT 0,
        CONSTRAINT `wallets_unique_identifier` UNIQUE (`identifier`, `name`)
    )
]]