


return function(Tab, HWID)


		local AllowedHWID = "TESTHWID"

		if HWID ~= AllowedHWID then
			Tab:AddLabel("You do not have premium.")
			return
		end

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


		local LOBBYPREMIUM = Tab:AddLeftGroupbox("Lobby")

		CodesList = {
			"67",
			"54",
			"41",
			"CHEDDAR BALLS",
			"XQC",
			"PENGUINZ0",
			"KREEKCRAFT",
			"ISHOWSPEED",
			"DANTDM",
			"KUBZ SCOUTS",
			"FIND THE TROLLFACES",
			"THINKNOODLES",
			"W",
			"RAGDOLL UNIVERSE",
			"RAGDOLL MAYHEM",
			"BIJUU MIKE",
			"8BITRYAN",
			"SCREECHSUCKS",
			"LORE",
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
			"FIND THE TROLLFACES",
			"3rd",
			"LAZYDEVS",
			"RAGDOLL COMBAT",
			"VOCAB HAVOC",
			"PATHSWAP",
			"JUMP OVER THE BRICK"
		}

		LOBBYPREMIUM:AddButton{
			Text = 'Redeem Codes',
			DoubleClick = false,
			Tooltip = 'Redeems all currently active codes in the game',
			Func = function()
				for i,ShopCode in pairs(CodesList) do
					game:GetService("ReplicatedStorage").RemotesFolder.ShopCode:FireServer(ShopCode)
					task.wait(1.1)
				end
			end
		}

		local MM2PREM = Tab:AddLeftGroupbox("Murderer Mystery 2")


		local RunService = game:GetService("RunService")


		local AutoFarmRunning = false
		local AutoFarmConnection = nil

		-- UI ELEMENTS (your exact code)
		MM2PREM:AddSlider("AutoFarmSpeed", {
			Text = 'Farm Speed ',
			Default = 21,
			Min = 18,
			Max = 27,
			Rounding = 0,
			Compact = true
		})

		MM2PREM:AddDivider()

		MM2PREM:AddToggle('AutoFarm', {
			Text = 'Auto Farm',
			Default = false,
			Callback = function(state)
				AutoFarmRunning = state

				if state then
					AutoFarmConnection = RunService.RenderStepped:Connect(function()
						if not AutoFarmRunning then return end

						local character = LocalPlayer.Character
						if not character then return end

						local root = character:FindFirstChild("HumanoidRootPart")
						if not root then return end

						local closest = nil
						local closestDist = math.huge

						-- Scan all workspace descendants for coins
						for _, obj in ipairs(workspace:GetDescendants()) do
							if obj.Name == "Coin_Server" and obj:IsA("BasePart") and obj:IsDescendantOf(workspace) then
								local dist = (root.Position - obj.Position).Magnitude
								if dist < closestDist then
									closestDist = dist
									closest = obj
								end
							end
						end

						if closest then
							local speed = Options.AutoFarmSpeed.Value
							root.CFrame = root.CFrame:Lerp(CFrame.new(closest.Position), speed / 100)
						end
					end)
				else
					if AutoFarmConnection then
						AutoFarmConnection:Disconnect()
						AutoFarmConnection = nil
					end
				end
			end
		})

	end
