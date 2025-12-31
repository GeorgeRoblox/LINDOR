return function(Tab)
	local Global = getgenv()
	local CloneReference = function(Object)
		if cloneref and typeof(cloneref) == "function" then
			return cloneref(Object)
		else
			return Object
		end
	end

	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

local VisionTab = FloorTab.FloorTabs:AddRightTabbox()
	local CringlesWorkShop = VisionTab:AddTab('Cringles WorkShop')
	
	CringlesWorkShop:AddButton({
		Text = 'Teleport To End',
		Func = function()
			if Floor == "Ripple" then
			local door = workspace.CurrentRooms["2"].RippleExitDoor
			local doorCF = door:GetPivot()

			local offset = doorCF.LookVector * 2
			local finalCF = doorCF + offset

			local player = game.Players.LocalPlayer
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart")

			hrp.CFrame = CFrame.new(finalCF.Position, doorCF.Position)
			Notify('Teleported...')
			else
				return
			end
		end,
		DoubleClick = (true),
		Tooltip = 'Makes You Teleport To The End Also Dont Forget You Need To Be in The Room 1.'
	})
end
