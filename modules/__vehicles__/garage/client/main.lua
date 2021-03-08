RegisterLocalEvent('marker:garage_spawn:enter', function(marker)
    local data = get('marker_addon_data')

    print(encode(data))
end)