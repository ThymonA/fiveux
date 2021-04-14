local __loaded = false
local __serverLoaded = false

MarkEventAsGlobal('fiveux:status')
RegisterEvent('fiveux:status', function(status)
    __serverLoaded = ensure(status, false)
end)

--- Detects when a player is fully loaded
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Citizen.Wait(0) end
    while not FrameworkLoaded() do Citizen.Wait(0) end
    while not __serverLoaded do
        TriggerRemote('fiveux:status')
        Citizen.Wait(500)
    end

    TriggerRemote('playerJoined')

    __loaded = true
end)

--- Checks if player is joined
---@return boolean Player joined
_G.PlayerJoined = function()
    return ensure(__loaded, false)
end