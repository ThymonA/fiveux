RegisterNUICallback('ready', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    print('WHEEL IS READY!!!')

    callback('ok')
end)