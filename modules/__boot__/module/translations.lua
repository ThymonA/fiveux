local data = {}

translations = {}

function translations:load(category, module)
    category = ensure(category, 'unknown')
    module = ensure(module, 'unknown')

    if (category == 'unknown' or module == 'unknown') then return {} end

    local lang, fLang = self:getPrimaryLanguage(), self:getFallbackLanguage()
    local langKey, fLangKey = ('translations:%s:%s'):format(lang, module), ('translations:%s:%s'):format(fLang, module)
    local langPath = ('modules/%s/%s/translations/%s.json'):format(category, module, lang)
    local fLangPath = ('modules/%s/%s/translations/%s.json'):format(category, module, fLang)
    local langList, fLangList, finalList = {}, {}, {}

    debug:info('translations', ("Loading translations(~x~%s~s~/~x~%s~s~) for module '~x~%s~s~'"):format(lang, fLang, module))

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

    finalList = ensure(fLangList, {})

    for k, v in pairs(langList) do
        finalList[k] = v
    end

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