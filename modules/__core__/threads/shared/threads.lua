local tasks = {}
local task_id = 0

threads = {}

function threads:addTask(func, tick)
    Citizen.CreateThread(function()
        local callback = ensure(func, function() end)
        local wait = ensure(tick, 0)

        while true do
            try(callback, print_error)

            Citizen.Wait(wait)
        end
    end)
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