-- 𝗙𝗶𝘃𝗲𝗠 𝗠𝘆𝗦𝗤𝗟 - 𝗠𝘆𝗦𝗤𝗟 𝗹𝗶𝗯𝗿𝗮𝗿𝘆 𝗳𝗼𝗿 𝗙𝗶𝘃𝗲𝗠
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ➤ License:      https://choosealicense.com/licenses/gpl-3.0/
-- ➤ GitHub:       https://github.com/ThymonA/fivem-mysql/
-- ➤ Author:       Thymon Arens <ThymonA>
-- ➤ Name:         FiveM MySQL
-- ➤ Version:      1.0.1
-- ➤ Description:  MySQL library made for FiveM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 𝗚𝗡𝗨 𝗚𝗲𝗻𝗲𝗿𝗮𝗹 𝗣𝘂𝗯𝗹𝗶𝗰 𝗟𝗶𝗰𝗲𝗻𝘀𝗲 𝘃𝟯.𝟬
-- ┳
-- ┃ Copyright (C) 2020 Thymon Arens <ThymonA>
-- ┃
-- ┃ This program is free software: you can redistribute it and/or modify
-- ┃ it under the terms of the GNU General Public License as published by
-- ┃ the Free Software Foundation, either version 3 of the License, or
-- ┃ (at your option) any later version.
-- ┃
-- ┃ This program is distributed in the hope that it will be useful,
-- ┃ but WITHOUT ANY WARRANTY; without even the implied warranty of
-- ┃ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- ┃ GNU General Public License for more details.
-- ┃
-- ┃ You should have received a copy of the GNU General Public License
-- ┃ al

local next = next
local setmetatable = setmetatable
local GetResourceState = GetResourceState
local Wait = Citizen.Wait

db = setmetatable({
    resource_name = 'fivem-mysql'
}, {})

function db:safeParams(params)
    params = ensure(params, {})

    if (next(params) == nil) then params = {} end

    return params
end

function db:execute(query, params)
    params = params or {}

    local res, finished = nil, false

    self:executeAsync(query, params, function(result)
        res = result
        finished = true
    end)

    repeat Wait(0) until finished == true

    return res
end

function db:insert(query, params)
    params = params or {}

    local res, finished = nil, false

    self:insertAsync(query, params, function(result)
        res = result
        finished = true
    end)

    repeat Wait(0) until finished == true

    return res
end

function db:fetchAll(query, params)
    params = params or {}

    local res, finished = nil, false

    self:fetchAllAsync(query, params, function(result)
        res = result
        finished = true
    end)

    repeat Wait(0) until finished == true

    return res
end

function db:fetchScalar(query, params)
    params = params or {}

    local res, finished = nil, false

    self:fetchScalarAsync(query, params, function(result)
        res = result
        finished = true
    end)

    repeat Wait(0) until finished == true

    return res
end

function db:fetchFirst(query, params)
    params = params or {}

    local res, finished = nil, false

    self:fetchFirstAsync(query, params, function(result)
        res = result
        finished = true
    end)

    repeat Wait(0) until finished == true

    return res
end

function db:executeAsync(query, params, callback)
    query = ensure(query, 'unknown')
    params = ensure(params, {})
    callback = ensure(callback, function(...) end)

    if (query == 'unknown') then
        callback({})
        return
    end

    params = self:safeParams(params)

    exports[self.resource_name]:executeAsync(query, params, callback, NAME)
end

function db:insertAsync(query, params, callback)
    query = ensure(query, 'unknown')
    params = ensure(params, {})
    callback = ensure(callback, function(...) end)

    if (query == 'unknown') then
        callback({})
        return
    end

    params = self:safeParams(params)

    exports[self.resource_name]:insertAsync(query, params, callback, NAME)
end

function db:fetchAllAsync(query, params, callback)
    query = ensure(query, 'unknown')
    params = ensure(params, {})
    callback = ensure(callback, function(...) end)

    if (query == 'unknown') then
        callback({})
        return
    end

    params = self:safeParams(params)

    exports[self.resource_name]:fetchAllAsync(query, params, callback, NAME)
end

function db:fetchScalarAsync(query, params, callback)
    query = ensure(query, 'unknown')
    params = ensure(params, {})
    callback = ensure(callback, function(...) end)

    if (query == 'unknown') then
        callback({})
        return
    end

    params = self:safeParams(params)

    exports[self.resource_name]:fetchScalarAsync(query, params, callback, NAME)
end

function db:fetchFirstAsync(query, params, callback)
    query = ensure(query, 'unknown')
    params = ensure(params, {})
    callback = ensure(callback, function(...) end)

    if (query == 'unknown') then
        callback({})
        return
    end

    params = self:safeParams(params)

    exports[self.resource_name]:fetchFirstAsync(query, params, callback, NAME)
end

local resourceState = GetResourceState(db.resource_name)

if (any(resourceState, { 'missing', 'stopped', 'stopping', 'unknown' }, 'value')) then
    error(('Resource "~x~%s~s~" required to run module "~x~%s~s~"'):format(db.resource_name, NAME))
    return
end

while GetResourceState(db.resource_name) ~= 'started' do Wait(0) end
while not exports[db.resource_name]:isReady() do Wait(0) end

export('db', db)