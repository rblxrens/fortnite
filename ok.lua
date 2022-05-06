	for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
		v:Disable()


		for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
			v:Disable()
			_G.Thing = true
			_G.Case = "Darklaced"

			for i=1,1400 do
				spawn(function()
					while _G.Thing do 
						game:GetService("ReplicatedStorage").Remotes.OpenCase:InvokeServer(_G.Case, tostring(game:GetService("Players").LocalPlayer.CasesPer.Value))
						game:GetService("ReplicatedStorage").Remotes.Click:FireServer()
					end
				end)
			end
		end)
