_G.autosell = true
_G.autosell == true do
        local args = {[1] = "SellUnder",[2] = 50000}
game:GetService("ReplicatedStorage").Events.InventoryActions:InvokeServer(unpack(args))
    end
