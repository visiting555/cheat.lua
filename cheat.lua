-- VISITING v11 - COMPLETE + HOTKEYS + FIXES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VS_V11"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 680, 0, 760)
Main.Position = UDim2.new(0.5, -340, 0.02, 0)
Main.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local function Shadow(parent)
    local s = Instance.new("ImageLabel", parent)
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0.5, 0, 0.5, 0)
    s.Size = UDim2.new(1, 80, 1, 80)
    s.Image = "rbxassetid://6015897843"
    s.ImageColor3 = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency = 0.7
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = parent.ZIndex - 1
end
Shadow(Main)

local Title = Instance.new("Frame", Main)
Title.Size = UDim2.new(1, 0, 0, 56)
Title.BackgroundColor3 = Color3.fromRGB(12, 14, 30)
Title.BorderSizePixel = 0
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 16)
local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
})

local Txt = Instance.new("TextLabel", Title)
Txt.Size = UDim2.new(1, -80, 1, 0)
Txt.Position = UDim2.new(0, 20, 0, 0)
Txt.BackgroundTransparency = 1
Txt.Text = "VISITING v11"
Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
Txt.Font = Enum.Font.GothamBlack
Txt.TextSize = 24
Txt.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0, 36, 0, 36)
Close.Position = UDim2.new(1, -46, 0.5, -18)
Close.BackgroundColor3 = Color3.fromRGB(255, 30, 70)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 24
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 10)
Close.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

local LeftPanel = Instance.new("Frame", Main)
LeftPanel.Size = UDim2.new(0, 140, 1, -56)
LeftPanel.Position = UDim2.new(0, 0, 0, 56)
LeftPanel.BackgroundColor3 = Color3.fromRGB(10, 12, 24)
LeftPanel.BorderSizePixel = 0

local RightPanel = Instance.new("Frame", Main)
RightPanel.Size = UDim2.new(1, -140, 1, -56)
RightPanel.Position = UDim2.new(0, 140, 0, 56)
RightPanel.BackgroundColor3 = Color3.fromRGB(6, 8, 18)
RightPanel.BorderSizePixel = 0
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 0)

_G.Dropdowns = {}

local Features = {
    Fly = {state = false, speed = 60, key = Enum.KeyCode.F1, mode = "Toggle"},
    NoClip = {state = false, key = Enum.KeyCode.F2, mode = "Toggle"},
    Aimbot = {state = false, fov = 120, smooth = 0.5, maxDist = 300, key = Enum.KeyCode.F3, mode = "Toggle"},
    SilentAim = {state = false, key = Enum.KeyCode.F4, mode = "Toggle"},
    Spinbot = {state = false, speed = 25, key = Enum.KeyCode.F5, mode = "Toggle"},
    MagicBullet = {state = false, key = Enum.KeyCode.F6, mode = "Toggle"},
    ESP = {state = false, box = false, name = false, skeleton = false, tracer = false, color = Color3.fromRGB(0,200,255), key = Enum.KeyCode.F7, mode = "Toggle"},
    DrawFOV = {state = false, key = Enum.KeyCode.F8, mode = "Toggle"},
    TeamCheck = {state = false, key = Enum.KeyCode.F9, mode = "Toggle"},
    AntiAFK = {state = false}
}

local Connections = {}
local ESPObjects = {}
local SpinAngle = 0
local FOVCircle = nil
local Holding = {}

local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
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
    for _, dd in ipairs(_G.Dropdowns) do
        if type(dd) == "function" then pcall(dd, names) end
    end
end

Players.PlayerAdded:Connect(function() task.wait(0.5) UpdateAllDropdowns() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) UpdateAllDropdowns() end)

local function FindRemoteEvent()
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("spin") or n:find("rotate") or n:find("character") or n:find("update") then
                return v
            end
        end
    end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            return v
        end
    end
    return nil
end
local SpinRemote = FindRemoteEvent()

function StartFly()
    if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
    local char = LocalPlayer.Character
    if not char then print("[FLY] Karakter yok") return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then print("[FLY] Humanoid/HRP yok") return end
    hum.PlatformStand = true
    local bg = Instance.new("BodyGyro", hrp)
    bg.Name = "FlyGyro"
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyVel"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    Connections.Fly = RunService.RenderStepped:Connect(function()
        if not Features.Fly.state then return end
        if not hrp or not hrp.Parent then return end
        local camCF = Camera.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * Features.Fly.speed or Vector3.new()
        bg.CFrame = camCF
    end)
    print("[FLY] Aktif")
