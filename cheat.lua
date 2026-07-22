--[[
    VISITING SOFTWARE v2.0
    Modern GUI, tüm fonksiyonlar eksiksiz.
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Ana GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VISITING_SOFTWARE"
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
MainFrame.Size = UDim2.new(0, 420, 0, 600)
MainFrame.Position = UDim2.new(0.02, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame
CreateShadow(MainFrame, UDim2.new(1, 80, 1, 80), UDim2.new(0.5, 0, 0.5, 0), 0.7)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 52)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 17, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -70, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "VISITING SOFTWARE"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -44, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 70)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 26
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -24, 1, -64)
ScrollFrame.Position = UDim2.new(0, 12, 0, 58)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 4200)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- UI Elemanları
local function CreateSection(text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 34)
    section.BackgroundTransparency = 1
    section.Parent = ScrollFrame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 17
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.5, 0, 0, 3)
    underline.Position = UDim2.new(0, 0, 1, -3)
    underline.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    underline.BorderSizePixel = 0
    underline.Parent = section
    local underGrad = Instance.new("UIGradient")
    underGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 20))
    })
    underGrad.Parent = underline
    return section
end

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 16, 0, 0)
    label.Parent = frame
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 28)
    toggleBtn.Position = UDim2.new(1, -76, 0.5, -14)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = toggleBtn
    local enabled = false
    local function setState(state)
        enabled = state
        if enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            toggleBtn.Text = "OFF"
        end
        callback(enabled)
    end
    toggleBtn.MouseButton1Click:Connect(function()
        setState(not enabled)
    end)
    toggleBtn.MouseEnter:Connect(function()
        if not enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 85)
        end
    end)
    toggleBtn.MouseLeave:Connect(function()
        if not enabled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        end
    end)
    return frame, toggleBtn, setState
end

local function CreateSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 68)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 26)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 16, 0, 8)
    label.Parent = frame
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -32, 0, 14)
    sliderBg.Position = UDim2.new(0, 16, 0, 42)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 7)
    sliderCorner.Parent = sliderBg
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 7)
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
    btn.Size = UDim2.new(1, -10, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 180, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    end)
    return btn
end

local DropdownFrames = {}
local function CreateDynamicDropdown(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.38, 0, 0, 44)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 16, 0, 0)
    label.Parent = frame
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.58, 0, 0, 32)
    dropdownBtn.Position = UDim2.new(0.4, 0, 0, 6)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    dropdownBtn.Text = "Select..."
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 13
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
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
            optBtn.Size = UDim2.new(0.58, 0, 0, 32)
            optBtn.Position = UDim2.new(0.4, 0, 0, 6 + (i * 34))
            optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 13
            optBtn.Visible = false
            optBtn.AutoButtonColor = false
            optBtn.Parent = frame
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 9)
            optCorner.Parent = optBtn
            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                open = false
                frame.Size = UDim2.new(1, -10, 0, 44)
                for _, b in ipairs(optionButtons) do
                    b.Visible = false
                end
                callback(option)
            end)
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            end)
            table.insert(optionButtons, optBtn)
        end
    end
    dropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            frame.Size = UDim2.new(1, -10, 0, 44 + (#currentOptions * 34))
            for _, b in ipairs(optionButtons) do
                b.Visible = true
            end
        else
            frame.Size = UDim2.new(1, -10, 0, 44)
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
    frame.Size = UDim2.new(1, -10, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 16, 0, 0)
    label.Parent = frame
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.66, -16, 0, 30)
    textBox.Position = UDim2.new(0.32, 0, 0.5, -15)
    textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 13
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 9)
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
    frame.Size = UDim2.new(1, -10, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 16, 0, 0)
    label.Parent = frame
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 70, 0, 30)
    colorBtn.Position = UDim2.new(1, -86, 0.5, -15)
    colorBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    colorBtn.Parent = frame
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 9)
    btnCorner.Parent = colorBtn
    local colors = {
        Color3.fromRGB(0, 180, 255), Color3.fromRGB(255, 50, 80), Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(128, 0, 128)
    }
    local colorIndex = 1
    colorBtn.BackgroundColor3 = colors[colorIndex]
    colorBtn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        colorBtn.BackgroundColor3 = colors[colorIndex]
        callback(colors[colorIndex])
    end)
    return frame
end

