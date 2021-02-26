item_info = config('items')
items = {}

function items:getInfo()
    return ensure(item_info, {})
end