local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiCheatTestMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local function CreateShadow(parent, size, pos, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = pos or UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = size or UDim2.new(1, 40, 1, 40)
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 560)
MainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

CreateShadow(MainFrame, UDim2.new(1, 60, 1, 60), UDim2.new(0.5, 0, 0.5, 0), 0.7)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 30, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 20, 60))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "intabazaki.lua"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -16, 1, -54)
ScrollFrame.Position = UDim2.new(0, 8, 0, 48)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 20, 60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2800)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollFrame

local function CreateSection(text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 32)
    section.BackgroundTransparency = 1
    section.Parent = ScrollFrame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 20, 60)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.4, 0, 0, 2)
    underline.Position = UDim2.new(0, 0, 1, -2)
    underline.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    underline.BorderSizePixel = 0
    underline.Parent = section
    local underGrad = Instance.new("UIGradient")
    underGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22))
    })
    underGrad.Parent = underline
    return section
end

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Parent = frame
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 52, 0, 24)
    toggleBtn.Position = UDim2.new(1, -64, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    local enabled = false
    local function setState(state)
        enabled = state
        if enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            toggleBtn.Text = "OFF"
        end
        callback(enabled)
    end
    toggleBtn.MouseButton1Click:Connect(function()
        setState(not enabled)
    end)
    toggleBtn.MouseEnter:Connect(function()
        if not enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
        end
    end)
    toggleBtn.MouseLeave:Connect(function()
        if not enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        end
    end)
    return frame, toggleBtn, setState
end

local function CreateSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 56)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 4)
    label.Parent = frame
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 10)
    sliderBg.Position = UDim2.new(0, 12, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
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
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 20, 60)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    end)
    return btn
end

local DropdownFrames = {}
local function CreateDynamicDropdown(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 0, 36)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Parent = frame
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.48, 0, 0, 28)
    dropdownBtn.Position = UDim2.new(0.49, 0, 0, 4)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    dropdownBtn.Text = "Select..."
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 12
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
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
            optBtn.Size = UDim2.new(0.48, 0, 0, 28)
            optBtn.Position = UDim2.new(0.49, 0, 0, 4 + (i * 30))
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 12
            optBtn.Visible = false
            optBtn.AutoButtonColor = false
            optBtn.Parent = frame
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 6)
            optCorner.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                open = false
                frame.Size = UDim2.new(1, -10, 0, 36)
                for _, b in ipairs(optionButtons) do
                    b.Visible = false
                end
                callback(option)
            end)
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end)
            table.insert(optionButtons, optBtn)
        end
    end
    dropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            frame.Size = UDim2.new(1, -10, 0, 36 + (#currentOptions * 30))
            for _, b in ipairs(optionButtons) do
                b.Visible = true
            end
        else
            frame.Size = UDim2.new(1, -10, 0, 36)
            for _, b in ipairs(optionButtons) do
                b.Visible = false
            end
        end
    end)
    table.insert(DropdownFrames, {Frame = frame, Update = UpdateOptions, Btn = dropdownBtn})
    return frame, UpdateOptions
end

local function CreateTextInput(text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.35, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Parent = frame
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.6, -14, 0, 26)
    textBox.Position = UDim2.new(0.38, 0, 0.5, -13)
    textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = textBox
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)
    return frame, textBox
end

local function CreateColorPicker(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Parent = frame
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 60, 0, 26)
    colorBtn.Position = UDim2.new(1, -72, 0.5, -13)
    colorBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
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

