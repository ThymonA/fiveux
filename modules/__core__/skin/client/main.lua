import 'menus'

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
            parents = {
                father = { min = 0, max = 46, value = 0, enabled = isMPCharachter, visible = false },
                mother = { min = 0, max = 46, value = 0, enabled = isMPCharachter, visible = false },
                headMix = { min = 0, max = 10, value = 5, enabled = isMPCharachter, visible = false },
                bodyMix = { min = 0, max = 10, value = 5, enabled = isMPCharachter, visible = false }
            },
            faceShape = {
                noseWidth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                nosePeakHeight = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                nosePeakLength = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                nosePeakLowering = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                noseBoneHeight = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                noseBoneTwist = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                eyebrownHeight = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                eyebrwonDepth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                eyeOpening = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                cheeckboneHeight = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                cheeckboneWidth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                lipThickness = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                jawBoneWidth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                jawBoneDepth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                chinHeight = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                chinDepth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                chinWidth = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                chinHoleSize = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false },
                neckThickness = { min = -10, max = 10, value = 0, enabled = isMPCharachter, visible = false }
            },
            hair = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 2), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 2, 0), value = 0, enabled = true, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter, visible = false },
                highlights = { min = 0; max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            blemish = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(0) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            beard = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(1) or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false },
                highlights = { min = 0; max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false }
            },
            eyebrow = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(2) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            ageing = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(3) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            makeup = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(4) or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false }
            },
            blush = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(5) or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false }
            },
            complexion = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(6) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            sunDamage = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(7) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            lipstick = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(8) or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPFemale, visible = false }
            },
            molesFreckle = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(9) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            chestHair = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(10) or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false },
                colors = { min = 0, max = isMPCharachter and maxOverlayColors or 0, value = 0, enabled = isMPCharachter and isMPMale, visible = false }
            },
            bodyBlemish = {
                styles = { min = 0, max = isMPCharachter and GetNumHeadOverlayValues(11) or 0, value = 0, enabled = isMPCharachter, visible = false },
                opacities = { min = 0, max = isMPCharachter and 10 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            eye = {
                colors = { min = 0, max = isMPCharachter and 32 or 0, value = 0, enabled = isMPCharachter, visible = false }
            },
            head = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 0), value = 0, enabled = not isMPCharachter, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 0, 0), value = 0, enabled = not isMPCharachter, visible = false }
            },
            masks = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 1), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 1, 0), value = 0, enabled = true, visible = false }
            },
            torsos = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 3), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 3, 0), value = 0, enabled = true, visible = false }
            },
            legs = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 4), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 4, 0), value = 0, enabled = true, visible = false }
            },
            bags = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 5), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 5, 0), value = 0, enabled = true, visible = false }
            },
            shoes = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 6), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 6, 0), value = 0, enabled = true, visible = false }
            },
            accessories = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 7), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 7, 0), value = 0, enabled = true, visible = false }
            },
            undershirts = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 8), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 8, 0), value = 0, enabled = true, visible = false }
            },
            bodyArmors = {
                styles = { min = -1, max = GetNumberOfPedDrawableVariations(handle, 9), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 9, 0), value = 0, enabled = true, visible = false }
            },
            decals = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 10), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 10, 0), value = 0, enabled = true, visible = false }
            },
            tops = {
                styles = { min = 0, max = GetNumberOfPedDrawableVariations(handle, 11), value = 0, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedTextureVariations(handle, 11, 0), value = 0, enabled = true, visible = false }
            },
            helmets = {
                styles = { min = -1, max = GetNumberOfPedPropDrawableVariations(handle, 0), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 0, 0), value = 0, enabled = true, visible = false }
            },
            glasses = {
                styles = { min = -1, max = GetNumberOfPedPropDrawableVariations(handle, 1), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 1, 0), value = 0, enabled = true, visible = false }
            },
            props = {
                styles = { min = -1, max = GetNumberOfPedPropDrawableVariations(handle, 2), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 2, 0), value = 0, enabled = true, visible = false }
            },
            watches = {
                styles = { min = -1, max = GetNumberOfPedPropDrawableVariations(handle, 6), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 6, 0), value = 0, enabled = true, visible = false }
            },
            bracles = {
                styles = { min = -1, max = GetNumberOfPedPropDrawableVariations(handle, 7), value = -1, enabled = true, visible = false },
                textures = { min = 0, max = GetNumberOfPedPropTextureVariations(handle, 7, 0), value = 0, enabled = true, visible = false }
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

        if (min >= value) then option.value = min end
        if (max <= value) then option.value = max end
        
        option.visible = max > 0

        return option.value
    end

    function skin:refresh(callback)
        callback = ensure(callback, function() end)

        local handle = ensure(self.handle, PlayerPedId())
        local isMPMale = ensure(self.mpMale, false)
        local isMPFemale = ensure(self.mpFemale, false)
        local isMPCharachter = isMPMale or isMPFemale
        local maxOverlayColors = GetNumHairColors()

        --- Set min values
        self.values.parents.father.min = 0
        self.values.parents.mother.min = 0
        self.values.parents.headMix.min = 0
        self.values.parents.bodyMix.min = 0
        self.values.faceShape.noseWidth.min = -10
        self.values.faceShape.nosePeakHeight.min = -10
        self.values.faceShape.nosePeakLength.min = -10
        self.values.faceShape.nosePeakLowering.min = -10
        self.values.faceShape.noseBoneHeight.min = -10
        self.values.faceShape.noseBoneTwist.min = -10
        self.values.faceShape.eyebrownHeight.min = -10
        self.values.faceShape.eyebrwonDepth.min = -10
        self.values.faceShape.eyeOpening.min = -10
        self.values.faceShape.cheeckboneHeight.min = -10
        self.values.faceShape.cheeckboneWidth.min = -10
        self.values.faceShape.lipThickness.min = -10
        self.values.faceShape.jawBoneWidth.min = -10
        self.values.faceShape.jawBoneDepth.min = -10
        self.values.faceShape.chinHeight.min = -10
        self.values.faceShape.chinDepth.min = -10
        self.values.faceShape.chinWidth.min = -10
        self.values.faceShape.chinHoleSize.min = -10
        self.values.faceShape.neckThickness.min = -10
        self.values.hair.styles.min = 0
        self.values.hair.textures.min = 0
        self.values.hair.colors.min = 0
        self.values.hair.highlights.min = 0
        self.values.blemish.styles.min = 0
        self.values.blemish.opacities.min = 0
        self.values.beard.styles.min = 0
        self.values.beard.opacities.min = 0
        self.values.beard.colors.min = 0
        self.values.beard.highlights.min = 0
        self.values.eyebrow.styles.min = 0
        self.values.eyebrow.opacities.min = 0
        self.values.eyebrow.colors.min = 0
        self.values.ageing.styles.min = 0
        self.values.ageing.opacities.min = 0
        self.values.makeup.styles.min = 0
        self.values.makeup.opacities.min = 0
        self.values.makeup.colors.min = 0
        self.values.blush.styles.min = 0
        self.values.blush.opacities.min = 0
        self.values.blush.colors.min = 0
        self.values.complexion.styles.min = 0
        self.values.complexion.opacities.min = 0
        self.values.sunDamage.styles.min = 0
        self.values.sunDamage.opacities.min = 0
        self.values.lipstick.styles.min = 0
        self.values.lipstick.opacities.min = 0
        self.values.lipstick.colors.min = 0
        self.values.molesFreckle.styles.min = 0
        self.values.molesFreckle.opacities.min = 0
        self.values.chestHair.styles.min = 0
        self.values.chestHair.opacities.min = 0
        self.values.chestHair.colors.min = 0
        self.values.bodyBlemish.styles.min = 0
        self.values.bodyBlemish.opacities.min = 0
        self.values.eye.colors.min = 0
        self.values.head.styles.min = 0
        self.values.head.textures.min = 0
        self.values.masks.styles.min = 0
        self.values.masks.textures.min = 0
        self.values.torsos.styles.min = 0
        self.values.torsos.textures.min = 0
        self.values.legs.styles.min = 0
        self.values.legs.textures.min = 0
        self.values.bags.styles.min = 0
        self.values.bags.textures.min = 0
        self.values.shoes.styles.min = 0
        self.values.shoes.textures.min = 0
        self.values.accessories.styles.min = 0
        self.values.accessories.textures.min = 0
        self.values.undershirts.styles.min = 0
        self.values.undershirts.textures.min = 0
        self.values.bodyArmors.styles.min = 0
        self.values.bodyArmors.textures.min = 0
        self.values.decals.styles.min = 0
        self.values.decals.textures.min = 0
        self.values.tops.styles.min = 0
        self.values.tops.textures.min = 0
        self.values.helmets.styles.min = -1
        self.values.helmets.textures.min = 0
        self.values.glasses.styles.min = -1
        self.values.glasses.textures.min = 0
        self.values.props.styles.min = -1
        self.values.props.textures.min = 0
        self.values.watches.styles.min = -1
        self.values.watches.textures.min = 0
        self.values.bracles.styles.min = -1
        self.values.bracles.textures.min = 0

        --- Set max values
        self.values.parents.father.max = 46
        self.values.parents.mother.max = 46
        self.values.parents.headMix.max = 10
        self.values.parents.bodyMix.max = 10
        self.values.faceShape.noseWidth.max = 10
        self.values.faceShape.nosePeakHeight.max = 10
        self.values.faceShape.nosePeakLength.max = 10
        self.values.faceShape.nosePeakLowering.max = 10
        self.values.faceShape.noseBoneHeight.max = 10
        self.values.faceShape.noseBoneTwist.max = 10
        self.values.faceShape.eyebrownHeight.max = 10
        self.values.faceShape.eyebrwonDepth.max = 10
        self.values.faceShape.eyeOpening.max = 10
        self.values.faceShape.cheeckboneHeight.max = 10
        self.values.faceShape.cheeckboneWidth.max = 10
        self.values.faceShape.lipThickness.max = 10
        self.values.faceShape.jawBoneWidth.max = 10
        self.values.faceShape.jawBoneDepth.max = 10
        self.values.faceShape.chinHeight.max = 10
        self.values.faceShape.chinDepth.max = 10
        self.values.faceShape.chinWidth.max = 10
        self.values.faceShape.chinHoleSize.max = 10
        self.values.faceShape.neckThickness.max = 10
        self.values.hair.styles.max = GetNumberOfPedDrawableVariations(handle, 2)
        self.values.hair.colors.max = maxOverlayColors
        self.values.hair.highlights.max = maxOverlayColors
        self.values.blemish.styles.max = isMPCharachter and GetNumHeadOverlayValues(0) or 0
        self.values.blemish.opacities.max = isMPCharachter and 10 or 0
        self.values.beard.styles.max = isMPCharachter and isMPMale and GetNumHeadOverlayValues(1) or 0
        self.values.beard.opacities.max = isMPCharachter and isMPMale and 10 or 0
        self.values.beard.colors.max = isMPCharachter and isMPMale and maxOverlayColors or 0
        self.values.beard.highlights.max = isMPCharachter and isMPMale and 10 or 0
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
        self.values.masks.styles.max = GetNumberOfPedDrawableVariations(handle, 1)
        self.values.torsos.styles.max = GetNumberOfPedDrawableVariations(handle, 3)
        self.values.legs.styles.max = GetNumberOfPedDrawableVariations(handle, 4)
        self.values.bags.styles.max = GetNumberOfPedDrawableVariations(handle, 5)
        self.values.shoes.styles.max = GetNumberOfPedDrawableVariations(handle, 6)
        self.values.accessories.styles.max = GetNumberOfPedDrawableVariations(handle, 7)
        self.values.undershirts.styles.max = GetNumberOfPedDrawableVariations(handle, 8)
        self.values.bodyArmors.styles.max = GetNumberOfPedDrawableVariations(handle, 9)
        self.values.decals.styles.max = GetNumberOfPedDrawableVariations(handle, 10)
        self.values.tops.styles.max = GetNumberOfPedDrawableVariations(handle, 11)
        self.values.helmets.styles.max = GetNumberOfPedPropDrawableVariations(handle, 0)
        self.values.glasses.styles.max = GetNumberOfPedPropDrawableVariations(handle, 1)
        self.values.props.styles.max = GetNumberOfPedPropDrawableVariations(handle, 2)
        self.values.watches.styles.max = GetNumberOfPedPropDrawableVariations(handle, 6)
        self.values.bracles.styles.max = GetNumberOfPedPropDrawableVariations(handle, 7)

        --- Set max value textures
        self.values.hair.textures.max = GetNumberOfPedTextureVariations(handle, 2, self:getValue(self.values.hair.styles))
        self.values.head.textures.max = GetNumberOfPedTextureVariations(handle, 0, self:getValue(self.values.head.styles))
        self.values.masks.textures.max = GetNumberOfPedTextureVariations(handle, 1, self:getValue(self.values.masks.styles))
        self.values.torsos.textures.max = GetNumberOfPedTextureVariations(handle, 3, self:getValue(self.values.torsos.styles))
        self.values.legs.textures.max = GetNumberOfPedTextureVariations(handle, 4, self:getValue(self.values.legs.styles))
        self.values.bags.textures.max = GetNumberOfPedTextureVariations(handle, 5, self:getValue(self.values.bags.styles))
        self.values.shoes.textures.max = GetNumberOfPedTextureVariations(handle, 6, self:getValue(self.values.shoes.styles))
        self.values.accessories.textures.max = GetNumberOfPedTextureVariations(handle, 7, self:getValue(self.values.accessories.styles))
        self.values.undershirts.textures.max = GetNumberOfPedTextureVariations(handle, 8, self:getValue(self.values.undershirts.styles))
        self.values.bodyArmors.textures.max = GetNumberOfPedTextureVariations(handle, 9, self:getValue(self.values.bodyArmors.styles))
        self.values.decals.textures.max = GetNumberOfPedTextureVariations(handle, 10, self:getValue(self.values.decals.styles))
        self.values.tops.textures.max = GetNumberOfPedTextureVariations(handle, 11, self:getValue(self.values.tops.styles))
        self.values.helmets.textures.max = GetNumberOfPedPropTextureVariations(handle, 0, self:getValue(self.values.helmets.styles))
        self.values.glasses.textures.max = GetNumberOfPedPropTextureVariations(handle, 1, self:getValue(self.values.glasses.styles))
        self.values.props.textures.max = GetNumberOfPedPropTextureVariations(handle, 2, self:getValue(self.values.props.styles))
        self.values.watches.textures.max = GetNumberOfPedPropTextureVariations(handle, 6, self:getValue(self.values.watches.styles))
        self.values.bracles.textures.max = GetNumberOfPedPropTextureVariations(handle, 7, self:getValue(self.values.bracles.styles))
        
        --- Enable or disable options
        self.values.parents.father.enabled = isMPCharachter
        self.values.parents.mother.enabled = isMPCharachter
        self.values.parents.headMix.enabled = isMPCharachter
        self.values.parents.bodyMix.enabled = isMPCharachter
        self.values.faceShape.noseWidth.enabled = isMPCharachter
        self.values.faceShape.nosePeakHeight.enabled = isMPCharachter
        self.values.faceShape.nosePeakLength.enabled = isMPCharachter
        self.values.faceShape.nosePeakLowering.enabled = isMPCharachter
        self.values.faceShape.noseBoneHeight.enabled = isMPCharachter
        self.values.faceShape.noseBoneTwist.enabled = isMPCharachter
        self.values.faceShape.eyebrownHeight.enabled = isMPCharachter
        self.values.faceShape.eyebrwonDepth.enabled = isMPCharachter
        self.values.faceShape.eyeOpening.enabled = isMPCharachter
        self.values.faceShape.cheeckboneHeight.enabled = isMPCharachter
        self.values.faceShape.cheeckboneWidth.enabled = isMPCharachter
        self.values.faceShape.lipThickness.enabled = isMPCharachter
        self.values.faceShape.jawBoneWidth.enabled = isMPCharachter
        self.values.faceShape.jawBoneDepth.enabled = isMPCharachter
        self.values.faceShape.chinHeight.enabled = isMPCharachter
        self.values.faceShape.chinDepth.enabled = isMPCharachter
        self.values.faceShape.chinWidth.enabled = isMPCharachter
        self.values.faceShape.chinHoleSize.enabled = isMPCharachter
        self.values.faceShape.neckThickness.enabled = isMPCharachter
        self.values.hair.styles.enabled = true
        self.values.hair.textures.enabled = true
        self.values.hair.colors.enabled = isMPCharachter
        self.values.hair.highlights.enabled = isMPCharachter
        self.values.blemish.styles.enabled = isMPCharachter
        self.values.blemish.opacities.enabled = isMPCharachter
        self.values.beard.styles.enabled = isMPCharachter and isMPMale
        self.values.beard.opacities.enabled = isMPCharachter and isMPMale
        self.values.beard.colors.enabled = isMPCharachter and isMPMale
        self.values.beard.highlights.enabled = isMPCharachter and isMPMale
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
        self.values.head.styles.enabled = not isMPCharachter
        self.values.head.textures.enabled = not isMPCharachter
        self.values.masks.styles.enabled = true
        self.values.masks.textures.enabled = true
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
                
                self.values[key][option].visible = value.max > 0
            end
        end

        if (self.values.parents.father.enabled) then SetPedHeadBlendData(handle, self.values.parents.mother.value, self.values.parents.father.value, 0, self.values.parents.mother.value, self.values.parents.father.value, 0, round(self.values.parents.headMix.value / 10, 1), round(self.values.parents.bodyMix.value / 10, 1), 0, false) end
        if (self.values.hair.styles.enabled) then SetPedComponentVariation(handle, 2, self.values.hair.styles.value, self.values.hair.textures.value, 2) end
        if (self.values.hair.colors.enabled) then SetPedHairColor(handle, self.values.hair.colors.value, self.values.hair.highlights.value) end
        if (self.values.blemish.styles.enabled) then SetPedHeadOverlay(handle, 0, self.values.blemish.styles.value, round(self.values.blemish.opacities.value / 10, 1)) end
        if (self.values.beard.styles.enabled) then SetPedHeadOverlay(handle, 1, self.values.beard.styles.value, round(self.values.beard.opacities.value / 10, 1)) end
        if (self.values.beard.colors.enabled) then SetPedHeadOverlayColor(handle, 1, 1, self.values.hair.colors.value, self.values.beard.highlights.value) end
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
        if (self.values.torsos.styles.enabled) then SetPedComponentVariation(handle, 3, self.values.torsos.styles.value, self.values.torsos.textures.value, 0) end
        if (self.values.legs.styles.enabled) then SetPedComponentVariation(handle, 4, self.values.legs.styles.value, self.values.legs.textures.value, 0) end
        if (self.values.bags.styles.enabled) then SetPedComponentVariation(handle, 5, self.values.bags.styles.value, self.values.bags.textures.value, 0) end
        if (self.values.shoes.styles.enabled) then SetPedComponentVariation(handle, 6, self.values.shoes.styles.value, self.values.shoes.textures.value, 0) end
        if (self.values.accessories.styles.enabled) then SetPedComponentVariation(handle, 7, self.values.accessories.styles.value, self.values.accessories.textures.value, 0) end
        if (self.values.undershirts.styles.enabled) then SetPedComponentVariation(handle, 8, self.values.undershirts.styles.value, self.values.undershirts.textures.value, 0) end
        if (self.values.bodyArmors.styles.enabled) then SetPedComponentVariation(handle, 9, self.values.bodyArmors.styles.value, self.values.bodyArmors.textures.value, 0) end
        if (self.values.decals.styles.enabled) then SetPedComponentVariation(handle, 10, self.values.decals.styles.value, self.values.decals.textures.value, 0) end
        if (self.values.tops.styles.enabled) then SetPedComponentVariation(handle, 11, self.values.tops.styles.value, self.values.tops.textures.value, 0) end
        if (self.values.helmets.styles.enabled and self.values.helmets.styles.value <= -1) then ClearPedProp(handle, 0) end
        if (self.values.helmets.styles.enabled and self.values.helmets.styles.value >= 0) then SetPedPropIndex(handle, 0, self.values.helmets.styles.value, self.values.helmets.textures.value, true) end
        if (self.values.glasses.styles.enabled and self.values.glasses.styles.value <= -1) then ClearPedProp(handle, 1) end
        if (self.values.glasses.styles.enabled and self.values.glasses.styles.value >= 0) then SetPedPropIndex(handle, 1, self.values.glasses.styles.value, self.values.glasses.textures.value, true) end
        if (self.values.props.styles.enabled and self.values.props.styles.value <= -1) then ClearPedProp(handle, 2) end
        if (self.values.props.styles.enabled and self.values.props.styles.value >= 0) then SetPedPropIndex(handle, 2, self.values.props.styles.value, self.values.props.textures.value, true) end
        if (self.values.watches.styles.enabled and self.values.watches.styles.value <= -1) then ClearPedProp(handle, 6) end
        if (self.values.watches.styles.enabled and self.values.watches.styles.value >= 0) then SetPedPropIndex(handle, 6, self.values.watches.styles.value, self.values.watches.textures.value, true) end
        if (self.values.bracles.styles.enabled and self.values.bracles.styles.value <= -1) then ClearPedProp(handle, 7) end
        if (self.values.bracles.styles.enabled and self.values.bracles.styles.value >= 0) then SetPedPropIndex(handle, 7, self.values.bracles.styles.value, self.values.bracles.textures.value, true) end
    
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
    local defaultModel = ensure(cfg.defaultModel, 'mp_m_freemode_01')
    local allowedModels = ensure(skinCfg.models, {})
    local skin = skins:create(PlayerPedId())
    local skin_model = nil
    local skin_done = false

    if (skinMenu == nil) then
        skinMenu = menus:create({
            title = T('select_model_title'),
            subtitle = T('select_model_desc'),
            position = defaultMenuLocation,
            red = defaultMenuColor.x,
            green = defaultMenuColor.y,
            blue = defaultMenuColor.z
        })
    end

    local function setModel(item)
        item = ensure(item, {})

        local params = ensure(item.params, {})
        local newModel = ensure(params[1], defaultModel)

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

        local function changeOption(value, item, menu, type, category, option)
            type = ensure(type, 'unknown')
            category = ensure(category, 'unknown')
            option = ensure(option, 'unknown')
            value = ensure(value, 0)
            
            if (type ~= 'option') then return end

            if (skin.values ~= nil and skin.values[category] ~= nil and skin.values[category][option] ~= nil) then
                skin.values[category][option].value = value
                skin:refresh()
            end
        end
        
        local function reloadOptions()
            skinMenu:clearAllItems(false)
            skinMenu:setEvent('change', changeOption)

            for category, values in pairs(skin.values) do
                category = ensure(category, 'unknown')
                values = ensure(values, {})

                for option, optionValue in pairs(values) do
                    option = ensure(option, 'unknown')
                    optionValue = ensure(optionValue, {})

                    local label = ('%s.%s'):format(category, option)
                    local enabled = ensure(optionValue.enabled, false)
                    local visible = ensure(optionValue.visible, false)
                    local min = ensure(optionValue.min, 0)
                    local max = ensure(optionValue.max, 0)
                    local value = ensure(optionValue.value, 0)

                    if (enabled and visible) then
                        skinMenu:addItem({ type = 'range', label = label, min = min, max = max, value = value, params = { 'option', category, option } }, false)
                    end
                end
            end

            skinMenu:setEvent('select', function(item, menu, type)
                type = ensure(type, 'unknown')

                if (type ~= 'save') then return end

                local data_model = ensure(skin_model, defaultModel)
                local data_skin = skin:export()
                local data_name = T('default_skin')

                TriggerRemote('player:skin:add', data_name, data_model, data_skin, true)

                skinMenu:close()
                skin_done = true

                doneCallback(skin.handle)
            end)

            skinMenu:addItem({ label = T('done'), params = { 'save' } }, true)
        end

        reloadOptions()
    end

    skinMenu:setEvent('open', function(m)
        if (skin_model == nil) then
            m:clearAllItems(false)
            m:setEvent('select', setModel)
            m:setEvent('change', function(...) end)

            for _, model in pairs(allowedModels) do
                m:addItem({ label = model, value = model, params = { model } }, false)
            end

            m:reload()
        else
            setModel(skin_model)
        end
    end)

    skinMenu:setEvent('close', function(m)
        if (not skin_done) then
            skin_model = nil
            m:open()
        end
    end)

    skinMenu:open()
end)

export('skins', skins)