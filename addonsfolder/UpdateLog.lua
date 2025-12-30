return function(Tab)
	local Global = getgenv()
	local CloneReference = function(Object)
		if cloneref and typeof(cloneref) == "function" then
			return cloneref(Object)
		else
			return Object
		end
	end

	local UpdateInfo = Tab:AddLeftGroupbox("UpdateLog")

	UpdateInfo:AddLabel(" + FIXED BUGS")
	UpdateInfo:AddLabel(" + FIXED SOME TOGGLES NOT WORKING")
	UpdateInfo:AddLabel(" + happy new year!!!!!! ")

	

end