local States = {
    Fly = false, FlySpeed = 50, NoClip = false, WalkSpeed = 16,
    ESP = false, ESPChams = false, ESPBox = false, ESPName = false,
    ESPSkeleton = false, ESPTracer = false, ESPColor = Color3.fromRGB(255, 0, 0),
    SilentAim = false, Aimbot = false, AimbotFOV = 100, AimbotSmoothness = 0.5,
    AimbotOnlyEnemy = false, MagicBullet = false,
    AntiAFK = false, FOV = 70, RainbowChar = false, GlassChar = false,
    ShowFPS = false, FlyCar = false, CarSpeed = 50, CarNoClip = false,
    FakeAdmin = false, FakeAdminColor = Color3.fromRGB(255, 0, 0),
    FakeOwner = false, FakeOwnerColor = Color3.fromRGB(255, 215, 0),
    ChatAdmin = false, ChatOwner = false, TargetPlayer = nil, AmmoTarget = nil,
    GodMode = false, Invisible = false
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
local FlyConnection = nil
local NoClipConnection = nil
local FlyCarConnection = nil
local CarNoClipConnection = nil
local GodModeConnection = nil
local InvisibleConnection = nil
local MagicBulletConnection = nil
local FlyWasEnabled = false
local NoClipWasEnabled = false
local AimbotWasEnabled = false
local GodModeWasEnabled = false
local InvisibleWasEnabled = false
local FlyCarWasEnabled = false
local CarNoClipWasEnabled = false
local MagicBulletWasEnabled = false

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
        if p.Name:lower() == name:lower() then
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

local function StartFly()
    if FlyConnection then FlyConnection:Disconnect() end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
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
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not States.Fly then return end
        if not hrp or not hrp.Parent then return end
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

local function StopFly()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if hrp then
            for _, v in ipairs(hrp:GetChildren()) do
                if v.Name == "ACFlyGyro" or v.Name == "ACFlyVelocity" then
                    v:Destroy()
                end
            end
        end
    end
end

local function StartNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() end
    NoClipConnection = RunService.Stepped:Connect(function()
        if not States.NoClip then return end
        local char = LocalPlayer.Character
        if not char or not char.Parent then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function StopNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function StartGodMode()
    if GodModeConnection then GodModeConnection:Disconnect() end
    GodModeConnection = RunService.RenderStepped:Connect(function()
        if not States.GodMode then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        end)
    end)
    local function onHealthChanged()
        if not States.GodMode then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.HealthChanged:Connect(onHealthChanged)
            hum.Died:Connect(function()
                if States.GodMode then
                    task.delay(0.1, function()
                        local newChar = LocalPlayer.Character
                        if newChar then
                            local newHum = newChar:FindFirstChildOfClass("Humanoid")
                            if newHum then
                                newHum.Health = newHum.MaxHealth
                            end
                        end
                    end)
                end
            end)
        end
    end
end

local function StopGodMode()
    if GodModeConnection then
        GodModeConnection:Disconnect()
        GodModeConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            end)
        end
    end
end

local InvisibleParts = {}

local function StartInvisible()
    if InvisibleConnection then InvisibleConnection:Disconnect() end
    InvisibleParts = {}
    local char = LocalPlayer.Character
    if not char then return end
    local function makeInvisible()
        if not char or not char.Parent then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if not InvisibleParts[part] then
                    InvisibleParts[part] = part.Transparency
                end
                part.Transparency = 1
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                if not InvisibleParts[part] then
                    InvisibleParts[part] = part.Transparency
                end
                part.Transparency = 1
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end
    makeInvisible()
    InvisibleConnection = RunService.RenderStepped:Connect(function()
        if not States.Invisible then return end
        local currentChar = LocalPlayer.Character
        if not currentChar or not currentChar.Parent then return end
        makeInvisible()
    end)
end

local function StopInvisible()
    if InvisibleConnection then
        InvisibleConnection:Disconnect()
        InvisibleConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        for part, originalTransparency in pairs(InvisibleParts) do
            if part and part.Parent then
                pcall(function()
                    part.Transparency = originalTransparency
                end)
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
    InvisibleParts = {}
end

