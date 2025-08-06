local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Fractxlware = {}

function Fractxlware:ShowAsync()
    local player = Players.LocalPlayer
    local blur = Instance.new("BlurEffect", Lighting)
    blur.Size = 0
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 24}):Play()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Fractxlware"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    bg.BackgroundTransparency = 1
    bg.ZIndex = 0
    bg.Parent = frame
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()

    local word = "FRACTXLWARE"
    local letters = {}

    for i = 1, #word do
        local char = word:sub(i, i)
        local label = Instance.new("TextLabel")
        label.Text = char
        label.Font = Enum.Font.GothamBlack
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 1 
        label.TextTransparency = 1
        label.TextScaled = false
        label.TextSize = 30 
        label.Size = UDim2.new(0, 60, 0, 60)
        label.AnchorPoint = Vector2.new(0.5, 0.5)
        label.Position = UDim2.new(0.5, (i - (#word / 2 + 0.5)) * 65, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Parent = frame

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 170, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 160))
        })
        gradient.Rotation = 90
        gradient.Parent = label

        local tweenIn = TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0, TextSize = 60})
        tweenIn:Play()

        table.insert(letters, label)
        task.wait(0.25)
    end

    task.wait(2)

    for _, label in ipairs(letters) do
        TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1, TextSize = 20}):Play()
    end
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()
    task.wait(0.6)

    screenGui:Destroy()
    blur:Destroy()
end


return Fractxlware
