local name = "Fractxlware";
local ownerid = "iU2PO9ridX"; 
local version = "1.0";

local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local function loadFileFromGitHub(path)
    local url = ("https://raw.githubusercontent.com/LowkeyFract/Fractxlware/main/%s.lua"):format(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    else
        warn("Failed to load module:", path, result)
        return nil
    end
end

local Themes = loadFileFromGitHub("src/config/themes")
local KeyAPI = loadFileFromGitHub("src/modules/KeyAPI")
local LoadingScreen = loadFileFromGitHub("src/modules/LoadingScreen")
local Fractxlware_M = loadFileFromGitHub("src/main")
local urls = loadFileFromGitHub("src/config/urls")
local SoundModule = loadFileFromGitHub("src/modules/SoundModule")

local Initialized = false
local sessionid = ""

local data = KeyAPI.Init(name, ownerid, version)

if not data then
    print("[KeyAuthError]: Initialization failed or invalid response")
    return false
end

if data.success == true then
    Initialized = true
    sessionid = data.sessionid
elseif data.message == "invalider" then
    print("[KeyAuthError]: Wrong Application Version")
    return false
else
    print("[KeyAuthError]: " .. data.message)
    return false
end

LoadingScreen:ShowAsync()
SoundModule.Play(82845990304289, 1, SoundService)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local WindUiSettings = {
    SelectedTheme = "Dark",
    Themes = Themes
}

for _, themeData in pairs(WindUiSettings.Themes) do
    WindUI:AddTheme(themeData)
end

WindUI:SetTheme(WindUiSettings.SelectedTheme)

local Elements = {}

local function LicenseWindow_F()
    local License = ""

    local LicenseWindow = WindUI:CreateWindow({
        Title = "Fractxlware Public",
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        Author = "v0.014",
        Folder = "Fractxlware",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = WindUiSettings.SelectedTheme,
        User = {
            Enabled = true,
            Callback = function() print("clicked") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })

    Elements.License = LicenseWindow:Tab({
        Title = "License",
        Icon = "key-round",
        Locked = false
    })

    Elements.LicenseInput = Elements.License:Input({
        Title = "License",
        Desc = "Input your license to gain access to Fractxlware",
        InputIcon = "key-square",
        Type = "Input",
        Placeholder = "Enter License",
        Value = (isfile and isfile("Fractxlware/license.key") and readfile("Fractxlware/license.key")) or "",
        SaveKey = true,
        Callback = function(input)
            License = input
        end
    })

    Elements.CheckLicense = Elements.License:Button({
        Title = "Check License",
        Callback = function()
            local licensedata = KeyAPI.LicenseCheck(name, ownerid, version, sessionid, License)
            if licensedata == nil then
                WindUI:Notify({
                    Title = "KeyAuth",
                    Icon = "info",
                    Content = "Failed to check license. Please try again or make a ticket in our discord."
                })
                return
            end
            if licensedata.success == false then
                WindUI:Notify({
                    Title = "KeyAuth",
                    Icon = "info",
                    Content = licensedata.message,
                })
            elseif licensedata.success == true then
                WindUI:Notify({
                    Title = "KeyAuth",
                    Icon = "info",
                    Content = licensedata.message .. " Loading hub.."
                })
            LicenseWindow:Close():Destroy()
            writefile(LicenseWindow.Folder .. "/" .. "license" .. ".key", tostring(License))
            Fractxlware_M.ConstructMain(License)
            end
        end
    })

    Elements.GetLicense = Elements.License:Button({
        Title = "Get License",
        URL = urls.DiscordUser,
        Callback = function(URL)
            setclipboard(urls.DiscordUser)
            WindUI:Notify({
                Title = "Clipboard",
                Icon = "info",
                Content = "You have successfully copied the link!"
            })
        end
    })
end

if Initialized == true then LicenseWindow_F() end