-- Durumlar
local States = {
    Fly = false, FlySpeed = 50, NoClip = false, WalkSpeed = 16,
    ESP = false, ESPChams = false, ESPBox = false, ESPName = false,
    ESPSkeleton = false, ESPTracer = false, ESPColor = Color3.fromRGB(0, 180, 255),
    SilentAim = false, Aimbot = false, AimbotFOV = 100, AimbotSmoothness = 0.5,
    AimbotOnlyEnemy = false, MagicBullet = false,
    AntiAFK = false, FOV = 70, RainbowChar = false, GlassChar = false,
    ShowFPS = false, FlyCar = false, CarSpeed = 50, CarNoClip = false,
    FakeAdmin = false, FakeAdminColor = Color3.fromRGB(255, 0, 0),
    FakeOwner = false, FakeOwnerColor = Color3.fromRGB(255, 215, 0),
    TargetPlayer = nil, AmmoTarget = nil,
    GodMode = false, Invisible = false,
    TriggerBot = false, AmmoActive = false,
    SpectateActive = false, SpectatePlayer = nil
}

-- Bağlantılar
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
local TriggerBotConnection = nil
local SpectateConnection = nil

local FlyWasEnabled = false
local NoClipWasEnabled = false
local AimbotWasEnabled = false
local GodModeWasEnabled = false
local InvisibleWasEnabled = false
local FlyCarWasEnabled = false
local CarNoClipWasEnabled = false
local MagicBulletWasEnabled = false
local TriggerBotWasEnabled = false
local SpectateWasEnabled = false

-- Yardımcı fonksiyonlar
local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    if #names == 0 then table.insert(names, "No Players") end
    return names
end

local function GetPlayerByName(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == name:lower() then return p end
    end
    return nil
end

local function UpdateAllDropdowns()
    local names = GetPlayerNames()
    for _, dd in ipairs(DropdownFrames) do
        dd.Update(names)
    end
end

Players.PlayerAdded:Connect(function() task.delay(0.5, UpdateAllDropdowns) end)
Players.PlayerRemoving:Connect(function() task.delay(0.5, UpdateAllDropdowns) end)

local function ClearESPForPlayer(player)
    if ESPObjects[player] then
        local esp = ESPObjects[player]
        if esp.Box and typeof(esp.Box) == "table" and esp.Box.Remove then esp.Box:Remove() end
        if esp.Name and typeof(esp.Name) == "table" and esp.Name.Remove then esp.Name:Remove() end
        if esp.Tracer and typeof(esp.Tracer) == "table" and esp.Tracer.Remove then esp.Tracer:Remove() end
        if esp.Skeleton then for _, line in ipairs(esp.Skeleton) do if typeof(line) == "table" and line.Remove then line:Remove() end end end
        if esp.ChamsList then for _, v in ipairs(esp.ChamsList) do if typeof(v) == "Instance" then v:Destroy() end end end
        ESPObjects[player] = nil
    end
end

local function ClearAllESP()
    for player, _ in pairs(ESPObjects) do ClearESPForPlayer(player) end
    ESPObjects = {}
end

-- Kill sistemi (agresif)
local function KillPlayer(player)
    if not player or not player.Character then return end
    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Önce oyun remotes'ları dene
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("kill") or n:find("hit") or n:find("hurt") then
                pcall(function()
                    if v:IsA("RemoteEvent") then
                        v:FireServer(hum, 99999)
                    else
                        v:InvokeServer(hum, 99999)
                    end
                end)
            end
        end
    end

    -- Karakteri parçala ve aşırı hızlandır
    pcall(function() char:BreakJoints() end)
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, -9999, 0)
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(90), 0, 0)
        end
    end)
end

-- FLY
local function StartFly()
    if FlyConnection then FlyConnection:Disconnect() end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro"); bg.Name = "FlyGyro"; bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = hrp.CFrame; bg.Parent = hrp
    local bv = Instance.new("BodyVelocity"); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Parent = hrp
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not States.Fly then return end
        if not hrp or not hrp.Parent then return end
        local camCF = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * States.FlySpeed or Vector3.new()
        bg.CFrame = camCF
    end)
end
local function StopFly()
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if hrp then
            for _, v in ipairs(hrp:GetChildren()) do
                if v.Name == "FlyGyro" or v.Name == "FlyVel" then v:Destroy() end
            end
        end
    end
end

