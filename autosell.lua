_G.autosell = true
while _G.autosell == true do
    wait(0.04)
    local args = {
    [1] = "SellUnder",
    [2] = 50000
}

game:GetService("ReplicatedStorage").Events.InventoryActions:InvokeServer(unpack(args))
end
