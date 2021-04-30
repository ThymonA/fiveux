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

    if (not DoesEntityExist(vehicle)) then return {} end

    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

    primaryColor = ensure(primaryColor, 0)
    secondaryColor = ensure(secondaryColor, 0)
    pearlescentColor = ensure(pearlescentColor, 0)
    wheelColor = ensure(wheelColor, 0)

    local results = {
        colors = {
            primary = primaryColor,
            secondary = secondaryColor,
            pearlsecent = pearlescentColor,
            wheel = wheelColor
        },
        extras = {},
        neons = {},
        mods = {},
        info = {},
        status = {}
    }

    --- Add all enabled extra's
    for extraIndex = 0, 14, 1 do 
        local hasExtra = DoesExtraExist(vehicle, extraIndex)
        local extraTurnedOn = IsVehicleExtraTurnedOn(vehicle, extraIndex)

        hasExtra = ensure(hasExtra, false)
        extraTurnedOn = ensure(extraTurnedOn, false)

        if (hasExtra and extraTurnedOn) then
            table.insert(results.extras, extraIndex)
        end
    end

    --- Add all added neon lights
    for neonIndex = 0, 3, 1 do
        local neonEnabled = IsVehicleNeonLightEnabled(vehicle, neonIndex)

        neonEnabled = ensure(neonEnabled, false)

        if (neonEnabled) then
            table.insert(results.neons, neonIndex)
        end
    end

    --- Set all mod type values of vehicle entity
    for name, modIndex in pairs(constants.vehicle.modTypes) do
        local modValue = GetVehicleMod(vehicle, modIndex)

        modValue = ensure(modValue, 0)
        name = name:lower()

        if (not ignoreDefault or modValue > 0) then
            results.mods[name] = modValue
        end
    end

    --- Set all toggable options of vehicle entity
    for name, modIndex in pairs(constants.vehicle.toggleModTypes) do
        local modValue = IsToggleModOn(vehicle, modIndex)
        
        modValue = ensure(modValue, false)
        name = name:lower()

        if (not ignoreDefault or modValue) then
            results.mods[name] = modValue
        end
    end

    if (not ignorePlate) then
        local plate = GetVehicleNumberPlateText(vehicle)

        results.info.plate = ensure(plate, 'XXXXXXX')
            :replace(' ', '-')
            :upper()
    end

    if (not ignoreModel) then
        local model = GetEntityModel(vehicle)

        results.info.model = ensure(model, 0)
    end

    if (not ignoreStatus) then
        results.status.body = round(GetVehicleBodyHealth(vehicle), 1)
        results.status.engine = round(GetVehicleEngineHealth(vehicle), 1)
        results.status.tank = round(GetVehiclePetrolTankHealth(vehicle), 1)
        results.status.fuel = round(GetVehicleFuelLevel(vehicle), 1)
        results.status.dirt = round(GetVehicleDirtLevel(vehicle), 1)
    end

    local plateIndex = GetVehicleNumberPlateTextIndex(vehicle)
    local windowTint = GetVehicleWindowTint(vehicle)
    local xenonColor = GetVehicleXenonLightsColour(vehicle)
    local livery = GetVehicleLivery(vehicle)
    local neon = table.pack(GetVehicleNeonLightsColour(vehicle))
    local tyresmoke = table.pack(GetVehicleTyreSmokeColor(vehicle))

    plateIndex = ensure(plateIndex, 0)
    windowTint = ensure(windowTint, 0)
    xenonColor = ensure(xenonColor, 0)
    livery = ensure(livery, 0)
    neon = ensure(neon, {})
    tyresmoke = ensure(tyresmoke, {})

    if (not ignoreDefault or plateIndex > 0) then results.mods.plateIndex = plateIndex end
    if (not ignoreDefault or (windowTint > 0 and windowTint ~= 4)) then results.mods.windowTint = windowTint end
    if (not ignoreDefault or (xenonColor >= 0 and xenonColor ~= 255)) then results.colors.xenon = xenonColor end
    if (not ignoreDefault or livery > 0) then results.mods.livery = livery end
    
    results.colors.neon = { ensure(neon[1], 255), ensure(neon[2], 255), ensure(neon[3], 255) }
    results.colors.tyresmoke = { ensure(tyresmoke[1], 255), ensure(tyresmoke[2], 255), ensure(tyresmoke[3], 255) }
    results.mods.wheels = GetVehicleWheelType(vehicle)

    return results