-- NOCLIP
local function StartNoClip()
    if NoClipConnection then NoClipConnection:Disconnect() end
    NoClipConnection = RunService.Stepped:Connect(function()
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
    if NoClipConnection then NoClipConnection:Disconnect(); NoClipConnection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

-- GODMODE
local function StartGodMode()
    if GodModeConnection then GodModeConnection:Disconnect() end
    GodModeConnection = RunService.RenderStepped:Connect(function()
        if not States.GodMode then return end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(char)
        if States.GodMode then
            local hum = char:WaitForChild("Humanoid")
            hum.Health = hum.MaxHealth
        end
    end)
end
local function StopGodMode()
    if GodModeConnection then GodModeConnection:Disconnect(); GodModeConnection = nil end
end

-- INVISIBLE
local function ApplyInvisible(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Transparency = 1; part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then part.Transparency = 1 end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
end
local function StartInvisible()
    if InvisibleConnection then InvisibleConnection:Disconnect() end
    InvisibleConnection = RunService.RenderStepped:Connect(function()
        if not States.Invisible then return end
        local char = LocalPlayer.Character
        if char and char.Parent then ApplyInvisible(char) end
    end)
    LocalPlayer.CharacterAdded:Connect(function(char)
        if States.Invisible then task.wait(0.2); ApplyInvisible(char) end
    end)
    if LocalPlayer.Character then ApplyInvisible(LocalPlayer.Character) end
end
local function StopInvisible()
    if InvisibleConnection then InvisibleConnection:Disconnect(); InvisibleConnection = nil end
end

-- FLYCAR
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
            for _, v in ipairs(car:GetDescendants()) do if v:IsA("BasePart") then primary = v break end end
        end
        if not primary then return end
        local camCF = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector end
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
    if FlyCarConnection then FlyCarConnection:Disconnect(); FlyCarConnection = nil end
end

-- CAR NOCLIP
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
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end
local function StopCarNoClip()
    if CarNoClipConnection then CarNoClipConnection:Disconnect(); CarNoClipConnection = nil end
end

-- MAGIC BULLET (optimize)
local function StartMagicBullet()
    if MagicBulletConnection then MagicBulletConnection:Disconnect() end
    MagicBulletConnection = RunService.Heartbeat:Connect(function()
        if not States.MagicBullet then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Velocity.Magnitude > 10 then
                local n = obj.Name:lower()
                if n:find("bullet") or n:find("projectile") or n:find("shell") then
                    local closestPlayer, closestDist = nil, 500
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local head = p.Character:FindFirstChild("Head")
                            if head then
                                local dist = (head.Position - obj.Position).Magnitude
                                if dist < closestDist then
                                    if not States.AimbotOnlyEnemy or (LocalPlayer.Team and p.Team and LocalPlayer.Team ~= p.Team) then
                                        closestDist = dist
                                        closestPlayer = p
                                    end
                                end
                            end
                        end
                    end
                    if closestPlayer and closestPlayer.Character then
                        local head = closestPlayer.Character:FindFirstChild("Head")
                        if head then
                            obj.CFrame = CFrame.new(head.Position)
                            obj.Velocity = Vector3.new()
                            obj.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end
local function StopMagicBullet()
    if MagicBulletConnection then MagicBulletConnection:Disconnect(); MagicBulletConnection = nil end
end

-- TRIGGERBOT
local function StartTriggerBot()
    if TriggerBotConnection then TriggerBotConnection:Disconnect() end
    TriggerBotConnection = RunService.RenderStepped:Connect(function()
        if not States.TriggerBot then return end
        local closestPlayer, closestDist = nil, 120
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if not p.Character then continue end
            local head = p.Character:FindFirstChild("Head")
            if not head then continue end
            if States.AimbotOnlyEnemy then
                local myTeam = LocalPlayer.Team
                local theirTeam = p.Team
                if myTeam and theirTeam and myTeam == theirTeam then continue end
            end
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < closestDist then closestDist = dist; closestPlayer = p end
            end
        end
        if closestPlayer then
            UserInputService:SendInputEvent(Enum.UserInputType.MouseButton1, true)
            task.wait(0.05)
            UserInputService:SendInputEvent(Enum.UserInputType.MouseButton1, false)
        end
    end)
end
local function StopTriggerBot()
    if TriggerBotConnection then TriggerBotConnection:Disconnect(); TriggerBotConnection = nil end
end

-- AIMBOT
local function StartAimbot()
    if AimbotConnection then AimbotConnection:Disconnect() end
    AimbotConnection = RunService.RenderStepped:Connect(function()
        if not States.Aimbot then return end
        local closestPlayer, closestDist = nil, States.AimbotFOV
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if not p.Character then continue end
            local head = p.Character:FindFirstChild("Head")
            if not head then continue end
            if States.AimbotOnlyEnemy then
                local myTeam = LocalPlayer.Team
                local theirTeam = p.Team
                if myTeam and theirTeam and myTeam == theirTeam then continue end
            end
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < closestDist then closestDist = dist; closestPlayer = p end
            end
        end
        if closestPlayer and closestPlayer.Character then
            local head = closestPlayer.Character:FindFirstChild("Head")
            if head then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), States.AimbotSmoothness)
            end
        end
    end)
end
local function StopAimbot()
    if AimbotConnection then AimbotConnection:Disconnect(); AimbotConnection = nil end
end

-- ESP (tam)
local function GetSkeletonJoints(char)
    local joints = {}
    local function add(a,b) if char:FindFirstChild(a) and char:FindFirstChild(b) then table.insert(joints, {a,b}) end end
    add("Head","Torso"); add("Torso","Left Arm"); add("Torso","Right Arm"); add("Torso","Left Leg"); add("Torso","Right Leg")
    add("Head","UpperTorso"); add("UpperTorso","LowerTorso")
    add("UpperTorso","LeftUpperArm"); add("LeftUpperArm","LeftLowerArm"); add("LeftLowerArm","LeftHand")
    add("UpperTorso","RightUpperArm"); add("RightUpperArm","RightLowerArm"); add("RightLowerArm","RightHand")
    add("LowerTorso","LeftUpperLeg"); add("LeftUpperLeg","LeftLowerLeg"); add("LeftLowerLeg","LeftFoot")
    add("LowerTorso","RightUpperLeg"); add("RightUpperLeg","RightLowerLeg"); add("RightLowerLeg","RightFoot")
    return joints
end

local function StartESP()
    if ESPConnection then ESPConnection:Disconnect() end
    ESPConnection = RunService.Heartbeat:Connect(function()
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
                            local highlight = Instance.new("Highlight")
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
                    if v:IsA("Highlight") then v.FillColor = States.ESPColor; v.OutlineColor = States.ESPColor end
                end
            else
                if esp.ChamsList then
                    for _, v in ipairs(esp.ChamsList) do v:Destroy() end
                    esp.ChamsList = nil
                end
            end

            -- Box
            if States.ESPBox then
                if not esp.Box then
                    esp.Box = Drawing.new("Square"); esp.Box.Thickness = 2; esp.Box.Filled = false; esp.Box.Color = States.ESPColor
                end
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local headPos = Camera:WorldToViewportPoint(head.Position)
                        local height = math.abs(headPos.Y - pos.Y) + 15
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
                    esp.Name = Drawing.new("Text"); esp.Name.Size = 14; esp.Name.Outline = true; esp.Name.Center = true; esp.Name.Color = States.ESPColor
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                    if onScreen then
                        esp.Name.Visible = true; esp.Name.Position = Vector2.new(pos.X, pos.Y); esp.Name.Text = p.Name; esp.Name.Color = States.ESPColor
                    else esp.Name.Visible = false end
                else esp.Name.Visible = false end
            elseif esp.Name then esp.Name.Visible = false end

            -- Skeleton
            if States.ESPSkeleton then
                if not esp.Skeleton then
                    esp.Skeleton = {}
                    local joints = GetSkeletonJoints(char)
                    for i = 1, #joints do
                        local line = Drawing.new("Line"); line.Thickness = 1.5; line.Color = States.ESPColor; table.insert(esp.Skeleton, line)
                    end
                    esp.SkeletonJoints = joints
                end
                local joints = esp.SkeletonJoints
                for i, joint in ipairs(joints) do
                    local part1 = char:FindFirstChild(joint[1])
                    local part2 = char:FindFirstChild(joint[2])
                    local line = esp.Skeleton[i]
                    if line and part1 and part2 then
                        local pos1, on1 = Camera:WorldToViewportPoint(part1.Position)
                        local pos2, on2 = Camera:WorldToViewportPoint(part2.Position)
                        if on1 and on2 then
                            line.Visible = true; line.From = Vector2.new(pos1.X, pos1.Y); line.To = Vector2.new(pos2.X, pos2.Y); line.Color = States.ESPColor
                        else line.Visible = false end
                    elseif line then line.Visible = false end
                end
            elseif esp.Skeleton then
                for _, line in ipairs(esp.Skeleton) do line.Visible = false end
            end

            -- Tracer
            if States.ESPTracer then
                if not esp.Tracer then
                    esp.Tracer = Drawing.new("Line"); esp.Tracer.Thickness = 1; esp.Tracer.Color = States.ESPColor
                end
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    esp.Tracer.Visible = true; esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); esp.Tracer.To = Vector2.new(pos.X, pos.Y); esp.Tracer.Color = States.ESPColor
                else esp.Tracer.Visible = false end
            elseif esp.Tracer then esp.Tracer.Visible = false end
        end
    end)
