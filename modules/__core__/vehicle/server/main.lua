import 'db'
import 'logs'
import 'players'

--- Local storage
---@type table<string, vehicle>
local data = {}
---@type table<number, string>
local ids = {}

---@class vehicles
vehicles = {}

local cfg = config('general')
local plateFormats = ensure(cfg.plateFormats, {})

--- Add a vehicle to framework
---@param fxid string FiveUX ID
---@param model string Vehicle model
---@return vehicle Generated vehicle object
function vehicles:add(fxid, model, props)
    fxid = ensure(fxid, 'unknown')
    model = ensure(model, 'unknown')
    props = ensure(props, {})

    if (data == nil) then data = {} end

    local owner = players:loadByFx(fxid)

    if (owner == nil) then return nil end

    local newPlate = self:generatePlate()
    local hash = GetHashKey(model)
    local vehicleId = db:insert('INSERT INTO `vehicles` (`fxid`, `plate`, `vehicle`, `model`, `hash`) VALUES (:fxid, :plate, :vehicle, :model, :hash)', {
        ['fxid'] = owner.fxid,
        ['plate'] = newPlate,
        ['vehicle'] = encode(props, false, 0),
        ['model'] = model,
        ['hash'] = hash
    })

    if (vehicleId <= 0) then return nil end

    local vehicle =  self:getByPlate(newPlate)

    if (vehicle == nil) then return nil end

    vehicle:log({
        action = 'vehicle.add',
        color = constants.colors.green,
        message = T('vehicle_add_message', newPlate, owner.name),
        title = T('vehicle_add_title', newPlate),
        footer = ('%s | %s | %s\n{time}'):format(newPlate, model, owner.fxid),
        arguments = { fxid = owner.fxid }
    })

    return vehicle
end

