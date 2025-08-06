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

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Fractxlware_M = {}

function Fractxlware_M:ConstructMain()
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
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })
end

return Fractxlware_M = {}

