presentCard = setmetatable({
    title = nil,
    description = nil,
    banner = nil,
    deferrals = deferrals
}, {})

function presentCard:update()
    local cardJson = self:generate()

    self.deferrals.presentCard(cardJson)
end

function presentCard:setTitle(title, update)
    title = ensure(title, 'unknown')
    update = ensure(update, true)

    if (title == 'unknown') then title = nil end

    self.title = title

    if (update) then self:update() end
end

function presentCard:setDescription(description, update)
    description = ensure(description, 'unknown')
    update = ensure(update, true)

    if (description == 'unknown') then description = nil end

    self.description = description

    if (update) then self:update() end
end

function presentCard:setBanner(banner, update)
    banner = ensure(banner, 'unknown')
    update = ensure(update, true)

    if (banner == 'unknown') then banner = nil end

    self.banner = banner

    if (update) then self:update() end
end

function presentCard:reset(update)
    update = ensure(update, true)

    self.title = nil
    self.description = nil
    self.banner = nil

    if (update) then self:update() end
end

function presentCard:override(card, ...)
    self.deferrals.presentCard(card, ...)
end

function presentCard:generate()
    local config = ensure(config('general'), {})
    local cfgBanner = ensure(config.bannerUrl, 'https://i.imgur.com/Rw4P2BM.gif')
    local serverName = ensure(config.serverName, 'FiveUX Framework')
    local _tit = _('connecting_title', serverName)
    local _desc = _('connecting_description', serverName)

    title = ensure(self.title, _tit)
    description = ensure(self.description, _desc)
    banner = ensure(self.banner, cfgBanner)

    local card = {
        ['type'] = 'AdaptiveCard',
        ['body'] = {
            { type = "Image", url = banner },
            { type = "TextBlock", size = "Medium", weight = "Bolder", text = title, horizontalAlignment = "Center" },
            { type = "TextBlock", text = description, wrap = true, horizontalAlignment = "Center" }
        },
        ['$schema'] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ['version'] = "1.3"
    }

    return encode(card)
end

function presentCard:init(deferrals, title, description, banner)
    title = ensure(title, 'unknown', true)
    description = ensure(description, 'unknown', true)
    banner = ensure(banner, 'unknown', true)

    self.deferrals = deferrals
    self.title = title
    self.description = description
    self.banner = banner

    return self
end

debug(_('connecting_title', 'test'))

register('presentCard', presentCard)