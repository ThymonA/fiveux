object:register('job', function(input)
    local job = ensure(input, {})
    local job_grade = ensure(job.grade, {})

    return {
        name = ensure(job.name, 'unemployed'),
        label = ensure(job.label, 'Unemployed'),
        permissions = ensure(job.allowed, {}),
        grade_name = ensure(job_grade.name, 'unemployed'),
        grade_label = ensure(job_grade.label, 'unemployed'),
        grade_permissions = ensure(job_grade.permissions, {})
    }
end)

object:register('weapon', function(input)
    local weapon = ensure(input, {})

    return {
        name = ensure(weapon.name, 'weapon_unknown'),
        hash = ensure(weapon.hash, -1),
        uuid = ensure(weapon.uuid, 'unknown'),
        bullets = ensure(weapon.bullets, 0),
        attachments = ensure(weapon.attachments, {})
    }
end)

object:register('location', function(input)
    local location = ensure(input, {})
    local weapons = {}

    for uuid, data in pairs(ensure(input.weapons, {})) do
        data = ensure(data, {})

        weapons[ensure(data.name, 'weapon_unknown')] = object:convert('weapon', data)
    end

    return {
        name = ensure(location.name, 'unknown'),
        weapons = weapons
    }
end)

object:register('marker', function(input)
    local marker = ensure(input, {})

    return {
        name = ensure(marker.name, 'unknown'),
        event = ensure(marker.event, 'unknown'),
        type = ensure(marker.type, 1),
        position = ensure(marker.position, vec(0, 0, 0)),
        rgba = ensure(marker.rgba, vec(255, 255, 255, 100)),
        rangeToShow = ensure(marker.rangeToShow, 25.0),
        bobUpAndDown = ensure(marker.bobUpAndDown, false),
        scale = ensure(marker.scale, vec(1, 1, 0.8)),
        rotation = ensure(marker.rotation, vec(0, 0, 0)),
        direction = ensure(marker.direction, vec(0, 0, 0)),
        faceCamera = ensure(marker.faceCamera, false),
        textureDict = ensure(marker.textureDict, 'unknown'),
        textureName = ensure(marker.textureName, 'unknown'),
        activationRange = ensure(marker.activationRange, 1.0),
        hide = ensure(marker.hide, false),
        addon_data = ensure(marker.addon_data, {})
    }
end)