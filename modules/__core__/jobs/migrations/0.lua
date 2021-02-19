--
-- Create a `jobs` and `job_grades` table table for you
--
migration.query = [[
    CREATE TABLE `jobs` (
        `id` INT(11) NOT NULL AUTO_INCREMENT,
        `name` VARCHAR(50) NOT NULL DEFAULT 'unemployed',

        CONSTRAINT `jobs_unique_name` UNIQUE (`name`),
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `job_grades` (
        `job_id` INT NOT NULL,
        `grade` INT NOT NULL DEFAULT 0,
        `name` VARCHAR(50) NOT NULL DEFAULT '',

        CONSTRAINT `job_grades_unique_name` UNIQUE (`job_id`, `name`),
        CONSTRAINT `fk_job_grades_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs`(`id`),
        PRIMARY KEY (`job_id`, `grade`)
    );
]]