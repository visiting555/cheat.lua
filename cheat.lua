-- VISITING SOFTWARE v3.0
-- Tam donanımlı, tüm özellikler aktif, test ortamı için.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GUI = Instance.new("ScreenGui")
GUI.Name = "VISITING_SOFTWARE"
GUI.ResetOnSpawn = false
GUI.Parent = game.CoreGui

local function Shadow(parent, size, pos, trans)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = pos or UDim2.new(0.5, 0, 0.5, 0)
    s.Size = size or UDim2.new(1, 60, 1, 60)
    s.Image = "rbxassetid://6015897843"
    s.ImageColor3 = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency = trans or 0.6
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = parent.ZIndex - 1
    s.Parent = parent
    return s
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 460, 0, 660)
Main.Position = UDim2.new(0.02, 0, 0.05, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
Shadow(Main, UDim2.new(1, 80, 1, 80), UDim2.new(0.5, 0, 0.5, 0), 0.7)

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 17, 30)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)
local TitleGrad = Instance.new("UIGradient", TitleBar)
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
})
TitleGrad.Rotation = 90

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 18, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "VISITING SOFTWARE v3"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -46, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 70)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 26
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 12)
CloseBtn.MouseButton1Click:Connect(function() GUI.Enabled = false end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -64)
Scroll.Position = UDim2.new(0, 10, 0, 54)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 5000)
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 10)

-- Helper: Create section
local function Section(text)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 34)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(0, 180, 255)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 17
    l.TextXAlignment = Enum.TextXAlignment.Left
    local u = Instance.new("Frame", f)
    u.Size = UDim2.new(0.5, 0, 0, 3)
    u.Position = UDim2.new(0, 0, 1, -3)
    u.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    u.BorderSizePixel = 0
    Instance.new("UIGradient", u).Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 22))
    })
    return f
end

-- Helper: Toggle
local function Toggle(label, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.65, 0, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 62, 0, 28)
    btn.Position = UDim2.new(1, -76, 0.5, -14)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    local state = false
    local function Set(v)
        state = v
        btn.BackgroundColor3 = v and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(50, 50, 65)
        btn.Text = v and "ON" or "OFF"
        pcall(callback, v)
    end
    btn.MouseButton1Click:Connect(function() Set(not state) end)
    btn.MouseEnter:Connect(function() if not state then btn.BackgroundColor3 = Color3.fromRGB(70, 70, 85) end end)
    btn.MouseLeave:Connect(function() if not state then btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end end)
    return Set
end

-- Helper: Slider
local function Slider(label, min, max, default, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 68)
    f.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -24, 0, 26)
    l.Position = UDim2.new(0, 16, 0, 8)
    l.BackgroundTransparency = 1
    l.Text = label .. ": " .. tostring(default)
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    local bg = Instance.new("Frame", f)
    bg.Size = UDim2.new(1, -32, 0, 14)
    bg.Position = UDim2.new(0, 16, 0, 42)
    bg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 7)
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 7)
    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        l.Text = label .. ": " .. tostring(val)
        pcall(callback, val)
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return f
end

-- Helper: Button
local function Button(text, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1, -10, 0, 44)
    b.BackgroundColor3 = Color3.fromRGB(28, 30, 44)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(0, 180, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    b.MouseButton1Click:Connect(callback)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(38, 40, 54) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(28, 30, 44) end)
    return b
end