end

-- SPECTATE
local function StartSpectate()
    if SpectateConnection then SpectateConnection:Disconnect() end
    if not States.SpectatePlayer then return end
    local target = GetPlayerByName(States.SpectatePlayer)
    if target and target.Character then
        Camera.CameraSubject = target.Character
        Camera.CameraType = Enum.CameraType.Custom
    end
    local pitch, yaw = 0, 0
    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not States.SpectateActive then return end
        local t = GetPlayerByName(States.SpectatePlayer)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            local head = t.Character.Head
            local delta = UserInputService:GetMouseDelta()
            yaw -= delta.X * 0.3
            pitch = math.clamp(pitch + delta.Y * 0.3, -80, 80)
            local rotCF = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
            Camera.CFrame = CFrame.new(head.Position) * rotCF + rotCF.LookVector * -5
        end
    end)
end
local function StopSpectate()
    if SpectateConnection then SpectateConnection:Disconnect(); SpectateConnection = nil end
    Camera.CameraSubject = LocalPlayer.Character
    Camera.CameraType = Enum.CameraType.Custom
end

-- RAINBOW / GLASS
local function StartRainbow()
    if RainbowConnection then RainbowConnection:Disconnect() end
    local hue = 0
    RainbowConnection = RunService.RenderStepped:Connect(function()
        if not States.RainbowChar then return end
        hue = (hue + 0.01) % 1
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Color = Color3.fromHSV(hue, 1, 1) end
            end
        end
    end)
