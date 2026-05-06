local Library = {
    ObjectsFolder = Instance.new("Folder"),
    ScreenGui = Instance.new("ScreenGui"),
    HighlightsFolder = Instance.new("Folder"),
    BillboardsFolder = Instance.new("Folder"),
    TracersFrame = Instance.new("Frame"),
    ArrowsFrame = Instance.new("Frame"),

    Highlights = {},
    Labels = {},
    Frames = {},
    Lines = {},
    ArrowsTable = {},
    ColorTable = {},
    TextTable = {},
    ElementsEnabled = {},
    TransparencyEnabled = {},
    ConnectionsTable = {},
    Objects = {},
    TotalObjects = {},

    Font = Enum.Font.RobotoCondensed,
    Rainbow = false,
    Tracers = false,
    Arrows = false,
    Unloaded = false,
    ShowDistance = false,
    MatchColors = true,

    TextTransparency = 0,
    TextOutlineTransparency = 0,
    TextSize = 20,
    FillTransparency = 0.75,
    OutlineTransparency = 0,
    FadeTime = 0.25,
    RenderLimit = 240,
    TracerOrigin = "Bottom",
    TracerSize = 0.5,
    ArrowRadius = 200,
    DistanceSizeRatio = 1,
    OutlineColor = Color3.fromRGB(255,255,255),
    RainbowColor = Color3.fromRGB(255,255,255),
}

local RainbowTable = {
    HueSetup = 0,
    Hue = 0,
    Step = 0,
    Color = Color3.new(),
}

local cloneref = cloneref or function(o) return o end

local Players = cloneref(game:GetService("Players"))
local Workspace = cloneref(workspace)
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local TweenService = cloneref(game:GetService("TweenService"))
local Debris = cloneref(game:GetService("Debris"))

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ObjectsFolder = Library.ObjectsFolder
local ScreenGui = Library.ScreenGui
local HighlightsFolder = Library.HighlightsFolder
local BillboardsFolder = Library.BillboardsFolder
local TracersFrame = Library.TracersFrame
local ArrowsFrame = Library.ArrowsFrame

local Highlights = Library.Highlights
local Labels = Library.Labels
local Frames = Library.Frames
local Lines = Library.Lines
local ArrowsTable = Library.ArrowsTable
local ColorTable = Library.ColorTable
local TextTable = Library.TextTable
local ElementsEnabled = Library.ElementsEnabled
local TransparencyEnabled = Library.TransparencyEnabled
local ConnectionsTable = Library.ConnectionsTable
local Objects = Library.Objects
local TotalObjects = Library.TotalObjects