-- Helper: Dropdown
local Dropdowns = {}
local function Dropdown(label, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.38, 0, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.58, -10, 0, 32)
    btn.Position = UDim2.new(0.4, 0, 0.5, -16)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = "Select..."
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    local open = false
    local options = {}
    local function UpdateList(newOptions)
        for _, v in ipairs(options) do v:Destroy() end
        options = {}
        for i, opt in ipairs(newOptions) do
            local ob = Instance.new("TextButton", f)
            ob.Size = UDim2.new(0.58, -10, 0, 30)
            ob.Position = UDim2.new(0.4, 0, 0, 6 + (i * 34))
            ob.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
            ob.Text = opt
            ob.TextColor3 = Color3.fromRGB(210, 210, 220)
            ob.Font = Enum.Font.Gotham
            ob.TextSize = 13
            ob.Visible = false
            ob.AutoButtonColor = false
            Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 9)
            ob.MouseButton1Click:Connect(function()
                btn.Text = opt
                open = false
                f.Size = UDim2.new(1, -10, 0, 44)
                for _, b in ipairs(options) do b.Visible = false end
                pcall(callback, opt)
            end)
            table.insert(options, ob)
        end
    end
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            f.Size = UDim2.new(1, -10, 0, 44 + (#options * 34))
            for _, b in ipairs(options) do b.Visible = true end
        else
            f.Size = UDim2.new(1, -10, 0, 44)
            for _, b in ipairs(options) do b.Visible = false end
        end
    end)
    table.insert(Dropdowns, {Update=UpdateList, Btn=btn})
    return UpdateList
end

-- Helper: ColorPicker
local function ColorPicker(label, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 48)
    f.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 72, 0, 32)
    btn.Position = UDim2.new(1, -84, 0.5, -16)
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
    local colors = {
        Color3.fromRGB(0, 180, 255), Color3.fromRGB(255, 50, 80), Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(128, 0, 128)
    }
    local idx = 1
    btn.BackgroundColor3 = colors[idx]
    btn.MouseButton1Click:Connect(function()
        idx = idx % #colors + 1
        btn.BackgroundColor3 = colors[idx]
        pcall(callback, colors[idx])
    end)
    return f
end

-- Helper: Text Input
local function TextInput(label, placeholder, callback)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -10, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(20, 22, 34)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.3, 0, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = Color3.fromRGB(230, 230, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0.66, -16, 0, 30)
    box.Position = UDim2.new(0.32, 0, 0.5, -15)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    box.Text = ""
    box.PlaceholderText = placeholder
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 9)
    box.FocusLost:Connect(function(enter) if enter then pcall(callback, box.Text) end end)
    return f, box
end

-- States
local States = {
    Fly = false, FlySpeed = 50, NoClip = false, WalkSpeed = 16,
    ESP = false, ESPChams = false, ESPBox = false, ESPName = false,
    ESPSkeleton = false, ESPTracer = false, ESPColor = Color3.fromRGB(0, 180, 255),
    SilentAim = false, Aimbot = false, AimbotFOV = 120, AimbotSmoothness = 0.5,
    AimbotOnlyEnemy = false, MagicBullet = false,
    AntiAFK = false, FOV = 70, RainbowChar = false, GlassChar = false,
    ShowFPS = false, FlyCar = false, CarSpeed = 50, CarNoClip = false,
    FakeAdmin = false, FakeAdminColor = Color3.fromRGB(255, 0, 0),
    FakeOwner = false, FakeOwnerColor = Color3.fromRGB(255, 215, 0),
    TargetPlayer = "No Target", AmmoTarget = "No Target",
    GodMode = false, Invisible = false,
    TriggerBot = false, AmmoActive = false,
    SpectateActive = false, SpectatePlayer = "No Target"
}

-- Connections and ESP data
local ESPObjects = {}
local FPSLabel = nil
local AdminBillboard = nil
local OwnerBillboard = nil
local RainbowConn = nil
local GlassConn = nil
local AFKConn = nil
local AimbotConn = nil
local AmmoConn = nil
local ESPConn = nil
local FlyConn = nil
local NoClipConn = nil
local FlyCarConn = nil
local CarNoClipConn = nil
local GodModeConn = nil
local InvisibleConn = nil
local MagicBulletConn = nil
local TriggerBotConn = nil
local SpectateConn = nil
local FlyCarSet = nil
local CarNoClipSet = nil
local GodModeSet = nil
local InvisibleSet = nil
local FlySet = nil
local NoClipSet = nil
local AimbotSet = nil
local MagicBulletSet = nil
local TriggerBotSet = nil
local SpectateSet = nil

-- Utility
local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    if #names == 0 then table.insert(names, "No Target") end
    return names
end