end
local function StopRainbow()
    if RainbowConnection then RainbowConnection:Disconnect(); RainbowConnection = nil end
end
local function StartGlass()
    if GlassConnection then GlassConnection:Disconnect() end
    GlassConnection = RunService.RenderStepped:Connect(function()
        if not States.GlassChar then return end
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0.7; part.Material = Enum.Material.Glass end
            end
        end
    end)
end
local function StopGlass()
    if GlassConnection then GlassConnection:Disconnect(); GlassConnection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0; part.Material = Enum.Material.Plastic end
        end
    end
end

-- ANTIAFK
local function ToggleAntiAFK(enabled)
    States.AntiAFK = enabled
    if enabled then
        if AFKConnection then AFKConnection:Disconnect() end
        AFKConnection = VirtualUser.Button2Down:Connect(function()
            VirtualUser.Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end)
    else
        if AFKConnection then AFKConnection:Disconnect(); AFKConnection = nil end
    end
end

-- FPS
local function ToggleFPS(enabled)
    States.ShowFPS = enabled
    if enabled then
        if not FPSLabel then
            FPSLabel = Instance.new("TextLabel")
            FPSLabel.Size = UDim2.new(0,100,0,25); FPSLabel.Position = UDim2.new(0,10,0,10)
            FPSLabel.BackgroundTransparency = 1; FPSLabel.TextColor3 = Color3.fromRGB(0,180,255)
            FPSLabel.Font = Enum.Font.GothamBold; FPSLabel.TextSize = 14; FPSLabel.Parent = ScreenGui
        end
        FPSLabel.Visible = true
        local lastTime, frames = tick(), 0
        RunService.RenderStepped:Connect(function()
            if not States.ShowFPS then return end
            frames += 1
            if tick() - lastTime >= 1 then
                FPSLabel.Text = "FPS: " .. frames
                frames = 0; lastTime = tick()
            end
        end)
    else
        if FPSLabel then FPSLabel.Visible = false end
    end
end