local function GenerateRandomString(len)
    len = len or 24
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    local t = {}
    for i = 1, len do
        local idx = math.random(1, #chars)
        table.insert(t, chars:sub(idx, idx))
    end
    return table.concat(t)
end

local function GetHiddenUI()
    if gethui then
        return gethui()
    end
    local cg = (getgenv and cloneref(game:GetService("CoreGui"))) or Players.LocalPlayer:WaitForChild("PlayerGui")
    local folder = Instance.new("Folder")
    folder.Name = GenerateRandomString()
    folder.Parent = cg
    return folder
end

local HiddenUI = GetHiddenUI()

ObjectsFolder.Name = GenerateRandomString()
ObjectsFolder.Parent = HiddenUI

ScreenGui.Name = GenerateRandomString()
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = HiddenUI

HighlightsFolder.Name = GenerateRandomString()
HighlightsFolder.Parent = ScreenGui

BillboardsFolder.Name = GenerateRandomString()
BillboardsFolder.Parent = ScreenGui

TracersFrame.Name = GenerateRandomString()
TracersFrame.Size = UDim2.new(1,0,1,0)
TracersFrame.BackgroundTransparency = 1
TracersFrame.Visible = false
TracersFrame.Parent = ScreenGui

ArrowsFrame.Name = GenerateRandomString()
ArrowsFrame.Size = UDim2.new(1,0,1,0)
ArrowsFrame.BackgroundTransparency = 1
ArrowsFrame.Visible = false
ArrowsFrame.Parent = ScreenGui

local ArrowT = Instance.new("ImageLabel")
ArrowT.Image = "rbxassetid://16368985219"
ArrowT.Size = UDim2.new(0, 50, 0, 50)
ArrowT.AnchorPoint = Vector2.new(0.5, 0.5)
ArrowT.BackgroundTransparency = 1
ArrowT.ImageTransparency = 1
local Constraint = Instance.new("UIAspectRatioConstraint")
Constraint.AspectRatio = 1
Constraint.Parent = ArrowT

local function RemoveObjectFromTables(obj)
    for i, v in ipairs(TotalObjects) do
        if v == obj then
            table.remove(TotalObjects, i)
            break
        end
    end
end

local function GetTracerOrigin()
    local vp = Camera.ViewportSize
    if Library.TracerOrigin == "Center" then
        return Vector2.new(vp.X/2, vp.Y/2)
    elseif Library.TracerOrigin == "Top" then
        return Vector2.new(vp.X/2, 0)
    elseif Library.TracerOrigin == "Mouse" then
        local m = UserInputService:GetMouseLocation()
        return Vector2.new(m.X, m.Y)
    else
        return Vector2.new(vp.X/2, vp.Y)
    end
end

local function GetArrowData(screenPoint)
    local screenSize = Camera.ViewportSize
    local screenCenter = Vector2.new(screenSize.X/2, screenSize.Y/2)
    local dir = Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter
    if dir.Magnitude == 0 then
        dir = Vector2.new(1, 0)
    end
    local angle = math.atan2(dir.Y, dir.X)
    local radius = math.min(screenSize.X, screenSize.Y)/2 - (400 - Library.ArrowRadius)
    local arrowPos = screenCenter + dir.Unit * radius
    return arrowPos, math.deg(angle)
end

function Library:AddESP(params)
    if Library.Unloaded then return end

    local obj = params.Object
    if not obj or ElementsEnabled[obj] then return end
    if not obj:IsA("BasePart") and not obj:IsA("Model") then return end

    ElementsEnabled[obj] = true
    TransparencyEnabled[obj] = false

    if Highlights[obj] then
        Highlights[obj]:Destroy()
        Highlights[obj] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = GenerateRandomString()
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1
    highlight.Adornee = obj
    highlight.Parent = HighlightsFolder
    Highlights[obj] = highlight

    local textFrame = Instance.new("Frame")
    textFrame.Name = GenerateRandomString()
    textFrame.Size = UDim2.fromScale(1,1)
    textFrame.BackgroundTransparency = 1
    textFrame.AnchorPoint = Vector2.new(0.5,0.5)
    textFrame.Visible = false
    textFrame.Parent = BillboardsFolder

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = GenerateRandomString()
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.Font = Library.Font
    textLabel.TextSize = Library.TextSize
    textLabel.RichText = true
    textLabel.Text = params.Text or ""
    textLabel.TextTransparency = 1
    textLabel.TextStrokeTransparency = Library.TextOutlineTransparency
    textLabel.TextColor3 = params.Color or Color3.new(1,1,1)
    textLabel.Parent = textFrame

    Frames[obj] = textFrame
    Labels[obj] = textLabel
    TextTable[obj] = params.Text or ""
    ColorTable[obj] = params.Color or Color3.new(1,1,1)
    Objects[obj] = obj
    table.insert(TotalObjects, obj)

    local lineFrame = Instance.new("Frame")
    lineFrame.Name = GenerateRandomString()
    lineFrame.Size = UDim2.new(0,0,0,0)
    lineFrame.BackgroundTransparency = 1
    lineFrame.AnchorPoint = Vector2.new(0.5,0.5)
    lineFrame.Parent = TracersFrame

    local stroke = Instance.new("UIStroke")
    stroke.Name = GenerateRandomString()
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = Library.TracerSize
    stroke.Transparency = 1
    stroke.Parent = lineFrame

    Lines[obj] = {lineFrame, stroke}

    if Library.FadeTime > 0 then
        TweenService:Create(highlight, TweenInfo.new(Library.FadeTime, Enum.EasingStyle.Quad), {
            FillTransparency = Library.FillTransparency,
            OutlineTransparency = Library.OutlineTransparency,
        }):Play()

        local t1 = TweenService:Create(textLabel, TweenInfo.new(Library.FadeTime, Enum.EasingStyle.Quad), {
            TextTransparency = Library.TextTransparency,
            TextStrokeTransparency = Library.TextOutlineTransparency,
        })
        t1.Completed:Once(function()
            TransparencyEnabled[obj] = true
        end)
        t1:Play()

        TweenService:Create(stroke, TweenInfo.new(Library.FadeTime, Enum.EasingStyle.Quad), {
            Transparency = 0,
        }):Play()
    else
        highlight.FillTransparency = Library.FillTransparency
        highlight.OutlineTransparency = Library.OutlineTransparency
        textLabel.TextTransparency = Library.TextTransparency
        textLabel.TextStrokeTransparency = Library.TextOutlineTransparency
        stroke.Transparency = 0
        TransparencyEnabled[obj] = true
    end

    local last = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if Library.Unloaded or not ElementsEnabled[obj] then
            if conn then conn:Disconnect() end
            return
        end

        if tick() - last < 1 / Library.RenderLimit then
            return
        end
        last = tick()

        if not obj or not obj:IsDescendantOf(game) then
            Library:RemoveESP(obj)
            return
        end

        local pos = obj:GetPivot().Position
        local screenPoint, onScreen = Camera:WorldToViewportPoint(pos)

        local frame = Frames[obj]
        local label = Labels[obj]
        local hl = Highlights[obj]
        local line = Lines[obj] and Lines[obj][0+1]
        local strokeLine = Lines[obj] and Lines[obj][0+2]

        if frame then
            frame.Visible = onScreen
            if onScreen then
                frame.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
            end
        end

        if hl then
            if not onScreen then
                hl.Enabled = false
            else
                hl.Enabled = true
            end
        end

        if label then
            local color = Library.Rainbow and RainbowTable.Color or ColorTable[obj] or Color3.new(1,1,1)
            label.TextColor3 = color

            if hl then
                local dist = math.floor((Camera.CFrame.Position - pos).Magnitude)
                local distText = ""
                if Library.ShowDistance then
                    distText = "\n<font size=\"" ..
                        math.round(Library.TextSize * Library.DistanceSizeRatio) ..
                        "\">[" .. dist .. "]</font>"
                end

                label.Text = (TextTable[obj] or "") .. distText

                hl.FillColor = color
                hl.OutlineColor = Library.MatchColors and color or Library.OutlineColor

                if TransparencyEnabled[obj] then
                    hl.FillTransparency = Library.FillTransparency
                    hl.OutlineTransparency = Library.OutlineTransparency
                    label.TextTransparency = Library.TextTransparency
                    label.TextStrokeTransparency = Library.TextOutlineTransparency
                end
            end
        end

        if line and strokeLine and hl and Library.Tracers and onScreen then
            local origin = GetTracerOrigin()
            local dest = Vector2.new(screenPoint.X, screenPoint.Y)
            local mid = (origin + dest) / 2
            local length = (origin - dest).Magnitude
            local rot = math.deg(math.atan2(dest.Y - origin.Y, dest.X - origin.X))

            line.Position = UDim2.new(0, mid.X, 0, mid.Y)
            line.Size = UDim2.new(0, length, 0, 1)
            line.Rotation = rot
            line.BackgroundColor3 = hl.FillColor
            line.BorderSizePixel = 0
            line.Visible = true

            strokeLine.Color = hl.FillColor
            strokeLine.Thickness = Library.TracerSize
            strokeLine.Transparency = 0
        elseif line then
            line.Visible = false
        end

        if Library.Arrows then
            local arrow = ArrowsTable[obj]
            if not arrow and ElementsEnabled[obj] then
                arrow = ArrowT:Clone()
                arrow.Name = GenerateRandomString()
                arrow.Parent = ArrowsFrame
                arrow.ImageTransparency = 1
                ArrowsTable[obj] = arrow

                if Library.FadeTime > 0 then
                    TweenService:Create(arrow, TweenInfo.new(Library.FadeTime, Enum.EasingStyle.Quad), {
                        ImageTransparency = 0
                    }):Play()
                else
                    arrow.ImageTransparency = 0
                end
            end

            if arrow then
                if onScreen and screenPoint.Z > 0 then
                    arrow.Visible = false
                else
                    local arrowPos, angle = GetArrowData(screenPoint)
                    arrow.Position = UDim2.new(0, arrowPos.X, 0, arrowPos.Y)
                    arrow.Rotation = angle - 90
                    arrow.Visible = true
                    arrow.ImageColor3 = (Library.Rainbow and Library.RainbowColor) or ColorTable[obj] or Color3.new(1,1,1)
                end
            end
        end
    end)

    ConnectionsTable[obj] = conn
