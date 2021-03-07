local data = {}

marker = function(name)
    local m = {
        name = ensure(name, 'unknown'),
        type = 1,
        position = vec(0, 0, 0),
        rgba = vec(255, 255, 255, 100),
        whitelist = { groups = {}, jobs = {} },
        rangeToShow = 25.0,
        bobUpAndDown = false,
        scale = vec(1, 1, 0.8),
        rotation = vec(0, 0, 0),
        direction = vec(0, 0, 0),
        faceCamera = false,
        textureDict = 'mpmissmarkers256',
        textureName = 'custom_icon',
        activationRange = 1.0,
        hide = false
    }

    local mt = setmetatable(m, {
        __call = function(t, options)
            t = ensure(t, {})
            options = ensure(options, {})

            local n = ensure(t.name, 'unknown')

            if (data[n]) then
                local whitelist = ensure(options.whitelist, {})
                local currentWhitelist = ensure(data[n].whitelist, {})

                data[n].type = ensure(options.type, data[n].type)
                data[n].position = ensure(options.position, data[n].position)
                data[n].rgba = ensure(options.rgba, data[n].rgba)
                data[n].whitelist = {
                    groups = ensure(whitelist.groups, currentWhitelist.groups),
                    jobs = ensure(whitelist.jobs, currentWhitelist.jobs)
                }
                data[n].rangeToShow = ensure(options.rangeToShow, data[n].rangeToShow)
                data[n].bobUpAndDown = ensure(options.bobUpAndDown, data[n].bobUpAndDown)
                data[n].scale = ensure(options.scale, data[n].scale)
                data[n].rotation = ensure(options.rotation, data[n].rotation)
                data[n].direction = ensure(options.direction, data[n].direction)
                data[n].faceCamera = ensure(options.faceCamera, data[n].faceCamera)
                data[n].textureDict = ensure(options.textureDict, data[n].textureDict)
                data[n].textureName = ensure(options.textureName, data[n].textureName)
                data[n].activationRange = ensure(options.activationRange, data[n].activationRange)
                data[n].hide = ensure(options.hide, data[n].hide)

                for i = 1, #currentWhitelist.jobs, 1 do ExecuteCommand(('remove_ace job.%s marker.%s allow'):format(ensure(currentWhitelist.jobs[i], 'unemployed'), n)) end
                for i = 1, #currentWhitelist.groups, 1 do ExecuteCommand(('remove_ace group.%s marker.%s allow'):format(ensure(currentWhitelist.groups[i], 'user'), n)) end
                for i = 1, #data[n].whitelist.jobs, 1 do ExecuteCommand(('add_ace job.%s marker.%s allow'):format(ensure(data[n].whitelist.jobs[i], 'unemployed'), n)) end
                for i = 1, #data[n].whitelist.groups, 1 do ExecuteCommand(('add_ace group.%s marker.%s allow'):format(ensure(data[n].whitelist.groups[i], 'user'), n)) end
            end
        end
    })

    data[m.name] = mt

    return data[m.name]
end

markers = {}

function markers:getAll()
    return ensure(data, {})
end

register('marker', marker, true)
register('markers', markers)