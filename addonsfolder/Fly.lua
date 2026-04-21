local Fly = {}
Fly.Speed = 500
Fly.Enabled = false

Fly.Body = Instance.new("BodyVelocity")
Fly.Body.Velocity = Vector3.zero
Fly.Body.MaxForce = Vector3.one * 8999999488

Fly.Gyro = Instance.new("BodyGyro")
Fly.Gyro.P = 6500
Fly.Gyro.MaxTorque = Vector3.new(4000000, 4000000, 4000000)
Fly.Gyro.D = 500

local CloneReference = function(Object)
	if cloneref and typeof(cloneref) == "function" then
		return cloneref(Object)
	else
		return Object
	end
end

function GenerateRandomString()
	local Result = {}
	local Chars = "1234567890abcdef"
	for i = 1,32,1 do
		local Index = math.random(1,#Chars)
		local Char = Chars:sub(Index, Index)
		table.insert(Result, Char)
	end
	return table.concat(Result)
end

Fly.Body.Name =  GenerateRandomString()
Fly.Gyro.Name = GenerateRandomString()

local Players = CloneReference(game:GetService("Players"))
local RunService = CloneReference(game:GetService("RunService"))
local TweenService = CloneReference(game:GetService("TweenService"))

local Camera = CloneReference(game:GetService("Workspace").CurrentCamera)
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChild("Humanoid")

local CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
Character = NewCharacter
Humanoid = NewCharacter:WaitForChild("Humanoid")
end)

function GetVelocity()
	if (Character:WaitForChild("Humanoid").MoveDirection == Vector3.new(0, 0, 0)) then
		local NewVelocity = Character:WaitForChild("Humanoid").MoveDirection;
		return Character:WaitForChild("Humanoid").MoveDirection;
	else
	end
	local Velocity = (Camera.CFrame * CFrame.new((CFrame.new(Camera.CFrame.p, Camera.CFrame.p + Vector3.new(Camera.CFrame.lookVector.x, 0, Camera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - Camera.CFrame.p;
	if (Velocity == Vector3.new()) then
		return Velocity;
	end
	return Velocity.unit;
end

local MainConnection = RunService.RenderStepped:Connect(function()
	if Fly.Enabled == true then
		local Velocity = Vector3.zero;
		Velocity = GetVelocity()
		Humanoid.PlatformStand = true
		
		TweenService:Create(Fly.Body, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Velocity=(Velocity * Fly.Speed)}):Play();
		TweenService:Create(Fly.Gyro, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {CFrame = Camera.CFrame}):Play();
		
		Fly.Body.Parent = Character.HumanoidRootPart
		Fly.Gyro.Parent = Character.HumanoidRootPart
	else
		Fly.Body.Parent = nil
		Fly.Gyro.Parent = nil
	end
end)

local CameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = CloneReference(game:GetService("Workspace").CurrentCamera)
end)

function Fly:Enable()
	Fly.Enabled = true
end
function Fly:Disable()
	Fly.Enabled = false
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	Humanoid.PlatformStand = false
	Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
end
function Fly:SetSpeed(Number)
	Fly.Speed = Number
end
function Fly:Unload()
	Fly:Disable()
	CharacterConnection:Disconnect()
	MainConnection:Disconnect()
	Fly.Body:Destroy()
	Fly.Gyro:Destroy()
end

return Fly
