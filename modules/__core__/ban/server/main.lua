import 'db'
import 'logs'

--- Create a logger object for this module
local logger = logs:create('module', NAME)

---@class bans
bans = {}

--- Returns ban status of given identifiers
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@return boolean Any identifier is banned
---@return table Information about ban
function bans:get(identifiers)
    identifiers = ensure(identifiers, {})

    local query, params = self:selectBanQuery(identifiers)

    if (query ~= nil) then
        query = ('%s LIMIT 1'):format(query)

        local results = ensure(db:fetchAll(query, params), {})

        if (#results > 0) then
            local originalBan = ensure(results[1], {})

            return true, {
                id = ensure(originalBan.id, 0),
                reason = ensure(originalBan.reason, T('default_ban_reason')),
                expire = ensure(originalBan.expire, 'unknown'),
                bannedBy = ensure(originalBan.bannedBy, 'system')
            }
        end
    end

    return false, {
        id = 0,
        reason = '',
        expire = '',
        bannedBy = ''
    }
end

--- Add a new ban to ban system
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@param username string Username that corresponds to the ban
---@param reason string Reason why player is banned
---@param bannedBy string Identifier who banned specific player
---@param year number Number of years banned
---@param month number Number of months banned
---@param day number Number of days banned
---@param hour number Number of hours banned
---@param minute number Number of minutes banned
---@param second number Number of seconds banned
---@return boolean If ban has been added
function bans:add(identifiers, username, reason, bannedBy, year, month, day, hour, minute, second)
    identifiers = ensure(identifiers, {})
    username = ensure(username, 'unknown')
    reason  = ensure(reason, T('default_ban_reason'))
    bannedBy = ensure(bannedBy, 'system')
    year = ensure(year, 0)
    month = ensure(month, 0)
    day = ensure(day, 0)
    hour = ensure(hour, 0)
    minute = ensure(minute, 0)
    second = ensure(second, 0)

    local hasBan, banInfo = self:get(identifiers)

    if (not hasBan) then
        local query, params = self:addBanQuery(identifiers, username, reason, bannedBy, year, month, day, hour, minute, second)
        local result = db:insert(query, params)
        local id = ensure(result, 0)
        local done = id >= 1

        if (done) then
            local expire = db:fetchScalar('SELECT `expire` FROM `player_bans` WHERE `id` = :id LIMIT 1', { ['id'] = id })
            
            logger:log({
                arguments = { id = id, reason = reason, year = year, month = month, day = day, hour = hour, minute = minute, second = second },
                action = 'ban.add',
                color = constants.colors.red,
                message = T('ban_added', username, reason, ensure(expire, 'unknown'), bannedBy),
                title = T('ban_title'),
                footer = T('ban_add_footer', year, month, day, hour, minute)
            })
        end

        return done
    end

    return false
end

--- Extends a existing ban
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@param username string Username that corresponds to the ban
---@return boolean If extend ban has been added
function bans:extend(identifiers, username)
    identifiers = ensure(identifiers, {})
    username = ensure(username, 'unknown')

    local query, params = self:selectBanQuery(identifiers)

    if (query ~= nil) then
        local results = ensure(db:fetchAll(query, params), {})

        if (#results > 0) then
            local columns = { 'steam', 'license', 'license2', 'xbl', 'live', 'discord', 'fivem', 'fxid' }
            local originalBan = ensure(results[1], {})
            local checklist = {}

            for _, v in pairs(columns) do checklist[v] = false end
            for k, v in pairs(params) do checklist[k] = true end
            
            for k, v in pairs(results) do
                for _, v2 in pairs(columns) do
                    if (checklist[v2] and v[v2] == identifiers[v2]) then
                        checklist[v2] = false
                    end
                end
            end

            local newIdentifiers = {}
            local needsNewBan = false

            for k, v in pairs(checklist) do
                if (v) then
                    needsNewBan = true
                    newIdentifiers[k] = identifiers[k]
                end
            end

            if (needsNewBan) then
                local reason = ensure(originalBan.reason, T('default_ban_reason'))
                local bannedBy = ensure(originalBan.bannedBy, 'system')
                local expire = ensure(originalBan.expire, '2021-01-01 00:00:00')
                local parentBanId = ensure(originalBan.id, 0)
                local query2, params2 = self:extendBanQuery(
                    identifiers,
                    username,
                    reason,
                    bannedBy,
                    expire,
                    parentBanId
                )

                local result = db:insert(query2, params2)
                local id = ensure(result, 0)
                local done = id >= 1

                if (done) then
                    logger:log({
                        arguments = { id = id, reason = reason, expire = expire, parentBanId = parentBanId },
                        action = 'ban.extend',
                        color = constants.colors.orange,
                        message = T('ban_extend', username, reason, expire, bannedBy),
                        title = T('ban_title'),
                        footer = T('ban_extend_footer', id)
                    })
                end

                return done
            end
        end
    end

    return false
end

--- Generate a SQL select query based on given identifiers
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@return string Generated select query
---@return table Generated query params
function bans:selectBanQuery(identifiers)
    identifiers = ensure(identifiers, {})

    local params = {}
    local query = 'SELECT * FROM `player_bans` WHERE'
    local values = nil
    local columns = { 'steam', 'license', 'license2', 'xbl', 'live', 'discord', 'fivem', 'fxid' }

    for _, v in pairs(columns) do
        if (identifiers[v]) then
            params[v] = identifiers[v]
            values = values == nil and ('`%s` = :%s'):format(v, v) or ('%s OR `%s` = :%s'):format(values, v, v)
        end
    end

    if (values == nil) then
        return nil, nil
    end

    query = ('%s (%s) AND `expire` >= CURRENT_TIMESTAMP ORDER BY `expire` DESC'):format(query, values)

    return query, params
end

--- Generate a SQL insert query based on given identifiers, reason and expire
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@param username string Username that corresponds to the ban
---@param reason string Reason why player is banned
---@param bannedBy string Identifier who banned specific player
---@param year number Number of years banned
---@param month number Number of months banned
---@param day number Number of days banned
---@param hour number Number of hours banned
---@param minute number Number of minutes banned
---@param second number Number of seconds banned
---@return string Generated insert query
---@return table Generated query params
function bans:addBanQuery(identifiers, username, reason, bannedBy, year, month, day, hour, minute, second)
    identifiers = ensure(identifiers, {})
    username = ensure(username, 'unknown')
    reason  = ensure(reason, T('default_ban_reason'))
    bannedBy = ensure(bannedBy, 'system')
    year = ensure(year, 0)
    month = ensure(month, 0)
    day = ensure(day, 0)
    hour = ensure(hour, 0)
    minute = ensure(minute, 0)
    second = ensure(second, 0)

    local params = {}
    local query = 'INSERT INTO `player_bans`'
    local columnValues = nil
    local paramValues = nil
    local columns = { 'steam', 'license', 'license2', 'xbl', 'live', 'discord', 'fivem', 'fxid', 'ip' }

    for _, v in pairs(columns) do
        if (identifiers[v]) then
            params[v] = identifiers[v]
            columnValues = columnValues == nil and ('`%s`'):format(v) or ('%s,`%s`'):format(columnValues, v)
            paramValues = paramValues == nil and (':%s'):format(v) or ('%s,:%s'):format(paramValues, v)
        end
    end

    params['username'] = username
    columnValues = columnValues == nil and '`username`' or ('%s,`username`'):format(columnValues)
    paramValues = paramValues == nil and ':username' or ('%s,:username'):format(paramValues)

    params['reason'] = reason
    columnValues = columnValues == nil and '`reason`' or ('%s,`reason`'):format(columnValues)
    paramValues = paramValues == nil and ':reason' or ('%s,:reason'):format(paramValues)

    params['bannedBy'] = bannedBy
    columnValues = columnValues == nil and '`bannedBy`' or ('%s,`bannedBy`'):format(columnValues)
    paramValues = paramValues == nil and ':bannedBy' or ('%s,:bannedBy'):format(paramValues)

    params['expire'] = ('%s-%s-%s %s:%s:%s'):format(year, month, day, hour, minute, second)
    columnValues = columnValues == nil and '`expire`' or ('%s,`expire`'):format(columnValues)
    paramValues = paramValues == nil and 'TIMESTAMP(CURRENT_TIMESTAMP + TIMESTAMP(:expire))' or ('%s,TIMESTAMP(CURRENT_TIMESTAMP + TIMESTAMP(:expire))'):format(paramValues)

    query = ('%s (%s) VALUES (%s)'):format(query, columnValues, paramValues)

    return query, params
end

--- Generate a insert query for an new child of existing ban
---@param self bans
---@param identifiers table List of identifiers ['steam'] => 'value' etc..
---@param username string Username that corresponds to the ban
---@param reason string Reason why player is banned
---@param bannedBy string Identifier who banned specific player
---@param expire string Timestring when ban original expires
---@param parentBan number Id of parent ban
function bans:extendBanQuery(identifiers, username, reason, bannedBy, expire, parentBan)
    identifiers = ensure(identifiers, {})
    username = ensure(username, 'unknown')
    reason = ensure(reason, T('default_ban_reason'))
    bannedBy = ensure(bannedBy, 'system')
    expire = ensure(expire, '2021-01-01 00:00:00')
    parentBan = ensure(parentBan, 0)

    local params = {}
    local query = 'INSERT INTO `player_bans`'
    local columnValues = nil
    local paramValues = nil
    local columns = { 'steam', 'license', 'license2', 'xbl', 'live', 'discord', 'fivem', 'fxid', 'ip' }

    for _, v in pairs(columns) do
        if (identifiers[v]) then
            params[v] = identifiers[v]
            columnValues = columnValues == nil and ('`%s`'):format(v) or ('%s,`%s`'):format(columnValues, v)
            paramValues = paramValues == nil and (':%s'):format(v) or ('%s,:%s'):format(paramValues, v)
        end
    end

    params['username'] = username
    columnValues = columnValues == nil and '`username`' or ('%s,`username`'):format(columnValues)
    paramValues = paramValues == nil and ':username' or ('%s,:username'):format(paramValues)

    params['reason'] = reason
    columnValues = columnValues == nil and '`reason`' or ('%s,`reason`'):format(columnValues)
    paramValues = paramValues == nil and ':reason' or ('%s,:reason'):format(paramValues)

    params['bannedBy'] = bannedBy
    columnValues = columnValues == nil and '`bannedBy`' or ('%s,`bannedBy`'):format(columnValues)
    paramValues = paramValues == nil and ':bannedBy' or ('%s,:bannedBy'):format(paramValues)

    params['expire'] = expire
    columnValues = columnValues == nil and '`expire`' or ('%s,`expire`'):format(columnValues)
    paramValues = paramValues == nil and ':expire' or ('%s,:expire'):format(paramValues)

    if (parentBan > 0) then
        params['parentBan'] = parentBan
        columnValues = columnValues == nil and '`parentBan`' or ('%s,`parentBan`'):format(columnValues)
        paramValues = paramValues == nil and ':parentBan' or ('%s,:parentBan'):format(paramValues)
    end

    query = ('%s (%s) VALUES (%s)'):format(query, columnValues, paramValues)

    return query, params
end

--- Triggers when a player is connecting to the server
on('playerConnecting', function(player, callback, presentCard)
    local banned, info = bans:get(player.identifiers)

    player:setVariable('banned', banned)
    player:setVariable('ban_info', info)

    if (banned) then
        local cfg = config('general')
        local banNewIdentifiers = ensure(cfg.banNewIdentifiers, false)

        if (banNewIdentifiers) then
            bans:extend(player.identifiers, player.name)
        end

        local reason = ensure(info.reason, T('default_ban_reason'))
        local expire = ensure(info.expire, 'unknown')
        local fxid = ensure(player.fxid, 'unknown')

        callback(serverMessage(T('ban_message', reason, expire, fxid)))
    else
        callback()
    end
end)

export('bans', bans)