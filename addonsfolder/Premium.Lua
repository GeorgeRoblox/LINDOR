
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

	local CWPREMIUM = Tab:AddLeftGroupbox("Cringles WorkShop")

	if LocalPlayer.Name == "yeahidkabtthis" or LocalPlayer.Name == "DontRun0_00" or LocalPlayer.Name == "jacob_irish009"  or LocalPlayer.Name == "Timmynotpog" then
		CWPREMIUM:AddButton({
			Text = 'Teleport To End',
			Func = function()
				
					local door = workspace.CurrentRooms["2"].RippleExitDoor
					local doorCF = door:GetPivot()

					local offset = doorCF.LookVector * 2
					local finalCF = doorCF + offset

					local player = game.Players.LocalPlayer
					local char = player.Character or player.CharacterAdded:Wait()
					local hrp = char:WaitForChild("HumanoidRootPart")

					hrp.CFrame = CFrame.new(finalCF.Position, doorCF.Position)
					Notify('Teleported...')

			end,
			DoubleClick = (true),
			Tooltip = 'Makes You Teleport To The End Also Dont Forget You Need To Be in The Room 1.'
		})
		end
	end