end

function StopFly()
    if Connections.Fly then Connections.Fly:Disconnect(); Connections.Fly = nil end
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
    print("[FLY] Kapandı")
end

function StartNoClip()
    if Connections.NoClip then Connections.NoClip:Disconnect(); Connections.NoClip = nil end
    Connections.NoClip = RunService.Stepped:Connect(function()
        if not Features.NoClip.state then return end
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    print("[NOCLIP] Aktif")
end

function StopNoClip()
    if Connections.NoClip then Connections.NoClip:Disconnect(); Connections.NoClip = nil end
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    print("[NOCLIP] Kapandı")
end

function StartAimbot()
    if Connections.Aimbot then Connections.Aimbot:Disconnect(); Connections.Aimbot = nil end
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not Features.Aimbot.state then return end
        local closest, dist = nil, Features.Aimbot.fov
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then return end
        local myTeam = LocalPlayer.Team
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            if Features.TeamCheck.state and myTeam and p.Team and myTeam == p.Team then continue end
            local head = p.Character:FindFirstChild("Head")
            if not head then continue end
            local pos, on = Camera:WorldToViewportPoint(head.Position)
            if not on then continue end
            local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
            if d > dist then continue end
            local distance = (myPos.Position - head.Position).Magnitude
            if distance > Features.Aimbot.maxDist then continue end
            local ray = Ray.new(myPos.Position, (head.Position - myPos.Position).Unit * distance)
            local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
            if hit and not hit:IsDescendantOf(p.Character) then continue end
            dist = d
            closest = p
        end
        if closest and closest.Character then
            local head = closest.Character.Head
            local targetCF = CFrame.new(Camera.CFrame.Position, head.Position)
            if Features.SilentAim.state then
                local current = Camera.CFrame
                local new = current:Lerp(targetCF, Features.Aimbot.smooth)
                Camera.CFrame = new
            else
                Camera.CFrame = targetCF
            end
        end
    end)
    print("[AIMBOT] Aktif")
end

function StopAimbot()
    if Connections.Aimbot then Connections.Aimbot:Disconnect(); Connections.Aimbot = nil end
    print("[AIMBOT] Kapandı")
end

