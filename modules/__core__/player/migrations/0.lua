--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['jobs'] = 0
}

--
-- Create a `players` table table for you
--
migration.query = [[
    CREATE TABLE `players` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `citizen` VARCHAR(255) NOT NULL,
        `name` VARCHAR(50) NOT NULL,
        `group` VARCHAR(50) NOT NULL DEFAULT 'user',
        `job` INT NOT NULL,
        `grade` INT NOT NULL,
        `job2` INT NOT NULL,
        `grade2` INT NOT NULL,
        `position` VARCHAR(100) NULL DEFAULT '[-206.79,-1015.12,29.14]',

        CONSTRAINT `players_unique_citizen` UNIQUE (`citizen`),
        CONSTRAINT `fk_players_job` FOREIGN KEY (`job`,`grade`) REFERENCES `job_grades`(`job_id`,`grade`),
        CONSTRAINT `fk_players_job2` FOREIGN KEY (`job2`,`grade2`) REFERENCES `job_grades`(`job_id`,`grade`),
        PRIMARY KEY (`id`)
    );
]]