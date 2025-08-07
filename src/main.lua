local name = "Fractxlware";
local ownerid = "iU2PO9ridX"; 
local version = "1.0";

local MarketPlaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")

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

    Elements.ChatTabInput = Elements.ChatTab:Input({
        Title = "Bypass Input",
        Desc = "Input your message here to bypass the Roblox chat filter.",
        Placeholder = "Type your message...",
        Value = "",
        Type = "Input",
        Callback = function(input)
            local textChatService = game:GetService("TextChatService")
            local textChannels = textChatService:WaitForChild("TextChannels")
            local generalChannel = textChannels:FindFirstChild("RBXGeneral") or textChannels:FindFirstChild("General") or textChannels:GetChildren()[1]

            if not generalChannel then
                warn("No valid TextChannel found")
                return
            end

            local function maxBypass(msg)
                local replacements = {
                    ["a"] = {"а", "ɑ", "ᴀ"},
                    ["b"] = {"Ь", "Ꮟ"},
                    ["c"] = {"ϲ", "ᴄ"},
                    ["e"] = {"е", "ҽ", "ɛ"},
                    ["g"] = {"ɡ", "ɢ"},
                    ["h"] = {"һ", "н", "ḥ"},
                    ["i"] = {"і", "ɩ", "ɪ"},
                    ["l"] = {"ⅼ", "ӏ"},
                    ["n"] = {"ո", "ռ"},
                    ["o"] = {"о", "૦", "օ"},
                    ["s"] = {"ѕ", "ṡ", "ꜱ"},
                    ["t"] = {"т", "ṭ"},
                    ["u"] = {"υ", "ᴜ", "ʋ"},
                    ["y"] = {"у", "ყ"},
                }

                local zwj = utf8.char(0x200D)
                local zwnj = utf8.char(0x200C)
                local zwsp = utf8.char(0x200B)

                local function randomInsert(str)
                    local result = ""
                    for i = 1, #str do
                        local ch = str:sub(i, i)
                        if replacements[ch:lower()] then
                            local replList = replacements[ch:lower()]
                            local randChar = replList[math.random(1, #replList)]
                            result = result .. randChar
                        else
                            result = result .. ch
                        end


                        if math.random() < 0.5 then
                            local invis = ({zwj, zwnj, zwsp})[math.random(1, 3)]
                            result = result .. invis
                        end
                    end
                    return result
                end

                return randomInsert(msg)
            end


            math.randomseed(tick())

            local filtered = maxBypass(input)
            generalChannel:SendAsync(filtered)
        end
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
