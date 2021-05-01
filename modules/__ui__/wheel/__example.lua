--- Import wheels
import 'wheels'

--- Create a new wheel object
local wheel = wheels:create()

--- Add wheel items to wheel
wheel:addItem('lights_on', 'las', 'la-lightbulb')

--- Register a `select` wheel event
wheel:on('select', function(value, entity)
    if (value == 'lights_on') then
        local _, lightsOn = GetVehicleLightsState(entity)

        SetVehicleLights(entity, lightsOn == 1 and 1 or 3)
    end
end)

--- When `raycast:vehicle` trigger's, open wheel
on('raycast:vehicle', function(entity, coords)
    --- Reset additional parameters
    wheel:resetParams()
    --- Add entity as additional parameter
    wheel:addParam(entity)
    --- Open wheel on NUI Cursor Position
    wheel:show(GetNuiCursorPosition())
end)