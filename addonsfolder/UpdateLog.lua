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
	
	UpdateInfo:AddLabel(" + FIXED BUGS")
	UpdateInfo:AddLabel(" + FIXED SOME TOGGLES NOT WORKING")
	UpdateInfo:AddLabel(" + happy new year!!!!!! ")
	UpdateInfo2:AddLabel(" - Removed Key System ! ")
	
	if LocalPlayer.Name == "Vuticlk" or LocalPlayer.Name == "yeahidkabtthis" then
		local UpdateInfo3 = Tab:AddLeftGroupbox("Nigga UpdateLog")
		UpdateInfo3:AddLabel("+ Jack is a GOOD BOY 💔")
	else
		return
	end

end