local function StartFlyCar()
    if FlyCarConnection then FlyCarConnection:Disconnect() end
    FlyCarConnection = RunService.RenderStepped:Connect(function()
        if not States.FlyCar then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local seat = hum.SeatPart
        if not seat or not seat:IsA("VehicleSeat") then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if not car then return end
        local primary = car.PrimaryPart or car:FindFirstChild("VehicleSeat") or car:FindFirstChild("Chassis")
        if not primary then
            for _, v in ipairs(car:GetDescendants()) do
                if v:IsA("BasePart") then
                    primary = v
                    break
                end
            end
        end
        if not primary then return end
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
            local targetVel = dir.Unit * States.CarSpeed
            primary.Velocity = targetVel
            primary.RotVelocity = Vector3.new(0, 0, 0)
            local targetCF = CFrame.new(primary.Position, primary.Position + dir.Unit)
            primary.CFrame = targetCF
        else
            primary.Velocity = Vector3.new(0, 0, 0)
            primary.RotVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFlyCar()
    if FlyCarConnection then
        FlyCarConnection:Disconnect()
        FlyCarConnection = nil
    end
end

local function StartCarNoClip()
    if CarNoClipConnection then CarNoClipConnection:Disconnect() end
    CarNoClipConnection = RunService.Stepped:Connect(function()
        if not States.CarNoClip then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local seat = hum.SeatPart
        if not seat then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if not car then return end
        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function StopCarNoClip()
    if CarNoClipConnection then
        CarNoClipConnection:Disconnect()
        CarNoClipConnection = nil
    end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local seat = hum.SeatPart
    if not seat then return end
    local car = seat:FindFirstAncestorOfClass("Model")
    if not car then return end
    for _, part in ipairs(car:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function StartMagicBullet()
    if MagicBulletConnection then MagicBulletConnection:Disconnect() end
    MagicBulletConnection = RunService.RenderStepped:Connect(function()
        if not States.MagicBullet then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("bullet") or name:find("projectile") or name:find("shot") or name:find("tracer") or name:find("shell") then
                    local closestPlayer = nil
                    local closestDist = math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p == LocalPlayer then continue end
                        if not p.Character then continue end
                        local targetHead = p.Character:FindFirstChild("Head")
                        if not targetHead then continue end
                        if States.AimbotOnlyEnemy then
                            local myTeam = LocalPlayer.Team
                            local theirTeam = p.Team
                            if myTeam and theirTeam and myTeam == theirTeam then
                                continue
                            end
                        end
                        local dist = (targetHead.Position - obj.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestPlayer = p
                        end
                    end
                    if closestPlayer and closestPlayer.Character then
                        local targetHead = closestPlayer.Character:FindFirstChild("Head")
                        if targetHead then
                            obj.CFrame = CFrame.new(targetHead.Position)
                            obj.Velocity = Vector3.new(0, 0, 0)
                            obj.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end

local function StopMagicBullet()
    if MagicBulletConnection then
        MagicBulletConnection:Disconnect()
        MagicBulletConnection = nil
    end
end

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

local _, _, FlySetState = CreateToggle("Fly", function(enabled)
    States.Fly = enabled
    FlyWasEnabled = enabled
    if enabled then
        StartFly()
    else
        StopFly()
    end
end)

local _, _, NoClipSetState = CreateToggle("NoClip", function(enabled)
    States.NoClip = enabled
    NoClipWasEnabled = enabled
    if enabled then
        StartNoClip()
    else
        StopNoClip()
    end
end)

CreateSection("TELEPORT TESTS")

local playerNames = GetPlayerNames()
local teleportDropdown, updateTeleportDropdown = CreateDynamicDropdown("Teleport Target", function(selected)
    States.TargetPlayer = selected
end)
updateTeleportDropdown(playerNames)

CreateTextInput("Find Player", "Type name...", function(text)
    local target = GetPlayerByName(text)
    if target then
        States.TargetPlayer = target.Name
        for _, dd in ipairs(DropdownFrames) do
            dd.Btn.Text = target.Name
        end
    end
end)

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

CreateSection("COMBAT TESTS")

CreateToggle("Silent Aim", function(enabled)
    States.SilentAim = enabled
end)

local _, _, AimbotSetState = CreateToggle("Aimbot", function(enabled)
    States.Aimbot = enabled
    AimbotWasEnabled = enabled
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
                if States.AimbotOnlyEnemy then
                    local myTeam = LocalPlayer.Team
                    local theirTeam = p.Team
                    if myTeam and theirTeam and myTeam == theirTeam then
                        continue
                    end
                end
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

CreateToggle("Only Enemy", function(enabled)
    States.AimbotOnlyEnemy = enabled
end)

CreateSlider("Aimbot FOV", 30, 300, 100, function(val)
    States.AimbotFOV = val
end)

CreateSlider("Aimbot Smooth", 1, 100, 50, function(val)
    States.AimbotSmoothness = val / 100
end)

local _, _, MagicBulletSetState = CreateToggle("Magic Bullet", function(enabled)
    States.MagicBullet = enabled
    MagicBulletWasEnabled = enabled
    if enabled then
        StartMagicBullet()
    else
        StopMagicBullet()
    end
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

local _, _, GodModeSetState = CreateToggle("God Mode", function(enabled)
    States.GodMode = enabled
    GodModeWasEnabled = enabled
    if enabled then
        StartGodMode()
    else
        StopGodMode()
    end
end)

local _, _, InvisibleSetState = CreateToggle("Invisible", function(enabled)
    States.Invisible = enabled
    InvisibleWasEnabled = enabled
    if enabled then
        StartInvisible()
    else
        StopInvisible()
    end
end)

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

CreateSection("CAR TESTS")

local _, _, FlyCarSetState = CreateToggle("Fly Car", function(enabled)
    States.FlyCar = enabled
    FlyCarWasEnabled = enabled
    if enabled then
        StartFlyCar()
    else
        StopFlyCar()
    end
end)

local _, _, CarNoClipSetState = CreateToggle("Car NoClip", function(enabled)
    States.CarNoClip = enabled
    CarNoClipWasEnabled = enabled
    if enabled then
        StartCarNoClip()
    else
        StopCarNoClip()
    end
end)

CreateSlider("Car Speed", 50, 500, 50, function(val)
    States.CarSpeed = val
end)

CreateSection("TROLL TESTS")

local ammoTargetDropdown, updateAmmoDropdown = CreateDynamicDropdown("Ammo Target", function(selected)
    States.AmmoTarget = selected
end)
updateAmmoDropdown(playerNames)

CreateTextInput("Find Ammo Target", "Type name...", function(text)
    local target = GetPlayerByName(text)
    if target then
        States.AmmoTarget = target.Name
        for _, dd in ipairs(DropdownFrames) do
            if dd.Btn.Text == "Select..." or dd.Btn.Text == "No Players" then
                dd.Btn.Text = target.Name
            end
        end
    end
end)

CreateToggle("Ammo", function(enabled)
    States.AmmoActive = enabled
    if enabled then
        if AmmoConnection then AmmoConnection:Disconnect() end
        local ammoNoclipConn = RunService.Stepped:Connect(function()
            if not States.AmmoActive then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        AmmoConnection = RunService.RenderStepped:Connect(function()
            if not States.AmmoActive then
                if ammoNoclipConn then ammoNoclipConn:Disconnect() end
                return
            end
            local target = GetPlayerByName(States.AmmoTarget)
            local myChar = LocalPlayer.Character
            if not target or not target.Character or not myChar then return end
            local targetHead = target.Character:FindFirstChild("Head")
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not targetHead or not myHRP then return end
            local frontOffset = targetHead.CFrame.LookVector * 0.6
            local heightOffset = Vector3.new(0, 1.0, 0)
            local targetPosition = targetHead.Position + frontOffset + heightOffset
            local faceDirection = -targetHead.CFrame.LookVector
            local baseCF = CFrame.new(targetPosition, targetPosition + faceDirection)
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
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.delay(0.5, function()
        if FlyWasEnabled and not States.Fly then
            States.Fly = true
            FlySetState(true)
        end
        if NoClipWasEnabled and not States.NoClip then
            States.NoClip = true
            NoClipSetState(true)
        end
        if AimbotWasEnabled and not States.Aimbot then
            States.Aimbot = true
            AimbotSetState(true)
        end
        if GodModeWasEnabled and not States.GodMode then
            States.GodMode = true
            GodModeSetState(true)
        end
        if InvisibleWasEnabled and not States.Invisible then
            States.Invisible = true
            InvisibleSetState(true)
        end
        if FlyCarWasEnabled and not States.FlyCar then
            States.FlyCar = true
            FlyCarSetState(true)
        end
        if CarNoClipWasEnabled and not States.CarNoClip then
            States.CarNoClip = true
            CarNoClipSetState(true)
        end
        if MagicBulletWasEnabled and not States.MagicBullet then
            States.MagicBullet = true
            MagicBulletSetState(true)
        end
    end)

    ClearAllESP()

    if AdminBillboard then
        AdminBillboard:Destroy()
        AdminBillboard = nil
    end
    if OwnerBillboard then
        OwnerBillboard:Destroy()
        OwnerBillboard = nil
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 340, 0, 44)
notif.Position = UDim2.new(0.5, -170, 0, 24)
notif.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
notif.Text = "intabazaki.lua v3.0 Loaded | Press INSERT"
notif.TextColor3 = Color3.fromRGB(220, 20, 60)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 14
notif.Parent = ScreenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 10)
notifCorner.Parent = notif

CreateShadow(notif, UDim2.new(1, 30, 1, 30), UDim2.new(0.5, 0, 0.5, 0), 0.6)

task.delay(5, function()
    notif:Destroy()
end)

print("intabazaki.lua v3.0 loaded successfully")
