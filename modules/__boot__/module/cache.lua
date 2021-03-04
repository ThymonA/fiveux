local data = {
    protected = {},
    public = {}
}

cache = {}

function cache:read(key)
    key = ensure(key, 'unknown'):lower()

    if (key == 'unknown') then return nil end
    if (data == nil) then data = { protected = {}, public = {} } end
    if (data.protected[key] ~= nil) then return data.protected[key] end
    if (data.public[key] ~= nil) then return data.public[key] end

    return nil
end

function cache:write(key, value, protected)
    key = ensure(key, 'unknown'):lower()
    protected = ensure(protected, false)

    if (key == 'unknown') then return nil end
    if (data == nil) then data = { protected = {}, public = {} } end
    if (data.protected[key] ~= nil) then return end

    if (protected) then
        data.protected[key] = value
    else
        data.public[key] = value
    end
end

function cache:exists(key)
    key = ensure(key, 'unknown'):lower()

    if (key == 'unknown') then return false end
    if (data.protected[key] ~= nil) then return true end
    if (data.public[key] ~= nil) then return true end

    return false
end

function cache:setProp(key, name, value)
    key = ensure(key, 'unknown'):lower()
    name = ensure(name, 'unknown')

    if (key == 'unknown') then return nil end
    if (data == nil) then data = { protected = {}, public = {} } end
    if (data.protected[key] ~= nil) then return end
    if (data.public[key] ~= nil) then
        data.public[key][name] = value
    end
end

function cache:delete(key)
    key = ensure(key, 'unknown'):lower()

    if (key == 'unknown') then return end
    if (data.protected[key] ~= nil) then return end

    if (data.public[key] ~= nil) then
        data.public[key] = nil
    end
end