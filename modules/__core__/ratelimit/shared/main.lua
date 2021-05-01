--- Local storage
local data = {}
local history = {}

---@class ratelimits
ratelimits = {}

--- Register a net event with protection
---@param event string Name of event
---@param callback function Function to exectue
---@param limit number Max execution each `x` time
---@param max number Max execution `x` times
function ratelimits:addEvent(event, callback, limit, max)
    event = ensure(event, 'unknown')
    callback = ensure(callback, function() end)
    limit = ensure(limit, 0)
    max = ensure(max, 0)

    ---@class ratelimit
    local ratelimit = {
        event = event,
        callback = callback,
        limit = limit,
        max = max
    }
    
    data[event] = ratelimit

    if (ENVIRONMENT == 'server') then
        RegisterNetEvent(event)
        AddEventHandler(event, function(...)
            local playerSrc = ensure(source, 0)
            local _event = ensure(event, 'unknown')
            local info = ensure(data[_event], {}, true)
            
            if (info == nil) then return end

            local func = ensure(info.callback, function() end)
            local _limit = ensure(info.limit, 0)
            local _max = ensure(info.max, 0)

            if (history == nil) then history = {} end
            if (history[playerSrc] == nil) then history[playerSrc] = {} end
            if (history[playerSrc][_event] == nil) then history[playerSrc][_event] = { lastTime = 0, triggerTimes = 0, executing = false } end

            local _executing = ensure(history[playerSrc][_event].executing, false)

            if (_executing) then
                emit('ratelimit:log', 'execute', playerSrc, _event, info)
                return
            end

            history[playerSrc][_event].executing = true

            local _triggerTimes = ensure(history[playerSrc][_event].triggerTimes, 0)

            if (_max > 0 and _max <= _triggerTimes) then
                emit('ratelimit:log', 'max', playerSrc, _event, info)
                return
            end

            local _lastTime = ensure(history[playerSrc][_event].lastTime, 0)
            local _timer = self:getCurrentTime()

            if ((_lastTime + _limit) > _timer) then
                emit('ratelimit:log', 'time', playerSrc, _event, info)
                return
            end

            history[playerSrc][_event].lastTime = _timer
            history[playerSrc][_event].triggerTimes = _triggerTimes + 1

            local ok = xpcall(func, print_error, ...)

            while ok == nil do Citizen.Wait(0) end

            history[playerSrc][_event].executing = false
        end)
    elseif (ENVIRONMENT == 'client') then
        RegisterNetEvent(event)
        AddEventHandler(event, function(...)
            local _event = ensure(event, 'unknown')
            local info = ensure(data[_event], {}, true)
            
            if (info == nil) then return end

            local func = ensure(info.callback, function() end)
            local _limit = ensure(info.limit, 0)
            local _max = ensure(info.max, 0)

            if (history == nil) then history = {} end
            if (history[_event] == nil) then history[_event] = { lastTime = 0, triggerTimes = 0, executing = false } end

            local _executing = ensure(history[_event].executing, false)

            if (_executing) then
                emit('ratelimit:log', 'execute', _event, info)
                return
            end

            history[_event].executing = true

            local _triggerTimes = ensure(history[_event].triggerTimes, 0)

            if (_max > 0 and _max <= _triggerTimes) then
                emit('ratelimit:log', 'max', _event, info)
                return
            end

            local _lastTime = ensure(history[_event].lastTime, 0)
            local _timer = self:getCurrentTime()

            if ((_lastTime + _limit) > _timer) then
                emit('ratelimit:log', 'time', _event, info)
                return
            end

            history[_event].lastTime = _timer
            history[_event].triggerTimes = _triggerTimes + 1

            local ok = xpcall(func, print_error, ...)

            while ok == nil do Citizen.Wait(0) end

            history[_event].executing = false
        end)
    end
end

--- Get any timer
---@return number Current time
function ratelimits:getCurrentTime()
    if (os ~= nil and os.time ~= nil and os.date ~= nil) then
        return ensure(os.time(os.date("!*t")), 0)
    end

    return ensure(GetGameTimer(), 0)
end

--- Export ratelimits
export('ratelimits', ratelimits)