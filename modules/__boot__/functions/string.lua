function string:startsWith(word)
    word = ensure(word, 'unknown')

    return self:sub(1, #word) == word
end

function string:endsWith(word)
    word = ensure(word, 'unknown')

    return self:sub(-#word) == word
end

function string:split(delim)
    delim = ensure(delim, 'unknown')

    local t = {}

    for substr in self:gmatch('[^' .. delim .. '^]') do
        substr = ensure(substr, '')

        if (#substr > 0) then
            table.insert(t, substr)
        end
    end

    return t
end