function StartSpinbot()
    if Connections.Spinbot then Connections.Spinbot:Disconnect(); Connections.Spinbot = nil end
    Connections.Spinbot = RunService.RenderStepped:Connect(function()
        if not Features.Spinbot.state then return end
        SpinAngle = (SpinAngle + Features.Spinbot.speed * 3.5) % 360
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local oldCF = hrp.CFrame
                hrp.CFrame = CFrame.new(oldCF.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
                if SpinRemote then
                    pcall(function()
                        SpinRemote:FireServer(hrp.CFrame)
                    end)
                end
            end
        end
    end)
    print("[SPINBOT] Aktif" .. (SpinRemote and " (Server-side)" or " (Client-side)"))
end

function StopSpinbot()
    if Connections.Spinbot then Connections.Spinbot:Disconnect(); Connections.Spinbot = nil end
    print("[SPINBOT] Kapandı")
end

function StartMagicBullet()
    if Connections.MagicBullet then Connections.MagicBullet:Disconnect(); Connections.MagicBullet = nil end
    local cache = {}
    Connections.MagicBullet = RunService.Stepped:Connect(function()
        if not Features.MagicBullet.state then return end
        local char = LocalPlayer.Character
        if not char then return end
        local now = tick()
        for _, obj in ipairs(Workspace:GetChildren()) do
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("BasePart") and child.Velocity.Magnitude > 20 then
                    local n = child.Name:lower()
                    if n:find("bullet") or n:find("projectile") or n:find("shell") or n:find("rocket") or n:find("missile") or n:find("arrow") then
                        if not cache[child] or cache[child] < now - 0.3 then
                            cache[child] = now
                            local closest, dist = nil, 400
                            local myTeam = LocalPlayer.Team
                            for _, p in ipairs(Players:GetPlayers()) do
                                if p == LocalPlayer or not p.Character then continue end
                                if Features.TeamCheck.state and myTeam and p.Team and myTeam == p.Team then continue end
                                local head = p.Character:FindFirstChild("Head")
                                if head then
                                    local d = (head.Position - child.Position).Magnitude
                                    if d < dist then
                                        dist = d
                                        closest = p
                                    end
                                end
                            end
                            if closest and closest.Character then
                                local head = closest.Character.Head
                                if head then
                                    child.CFrame = CFrame.new(head.Position)
                                    child.Velocity = Vector3.new()
                                    child.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
        end
        for k, v in pairs(cache) do
            if v < now - 2 then cache[k] = nil end
        end
    end)
    print("[MAGICBULLET] Aktif")
end

function StopMagicBullet()
    if Connections.MagicBullet then Connections.MagicBullet:Disconnect(); Connections.MagicBullet = nil end
    print("[MAGICBULLET] Kapandı")
end

function StartESP()
    if Connections.ESP then Connections.ESP:Disconnect(); Connections.ESP = nil end
    Connections.ESP = RunService.Heartbeat:Connect(function()
        if not Features.ESP.state then
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
            if not p.Character then
                if ESPObjects[p] then
                    for _, v in pairs(ESPObjects[p]) do if v and v.Remove then v:Remove() end end
                    ESPObjects[p] = nil
                end
                continue
            end
            local char = p.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            if not ESPObjects[p] then ESPObjects[p] = {} end
            local esp = ESPObjects[p]
            if Features.ESP.box then
                if not esp.Box then
                    esp.Box = Drawing.new("Square")
                    esp.Box.Thickness = 2
                    esp.Box.Filled = false
                    esp.Box.Color = Features.ESP.color
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
                        esp.Box.Color = Features.ESP.color
                    else esp.Box.Visible = false end
                else esp.Box.Visible = false end
            elseif esp.Box then esp.Box.Visible = false end
            if Features.ESP.name then
                if not esp.Name then
                    esp.Name = Drawing.new("Text")
                    esp.Name.Size = 14
                    esp.Name.Outline = true
                    esp.Name.Center = true
                    esp.Name.Color = Features.ESP.color
                end
                local head = char:FindFirstChild("Head")
                if head then
                    local pos, on = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    if on then
                        esp.Name.Visible = true
                        esp.Name.Position = Vector2.new(pos.X, pos.Y)
                        esp.Name.Text = p.Name
                        esp.Name.Color = Features.ESP.color
                    else esp.Name.Visible = false end
                else esp.Name.Visible = false end
            elseif esp.Name then esp.Name.Visible = false end
            if Features.ESP.skeleton then
                if not esp.Skeleton then
                    esp.Skeleton = {}
                    local joints = {
                        {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                        {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                        {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
                        {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
                        {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"}
                    }
                    for i = 1, #joints do
                        local line = Drawing.new("Line")
                        line.Thickness = 1.5
                        line.Color = Features.ESP.color
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
                            line.Color = Features.ESP.color
                        else line.Visible = false end
                    elseif line then line.Visible = false end
                end
            elseif esp.Skeleton then
                for _, line in ipairs(esp.Skeleton) do line.Visible = false end
            end
            if Features.ESP.tracer then
                if not esp.Tracer then
                    esp.Tracer = Drawing.new("Line")
                    esp.Tracer.Thickness = 1
                    esp.Tracer.Color = Features.ESP.color
                end
                local pos, on = Camera:WorldToViewportPoint(hrp.Position)
                if on then
                    esp.Tracer.Visible = true
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                    esp.Tracer.Color = Features.ESP.color
                else esp.Tracer.Visible = false end
            elseif esp.Tracer then esp.Tracer.Visible = false end
        end
    end)
    print("[ESP] Aktif")
end

function StopESP()
    if Connections.ESP then Connections.ESP:Disconnect(); Connections.ESP = nil end
    for _, esp in pairs(ESPObjects) do
        if esp.Box then esp.Box:Remove() end
        if esp.Name then esp.Name:Remove() end
        if esp.Tracer then esp.Tracer:Remove() end
        if esp.Skeleton then for _, line in ipairs(esp.Skeleton) do line:Remove() end end
    end
    ESPObjects = {}
    print("[ESP] Kapandı")
end

function DrawFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    if not Features.DrawFOV.state then return end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.5
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.NumSides = 64
    FOVCircle.Radius = Features.Aimbot.fov * 2.5
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = true
    Connections.FOVCircle = RunService.RenderStepped:Connect(function()
        if not Features.DrawFOV.state then
            if FOVCircle then FOVCircle.Visible = false end
            return
        end
        if FOVCircle then
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            FOVCircle.Radius = Features.Aimbot.fov * 2.5
            FOVCircle.Visible = true
        end
    end)
end

local function ClearRight()
    for _, v in ipairs(RightPanel:GetChildren()) do
        if v:IsA("ScrollingFrame") then v:Destroy() end
    end
end

local function BuildCategory(cat)
    ClearRight()
    local Scroll = Instance.new("ScrollingFrame", RightPanel)
    Scroll.Size = UDim2.new(1, -10, 1, -10)
    Scroll.Position = UDim2.new(0, 5, 0, 5)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 5
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 8)

    local function Section(text)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1, -10, 0, 32)
        f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(0, 200, 255)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
        local u = Instance.new("Frame", f)
        u.Size = UDim2.new(0.5, 0, 0, 2)
        u.Position = UDim2.new(0, 0, 1, -2)
        u.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        u.BorderSizePixel = 0
        return f
    end

    local function Toggle(text, stateRef, callback)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1, -10, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(220, 220, 230)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0.2, 0, 0, 28)
        btn.Position = UDim2.new(0.75, 0, 0.5, -14)
        btn.BackgroundColor3 = stateRef and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(45, 45, 60)
        btn.Text = stateRef and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function()
            stateRef = not stateRef
            btn.BackgroundColor3 = stateRef and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(45, 45, 60)
            btn.Text = stateRef and "ON" or "OFF"
            pcall(callback, stateRef)
        end)
        return f
    end

    local function Slider(text, min, max, default, callback)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1, -10, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text .. ": " .. tostring(default)
        l.TextColor3 = Color3.fromRGB(220, 220, 230)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        local bg = Instance.new("Frame", f)
        bg.Size = UDim2.new(0.4, 0, 0, 12)
        bg.Position = UDim2.new(0.55, 0, 0.5, -6)
        bg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        local fill = Instance.new("Frame", bg)
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)
        local dragging = false
        bg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local pos = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (pos * (max - min)))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                l.Text = text .. ": " .. tostring(val)
                pcall(callback, val)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (pos * (max - min)))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                l.Text = text .. ": " .. tostring(val)
                pcall(callback, val)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        return f
    end

    local function Button(text, callback)
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, -10, 0, 44)
        b.BackgroundColor3 = Color3.fromRGB(25, 28, 44)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(0, 200, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        b.MouseButton1Click:Connect(callback)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(35, 38, 54) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(25, 28, 44) end)
        return b
    end

    local function KeybindRow(featureName, labelText)
        local f = Instance.new("Frame", Scroll)
        f.Size = UDim2.new(1, -10, 0, 44)
        f.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.35, 0, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = labelText
        l.TextColor3 = Color3.fromRGB(220, 220, 230)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        local keyBtn = Instance.new("TextButton", f)
        keyBtn.Size = UDim2.new(0.25, 0, 0, 30)
        keyBtn.Position = UDim2.new(0.38, 0, 0.5, -15)
        keyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        local keyName = tostring(Features[featureName].key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
        keyBtn.Text = keyName
        keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBtn.Font = Enum.Font.Gotham
        keyBtn.TextSize = 12
        keyBtn.AutoButtonColor = false
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)
        local modeBtn = Instance.new("TextButton", f)
        modeBtn.Size = UDim2.new(0.2, 0, 0, 30)
        modeBtn.Position = UDim2.new(0.67, 0, 0.5, -15)
        modeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        modeBtn.Text = Features[featureName].mode
        modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        modeBtn.Font = Enum.Font.Gotham
        modeBtn.TextSize = 12
        modeBtn.AutoButtonColor = false
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            keyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Features[featureName].key = input.KeyCode
                    keyBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    keyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    conn:Disconnect()
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 or input.UserInputType == Enum.UserInputType.MouseButton4 or input.UserInputType == Enum.UserInputType.MouseButton5 then
                    Features[featureName].key = input.UserInputType
                    keyBtn.Text = tostring(input.UserInputType):gsub("Enum.UserInputType.", "")
                    keyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    conn:Disconnect()
                end
            end)
        end)
        modeBtn.MouseButton1Click:Connect(function()
            if Features[featureName].mode == "Toggle" then
                Features[featureName].mode = "Hold"
                modeBtn.Text = "Hold"
            else
                Features[featureName].mode = "Toggle"
                modeBtn.Text = "Toggle"
            end
        end)
        return f
    end

    if cat == "MOVEMENT" then
        Section("FLIGHT")
        Toggle("Fly", Features.Fly.state, function(v) Features.Fly.state = v; if v then StartFly() else StopFly() end end)
        Slider("Fly Speed", 10, 400, Features.Fly.speed, function(v) Features.Fly.speed = v end)
        Section("NOCLIP")
        Toggle("NoClip", Features.NoClip.state, function(v) Features.NoClip.state = v; if v then StartNoClip() else StopNoClip() end end)
        Section("WALK")
        local walkSpeed = 16
        Slider("Walk Speed", 16, 500, walkSpeed, function(v) walkSpeed = v; if LocalPlayer.Character then local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end end)
    elseif cat == "AIMBOT" then
        Section("AIMBOT")
        Toggle("Aimbot", Features.Aimbot.state, function(v) Features.Aimbot.state = v; if v then StartAimbot() else StopAimbot() end end)
        Toggle("Silent Aim", Features.SilentAim.state, function(v) Features.SilentAim.state = v end)
        Toggle("Team Check", Features.TeamCheck.state, function(v) Features.TeamCheck.state = v end)
        Slider("Aimbot FOV", 30, 300, Features.Aimbot.fov, function(v) Features.Aimbot.fov = v end)
        Slider("Aimbot Smooth", 1, 100, Features.Aimbot.smooth * 100, function(v) Features.Aimbot.smooth = v / 100 end)
        Slider("Max Distance", 100, 500, Features.Aimbot.maxDist, function(v) Features.Aimbot.maxDist = v end)
        Section("SPINBOT")
        Toggle("Spinbot", Features.Spinbot.state, function(v) Features.Spinbot.state = v; if v then StartSpinbot() else StopSpinbot() end end)
        Slider("Spin Speed", 1, 50, Features.Spinbot.speed, function(v) Features.Spinbot.speed = v end)
        Section("MAGIC BULLET")
        Toggle("Magic Bullet", Features.MagicBullet.state, function(v) Features.MagicBullet.state = v; if v then StartMagicBullet() else StopMagicBullet() end end)
        Section("DRAW FOV")
        Toggle("Draw FOV", Features.DrawFOV.state, function(v) Features.DrawFOV.state = v; if v then DrawFOVCircle() else if FOVCircle then FOVCircle:Remove(); FOVCircle = nil end end end)
    elseif cat == "ESP" then
        Section("ESP")
        Toggle("ESP", Features.ESP.state, function(v) Features.ESP.state = v; if v then StartESP() else StopESP() end end)
        Toggle("Box", Features.ESP.box, function(v) Features.ESP.box = v end)
        Toggle("Name", Features.ESP.name, function(v) Features.ESP.name = v end)
        Toggle("Skeleton", Features.ESP.skeleton, function(v) Features.ESP.skeleton = v end)
        Toggle("Tracer", Features.ESP.tracer, function(v) Features.ESP.tracer = v end)
        local espColor = Instance.new("Frame", Scroll)
        espColor.Size = UDim2.new(1, -10, 0, 44)
        espColor.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        espColor.BorderSizePixel = 0
        Instance.new("UICorner", espColor).CornerRadius = UDim.new(0, 10)
        local l10 = Instance.new("TextLabel", espColor)
        l10.Size = UDim2.new(0.5, 0, 1, 0)
        l10.Position = UDim2.new(0, 14, 0, 0)
        l10.BackgroundTransparency = 1
        l10.Text = "Color"
        l10.TextColor3 = Color3.fromRGB(220, 220, 230)
        l10.Font = Enum.Font.Gotham
        l10.TextSize = 13
        l10.TextXAlignment = Enum.TextXAlignment.Left
        local colorBtn = Instance.new("TextButton", espColor)
        colorBtn.Size = UDim2.new(0.2, 0, 0, 28)
        colorBtn.Position = UDim2.new(0.75, 0, 0.5, -14)
        colorBtn.BackgroundColor3 = Features.ESP.color
        colorBtn.Text = ""
        colorBtn.AutoButtonColor = false
        Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 8)
        local colors = {Color3.fromRGB(0,200,255), Color3.fromRGB(255,50,80), Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(255,255,255)}
        local idx = 1
        colorBtn.MouseButton1Click:Connect(function()
            idx = idx % #colors + 1
            colorBtn.BackgroundColor3 = colors[idx]
            Features.ESP.color = colors[idx]
        end)
    elseif cat == "HOTKEYS" then
        Section("HOTKEYS")
        KeybindRow("Fly", "Fly")
        KeybindRow("NoClip", "NoClip")
        KeybindRow("Aimbot", "Aimbot")
        KeybindRow("SilentAim", "Silent Aim")
        KeybindRow("Spinbot", "Spinbot")
        KeybindRow("MagicBullet", "Magic Bullet")
        KeybindRow("ESP", "ESP")
        KeybindRow("DrawFOV", "Draw FOV")
        KeybindRow("TeamCheck", "Team Check")
    elseif cat == "UTILITY" then
        Section("TELEPORT")
        local targetDD = Instance.new("Frame", Scroll)
        targetDD.Size = UDim2.new(1, -10, 0, 44)
        targetDD.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        targetDD.BorderSizePixel = 0
        Instance.new("UICorner", targetDD).CornerRadius = UDim.new(0, 10)
        local l11 = Instance.new("TextLabel", targetDD)
        l11.Size = UDim2.new(0.3, 0, 1, 0)
        l11.Position = UDim2.new(0, 14, 0, 0)
        l11.BackgroundTransparency = 1
        l11.Text = "Target"
        l11.TextColor3 = Color3.fromRGB(220, 220, 230)
        l11.Font = Enum.Font.Gotham
        l11.TextSize = 13
        l11.TextXAlignment = Enum.TextXAlignment.Left
        local ddBtn = Instance.new("TextButton", targetDD)
        ddBtn.Size = UDim2.new(0.5, -10, 0, 30)
        ddBtn.Position = UDim2.new(0.45, 0, 0.5, -15)
        ddBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        ddBtn.Text = "Select..."
        ddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ddBtn.Font = Enum.Font.Gotham
        ddBtn.TextSize = 12
        ddBtn.AutoButtonColor = false
        Instance.new("UICorner", ddBtn).CornerRadius = UDim.new(0, 8)
        local open = false
        local options = {}
        local function UpdateList(newOptions)
            for _, v in ipairs(options) do v:Destroy() end
            options = {}
            for i, opt in ipairs(newOptions) do
                local ob = Instance.new("TextButton", targetDD)
                ob.Size = UDim2.new(0.5, -10, 0, 28)
                ob.Position = UDim2.new(0.45, 0, 0, 6 + (i * 32))
                ob.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                ob.Text = opt
                ob.TextColor3 = Color3.fromRGB(200, 200, 210)
                ob.Font = Enum.Font.Gotham
                ob.TextSize = 12
                ob.Visible = false
                ob.AutoButtonColor = false
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 8)
                ob.MouseButton1Click:Connect(function()
                    ddBtn.Text = opt
                    open = false
                    targetDD.Size = UDim2.new(1, -10, 0, 44)
                    for _, b in ipairs(options) do b.Visible = false end
                    States.TargetPlayer = opt
                end)
                table.insert(options, ob)
            end
        end
        ddBtn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                targetDD.Size = UDim2.new(1, -10, 0, 44 + (#options * 32))
                for _, b in ipairs(options) do b.Visible = true end
            else
                targetDD.Size = UDim2.new(1, -10, 0, 44)
                for _, b in ipairs(options) do b.Visible = false end
            end
        end)
        _G.Dropdowns[#_G.Dropdowns+1] = UpdateList
        UpdateList(GetPlayerNames())
        local States = {TargetPlayer = nil}
        Button("Teleport to Target", function()
            if ddBtn.Text and ddBtn.Text ~= "Select..." then
                local p = GetPlayerByName(ddBtn.Text)
                if p and p.Character then
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP and tHRP then myHRP.CFrame = tHRP.CFrame + Vector3.new(0,3,0) end
                end
            end
        end)
        Button("Bring Target", function()
            if ddBtn.Text and ddBtn.Text ~= "Select..." then
                local p = GetPlayerByName(ddBtn.Text)
                if p and p.Character then
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP and tHRP then tHRP.CFrame = myHRP.CFrame + Vector3.new(0,3,0) end
                end
            end
        end)
        Section("FOV")
        Slider("FOV Changer", 30, 120, 70, function(v) Camera.FieldOfView = v end)
        Section("UTILITY")
        Toggle("Anti AFK", Features.AntiAFK.state, function(v)
            Features.AntiAFK.state = v
            if v then
                Connections.AFK = VirtualUser.Button2Down:Connect(function()
                    VirtualUser.Button2Up(Vector2.new(0,0), Camera.CFrame)
                end)
            else
                if Connections.AFK then Connections.AFK:Disconnect(); Connections.AFK = nil end
            end
        end)
        Button("Kill Target", function()
            if ddBtn.Text and ddBtn.Text ~= "Select..." then
                local p = GetPlayerByName(ddBtn.Text)
                if p and p.Character then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                            if v:IsA("RemoteEvent") and (v.Name:lower():find("damage") or v.Name:lower():find("kill")) then
                                pcall(function() v:FireServer(hum, 99999) end)
                            end
                        end
                        pcall(function() p.Character:BreakJoints() end)
                    end
                end
            end
        end)
    elseif cat == "GUIDE" then
        local guideText = [[
═══════════════════════════════════════
          VISITING v11 GUIDE
═══════════════════════════════════════

[CONTROLS]
INSERT  → Toggle Menu
END     → Emergency Stop (All Off)

[HOTKEYS KATEGORİSİ]
Tüm tuş atamaları ve Hold/Toggle modları
"HOTKEYS" bölümünden ayarlanabilir.

[MOVEMENT]
Fly       → W/A/S/D move, Space up, Shift down
NoClip    → Walk through walls
Walk Speed→ Adjust running speed

[AIMBOT]
Aimbot    → Auto-aim with wall check, Team Check, Max Distance
Silent Aim→ Bullets go to head without camera shake
FOV       → Aim field of view (drawable)
Smooth    → Aim smoothness
Magic Bullet→ Projectiles homing to target

[SPINBOT]
Spinbot   → Character spins (SERVER-SIDE via RemoteEvent)
Spin Speed→ Rotation speed (doesn't affect fly)

[ESP]
Box, Name, Skeleton, Tracer, Color

[FOV]
FOV Changer→ Camera field of view

[TELEPORT]
Select target, Teleport/Bring

[UTILITY]
Anti AFK, Kill Target

═══════════════════════════════════════
        MADE FOR TESTING
        EDUCATIONAL USE ONLY
═══════════════════════════════════════
]]
        local g = Instance.new("TextLabel", Scroll)
        g.Size = UDim2.new(1, -10, 0, 550)
        g.BackgroundColor3 = Color3.fromRGB(18, 20, 34)
        g.Text = guideText
        g.TextColor3 = Color3.fromRGB(200, 200, 210)
        g.Font = Enum.Font.Gotham
        g.TextSize = 13
        g.TextXAlignment = Enum.TextXAlignment.Left
        g.TextYAlignment = Enum.TextYAlignment.Top
        g.TextWrapped = true
        Instance.new("UICorner", g).CornerRadius = UDim.new(0, 10)
    end

    Scroll.CanvasSize = UDim2.new(0, 0, 0, #Scroll:GetChildren() * 52 + 100)
end

local Categories = {"MOVEMENT", "AIMBOT", "ESP", "HOTKEYS", "UTILITY", "GUIDE"}
local CatButtons = {}

for i, cat in ipairs(Categories) do
    local btn = Instance.new("TextButton", LeftPanel)
    btn.Size = UDim2.new(1, -10, 0, 44)
    btn.Position = UDim2.new(0, 5, 0, 5 + (i-1) * 50)
    btn.BackgroundColor3 = (cat == "MOVEMENT") and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(18, 20, 34)
    btn.Text = cat
    btn.TextColor3 = (cat == "MOVEMENT") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(CatButtons) do
            b.BackgroundColor3 = (b.Text == cat) and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(18, 20, 34)
            b.TextColor3 = (b.Text == cat) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
        end
        BuildCategory(cat)
    end)
    table.insert(CatButtons, btn)
end

local function ToggleFeature(name)
    local feature = Features[name]
    if not feature then return end
    if name == "Fly" then
        feature.state = not feature.state
        if feature.state then StartFly() else StopFly() end
    elseif name == "NoClip" then
        feature.state = not feature.state
        if feature.state then StartNoClip() else StopNoClip() end
    elseif name == "Aimbot" then
        feature.state = not feature.state
        if feature.state then StartAimbot() else StopAimbot() end
    elseif name == "SilentAim" then
        feature.state = not feature.state
        print("[SILENT AIM] " .. tostring(feature.state))
    elseif name == "Spinbot" then
        feature.state = not feature.state
        if feature.state then StartSpinbot() else StopSpinbot() end
    elseif name == "MagicBullet" then
        feature.state = not feature.state
        if feature.state then StartMagicBullet() else StopMagicBullet() end
    elseif name == "ESP" then
        feature.state = not feature.state
        if feature.state then StartESP() else StopESP() end
    elseif name == "DrawFOV" then
        feature.state = not feature.state
        if feature.state then DrawFOVCircle() else if FOVCircle then FOVCircle:Remove(); FOVCircle = nil end end
    elseif name == "TeamCheck" then
        feature.state = not feature.state
        print("[TEAM CHECK] " .. tostring(feature.state))
    end
end

local function SetFeatureState(name, state)
    local feature = Features[name]
    if not feature then return end
    if feature.state == state then return end
    if name == "Fly" then
        feature.state = state
        if state then StartFly() else StopFly() end
    elseif name == "NoClip" then
        feature.state = state
        if state then StartNoClip() else StopNoClip() end
    elseif name == "Aimbot" then
        feature.state = state
        if state then StartAimbot() else StopAimbot() end
    elseif name == "SilentAim" then
        feature.state = state
        print("[SILENT AIM] " .. tostring(state))
    elseif name == "Spinbot" then
        feature.state = state
        if state then StartSpinbot() else StopSpinbot() end
    elseif name == "MagicBullet" then
        feature.state = state
        if state then StartMagicBullet() else StopMagicBullet() end
    elseif name == "ESP" then
        feature.state = state
        if state then StartESP() else StopESP() end
    elseif name == "DrawFOV" then
        feature.state = state
        if state then DrawFOVCircle() else if FOVCircle then FOVCircle:Remove(); FOVCircle = nil end end
    elseif name == "TeamCheck" then
        feature.state = state
        print("[TEAM CHECK] " .. tostring(state))
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
        return
    end
    if input.KeyCode == Enum.KeyCode.End then
        ResetAll()
        return
    end
    for name, feature in pairs(Features) do
        if feature.key == input.KeyCode or feature.key == input.UserInputType then
            if feature.mode == "Toggle" then
                ToggleFeature(name)
            else
                if not Holding[name] then
                    Holding[name] = true
                    SetFeatureState(name, true)
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    for name, feature in pairs(Features) do
        if feature.mode == "Hold" and (feature.key == input.KeyCode or feature.key == input.UserInputType) then
            Holding[name] = false
            SetFeatureState(name, false)
        end
    end
end)

local function ResetAll()
    for name, feature in pairs(Features) do
        if feature.state then
            feature.state = false
            if name == "Fly" then StopFly()
            elseif name == "NoClip" then StopNoClip()
            elseif name == "Aimbot" then StopAimbot()
            elseif name == "Spinbot" then StopSpinbot()
            elseif name == "ESP" then StopESP()
            elseif name == "MagicBullet" then StopMagicBullet()
            elseif name == "DrawFOV" then
                if FOVCircle then FOVCircle:Remove(); FOVCircle = nil end
                if Connections.FOVCircle then Connections.FOVCircle:Disconnect(); Connections.FOVCircle = nil end
            elseif name == "AntiAFK" then
                if Connections.AFK then Connections.AFK:Disconnect(); Connections.AFK = nil end
            end
        end
    end
    ScreenGui.Enabled = false
    print("[RESET] Tüm özellikler kapatıldı")
end

local splash = Instance.new("TextLabel", ScreenGui)
splash.Size = UDim2.new(0, 480, 0, 48)
splash.Position = UDim2.new(0.5, -240, 0, 20)
splash.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
splash.Text = "VISITING v11 | INSERT | END | HOTKEYS Kategorisi Eklendi"
splash.TextColor3 = Color3.fromRGB(0, 200, 255)
splash.Font = Enum.Font.GothamBold
splash.TextSize = 18
Instance.new("UICorner", splash).CornerRadius = UDim.new(0, 12)
Shadow(splash)
task.delay(5, function() splash:Destroy() end)

BuildCategory("MOVEMENT")
UpdateAllDropdowns()
print("=== VISITING v11 YÜKLENDİ ===")
print("Team Check, Max Distance, FOV düzeltildi.")
print("Spinbot fly'ı bozmaz (sadece Y ekseninde döner).")
print("HOTKEYS kategorisi eklendi - tüm tuş atamaları orada.")
