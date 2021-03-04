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
        func = func,
        canceled = false,
        thread = nil
    }

    tasks[task.id] = task
    tasks[task.id].thread = Citizen.CreateThread(function()
        local taskId = ensure(task.id, 0)

        while tasks[taskId] ~= nil and not tasks[taskId].canceled do
            local wait = ensure(tasks[taskId].tick, 0)
            local callback = ensure(func, function() end)

            if (wait <= 0) then wait = 0 end

            try(callback, print_error)

            Citizen.Wait(wait)
        end
    end)

    return tasks[task.id]
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

register('threads', threads)