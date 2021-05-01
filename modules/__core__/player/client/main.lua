--- Local storage
local playerData = nil

--- Update player position every 5 sec
Citizen.CreateThread(function()
    while not PlayerJoined() do Citizen.Wait(0) end

    while true do
        Citizen.Wait(5000)

        local playerPed = PlayerPedId()
        local position = GetEntityCoords(playerPed)

        TriggerRemote('player:position', position)
    end
end)

--- Set player data
MarkEventAsGlobal('fiveux:setPlayerData')
RegisterEvent('fiveux:setPlayerData', function(data)
    data = ensure(data, {})

    local job = ensure(data.job, {})
    local grade = ensure(job.grade, {})
    local job2 = ensure(data.job2, {})
    local grade2 = ensure(job2.grade, {})

    ---@class playerData
    playerData = {
        fxid = ensure(data.fxid, 'unknown'),
        name = ensure(data.name, 'unknown'),
        identifier = ensure(data.identifier, 'unknown'),
        identifiers = ensureStringList(data.identifiers),
        group = ensure(data.group, 'user'),
        job = {
            name = ensure(job.name, 'unknown'),
            label = ensure(job.label, 'unknown'),
            grade = {
                grade = ensure(grade.grade, 0),
                name =  ensure(grade.name, 'unknown'),
                label = ensure(grade.label, 'unknown')
            }
        },
        job2 = {
            name = ensure(job2.name, 'unknown'),
            label = ensure(job2.label, 'unknown'),
            grade = {
                grade = ensure(grade2.grade, 0),
                name =  ensure(grade2.name, 'unknown'),
                label = ensure(grade2.label, 'unknown')
            }
        }
    }
end)

--- Update group when group has been changed
MarkEventAsGlobal('player:group:set')
RegisterEvent('player:group:set', function(group)
    playerData = ensure(playerData, {})
    playerData.group = ensure(group, 'user')
end)

--- Update job when job has been changed
MarkEventAsGlobal('player:job:set')
RegisterEvent('player:job:set', function(job)
    playerData = ensure(playerData, {})
    job = ensure(job, {})

    local grade = ensure(job.grade, {})

    playerData.job = {
        name = ensure(job.name, 'unknown'),
        label = ensure(job.label, 'unknown'),
        grade = {
            grade = ensure(grade.grade, 0),
            name =  ensure(grade.name, 'unknown'),
            label = ensure(grade.label, 'unknown')
        }
    }
end)

--- Update job2 when job2 has been changed
MarkEventAsGlobal('player:job2:set')
RegisterEvent('player:job2:set', function(job)
    playerData = ensure(playerData, {})
    job = ensure(job, {})

    local grade = ensure(job.grade, {})

    playerData.job2 = {
        name = ensure(job.name, 'unknown'),
        label = ensure(job.label, 'unknown'),
        grade = {
            grade = ensure(grade.grade, 0),
            name =  ensure(grade.name, 'unknown'),
            label = ensure(grade.label, 'unknown')
        }
    }
end)

export('playerdata', function()
    return playerData
end)