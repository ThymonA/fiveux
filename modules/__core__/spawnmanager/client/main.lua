local playerData = {}

RegisterPublicNet('update:playerData', function(data)
    playerData = ensure(data, {})

    Citizen.CreateThread(function()
        while true do
            if (NetworkIsPlayerActive(PlayerId())) then
                local model = `s_m_y_blackops_01`
                local position = ensure(playerData.position, vector3(-206.79, -1015.12, 29.14))
    
                if (GetEntityModel(PlayerPedId()) == model) then
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
    
                RequestCollisionAtCoord(position.x, position.y, position.z)
    
                while not HasCollisionLoadedAroundEntity(ped) and timeout < 2000 do
                    timeout = timeout + 1
                    Citizen.Wait(0)
                end
    
                SetEntityCoords(ped, position.x, position.y, position.z, false, false, false, true)
                FreezeEntityPosition(ped, false)
    
                return
            end
    
            Citizen.Wait(0)
        end
    end)
end)