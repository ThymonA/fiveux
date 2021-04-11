typeof = function(input)
    if (input == nil) then return 'nil' end

    local t = type(input)

    if (t ~= 'table') then return t end

    if (rawget(input, '__cfx_functionReference') ~= nil or
        rawget(input, '__cfx_async_retval') ~= nil) then
        return 'function'
    end

    if (rawget(input, '__cfx_functionSource') ~= nil) then
        return 'number'
    end

    local __class = rawget(input, '__class')

    if (__class ~= nil) then
        return type(__class) == 'string' and __class or 'class'
    end

    local __type = rawget(input, '__type')

    if (__type ~= nil) then
        return type(__type) == 'string' and __type or '__type'
    end

    return t
end

ensure = function(input, default, ignoreDefault)
    if (ignoreDefault == nil) then
        ignoreDefault = false
    else
        ignoreDefault = ensure(ignoreDefault, false)
    end

    if (default == nil) then return nil end
    if (input == nil) then return (not ignoreDefault and default or nil) end

    local input_type = typeof(input)
    local output_type = typeof(default)

    if (input_type == output_type) then return input end

    if (output_type == 'number') then
        if (input_type == 'string') then return tonumber(input) or (not ignoreDefault and default or nil) end
        if (input_type == 'boolean') then return input and 1 or 0 end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'string') then
        if (input_type == 'number') then return tostring(input) or (not ignoreDefault and default or nil) end
        if (input_type == 'boolean') then return input and 'yes' or 'no' end
        if (input_type == 'table') then return encode(input) or (not ignoreDefault and default or nil) end
        if (input_type == 'vector4') then return encode({ input.x, input.y, input.z, input.w }) or (not ignoreDefault and default or nil) end
        if (input_type == 'vector3') then return encode({ input.x, input.y, input.z }) or (not ignoreDefault and default or nil) end
        if (input_type == 'vector2') then return encode({ input.x, input.y }) or (not ignoreDefault and default or nil) end

        return tostring(input) or (not ignoreDefault and default or nil)
    end

    if (output_type == 'boolean') then
        if (input_type == 'string') then
            input = string.lower(input)

            if (input == 'true' or input == '1' or input == 'yes' or input == 'y') then return true end
            if (input == 'false' or input == '0' or input == 'no' or input == 'n') then return false end

            return (not ignoreDefault and default or nil)
        end

        if (input_type == 'number') then
            if (input == 1) then return true end
            if (input == 0) then return false end

            return (not ignoreDefault and default or nil)
        end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'vector2') then
        if (input_type == 'table') then
            if (#input >= 1) then
                local x = ensure(input[1], default.x)
                local y = ensure(input[2], default.y)

                return vector2(x, y)
            end

            if (input.x ~= nil and input.y ~= nil) then
                local x = ensure(input.x, default.x)
                local y = ensure(input.y, default.y)

                return vector2(x, y)
            end

            return (not ignoreDefault and default or nil)
        end

        if (input_type == 'vector3' or input_type == 'vector4') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)

            return vector2(x, y)
        end

        if (input_type == 'number') then
            return vector2(input, input)
        end

        if (input_type == 'string' and input:startsWith('{') and input:endsWith('}')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        if (input_type == 'string' and input:startsWith('[') and input:endsWith(']')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'vector3') then
        if (input_type == 'table') then
            if (#input >= 2) then
                local x = ensure(input[1], default.x)
                local y = ensure(input[2], default.y)
                local z = ensure(input[3], default.z)

                return vector3(x, y, z)
            end

            if (input.x ~= nil and input.y ~= nil) then
                local x = ensure(input.x, default.x)
                local y = ensure(input.y, default.y)
                local z = ensure(input.z, default.z)

                return vector3(x, y, z)
            end

            return (not ignoreDefault and default or nil)
        end

        if (input_type == 'vector2') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)
            local z = ensure(input.z, 0)

            return vector3(x, y, z)
        end

        if (input_type == 'vector4') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)
            local z = ensure(input.z, default.z)

            return vector3(x, y, z)
        end

        if (input_type == 'number') then
            return vector3(input, input, input)
        end

        if (input_type == 'string' and input:startsWith('{') and input:endsWith('}')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        if (input_type == 'string' and input:startsWith('[') and input:endsWith(']')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'vector4') then
        if (input_type == 'table') then
            if (#input >= 2) then
                local x = ensure(input[1], default.x)
                local y = ensure(input[2], default.y)
                local z = ensure(input[3], default.z)
                local w = ensure(input[4], default.w)

                return vector4(x, y, z, w)
            end

            if (input.x ~= nil and input.y ~= nil) then
                local x = ensure(input.x, default.x)
                local y = ensure(input.y, default.y)
                local z = ensure(input.z, default.z)
                local w = ensure(input.w, default.w)

                return vector4(x, y, z, w)
            end

            return (not ignoreDefault and default or nil)
        end

        if (input_type == 'vector2') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)
            local z = ensure(input.z, 0)
            local w = ensure(input.w, 0)

            return vector4(x, y, z, w)
        end

        if (input_type == 'vector3') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)
            local z = ensure(input.z, default.z)
            local w = ensure(input.w, 0)

            return vector4(x, y, z, w)
        end

        if (input_type == 'number') then
            return vector4(input, input, input, input)
        end

        if (input_type == 'string' and input:startsWith('{') and input:endsWith('}')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        if (input_type == 'string' and input:startsWith('[') and input:endsWith(']')) then
            local decodedInput = ensure(json.decode(input), {})

            return ensure(decodedInput, default, ignoreDefault)
        end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'table') then
		if (input_type == 'string') then
			if ((input:startsWith('{') and input:endsWith('}')) or (input:startsWith('[') and input:endsWith(']'))) then
				return json.decode(input) or (not ignoreDefault and default or nil)
			end

			return { input } or (not ignoreDefault and default or nil)
		end

		if (input_type == 'vector2') then
			return { ensure(input.x, 0), ensure(input.y, 0) } or (not ignoreDefault and default or nil)
		end

		if (input_type == 'vector3') then
			return { ensure(input.x, 0), ensure(input.y, 0), ensure(input.z, 0) } or (not ignoreDefault and default or nil)
		end

		if (input_type == 'vector4') then
			return { ensure(input.x, 0), ensure(input.y, 0), ensure(input.z, 0), ensure(input.w, 0) } or (not ignoreDefault and default or nil)
		end

		if (input_type == 'boolean' or input_type == 'number') then
			return { input } or (not ignoreDefault and default or nil)
		end
	end

    return (not ignoreDefault and default or nil)
