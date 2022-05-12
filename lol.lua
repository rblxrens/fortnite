local lib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt")()

local win = lib:Window("$ czW#1748 gui :3",Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightControl)

local tab = win:Tab("Main")
local tab2 = win:Tab("Misc")
local tab3 = win:Tab("Jackpot")
tab:Button("fastcase", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/rblxrens/fortnite/main/ok.lua'))()
end)

tab:Button("ADD ALL ", function()    
    for i,v in pairs(game.Players.LocalPlayer.Items:GetChildren()) do
        local args = {  
            [1] = v.Name,
            [2] = "11111111111111"
            }
            game:GetService("ReplicatedStorage").Remotes.Jackpot:FireServer(unpack(args))
        end
            end)
tab:Button("ANTI AFK ", function()    
    for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
		v:Disable()
	end
end)

tab2:Button("Sprint", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
end)

tab2:Button("Walk", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

tab3:Button("10T", function()
	local string_1 = "Custom Tan Fast Helmet";
	local string_2 = "1733";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Volcanic Warlord Helmet";
	local string_2 = "1733";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Fire Helmet Red";
	local string_2 = "1733";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);
end)

tab3:Button("100T", function()
	local string_1 = "Custom Tan Fast Helmet";
	local string_2 = "17333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Volcanic Warlord Helmet";
	local string_2 = "17333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Fire Helmet Red";
	local string_2 = "17333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);
end)

tab3:Button("1qd", function()
        local string_1 = "Custom Tan Fast Helmet";
	local string_2 = "173333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Volcanic Warlord Helmet";
	local string_2 = "173333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Fire Helmet Red";
	local string_2 = "173333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);
end)

tab3:Button("10qd", function()
        local string_1 = "Custom Tan Fast Helmet";
	local string_2 = "1733333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Volcanic Warlord Helmet";
	local string_2 = "1733333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Fire Helmet Red";
	local string_2 = "1733333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);
end)

tab3:Button("100qd (new)", function()
	local string_1 = "Custom Tan Fast Helmet";
	local string_2 = "17333333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Volcanic Warlord Helmet";
	local string_2 = "17333333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);


	local string_1 = "Fire Helmet Red";
	local string_2 = "17333333";
	local Target = game:GetService("ReplicatedStorage").Remotes.Jackpot;
	Target:FireServer(string_1, string_2);
end)


local changeclr = win:Tab("Change UI Color")

changeclr:Colorpicker("Change UI Color",Color3.fromRGB(44, 120, 224), function(t)
lib:ChangePresetColor(Color3.fromRGB(t.R * 255, t.G * 255, t.B * 255))
end)


    
