--- Local storage
local skinMenu = nil

---@class skins
skins = {}

--- Create a player skin object
---@return skin Player skin object
function skins:create(handle)
    handle = ensure(handle, PlayerPedId())

    local maxOverlayColors = GetNumHairColors()
    local isMPMale = GetEntityModel(handle) == GetHashKey('mp_m_freemode_01')
    local isMPFemale = GetEntityModel(handle) == GetHashKey('mp_f_freemode_01')
    local isMPCharachter = isMPMale or isMPFemale

    ---@class skin
    local skin = {
        handle = handle,
        mpMale = isMPMale,
        mpFemale = isMPFemale,
        mpCharachter = isMPCharachter,
        values = {
            hair = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 2), value = 0, enabled = isMPCharachter },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter },
                hightlights = { min = 0; max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter }
            },
            blemish = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(0) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            beard = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(1) or 0, value = 0, enabled = isMPCharachter and isMPMale },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPMale },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPMale }
            },
            eyebrow = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(2) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter }
            },
            ageing = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(3) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            makeup = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(4) or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale }
            },
            blush = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(5) or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale }
            },
            complexion = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(6) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            sunDamage = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(7) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            lipstick = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(8) or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale }
            },
            molesFreckle = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(9) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            chestHair = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(10) or 0, value = 0, enabled = isMPCharachter and isMPMale },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPMale },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPMale }
            },
            bodyBlemish = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(11) or 0, value = 0, enabled = isMPCharachter },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter }
            },
            eye = {
                colors = { min = 0, max = isMPCharachter and 32 or 0, value = 0, enabled = isMPCharachter }
            },
            head = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 0), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 0, 0), value = 0, enabled = true }
            },
            masks = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 1), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 1, 0), value = 0, enabled = true }
            },
            hairStyles = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 2), value = 0, enabled = not isMPCharachter },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 2, 0), value = 0, enabled = not isMPCharachter }
            },
            torsos = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 3), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 3, 0), value = 0, enabled = true }
            },
            legs = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 4), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 4, 0), value = 0, enabled = true }
            },
            bags = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 5), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 5, 0), value = 0, enabled = true }
            },
            shoes = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 6), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 6, 0), value = 0, enabled = true }
            },
            accessories = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 7), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 7, 0), value = 0, enabled = true }
            },
            undershirts = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 8), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 8, 0), value = 0, enabled = true }
            },
            bodyArmors = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 9), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 9, 0), value = 0, enabled = true }
            },
            decals = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 10), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 10, 0), value = 0, enabled = true }
            },
            tops = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 11), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 11, 0), value = 0, enabled = true }
            },
            helmets = {
                styles = { min = 0, max = GetNumberOfPedPropDrawableVariations(handle, 0), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 0, 0), value = 0, enabled = true }
            },
            glasses = {
                styles = { min = 0, max = GetNumberOfPedPropDrawableVariations(handle, 1), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 1, 0), value = 0, enabled = true }
            },
            props = {
                styles = { min = 0, max = GetNumberOfPedPropDrawableVariations(handle, 2), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 2, 0), value = 0, enabled = true }
            },
            watches = {
                styles = { min = 0, max = GetNumberOfPedPropDrawableVariations(handle, 6), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 6, 0), value = 0, enabled = true }
            },
            bracles = {
                styles = { min = 0, max = GetNumberOfPedPropDrawableVariations(handle, 7), value = 0, enabled = true },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 7, 0), value = 0, enabled = true }
            }
        }
    }

    function skin:changePed(ped)
        self.handle = ensure(ped, PlayerPedId())
        self.mpMale = GetEntityModel(self.handle) == GetHashKey('mp_m_freemode_01')
        self.mpFemale = GetEntityModel(self.handle) == GetHashKey('mp_f_freemode_01')
        self.mpCharachter = self.mpMale or self.mpFemale
        self:refresh()
    end

    function skin:load(values, callback)
        values = ensure(values, {})
        callback = ensure(callback, function() end)

        for key, options in pairs(self.values) do
            key = ensure(key, 'unknown')
            options = ensure(options, {})

            for optionKey, optionValue in pairs(options) do
                optionKey = ensure(optionKey, 'unknown')
                optionValue = ensure(optionValue, {})

                local value = ensure(optionValue.value, 0)

                if (values[key] ~= nil and values[key][optionKey] ~= nil) then
                    value = ensure(values[key][optionKey], value)
                elseif (values[('%s.%s'):format(key, optionKey)] ~= nil) then
                    value = ensure(values[('%s.%s'):format(key, optionKey)], value)
                end

                self.values[key][optionKey].value = value
            end
        end

        self:refresh(callback)
    end

    function skin:export()
        local result = {}

        for key, options in pairs(self.values) do
            key = ensure(key, 'unknown')
            options = ensure(options, {})

            for optionKey, optionValue in pairs(options) do
                optionKey = ensure(optionKey, 'unknown')
                optionValue = ensure(optionValue, {})

                if (result[key] == nil) then result[key] = {} end

                result[key][optionKey] = ensure(optionValue.value, 0)
            end
        end

        return result
    end

    function skin:getValue(option)
        option = ensure(option, {})

        local min = ensure(option.min, 0)
        local max = ensure(option.max, 0)
        local value = ensure(option.value, 0)

        if (min >= value) then return min end
        if (max <= value) then return max end

        return value
    end

    function skin:refresh(callback)
        callback = ensure(callback, function() end)

        local handle = ensure(self.handle, PlayerPedId())
        local isMPMale = ensure(self.mpMale, false)
        local isMPFemale = ensure(self.mpFemale, false)
        local isMPCharachter = isMPMale or isMPFemale
        local maxOverlayColors = GetNumHairColors()

        --- Set max values
        self.values.hair.styles.max = GetNumberOfPedDrawableVariations(handle, 0)
        self.values.hair.colors.max = maxOverlayColors
        self.values.hair.hightlights.max = maxOverlayColors
        self.values.blemish.styles.max = isMPCharachter and GetNumHeadOverlayValues(0) or 0
        self.values.blemish.opacities.max = isMPCharachter and 10 or 0
        self.values.beard.styles.max = isMPCharachter and GetNumHeadOverlayValues(1) or 0
        self.values.beard.opacities.max = isMPCharachter and 10 or 0
        self.values.beard.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.eyebrow.styles.max = isMPCharachter and GetNumHeadOverlayValues(2) or 0
        self.values.eyebrow.opacities.max = isMPCharachter and 10 or 0
        self.values.eyebrow.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.ageing.styles.max = isMPCharachter and GetNumHeadOverlayValues(3) or 0
        self.values.ageing.opacities.max = isMPCharachter and 10 or 0
        self.values.makeup.styles.max = isMPCharachter and GetNumHeadOverlayValues(4) or 0
        self.values.makeup.opacities.max = isMPCharachter and 10 or 0
        self.values.makeup.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.blush.styles.max = isMPCharachter and GetNumHeadOverlayValues(5) or 0
        self.values.blush.opacities.max = isMPCharachter and 10 or 0
        self.values.blush.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.complexion.styles.max = isMPCharachter and GetNumHeadOverlayValues(6) or 0
        self.values.complexion.opacities.max = isMPCharachter and 10 or 0
        self.values.sunDamage.styles.max = isMPCharachter and GetNumHeadOverlayValues(7) or 0
        self.values.sunDamage.opacities.max = isMPCharachter and 10 or 0
        self.values.lipstick.styles.max = isMPCharachter and GetNumHeadOverlayValues(8) or 0
        self.values.lipstick.opacities.max = isMPCharachter and 10 or 0
        self.values.lipstick.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.molesFreckle.styles.max = isMPCharachter and GetNumHeadOverlayValues(9) or 0
        self.values.molesFreckle.opacities.max = isMPCharachter and 10 or 0
        self.values.chestHair.styles.max = isMPCharachter and GetNumHeadOverlayValues(10) or 0
        self.values.chestHair.opacities.max = isMPCharachter and 10 or 0
        self.values.chestHair.colors.max = isMPCharachter and maxOverlayColors or 0
        self.values.bodyBlemish.styles.max = isMPCharachter and GetNumHeadOverlayValues(11) or 0
        self.values.bodyBlemish.opacities.max = isMPCharachter and 10 or 0
        self.values.eye.colors.max = isMPCharachter and 32 or 0
        self.values.head.styles.max = GetNumberOfPedDrawableVariations(handle, 0)
        self.values.head.textures.max = GetNumberOfPedTextureVariations(handle, 0, self:getValue(self.values.head.styles))
        self.values.masks.styles.max = GetNumberOfPedDrawableVariations(handle, 1)
        self.values.masks.textures.max = GetNumberOfPedTextureVariations(handle, 1, self:getValue(self.values.masks.styles))
        self.values.hairStyles.styles.max = GetNumberOfPedDrawableVariations(handle, 2)
        self.values.hairStyles.textures.max = GetNumberOfPedTextureVariations(handle, 2, self:getValue(self.values.hairStyles.styles))
        self.values.torsos.styles.max = GetNumberOfPedDrawableVariations(handle, 3)
        self.values.torsos.textures.max = GetNumberOfPedTextureVariations(handle, 3, self:getValue(self.values.torsos.styles))
        self.values.legs.styles.max = GetNumberOfPedDrawableVariations(handle, 4)
        self.values.legs.textures.max = GetNumberOfPedTextureVariations(handle, 4, self:getValue(self.values.legs.styles))
        self.values.bags.styles.max = GetNumberOfPedDrawableVariations(handle, 5)
        self.values.bags.textures.max = GetNumberOfPedTextureVariations(handle, 5, self:getValue(self.values.bags.styles))
        self.values.shoes.styles.max = GetNumberOfPedDrawableVariations(handle, 6)
        self.values.shoes.textures.max = GetNumberOfPedTextureVariations(handle, 6, self:getValue(self.values.shoes.styles))
        self.values.accessories.styles.max = GetNumberOfPedDrawableVariations(handle, 7)
        self.values.accessories.textures.max = GetNumberOfPedTextureVariations(handle, 7, self:getValue(self.values.accessories.styles))
        self.values.undershirts.styles.max = GetNumberOfPedDrawableVariations(handle, 8)
        self.values.undershirts.textures.max = GetNumberOfPedTextureVariations(handle, 8, self:getValue(self.values.undershirts.styles))
        self.values.bodyArmors.styles.max = GetNumberOfPedDrawableVariations(handle, 9)
        self.values.bodyArmors.textures.max = GetNumberOfPedTextureVariations(handle, 9, self:getValue(self.values.bodyArmors.styles))
        self.values.decals.styles.max = GetNumberOfPedDrawableVariations(handle, 10)
        self.values.decals.textures.max = GetNumberOfPedTextureVariations(handle, 10, self:getValue(self.values.decals.styles))
        self.values.tops.styles.max = GetNumberOfPedDrawableVariations(handle, 11)
        self.values.tops.textures.max = GetNumberOfPedTextureVariations(handle, 11, self:getValue(self.values.tops.styles))
        self.values.helmets.styles.max = GetNumberOfPedPropDrawableVariations(handle, 0)
        self.values.helmets.textures.max = GetNumberOfPedPropTextureVariations(handle, 0, self:getValue(self.values.helmets.styles))
        self.values.glasses.styles.max = GetNumberOfPedPropDrawableVariations(handle, 1)
        self.values.glasses.textures.max = GetNumberOfPedPropTextureVariations(handle, 1, self:getValue(self.values.glasses.styles))
        self.values.props.styles.max = GetNumberOfPedPropDrawableVariations(handle, 2)
        self.values.props.textures.max = GetNumberOfPedPropTextureVariations(handle, 2, self:getValue(self.values.props.styles))
        self.values.watches.styles.max = GetNumberOfPedPropDrawableVariations(handle, 6)
        self.values.watches.textures.max = GetNumberOfPedPropTextureVariations(handle, 6, self:getValue(self.values.watches.styles))
        self.values.bracles.styles.max = GetNumberOfPedPropDrawableVariations(handle, 7)
        self.values.bracles.textures.max = GetNumberOfPedPropTextureVariations(handle, 7, self:getValue(self.values.bracles.styles))
        
        --- Enable or disable options
        self.values.hair.styles.enabled = isMPCharachter
        self.values.hair.colors.enabled = isMPCharachter
        self.values.hair.hightlights.enabled = isMPCharachter
        self.values.blemish.styles.enabled = isMPCharachter
        self.values.blemish.opacities.enabled = isMPCharachter
        self.values.beard.styles.enabled = isMPCharachter and isMPMale
        self.values.beard.opacities.enabled = isMPCharachter and isMPMale
        self.values.beard.colors.enabled = isMPCharachter and isMPMale
        self.values.eyebrow.styles.enabled = isMPCharachter
        self.values.eyebrow.opacities.enabled = isMPCharachter
        self.values.eyebrow.colors.enabled = isMPCharachter
        self.values.ageing.styles.enabled = isMPCharachter
        self.values.ageing.opacities.enabled = isMPCharachter
        self.values.makeup.styles.enabled = isMPCharachter and isMPFemale
        self.values.makeup.opacities.enabled = isMPCharachter and isMPFemale
        self.values.makeup.colors.enabled = isMPCharachter and isMPFemale
        self.values.blush.styles.enabled = isMPCharachter and isMPFemale
        self.values.blush.opacities.enabled = isMPCharachter and isMPFemale
        self.values.blush.colors.enabled = isMPCharachter and isMPFemale
        self.values.complexion.styles.enabled = isMPCharachter
        self.values.complexion.opacities.enabled = isMPCharachter
        self.values.sunDamage.styles.enabled = isMPCharachter
        self.values.sunDamage.opacities.enabled = isMPCharachter
        self.values.lipstick.styles.enabled = isMPCharachter and isMPFemale
        self.values.lipstick.opacities.enabled = isMPCharachter and isMPFemale
        self.values.lipstick.colors.enabled = isMPCharachter and isMPFemale
        self.values.molesFreckle.styles.enabled = isMPCharachter
        self.values.molesFreckle.opacities.enabled = isMPCharachter
        self.values.chestHair.styles.enabled = isMPCharachter and isMPMale
        self.values.chestHair.opacities.enabled = isMPCharachter and isMPMale
        self.values.chestHair.colors.enabled = isMPCharachter and isMPMale
        self.values.bodyBlemish.styles.enabled = isMPCharachter
        self.values.bodyBlemish.opacities.enabled = isMPCharachter
        self.values.eye.colors.enabled = isMPCharachter
        self.values.head.styles.enabled = true
        self.values.head.textures.enabled = true
        self.values.masks.styles.enabled = true
        self.values.masks.textures.enabled = true
        self.values.hairStyles.styles.enabled = not isMPCharachter
        self.values.hairStyles.textures.enabled = not isMPCharachter
        self.values.torsos.styles.enabled = true
        self.values.torsos.textures.enabled = true
        self.values.legs.styles.enabled = true
        self.values.legs.textures.enabled = true
        self.values.bags.styles.enabled = true
        self.values.bags.textures.enabled = true
        self.values.shoes.styles.enabled = true
        self.values.shoes.textures.enabled = true
        self.values.accessories.styles.enabled = true
        self.values.accessories.textures.enabled = true
        self.values.undershirts.styles.enabled = true
        self.values.undershirts.textures.enabled = true
        self.values.bodyArmors.styles.enabled = true
        self.values.bodyArmors.textures.enabled = true
        self.values.decals.styles.enabled = true
        self.values.decals.textures.enabled = true
        self.values.tops.styles.enabled = true
        self.values.tops.textures.enabled = true
        self.values.helmets.styles.enabled = true
        self.values.helmets.textures.enabled = true
        self.values.glasses.styles.enabled = true
        self.values.glasses.textures.enabled = true
        self.values.props.styles.enabled = true
        self.values.props.textures.enabled = true
        self.values.watches.styles.enabled = true
        self.values.watches.textures.enabled = true
        self.values.bracles.styles.enabled = true
        self.values.bracles.textures.enabled = true

        --- Loop in options and set min/max as value if needed
        for key, values in pairs(self.values) do
            key = ensure(key, 'unknown')
            values = ensure(values, {})

            for option, value in pairs(values) do
                option = ensure(option, 'unknown')
                value = ensure(value, {})

                if (value.min >= value.value) then self.values[key][option].value = value.min end
                if (value.max <= value.value) then self.values[key][option].value = value.max end
            end
        end

        if (self.values.hair.styles.enabled) then SetPedComponentVariation(handle, 2, 0, 2) end
        if (self.values.hair.colors.enabled) then SetPedHairColor(handle, self.values.hair.colors.value, self.values.hair.hightlights.value) end
        if (self.values.blemish.styles.enabled) then SetPedHeadOverlay(handle, 0, self.values.blemish.styles.value, round(self.values.blemish.opacities.value / 10, 1)) end
        if (self.values.beard.styles.enabled) then SetPedHeadOverlay(handle, 1, self.values.beard.styles.value, round(self.values.beard.opacities.value / 10, 1)) end
        if (self.values.beard.colors.enabled) then SetPedHeadOverlayColor(handle, 1, 1, self.values.hair.colors.value, self.values.beard.colors.value) end
        if (self.values.eyebrow.styles.enabled) then SetPedHeadOverlay(handle, 2, self.values.eyebrow.styles.value, round(self.values.eyebrow.opacities.value / 10, 1)) end
        if (self.values.eyebrow.colors.enabled) then SetPedHeadOverlayColor(handle, 1, 1, self.values.hair.colors.value, self.values.eyebrow.colors.value) end
        if (self.values.ageing.styles.enabled) then SetPedHeadOverlay(handle, 3, self.values.ageing.styles.value, round(self.values.ageing.opacities.value / 10, 1)) end
        if (self.values.makeup.styles.enabled) then SetPedHeadOverlay(handle, 4, self.values.makeup.styles.value, round(self.values.makeup.opacities.value / 10, 1)) end
        if (self.values.makeup.colors.enabled) then SetPedHeadOverlayColor(handle, 4, 2, self.values.makeup.colors.value, 0) end
        if (self.values.blush.styles.enabled) then SetPedHeadOverlay(handle, 5, self.values.blush.styles.value, round(self.values.blush.opacities.value / 10, 1)) end
        if (self.values.blush.colors.enabled) then SetPedHeadOverlayColor(handle, 5, 2, self.values.blush.colors.value, 0) end
        if (self.values.complexion.styles.enabled) then SetPedHeadOverlay(handle, 6, self.values.complexion.styles.value, round(self.values.complexion.opacities.value / 10, 1)) end
        if (self.values.sunDamage.styles.enabled) then SetPedHeadOverlay(handle, 7, self.values.sunDamage.styles.value, round(self.values.sunDamage.opacities.value / 10, 1)) end
        if (self.values.lipstick.styles.enabled) then SetPedHeadOverlay(handle, 8, self.values.lipstick.styles.value, round(self.values.lipstick.opacities.value / 10, 1)) end
        if (self.values.lipstick.colors.enabled) then SetPedHeadOverlayColor(handle, 8, 1, self.values.lipstick.colors.value, 0) end
        if (self.values.molesFreckle.styles.enabled) then SetPedHeadOverlay(handle, 9, self.values.molesFreckle.styles.value, round(self.values.molesFreckle.opacities.value / 10, 1)) end
        if (self.values.chestHair.styles.enabled) then SetPedHeadOverlay(handle, 10, self.values.chestHair.styles.value, round(self.values.chestHair.opacities.value / 10, 1)) end
        if (self.values.chestHair.colors.enabled) then SetPedHeadOverlayColor(handle, 10, 1, self.values.chestHair.colors.value, 0) end
        if (self.values.bodyBlemish.styles.enabled) then SetPedHeadOverlay(handle, 11, self.values.bodyBlemish.styles.value, round(self.values.bodyBlemish.opacities.value / 10, 1)) end
        if (self.values.eye.colors.enabled) then SetPedEyeColor(handle, self.values.eye.colors.value, 0, 1) end
        if (self.values.head.styles.enabled) then SetPedComponentVariation(handle, 0, self.values.head.styles.value, self.values.head.textures.value, 0) end
        if (self.values.masks.styles.enabled) then SetPedComponentVariation(handle, 1, self.values.masks.styles.value, self.values.masks.textures.value, 0) end
        if (self.values.hairStyles.styles.enabled) then SetPedComponentVariation(handle, 2, self.values.hairStyles.styles.value, self.values.hairStyles.textures.value, 0) end
        if (self.values.torsos.styles.enabled) then SetPedComponentVariation(handle, 3, self.values.torsos.styles.value, self.values.torsos.textures.value, 0) end
        if (self.values.legs.styles.enabled) then SetPedComponentVariation(handle, 4, self.values.legs.styles.value, self.values.legs.textures.value, 0) end
        if (self.values.bags.styles.enabled) then SetPedComponentVariation(handle, 5, self.values.bags.styles.value, self.values.bags.textures.value, 0) end
        if (self.values.shoes.styles.enabled) then SetPedComponentVariation(handle, 6, self.values.shoes.styles.value, self.values.shoes.textures.value, 0) end
        if (self.values.accessories.styles.enabled) then SetPedComponentVariation(handle, 7, self.values.accessories.styles.value, self.values.accessories.textures.value, 0) end
        if (self.values.undershirts.styles.enabled) then SetPedComponentVariation(handle, 8, self.values.undershirts.styles.value, self.values.undershirts.textures.value, 0) end
        if (self.values.bodyArmors.styles.enabled) then SetPedComponentVariation(handle, 9, self.values.bodyArmors.styles.value, self.values.bodyArmors.textures.value, 0) end
        if (self.values.decals.styles.enabled) then SetPedComponentVariation(handle, 10, self.values.decals.styles.value, self.values.decals.textures.value, 0) end
        if (self.values.tops.styles.enabled) then SetPedComponentVariation(handle, 11, self.values.tops.styles.value, self.values.tops.textures.value, 0) end
        if (self.values.helmets.styles.enabled) then SetPedPropIndex(handle, 0, self.values.helmets.styles.value, self.values.helmets.textures.value, true) end
        if (self.values.glasses.styles.enabled) then SetPedPropIndex(handle, 1, self.values.glasses.styles.value, self.values.glasses.textures.value, true) end
        if (self.values.props.styles.enabled) then SetPedPropIndex(handle, 2, self.values.props.styles.value, self.values.props.textures.value, true) end
        if (self.values.watches.styles.enabled) then SetPedPropIndex(handle, 6, self.values.watches.styles.value, self.values.watches.textures.value, true) end
        if (self.values.bracles.styles.enabled) then SetPedPropIndex(handle, 7, self.values.bracles.styles.value, self.values.bracles.textures.value, true) end
    
        callback(handle)
    end

    return skin
