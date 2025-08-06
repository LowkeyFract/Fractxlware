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

function KeyAPI.FetchStats(name, ownerid, sessionid)
    local url = string.format(
        "https://keyauth.win/api/1.3/?type=fetchStats&name=%s&ownerid=%s&sessionid=%s",
        name, ownerid, sessionid
    )

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("[KeyAuthError]: Stats request failed -", response)
        return nil
    end

    local ok, statsdata = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not ok then
        warn("[KeyAuthError]: Failed to decode stats JSON -", statsdata)
        return nil
    end

    return statsdata
end

return KeyAPI
