_G.Thing = true
_G.Case = "Beanistic"

for i=1,700 do
spawn(function()
    while _G.Thing do 
        game:GetService("ReplicatedStorage").Remotes.OpenCase:InvokeServer(_G.Case, tostring(game:GetService("Players").LocalPlayer.CasesPer.Value))
        game:GetService("ReplicatedStorage").Remotes.Click:FireServer()
    end
end)
end
