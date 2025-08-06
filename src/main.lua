local name = "Fractxlware";
local ownerid = "iU2PO9ridX"; 
local version = "1.0";

local HttpService = game:GetService("HttpService")

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

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local WindUiSettings = {
    SelectedTheme = "Dark",
    Themes = Themes
}

for _, themeData in pairs(WindUiSettings.Themes) do
    WindUI:AddTheme(themeData)
end

WindUI:SetTheme(WindUiSettings.SelectedTheme)

local Fractxlware_M = {}
local Elements = {}

function Fractxlware_M.ConstructMain(License)
    local MainWindow = WindUI:CreateWindow({
        Title = "Fractxlware",
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        Author = "Made by LowkeyFract",
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

    Elements.StatsTab = MainWindow:Tab({
        Title = "Stats",
        Icon = "server",
    })

    Elements.SettingsTab = MainWindow:Tab({
        Title = "Settings",
        Icon = "settings",
    })
end

return Fractxlware_M
