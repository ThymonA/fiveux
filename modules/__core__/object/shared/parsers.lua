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