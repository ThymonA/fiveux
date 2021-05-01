--- Import menus
import 'menus'

--- Execute function when menu is ready/loaded
menus:onReady(function()
    --- Create a new menu object
    local exampleMenu = menus:create({
        title = 'Example Menu',
        subtitle = 'Wauw an example menu!',
        position = 'topleft',
        red = 255,
        green = 0,
        blue = 0
    })

    --- Add menu items to menu
    exampleMenu:addItem({ type = 'button', label = 'First option', description = 'You can select this option', params = { 'option_01' } })
    exampleMenu:addItem({ type = 'button', label = 'Second option', description = 'You can select this option', disabled = true, params = { 'option_02' } })
    exampleMenu:addItem({ type = 'button', label = 'Third option', description = 'You can select this option', params = { 'option_03' } })
    exampleMenu:addItem({ type = 'range', min = 0, max = 10, value = 5, label = 'Range option', description = 'You can do some range shit!', params = { 'range_01' } })
    exampleMenu:addItem({ type = 'range', min = 0, max = 0, value = 0, label = 'Range option', disabled = true, description = 'You can do some range shit!', params = { 'range_02' } })
    
    --- Register a menu events
    exampleMenu:setEvent('change', function(...) print('exampleMenu:change') end)
    exampleMenu:setEvent('select', function(value, menu, name) print('exampleMenu:select > ' .. name) end)
    exampleMenu:setEvent('cancel', function(...) print('exampleMenu:cancel') end)
    exampleMenu:setEvent('open', function(...) print('exampleMenu:open') end)
    exampleMenu:setEvent('close', function(...) print('exampleMenu:close') end)
    
    --- Open nenu
    exampleMenu:open()
end)