-- Fake Tags
local function UpdateFakeAdmin()
    if AdminBillboard then AdminBillboard:Destroy() end
    if not States.FakeAdmin then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        AdminBillboard = Instance.new("BillboardGui")
        AdminBillboard.Size = UDim2.new(0,100,0,30); AdminBillboard.StudsOffset = Vector3.new(0,2.5,0); AdminBillboard.AlwaysOnTop = true
        AdminBillboard.Parent = char.Head
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.Text = "[ADMIN]"; label.TextColor3 = States.FakeAdminColor
        label.Font = Enum.Font.GothamBold; label.TextSize = 16; label.Parent = AdminBillboard
    end
end
local function UpdateFakeOwner()
    if OwnerBillboard then OwnerBillboard:Destroy() end
    if not States.FakeOwner then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        OwnerBillboard = Instance.new("BillboardGui")
        OwnerBillboard.Size = UDim2.new(0,100,0,30); OwnerBillboard.StudsOffset = Vector3.new(0,2.5,0); OwnerBillboard.AlwaysOnTop = true
        OwnerBillboard.Parent = char.Head
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0); label.BackgroundTransparency = 1; label.Text = "[OWNER]"; label.TextColor3 = States.FakeOwnerColor
        label.Font = Enum.Font.GothamBold; label.TextSize = 16; label.Parent = OwnerBillboard
    end
end

-- Ammo Troll
local function ToggleAmmo(enabled)
    States.AmmoActive = enabled
    if enabled then
        if AmmoConnection then AmmoConnection:Disconnect() end
        local noclipConn
        AmmoConnection = RunService.RenderStepped:Connect(function()
            if not States.AmmoActive then return end
            local target = GetPlayerByName(States.AmmoTarget)
            local myChar = LocalPlayer.Character
            if not target or not target.Character or not myChar then return end
            local head = target.Character:FindFirstChild("Head")
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if not head or not myHRP then return end
            local targetPos = head.Position + head.CFrame.LookVector*0.6 + Vector3.new(0,1,0)
            local faceDir = -head.CFrame.LookVector
            local cf = CFrame.new(targetPos, targetPos + faceDir) * CFrame.new(0,0, math.sin(tick()*10)*0.3)
            myHRP.CFrame = cf
            myHRP.Velocity = Vector3.new()
            local hum = myChar:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
        end)
        noclipConn = RunService.Stepped:Connect(function()
            if not States.AmmoActive then return end
            local char = LocalPlayer.Character
            if char then for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end)
        AmmoConnection = AmmoConnection 
    else
        if AmmoConnection then AmmoConnection:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end

-- UI elemanlarını oluştur
CreateSection("MOVEMENT")
CreateSlider("WalkSpeed", 16, 500, 16, function(val) States.WalkSpeed = val; if LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = val end end end)
CreateSlider("Fly Speed", 10, 200, 50, function(val) States.FlySpeed = val end)
local _, _, FlySetState = CreateToggle("Fly", function(enabled) States.Fly = enabled; FlyWasEnabled = enabled; if enabled then StartFly() else StopFly() end end)
local _, _, NoClipSetState = CreateToggle("NoClip", function(enabled) States.NoClip = enabled; NoClipWasEnabled = enabled; if enabled then StartNoClip() else StopNoClip() end end)

CreateSection("TELEPORT")
local playerNames = GetPlayerNames()
local tpDropdown, updateTP = CreateDynamicDropdown("Teleport Target", function(sel) States.TargetPlayer = sel end)
updateTP(playerNames)
CreateTextInput("Find Player", "Type name...", function(text)
    local target = GetPlayerByName(text)
    if target then
        States.TargetPlayer = target.Name
        for _, dd in ipairs(DropdownFrames) do dd.Btn.Text = target.Name end
    end
end)
CreateButton("Teleport to Target", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Players" then
        local target = GetPlayerByName(States.TargetPlayer)
        if target and target.Character then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and targetHRP then myHRP.CFrame = targetHRP.CFrame + Vector3.new(0,3,0) end
        end
    end
end)
CreateButton("Teleport to Car", function()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") or v:IsA("Seat") then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP then myHRP.CFrame = v.CFrame + Vector3.new(0,3,0); break end
        end
    end
end)
local pullDropdown, updatePull = CreateDynamicDropdown("Yanına Çek", function(sel) States.TargetPlayer = sel end)
updatePull(playerNames)
CreateButton("Yanına Çek", function()
    if States.TargetPlayer and States.TargetPlayer ~= "No Players" then
        local target = GetPlayerByName(States.TargetPlayer)
        local myChar = LocalPlayer.Character
        if target and target.Character and myChar then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            if targetHRP and myHRP then targetHRP.CFrame = myHRP.CFrame + Vector3.new(0,3,0) end
        end
    end
end)

