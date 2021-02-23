using 'threads'

local currentTick = 0
local currentTimer = 0
local data = {}
local players = {}
local limits = {}

ratelimit = {}

function ratelimit:registerNet(name, callback, limit, max)
    name = ensure(name, 'unknown')
    callback = ensure(callback, function() end)
    limit = ensure(limit, 0)
    max = ensure(max, 0)

    data[name] = {
        name = name,
        callback = callback,
        limit = limit,
        max = max
    }

    if (ENVIRONMENT == 'client') then
        RegisterPublicNet(name, function(...)
            local event = ensure(name, 'unknown')
            local rateInfo = ensure(data[event], {}, true)
    
            if (rateInfo == nil) then return end
    
            local cb = ensure(rateInfo.callback, function() end)
            local rateLimit = ensure(rateInfo.limit, 0)
            local maxTriggers = ensure(rateInfo.max, 0)
    
            if (limits == nil) then limits = {} end
            if (limits[event] == nil) then limits[event] = { last = 0, triggered  = 0 } end
    
            local numTriggered = ensure(limits[event].triggered, 0)
    
            if (maxTriggers > 0 and maxTriggers <= numTriggered) then
                return
            end
    
            local lastTriggered = ensure(limits[event].last, 0)
            local tick = ensure(currentTick, 0)

            limits[event].triggered = (numTriggered + 1)
            limits[event].last = tick
    
            if ((tick - lastTriggered) < rateLimit) then
                cb(...)
            end
        end)
    elseif (ENVIRONMENT == 'server') then
        RegisterPublicNet(name, function(...)
            local src = ensure(source, 0)
            local event = ensure(name, 'unknown')
            local rateInfo = ensure(data[event], {}, true)
    
            if (rateInfo == nil) then return end
    
            local cb = ensure(rateInfo.callback, function() end)
            local rateLimit = ensure(rateInfo.limit, 0)
            local maxTriggers = ensure(rateInfo.max, 0)
    
            if (players == nil) then players = {} end
            if (players[src] == nil) then players[src] = {} end
            if (players[src][event] == nil) then players[src][event] = { last = 0, triggered  = 0 } end
    
            local numTriggered = ensure(players[src][event].triggered, 0)
    
            if (maxTriggers > 0 and maxTriggers <= numTriggered) then
                return
            end
    
            local lastTriggered = ensure(players[src][event].last, 0)
            local tick = ensure(currentTick, 0)

            players[src][event].triggered = (numTriggered + 1)
            players[src][event].last = tick
    
            if ((tick - lastTriggered) < rateLimit) then
                cb(src, ...)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local timer = GetGameTimer()
        local currentTime = ensure(currentTimer, 0)
        local addTime = round((timer - currentTime) / 1.25, 2)

        currentTick = currentTick + addTime
        currentTick = currentTick <= 65565 and currentTick or 0
        currentTimer = timer

        Citizen.Wait(5)
    end
end)

register('ratelimit', ratelimit)