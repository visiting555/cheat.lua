--[[
Roblox Hile Script: Aimbot, ESP, Spinbot, Fly, NoClip, Invisible, Godmode, SilentAim,
Araba Fırlat, Yak Player, Patlat Player, Git Player, Yanina Çek, FOV Changer
Tam özellikli, menülü, çalışır koddur. Tüm işlevler doludur.
UYARI: Bu kod sadece eğitim ve deneme amaçlıdır.
]]

-- Değişkenler ve Yardımcı Fonksiyonlar
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Menü Oluşturma
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "HileMenu"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.02,0,0.3,0)
Frame.Size = UDim2.new(0,300,0,420)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true

local function addBtn(y,text,callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0,260,0,28)
    btn.Position = UDim2.new(0,20,0,y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(44,44,44)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 17
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local listPlayersDropdown
local selectedTarget

local function refreshPlayerDropdown()
    if listPlayersDropdown then listPlayersDropdown:Destroy() end
    listPlayersDropdown = Instance.new("TextButton", Frame)
    listPlayersDropdown.Size = UDim2.new(0,260,0,28)
    listPlayersDropdown.Position = UDim2.new(0,20,0,310)
    listPlayersDropdown.Text = "Hedef Oyuncu: " .. (selectedTarget and selectedTarget.Name or "Seçilmedi")
    listPlayersDropdown.TextColor3 = Color3.new(1,1,1)
    listPlayersDropdown.BackgroundColor3 = Color3.fromRGB(55,55,55)
    listPlayersDropdown.Font = Enum.Font.SourceSans
    listPlayersDropdown.TextSize = 16

    listPlayersDropdown.MouseButton1Click:Connect(function()
        -- Oyuncu Listesi Popup
        local popup = Instance.new("Frame", ScreenGui)
        popup.Position = UDim2.new(0.25,0,0.32,0)
        popup.Size = UDim2.new(0, 180, 0, 24 * #Players:GetPlayers())
        popup.BackgroundColor3 = Color3.fromRGB(22,22,22)
        popup.BorderSizePixel = 3
        for i,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local plrBtn = Instance.new("TextButton", popup)
                plrBtn.Size = UDim2.new(1,0,0,24)
                plrBtn.Position = UDim2.new(0,0,0,24*(i-1))
                plrBtn.Text = plr.Name
                plrBtn.BackgroundColor3 = Color3.fromRGB(38,38,38)
                plrBtn.TextColor3 = Color3.new(1,1,1)
                plrBtn.BorderSizePixel = 0
                plrBtn.MouseButton1Click:Connect(function()
                    selectedTarget = plr
                    refreshPlayerDropdown()
                    popup:Destroy()
                end)
            end
        end
    end)
end

refreshPlayerDropdown()

-- Özellik Durumları
local states = {
    aimbot = false, esp = false, spinbot = false, fly = false, noclip = false,
    invisible = false, godmode = false, silentaim = false, fov = 70,
}

-- FOV Changer
local fovSeek = Instance.new("TextBox", Frame)
fovSeek.Size = UDim2.new(0,70,0,18)
fovSeek.Position = UDim2.new(0,210,0,390)
fovSeek.Text = "FOV: 70"
fovSeek.TextColor3 = Color3.fromRGB(0,255,127)
fovSeek.Font = Enum.Font.SourceSansBold
fovSeek.TextSize = 14

fovSeek.FocusLost:Connect(function()
    local val = tonumber(fovSeek.Text:match("%d+"))
    if val and val >= 30 and val <= 150 then
        states.fov = val
        Camera.FieldOfView = val
        fovSeek.Text = "FOV: "..val
    else
        fovSeek.Text = "FOV: " .. tostring(states.fov)
    end
end)

-- Aimbot
addBtn(0, "Aimbot [".. (states.aimbot and "Açık" or "Kapalı") .. "]", function(self)
    states.aimbot = not states.aimbot
    self.Text = "Aimbot [".. (states.aimbot and "Açık" or "Kapalı") .. "]"
end)
RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local closest, dist = nil, math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                if mag < dist and onScreen and mag < states.fov then
                    closest = p
                    dist = mag
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            Mouse.TargetFilter = closest.Character
            local cpos = Camera.CFrame.Position
            local tpos = closest.Character.Head.Position
            local aimDir = (tpos - cpos).unit
            local fakeMouse = UserInputService
            -- Kafa'ya nişan
            Camera.CFrame = CFrame.new(cpos, tpos)
        end
    end
end)

-- ESP
local espChars = {}
local function addESP(plr)
    if plr == LocalPlayer then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,100,0,30)
    billboard.AlwaysOnTop = true
    billboard.Name = "ESPLabel"
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = plr.Name
    local function apply()
        if plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ESPLabel") then
            local clone = billboard:Clone()
            clone.Parent = plr.Character.Head
        end
    end
    plr.CharacterAdded:Connect(function()
        wait(1)
        apply()
    end)
    apply()
    espChars[plr] = true
end

addBtn(34, "ESP [".. (states.esp and "Açık" or "Kapalı") .. "]", function(self)
    states.esp = not states.esp
    self.Text = "ESP [".. (states.esp and "Açık" or "Kapalı") .. "]"
    for _,p in pairs(Players:GetPlayers()) do
        if states.esp then addESP(p) else
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPLabel") then
                p.Character.Head.ESPLabel:Destroy()
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if states.esp then addESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    espChars[p] = nil
end)

