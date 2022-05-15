_G.autoclick = true
while _G.autoclick == true do
    game:GetService("ReplicatedStorage").Events.ClientClick:FireServer()
wait(0.30)
end
