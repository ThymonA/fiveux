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
        if (input_type == 'table') then return json.encode(input) or (not ignoreDefault and default or nil) end
        if (input_type == 'vector3') then return json.encode({ input.x, input.y, input.z }) or (not ignoreDefault and default or nil) end
        if (input_type == 'vector2') then return json.encode({ input.x, input.y }) or (not ignoreDefault and default or nil) end

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
        if (input_type == 'table' or input_type == 'vector3') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)

            return vector2(x, y)
        end

        if (input_type == 'number') then
            return vector2(input, input)
        end

        if (input_type == 'string' and input:startsWith('{') and input:endsWith('}')) then
            local decodedInput = ensure(json.decode(input), {})

            local x = ensure(decodedInput.x, default.x)
            local y = ensure(decodedInput.y, default.y)

            return vector2(x, y)
        end

        if (input_type == 'string' and input:startsWith('[') and input:endsWith(']')) then
            local decodedInput = ensure(json.decode(input), {})

            local x = ensure(decodedInput[1], default.x)
            local y = ensure(decodedInput[2], default.y)

            return vector2(x, y)
        end

        return (not ignoreDefault and default or nil)
    end

    if (output_type == 'vector3') then
        if (input_type == 'table' or input_type == 'vector2') then
            local x = ensure(input.x, default.x)
            local y = ensure(input.y, default.y)
            local z = ensure(input.z, input_type == 'vector2' and 0 or default.z)

            return vector3(x, y, z)
        end

        if (input_type == 'number') then
            return vector3(input, input, input)
        end

        if (input_type == 'string' and input:startsWith('{') and input:endsWith('}')) then
            local decodedInput = ensure(json.decode(input), {})

            local x = ensure(decodedInput.x, default.x)
            local y = ensure(decodedInput.y, default.y)
            local z = ensure(decodedInput.z, default.z)

            return vector3(x, y, z)
        end

        if (input_type == 'string' and input:startsWith('[') and input:endsWith(']')) then
            local decodedInput = ensure(json.decode(input), {})

            local x = ensure(decodedInput[1], default.x)
            local y = ensure(decodedInput[2], default.y)
            local z = ensure(decodedInput[3], default.z)

            return vector3(x, y, z)
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

encode = function(input)
    local innerTable = ''
    local hasKey = false

    input = ensure(input, {})

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
				finalValue = hasIndex and ('"%s"'):format(v) or ('"%s": "%s"'):format(k, v)
			elseif (valueType == 'boolean') then
				finalValue = hasIndex and ('%s'):format(v and 'true' or 'false') or ('"%s": %s'):format(k, v and 'true' or 'false')
			elseif (valueType == 'vector2') then
				finalValue = hasIndex and ('[%.2f,%.2f]'):format(v.x, v.y) or ('"%s": [%.2f,%.2f]'):format(k, v.x, v.y)
			elseif (valueType == 'vector3') then
				finalValue = hasIndex and ('[%.2f,%.2f,%.2f]'):format(v.x, v.y, v.z) or ('"%s": [%.2f,%.2f,%.2f]'):format(k, v.x, v.y, v.z)
			elseif (valueType == 'vector4') then
				finalValue = hasIndex and ('[%.2f,%.2f,%.2f,%.2f]'):format(v.x, v.y, v.z, v.w) or ('"%s": [%.2f,%.2f,%.2f,%.2f]'):format(k, v.x, v.y, v.z, v.w)
			end
        end

        if (innerTable == nil or string.len(innerTable) == 0) then
			innerTable = finalValue
		else
			innerTable = ('%s,%s'):format(innerTable, finalValue)
		end
    end

    return hasKey and ('{%s}'):format(innerTable) or ('[%s]'):format(innerTable)
end

print_error = function(msg, module)
    module = ensure(module, 'global')
	msg = ensure(msg, 'UNKNOWN ERROR')

	local fst = Citizen.InvokeNative(-0x28F3C436 & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())
	local error_message = nil
	local start_index, end_index = msg:find(':%d+:')

	if (start_index and end_index) then
		msg = ('%s^7 line^1:^7%s^7\n\n^1%s\n'):format(
			msg:sub(1, start_index - 1),
			msg:sub(start_index + 1, end_index - 1),
			msg:sub(end_index + 1)
		)
	end

	if (not fst) then
		error_message = ('^1> ^1error^7(^1%s^7/^1%s^7): ^1%s^7'):format(ENVIRONMENT, module, msg)
	else
		error_message = ('^1> ^1error^7(^1%s^7/^1%s^7): ^1%s\n^7%s^7'):format(ENVIRONMENT, module, msg, fst)
	end

    error_message = ('%s^7'):format(error_message)
    error_message = error_message:gsub('%~x~', '^1')
    error_message = error_message:gsub('%~s~', '^7')

	print(error_message)
end