import 'db'

local data = {
    players = {},
    modules = {}
}

---@class logs
logs = {}

--- Returns a list of webhooks matching given action
---@param self logs
---@param action string Action to search webhook for
---@param fallback string Fallback webhook if you don't want to use default one
---@return table List of webhooks
function logs:getWebhooks(action, fallback)
    local results = {}
    local configuration = ensure(config('discord'), {})
    local webhooks = ensure(configuration.webhooks, {})
    local fbWebhook = ensure(webhooks.fallback, {})

    action = ensure(action, 'unknown')
    fallback = ensure(fallback, fbWebhook)

    if (webhooks[action] ~= nil) then
        local webhooksList = ensureStringList(ensure(webhooks[action], {}))

        for k, v in pairs(webhooksList) do
            if (v:startsWith('https://') or v:startsWith('http://')) then
                table.insert(results, v)
            end
        end

        return results
    end

    local actionParts = ensure(action:split('.'), {})

    if (#actionParts > 2) then
        local newAction = ensure(actionParts[1], 'unknown')

        for i = 2, (#actionParts - 1), 1 do
            newAction = ('%s%s%s'):format(newAction, (i == 2 and '' or '.'), ensure(actionParts[i], 'unknown'))
        end

        return self:getWebhooks(newAction, fallback)
    elseif (#actionParts == 2) then
        return self:getWebhooks(ensure(actionParts[1], 'unknown'), fallback)
    end

    local fallbackList = ensureStringList(fallback)

    for k, v in pairs(fallbackList) do
        if (v:startsWith('https://') or v:startsWith('http://')) then
            table.insert(results, v)
        end
    end

    return results
end

--- Create a new log object
---@param self logs
---@param type string Type of logging (player/module)
---@return logger|table Log object
function logs:create(type, ...)
    type = ensure(type, 'module')

    --- @class logger
    local logger = {}
    local arguments = {...}
    local name = ensure(arguments[1], 'unknown')
    local configuration = config('general')

    if (type == 'player') then
        local rawIdentifiers = ensure(arguments[2], {})
        local identifiers = playerIdentifiers(rawIdentifiers)
        local primaryIdentifier = ensure(identifiers[PRIMARY], 'unknown')

        if (data == nil) then data = { players = {}, modules = {} } end
        if (data.players == nil) then data.players = {} end
        if (data.players[primaryIdentifier] ~= nil) then return data.players[primaryIdentifier] end

        logger.key = primaryIdentifier
        logger.name = name
        logger.fxid = ensure(identifiers.fxid, 'unknown')
        logger.identifier = primaryIdentifier
        logger.identifiers = identifiers
        logger.type = type
        logger.avatar = ensure(configuration.avatarUrl, 'https://i.imgur.com/xa7JN6h.png')

        Citizen.CreateThread(function()
            logger.avatar = self:getSteamAvatar(logger.identifiers.steam, logger.avatar)
        end)
    elseif (type == 'module') then
        logger.key = name
        logger.name = name
        logger.fxid = name
        logger.identifier = name
        logger.identifiers = {}
        logger.type = type
        logger.avatar = ensure(configuration.avatarUrl, 'https://i.imgur.com/xa7JN6h.png')
    end

    function logger:log(object)
        object = ensure(object, {})

        local arguments = ensure(object.arguments, {})
        local action = ensure(object.action, 'none')
        local color = ensure(object.color, 9807270)
        local footer = ensure(object.footer, ("%s | %s"):format((self.type == 'player' and self.fxid or self.name), action))
        local message = ensure(object.message, '')
        local title = ensure(object.title, ('**[%s]** %s'):format(action, self.name))
        local username = ensure(object.username, ('[%s] %s'):format(action, self.name))
        local webhooks = logs:getWebhooks(action)
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
            if (self.type == 'player') then
                db:insert('INSERT INTO `player_logs` (`fxid`, `name`, `action`, `arguments`) VALUES (:fxid, :name, :action, :arguments)', {
                    ['fxid'] = ensure(self.fxid, 'unknown'),
                    ['name'] = ensure(self.name, 'unknown'),
                    ['action'] = ensure(action, 'unknown'),
                    ['arguments'] = json.encode(arguments)
                }, function() end)
            elseif (self.type == 'module') then
                db:insert('INSERT INTO `module_logs` (`name`, `action`, `arguments`) VALUES (:name, :action, :arguments)', {
                    ['name'] = ensure(self.name, 'unknown'),
                    ['action'] = ensure(action, 'unknown'),
                    ['arguments'] = json.encode(arguments)
                }, function() end)
            end
        end
    end

    function logger:replacePlaceholders(action, str)
        action = ensure(action, 'none')

        return ensure(str, '')
            :gsub('{name}', ensure(self.name, 'unknown'))
            :gsub('{action}', action)
            :gsub('{identifier}', ensure(self.identifier, 'unknown'))
            :gsub('{citizen}', ensure(self.identifiers.citizen, 'none'))
            :gsub('{identifier:steam}', ensure(self.identifiers.steam, 'none'))
            :gsub('{identifier:license}', ensure(self.identifiers.license, 'none'))
            :gsub('{identifier:license2}', ensure(self.identifiers.license2, 'none'))
            :gsub('{identifier:xbl}', ensure(self.identifiers.xbl, 'none'))
            :gsub('{identifier:live}', ensure(self.identifiers.live, 'none'))
            :gsub('{identifier:discord}', ensure(self.identifiers.discord, 'none'))
            :gsub('{identifier:fivem}', ensure(self.identifiers.fivem, 'none'))
            :gsub('{identifier:ip}', ensure(self.identifiers.ip, 'none'))
            :gsub('{identifier:citizen}', ensure(self.identifiers.citizen, 'none'))
            :gsub('{source}', ensure(self.source, 'unknown'))
    end

    if (type == 'player') then
        data.players[logger.key] = logger
    elseif (type == 'module') then
        data.modules[logger.key] = logger
    end

    return logger
end

--- Load avatar url from Steam API
---@param self logs
---@param identifier string Steam identifier
---@param fallback string Fallback avatar URL
---@return string Fallback avatar or Steam avatar
function logs:getSteamAvatar(identifier, fallback)
    identifier = ensure(identifier, 'unknown')
    fallback = ensure(fallback, 'https://i.imgur.com/xa7JN6h.png')

    if (identifier ~= nil and not any(identifier, { 'unknown', 'none', '', 'system' }, 'value')) then
        local steamHex64 = tonumber(identifier, 16)
        local webApiKey = ensure(GetConvar('steam_webApiKey', 'unknown'), 'unknown')

        if (webApiKey ~= 'unknown') then
            local loaded = false
            local avatar = fallback
            local url = ('http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s'):format(webApiKey, steamHex64)

            PerformHttpRequest(url, function(s, r, h)
                if (s == 200) then
                    local rawData = ensure(r, '{}')
                    local jsonData = ensure(json.decode(rawData), {})
                    local response = ensure(jsonData.response, {})
                    local players = ensure(response.players, {})

                    if (#players > 0) then
                        avatar = ensure(players[1].avatarfull, fallback)
                    end
                end

                loaded = true
            end, 'GET', '', { ['Content-Type'] = 'application/json' })

            repeat Citizen.Wait(0) until loaded == true

            return avatar
        end
    end

    return fallback
end

export('logs', logs)