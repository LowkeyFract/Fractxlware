local HttpService = game:GetService("HttpService")

local KeyAPI = {}

function KeyAPI.Init(name, ownerid, version)
    local url = string.format(
        "https://keyauth.win/api/1.1/?name=%s&ownerid=%s&type=init&ver=%s",
        name, ownerid, version
    )

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("[KeyAuthError]: Request failed -", response)
        return nil
    end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not ok then
        warn("[KeyAuthError]: Failed to decode JSON -", data)
        return nil
    end

    return data
end

function KeyAPI.LicenseCheck(name, ownerid, version, sessionid, license)
    local url = string.format(
        "https://keyauth.win/api/1.1/?name=%s&ownerid=%s&type=license&key=%s&ver=%s&sessionid=%s",
        name, ownerid, license, version, sessionid
    )

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("[KeyAuthError]: License request failed -", response)
        return nil
    end

    local ok, licensedata = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not ok then
        warn("[KeyAuthError]: Failed to decode license JSON -", licensedata)
        return nil
    end

    return licensedata
end

return KeyAPI
