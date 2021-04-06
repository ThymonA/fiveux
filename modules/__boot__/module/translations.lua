local data = {}
local global, global_loaded = {}, false

translations = {}

function translations:getGlobalTranslations()
    return ensure(global, {})
end

function translations:load(category, module)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')

    if (category == 'unknown' or module == 'unknown') then return {} end

    local pathTemp = 'modules/%s/%s/translations/%s.json'
    local corePathTemp = 'modules/__boot__/translations/%s.json'
    local lang, fLang = self:getPrimaryLanguage(), self:getFallbackLanguage()
    local langKey, fLangKey = ('translations:%s:%s'):format(lang, module), ('translations:%s:%s'):format(fLang, module)
    local coreLangKey, fCoreLangKey = ('translations:%s:core'):format(lang), ('translations:%s:core'):format(fLang)
    local langPath = pathTemp:format(category, module, lang)
    local fLangPath = pathTemp:format(category, module, fLang)
    local coreLangPath = corePathTemp:format(lang)
    local fCoreLangPath = corePathTemp:format(fLang)
    local langList, fLangList, coreLangList, fCoreLangList, finalList = {}, {}, {}, {}, {}

    if (cache:exists(langKey)) then
        langList = ensure(cache:read(langKey), {})
    else
        langList = translations:readJson(langPath)

        cache:write(langKey, langList)
    end

    if (cache:exists(fLangKey)) then
        fLangList = ensure(cache:read(fLangKey), {})
    else
        fLangList = translations:readJson(fLangPath)
        
        cache:write(fLangKey, fLangList)
    end

    if (cache:exists(fCoreLangKey)) then
        fCoreLangList = ensure(cache:read(fCoreLangKey), {})
    else
        fCoreLangList = translations:readJson(fCoreLangPath)
        
        cache:write(fCoreLangKey, fCoreLangList)
    end

    if (cache:exists(coreLangKey)) then
        coreLangList = ensure(cache:read(coreLangKey), {})
    else
        coreLangList = translations:readJson(coreLangPath)
        
        cache:write(coreLangKey, coreLangList)
    end

    if (not global_loaded) then
        for k, v in pairs(fCoreLangList) do global[k] = v end
        for k, v in pairs(coreLangList) do global[k] = v end

        global_loaded = true
    end

    finalList = ensure(fCoreLangList, {})

    for k, v in pairs(coreLangList) do finalList[k] = v end
    for k, v in pairs(fLangList) do finalList[k] = v end
    for k, v in pairs(langList) do finalList[k] = v end

    return finalList
end

function translations:readJson(path)
    path = ensure(path, 'unknown')

    if (path == 'unknown') then return {} end

    local raw = LoadResourceFile(RESOURCE_NAME, path)

    if (raw) then
        local list = {}
        local data = ensure(json.decode(raw), {})

        for k, v in pairs(data) do
            list[ensure(k, 'unknown')] = ensure(v, 'INVALID TRANSLATION')
        end

        return list
    end

    return {}
end

function translations:getPrimaryLanguage()
    local key, language = 'translations:primaryLanguage', 'en'

    if (cache:exists(key)) then
        return ensure(cache:read(key), 'en')
    end

    local cfg = config:load('general')

    language = ensure(cfg.language, 'en')

    cache:write(key, language, true)

    return language
end

function translations:getFallbackLanguage()
    local key, language = 'translations:fallbackLanguage', 'en'

    if (cache:exists(key)) then
        return ensure(cache:read(key), 'en')
    end

    local cfg = config:load('general')

    language = ensure(cfg.fallbackLanguage, 'en')

    cache:write(key, language, true)

    return language
end