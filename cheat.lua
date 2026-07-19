-- ============================================
-- intabazaki.lua v3.0
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================
-- GUI SETUP
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheatTestMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "intabazaki.lua"
TitleText.TextColor3 = Color3.fromRGB(220, 20, 60)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.Parent = TitleBar

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 20, 60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2500)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function CreateSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = text
    section.TextColor3 = Color3.fromRGB(220, 20, 60)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 14
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = ScrollFrame
    return section
end

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = frame
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 22)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = toggleBtn
    local enabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggleBtn.Text = "OFF"
        end
        callback(enabled)
    end)
    return frame, toggleBtn
end

local function CreateSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 2)
    label.Parent = frame
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (pos * (max - min)))
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
        callback(value)
    end
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return frame
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 20, 60)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local DropdownFrames = {}
local function CreateDynamicDropdown(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = frame
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.45, 0, 0, 24)
    dropdownBtn.Position = UDim2.new(0.52, 0, 0, 3)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownBtn.Text = "Select..."
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    dropdownBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = dropdownBtn
    local open = false
    local optionButtons = {}
    local currentOptions = {}
    local function UpdateOptions(options)
        for _, btn in ipairs(optionButtons) do
            btn:Destroy()
        end
        optionButtons = {}
        currentOptions = options
        for i, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(0.45, 0, 0, 24)
            optBtn.Position = UDim2.new(0.52, 0, 0, 3 + (i * 26))
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 12
            optBtn.Visible = false
            optBtn.Parent = frame
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                open = false
                frame.Size = UDim2.new(1, -10, 0, 30)
                for _, b in ipairs(optionButtons) do
                    b.Visible = false
                end
                callback(option)
            end)
            table.insert(optionButtons, optBtn)
        end
    end
    dropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            frame.Size = UDim2.new(1, -10, 0, 30 + (#currentOptions * 26))
            for _, b in ipairs(optionButtons) do
                b.Visible = true
            end
        else
            frame.Size = UDim2.new(1, -10, 0, 30)
            for _, b in ipairs(optionButtons) do
                b.Visible = false
            end
        end
    end)
    table.insert(DropdownFrames, {Frame = frame, Update = UpdateOptions, Btn = dropdownBtn})
    return frame, UpdateOptions
end

local function CreateColorPicker(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = frame
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 60, 0, 24)
    colorBtn.Position = UDim2.new(1, -70, 0.5, -12)
    colorBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    colorBtn.Text = ""
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = colorBtn
    local colors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(128, 0, 128)
    }
    local colorIndex = 1
    colorBtn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        colorBtn.BackgroundColor3 = colors[colorIndex]
        callback(colors[colorIndex])
    end)
    return frame
end

-- ============================================
-- STATE VARIABLES
-- ============================================
local States = {
    Fly = false, FlySpeed = 50, NoClip = false, WalkSpeed = 16,
    ESP = false, ESPChams = false, ESPBox = false, ESPName = false,
    ESPSkeleton = false, ESPTracer = false, ESPColor = Color3.fromRGB(255, 0, 0),
    SilentAim = false, Aimbot = false, AimbotFOV = 100, AimbotSmoothness = 0.5,
    AntiAFK = false, FOV = 70, RainbowChar = false, GlassChar = false,
    ShowFPS = false, FlyCar = false, CarSpeed = 50, CarNoClip = false,
    FakeAdmin = false, FakeAdminColor = Color3.fromRGB(255, 0, 0),
    FakeOwner = false, FakeOwnerColor = Color3.fromRGB(255, 215, 0),
    ChatAdmin = false, ChatOwner = false, TargetPlayer = nil, AmmoActive = false
}

local ESPObjects = {}
local FPSLabel = nil
local AdminBillboard = nil
local OwnerBillboard = nil
local RainbowConnection = nil
local GlassConnection = nil
local AFKConnection = nil
local AimbotConnection = nil
local AmmoConnection = nil
local ESPConnection = nil
local FlyWasEnabled = false