end

function Library:RemoveESP(obj)
    if not obj or not ElementsEnabled[obj] then return end
    ElementsEnabled[obj] = false
    TransparencyEnabled[obj] = false

    local textFrame = Frames[obj]
    local textLabel = Labels[obj]
    local hl = Highlights[obj]
    local line = Lines[obj] and Lines[obj][1]
    local strokeLine = Lines[obj] and Lines[obj][2]
    local arrow = ArrowsTable[obj]
    local conn = ConnectionsTable[obj]

    local fade = Library.FadeTime

    if textLabel then
        TweenService:Create(textLabel, TweenInfo.new(fade, Enum.EasingStyle.Quad), {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
        }):Play()
    end

    if hl then
        TweenService:Create(hl, TweenInfo.new(fade, Enum.EasingStyle.Quad), {
            FillTransparency = 1,
            OutlineTransparency = 1,
        }):Play()
    end

    if line then
        TweenService:Create(line, TweenInfo.new(fade, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
        }):Play()
    end

    if strokeLine then
        TweenService:Create(strokeLine, TweenInfo.new(fade, Enum.EasingStyle.Quad), {
            Transparency = 1,
        }):Play()
    end

    if arrow then
        TweenService:Create(arrow, TweenInfo.new(fade, Enum.EasingStyle.Quad), {
            ImageTransparency = 1,
        }):Play()
    end

    task.delay(fade + 0.05, function()
        if textFrame then textFrame:Destroy() end
        if hl then hl:Destroy() end
        if line then line:Destroy() end
        if strokeLine then strokeLine:Destroy() end
        if arrow then arrow:Destroy() end

        Frames[obj] = nil
        Labels[obj] = nil
        Highlights[obj] = nil
        Lines[obj] = nil
        ArrowsTable[obj] = nil
        Objects[obj] = nil
        ConnectionsTable[obj] = nil
        RemoveObjectFromTables(obj)

        if conn then conn:Disconnect() end
    end)
