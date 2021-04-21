--- Default values
local default_vector3 = vec(0, 0, 0)

--- Local storage
local __loaded = false
local __serverLoaded = false
local __playerSpawned = false

--- Returns current running state of server
MarkEventAsGlobal('fiveux:status')
RegisterEvent('fiveux:status', function(status)
    __serverLoaded = ensure(status, false)
end)

--- Spawn player based on server info
MarkEventAsGlobal('fiveux:spawn')
RegisterEvent('fiveux:spawn', function(modelName, coords, skin)
    modelName = ensure(modelName, 'unknown')
    coords = ensure(coords, default_vector3)
    skin = ensure(skin, {})

    ---@type skins
    local skins = GetExport('skins')
    local cfg = GetConfiguration('general')
    local defaultModel = ensure(cfg.defaultModel, 'mp_m_freemode_01')

    if (modelName == 'unknown') then
        local defaultHash = GetHashKey(defaultModel)

        RequestModel(defaultHash)

        while not HasModelLoaded(defaultHash) do
            Citizen.Wait(0)
        end

        local pId = PlayerId()

        SetPlayerModel(pId, defaultHash)

        local ped = PlayerPedId()

        SetPedDefaultComponentVariation(ped)

        SetModelAsNoLongerNeeded(defaultHash)

        DoScreenFadeIn(2500)
        ShutdownLoadingScreen()

        FreezeEntityPosition(ped, true)
        SetCanAttackFriendly(ped, true, false)

        NetworkSetFriendlyFireOption(true)
        ClearPlayerWantedLevel(pId)
        SetMaxWantedLevel(0)

        local timeout = 0

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        while not HasCollisionLoadedAroundEntity(ped) and timeout < 2000 do
            timeout = timeout + 1
            Citizen.Wait(0)
        end

        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
        PlaceObjectOnGroundProperly(ped)

        local finished = false

        TriggerEvent('skins:create', function() finished = true end)

        while finished == false do Citizen.Wait(0) end
        
        ped = PlayerPedId()

        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
        FreezeEntityPosition(ped, false)

        TriggerRemote('playerSpawned')

        __playerSpawned = true
    end

    local model = GetHashKey(modelName)

    if (GetEntityModel(PlayerPedId()) == model) then
        __playerSpawned = true
        return
    end

    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local pId = PlayerId()

    SetPlayerModel(pId, model)

    local ped = PlayerPedId()

    SetPedDefaultComponentVariation(ped)
    SetModelAsNoLongerNeeded(model)

    DoScreenFadeIn(2500)
    ShutdownLoadingScreen()

    FreezeEntityPosition(ped, true)
    SetCanAttackFriendly(ped, true, false)

    NetworkSetFriendlyFireOption(true)
    ClearPlayerWantedLevel(pId)
    SetMaxWantedLevel(0)

    local timeout = 0
    local playerSkin = skins:create(ped)

    playerSkin:load(skin, function(ped)
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)

        while not HasCollisionLoadedAroundEntity(ped) and timeout < 2000 do
            timeout = timeout + 1
            Citizen.Wait(0)
        end

        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, true)
        FreezeEntityPosition(ped, false)

        TriggerRemote('playerSpawned')

        __playerSpawned = true
    end)
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

    while not __playerSpawned do Citizen.Wait(0) end

    __loaded = true
end)

--- Checks if player is joined
---@return boolean Player joined
_G.PlayerJoined = function()
    return ensure(__loaded, false)
end