function vehicles:getById(id)
    id = ensure(id, 0)

    if (ids == nil) then ids = {} end
    if (ids[id] ~= nil) then return self.getByPlate(ids[id]) end

    local dbResult = db:fetchAll('SELECT `plate` FROM `vehicles` WHERE `id` = :id LIMIT 1', { ['id'] = id })

    dbResult = ensure(dbResult, {})

    if (#dbResult <= 0) then return nil end

    return self:getByPlate(ensure(dbResult[1].plate, 'XXXXXXX'))
end

function vehicles:getByPlate(plate)
    plate = ensure(plate, 'unknown')

    if (data == nil) then data = {} end
    if (data[plate] ~= nil) then return data[plate] end

    local dbVehicles = db:fetchAll('SELECT * FROM `vehicles` WHERE `plate` = :plate LIMIT 1', {
        ['plate'] = plate
    })

    dbVehicles = ensure(dbVehicles, {})

    if (#dbVehicles <= 0) then return nil end

    local dbVehicle = ensure(dbVehicles[1], {})
    local rawVehicleData = ensure(dbVehicle.vehicle, '[]');
    local vehicleData = json.decode(rawVehicleData);
    local vehiclePlate = ensure(dbVehicle.plate, 'XXXXXXX')
    local vehicleModel = ensure(dbVehicle.model, 'unknown')
    
    ---@class vehicle
    local vehicle = {
        id = ensure(dbVehicle.id, 0),
        fxid = ensure(dbVehicle.fxid, 'unknown'),
        plate = vehiclePlate,
        vehicle = ensure(vehicleData, {}),
        model = vehicleModel,
        hash = ensure(dbVehicle.hash, 0),
        status = ensure(dbVehicle.status, 0),
        distance = ensure(dbVehicle.distance, 0),
        price = ensure(dbVehicle.price, 0),
        forSale = ensure(dbVehicle.forSale, false),
        saleLocation = ensure(dbVehicle.saleLocation, 'unknown'),
        logger = logs:create('vehicle', vehicleModel, vehiclePlate)
    }

    function vehicle:getOwner()
        return players:loadByFx(self.fxid)
    end

    function vehicle:sell(price, location)
        self.price = round(ensure(price, 99999999))
        self.saleLocation = ensure(location, 'unknown')
        self.forSale = true

        self:log({
            action = 'vehicle.sell.add',
            color = constants.colors.red,
            message = T('vehicle_sell_message', self.plate, self.price),
            title = T('vehicle_sell_title', self.plate),
            footer = ('%s | %s | %s\n{time}'):format(self.plate, self.model, self.fxid),
            arguments = { price = price, location = location, fxid = self.fxid }
        })

        self:save()
    end

    function vehicle:unsell()
        self.price = 0
        self.saleLocation = 'unknown'
        self.forSale = false

        self:log({
            action = 'vehicle.sell.remove',
            color = constants.colors.orange,
            message = T('vehicle_unsell_message', self.plate),
            title = T('vehicle_unsell_title', self.plate),
            footer = ('%s | %s | %s\n{time}'):format(self.plate, self.model, self.fxid),
            arguments = { fxid = self.fxid }
        })

        self:save()
    end

    function vehicle:transfer(newOwnerFxId)
        newOwnerFxId = ensure(newOwnerFxId, 'system')

        local currentOwner = players:loadByFx(self.fxid)
        local newOwner = players:loadByFx(newOwnerFxId)

        if (currentOwner == nil or newOwner == nil) then return end
        if (currentOwner.fxid == newOwner.fxid) then return end

        self:log({
            action = 'vehicle.transfer',
            color = constants.colors.blue,
            message = T('vehicle_transfer_message', self.plate, currentOwner.name, newOwner.name),
            title = T('vehicle_transfer_title', self.plate),
            footer = ('%s | %s\n%s\n%s\n{time}'):format(self.plate, self.model, currentOwner.fxid, newOwner.fxid),
            arguments = { prevOwner = currentOwner.fxid, newOwner = newOwner.fxid }

        })
        
        self.price = 0
        self.saleLocation = 'unknown'
        self.forSale = false
        self.fxid = newOwner.fxid
        self:save()
    end

    function vehicle:delete()
        local currentOwner = players:loadByFx(self.fxid)

        if (currentOwner == nil) then return end

        self:log({
            action = 'vehicle.delete',
            color = constants.colors.red,
            message = T('vehicle_delete_message', self.plate, currentOwner.name),
            title = T('vehicle_delete_title', self.plate),
            footer = ('%s | %s | %s\n{time}'):format(self.plate, self.model, currentOwner.fxid),
            arguments = { fxid = self.fxid }
        })
        return db:execute('DELETE FROM `vehicles` WHERE `plate` = :plate', { ['plate'] = ensure(self.plate, 'XXXXXXX') })
    end

    function vehicle:save()
        return db:execute('UPDATE `vehicles` SET `fxid` = :fxid, `vehicle` = :vehicle, `status` = :status, `distance` = :distance, `price` = :price, `forSale` = :forSale, `saleLocation` = :saleLocation WHERE `plate` = :plate', {
            ['fxid'] = ensure(self.fxid, 'unknown'),
            ['vehicle'] = encode(ensure(self.vehicle, {}), false, 0),
            ['status'] = ensure(self.status, 0),
            ['distance'] = ensure(self.distance, 0),
            ['price'] = ensure(self.price, 0),
            ['forSale'] = ensure(self.forSale, 0),
            ['saleLocation'] = ensure(self.saleLocation, 'unknown'),
            ['plate'] = ensure(self.plate, 'XXXXXXX')
        })
    end

    function vehicle:log(object)
        if (self.logger == nil) then return nil end

        return self.logger:log(object)
    end

    data[vehicle.plate] = vehicle
    ids[vehicle.id] = vehicle.plate

    return vehicle
end

function vehicles:generatePlate()
    math.randomseed(GetGameTimer())

    local result = ''
    local index = math.random(1, #plateFormats)
    local format = ensure(plateFormats[index], 'unknown')

    if (format == 'unknown') then
        print_error(('plateFormats index \'%s\' not found!'):format(index))
        return nil
    end

    for i = 1, format:len(), 1 do
        Citizen.Wait(0)

        local c = ensure(format:sub(i, i), 'X'):upper()

        if (not any(c, { 'X', '9', '-', ' ' }, 'value')) then c = 'X' end
        
        if (c == '-' or c == ' ') then
            result = ('%s%s'):format(result, c)
        elseif (c == 'X') then
            math.randomseed(GetGameTimer())

            local index = math.random(1, #constants.allowedCharacters)
            local char = ensure(constants.allowedCharacters[index], 'X')

            result = ('%s%s'):format(result, char)
        elseif (c == '9') then
            math.randomseed(GetGameTimer())

            result = ('%s%s'):format(result, math.random(0, 9))
        end

        Citizen.Wait(0)
    end

    if (self:plateExsits(result)) then
        return self:generatePlate()
    end

    return result
end

--- Checks if plate exists in database
---@param plate string Plate
---@return boolean Whether or not plate exists
function vehicles:plateExsits(plate)
    plate = ensure(plate, 'XXXXXXX')

    local dbResults = db:fetchScalar('SELECT COUNT(*) FROM `vehicles` WHERE `plate` = :plate LIMIT 1', { ['plate'] = plate })

    return ensure(dbResults, false)
end

export('vehicles', vehicles)