--- Local storage
---@type table<number, menu>
local data = {}
local __id = 0
local __ready = false
local __positions = { 'topleft', 'topcenter', 'topright', 'centerleft', 'center', 'centeright', 'bottomleft', 'bottomcenter', 'bottomright' }
local __itemTypes = { 'button', 'range', 'checkbox' }
local __currentMenu = nil
local __prevMenus = {}

---@class menus
menus = {}

--- Create a new menu object
---@param options table Menu options
---@return menu Generated menu
function menus:create(options)
    __id = __id + 1
    options = ensure(options, {})

    ---@class menu
    local menu = {
        id = __id,
        title = ensure(options.title, ''),
        subtitle = ensure(options.subtitle, ''),
        position = ensure(options.position, 'topleft'),
        red = ensure(options.red, 0),
        green = ensure(options.green, 0),
        blue = ensure(options.blue, 0),
        bannerUrl = ensure(options.bannerUrl, src('images/default.png')),
        items = ensure(options.items, {}),
        __visible = false,
        __onChange = ensure(options.onChange, function(...) end),
        __onSelect = ensure(options.onSelect, function(...) end),
        __onCancel = ensure(options.onCancel, function(...) end),
        __onOpen = ensure(options.onOpen, function(...) end),
        __onClose = ensure(options.onClose, function(...) end)
    }

    if (not any(menu.position, __positions, 'value')) then menu.position = 'topleft' end

    function menu:setTitle(title, reload)
        reload = ensure(reload, true)

        self.title = ensure(title, '')

        if (reload) then self:reload() end
    end

    function menu:setSubtitle(subtitle, reload)
        reload = ensure(reload, true)

        self.subtitle = ensure(subtitle, '')

        if (reload) then self:reload() end
    end

    function menu:setPosition(position, reload)
        reload = ensure(reload, true)

        self.position = ensure(position, '')

        if (reload) then self:reload() end
    end

    function menu:setColor(red, green, blue, reload)
        reload = ensure(reload, true)

        self.red = ensure(red, 0)
        self.green = ensure(green, 0)
        self.blue = ensure(blue, 0)

        if (reload) then self:reload() end
    end

    function menu:setBannerUrl(bannerUrl, reload)
        reload = ensure(reload, true)

        self.bannerUrl = ensure(bannerUrl, src('images/default.png'))

        if (reload) then self:reload() end
    end

    function menu:clearAllItems(reload)
        reload = ensure(reload, true)

        self.items = {}

        if (reload) then self:reload() end
    end

    function menu:addItem(item, reload)
        reload = ensure(reload, true)
        item = ensure(item, {})

        self.items = ensure(self.items, {})

        local itemType = ensure(item.type, 'button')

        if (not any(itemType, __itemTypes, 'value')) then itemType = 'button' end

        local value

        if (itemType == 'range') then
            value = ensure(item.value, ensure(item.min, 0))
        elseif (itemType == 'checkbox') then
            value = ensure(item.value, false)
        else
            value = item.value
        end

        table.insert(self.items, {
            index = #self.items,
            type = itemType,
            label = ensure(item.label, ''),
            value = value,
            disabled = ensure(item.disabled, false),
            description = ensure(item.description, ''),
            min = ensure(item.min, 0),
            max = ensure(item.max, 0),
            params = ensure(item.params, {})
        })

        if (reload) then self:reload() end
    end

    function menu:addItems(items, reload)
        reload = ensure(reload, true)
        items = ensure(items, {})

        self.items = ensure(self.items, {})

        for _, item in pairs(items) do
            self:addItem(item, false)
        end

        if (reload) then self:reload() end
    end

    function menu:isOpen()
        return ensure(self.__visible, false)
    end

    function menu:open(onChange, onSelect, onCancel)
        self:setEvent('change', onChange)
        self:setEvent('select', onSelect)
        self:setEvent('cancel', onCancel)
        self:reload(false)
        
        SendNUIMessage({
            action = 'OPEN',
            id = self.id,
            title = self.title,
            subtitle = self.subtitle,
            position = self.position,
            red = self.red,
            green = self.green,
            blue = self.blue,
            bannerUrl = self.bannerUrl,
            items = self.items,
            reloaded = false
        })
    end

    function menu:close()
        SendNUIMessage({
            action = 'CLOSE',
            id = self.id
        })
    end

    function menu:clearEvent(name)
        name = ensure(name, 'unknown')

        local key = ('__on%s'):format(name:gsub('^%l', string.upper))

        if (self[key] ~= nil) then
            self[key] = function(...) end
        end
    end

    function menu:setEvent(name, func)
        name = ensure(name, 'unknown')
        
        local key = ('__on%s'):format(name:gsub('^%l', string.upper))

        if (self[key] ~= nil) then
            self[key] = ensure(self[key], function(...) end)
            self[key] = ensure(func, self[key])
        end
    end

    function menu:reload(update)
        update = ensure(update, true)

        self.id = ensure(self.id, 0)
        self.title = ensure(self.title, '')
        self.subtitle = ensure(self.subtitle, '')
        self.position = ensure(self.position, 'topleft')
        self.red = ensure(self.red, 0)
        self.green = ensure(self.green, 0)
        self.blue = ensure(self.blue, 0)
        self.bannerUrl = ensure(self.bannerUrl, src('images/default.png'))
        self.items = ensure(self.items, {})
        self.__visible = ensure(self.__visible, false)
        self.__onChange = ensure(self.__onChange, function(...) end)
        self.__onSelect = ensure(self.__onSelect, function(...) end)
        self.__onCancel = ensure(self.__onCancel, function(...) end)
        self.__onOpen = ensure(self.__onOpen, function(...) end)
        self.__onClose = ensure(self.__onClose, function(...) end)

        for index, item in pairs(self.items) do
            index = ensure(index, 0)
            item = ensure(item, {})

            local itemType = ensure(item.type, 'button')

            if (not any(itemType, __itemTypes, 'value')) then itemType = 'button' end

            local value

            if (itemType == 'range') then
                value = ensure(item.value, ensure(item.min, 0))
            elseif (itemType == 'checkbox') then
                value = ensure(item.value, false)
            else
                value = item.value
            end

            self.items[index] = {
                index = index,
                type = itemType,
                label = ensure(item.label, ''),
                value = value,
                disabled = ensure(item.disabled, false),
                description = ensure(item.description, ''),
                min = ensure(item.min, 0),
                max = ensure(item.max, 0),
                params = ensure(item.params, {})
            }
        end

        if (update) then
            SendNUIMessage({
                action = 'OPEN',
                id = self.id,
                title = self.title,
                subtitle = self.subtitle,
                position = self.position,
                red = self.red,
                green = self.green,
                blue = self.blue,
                bannerUrl = self.bannerUrl,
                items = self.items,
                reloaded = true
            })
        end
    end

    data[menu.id] = menu

    return data[menu.id]
