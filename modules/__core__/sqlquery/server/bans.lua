sqlquery.ban = {}

function sqlquery.ban:select(identifiers)
    identifiers = ensure(identifiers, {})

    local queryParams = {}
    local selectQuery = 'SELECT * FROM `player_bans` WHERE'
    local values1 = nil
    local columns = { ['steam'] = 'steam', ['license'] = 'license', ['license2'] = 'license2', ['xbl'] = 'xbl', ['live'] = 'live', ['discord'] = 'discord', ['fivem'] = 'fivem', ['citizen'] = 'citizen' }

    for k, v in pairs(columns) do
        if (identifiers[k]) then
            queryParams[k] = identifiers[k]
            values1 = values1 == nil and ('`%s` = :%s'):format(v, k) or ('%s OR `%s` = :%s'):format(values1, v, k)
        end
    end

    selectQuery = ('%s (%s)'):format(selectQuery, values1)

    return selectQuery, queryParams
end

function sqlquery.ban:insert(identifiers, username, reason, expire, bannedBy, parentBan, previousBan)
    identifiers = ensure(identifiers, {})
    username = ensure(username, '')
    expire = ensure(expire, '2069-06-09 06:09:00')
    reason = ensure(reason, T('default_ban_reason'))
    bannedBy = ensure(bannedBy, 'system')
    parentBan = ensure(parentBan, 0)
    previousBan = ensure(previousBan, 0)

    local queryParams = {}
    local values1 = nil
    local values2 = nil
    local insertQuery = 'INSERT INTO `player_bans`'
    local columns = { ['steam'] = 'steam', ['license'] = 'license', ['license2'] = 'license2', ['xbl'] = 'xbl', ['live'] = 'live', ['discord'] = 'discord', ['fivem'] = 'fivem', ['citizen'] = 'citizen' }

    for k, v in pairs(columns) do
        if (identifiers[k]) then
            queryParams[k] = identifiers[k]
            values1 = values1 == nil and ('`%s`'):format(v) or ('%s,`%s`'):format(values1, v)
            values2 = values2 == nil and (':%s'):format(k) or ('%s,:%s'):format(values2, k)
        end
    end

    queryParams['reason'] = reason
    values1 = values1 == nil and '`reason`' or ('%s,`reason`'):format(values1)
    values2 = values2 == nil and ':reason' or ('%s,:reason'):format(values2)

    queryParams['expire'] = expire
    values1 = values1 == nil and '`expire`' or ('%s,`expire`'):format(values1)
    values2 = values2 == nil and ':expire' or ('%s,:expire'):format(values2)

    queryParams['banner'] = bannedBy
    values1 = values1 == nil and '`bannedBy`' or ('%s,`bannedBy`'):format(values1)
    values2 = values2 == nil and ':banner' or ('%s,:banner'):format(values2)
    
    queryParams['username'] = username
    values1 = values1 == nil and '`username`' or ('%s,`username`'):format(values1)
    values2 = values2 == nil and ':username' or ('%s,:username'):format(values2)

    if (parentBan > 0) then
        queryParams['parent'] = parentBan
        values1 = values1 == nil and '`parentBan`' or ('%s,`parentBan`'):format(values1)
        values2 = values2 == nil and ':parent' or ('%s,:parent'):format(values2)
    end

    if (previousBan > 0) then
        queryParams['previous'] = previousBan
        values1 = values1 == nil and '`previousBan`' or ('%s,`previousBan`'):format(values1)
        values2 = values2 == nil and ':previous' or ('%s,:previous'):format(values2)
    end

    insertQuery = ('%s (%s) VALUES (%s)'):format(insertQuery, values1, values2)

    return insertQuery, queryParams
end