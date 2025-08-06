local HttpService = game:GetService("HttpService")
local KeyAPI = require("./src/modules/KeyAPI")
local LuaName = "Fractxlware"

local Initialized = false
local sessionid = ""

local name = "Fractxlware";
local ownerid = "iU2PO9ridX"; 
local version = "1.0";

local req = KeyAPI.Init(name, ownerid, version)
if req == "KeyAuth_Invalid" then
    print("[KeyAuthError]: Wrong Application Details")

    return false
end
local data = HttpService:JSONDecode(req)

if data.success == true then
    Initialized = true
    sessionid = data.sessionid
elseif (data.message == "invalider") then
    print("[KeyAuthError]: Wrong Application Version")

    return false
else
    print("[KeyAuthError]: " .. data.message)
end

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local WindUiSettings = {
    SelectedTheme = "Dark",
    Themes = {
        Dark = {
            Name = "Dark",
            Accent = "#18181b",
            Dialog = "#18181b",
            Outline = "#FFFFFF",
            Text = "#FFFFFF",
            Placeholder = "#999999",
            Background = "#0e0e10",
            Button = "#52525b",
            Icon = "#a1a1aa",
        },
        Light = {
            Name = "Light",
            Accent = "#ffffff",
            Dialog = "#f1f1f1",
            Outline = "#000000",
            Text = "#000000",
            Placeholder = "#666666",
            Background = "#ffffff",
            Button = "#d4d4d8",
            Icon = "#52525b",
        }
    }
}

for _, themeData in pairs(WindUiSettings.Themes) do
    WindUI:AddTheme(themeData)
end

WindUI:SetTheme(WindUiSettings.SelectedTheme)

local Elements = {}

local function LicenseWindow_F()
    local InputtedLicense = ""

    local LicenseWindow = WindUI:CreateWindow({
        Title = "Fractxlware Public",
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

    Elements.License = LicenseWindow:Tab({
        Title = "License",
        Icon = "key-round",
        Locked = false
    })

    Elements.LicenseInput = Elements.License:Input({
        Title = "License",
        Desc = "Input your license to gain access to Fractxlware",
        InputIcon = "",
        Type = "Input",
        Placeholder = "Enter License",
        SaveKey = true,
        Callback = function(input)
            InputtedLicense = input
        end
    })

    Elements.CheckLicense = Elements.License:Button({
        Title = "Check License",
        Callback = function()
            local licensereq = game:HttpGet('https://keyauth.win/api/1.1/?name=' .. name .. '&ownerid=' .. ownerid .. '&type=license&key=' .. InputtedLicense ..'&ver=' .. version .. '&sessionid=' .. sessionid)
            local licensedata = HttpService:JSONDecode(licensereq)
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
                    Content = licensedata.message .. " Creating Window.."
                })
            LicenseWindow:Close():Destroy()
            writefile(LicenseWindow.Folder .. "/" .. "license" .. ".key", tostring(InputtedLicense))
            end
        end
    })
end

if Initialized == true then LicenseWindow_F() end