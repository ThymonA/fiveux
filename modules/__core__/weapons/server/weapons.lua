using 'db'

local data = {}

weapons = {}

function weapons:create(location, name, bullets, components)
    location = ensure(location, 0)
    name = ensure(name, 'unknown'):lower()

    if (weapon_info[name] == nil) then
        return
    end

    local cfg = config('general')
    local numberOfClips = ensure(cfg.numberOfClips, 1)
    local weapon = ensure(weapon_info[name], {})
    local defaultComponents = {}

    for k, v in pairs(ensure(weapon.components, {})) do
        if (ensure(v.default, false)) then
            table.insert(defaultComponents, ensure(v.name, 'unknown_component'))
        end
    end

    bullets = ensure(bullets, (weapon.clipSize * numberOfClips))
    components = ensure(components, defaultComponents)

    local weaponId = db:insert('INSERT INTO `weapons` (`uuid`, `location_id`, `name`, `bullets`, `components`) VALUES (UUID_TO_BIN(UUID()), :location, :name, :bullets, :components)', {
        ['location'] = location,
        ['name'] = ensure(weapon.name, 'unknown'),
        ['bullets'] = bullets,
        ['components'] = encode(components)
    })

    local weaponDbResults = db:fetchAll('SELECT BIN_TO_UUID(`uuid`) AS `uuid`, `location_id`, `name`, `bullets`, `components` FROM `weapons` WHERE `id` = :id LIMIT 1', {
        ['id'] = ensure(weaponId, 0)
    })

    weaponDbResults = ensure(weaponDbResults, {})

    local dbWeapon = ensure(weaponDbResults[1], {})
    local dbName = ensure(dbWeapon.name, 'unknown')
    local weaponData = ensure(weapon_info[dbName], {})

    weaponData.id = weaponId
    weaponData.uuid = ensure(dbWeapon.uuid, 'unknown')
    weaponData.location = ensure(dbWeapon.location, 0)
    weaponData.bullets = ensure(dbWeapon.bullets, 0)
    weaponData.attachments = ensure(dbWeapon.components, {})
    weaponData.loaded = false

    data[weaponData.uuid] = weaponData

    return weaponData
end

function weapons:getAllWeapons(location)
    location = ensure(location, 0)

    local results = {}
    local weaponDbResults = db:fetchAll('SELECT `id`, BIN_TO_UUID(`uuid`) AS `uuid`, `location_id`, `name`, `bullets`, `components` FROM `weapons` WHERE `location_id` = :location', {
        ['location'] = location
    })

    weaponDbResults = ensure(weaponDbResults, {})

    for k, v in pairs(weaponDbResults) do
        local dbWeapon = ensure(v, {})
        local dbName = ensure(dbWeapon.name, 'unknown')
        local weaponData = ensure(weapon_info[dbName], {})

        weaponData.id = ensure(dbWeapon.id, 0)
        weaponData.uuid = ensure(dbWeapon.uuid, 'unknown')
        weaponData.location = ensure(dbWeapon.location, 0)
        weaponData.bullets = ensure(dbWeapon.bullets, 0)
        weaponData.attachments = ensure(dbWeapon.components, {})
        weaponData.loaded = false

        data[weaponData.uuid] = weaponData
        results[weaponData.uuid] = weaponData
    end

    return results
end

register('weapons', weapons)