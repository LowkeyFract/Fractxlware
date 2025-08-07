local scripthub = {
    Template1 = {
        Name = "Template 1",
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        loadstring = ""
    },
    Template2 = {
        Name = "Template 2",
        Icon = "rbxassetid://129260712070622",
        IconThemed = true,
        loadstring = ""
    },
}

return function(tab)
    for key, template in pairs(scripthub) do
        tab:Button({
            Title = template.Name,
            Icon = template.Icon,
            IconThemed = template.IconThemed,
            Callback = function()
                if template.loadstring and template.loadstring ~= "" then
                    local success, err = pcall(loadstring(template.loadstring))
                    if not success then
                        WindUI:Notify({
                            Title = "Error",
                            Icon = "error",
                            Content = "Failed to load script: " .. err
                        })
                    end
                else
                    WindUI:Notify({
                        Title = "Error",
                        Icon = "error",
                        Content = "No script available for this template."
                    })
                end
                WindUI:Notify({
                    Title = "Script Loaded",
                    Icon = "check",
                    Content = "Successfully executed " .. template.Name
                })
            end
        })
    end
end