--
-- Execute this migration after those are executed
--
migration.requirements = {
    ['jobs'] = 0
}

--
-- Insert data into `jobs` and `job_grades` table
--
migration.query = [[
    INSERT INTO `jobs` (`name`) VALUES ('unemployed');
    INSERT INTO `job_grades` SELECT `id` AS `job_id`, 0 AS `grade`, 'unemployed' AS `name` FROM `jobs` WHERE `name` = 'unemployed' LIMIT 1;
]]