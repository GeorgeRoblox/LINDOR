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

	UpdateInfo:AddLabel("Jack Is a Good Boy")

end
