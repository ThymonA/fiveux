using 'threads'

threads:addTask(function()
    TriggerNet('players:position', GetEntityCoords(PlayerPedId()))
end, 1000)