end

function menus:onReady(callback)
    callback = ensure(callback, function() end)

    if (__ready) then
        callback()
        return
    end

    Citizen.CreateThread(function()
        while not __ready do Citizen.Wait(0) end
        callback()
    end)
end

RegisterNUICallback('ready', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    __ready = true

    callback('ok')
end)

RegisterNUICallback('open', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)

    if (data == nil) then data = {} end

    callback('ok')

    if (data[id] ~= nil) then
        if (__currentMenu == nil) then
            __currentMenu = data[id]
        elseif (__currentMenu.id ~= id) then
            table.insert(__prevMenus, __currentMenu.id)
            __currentMenu = data[id]
        end

        data[id].__visible = true

        for menuId, _ in pairs(data) do
            if (menuId == id) then
                if (typeof(data[id].__onOpen) == 'function') then
                    local ok = xpcall(data[id].__onOpen, print_error, data[id])
        
                    repeat Citizen.Wait(0) until ok ~= nil
                end

                data[menuId].__visible = true
            else
                if (data[menuId].__visible and typeof(data[menuId].__onClose) == 'function') then
                    local ok = xpcall(data[menuId].__onClose, print_error, data[menuId])
        
                    repeat Citizen.Wait(0) until ok ~= nil
                end

                data[menuId].__visible = false
            end
        end
    end
end)