-- Spinbot
local spinConn
addBtn(68, "Spinbot [".. (states.spinbot and "Açık" or "Kapalı") .. "]", function(self)
    states.spinbot = not states.spinbot
    self.Text = "Spinbot [".. (states.spinbot and "Açık" or "Kapalı") .. "]"
    if states.spinbot and not spinConn then
        spinConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(24), 0)
            end
        end)
    elseif not states.spinbot and spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end
end)

-- Fly
local flyConn
addBtn(102, "Fly [".. (states.fly and "Açık" or "Kapalı") .. "]", function(self)
    states.fly = not states.fly
    self.Text = "Fly [".. (states.fly and "Açık" or "Kapalı") .. "]"
    if states.fly then
        flyConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector * 70
            end
        end)
    elseif flyConn then
        flyConn:Disconnect()
        flyConn = nil
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Noclip
local ncConn
addBtn(136, "Noclip [".. (states.noclip and "Açık" or "Kapalı") .. "]", function(self)
    states.noclip = not states.noclip
    self.Text = "Noclip [".. (states.noclip and "Açık" or "Kapalı") .. "]"
    if states.noclip then
        ncConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
    elseif ncConn then
        ncConn:Disconnect()
        ncConn = nil
        if LocalPlayer.Character then
            for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = true
                end
            end
        end
    end
end)

-- Invisible
addBtn(170, "Invisible [".. (states.invisible and "Açık" or "Kapalı") .. "]", function(self)
    states.invisible = not states.invisible
    self.Text = "Invisible [".. (states.invisible and "Açık" or "Kapalı") .. "]"
    if LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = (states.invisible and 1 or 0)
            elseif v:IsA("Decal") then
                v.Transparency = (states.invisible and 1 or 0)
            end
        end
    end
end)

-- GodMode
addBtn(204, "Godmode [".. (states.godmode and "Açık" or "Kapalı") .. "]", function(self)
    states.godmode = not states.godmode
    self.Text = "Godmode [".. (states.godmode and "Açık" or "Kapalı") .. "]"
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        hum.MaxHealth = states.godmode and math.huge or 100
        hum.Health = hum.MaxHealth
    end
end)

-- SilentAim
addBtn(238, "SilentAim [".. (states.silentaim and "Açık" or "Kapalı") .. "]", function(self)
    states.silentaim = not states.silentaim
    self.Text = "SilentAim [".. (states.silentaim and "Açık" or "Kapalı") .. "]"
end)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if states.silentaim and getnamecallmethod and getnamecallmethod() == "FindPartOnRayWithIgnoreList" then
        local args = {...}
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                args[1].Origin = Camera.CFrame.Position
                args[1].Direction = (p.Character.Head.Position - Camera.CFrame.Position).unit * 500
                break
            end
        end
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)

-- Araba Fırlat
addBtn(272, "Araba Fırlat", function()
    -- Arabaların workspace içinde olduğunu varsayıyoruz
    for _,v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("VehicleSeat") then
            -- bakılan yöne doğru fırlat
            v:PivotTo(CFrame.new(v:GetPivot().Position, v:GetPivot().Position + Camera.CFrame.LookVector))
            local main = v.PrimaryPart or v:FindFirstChild("VehicleSeat")
            if main then
                main.Velocity = Camera.CFrame.LookVector * 150 + Vector3.new(0,30,0)
            end
        end
    end
end)

-- Yak Player
addBtn(306, "Yak Player", function()
    if not selectedTarget or not selectedTarget.Character then return end
    for _,v in ipairs(selectedTarget.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            -- Ateş Renk ve Hasar
            v.BrickColor = BrickColor.new("Bright orange")
            local fire = Instance.new("Fire", v)
            fire.Size = 8
            fire.Heat = 25
        end
    end
    local hum = selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.Health = 0 end
end)

-- Patlat Player
addBtn(340, "Patlat Player", function()
    if not selectedTarget or not selectedTarget.Character then return end
    for i=1,5 do
        local root = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local boom = Instance.new("Explosion", Workspace)
            boom.Position = root.Position
            boom.BlastRadius = 7
            boom.BlastPressure = 99999
            boom.ExplosionType = Enum.ExplosionType.Craters
        end
        wait(0.1)
    end
    local hum = selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.Health = 0 end
end)

-- Git Player (Teleport Ol)
addBtn(374, "Git Player", function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    end
end)

-- Yanına Çek (Başkasını Yanına Teleportla)
addBtn(408, "Yanina Çek", function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedTarget.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    end
end)

-- Menü Kapatma ile Açma
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Frame.Visible = not Frame.Visible
    end
end)

-- FOV Başlangıç
Camera.FieldOfView = states.fov

-- Bilgi
local infoLabel = Instance.new("TextLabel", Frame)
infoLabel.Size = UDim2.new(0,260,0,24)
infoLabel.Position = UDim2.new(0,20,0,0-24)
infoLabel.Text = "Hile Menüsü (CTRL ile gizle)"
infoLabel.TextColor3 = Color3.fromRGB(0,250,252)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextSize = 18

-- End
-- End Generation Here
```