-- ============================================
-- PLAYER LIST HELPERS
-- ============================================
local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    if #names == 0 then
        table.insert(names, "No Players")
    end
    return names
end

local function GetPlayerByName(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == name then
            return p
        end
    end
    return nil
end

local function UpdateAllDropdowns()
    local names = GetPlayerNames()
    for _, dd in ipairs(DropdownFrames) do
        dd.Update(names)
    end
end

Players.PlayerAdded:Connect(function()
    task.delay(0.5, UpdateAllDropdowns)
end)

Players.PlayerRemoving:Connect(function()
    task.delay(0.5, UpdateAllDropdowns)
end)

-- ============================================
-- ESP CLEANUP
-- ============================================
local function ClearESPForPlayer(player)
    if ESPObjects[player] then
        local esp = ESPObjects[player]
        if esp.Box and typeof(esp.Box) == "table" and esp.Box.Remove then
            esp.Box:Remove()
        end
        if esp.Name and typeof(esp.Name) == "table" and esp.Name.Remove then
            esp.Name:Remove()
        end
        if esp.Tracer and typeof(esp.Tracer) == "table" and esp.Tracer.Remove then
            esp.Tracer:Remove()
        end
        if esp.Skeleton then
            for _, line in ipairs(esp.Skeleton) do
                if typeof(line) == "table" and line.Remove then
                    line:Remove()
                end
            end
        end
        if esp.ChamsList then
            for _, v in ipairs(esp.ChamsList) do
                if typeof(v) == "Instance" then
                    v:Destroy()
                end
            end
        end
        ESPObjects[player] = nil
    end
end

local function ClearAllESP()
    for player, _ in pairs(ESPObjects) do
        ClearESPForPlayer(player)
    end
    ESPObjects = {}
end

-- ============================================
-- MOVEMENT TESTS
-- ============================================
CreateSection("MOVEMENT TESTS")

CreateSlider("WalkSpeed", 16, 500, 16, function(val)
    States.WalkSpeed = val
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = val
        end
    end
end)

CreateSlider("Fly Speed", 10, 200, 50, function(val)
    States.FlySpeed = val
end)

CreateToggle("Fly", function(enabled)
    States.Fly = enabled
    FlyWasEnabled = enabled
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if enabled then
        hum.PlatformStand = true
        local bg = Instance.new("BodyGyro")
        bg.Name = "ACFlyGyro"
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
        local bv = Instance.new("BodyVelocity")
        bv.Name = "ACFlyVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
        local flyConn
        flyConn = RunService.RenderStepped:Connect(function()
            if not States.Fly then
                flyConn:Disconnect()
                return
            end
            if not hrp or not hrp.Parent then
                flyConn:Disconnect()
                return
            end
            local camCF = Camera.CFrame
            local dir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                dir = dir - Vector3.new(0, 1, 0)
            end
            if dir.Magnitude > 0 then
                dir = dir.Unit * States.FlySpeed
            end
            bv.Velocity = dir
            bg.CFrame = camCF
        end)
    else
        hum.PlatformStand = false
        for _, v in ipairs(hrp:GetChildren()) do
            if v.Name == "ACFlyGyro" or v.Name == "ACFlyVelocity" then
                v:Destroy()
            end
        end
    end
end)

CreateToggle("NoClip", function(enabled)
    States.NoClip = enabled
    local char = LocalPlayer.Character
    if not char then return end
    if enabled then
        local noclipConn
        noclipConn = RunService.Stepped:Connect(function()
            if not States.NoClip then
                noclipConn:Disconnect()
                return
            end
            if not char or not char.Parent then
                noclipConn:Disconnect()
                return
            end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ============================================
-- TELEPORT TESTS
-- ============================================
CreateSection("TELEPORT TESTS")

local playerNames = GetPlayerNames()
local teleportDropdown, updateTeleportDropdown = CreateDynamicDropdown("Teleport Target", function(selected)
    States.TargetPlayer = selected
end)
updateTeleportDropdown(playerNames)

CreateButton("Teleport to Target", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Players" then
        local target = GetPlayerByName(States.TargetPlayer)
        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and myHRP then
                myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end)

CreateButton("Teleport to Car", function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") or v:IsA("Seat") then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then
                myHRP.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                break
            end
        end
    end
end)

-- ============================================
-- ESP TESTS
-- ============================================
CreateSection("ESP TESTS")

CreateToggle("Enable ESP", function(enabled)
    States.ESP = enabled
    if not enabled then
        ClearAllESP()
    end
end)

CreateToggle("Chams ESP", function(enabled)
    States.ESPChams = enabled
    if not enabled then
        for player, esp in pairs(ESPObjects) do
            if esp.ChamsList then
                for _, v in ipairs(esp.ChamsList) do
                    if typeof(v) == "Instance" then
                        v:Destroy()
                    end
                end
                esp.ChamsList = nil
            end
        end
    end
end)

CreateToggle("Box ESP", function(enabled)
    States.ESPBox = enabled
    if not enabled then
        for player, esp in pairs(ESPObjects) do
            if esp.Box and typeof(esp.Box) == "table" and esp.Box.Remove then
                esp.Box:Remove()
                esp.Box = nil
            end
        end
    end
end)

CreateToggle("Name ESP", function(enabled)
    States.ESPName = enabled
    if not enabled then
        for player, esp in pairs(ESPObjects) do
            if esp.Name and typeof(esp.Name) == "table" and esp.Name.Remove then
                esp.Name:Remove()
                esp.Name = nil
            end
        end
    end
end)

CreateToggle("Skeleton ESP", function(enabled)
    States.ESPSkeleton = enabled
    if not enabled then
        for player, esp in pairs(ESPObjects) do
            if esp.Skeleton then
                for _, line in ipairs(esp.Skeleton) do
                    if typeof(line) == "table" and line.Remove then
                        line:Remove()
                    end
                end
                esp.Skeleton = nil
            end
        end
    end
end)

CreateToggle("Tracer ESP", function(enabled)
    States.ESPTracer = enabled
    if not enabled then
        for player, esp in pairs(ESPObjects) do
            if esp.Tracer and typeof(esp.Tracer) == "table" and esp.Tracer.Remove then
                esp.Tracer:Remove()
                esp.Tracer = nil
            end
        end
    end
end)

CreateColorPicker("ESP Color", function(color)
    States.ESPColor = color
end)

local SkeletonJoints = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

if ESPConnection then ESPConnection:Disconnect() end
ESPConnection = RunService.RenderStepped:Connect(function()
    if not States.ESP then
        for player, esp in pairs(ESPObjects) do
            if esp.Box and typeof(esp.Box) == "table" then
                esp.Box.Visible = false
            end
            if esp.Name and typeof(esp.Name) == "table" then
                esp.Name.Visible = false
            end
            if esp.Tracer and typeof(esp.Tracer) == "table" then
                esp.Tracer.Visible = false
            end
            if esp.Skeleton then
                for _, line in ipairs(esp.Skeleton) do
                    if typeof(line) == "table" then
                        line.Visible = false
                    end
                end
            end
        end
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not p.Character then
            ClearESPForPlayer(p)
            continue
        end
        local char = p.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            ClearESPForPlayer(p)
            continue
        end
        if not ESPObjects[p] then
            ESPObjects[p] = {}
        end
        local esp = ESPObjects[p]
        if States.ESPChams then
            if not esp.ChamsList then
                esp.ChamsList = {}
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ACESPHighlight"
                        highlight.FillColor = States.ESPColor
                        highlight.OutlineColor = States.ESPColor
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = part
                        table.insert(esp.ChamsList, highlight)
                    end
                end
            end
            for _, v in ipairs(esp.ChamsList) do
                if v:IsA("Highlight") then
                    v.FillColor = States.ESPColor
                    v.OutlineColor = States.ESPColor
                end
            end
        else
            if esp.ChamsList then
                for _, v in ipairs(esp.ChamsList) do
                    if typeof(v) == "Instance" then
                        v:Destroy()
                    end
                end
                esp.ChamsList = nil
            end
        end
        if States.ESPBox then
            if not esp.Box then
                local box = Drawing.new("Square")
                box.Visible = false
                box.Thickness = 2
                box.Color = States.ESPColor
                box.Filled = false
                esp.Box = box
            end
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local head = char:FindFirstChild("Head")
                local root = hrp
                if head and root then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local rootPos = Camera:WorldToViewportPoint(root.Position)
                    local height = math.abs(headPos.Y - rootPos.Y) + 15
                    local width = height * 0.6
                    esp.Box.Visible = true
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                    esp.Box.Color = States.ESPColor
                else
                    esp.Box.Visible = false
                end
            else
                esp.Box.Visible = false
            end
        elseif esp.Box then
            esp.Box.Visible = false
        end
        if States.ESPName then
            if not esp.Name then
                local name = Drawing.new("Text")
                name.Visible = false
                name.Size = 14
                name.Color = States.ESPColor
                name.Center = true
                name.Outline = true
                esp.Name = name
            end
            local head = char:FindFirstChild("Head")
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                if onScreen then
                    esp.Name.Visible = true
                    esp.Name.Position = Vector2.new(pos.X, pos.Y)
                    esp.Name.Text = p.Name
                    esp.Name.Color = States.ESPColor
                else
                    esp.Name.Visible = false
                end
            else
                esp.Name.Visible = false
            end
        elseif esp.Name then
            esp.Name.Visible = false
        end
        if States.ESPSkeleton then
            if not esp.Skeleton then
                esp.Skeleton = {}
                for i = 1, #SkeletonJoints do
                    local line = Drawing.new("Line")
                    line.Visible = false
                    line.Thickness = 1.5
                    line.Color = States.ESPColor
                    table.insert(esp.Skeleton, line)
                end
            end
            for i, joint in ipairs(SkeletonJoints) do
                local part1 = char:FindFirstChild(joint[1])
                local part2 = char:FindFirstChild(joint[2])
                local line = esp.Skeleton[i]
                if part1 and part2 then
                    local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                    local pos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                    if onScreen1 and onScreen2 then
                        line.Visible = true
                        line.From = Vector2.new(pos1.X, pos1.Y)
                        line.To = Vector2.new(pos2.X, pos2.Y)
                        line.Color = States.ESPColor
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        elseif esp.Skeleton then
            for _, line in ipairs(esp.Skeleton) do
                line.Visible = false
            end
        end
        if States.ESPTracer then
            if not esp.Tracer then
                local tracer = Drawing.new("Line")
                tracer.Visible = false
                tracer.Thickness = 1
                tracer.Color = States.ESPColor
                esp.Tracer = tracer
            end
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                esp.Tracer.Visible = true
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                esp.Tracer.Color = States.ESPColor
            else
                esp.Tracer.Visible = false
            end
        elseif esp.Tracer then
            esp.Tracer.Visible = false
        end
    end
    for player, _ in pairs(ESPObjects) do
        if not player.Parent then
            ClearESPForPlayer(player)
        end
    end
end)

-- ============================================
-- COMBAT TESTS
-- ============================================
CreateSection("COMBAT TESTS")

CreateToggle("Silent Aim", function(enabled)
    States.SilentAim = enabled
end)

CreateToggle("Aimbot", function(enabled)
    States.Aimbot = enabled
    if enabled then
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not States.Aimbot then return end
            local closestPlayer = nil
            local closestDistance = States.AimbotFOV
            local mousePos = UserInputService:GetMouseLocation()
            for _, p in ipairs(Players:GetPlayers()) do
                if p == LocalPlayer then continue end
                if not p.Character then continue end
                local head = p.Character:FindFirstChild("Head")
                if not head then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = p
                    end
                end
            end
            if closestPlayer and closestPlayer.Character then
                local head = closestPlayer.Character:FindFirstChild("Head")
                if head then
                    local targetCF = CFrame.new(Camera.CFrame.Position, head.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, States.AimbotSmoothness)
                end
            end
        end)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
    end
end)

CreateSlider("Aimbot FOV", 30, 300, 100, function(val)
    States.AimbotFOV = val
end)

CreateSlider("Aimbot Smooth", 1, 100, 50, function(val)
    States.AimbotSmoothness = val / 100
end)

local killTargetDropdown, updateKillDropdown = CreateDynamicDropdown("Kill Target", function(selected)
    States.TargetPlayer = selected
end)
updateKillDropdown(playerNames)

CreateButton("Kill Target", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Players" then
        local target = GetPlayerByName(States.TargetPlayer)
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
        end
    end
end)

CreateButton("Kill All", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
        end
    end
end)

-- ============================================
-- UTILITY TESTS
-- ============================================
CreateSection("UTILITY TESTS")

CreateToggle("Anti AFK", function(enabled)
    States.AntiAFK = enabled
    if enabled then
        if AFKConnection then AFKConnection:Disconnect() end
        AFKConnection = VirtualUser.Button2Down:Connect(function()
            VirtualUser.Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end)
    else
        if AFKConnection then
            AFKConnection:Disconnect()
            AFKConnection = nil
        end
    end
end)

CreateSlider("FOV Changer", 30, 120, 70, function(val)
    States.FOV = val
    Camera.FieldOfView = val
end)

CreateToggle("Show FPS", function(enabled)
    States.ShowFPS = enabled
    if enabled then
        if not FPSLabel then
            FPSLabel = Instance.new("TextLabel")
            FPSLabel.Size = UDim2.new(0, 100, 0, 25)
            FPSLabel.Position = UDim2.new(0, 10, 0, 10)
            FPSLabel.BackgroundTransparency = 1
            FPSLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
            FPSLabel.Font = Enum.Font.GothamBold
            FPSLabel.TextSize = 14
            FPSLabel.Parent = ScreenGui
        end
        FPSLabel.Visible = true
        local lastTime = tick()
        local frameCount = 0
        RunService.RenderStepped:Connect(function()
            if not States.ShowFPS then return end
            frameCount = frameCount + 1
            local currentTime = tick()
            if currentTime - lastTime >= 1 then
                FPSLabel.Text = "FPS: " .. tostring(frameCount)
                frameCount = 0
                lastTime = currentTime
            end
        end)
    else
        if FPSLabel then
            FPSLabel.Visible = false
        end
    end
end)

-- ============================================
-- CHARACTER TESTS
-- ============================================
CreateSection("CHARACTER TESTS")

CreateToggle("Rainbow Character", function(enabled)
    States.RainbowChar = enabled
    if enabled then
        if RainbowConnection then RainbowConnection:Disconnect() end
        local hue = 0
        RainbowConnection = RunService.RenderStepped:Connect(function()
            if not States.RainbowChar then return end
            hue = (hue + 0.01) % 1
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(hue, 1, 1)
                    end
                end
            end
        end)
    else
        if RainbowConnection then
            RainbowConnection:Disconnect()
            RainbowConnection = nil
        end
    end
end)

CreateToggle("Glass Character", function(enabled)
    States.GlassChar = enabled
    if enabled then
        if GlassConnection then GlassConnection:Disconnect() end
        GlassConnection = RunService.RenderStepped:Connect(function()
            if not States.GlassChar then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.7
                        part.Material = Enum.Material.Glass
                    end
                end
            end
        end)
    else
        if GlassConnection then
            GlassConnection:Disconnect()
            GlassConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)

-- ============================================
-- FAKE TAGS TESTS
-- ============================================
CreateSection("FAKE TAGS TESTS")

CreateToggle("Fake Admin", function(enabled)
    States.FakeAdmin = enabled
    if enabled then
        local char = LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                if AdminBillboard then AdminBillboard:Destroy() end
                AdminBillboard = Instance.new("BillboardGui")
                AdminBillboard.Name = "ACFakeAdmin"
                AdminBillboard.Size = UDim2.new(0, 100, 0, 30)
                AdminBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
                AdminBillboard.AlwaysOnTop = true
                AdminBillboard.Parent = head
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "[ADMIN]"
                label.TextColor3 = States.FakeAdminColor
                label.Font = Enum.Font.GothamBold
                label.TextSize = 16
                label.Parent = AdminBillboard
            end
        end
    else
        if AdminBillboard then
            AdminBillboard:Destroy()
            AdminBillboard = nil
        end
    end
end)

CreateColorPicker("Admin Color", function(color)
    States.FakeAdminColor = color
    if AdminBillboard then
        local label = AdminBillboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.TextColor3 = color
        end
    end
end)

CreateToggle("Fake Owner", function(enabled)
    States.FakeOwner = enabled
    if enabled then
        local char = LocalPlayer.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head then
                if OwnerBillboard then OwnerBillboard:Destroy() end
                OwnerBillboard = Instance.new("BillboardGui")
                OwnerBillboard.Name = "ACFakeOwner"
                OwnerBillboard.Size = UDim2.new(0, 100, 0, 30)
                OwnerBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
                OwnerBillboard.AlwaysOnTop = true
                OwnerBillboard.Parent = head
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "[OWNER]"
                label.TextColor3 = States.FakeOwnerColor
                label.Font = Enum.Font.GothamBold
                label.TextSize = 16
                label.Parent = OwnerBillboard
            end
        end
    else
        if OwnerBillboard then
            OwnerBillboard:Destroy()
            OwnerBillboard = nil
        end
    end
end)

CreateColorPicker("Owner Color", function(color)
    States.FakeOwnerColor = color
    if OwnerBillboard then
        local label = OwnerBillboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.TextColor3 = color
        end
    end
end)

CreateToggle("Chat Admin", function(enabled)
    States.ChatAdmin = enabled
end)

CreateToggle("Chat Owner", function(enabled)
    States.ChatOwner = enabled
end)

-- ============================================
-- CAR TESTS
-- ============================================
CreateSection("CAR TESTS")

CreateToggle("Fly Car", function(enabled)
    States.FlyCar = enabled
    if enabled then
        local flyCarConn
        flyCarConn = RunService.RenderStepped:Connect(function()
            if not States.FlyCar then
                flyCarConn:Disconnect()
                return
            end
            local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local car = seat:FindFirstAncestorOfClass("Model")
                if car then
                    local primary = car.PrimaryPart or car:FindFirstChild(" chassis") or car:FindFirstChild("VehicleSeat")
                    if primary then
                        local camCF = Camera.CFrame
                        local dir = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            dir = dir + camCF.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            dir = dir - camCF.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            dir = dir + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            dir = dir - Vector3.new(0, 1, 0)
                        end
                        if dir.Magnitude > 0 then
                            primary.Velocity = dir.Unit * States.FlySpeed
                        end
                    end
                end
            end
        end)
    end
end)

CreateToggle("Car NoClip", function(enabled)
    States.CarNoClip = enabled
    if enabled then
        local carNoclipConn
        carNoclipConn = RunService.Stepped:Connect(function()
            if not States.CarNoClip then
                carNoclipConn:Disconnect()
                return
            end
            local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").SeatPart
            if seat then
                local car = seat:FindFirstAncestorOfClass("Model")
                if car then
                    for _, part in ipairs(car:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

CreateSlider("Car Speed", 50, 500, 50, function(val)
    States.CarSpeed = val
end)

-- ============================================
-- TROLL TESTS - AMMO (FIXED POSITIONING)
-- ============================================
CreateSection("TROLL TESTS")

-- Dropdown Tanımlaması
local ammoTargetDropdown, updateAmmoDropdown = CreateDynamicDropdown("Ammo Target", function(selected)
    States.TargetPlayer = selected
end)
-- Oyunculari güncelle
updateAmmoDropdown(playerNames)

-- Toggle Tanımlaması
CreateToggle("Ammo", function(enabled)
    States.AmmoActive = enabled
    if enabled then
        if AmmoConnection then AmmoConnection:Disconnect() end
        
        -- Noclip döngüsü
        local ammoNoclipConn = RunService.Stepped:Connect(function()
            if not States.AmmoActive then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)

        -- Ana Pozisyonlama Döngüsü
        AmmoConnection = RunService.RenderStepped:Connect(function()
            if not States.AmmoActive then
                if ammoNoclipConn then ammoNoclipConn:Disconnect() end
                return
            end

            local target = GetPlayerByName(States.TargetPlayer)
            local myChar = LocalPlayer.Character
            if not target or not target.Character or not myChar then return end
            
            local targetHead = target.Character:FindFirstChild("Head")
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not targetHead or not myHRP then return end

            -- HESAPLAMA: Gövde-Bacak birleşimi hedefli
            local frontOffset = targetHead.CFrame.LookVector * 0.7 
            -- HRP merkezini aşağı çekiyoruz ki gövde/bacak birleşimi hizalansın
            local heightOffset = Vector3.new(0, -0, 0)
            local targetPosition = targetHead.Position + frontOffset + heightOffset

            -- Karakteri hedefe döndür ve 180 derece ile yüzünü çevir
            local baseCF = CFrame.lookAt(targetPosition, targetHead.Position) * CFrame.Angles(0, math.rad(0), 0)
            
            -- İleri-geri hareket
            local thrustOffset = math.sin(tick() * 10) * 0.3
            baseCF = baseCF * CFrame.new(0, 0, thrustOffset)

            myHRP.CFrame = baseCF
            myHRP.Velocity = Vector3.zero
            
            local hum = myChar:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = true
                hum.Sit = false
            end
        end)
    else
        if AmmoConnection then AmmoConnection:Disconnect() end
        -- Kapatıldığında eski hale döndür
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end) burda local myheight diye biryer yokki

-- ============================================
-- CLEANUP ON DEATH
-- ============================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    if FlyWasEnabled then
        task.delay(0.5, function()
            if FlyWasEnabled and not States.Fly then
                local hum = newChar:FindFirstChildOfClass("Humanoid")
                local hrp = newChar:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    States.Fly = true
                    hum.PlatformStand = true
                    local bg = Instance.new("BodyGyro")
                    bg.Name = "ACFlyGyro"
                    bg.P = 9e4
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.CFrame = hrp.CFrame
                    bg.Parent = hrp
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "ACFlyVelocity"
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Parent = hrp
                    local flyConn
                    flyConn = RunService.RenderStepped:Connect(function()
                        if not States.Fly then
                            flyConn:Disconnect()
                            return
                        end
                        if not hrp or not hrp.Parent then
                            flyConn:Disconnect()
                            return
                        end
                        local camCF = Camera.CFrame
                        local dir = Vector3.new(0, 0, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            dir = dir + camCF.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            dir = dir - camCF.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            dir = dir - camCF.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            dir = dir + camCF.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            dir = dir + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            dir = dir - Vector3.new(0, 1, 0)
                        end
                        if dir.Magnitude > 0 then
                            dir = dir.Unit * States.FlySpeed
                        end
                        bv.Velocity = dir
                        bg.CFrame = camCF
                    end)
                end
            end
        end)
    end

    States.NoClip = false
    States.AmmoActive = false
    States.Aimbot = false

    ClearAllESP()

    if AdminBillboard then
        AdminBillboard:Destroy()
        AdminBillboard = nil
    end
    if OwnerBillboard then
        OwnerBillboard:Destroy()
        OwnerBillboard = nil
    end

    if RainbowConnection then
        RainbowConnection:Disconnect()
        RainbowConnection = nil
    end
    if GlassConnection then
        GlassConnection:Disconnect()
        GlassConnection = nil
    end
    if AmmoConnection then
        AmmoConnection:Disconnect()
        AmmoConnection = nil
    end
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
end)

-- ============================================
-- TOGGLE MENU WITH INSERT KEY
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ============================================
-- INITIAL NOTIFICATION
-- ============================================
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 320, 0, 40)
notif.Position = UDim2.new(0.5, -160, 0, 20)
notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
notif.Text = "intabazaki.lua v3.0 Loaded | Press INSERT"
notif.TextColor3 = Color3.fromRGB(220, 20, 60)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.Parent = ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notif

task.delay(5, function()
    notif:Destroy()
end)

print("intabazaki.lua v3.0 loaded successfully")
