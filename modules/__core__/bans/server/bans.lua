m('db')
m('sqlquery')

local data = {}

bans = {}

function bans:updateBanStatus(identifiers, username)
    identifiers = ensure(identifiers, {})
    username = ensure(username, '')

    local cfg = config('general')
    local banNewIdentifiers = ensure(cfg.banNewIdentifiers, true)
    local selectSql, selectParams = sqlquery.ban:select(identifiers, username)

    selectSql = ('%s AND `expire` >= CURRENT_TIMESTAMP ORDER BY `expire` DESC'):format(selectSql)

    local results = ensure(db:fetchAll(selectSql, selectParams), {})

    if (#results > 0) then
        local highestBan = ensure(results[1], {})

        if (banNewIdentifiers) then
            local checklist = {}

            for k, v in pairs(selectParams) do checklist[k] = true end

            for _, ban in pairs(results) do
                if (checklist.citizen and ban.citizen == identifiers.citizen) then checklist.citizen = false end
                if (checklist.steam and ban.steam == identifiers.steam) then checklist.steam = false end
                if (checklist.license and ban.license == identifiers.license) then checklist.license = false end
                if (checklist.license2 and ban.license2 == identifiers.license2) then checklist.license2 = false end
                if (checklist.xbl and ban.xbl == identifiers.xbl) then checklist.xbl = false end
                if (checklist.live and ban.live == identifiers.live) then checklist.live = false end
                if (checklist.discord and ban.discord == identifiers.discord) then checklist.discord = false end
                if (checklist.fivem and ban.fivem == identifiers.fivem) then checklist.fivem = false end
            end

            local newIdentifiers = {}
            local needsNewBan = false

            for k, v in pairs(checklist) do
                if (v == true) then
                    needsNewBan = true
                    newIdentifiers[k] = identifiers[k]
                end
            end

            if (needsNewBan) then
                local insertSql, insertParams = sqlquery.ban:insert(
                    newIdentifiers,
                    ensure(username, ''),
                    ensure(highestBan.reason, T('default_ban_reason')),
                    ensure(highestBan.expire, '2021-01-01 00:00:00'),
                    ensure(highestBan.bannedBy, 'system'),
                    ensure(highestBan.id, 0)
                )

                db:insert(insertSql, insertParams)
            end
        end

        return true, {
            reason = ensure(highestBan.reason, T('default_ban_reason')),
            expire = ensure(highestBan.expire, '2021-01-01 00:00:00'),
            bannedBy = ensure(highestBan.bannedBy, 'system')
        }
    end

    return false, {
        reason = T('default_ban_reason'),
        expire = '2021-01-01 00:00:00',
        bannedBy = 'system'
    }
end

register('bans', bans)