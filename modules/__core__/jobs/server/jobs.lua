using 'db'

local loaded = false
local data = {}

jobs = {}

function jobs:load()
    if (loaded) then return end

    local jobsConfig = config('jobs')
    local dbJobs = db:fetchAll([[
        SELECT
            `j`.`id` as `job_id`,
            `j`.`name` as `job_name`,
            `jg`.`grade` as `grade`,
            `jg`.`name` as `grade_name`
        FROM `job_grades` AS `jg`
        LEFT JOIN `jobs` AS `j`
            ON `j`.`id` = `jg`.`job_id`
    ]], {})

    dbJobs = ensure(dbJobs, {})

    for _, jobGrade in pairs(dbJobs) do
        local job
        local jobName = ensure(jobGrade.job_name, 'unemployed')
        local gradeName = ensure(jobGrade.grade_name, 'unemployed')
        local jobConfig = ensure(jobsConfig[jobName], {})
        local jobGradeConfig = ensure(jobConfig.grades, {})
        local gradeConfig = ensure(jobGradeConfig[gradeName], {})

        if (data[jobName]) then
            job = data[jobName]
        else
            job = {
                id = ensure(jobGrade.job_id, 0),
                name = jobName,
                grades = {},
                allowed = ensure(jobConfig.allowed, {}),
                webhooks = ensure(jobConfig.webhooks, {}),
                label = T(('job_%s'):format(gradeName))
            }

            print_success(T('job_loaded', T(('job_%s'):format(jobName)), jobName))
        end

        local grade = {
            grade = ensure(jobGrade.grade, 0),
            name = gradeName,
            salary = ensure(gradeConfig.salary, 0),
            permissions = ensure(gradeConfig.permissions, {}),
            label = T(('grade_%s'):format(gradeName))
        }

        job.grades[grade.grade] = grade
        data[jobName] = job
    end

    loaded = true
end

function jobs:getJobIdWithGrade(job, grade)
    job = ensure(job, 'unemployed')
    grade = ensure(grade, 'unemployed')

    if (not loaded) then
        repeat Citizen.Wait(0) until loaded == true
    end

    if (data[job] and data[job].grades) then
        local jobData = ensure(data[job], {})
        local grades = ensure(jobData.grades, {})
        
        for _, jobGrade in pairs(grades) do
            if (jobGrade.name == grade) then
                return ensure(jobData.id, 0), ensure(jobGrade.grade, 0)
            end
        end

        return ensure(jobData.id, 0), nil
    end

    return nil, nil
end

function jobs:getJobId(job)
    job = ensure(job, 'unemployed')

    if (not loaded) then
        repeat Citizen.Wait(0) until loaded == true
    end

    if (data[job]) then        
        return ensure(ensure(data[job], {}).id, 0)
    end

    return nil
end

function jobs:getJobWithGrade(jobId, gradeId)
    jobId = ensure(jobId, 0)
    gradeId = ensure(gradeId, 0)

    if (not loaded) then
        repeat Citizen.Wait(0) until loaded == true
    end

    for k, v in pairs(data) do
        if (v.id == jobId) then
            local newJob = {
                id = ensure(v.id, 0),
                name = ensure(v.name, 'unemployed'),
                grades = ensure(v.grades, {}),
                allowed = ensure(v.allowed, {}),
                webhooks = ensure(v.webhooks, {}),
                label = ensure(v.label, T(('job_%s'):format(v.name))),
                grade = {}
            }

            newJob.grade = ensure(newJob.grades[gradeId], {})

            return newJob
        end
    end

    return nil
end

function jobs:getAll()
    return ensure(data, {})
end

jobs:load()

register('jobs', jobs)