end

any = function(input, inputs, checkType)
    if (input == nil or inputs == nil) then return false end

    inputs = ensure(inputs, {})
    checkType = ensure(checkType, 'value')

    local checkMethod = 1

    if (checkType == 'value' or checkType == 'v') then checkMethod = 1 end
    if (checkType == 'key' or checkType == 'k') then checkMethod = -1 end
    if (checkType == 'both' or checkType == 'b') then checkMethod = 0 end

    for k, v in pairs(inputs) do
        if (checkMethod <= 0) then
            local checkK = ensure(input, k, true)

            if (checkK ~= nil and checkK == k) then return true end
        end

        if (checkMethod >= 0) then
            local checkV = ensure(input, v, true)

            if (checkV ~= nil and checkV == v) then return true end
        end
    end

    return false
end

try = function(func, catch_func)
    func = ensure(func, function() end)
    catch_func = ensure(catch_func, function() end)

    local status, exception = pcall(func)

    if (not status) then
        catch_func(exception)
    end
end

encode = function(input, ignoreJson)
    local innerTable = ''
    local hasKey = false

    input = ensure(input, {})
    ignoreJson = ensure(ignoreJson, false)

    for k, v in pairs(input) do
        local keyType = typeof(k) or 'nil'
        local valueType = typeof(v) or 'nil'
        local finalValue = ''

        if (valueType ~= 'function') then
            local hasIndex = keyType == 'number'

            if (not hasIndex) then
                hasKey = true
                k = ensure(k, 'unknown')
            end

            if (valueType == 'table') then
				finalValue = hasIndex and encode(v) or ('"%s": %s'):format(k, encode(v))
			elseif (valueType == 'number') then
				finalValue = hasIndex and ('%.2f'):format(v) or ('"%s": %.2f'):format(k, v)
			elseif (valueType == 'string') then
                if (not ignoreJson) then
                    v = v:gsub("\"", "\\\"")
                end

				finalValue = hasIndex and ('%s'):format('"' .. v .. '"') or ('"%s": %s'):format(k, '"' .. v .. '"')
			elseif (valueType == 'boolean') then
				finalValue = hasIndex and ('%s'):format(v and 'true' or 'false') or ('"%s": %s'):format(k, v and 'true' or 'false')
			elseif (valueType == 'vector2') then
				finalValue = hasIndex and ('[%.2f,%.2f]'):format(v.x, v.y) or ('"%s": [%.2f,%.2f]'):format(k, v.x, v.y)
			elseif (valueType == 'vector3') then
				finalValue = hasIndex and ('[%.2f,%.2f,%.2f]'):format(v.x, v.y, v.z) or ('"%s": [%.2f,%.2f,%.2f]'):format(k, v.x, v.y, v.z)
			elseif (valueType == 'vector4') then
				finalValue = hasIndex and ('[%.2f,%.2f,%.2f,%.2f]'):format(v.x, v.y, v.z, v.w) or ('"%s": [%.2f,%.2f,%.2f,%.2f]'):format(k, v.x, v.y, v.z, v.w)
            elseif (valueType == 'nil' or valueType == 'null') then
                finalValue = hasIndex and "nil" or ('"%s": %s'):format(k, "nil")
            end
        end

        if (innerTable == nil or string.len(innerTable) == 0) then
			innerTable = finalValue
		else
			innerTable = ('%s,%s'):format(innerTable, finalValue)
		end
    end

    if (ignoreJson) then
        if (innerTable:startsWith('"') and innerTable:endsWith('"')) then
            innerTable = innerTable:sub(2, (#innerTable - 1))
        end

        return innerTable
    end

    local final = hasKey and ('{%s}'):format(innerTable) or ('[%s]'):format(innerTable)

    final = final:gsub('\n', '\\n')
    final = final:gsub('\t', '\\t')

    return final
end

print_error = function(msg, module)
    module = ensure(module, 'global')
	msg = ensure(msg, 'UNKNOWN ERROR')

	local message = ('🟥^7[^1ERROR^7][^1%s^7/^1%s^7] ^7%s^7'):format(ENVIRONMENT, module, msg)

    message = ('%s^7'):format(message)
    message = message:gsub('%~x~', '^1')
    message = message:gsub('%~s~', '^7')

	print(message)
end

print_success = function(msg, module)
    module = ensure(module, 'global')
	msg = ensure(msg, 'UNKNOWN ERROR')

	local message = ('🟩^7[^2SUCCESS^7][^2%s^7/^2%s^7] ^7%s^7'):format(ENVIRONMENT, module, msg)

    message = ('%s^7'):format(message)
    message = message:gsub('%~x~', '^2')
    message = message:gsub('%~s~', '^7')

	print(message)
end

print_warning = function(msg, module)
    module = ensure(module, 'global')
	msg = ensure(msg, 'UNKNOWN ERROR')

	local message = ('🟧^7[^3WARN^7][^3%s^7/^3%s^7] ^7%s^7'):format(ENVIRONMENT, module, msg)

    message = ('%s^7'):format(message)
    message = message:gsub('%~x~', '^3')
    message = message:gsub('%~s~', '^7')

	print(message)
end

print_info = function(msg, module)
    module = ensure(module, 'global')
	msg = ensure(msg, 'UNKNOWN ERROR')

	local message = ('🟦^7[^4INFO^7][^4%s^7/^4%s^7] ^7%s^7'):format(ENVIRONMENT, module, msg)

    message = ('%s^7'):format(message)
    message = message:gsub('%~x~', '^4')
    message = message:gsub('%~s~', '^7')

	print(message)
end

argumentsToString = function(...)
    local args = { ... }
    local msg = nil

    for i = 1, #args, 1 do
        local sArg = ensure(args[i], '')

        if (msg == nil) then
            msg = sArg
        else
            msg = ('%s %s'):format(msg, sArg)
        end
    end

    return msg
end

sizeof = function(input)
    input = ensure(input, {})

    local count = 0

    for _, _ in pairs(input) do
        count = count + 1
    end

    return count
end

dateTimeString = function()
    if (os == nil) then return '<<time>>' end

    local str = ''
    local date = ensure(os.date('*t'), {})
    local hour, min, sec = ensure(date.hour, 0), ensure(date.min, 0), ensure(date.sec, 0)
    local year, month, day = ensure(date.year, 0), ensure(date.month, 0), ensure(date.day, 0)

    str = ('%s'):format(year < 10 and ('0' .. year) or year)
    str = ('%s-%s'):format(str, month < 10 and ('0' .. month) or month)
    str = ('%s-%s'):format(str, day < 10 and ('0' .. day) or day)
    str = ('%s %s'):format(str, hour < 10 and ('0' .. hour) or hour)
    str = ('%s:%s'):format(str, min < 10 and ('0' .. min) or min)
    str = ('%s:%s'):format(str, sec < 10 and ('0' .. sec) or sec)

    return str
end

ensureStringList = function(t)
    t = ensure(t, {})

    local raw = {}

    for _, v in pairs(t) do
        v = ensure(v, 'unknown')

        if (v ~= 'unknown') then
            table.insert(raw, v)
        end
    end

    return raw
end

logToDiscord = function(username, title, message, footer, webhooks, color, avatar)
    username = ensure(username, 'FiveUX Framework')
    title = ensure(title, '')
    message = ensure(message, '')
    footer = ensure(footer, '')
    color = ensure(color, 9807270)
    avatar = ensure(avatar, '')

    if (typeof(webhooks) == 'table') then
        for k, v in pairs(webhooks) do
            logToDiscord(username, title, message, footer, v, color, avatar)
        end
        return
    end

    local webhook = ensure(webhooks, 'unknown')

    if (webhook == 'unknown' or not (webhook:startsWith('https://') or webhook:startsWith('http://'))) then
        return
    end

    local request = {
        ['color'] = color,
        ['type'] = 'rich'
    }

    if (title ~= '') then request['title'] = title end
    if (message ~= '') then request['description'] = message end
    if (footer ~= '') then request['footer'] = { ['text'] = footer } end

    PerformHttpRequest(webhook, function(error, text, headers) end, 'POST', encode({ username = username, embeds = { request }, avatar_url = avatar }), { ['Content-Type'] = 'application/json' })
end

boldText = function(text)
    local boldFonts = ensure(constants.boldFonts, {})

    text = ensure(text, '')

    for k, v in pairs(boldFonts) do
        text = text:gsub(k, v)
    end

    return text
end

dateTimeToTime = function(datatime)
    datatime = ensure(datatime, '1001-01-01 01:01:01')

    local year, month, day, hour, min, sec =
        datatime:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")

    local date = {
        year = ensure(year, 1001),
        month = ensure(month, 1),
        day = ensure(day, 1),
        hour = ensure(hour, 1),
        min = ensure(min, 1),
        sec = ensure(sec, 1)
    }

    if (os == nil) then
        return date
    end

    return os.time(date)
end

readData = function(name)
    name = ensure(name, 'unknown')

    local path = ('data/%s'):format(name)
    local raw = LoadResourceFile(RESOURCE_NAME, path)

    if (name:endsWith('.json')) then
        if (raw) then
            return json.decode(raw)
        end

        return {}
    end
    
    return raw
end

getIPHubInfo = function(ip)
	local code, country = 0, 'XX'
	local done = false
	local body = {
		['X-Key'] = ensure(GetConvar('iphub_apiKey', 'unknown'), 'unknown')
	}

	ip = ensure(ip, '127.0.0.1')

	PerformHttpRequest(('https://v2.api.iphub.info/ip/%s'):format(ip), function(s, r, h)
		if (s == 200) then
			local response = json.decode(ensure(r, '{}'))

			code = ensure(response.block, 0)
			country = ensure(response.countryCode, 'XX')
		end

		done = true
	end, 'GET', encode(body), body)

	repeat Citizen.Wait(0) until done == true

	return code, country
end

timeToString = function(time)
    time = ensure(time, 0)

    if (time <= 0) then
        return 0, 'none'
    elseif (time < 60) then
        local remain = math.floor(math.modf(time,60))
        return remain, remain <= 0 and 'second' or 'seconds'
    elseif (time < 3600) then
        local remain = math.floor(math.modf(time, 3600) / 60)
        return remain, remain <= 0 and 'minute' or 'minutes'
    elseif (time < 86400) then
        local remain = math.floor(math.modf(time, 86400)/ 3600)
        return remain, remain <= 0 and 'hour' or 'hours'
    end

    local remain = math.floor(time / 86400)
    return remain, remain <= 0 and 'day' or 'days'
end

round = function(value, numDecimalPlaces)
    if (numDecimalPlaces) then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    end

    return math.floor(value + 0.5)
end

generateCitizenId = function(identifier)
    identifier = ensure(identifier, 'unknown')
    
    if (identifier == 'unknown') then return 'unknown' end
	if (identifier == 'system') then return 'system' end

	if (PRIMARY == 'steam' or PRIMARY == 'license' or PRIMARY == 'license2') then
		local rawPrefix = tonumber(identifier, 16)
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	elseif (PRIMARY == 'xbl' or PRIMARY == 'live' or PRIMARY == 'discord' or PRIMARY == 'fivem') then
		local rawPrefix = tonumber(identifier)
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	elseif (PRIMARY == 'ip') then
		local rawPrefix = tonumber(identifier:gsub('[.]', ''))
		local rawSuffix = GetHashKey(identifier)
		local prefix = string.format('%x', rawPrefix)
		local suffix = string.format('%x', rawSuffix)

		return ('%s%s'):format(prefix, suffix)
	end

	return 'unknown'
end

playerIdentifiers = function(rawIdentifiers)
    rawIdentifiers = ensure(rawIdentifiers, {})

    local identifiers = {
        steam = nil,
        license = nil,
        license2 = nil,
        xbl = nil,
        live = nil,
        discord = nil,
        fivem = nil,
        ip = nil,
        fxid = nil
    }

    for k, v in pairs(rawIdentifiers) do
        local identifier = ensure(v, 'unknown')

        for k2, v2 in pairs(constants.identifierTypes) do
            local prefix = ('%s:'):format(v2)

            if (identifier:startsWith(prefix)) then
                identifiers[v2] = identifier:sub(#prefix + 1)
            end
        end
    end

    identifiers.fxid = generateCitizenId(identifiers[PRIMARY:lower()])

    return identifiers
end

getCurrentDate = function()
    local date = { year = 2021, month = 1, day = 1, hour = 0, minute = 0, second = 0 }

    if (os ~= nil and os.date ~= nil) then
        local d = ensure(os.date('*t'), {})

        date = {
            year = ensure(d.year, 2021),
            month = ensure(d.month, 1),
            day = ensure(d.day, 1),
            hour = ensure(d.hour, 0),
            minute = ensure(d.min, 0),
            second = ensure(d.sec, 0)
        }
    end

    return date
end

function string:startsWith(word)
    word = ensure(word, 'unknown')

    return self:sub(1, #word) == word
end

function string:endsWith(word)
    word = ensure(word, 'unknown')

    return self:sub(-#word) == word
end

function string:split(delim)
    delim = ensure(delim, 'unknown')

    local t = {}

    for substr in self:gmatch("[^".. delim.. "]*") do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(t,substr)
        end
    end

    return t
end

function string:replace(this, that)
    this = ensure(this, 'unknown')
    that = ensure(that, 'unknown')

    local b, e = self:find(this, 1, true)

    if b == nil then
        return self
    else
        return self:sub(1, b - 1) .. that .. self:sub(e + 1):replace(this, that)
    end
end