local name = "Fractxlware";
local ownerid = "iU2PO9ridX"; 
local version = "1.0";

local MarketPlaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local placeInfo = MarketPlaceService:GetProductInfo(game.PlaceId)
local universeName = placeInfo.Name

local function loadFileFromGitHub(path)
    local url = ("https://raw.githubusercontent.com/LowkeyFract/Fractxlware/main/%s.lua"):format(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    else
        warn("Failed to load module from:", url)
        warn("Error:", result)
        return nil
    end
end

local Themes = loadFileFromGitHub("src/config/themes")
local KeyAPI = loadFileFromGitHub("src/modules/KeyAPI")
local scripthub = loadFileFromGitHub("src/config/scripthub")

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
local stats = KeyAPI.FetchStats(name, ownerid, sessionid)
local statsdata = stats or {}

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local WindUiSettings = {
    SelectedTheme = "Dark",
    Themes = Themes
}

for _, themeData in pairs(WindUiSettings.Themes) do
    WindUI:AddTheme(themeData)
end

local Fractxlware_M = {}
local Elements = {}

function Fractxlware_M.ConstructMain(License)
    if Initialized then
    local MainWindow = WindUI:CreateWindow({
        Title = "Fractxlware",
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        Author = universeName,
        Folder = "Fractxlware",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = WindUiSettings.SelectedTheme,
        User = {
            Enabled = true,
            Callback = function() print("clicked") end,
            Anonymous = true
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
        Anonymous = true,
    })

    MainWindow:DisableTopbarButtons({
    "Minimize",
    "Fullscreen",
    })

    Elements.InformationTab = MainWindow:Tab({
        Title = "Information",
        Icon = "info",
    })

    Elements.ChatTab = MainWindow:Tab({
        Title = "Chat Bypasser",
        Icon = "message-circle-warning",
    })

    Elements.PlayerTab = MainWindow:Tab({
        Title = "Player",
        Icon = "user-round-cog",
    })

    Elements.ScriptHubTab = MainWindow:Tab({
        Title = "Script Hub",
        Icon = "github",
    })

    for key, template in pairs(scripthub) do
        Elements.ScriptHubTab:Button({
            Title = template.Name,
            Icon = template.Icon,
            IconThemed = template.IconThemed,
            Callback = function()
                if template.loadstring and template.loadstring ~= "" then
                    local success, err = pcall(loadstring(template.loadstring))
                    if success then
                        WindUI:Notify({
                            Title = "Script Loaded",
                            Icon = "check",
                            Content = "Successfully executed " .. template.Name
                        })
                    else
                        WindUI:Notify({
                            Title = "Error",
                            Icon = "bug",
                            Content = "Failed to load script: " .. err
                        })
                    end
                else
                    WindUI:Notify({
                        Title = "Error",
                        Icon = "bug",
                        Content = "No script available, please contact the developer."
                    })
                end
            end
        })
    end

    Elements.SettingsTab = MainWindow:Tab({
        Title = "Settings",
        Icon = "settings",
    })

    Elements.ThemeSelection = Elements.SettingsTab:Dropdown({
        Title = "Select Theme",
        Values = (function() local t = {}; for k, _ in pairs(WindUiSettings.Themes) do table.insert(t, k) end; return t end)(),
        Value = WindUiSettings.SelectedTheme,
        Callback = function(option)
            WindUiSettings.SelectedTheme = option
            WindUI:SetTheme(option)
        end
    })
    end
end

--Fractxlware_M.ConstructMain()

return Fractxlware_M