CreateSection("ESP")
CreateToggle("Enable ESP", function(enabled) States.ESP = enabled; if not enabled then ClearAllESP() end end)
CreateToggle("Chams ESP", function(enabled) States.ESPChams = enabled; if not enabled then for _, esp in pairs(ESPObjects) do if esp.ChamsList then for _, v in ipairs(esp.ChamsList) do v:Destroy() end esp.ChamsList = nil end end end end)
CreateToggle("Box ESP", function(enabled) States.ESPBox = enabled; if not enabled then for _, esp in pairs(ESPObjects) do if esp.Box then esp.Box.Visible = false end end end end)
CreateToggle("Name ESP", function(enabled) States.ESPName = enabled; if not enabled then for _, esp in pairs(ESPObjects) do if esp.Name then esp.Name.Visible = false end end end end)
CreateToggle("Skeleton ESP", function(enabled) States.ESPSkeleton = enabled; if not enabled then for _, esp in pairs(ESPObjects) do if esp.Skeleton then for _, line in ipairs(esp.Skeleton) do line.Visible = false end end end end end)
CreateToggle("Tracer ESP", function(enabled) States.ESPTracer = enabled; if not enabled then for _, esp in pairs(ESPObjects) do if esp.Tracer then esp.Tracer.Visible = false end end end end)
CreateColorPicker("ESP Color", function(color) States.ESPColor = color end)
StartESP()

CreateSection("COMBAT")
CreateToggle("Silent Aim", function(enabled) States.SilentAim = enabled end)
local _, _, AimbotSetState = CreateToggle("Aimbot", function(enabled) States.Aimbot = enabled; AimbotWasEnabled = enabled; if enabled then StartAimbot() else StopAimbot() end end)
CreateToggle("Only Enemy", function(enabled) States.AimbotOnlyEnemy = enabled end)
CreateSlider("Aimbot FOV", 30, 300, 100, function(val) States.AimbotFOV = val end)
CreateSlider("Aimbot Smooth", 1, 100, 50, function(val) States.AimbotSmoothness = val/100 end)
local _, _, MagicBulletSetState = CreateToggle("Magic Bullet", function(enabled) States.MagicBullet = enabled; MagicBulletWasEnabled = enabled; if enabled then StartMagicBullet() else StopMagicBullet() end end)
local _, _, TriggerBotSetState = CreateToggle("TriggerBot", function(enabled) States.TriggerBot = enabled; TriggerBotWasEnabled = enabled; if enabled then StartTriggerBot() else StopTriggerBot() end end)
local killDropdown, updateKill = CreateDynamicDropdown("Kill Target", function(sel) States.TargetPlayer = sel end)
updateKill(playerNames)
CreateButton("Kill Target", function() if States.TargetPlayer and States.TargetPlayer ~= "No Players" then KillPlayer(GetPlayerByName(States.TargetPlayer)) end end)
CreateButton("Kill All", function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then KillPlayer(p) end end end)

CreateSection("SPECTATE")
local specDropdown, updateSpec = CreateDynamicDropdown("Spectate Player", function(sel) States.SpectatePlayer = sel end)
updateSpec(playerNames)
local _, _, SpectateSetState = CreateToggle("Spectate", function(enabled) States.SpectateActive = enabled; SpectateWasEnabled = enabled; if enabled then StartSpectate() else StopSpectate() end end)

CreateSection("UTILITY")
CreateToggle("Anti AFK", ToggleAntiAFK)
CreateSlider("FOV Changer", 30, 120, 70, function(val) States.FOV = val; Camera.FieldOfView = val end)
CreateToggle("Show FPS", ToggleFPS)

CreateSection("CHARACTER")
CreateToggle("Rainbow Character", function(enabled) States.RainbowChar = enabled; if enabled then StartRainbow() else StopRainbow() end end)
CreateToggle("Glass Character", function(enabled) States.GlassChar = enabled; if enabled then StartGlass() else StopGlass() end end)
local _, _, GodModeSetState = CreateToggle("God Mode", function(enabled) States.GodMode = enabled; GodModeWasEnabled = enabled; if enabled then StartGodMode() else StopGodMode() end end)
local _, _, InvisibleSetState = CreateToggle("Invisible", function(enabled) States.Invisible = enabled; InvisibleWasEnabled = enabled; if enabled then StartInvisible() else StopInvisible() end end)

