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
        warn("Failed to load module from:", url)
        warn("Error:", result)
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



    Elements.ScriptHub = MainWindow:Tab({
        Title = "Script Hub",
        Icon = "github"
    })

    Elements.Da_Hood_Lock = Elements.ScriptHub:Button({
        Title = "Best Dahood Menu",
        Callback = function ()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yuvic123/SKIDO-V3/refs/heads/main/%40Siom4i_"))()
        end
    })

    Elements.StatsTab = MainWindow:Tab({
        Title = "Stats",
        Icon = "server",
    })

    Elements.FractxlwareStats = Elements.StatsTab:Section({
        Title = "Realtime Fractxlware Information",
        TextXAlignment = "Center"
    })

    Elements.StatssActiveUsers = Elements.StatsTab:Paragraph({
        Title = string.format("Active Users: %s", stats.appinfo and stats.appinfo.numOnlineUsers or "0")
    })

    Elements.StatsUsers = Elements.StatsTab:Paragraph({
        Title = string.format("Users: %s", stats.appinfo and stats.appinfo.numUsers or "0")
    })
    
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

return Fractxlware_M
