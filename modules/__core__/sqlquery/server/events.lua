sqlquery.events = {}

function sqlquery.events:select(identifiers)
    identifiers = ensure(identifiers, {})

    local params = {}
    local query = 'SELECT COUNT(*) FROM `identifiers` WHERE'

    if (identifiers.steam) then
        params['steam'] = identifiers.steam
        query = ('%s `steam` = :steam AND'):format(query)
    else
        query = ('%s `steam` IS NULL AND'):format(query)
    end

    if (identifiers.license) then
        params['license'] = identifiers.license
        query = ('%s `license` = :license AND'):format(query)
    else
        query = ('%s `license` IS NULL AND'):format(query)
    end

    if (identifiers.license2) then
        params['license2'] = identifiers.license2
        query = ('%s `license2` = :license2 AND'):format(query)
    else
        query = ('%s `license2` IS NULL AND'):format(query)
    end

    if (identifiers.xbl) then
        params['xbl'] = identifiers.xbl
        query = ('%s `xbl` = :xbl AND'):format(query)
    else
        query = ('%s `xbl` IS NULL AND'):format(query)
    end

    if (identifiers.live) then
        params['live'] = identifiers.live
        query = ('%s `live` = :live AND'):format(query)
    else
        query = ('%s `live` IS NULL AND'):format(query)
    end

    if (identifiers.discord) then
        params['discord'] = identifiers.discord
        query = ('%s `discord` = :discord AND'):format(query)
    else
        query = ('%s `discord` IS NULL AND'):format(query)
    end

    if (identifiers.fivem) then
        params['fivem'] = identifiers.fivem
        query = ('%s `fivem` = :fivem AND'):format(query)
    else
        query = ('%s `fivem` IS NULL AND'):format(query)
    end

    if (query:endsWith('AND')) then
        query = query:sub(1, (#query - 4))
    end

    return query, params
end