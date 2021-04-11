--- Globals
local math_pi = math.pi
local math_abs = math.abs
local math_cos = math.cos
local math_sin = math.sin
local default_vector2 = vec(0, 0)
local default_vector3 = vec(0, 0, 0)
local cfg = config('general')
local raycastLength = ensure(cfg.raycastLength, 50.0)

--- @class raycast
raycast = {}

--- Rotate rotation to direction
---@param rotation vector3|table rotation
---@return vector3|table Result
function raycast:rotateToDirection(rotation)
    rotation = ensure(rotation, default_vector3)

    local x = rotation.x * math_pi / 180.0
    local z = rotation.z * math_pi / 180.0
    local num = math_abs(math_cos(x))

    return vec(
        -math_sin(z) * num,
        math_cos(z) * num,
        math_sin(x)
    )
end

--- Transform 3D position to 2D screen coords
---@param position vector3|table World position
---@return boolean Whether `position` is visible on screen
---@return vector2|table Screen position coords
function raycast:world3dToScreen2D(position)
    position = ensure(position, default_vector3)

    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)

    return ensure(onScreen, false), vec(ensure(screenX, 0), ensure(screenY, 0))
end

--- Calculates the position where mouse is pointing at
---@param camPosition vector3|table Position of camera
---@param camRotation vector3|table Rotation of camera
---@param mousePosition vector2|table Position of mouse
function raycast:screenToWorld(camPosition, camRotation, mousePosition)
    camPosition = ensure(camPosition, default_vector3)
    camRotation = ensure(camRotation, default_vector3)
    mousePosition = ensure(mousePosition, default_vector2)

    local cameraForward = self:rotateToDirection(camRotation)
    local rotationUp = vec(camRotation.x + 1.0, camRotation.y, camRotation.z)
    local rotationDown = vec(camRotation.x - 1.0, camRotation.y, camRotation.z)
    local rotationLeft = vec(camRotation.x, camRotation.y, camRotation.z - 1.0)
    local rotationRight = vec(camRotation.x, camRotation.y, camRotation.z + 1.0)
    local cameraRight = self:rotateToDirection(rotationRight) - self:rotateToDirection(rotationLeft)
    local cameraUp = self:rotateToDirection(rotationUp) - self:rotateToDirection(rotationDown)
    local roll = -(camRotation.y * math_pi / 180.0)
    local cameraRightRoll = cameraRight * math_cos(roll) - cameraUp * math_sin(roll)
    local cameraUpRoll = cameraRight * math_sin(roll) + cameraUp * math_cos(roll)
    local point3dZero = camPosition + cameraForward * 1.0
    local point3d = point3dZero + cameraRightRoll + cameraUpRoll
    local _, point2dZero = self:world3dToScreen2D(point3dZero)
    local _, point2d = self:world3dToScreen2D(point3d)
    local scaleX = (mousePosition.x - point2dZero.x) / (point2d.x - point2dZero.x)
    local scaleY = (mousePosition.y - point2dZero.y) / (point2d.y - point2dZero.y)
    local _point3d = point3dZero + cameraRightRoll * scaleX + cameraUpRoll * scaleY
    local _forwardDirection = cameraForward + cameraRightRoll * scaleX + cameraUpRoll * scaleY

    return _point3d, _forwardDirection
end

--- Transforms player screen mouse position to 3D world entities
---@return boolean Any entity hit
---@return vector3 Coords of entity
---@return boolean Has normal surface
---@return number Entity ID
---@return number Entity type
---@return vector3 Camera direction
function raycast:screen2dToWorld3D()
    local camRotation = ensure(GetGameplayCamRot(0), default_vector3)
    local camPosition = ensure(GetGameplayCamCoord(), default_vector3)
    local mousePosition = vec(ensure(GetControlNormal(0, 239), 0), ensure(GetControlNormal(0, 240), 0))
    local camera3dPosition, forwardDirection = self:screenToWorld(camPosition, camRotation, mousePosition)
    local cameraDirection = camPosition + forwardDirection * raycastLength
    local raycastHandle = StartShapeTestRay(camera3dPosition, cameraDirection, 30, 0, 0)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(raycastHandle)
    
    entityHit = ensure(entityHit, 0)

    if (entityHit > 0) then
        return true, endCoords, surfaceNormal, entityHit, GetEntityType(entityHit), cameraDirection
    end

    return false, nil, nil, nil, nil, nil
end

--- Register controls
addControl('raycast_select', T('raycast_select'), 'MOUSE_BUTTON', 'MOUSE_RIGHT')
addControl('raycast_click', T('raycast_click'), 'MOUSE_BUTTON', 'MOUSE_LEFT')

--- Handles mouse actions
Citizen.CreateThread(function()
    local mouseVisible = false
    local prevMouseVisible = false

    while true do
        if (isControlPressed('raycast_select') and not mouseVisible) then
            mouseVisible = true
        end

        if (mouseVisible ~= prevMouseVisible) then
            prevMouseVisible = mouseVisible

            DisableControlAction(0, 1, prevMouseVisible)
            DisableControlAction(0, 2, prevMouseVisible)
            DisableControlAction(0, 142, prevMouseVisible)
            DisableControlAction(0, 106, prevMouseVisible)
        end

        if (mouseVisible) then
            SetMouseCursorActiveThisFrame()

            DisableControlAction(0, 1, prevMouseVisible)
            DisableControlAction(0, 2, prevMouseVisible)
            DisableControlAction(0, 142, prevMouseVisible)
            DisableControlAction(0, 106, prevMouseVisible)
        end

        if (mouseVisible and isControlPressed('raycast_click')) then
            mouseVisible = false

            local found, coords, normal, entity, type, direction = raycast:screen2dToWorld3D()

            if (found) then
                Citizen.CreateThread(function()
                    local entityHash = GetEntityModel(entity)
                    local entityType = ensure(type, 0)

                    emit('raycast:entity', entityHash, entity, coords, entityType)

                    if (entityType == 4 or (entityType == 1 and PlayerPedId() == entity)) then
                        emit('raycast:self', entityHash, entity, coords)
                    elseif (entityType == 1) then
                        emit('raycast:ped', entityHash, entity, coords)
                    elseif (entityType == 2) then
                        emit('raycast:vehicle', entityHash, entity, coords)
                    elseif (entityType == 3) then
                        emit('raycast:object', entityHash, entity, coords)
                    elseif (entityType == 5) then
                        emit('raycast:player', entityHash, entity, coords)
                    end
                end)
            end
        end

        Citizen.Wait(0)
    end
end)

--- Exports raycast module
export('raycast', raycast)

on('raycast:self', function(entity, coords)
    print('YOU PRESSED ON YOURSELF!!!')
end)