local playerData = {}

RegisterPublicNet('update:playerData', function(data)
    playerData = ensure(data, {})

    local needsToSpawn = ensure(playerData.needsToSpawn, false)

    if (not needsToSpawn) then
        return
    end

    Citizen.CreateThread(function()
        while true do
            if (NetworkIsPlayerActive(PlayerId())) then
                local model = GetHashKey('s_m_y_blackops_01')
                local position = ensure(playerData.position, vec(-206.79, -1015.12, 29.14))
    
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
    
                RequestCollisionAtCoord(position.x, position.y, position.z)
    
                while not HasCollisionLoadedAroundEntity(ped) and timeout < 2000 do
                    timeout = timeout + 1
                    Citizen.Wait(0)
                end
    
                SetEntityCoords(ped, position.x, position.y, position.z, false, false, false, true)
                FreezeEntityPosition(ped, false)

                TriggerLocal('player:spawned', ped, position)
                TriggerNet('player:spawned', position)
    
                return
            end
    
            Citizen.Wait(0)
        end
    end)
end)