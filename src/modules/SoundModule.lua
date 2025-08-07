local SoundModule = {}

function SoundModule.Play(soundId, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(soundId)
    sound.Volume = volume or 1
    sound.Parent = parent or workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    return sound
end

return SoundModule