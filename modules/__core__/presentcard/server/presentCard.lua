pc = {}

function pc:create(deferrals, title, description, banner)
    title = ensure(title, '', true)
    description = ensure(description, '', true)
    banner = ensure(banner, '', true)

    local presentCard = setmetatable({
        title = title,
        description = description,
        banner = banner,
        deferrals = deferrals 
    }, {})

    function presentCard:generate()
        local cfg = config('general')
        local serverName = ensure(cfg.serverName, 'FiveUX Framework')
        local _ban = ensure(cfg.bannerUrl, 'https://i.imgur.com/C7iadzZ.png')
        local _tit = T('connecting_title', serverName)
        local _desc = T('connecting_description', serverName)
        local _title = ensure(self.title, _tit)
        local _description = ensure(self.description, _desc)
        local _banner = ensure(self.banner, _ban)

        local card = {
            ['type'] = 'AdaptiveCard',
            ['body'] = {
                { type = "Image", url = _banner },
                { type = "TextBlock", size = "Medium", weight = "Bolder", text = _title, horizontalAlignment = "Center" },
                { type = "TextBlock", text = _description, wrap = true, horizontalAlignment = "Center" }
            },
            ['$schema'] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ['version'] = "1.3"
        }

        return encode(card)
    end

    function presentCard:update()
        local jData = self:generate()

        return self.deferrals.presentCard(jData)
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

    presentCard:update()

    return presentCard
end

register('presentCard', pc)