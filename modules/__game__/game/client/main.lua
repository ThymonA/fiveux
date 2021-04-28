import 'streaming'

--- Default values
local default_vector3 = vec(0, 0, 0)

---@class game
game = {}

--- Spawn vehicle (async)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@param callback function Callback to execute
function game:spawnVehicleAsync(model, coords, heading, callback)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)
    callback = ensure(callback, function() end)

    Citizen.CreateThread(function()
        if (streaming:requestModel(model)) then
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z + 1.0, heading, true, false)

            SetVehicleNeedsToBeHotwired(vehicle, false)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetEntityAsMissionEntity(vehicle, true, true)
            SetVehicleIsStolen(vehicle, false)
            SetVehicleIsWanted(vehicle, false)
            SetVehRadioStation(vehicle, 'OFF')

            callback(vehicle)
        else
            callback(nil)
        end
    end)
end

--- Spawn vehicle (sync)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@return number|nil Vehicle entity
function game:spawnVehicle(model, coords, heading)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)

    local veh, finished = nil, false

    self:spawnVehicleAsync(model, coords, heading, function(vehicle)
        veh = vehicle
        finished = true
    end)

    repeat Citizen.Wait(0) until finished == true

    return veh
end

--- Spawn local vehicle (async)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@param callback function Callback to execute
function game:spawnLocalVehicleAsync(model, coords, heading, callback)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)
    callback = ensure(callback, function() end)

    Citizen.CreateThread(function()
        if (streaming:requestModel(model)) then
            local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z + 1.0, heading, false, false)

            SetVehicleNeedsToBeHotwired(vehicle, false)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)
            SetEntityAsMissionEntity(vehicle, true, false)
            SetVehicleIsStolen(vehicle, false)
            SetVehicleIsWanted(vehicle, false)
            SetVehRadioStation(vehicle, 'OFF')
            SetModelAsNoLongerNeeded(model)

            callback(vehicle)
        else
            callback(nil)
        end
    end)
end

--- Spawn vehicle (sync)
---@param model any|number Model or hash of vehicle
---@param coords vector3 Vehicle coords
---@param heading number Heading of vehicle
---@return number|nil Vehicle entity
function game:spawnLocalVehicle(model, coords, heading)
    model = ensureHash(model)
    coords = ensure(coords, default_vector3)
    heading = ensure(heading, 0.0)

    local veh, finished = nil, false

    self:spawnLocalVehicleAsync(model, coords, heading, function(vehicle)
        veh = vehicle
        finished = true
    end)

    repeat Citizen.Wait(0) until finished == true

    return veh
end

--- Delete given vehicle
---@param entity any Vehicle entity to delete
function game:deleteVehicle(entity)
    SetEntityAsMissionEntity(entity, false, true)
    DeleteVehicle(entity)
end

--- Request control of entity (async)
---@param entity any Entity to get control of
---@param attempts number Number of attempts, default: 0
---@param callback function Callback to execute
function game:requestControlOfEntityAsync(entity, attempts, callback)
    attempts = ensure(attempts, 0)
    callback = ensure(callback, function() end)

    Citizen.CreateThread(function()
        local attempt = 0

        while not NetworkHasControlOfEntity(entity) and (attempts == 0 or attempt < attempts) and DoesEntityExist(entity) do
            attempt = attempt + 1
            NetworkRequestControlOfEntity(entity)
            Citizen.Wait(50)
        end

        if (DoesEntityExist(entity) and NetworkHasControlOfEntity(entity)) then
            callback(true)
        else
            callback(false)
        end
    end)
end

--- Request control of entity (sync)
---@param entity any Entity to get control of
---@param attempts number Number of attempts, default: 0
---@return boolean Has control of entity
function game:requestControlOfEntity(entity, attempts)
    attempts = ensure(attempts, 0)

    local res, finished = nil, false

    self:requestControlOfEntityAsync(entity, attempts, function(result)
        res = result
        finished = true
    end)

    repeat Citizen.Wait(0) until finished == true

    return res
