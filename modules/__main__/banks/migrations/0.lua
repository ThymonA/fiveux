--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['player'] = 0,
    ['jobs'] = 0
}

--
-- Create a `bank`, `bank_cards` and `bank_transactions` table table for you
--
migration.query = [[
    CREATE TABLE `bank` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `player_id` INT DEFAULT NULL,
        `job_id` INT DEFAULT NULL,
        `type` VARCHAR(50) NOT NULL DEFAULT 'payment',
        `number` VARCHAR(18) NOT NULL,
        `balance` INT NOT NULL DEFAULT 0,

        CONSTRAINT `bank_unique_number` UNIQUE (`number`),
        CONSTRAINT `fk_bank_player_id` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`),
        CONSTRAINT `fk_bank_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs`(`id`),
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `bank_cards` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `bank_id` INT NOT NULL,
        `player_id` INT NOT NULL,
        `number` VARCHAR(3) NOT NULL,
        `valid_thru` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        `blocked` INT NOT NULL DEFAULT 0,

        CONSTRAINT `player_bankcards_unique_number` UNIQUE (`bank_id`, `number`),
        CONSTRAINT `fk_bank_cards_bank_id` FOREIGN KEY (`bank_id`) REFERENCES `bank`(`id`),
        CONSTRAINT `fk_bank_cards_player_id` FOREIGN KEY (`player_id`) REFERENCES `players`(`id`),
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `bank_transactions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `card_id` INT NOT NULL,
        `target_id` INT NOT NULL,
        `type` VARCHAR(10) NOT NULL DEFAULT 'withdraw',
        `amount` INT NOT NULL DEFAULT 0,
        `description` VARCHAR(255) NOT NULL DEFAULT '',

        CONSTRAINT `fk_bank_transactions_card_id` FOREIGN KEY (`card_id`) REFERENCES `bank_cards`(`id`),
        CONSTRAINT `fk_bank_transactions_target_id` FOREIGN KEY (`target_id`) REFERENCES `bank`(`id`),
        PRIMARY KEY (`id`)
    );
]]