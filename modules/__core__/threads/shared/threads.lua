local tasks = {}
local task_id = 0

threads = {}

function threads:addTask(func, tick)
    func = ensure(func, function() end)
    tick = ensure(tick, 0)
    task_id = task_id + 1

    local task = {
        id = task_id,
        tick = tick,
        last_tick = 0,
        func = func,
        canceled = false
    }

    tasks[task.id] = task

    return task.id
end

function threads:removeTask(id)
    id = ensure(id, 0)

    if (id <= 0 or tasks[id] == nil) then
        return
    end

    if (not tasks[id].canceled) then
        tasks[id] = nil
    end
end

Citizen.CreateThread(function()
    while true do
        for id, task in pairs(tasks) do
            if (task.tick == task.last_tick) then
                _ENV.task_id = task.id

                task.func()
                task.last_tick = 0
            else
                task.last_tick = task.last_tick + 1
            end
        end

        _ENV.task_id = nil

        Citizen.Wait(0)
    end
end)

register('threads', threads)