end

function game:getVehicleProperties(vehicle, ignoreDefault, ignoreModel, ignorePlate, ignoreStatus)
    vehicle = ensure(vehicle, 0)
    ignoreDefault = ensure(ignoreDefault, true)
    ignoreModel = ensure(ignoreModel, true)
    ignorePlate = ensure(ignorePlate, true)
    ignoreStatus = ensure(ignoreStatus, true)

    if (not DoesEntityExist(vehicle)) then return nil end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local results = {
        ['colors'] = {
            ['primary'] = colorPrimary,
            ['secondary'] = colorSecondary,
            ['pearlescent'] = pearlescentColor,
            ['wheel'] = wheelColor
        }
    }
    local vehicleExtras = {}
    local vehicleNeonEnabled = {}

    --- Add all enabled extra's
    for extra = 0, 14, 1 do
        if (DoesExtraExist(vehicle, extra) and IsVehicleExtraTurnedOn(vehicle, extra) == 1) then
            table.insert(vehicleExtras, extra)
        end
    end

    --- Add all added neon lights
    for neon = 0, 3, 1 do
        local neonEnabled = IsVehicleNeonLightEnabled(vehicle, neon) == 1

        if (neonEnabled) then
            table.insert(vehicleNeonEnabled, neon)
        end
    end

    --- Set all mod type values of vehicle entity
    for name, modIndex in pairs(constants.vehicle.modTypes) do
        local modValue = GetVehicleMod(vehicle, modIndex)
        local modKey = ('mod%s'):format(name)

        if ((not ignoreDefault or modValue >= 0) and modIndex ~= constants.vehicle.modTypes.livery) then
            results[modKey] = modValue
        end
    end

    --- Set all toggable options of vehicle entity
    for name, modIndex in pairs(constants.vehicle.toggleModTypes or {}) do
        local modValue = IsToggleModOn(vehicle, modIndex)
        local modKey = ('mod%s'):format(name)

        if (not ignoreDefault or modValue) then
            results[modKey] = modValue
        end
    end

    if (not ignoreModel) then results['model'] = GetEntityModel(vehicle) end
    if (not ignorePlate) then results['plate'] = GetVehicleNumberPlateText(vehicle) end

    if (not ignoreStatus) then
        local bodyHealth = round(GetVehicleBodyHealth(vehicle), 1)
        local engineHealth = round(GetVehicleEngineHealth(vehicle), 1)
        local tankHealth = round(GetVehiclePetrolTankHealth(vehicle), 1)
        local fuelLevel = round(GetVehicleFuelLevel(vehicle), 1)
        local dirtLevel = round(GetVehicleDirtLevel(vehicle), 1)

        if (not ignoreDefault or bodyHealth <= 950) then results['bodyHealth'] = bodyHealth end
        if (not ignoreDefault or engineHealth <= 950) then results['engineHealth'] = engineHealth end
        if (not ignoreDefault or tankHealth <= 950) then results['tankHealth'] = tankHealth end
        if (not ignoreDefault or fuelLevel <= 950) then results['fuelLevel'] = fuelLevel end
        if (not ignoreDefault or dirtLevel >= 1) then results['dirtLevel'] = dirtLevel end
    end

    if (not ignoreDefault or #vehicleExtras > 0) then results['extras'] = vehicleExtras end
    if (not ignoreDefault or #vehicleNeonEnabled > 0) then results['neonEnabled'] = vehicleNeonEnabled end

    local plateIndex = GetVehicleNumberPlateTextIndex(vehicle)
    local windowTint = GetVehicleWindowTint(vehicle)
    local xenonColor = GetVehicleXenonLightsColour(vehicle)
    local livery = GetVehicleLivery(vehicle)

    if (not ignoreDefault or plateIndex > 0) then results['plateIndex'] = plateIndex end
    if (not ignoreDefault or (windowTint > 0 and windowTint ~= 4)) then results['windowTint'] = windowTint end
    if (not ignoreDefault or (xenonColor >= 0 and xenonColor ~= 255)) then results['colors']['xenon'] = xenonColor end
    if (not ignoreDefault or (#vehicleNeonEnabled > 0)) then results['colors']['neon'] = table.pack(GetVehicleNeonLightsColour(vehicle)) end
    if (not ignoreDefault or IsToggleModOn(vehicle, constants.vehicle.toggleModTypes.tiresmoke)) then results['colors']['tyreSmoke'] = table.pack(GetVehicleTyreSmokeColor(vehicle)) end
    if (not ignoreDefault or livery > 0) then results['modLivery'] = livery end

    results['wheels'] = GetVehicleWheelType(vehicle)

    return results
end

function game:setVehicleProperties(vehicle, props, setNullToDefault)
    vehicle = ensure(vehicle, 0)
    setNullToDefault = ensure(setNullToDefault, false)
    props = ensure(props, {})

    if (not DoesEntityExist(vehicle)) then return end

    SetVehicleModKit(vehicle, 0)

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    if ((props.plateIndex == nil or not props.plateIndex) and setNullToDefault) then props.plateIndex = 0 end
    if ((props.bodyHealth == nil or not props.bodyHealth) and setNullToDefault) then props.bodyHealth = 1000 end
    if ((props.engineHealth == nil or not props.engineHealth) and setNullToDefault) then props.engineHealth = 1000 end
    if ((props.tankHealth == nil or not props.tankHealth) and setNullToDefault) then props.tankHealth = 1000 end
    if ((props.fuelLevel == nil or not props.fuelLevel) and setNullToDefault) then props.fuelLevel = 1000 end
    if ((props.dirtLevel == nil or not props.dirtLevel) and setNullToDefault) then props.dirtLevel = 0 end
    if ((props.windowTint == nil or not props.windowTint) and setNullToDefault) then props.windowTint = 4 end
    if (props.colors == nil or not props.colors) then props.colors = {} end
    if ((props.colors.xenon == nil or not props.colors.xenon) and setNullToDefault) then props.colors.xenon = -1 end

    if ((props.extras == nil or not props.extras) and setNullToDefault) then
        props.extras = { [0] = false, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false, [9] = false, [10] = false, [11] = false, [12] = false, [13] = false, [14] = false }
    elseif(props.extras ~= nil and props.extras) then
        local extras = {}

        for _, index in pairs(props.extras or {}) do
            extras[index] = true
        end

        props.extras = extras
    else
        props.extras = {}
    end

    if ((props.neonEnabled == nil or not props.neonEnabled) and setNullToDefault) then
        props.neonEnabled = { [0] = false, [1] = false, [2] = false, [3] = false }
    elseif(props.neonEnabled ~= nil and props.neonEnabled) then
        local neonEnabled = {}

        for _, index in pairs(props.neonEnabled or {}) do
            neonEnabled[index] = true
        end

        props.neonEnabled = neonEnabled
    else
        props.neonEnabled = {}
    end

    if (props.plate ~= nil and props.plate) then SetVehicleNumberPlateText(vehicle, props.plate) end
    if (props.plateIndex ~= nil and props.plateIndex) then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if (props.bodyHealth ~= nil and props.bodyHealth) then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if (props.engineHealth ~= nil and props.engineHealth) then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if (props.tankHealth ~= nil and props.tankHealth) then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
    if (props.fuelLevel ~= nil and props.fuelLevel) then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if (props.dirtLevel ~= nil and props.dirtLevel) then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end

    if ((props.colors.primary ~= nil and props.colors.primary) or (props.colors.secondary ~= nil and props.colors.secondary)) then
        SetVehicleColours(vehicle, props.colors.primary or colorPrimary, props.colors.secondary or colorSecondary)
    end

    if ((props.colors.pearlescent ~= nil and props.colors.pearlescent) or (props.colors.wheel ~= nil and props.colors.wheel)) then
        SetVehicleExtraColours(vehicle, props.colors.pearlescent or pearlescentColor, props.colors.wheel or wheelColor)
    end

    if (props.colors.neon ~= nil and props.colors.neon) then
        SetVehicleNeonLightsColour(vehicle, props.colors.neon[1] or 255, props.colors.neon[2] or 255, props.colors.neon[3] or 255)
    end

    if (props.colors.tyreSmoke ~= nil and props.colors.tyreSmoke) then
        SetVehicleTyreSmokeColor(vehicle, props.colors.tyreSmoke[1] or 255, props.colors.tyreSmoke[2] or 255, props.colors.tyreSmoke[3] or 255)
    end

    if (props.colors.xenon ~= nil and props.colors.xenon) then SetVehicleXenonLightsColour(vehicle, props.colors.xenon) end
    if (props.wheels ~= nil and props.wheels) then SetVehicleWheelType(vehicle, props.wheels) end
    if (props.windowTint ~= nil and props.windowTint) then SetVehicleWindowTint(vehicle, props.windowTint) end

    -- Enable or disbale neon's
    for i = 0, 3, 1 do
        if (props.neonEnabled[i]) then
            SetVehicleNeonLightEnabled(vehicle, i, true)
        elseif (setNullToDefault) then
            SetVehicleNeonLightEnabled(vehicle, i, false)
        end
    end

    -- Enable or disable extra's
    for i = 0, 14, 1 do
        local extraExits = DoesExtraExist(vehicle, i)

        if (extraExits and props.extras[i]) then
            SetVehicleExtra(vehicle, i, false)
        elseif (extraExits and setNullToDefault) then
            SetVehicleExtra(vehicle, i, true)
        end
    end

    --- Set all mod type values of vehicle entity
    for name, modIndex in pairs(constants.vehicle.modTypes) do
        local modKey = ('mod%s'):format(name)

        if ((props[modKey] == nil or not props[modKey]) and setNullToDefault) then props[modKey] = -1 end

        if (props[modKey] ~= nil and props[modKey]) then
            SetVehicleMod(vehicle, modIndex, props[modKey], false)

            if (modIndex == constants.vehicle.modTypes.livery) then
                if (props[modKey] == -1) then props[modKey] = 0 end

                SetVehicleLivery(vehicle, props[modKey])
            end
        end
    end

    --- Set all mod type values of vehicle entity
    for name, modIndex in pairs(constants.vehicle.toggleModTypes) do
        local modKey = ('mod%s'):format(name)

        if (props[modKey] == nil and setNullToDefault) then props[modKey] = false end
        if (props[modKey] ~= nil) then ToggleVehicleMod(vehicle, modIndex, props[modKey]) end
    end
end

function game:getClosestEntity(entities, isPlayerEntities, coords, modelFilter)
    local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

    entities = ensure(entities, {})
    isPlayerEntities = ensure(isPlayerEntities, false)
	coords = ensure(coords, default_vector3)
    modelFilter = ensure(modelFilter, {})

    if (coords == default_vector3) then
        local playerPed = PlayerPedId()

        coords = GetEntityCoords(playerPed)
    end

	if (#modelFilter > 0) then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if (modelFilter[GetEntityModel(entity)]) then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if (closestEntityDistance == -1 or distance < closestEntityDistance) then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

--- Returns closes vehicle based on given coords and filter
---@param coords vector3 Coords to search for
---@param modelFilter table Entity filter
---@return number Founded closest entity
---@return number Closest distance
function game:getClosestVehicle(coords, modelFilter)
    coords = ensure(coords, default_vector3)
    modelFilter = ensure(modelFilter, {})

    return self:getClosestEntity(self:getVehicles(), false, coords, modelFilter)
end

function game:getVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

--- Export game
export('game', game)