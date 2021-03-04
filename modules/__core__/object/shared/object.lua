local parsers ={}

object = {}

function object:register(name, func)
    name = ensure(name, 'unknown')
    func = ensure(func, function() return {} end)

    parsers[name] = func
end

function object:convert(name, ...)
    name = ensure(name, 'unknown')

    if (parsers[name]) then
        return parsers[name](...)
    end

    return nil
end

register('object', object)