RegisterNUICallback('close', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)

    if (data == nil) then data = {} end

    callback('ok')

    if (__currentMenu == nil) then return end

    if (__currentMenu.id == id) then
        __currentMenu = nil

        for menuId, _ in pairs(data) do
            if (data[menuId].__visible and typeof(data[menuId].__onClose) == 'function') then
                local ok = xpcall(data[menuId].__onClose, print_error, data[menuId])
    
                repeat Citizen.Wait(0) until ok ~= nil
            end

            data[menuId].__visible = false
        end
    end

    __prevMenus = ensure(__prevMenus, {})

    if (__currentMenu ~= nil and __currentMenu.id == id) then
        __currentMenu = nil
    end

    if (#__prevMenus > 0) then
        while #__prevMenus > 0 do
            local lastMenu = ensure(__prevMenus[#__prevMenus], 0)

            if (lastMenu > 0) then
                table.remove(__prevMenus, #__prevMenus)

                if (data[lastMenu] ~= nil) then
                    data[lastMenu]:open()
                    return
                end
            end
        end
    end
end)

RegisterNUICallback('change', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)
    local index = ensure(info.index, 0)
    local value

    if (data == nil) then data = {} end

    callback('ok')

    if (data[id] ~= nil) then
        data[id].items = ensure(data[id].items, {})

        if (typeof(data[id].__onChange) == 'function') then
            local item = data[id].items[index]

            if (item == nil or item.disabled) then return end

            if (item == 'range') then
                value = ensure(info.value, ensure(item.min, 0))
            elseif (item == 'checkbox') then
                value = ensure(info.value, false)
            else
                value = info.value
            end

            local params = ensure(item.params, {})

            local ok = xpcall(data[id].__onChange, print_error, value, item.value, data[id], table.unpack(params))

            repeat Citizen.Wait(0) until ok ~= nil
        end
    end
end)

RegisterNUICallback('submit', function(info, callback)
    info = ensure(info, {})
    callback = ensure(callback, function() end)

    local id = ensure(info.id, 0)
    local index = ensure(info.index, 0)
    local value

    if (data == nil) then data = {} end

    callback('ok')

    if (data[id] ~= nil) then
        data[id].items = ensure(data[id].items, {})

        if (typeof(data[id].__onSelect) == 'function') then
            local item = data[id].items[index]

            if (item == nil or item.disabled) then return end

            if (item == 'range') then
                value = ensure(info.value, ensure(item.min, 0))
            elseif (item == 'checkbox') then
                value = ensure(info.value, false)
            else
                value = info.value
            end

            item.value = value

            local params = ensure(item.params, {})

            local ok = xpcall(data[id].__onSelect, print_error, item.value, data[id], table.unpack(params))

            repeat Citizen.Wait(0) until ok ~= nil
        end
    end
end)

--- Register controls
addControl('menu_arrow_up', T('menu_arrow_up'), 'KEYBOARD', 'UP')
addControl('menu_arrow_down', T('menu_arrow_down'), 'KEYBOARD', 'DOWN')
addControl('menu_arrow_left', T('menu_arrow_left'), 'KEYBOARD', 'LEFT')
addControl('menu_arrow_right', T('menu_arrow_right'), 'KEYBOARD', 'RIGHT')
addControl('menu_keyboard_enter', T('menu_keyboard_enter'), 'KEYBOARD', 'RETURN')
addControl('menu_keyboard_close', T('menu_keyboard_close'), 'KEYBOARD', 'BACK')

--- Handles keyboard actions
Citizen.CreateThread(function()
    while true do
        if (isControlJustPressed('menu_arrow_up') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'UP' })
            Citizen.Wait(50)
        elseif (isControlJustPressed('menu_arrow_down') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'DOWN' })
            Citizen.Wait(50)
        elseif (isControlJustPressed('menu_arrow_left') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'LEFT' })
            Citizen.Wait(50)
        elseif (isControlJustPressed('menu_arrow_right') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'RIGHT' })
            Citizen.Wait(50)
        elseif (isControlJustPressed('menu_keyboard_enter') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'ENTER' })
            Citizen.Wait(50)
        elseif (isControlJustPressed('menu_keyboard_close') and __currentMenu ~= nil) then
            SendNUIMessage({ action = 'KEY_PRESSED', key = 'CLOSE' })
            Citizen.Wait(50)
        else
            Citizen.Wait(0)
        end
    end
end)