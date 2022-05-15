_G.autocase = true
while _G.autocase == true do
    local args = {[1] = "Starter"}
    game:GetService("ReplicatedStorage").Events.OpenCase:InvokeServer(unpack(args))
    wait(0.01)
    end