local function FindPlayer(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() then return p end
    end
    return nil
end

local function UpdateAllDropdowns()
    local names = GetPlayerNames()
    for _, dd in ipairs(Dropdowns) do dd.Update(names) end
end
Players.PlayerAdded:Connect(function() task.wait(0.5); UpdateAllDropdowns() end)
Players.PlayerRemoving:Connect(UpdateAllDropdowns)

-- Kill System
local function KillPlayer(player)
    if not player or not player.Character then return end
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("kill") or n:find("hit") or n:find("hurt") then
                pcall(function()
                    if v:IsA("RemoteEvent") then v:FireServer(hum, 99999)
                    else v:InvokeServer(hum, 99999) end
                end)
            end
        end
    end
    pcall(function() char:BreakJoints() end)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.Velocity = Vector3.new(0, -9999, 0) end
end

-- ESP Clear
local function ClearESPForPlayer(p)
    if ESPObjects[p] then
        local e = ESPObjects[p]
        if e.Box and type(e.Box) == "table" and e.Box.Remove then e.Box:Remove() end
        if e.Name and type(e.Name) == "table" and e.Name.Remove then e.Name:Remove() end
        if e.Tracer and type(e.Tracer) == "table" and e.Tracer.Remove then e.Tracer:Remove() end
        if e.Skeleton then for _, line in ipairs(e.Skeleton) do if line.Remove then line:Remove() end end end
        if e.ChamsList then for _, v in ipairs(e.ChamsList) do v:Destroy() end end
        ESPObjects[p] = nil
    end
end
local function ClearAllESP()
    for p, _ in pairs(ESPObjects) do ClearESPForPlayer(p) end
    ESPObjects = {}
end

-- Fly
local function StartFly()
    if FlyConn then FlyConn:Disconnect() end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro", hrp); bg.Name = "F_Gyro"; bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    local bv = Instance.new("BodyVelocity", hrp); bv.Name = "F_Vel"; bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    FlyConn = RunService.RenderStepped:Connect(function()
        if not States.Fly then return end
        if not hrp.Parent then return end
        local cf = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * States.FlySpeed or Vector3.new()
        bg.CFrame = cf
    end)
end
local function StopFly()
    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if hrp then
            for _, v in ipairs(hrp:GetChildren()) do
                if v.Name == "F_Gyro" or v.Name == "F_Vel" then v:Destroy() end
            end
        end
    end
end

