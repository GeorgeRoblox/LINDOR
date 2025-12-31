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
	local UpdateInfo = Tab:AddLeftGroupbox("Added UpdateLog")
	local UpdateInfo2 = Tab:AddRightGroupbox("Removed UpdateLog")
	local UpdateInfo4 = Tab:AddLeftGroupbox("Buyers UpdateLog")
	local UserInfo = Tab:AddLeftGroupbox("Player Info")

	UpdateInfo:AddLabel("Doors:")
	UpdateInfo:AddLabel(" + FIXED BUGS")
	UpdateInfo:AddLabel(" + FIXED SOME TOGGLES NOT WORKING")
	UpdateInfo:AddLabel(" + FIXED AUTO INTERACT")
	UpdateInfo:AddLabel(" + happy new year!!!!!! ")
	UpdateInfo4:AddLabel(" + Teleport to end (cringles workshop) ")
	
	
	UpdateInfo2:AddLabel("Doors:")
	UpdateInfo2:AddLabel(" - Removed Key System ! ")
	UpdateInfo2:AddLabel(" - Removed Can Slide Toggle ! ")
	
	
	local name, version = identifyexecutor()

	if name then
		UserInfo:AddLabel(" Executor: " .. name .. " v" .. tostring(version))
	else
		UserInfo:AddLabel(" Executor: Unknown")
	end
	UserInfo:AddDivider()
	UserInfo:AddButton({
		Text = 'Copy Join Code',
		Func = function()
			local Success, Error = pcall(function()
				toclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game:GetService("Players").LocalPlayer)')
			end)
			if Success then
				Library:Notify("Link is copied!")
			else
				Library:Notify("Link Failed To Copy.")
			end
		end,
		DoubleClick = (true),
		Tooltip = 'Copies The Join Code.'
	})

	if LocalPlayer.Name == "Vuticlk" or LocalPlayer.Name == "yeahidkabtthis" then
		local UpdateInfo3 = Tab:AddRightGroupbox("Nigga UpdateLog")
		UpdateInfo3:AddLabel("+ Jack is a GOOD BOY 💔")
		UpdateInfo3:AddLabel("+ Jacob is MARRIED TO DARK ")
		UpdateInfo3:AddLabel("+ Jacob is better than jack 👌 ")
	else
		return
	end

end
