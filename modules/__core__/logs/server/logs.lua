m('players')
m('db')

local data = {}

logging = {}

function logging:create(source)
    source = ensure(source, 0)

    local logger = {}
    local player = players:load(source)
    local identifier = ensure(player.identifier, 'unknown')

    if (identifier == 'unknown') then
        return nil
    end

    local key = ('logger:player:%s'):format(identifier)

    if (cache:exists(key)) then
        logger = cache:read(key)
        logger.user = player

        return logger
    end

    logger.user = player
    logger.avatar = ensure(ensure(config('general'), {}).avatarUrl, 'https://i.imgur.com/xa7JN6h.png')

    if (player.identifiers.steam ~= nil and not any(player.identifiers.steam, { 'unknown', 'none', '', 'console' }, 'value')) then
        local steamHex64 = tonumber(player.identifiers.steam, 16)
        local webApiKey = ensure(GetConvar('steam_webApiKey', 'unknown'), 'unknown')

        if (webApiKey ~= 'unknown') then
            local loaded = false
            local url = ('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s'):format(webApiKey, steamHex64)

            PerformHttpRequest(url, function(s, r, h)
                if (s == 200) then
                    local rawData = ensure(r, '{}')
                    local jsonData = ensure(json.decode(rawData), {})
                    local response = ensure(jsonData.response, {})
                    local players = ensure(response.players, {})

                    if (#players > 0) then
                        logger.avatar = ensure(players[1].avatarfull, logger.avatar)
                    end
                end

                loaded = true
            end, 'GET', '', { ['Content-Type'] = 'application/json' })

            repeat Citizen.Wait(0) until loaded == true
        end
    end

    function logger:log(object)
        object = ensure(object, {})

        local arguments = ensure(object.arguments, {})
        local action = ensure(object.action, 'none')
        local color = ensure(object.color, 9807270)
        local footer = ensure(object.footer, ("%s | %s | %s"):format(self.user.identifier, action, dateTimeString()))
        local message = ensure(object.message, '')
        local title = ensure(object.title, ('**log(%s)** %s'):format(action, self.user.name))
        local username = ensure(object.username, ('log(%s) %s'):format(action, self.user.name))
        local webhooks = getWebhooks(action)
        local logDiscord = ensure(object.discord, true)
        local logDatabase = ensure(object.database, true)

        username = self:replacePlaceholders(action, username)
        title = self:replacePlaceholders(action, title)
        message = self:replacePlaceholders(action, message)
        footer = self:replacePlaceholders(action, footer)

        if (#webhooks > 0 and logDiscord) then
            logToDiscord(username, title, message, footer, webhooks, color, self.avatar)
        end

        if (logDatabase) then
            db:insert('INSERT INTO `logs` (`identifier`, `name`, `action`, `arguments`) VALUES (:identifier, :name, :action, :arguments)', {
                ['identifier'] = self.user.identifier,
                ['name'] = self.user.name,
                ['action'] = action,
                ['arguments'] = json.encode(arguments)
            }, function() end)
        end
    end

    function logger:replacePlaceholders(action, str)
        action = ensure(action, 'none')

        return ensure(str, '')
            :gsub('{name}', self.user.name)
            :gsub('{action}', action)
            :gsub('{identifier}', self.user.identifier)
            :gsub('{identifier:steam}', ensure(self.user.identifiers.steam, 'none'))
            :gsub('{identifier:license}', ensure(self.user.identifiers.license, 'none'))
            :gsub('{identifier:license2}', ensure(self.user.identifiers.license2, 'none'))
            :gsub('{identifier:xbl}', ensure(self.user.identifiers.xbl, 'none'))
            :gsub('{identifier:live}', ensure(self.user.identifiers.live, 'none'))
            :gsub('{identifier:discord}', ensure(self.user.identifiers.discord, 'none'))
            :gsub('{identifier:fivem}', ensure(self.user.identifiers.fivem, 'none'))
            :gsub('{identifier:ip}', ensure(self.user.identifiers.ip, 'none'))
            :gsub('{source}', self.user.source)
    end

    cache:write(key, logger)

    return logger
end

register('logging', logging)
register('logger', function(source)
    return logging:create(ensure(source, 0))
end)