-- NoClip
local function StartNoClip()
    if NoClipConn then NoClipConn:Disconnect() end
    NoClipConn = RunService.Stepped:Connect(function()
        if not States.NoClip then return end
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end
local function StopNoClip()
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- GodMode (aggressive)
local function StartGodMode()
    if GodModeConn then GodModeConn:Disconnect() end
    local function heal(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Parent then hum.Health = hum.MaxHealth end
    end
    GodModeConn = RunService.Heartbeat:Connect(function()
        if not States.GodMode then return end
        local char = LocalPlayer.Character
        if char then heal(char) end
    end)
    LocalPlayer.CharacterAdded:Connect(function(c)
        if States.GodMode then task.wait(0.1); heal(c) end
    end)
    heal(LocalPlayer.Character)
end
local function StopGodMode()
    if GodModeConn then GodModeConn:Disconnect(); GodModeConn = nil end
end

-- Invisible (client only, but works on your test game)
local function ApplyInvisible(char)
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") then
                v.Transparency = 1
                v.CanCollide = false
                v.Material = Enum.Material.ForceField
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end)
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
end
local function StartInvisible()
    if InvisibleConn then InvisibleConn:Disconnect() end
    InvisibleConn = RunService.RenderStepped:Connect(function()
        if not States.Invisible then return end
        local char = LocalPlayer.Character
        if char then ApplyInvisible(char) end
    end)
    LocalPlayer.CharacterAdded:Connect(function(c)
        if States.Invisible then task.wait(0.1); ApplyInvisible(c) end
    end)
    ApplyInvisible(LocalPlayer.Character)
end
local function StopInvisible()
    if InvisibleConn then InvisibleConn:Disconnect(); InvisibleConn = nil end
end

-- FlyCar
local function StartFlyCar()
    if FlyCarConn then FlyCarConn:Disconnect() end
    FlyCarConn = RunService.RenderStepped:Connect(function()
        if not States.FlyCar then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local seat = hum.SeatPart
        if not seat or not seat:IsA("VehicleSeat") then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if not car then return end
        local primary = car.PrimaryPart or seat
        if not primary then return end
        local cf = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then
            primary.Velocity = dir.Unit * States.CarSpeed
            primary.RotVelocity = Vector3.new()
            primary.CFrame = CFrame.new(primary.Position, primary.Position + dir.Unit)
        else
            primary.Velocity = Vector3.new()
            primary.RotVelocity = Vector3.new()
        end
    end)
end
local function StopFlyCar()
    if FlyCarConn then FlyCarConn:Disconnect(); FlyCarConn = nil end
end

-- CarNoClip
local function StartCarNoClip()
    if CarNoClipConn then CarNoClipConn:Disconnect() end
    CarNoClipConn = RunService.Stepped:Connect(function()
        if not States.CarNoClip then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local seat = hum.SeatPart
        if not seat then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if car then
            for _, v in ipairs(car:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end
local function StopCarNoClip()
    if CarNoClipConn then CarNoClipConn:Disconnect(); CarNoClipConn = nil end
end

-- Magic Bullet
local function StartMagicBullet()
    if MagicBulletConn then MagicBulletConn:Disconnect() end
    MagicBulletConn = RunService.Heartbeat:Connect(function()
        if not States.MagicBullet then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Velocity.Magnitude > 10 then
                local name = obj.Name:lower()
                if name:find("bullet") or name:find("projectile") or name:find("shell") then
                    local closest, dist = nil, 500
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local head = p.Character:FindFirstChild("Head")
                            if head then
                                local d = (head.Position - obj.Position).Magnitude
                                if d < dist then
                                    if not States.AimbotOnlyEnemy or (LocalPlayer.Team and p.Team and LocalPlayer.Team ~= p.Team) then
                                        dist = d; closest = p
                                    end
                                end
                            end
                        end
                    end
                    if closest and closest.Character then
                        local head = closest.Character.Head
                        obj.CFrame = CFrame.new(head.Position)
                        obj.Velocity = Vector3.new()
                        obj.CanCollide = false
                    end
                end
            end
        end
    end)
end
local function StopMagicBullet()
    if MagicBulletConn then MagicBulletConn:Disconnect(); MagicBulletConn = nil end
end

-- TriggerBot
local function StartTriggerBot()
    if TriggerBotConn then TriggerBotConn:Disconnect() end
    TriggerBotConn = RunService.RenderStepped:Connect(function()
        if not States.TriggerBot then return end
        local closest, dist = nil, 120
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local head = p.Character:FindFirstChild("Head")
            if not head then continue end
            if States.AimbotOnlyEnemy then
                local myTeam = LocalPlayer.Team
                local theirTeam = p.Team
                if myTeam and theirTeam and myTeam == theirTeam then continue end
            end
            local pos, on = Camera:WorldToViewportPoint(head.Position)
            if on then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
        if closest then
            UserInputService:SendInputEvent(Enum.UserInputType.MouseButton1, true)
            task.wait(0.05)
            UserInputService:SendInputEvent(Enum.UserInputType.MouseButton1, false)
        end
    end)
end
local function StopTriggerBot()
    if TriggerBotConn then TriggerBotConn:Disconnect(); TriggerBotConn = nil end
end

-- Aimbot
local function StartAimbot()
    if AimbotConn then AimbotConn:Disconnect() end
    AimbotConn = RunService.RenderStepped:Connect(function()
        if not States.Aimbot then return end
        local closest, dist = nil, States.AimbotFOV
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local head = p.Character:FindFirstChild("Head")
            if not head then continue end
            if States.AimbotOnlyEnemy then
                local myTeam = LocalPlayer.Team
                local theirTeam = p.Team
                if myTeam and theirTeam and myTeam == theirTeam then continue end
            end
            local pos, on = Camera:WorldToViewportPoint(head.Position)
            if on then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
        if closest and closest.Character then
            local head = closest.Character.Head
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), States.AimbotSmoothness)
        end
    end)
end
local function StopAimbot()
    if AimbotConn then AimbotConn:Disconnect(); AimbotConn = nil end
end

-- Spectate
local function StartSpectate()
    if SpectateConn then SpectateConn:Disconnect() end
    if not States.SpectatePlayer or States.SpectatePlayer == "No Target" then return end
    local target = FindPlayer(States.SpectatePlayer)
    if target and target.Character then
        Camera.CameraSubject = target.Character
        Camera.CameraType = Enum.CameraType.Custom
    end
    local pitch, yaw = 0, 0
    SpectateConn = RunService.RenderStepped:Connect(function()
        if not States.SpectateActive then return end
        local t = FindPlayer(States.SpectatePlayer)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            local head = t.Character.Head
            local delta = UserInputService:GetMouseDelta()
            yaw = yaw - delta.X * 0.3
            pitch = math.clamp(pitch + delta.Y * 0.3, -80, 80)
            local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
            Camera.CFrame = CFrame.new(head.Position) * rot + rot.LookVector * -5
        end
    end)
end
local function StopSpectate()
    if SpectateConn then SpectateConn:Disconnect(); SpectateConn = nil end
    Camera.CameraSubject = LocalPlayer.Character
    Camera.CameraType = Enum.CameraType.Custom
end

-- ESP
local function GetSkeletonJoints(char)
    local joints = {}
    local function add(a,b)
        if char:FindFirstChild(a) and char:FindFirstChild(b) then
            table.insert(joints, {a,b})
        end
    end
    add("Head","Torso"); add("Torso","Left Arm"); add("Torso","Right Arm")
    add("Torso","Left Leg"); add("Torso","Right Leg")
    add("Head","UpperTorso"); add("UpperTorso","LowerTorso")
    add("UpperTorso","LeftUpperArm"); add("LeftUpperArm","LeftLowerArm"); add("LeftLowerArm","LeftHand")
    add("UpperTorso","RightUpperArm"); add("RightUpperArm","RightLowerArm"); add("RightLowerArm","RightHand")
    add("LowerTorso","LeftUpperLeg"); add("LeftUpperLeg","LeftLowerLeg"); add("LeftLowerLeg","LeftFoot")
    add("LowerTorso","RightUpperLeg"); add("RightUpperLeg","RightLowerLeg"); add("RightLowerLeg","RightFoot")
    return joints
end
local function StartESP()
    if ESPConn then ESPConn:Disconnect() end
    ESPConn = RunService.Heartbeat:Connect(function()
        if not States.ESP then
            for _, esp in pairs(ESPObjects) do
                if esp.Box then esp.Box.Visible = false end
                if esp.Name then esp.Name.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
                if esp.Skeleton then for _, line in ipairs(esp.Skeleton) do line.Visible = false end end
            end
            return
        end
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if not p.Character then ClearESPForPlayer(p); continue end
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then ClearESPForPlayer(p); continue end
            if (hrp.Position - myHRP.Position).Magnitude > 1500 then ClearESPForPlayer(p); continue end
            if not ESPObjects[p] then ESPObjects[p] = {} end
            local esp = ESPObjects[p]
            -- Chams
            if States.ESPChams then
                if not esp.ChamsList then
                    esp.ChamsList = {}
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = States.ESPColor
                            hl.OutlineColor = States.ESPColor
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0
                            hl.Parent = part
                            table.insert(esp.ChamsList, hl)
                        end
                    end
                end
                for _, v in ipairs(esp.ChamsList) do
                    if v:IsA("Highlight") then v.FillColor = States.ESPColor; v.OutlineColor = States.ESPColor end
                end
            elseif esp.ChamsList then
                for _, v in ipairs(esp.ChamsList) do v:Destroy() end
                esp.ChamsList = nil
            end
            -- Box
            if States.ESPBox then
                if not esp.Box then
                    esp.Box = Drawing.new("Square")
                    esp.Box.Thickness = 2
                    esp.Box.Filled = false
                end
                local pos, on = Camera:WorldToViewportPoint(hrp.Position)
                if on then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local hp = Camera:WorldToViewportPoint(head.Position)
                        local height = math.abs(hp.Y - pos.Y) + 15
                        local width = height * 0.6
                        esp.Box.Visible = true
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                        esp.Box.Color = States.ESPColor
                    else esp.Box.Visible = false end
                else esp.Box.Visible = false end
            elseif esp.Box then esp.Box.Visible = false end
            -- Name
            if States.ESPName then
                if not esp.Name then
                    esp.Name = Drawing.new("Text")
                    esp.Name.Size = 14
                    esp.Name.Outline = true
                    esp.Name.Center = true
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local pos, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    if on then
                        esp.Name.Visible = true
                        esp.Name.Position = Vector2.new(pos.X, pos.Y)
                        esp.Name.Text = p.Name
                        esp.Name.Color = States.ESPColor
                    else esp.Name.Visible = false end
                else esp.Name.Visible = false end
            elseif esp.Name then esp.Name.Visible = false end
            -- Skeleton
            if States.ESPSkeleton then
                if not esp.Skeleton then
                    esp.Skeleton = {}
                    local joints = GetSkeletonJoints(char)
                    for i = 1, #joints do
                        local line = Drawing.new("Line")
                        line.Thickness = 1.5
                        table.insert(esp.Skeleton, line)
                    end
                    esp.SkeletonJoints = joints
                end
                local joints = esp.SkeletonJoints
                for i, joint in ipairs(joints) do
                    local p1 = char:FindFirstChild(joint[1])
                    local p2 = char:FindFirstChild(joint[2])
                    local line = esp.Skeleton[i]
                    if line and p1 and p2 then
                        local pos1, on1 = Camera:WorldToViewportPoint(p1.Position)
                        local pos2, on2 = Camera:WorldToViewportPoint(p2.Position)
                        if on1 and on2 then
                            line.Visible = true
                            line.From = Vector2.new(pos1.X, pos1.Y)
                            line.To = Vector2.new(pos2.X, pos2.Y)
                            line.Color = States.ESPColor
                        else line.Visible = false end
                    elseif line then line.Visible = false end
                end
            elseif esp.Skeleton then
                for _, line in ipairs(esp.Skeleton) do line.Visible = false end
            end
            -- Tracer
            if States.ESPTracer then
                if not esp.Tracer then
                    esp.Tracer = Drawing.new("Line")
                    esp.Tracer.Thickness = 1
                end
                local pos, on = Camera:WorldToViewportPoint(hrp.Position)
                if on then
                    esp.Tracer.Visible = true
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                    esp.Tracer.Color = States.ESPColor
                else esp.Tracer.Visible = false end
            elseif esp.Tracer then esp.Tracer.Visible = false end
        end
    end)
end

-- Rainbow/Glass
local function StartRainbow()
    if RainbowConn then RainbowConn:Disconnect() end
    local hue = 0
    RainbowConn = RunService.RenderStepped:Connect(function()
        if not States.RainbowChar then return end
        hue = (hue + 0.01) % 1
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Color = Color3.fromHSV(hue, 1, 1) end
            end
        end
    end)
end
local function StopRainbow()
    if RainbowConn then RainbowConn:Disconnect(); RainbowConn = nil end
end
local function StartGlass()
    if GlassConn then GlassConn:Disconnect() end
    GlassConn = RunService.RenderStepped:Connect(function()
        if not States.GlassChar then return end
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.Transparency = 0.7; v.Material = Enum.Material.Glass end
            end
        end
    end)
end
local function StopGlass()
    if GlassConn then GlassConn:Disconnect(); GlassConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.Transparency = 0; v.Material = Enum.Material.Plastic end
        end
    end
end

-- AntiAFK
local function ToggleAntiAFK(v)
    States.AntiAFK = v
    if v then
        if AFKConn then AFKConn:Disconnect() end
        AFKConn = VirtualUser.Button2Down:Connect(function()
            VirtualUser.Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
    else
        if AFKConn then AFKConn:Disconnect(); AFKConn = nil end
    end
end

-- FPS
local function ToggleFPS(v)
    States.ShowFPS = v
    if v then
        if not FPSLabel then
            FPSLabel = Instance.new("TextLabel", GUI)
            FPSLabel.Size = UDim2.new(0, 120, 0, 30)
            FPSLabel.Position = UDim2.new(0, 10, 0, 10)
            FPSLabel.BackgroundTransparency = 1
            FPSLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
            FPSLabel.Font = Enum.Font.GothamBold
            FPSLabel.TextSize = 16
        end
        FPSLabel.Visible = true
        local last, frames = tick(), 0
        RunService.RenderStepped:Connect(function()
            if not States.ShowFPS then return end
            frames = frames + 1
            if tick() - last >= 1 then
                FPSLabel.Text = "FPS: " .. frames
                frames = 0; last = tick()
            end
        end)
    else
        if FPSLabel then FPSLabel.Visible = false end
    end
end

-- Fake Admin/Owner
local function UpdateFakeAdmin()
    if AdminBillboard then AdminBillboard:Destroy(); AdminBillboard = nil end
    if not States.FakeAdmin then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        AdminBillboard = Instance.new("BillboardGui")
        AdminBillboard.Size = UDim2.new(0, 120, 0, 30)
        AdminBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
        AdminBillboard.AlwaysOnTop = true
        AdminBillboard.Parent = char.Head
        local label = Instance.new("TextLabel", AdminBillboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = "[ADMIN]"
        label.TextColor3 = States.FakeAdminColor
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
    end
end
local function UpdateFakeOwner()
    if OwnerBillboard then OwnerBillboard:Destroy(); OwnerBillboard = nil end
    if not States.FakeOwner then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        OwnerBillboard = Instance.new("BillboardGui")
        OwnerBillboard.Size = UDim2.new(0, 120, 0, 30)
        OwnerBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
        OwnerBillboard.AlwaysOnTop = true
        OwnerBillboard.Parent = char.Head
        local label = Instance.new("TextLabel", OwnerBillboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = "[OWNER]"
        label.TextColor3 = States.FakeOwnerColor
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
    end
end

-- Ammo (troll)
local function ToggleAmmo(v)
    States.AmmoActive = v
    if v then
        if AmmoConn then AmmoConn:Disconnect() end
        local noclipConn
        AmmoConn = RunService.RenderStepped:Connect(function()
            if not States.AmmoActive then return end
            local target = FindPlayer(States.AmmoTarget)
            local myChar = LocalPlayer.Character
            if not target or not target.Character or not myChar then return end
            local head = target.Character:FindFirstChild("Head")
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not head or not myHRP then return end
            local targetPos = head.Position + head.CFrame.LookVector*0.6 + Vector3.new(0,1,0)
            local face = -head.CFrame.LookVector
            local cf = CFrame.new(targetPos, targetPos + face) * CFrame.new(0,0, math.sin(tick()*10)*0.3)
            myHRP.CFrame = cf
            myHRP.Velocity = Vector3.new()
            local hum = myChar:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
        end)
        noclipConn = RunService.Stepped:Connect(function()
            if not States.AmmoActive then return end
            local char = LocalPlayer.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
        AmmoConn = AmmoConn
    else
        if AmmoConn then AmmoConn:Disconnect(); AmmoConn = nil end
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- UI Creation
Section("MOVEMENT")
Slider("Walk Speed", 16, 500, 16, function(v)
    States.WalkSpeed = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)
Slider("Fly Speed", 10, 200, 50, function(v) States.FlySpeed = v end)
FlySet = Toggle("Fly", function(v) States.Fly = v; if v then StartFly() else StopFly() end end)
NoClipSet = Toggle("NoClip", function(v) States.NoClip = v; if v then StartNoClip() else StopNoClip() end end)

Section("TELEPORT")
local tpUpd = Dropdown("Teleport Target", function(sel) States.TargetPlayer = sel end)
tpUpd(GetPlayerNames())
Button("Teleport to Target", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Target" then
        local target = FindPlayer(States.TargetPlayer)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and target.Character and myHRP then
            local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then myHRP.CFrame = tHRP.CFrame + Vector3.new(0,3,0) end
        end
    end
end)
Button("Teleport to Car", function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") or v:IsA("Seat") then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then myHRP.CFrame = v.CFrame + Vector3.new(0,3,0); break end
        end
    end
end)
local pullUpd = Dropdown("Pull Player", function(sel) States.TargetPlayer = sel end)
pullUpd(GetPlayerNames())
Button("Pull Player", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Target" then
        local target = FindPlayer(States.TargetPlayer)
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and target.Character and myHRP then
            local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then tHRP.CFrame = myHRP.CFrame + Vector3.new(0,3,0) end
        end
    end
end)

Section("ESP")
Toggle("Enable ESP", function(v) States.ESP = v; if not v then ClearAllESP() end end)
Toggle("Chams", function(v) States.ESPChams = v end)
Toggle("Box", function(v) States.ESPBox = v end)
Toggle("Name", function(v) States.ESPName = v end)
Toggle("Skeleton", function(v) States.ESPSkeleton = v end)
Toggle("Tracer", function(v) States.ESPTracer = v end)
ColorPicker("ESP Color", function(c) States.ESPColor = c end)
StartESP()

Section("COMBAT")
Toggle("Silent Aim", function(v) States.SilentAim = v end)
AimbotSet = Toggle("Aimbot", function(v) States.Aimbot = v; if v then StartAimbot() else StopAimbot() end end)
Toggle("Only Enemy", function(v) States.AimbotOnlyEnemy = v end)
Slider("Aimbot FOV", 30, 300, 120, function(v) States.AimbotFOV = v end)
Slider("Aimbot Smooth", 1, 100, 50, function(v) States.AimbotSmoothness = v/100 end)
MagicBulletSet = Toggle("Magic Bullet", function(v) States.MagicBullet = v; if v then StartMagicBullet() else StopMagicBullet() end end)
TriggerBotSet = Toggle("TriggerBot", function(v) States.TriggerBot = v; if v then StartTriggerBot() else StopTriggerBot() end end)
local killUpd = Dropdown("Kill Target", function(sel) States.TargetPlayer = sel end)
killUpd(GetPlayerNames())
Button("Kill Target", function() if States.TargetPlayer and States.TargetPlayer ~= "No Target" then KillPlayer(FindPlayer(States.TargetPlayer)) end end)
Button("Kill All", function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then KillPlayer(p) end end end)

Section("SPECTATE")
local specUpd = Dropdown("Spectate Player", function(sel) States.SpectatePlayer = sel end)
specUpd(GetPlayerNames())
SpectateSet = Toggle("Spectate", function(v) States.SpectateActive = v; if v then StartSpectate() else StopSpectate() end end)

Section("CHARACTER")
GodModeSet = Toggle("God Mode", function(v) States.GodMode = v; if v then StartGodMode() else StopGodMode() end end)
InvisibleSet = Toggle("Invisible", function(v) States.Invisible = v; if v then StartInvisible() else StopInvisible() end end)
Toggle("Rainbow Character", function(v) States.RainbowChar = v; if v then StartRainbow() else StopRainbow() end end)
Toggle("Glass Character", function(v) States.GlassChar = v; if v then StartGlass() else StopGlass() end end)

Section("CAR")
FlyCarSet = Toggle("Fly Car", function(v) States.FlyCar = v; if v then StartFlyCar() else StopFlyCar() end end)
CarNoClipSet = Toggle("Car NoClip", function(v) States.CarNoClip = v; if v then StartCarNoClip() else StopCarNoClip() end end)
Slider("Car Speed", 50, 500, 50, function(v) States.CarSpeed = v end)

Section("TROLL")
local ammoUpd = Dropdown("Ammo Target", function(sel) States.AmmoTarget = sel end)
ammoUpd(GetPlayerNames())
Toggle("Ammo (Glitch)", ToggleAmmo)
Button("Kill Ammo Target", function()
    if States.AmmoTarget and States.AmmoTarget ~= "No Target" then
        KillPlayer(FindPlayer(States.AmmoTarget))
    end
end)

Section("FAKE TAGS")
Toggle("Fake Admin", function(v) States.FakeAdmin = v; UpdateFakeAdmin() end)
ColorPicker("Admin Color", function(c) States.FakeAdminColor = c; if AdminBillboard then local lbl = AdminBillboard:FindFirstChildOfClass("TextLabel"); if lbl then lbl.TextColor3 = c end end end)
Toggle("Fake Owner", function(v) States.FakeOwner = v; UpdateFakeOwner() end)
ColorPicker("Owner Color", function(c) States.FakeOwnerColor = c; if OwnerBillboard then local lbl = OwnerBillboard:FindFirstChildOfClass("TextLabel"); if lbl then lbl.TextColor3 = c end end end)

Section("UTILITY")
Toggle("Anti AFK", ToggleAntiAFK)
Slider("FOV Changer", 30, 120, 70, function(v) States.FOV = v; Camera.FieldOfView = v end)
Toggle("Show FPS", ToggleFPS)
Button("Reset Character", function()
    LocalPlayer.Character = nil
    LocalPlayer.Character = LocalPlayer.CharacterAdded:Wait()
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    if States.Fly then StartFly() end
    if States.NoClip then StartNoClip() end
    if States.Aimbot then StartAimbot() end
    if States.GodMode then StartGodMode() end
    if States.Invisible then StartInvisible() end
    if States.FlyCar then StartFlyCar() end
    if States.CarNoClip then StartCarNoClip() end
    if States.MagicBullet then StartMagicBullet() end
    if States.TriggerBot then StartTriggerBot() end
    if States.SpectateActive then StartSpectate() end
    if States.FakeAdmin then UpdateFakeAdmin() end
    if States.FakeOwner then UpdateFakeOwner() end
    ClearAllESP()
end)

-- Insert toggle
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)

-- Splash
local splash = Instance.new("TextLabel", GUI)
splash.Size = UDim2.new(0, 400, 0, 50)
splash.Position = UDim2.new(0.5, -200, 0, 30)
splash.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
splash.Text = "VISITING SOFTWARE v3 | INSERT"
splash.TextColor3 = Color3.fromRGB(0, 180, 255)
splash.Font = Enum.Font.GothamBold
splash.TextSize = 18
Instance.new("UICorner", splash).CornerRadius = UDim.new(0, 14)
Shadow(splash, UDim2.new(1, 40, 1, 40), UDim2.new(0.5, 0, 0.5, 0), 0.6)
task.delay(4, function() splash:Destroy() end)

print("VISITING SOFTWARE v3 loaded - Test environment ready.")
