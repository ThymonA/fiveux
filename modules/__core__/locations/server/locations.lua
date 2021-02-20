using 'db'
using 'jobs'
using 'weapons'

local loaded = false
local data = { jobs = {}, players = {} }

locations = {}

function locations:load()
    if (loaded) then return end

    local cfg = config('general')
    local defaultLocations = ensure(cfg.defaultLocations, {})
    local jobList = jobs:getAll()
    local dbResults = db:fetchAll([[
        SELECT `l`.*, `j`.`name` AS `job_name` FROM `locations` AS `l`
        LEFT JOIN `jobs` AS `j`                                   
        ON `l`.`job_id` = `j`.`id`                                
        WHERE `l`.`job_id` IS NOT NULL AND `l`.`player_id` IS NULL
    ]])

    dbResults = ensure(dbResults, {})

    for k, v in pairs(dbResults) do
        local name = ensure(v.name, 'unknown')
        local job_name = ensure(v.job_name, 'unemployed')

        if (data.jobs[job_name] == nil) then data.jobs[job_name] = {} end

        data.jobs[job_name][name] = ensure(v.id, 0)
    end

    for k, v in pairs(jobList) do
        local job_name = ensure(v.name, 'unemployed')
        local job_id = ensure(v.id, 0)
        
        for k2, v2 in pairs(defaultLocations) do
            local types = ensure(v2, {})

            if (any(constants.types.jobs, types, 'value')) then
                local name = ensure(k2, 'unknown')

                if (data.jobs[job_name] == nil) then data.jobs[job_name] = {} end
                if (data.jobs[job_name][name] == nil) then
                    data.jobs[job_name][name] = db:insert('INSERT INTO `locations` (`job_id`, `name`) VALUES (:jobId, :name)', {
                        ['jobId'] = job_id,
                        ['name'] = name
                    })
                end
            end
        end
    end

    loaded = true
end

function locations:getPlayerLocations(citizen)
    citizen = ensure(citizen, 'unknown')

    if (not loaded) then
        repeat Citizen.Wait(0) until loaded == true
    end

    if (data.players[citizen] == nil) then
        local cfg = config('general')
        local defaultLocations = ensure(cfg.defaultLocations, {})
        local dbResults = db:fetchAll([[
            SELECT `l`.* FROM `locations` AS `l`                      
            LEFT JOIN `players` AS `p`                                
            ON `l`.`player_id` = `p`.`id` AND `p`.`citizen` = :citizen
            WHERE `l`.`job_id` IS NULL AND `l`.`player_id` IS NOT NULL
        ]], {
            ['citizen'] = citizen
        })

        dbResults = ensure(dbResults, {})

        for k, v in pairs(dbResults) do
            local name = ensure(v.name, 'unknown')
    
            if (data.players[citizen] == nil) then data.players[citizen] = {} end
    
            data.players[citizen][name] = {
                id = ensure(v.id, 0),
                weapons = weapons:getAllWeapons(ensure(v.id, 0))
            }
        end

        for k, v in pairs(defaultLocations) do
            local types = ensure(v, {})

            if (any(constants.types.player, types, 'value')) then
                local name = ensure(k, 'unknown')

                if (data.players[citizen] == nil) then data.players[citizen] = {} end
                if (data.players[citizen][name] == nil) then
                    data.players[citizen][name] = {
                        id = db:insert('INSERT INTO `locations` (`player_id`, `name`) SELECT `id` AS `player_id`, :name AS `name` FROM `players` WHERE `citizen` = :citizen LIMIT 1', {
                            ['citizen'] = citizen,
                            ['name'] = name
                        }),
                        weapons = {}
                    }
                end
            end
        end
    end

    return ensure(data.players[citizen], {})
end

function locations:getJobLocationId(job_name, name)
    job_name = ensure(job_name, 'unemployed')
    name = ensure(name, 'unknown')

    return ensure(ensure(data.jobs[job_name], {})[name], 0)
end

function locations:getPlayerLocationId(citizen, name)
    citizen = ensure(citizen, 'unknown')
    name = ensure(name, 'unknown')

    return ensure(ensure(data.players[citizen], {})[name], 0)
end

locations:load()

register('locations', locations)