CreateSection("FAKE TAGS")
CreateToggle("Fake Admin", function(enabled) States.FakeAdmin = enabled; UpdateFakeAdmin() end)
CreateColorPicker("Admin Color", function(color) States.FakeAdminColor = color; if AdminBillboard then AdminBillboard:FindFirstChildOfClass("TextLabel").TextColor3 = color end end)
CreateToggle("Fake Owner", function(enabled) States.FakeOwner = enabled; UpdateFakeOwner() end)
CreateColorPicker("Owner Color", function(color) States.FakeOwnerColor = color; if OwnerBillboard then OwnerBillboard:FindFirstChildOfClass("TextLabel").TextColor3 = color end end)

CreateSection("CAR")
local _, _, FlyCarSetState = CreateToggle("Fly Car", function(enabled) States.FlyCar = enabled; FlyCarWasEnabled = enabled; if enabled then StartFlyCar() else StopFlyCar() end end)
local _, _, CarNoClipSetState = CreateToggle("Car NoClip", function(enabled) States.CarNoClip = enabled; CarNoClipWasEnabled = enabled; if enabled then StartCarNoClip() else StopCarNoClip() end end)
CreateSlider("Car Speed", 50, 500, 50, function(val) States.CarSpeed = val end)

CreateSection("TROLL")
local ammoDropdown, updateAmmo = CreateDynamicDropdown("Ammo Target", function(sel) States.AmmoTarget = sel end)
updateAmmo(playerNames)
CreateTextInput("Find Ammo Target", "Type name...", function(text)
    local target = GetPlayerByName(text)
    if target then
        States.AmmoTarget = target.Name
        for _, dd in ipairs(DropdownFrames) do if dd.Btn.Text == "Select..." or dd.Btn.Text == "No Players" then dd.Btn.Text = target.Name end end
    end
end)
CreateToggle("Ammo", ToggleAmmo)

-- Karakter respawn hafıza
LocalPlayer.CharacterAdded:Connect(function(char)
    task.delay(0.5, function()
        if FlyWasEnabled then States.Fly = true; StartFly() end
        if NoClipWasEnabled then States.NoClip = true; StartNoClip() end
        if AimbotWasEnabled then States.Aimbot = true; StartAimbot() end
        if GodModeWasEnabled then States.GodMode = true; StartGodMode() end
        if InvisibleWasEnabled then States.Invisible = true; StartInvisible() end
        if FlyCarWasEnabled then States.FlyCar = true; StartFlyCar() end
        if CarNoClipWasEnabled then States.CarNoClip = true; StartCarNoClip() end
        if MagicBulletWasEnabled then States.MagicBullet = true; StartMagicBullet() end
        if TriggerBotWasEnabled then States.TriggerBot = true; StartTriggerBot() end
        if SpectateWasEnabled then States.SpectateActive = true; StartSpectate() end
    end)
    ClearAllESP()
    if AdminBillboard then AdminBillboard:Destroy(); AdminBillboard = nil end
    if OwnerBillboard then OwnerBillboard:Destroy(); OwnerBillboard = nil end
    if States.FakeAdmin then UpdateFakeAdmin() end
    if States.FakeOwner then UpdateFakeOwner() end
end)

-- INSERT ile gizle/göster
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Bildirim
local notif = Instance.new("TextLabel")
notif.Size = UDim2.new(0, 380, 0, 48); notif.Position = UDim2.new(0.5, -190, 0, 30)
notif.BackgroundColor3 = Color3.fromRGB(10, 12, 20); notif.Text = "VISITING SOFTWARE | Press INSERT"
notif.TextColor3 = Color3.fromRGB(0, 180, 255); notif.Font = Enum.Font.GothamBold; notif.TextSize = 16
notif.Parent = ScreenGui
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 14)
CreateShadow(notif, UDim2.new(1, 40, 1, 40), UDim2.new(0.5, 0, 0.5, 0), 0.6)
task.delay(5, function() notif:Destroy() end)

print("VISITING SOFTWARE fully loaded")
