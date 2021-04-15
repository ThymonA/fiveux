---@class streaming
streaming = {}

--- Request a model based on given hash
---@param hash any|number Hash or model name
---@return boolean Has model been loaded
function streaming:requestModel(hash)
    local model = ensureHash(hash)

    if (not IsModelInCdimage(model)) then
        return false
    end

    if (not HasModelLoaded(model)) then
        RequestModel(model)

        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
    end

    return true
end

--- Export streaming
export('streaming', streaming)