end

RegisterEvent('skins:create', function(doneCallback)
    doneCallback = ensure(doneCallback, function() end)

    local cfg = config('general')
    local skinCfg = config('skins')
    local defaultMenuLocation = ensure(cfg.defaultMenuLocation, 'topleft')
    local defaultMenuColor = ensure(cfg.defaultMenuLocation, vector3(255, 0, 0))
    local defaultMenuSize = ensure(cfg.defaultMenuLocation, 'size-125')
    local defaultMenuBanner = ensure(cfg.defaultMenuLocation, 'default')
    local defaultMenuLibrary = ensure(cfg.defaultMenuLocation, 'menuv')
    local defaultModel = ensure(cfg.defaultModel, 'mp_m_freemode_01')
    local allowedModels = ensure(skinCfg.models, {})
    local skin = skins:create(PlayerPedId())
    local skin_model = nil

    if (true == true) then
        local model = 'a_m_y_vindouche_01'
        local modelHash = GetHashKey(model)

        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end

        local pId = PlayerId()

        SetPlayerModel(pId, modelHash)

        local ped = PlayerPedId()

        PlaceObjectOnGroundProperly(ped)

        skin:changePed(ped)
        skin:refresh(function()
            local data_model = ensure(model, defaultModel)
            local data_skin = skin:export()
            local data_name = T('default_skin')

            TriggerRemote('player:skin:add', data_name, data_model, data_skin, true)

            doneCallback()
        end)

        return
    end

    if (skinMenu == nil) then
        skinMenu = MenuV:CreateMenu(
            T('select_model_title'),
            T('select_model_desc'),
            defaultMenuLocation,
            defaultMenuColor.x,
            defaultMenuColor.y,
            defaultMenuColor.z,
            defaultMenuSize,
            defaultMenuBanner,
            defaultMenuLibrary,
            'skin_menu')
    end

    local function setModel(item)
        item = ensure(item, {})

        local newModel = ensure(item.value, defaultModel)

        if (newModel ~= skin_model) then
            local modelHash = GetHashKey(newModel)

            RequestModel(modelHash)

            while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
            end

            local pId = PlayerId()

            SetPlayerModel(pId, modelHash)

            local ped = PlayerPedId()

            PlaceObjectOnGroundProperly(ped)

            skin:changePed(ped)
        end

        skin_model = newModel

        local function changeOption(category, option, value, callback)
            category = ensure(category, 'unknown')
            option = ensure(option, 'unknown')
            value = ensure(value, 0)
            callback = ensure(callback, function() end)

            if (skin.values ~= nil and skin.values[category] ~= nil and skin.values[category][option] ~= nil) then
                skin.values[category][option].value = value
                skin:refresh(callback)
            end
        end
        
        local function reloadOptions()
            skinMenu:ClearItems()

            for category, values in pairs(skin.values) do
                category = ensure(category, 'unknown')
                values = ensure(values, {})

                for option, optionValue in pairs(values) do
                    option = ensure(option, 'unknown')
                    optionValue = ensure(optionValue, {})

                    local label = ('%s.%s'):format(category, option)
                    local enabled = ensure(optionValue.enabled, false)
                    local min = ensure(optionValue.min, 0)
                    local max = ensure(optionValue.max, 0)
                    local value = ensure(optionValue.value, 0)

                    if (enabled and min < max) then
                        skinMenu:AddRange({ label = label, min = min, max = max, value = value, change = function(item)
                            item = ensure(item, {})

                            changeOption(category, option, ensure(item.value, 0), reloadOptions)
                        end })
                    end
                end
            end

            skinMenu:AddButton({ label = T('done'), select = function()
                local data_model = ensure(skin_model, defaultModel)
                local data_skin = skin:export()
                local data_name = T('default_skin')

                TriggerRemote('player:skin:add', data_name, data_model, data_skin, true)

                skinMenu:Close()

                MenuV:CloseAll(function()
                    doneCallback()
                end)
            end})
        end

        reloadOptions()
    end

    skinMenu:On('open', function(m)
        if (skin_model == nil) then
            m:ClearItems()

            for _, model in pairs(allowedModels) do
                m:AddButton({ label = model, value = model, select = setModel })
            end
        else
            setModel(skin_model)
        end
    end)

    print('OPEN SKIN MENU!!!')

    skinMenu:Open()
end)

export('skins', skins)