end

function game:setVehicleProperties(vehicle, props)
    vehicle = ensure(vehicle, 0)
    props = ensure(props, {})

    if (not DoesEntityExist(vehicle)) then return end
    
    SetVehicleModKit(vehicle, 0)

    local colors = ensure(props.colors, {})
    local extras = ensure(props.extras, {})
    local neons = ensure(props.neons, {})
    local mods = ensure(props.mods, {})
    local info = ensure(props.info, {})
    local status = ensure(props.status, {})

    --- Set all enabled extra's
    for extraIndex = 0, 14, 1 do 
        local hasExtra = DoesExtraExist(vehicle, extraIndex)
        local hasEnabled = any(extraIndex, extras, 'value')

        hasExtra = ensure(hasExtra, false)
        hasEnabled = ensure(hasEnabled, false)

        if (hasExtra) then
            SetVehicleExtra(vehicle, extraIndex, hasEnabled)
        end
    end

    --- Set all neon lights
    for neonIndex = 0, 3, 1 do
        local hasEnabled = any(neonIndex, neons, 'value')

        hasEnabled = ensure(hasEnabled, false)

        SetVehicleNeonLightEnabled(vehicle, neonIndex, hasEnabled)
    end

    --- Set all mod type values of vehicle entity
    for name, modIndex in pairs(constants.vehicle.modTypes) do
        name = name:lower()

        local modValue = ensure(mods[name], 0)

        SetVehicleMod(vehicle, modIndex, modValue, false)
    end

    --- Set all toggable options of vehicle entity
    for name, modIndex in pairs(constants.vehicle.toggleModTypes) do
        name = name:lower()

        local modValue = ensure(mods[name], false)

        ToggleVehicleMod(vehicle, modIndex, modValue)
    end

    local primaryColor = ensure(colors.primary, 0)
    local secondaryColor = ensure(colors.secondary, 0)
    local pearlescentColor = ensure(colors.pearlsecent, 0)
    local wheelColor = ensure(colors.wheel, 0)
    local plate = ensure(info.plate, 'XXXXXXX'):replace(' ', '-'):upper()
    local body = ensure(status.body, 1000) + 0.0
    local engine = ensure(status.engine, 1000) + 0.0
    local tank = ensure(status.tank, 1000) + 0.0
    local fuel = ensure(status.fuel, 1000) + 0.0
    local dirt = ensure(status.dirt, 0) + 0.0
    local plateIndex = ensure(mods.plateIndex, 0)
    local windowTint = ensure(mods.windowTint, 0)
    local xenonColor = ensure(colors.xenon, 0)
    local livery = ensure(mods.livery, 0)
    local neon = ensure(colors.neon, {})
    local tyresmoke = ensure(colors.tyresmoke, {})
    local wheels = ensure(mods.wheels, 0)

    if (plate ~= 'XXXXXXX') then SetVehicleNumberPlateText(vehicle, plate) end

    SetVehicleColours(vehicle, primaryColor, secondaryColor)
    SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor)
    SetVehicleBodyHealth(vehicle, body)
    SetVehicleEngineHealth(vehicle, engine)
    SetVehiclePetrolTankHealth(vehicle, tank)
    SetVehicleFuelLevel(vehicle, fuel)
    SetVehicleDirtLevel(vehicle, dirt)
    SetVehicleNumberPlateTextIndex(vehicle, plateIndex)
    SetVehicleWindowTint(vehicle, windowTint)
    SetVehicleXenonLightsColour(vehicle, xenonColor)
    SetVehicleLivery(vehicle, livery)
    SetVehicleNeonLightsColour(vehicle, ensure(neon[1], 255), ensure(neon[2], 255), ensure(neon[3], 255))
    SetVehicleTyreSmokeColor(vehicle, ensure(tyresmoke[1], 255), ensure(tyresmoke[2], 255), ensure(tyresmoke[3], 255))
    SetVehicleWheelType(vehicle, wheels)
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