end

function Library:SetColorTable(obj, color)
    ColorTable[obj] = color
    if Labels[obj] then
        Labels[obj].TextColor3 = color
    end
end

function Library:SetFadeTime(n)
    Library.FadeTime = n
end

function Library:SetRenderLimit(n)
    Library.RenderLimit = n
end

function Library:SetTextTransparency(n)
    Library.TextTransparency = n
    for _, lbl in pairs(Labels) do
        lbl.TextTransparency = n
    end
end

function Library:SetFillTransparency(n)
    Library.FillTransparency = n
    for _, hl in pairs(Highlights) do
        if hl:IsA("Highlight") then
            hl.FillTransparency = n
        end
    end
end

function Library:SetOutlineTransparency(n)
    Library.OutlineTransparency = n
    for _, hl in pairs(Highlights) do
        if hl:IsA("Highlight") then
            hl.OutlineTransparency = n
        end
    end
end

function Library:SetTextSize(n)
    Library.TextSize = n
    for _, lbl in pairs(Labels) do
        lbl.TextSize = n
    end
end

function Library:SetTextOutlineTransparency(n)
    Library.TextOutlineTransparency = n
    for _, lbl in pairs(Labels) do
        lbl.TextStrokeTransparency = n
    end
end

function Library:SetFont(font)
    Library.Font = font
    for _, lbl in pairs(Labels) do
        lbl.Font = font
        lbl.TextSize = Library.TextSize
    end
end

function Library:UpdateObjectText(obj, text)
    if Labels[obj] then
        TextTable[obj] = text
    end
end

function Library:UpdateObjectColor(obj, color)
    ColorTable[obj] = color
    if Labels[obj] then
        Labels[obj].TextColor3 = color
    end
end

function Library:SetOutlineColor(color)
    Library.OutlineColor = color
end

function Library:SetRainbow(val)
    Library.Rainbow = val
end

function Library:SetShowDistance(val)
    Library.ShowDistance = val
end

function Library:SetMatchColors(val)
    Library.MatchColors = val
end

function Library:SetTracers(val)
    Library.Tracers = val
    TracersFrame.Visible = val
end

function Library:SetArrows(val)
    Library.Arrows = val
    ArrowsFrame.Visible = val
end

function Library:SetArrowRadius(val)
    Library.ArrowRadius = val
end

function Library:SetTracerOrigin(val)
    Library.TracerOrigin = val
end

function Library:SetDistanceSizeRatio(val)
    Library.DistanceSizeRatio = val
end

function Library:SetTracerSize(val)
    Library.TracerSize = 0.5 * val
end

local RainbowConnection = RunService.RenderStepped:Connect(function(dt)
    RainbowTable.Step += dt
    if RainbowTable.Step >= 1/60 then
        RainbowTable.Step = 0
        RainbowTable.HueSetup += 1/400
        if RainbowTable.HueSetup > 1 then
            RainbowTable.HueSetup = 0
        end
        RainbowTable.Hue = RainbowTable.HueSetup
        RainbowTable.Color = Color3.fromHSV(RainbowTable.Hue, 0.8, 1)
        Library.RainbowColor = RainbowTable.Color
    end
end)

local CameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

function Library:Unload()
    if Library.Unloaded then return end
    Library.Unloaded = true

    for obj in pairs(Objects) do
        self:RemoveESP(obj)
    end

    for _, conn in pairs(ConnectionsTable) do
        conn:Disconnect()
    end

    RainbowConnection:Disconnect()
    CameraConnection:Disconnect()
    ScreenGui.Enabled = false
end

if getgenv then
    getgenv().ESPLibrary = Library
end

return Library
