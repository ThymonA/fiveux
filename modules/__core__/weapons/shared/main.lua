weapon_info = config('weapons')
weapons = {}

function weapons:getInfo()
    return ensure(weapon_info, {})
end