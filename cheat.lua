--[[
Roblox Gelişmiş Hile Menüsü: Aimbot, ESP, Spinbot, Fly, Noclip, Invisible, Godmode, SilentAim, Araba Fırlat,
Yak Player, Patlat Player, Git Player, Yanina Çek, FOV Changer (TAM ÇALIŞIR!)
NOT: Eğitim/deneme içindir!
]]

-- Servisler ve Değişkenler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Menü Sistemi
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GelistirilmisHileMenu"
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Ana Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 475)
MainFrame.Position = UDim2.new(0.03,0,0.23,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
MainFrame.BackgroundTransparency = 0.34
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Başlık
local baslik = Instance.new("TextLabel", MainFrame)
baslik.Size = UDim2.new(1,0,0,38)
baslik.Position = UDim2.new(0,0,0,0)
baslik.Text = "ROBLOX HİLE MENÜSÜ (CTRL ile Kapat/Aç)"
baslik.Font = Enum.Font.SourceSansBold
baslik.TextSize = 22
baslik.TextColor3 = Color3.fromRGB(0,247,252)
baslik.BackgroundTransparency = 1

-- Sekme (Tab) Sistemi
local Tabs = {}
local CurrentTab = nil
local tabFrame = Instance.new("Frame", MainFrame)
tabFrame.Size = UDim2.new(1,0,0,34)
tabFrame.Position = UDim2.new(0,0,0,38)
tabFrame.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", MainFrame)
contentFrame.Size = UDim2.new(1,0,1,-72)
contentFrame.Position = UDim2.new(0,0,0,72)
contentFrame.BackgroundTransparency = 1

local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0,110,1,0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(33,33,34)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 18
    tabBtn.Text = name
    tabBtn.AutoButtonColor = true
    tabBtn.TextColor3 = Color3.new(0.9,0.9,0.95)
    local index = #Tabs+1
    tabBtn.Position = UDim2.new(0, (index-1)*112, 0,0)
    local cFrame = Instance.new("Frame", contentFrame)
    cFrame.Size = UDim2.new(1,0,1,0)
    cFrame.BackgroundTransparency = 1
    cFrame.Visible = false
    table.insert(Tabs, {Button = tabBtn, Frame = cFrame})
    tabBtn.MouseButton1Click:Connect(function()
        for _,tab in ipairs(Tabs) do
            tab.Frame.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(33,33,34)
        end
        cFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(70,105,130)
        CurrentTab = cFrame
    end)
    return cFrame
end

-- Sekmeleri Oluştur
local tabAimbot = createTab("Aimbot/FOV")
local tabESP    = createTab("Görsel")
local tabMisc   = createTab("Misc/Movement")
local tabPlayer = createTab("Oyuncu İşlemleri")

-- Varsayılan Tab Açık
wait()
Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(70,105,130)
Tabs[1].Frame.Visible = true
CurrentTab = Tabs[1].Frame

-- Özellikler Durumları
local states = {
    aimbot = false,
    esp = false,
    spinbot = false,
    fly = false,
    noclip = false,
    invisible = false,
    godmode = false,
    silentaim = false,
    fov = 70,
}
local flyConn, spinConn, ncConn = nil, nil, nil

-- Buton ve Slider Yardımcısı
local function addBtn(tab, ypos, textgen, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,185,0,30)
    btn.Position = UDim2.new(0,18,0,ypos)
    btn.BackgroundColor3 = Color3.fromRGB(48,49,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 17
    btn.Text = type(textgen)=="function" and textgen() or (textgen or "Button")
    btn.Parent = tab
    btn.MouseButton1Click:Connect(function()
        callback(btn)
        if type(textgen)=="function" then
            btn.Text = textgen()
        end
    end)
    return btn
end

local function addLabel(tab, ypos, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,185,0,24)
    lbl.Position = UDim2.new(0,18,0,ypos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(96,212,247)
    lbl.Font = Enum.Font.SourceSansItalic
    lbl.TextSize = 17
    lbl.Text = text
    lbl.Parent = tab
    return lbl
end

-- Aim & FOV Sekmesi
addLabel(tabAimbot,0,"Aimbot Özelliği")
addBtn(tabAimbot,28,function() return "Aimbot [" .. (states.aimbot and "Açık" or "Kapalı") .. "]" end, function()
    states.aimbot = not states.aimbot
end)

addLabel(tabAimbot,70,"FOV Ayarı (30-150)")
local fovBox = Instance.new("TextBox", tabAimbot)
fovBox.Size = UDim2.new(0,85,0,28)
fovBox.Position = UDim2.new(0,18,0,92)
fovBox.BackgroundColor3 = Color3.fromRGB(34,104,84)
fovBox.TextColor3 = Color3.fromRGB(0,255,127)
fovBox.TextSize = 16
fovBox.Font = Enum.Font.SourceSansBold
fovBox.Text = tostring(states.fov)
fovBox.ClearTextOnFocus = false
fovBox.FocusLost:Connect(function()
    local val = tonumber(fovBox.Text:match("%d+"))
    if val and val>=30 and val<=150 then
        states.fov = val
        Camera.FieldOfView = val
    else
        fovBox.Text = tostring(states.fov)
    end
end)
Camera.FieldOfView = states.fov

-- Görsel Sekmesi (ESP ve benzeri)
addLabel(tabESP,0,"ESP (Oyuncuları Etiketle)")
addBtn(tabESP,28,function() return "ESP [".. (states.esp and "Açık" or "Kapalı") .. "]" end, function()
    states.esp = not states.esp
    for _,p in pairs(Players:GetPlayers()) do
        local remove = function()
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPLabel") then
                p.Character.Head.ESPLabel:Destroy()
            end
        end
        if states.esp then
            if p~=LocalPlayer then
                -- Eklediğimizde
                if not (p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPLabel")) then
                    local b = Instance.new("BillboardGui")
                    b.AlwaysOnTop=true b.Size=UDim2.new(0,100,0,30) b.Name="ESPLabel"
                    local t = Instance.new("TextLabel",b)
                    t.Size=UDim2.new(1,0,1,0)
                    t.BackgroundTransparency=1
                    t.Font=Enum.Font.SourceSansBold
                    t.TextColor3=Color3.new(1,0,0) t.TextScaled=true t.Text=p.Name
                    if p.Character and p.Character:FindFirstChild("Head") then
                        b.Parent=p.Character.Head
                    end
                end
            end
        else
            remove()
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if states.esp then
        repeat wait() until p.Character and p.Character:FindFirstChild("Head")
        local b = Instance.new("BillboardGui")
        b.AlwaysOnTop=true b.Size=UDim2.new(0,100,0,30) b.Name="ESPLabel"
        local t = Instance.new("TextLabel",b)
        t.Size=UDim2.new(1,0,1,0)
        t.BackgroundTransparency=1
        t.Font=Enum.Font.SourceSansBold
        t.TextColor3=Color3.new(1,0,0) t.TextScaled=true t.Text=p.Name
        b.Parent=p.Character.Head
    end
end)

addLabel(tabESP,70,"SilentAim (Tetik, Gizli Aimbot)")
addBtn(tabESP,100,function() return "SilentAim ["..(states.silentaim and "Açık" or "Kapalı").."]" end, function()
    states.silentaim = not states.silentaim
end)

-- Misc/Movement Sekmesi
addLabel(tabMisc,0,"Spinbot (Sürekli Döndürür)")
addBtn(tabMisc,28,function() return "Spinbot [".. (states.spinbot and "Açık" or "Kapalı") .. "]" end, function()
    states.spinbot = not states.spinbot
    if states.spinbot and not spinConn then
        spinConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(24),0)
            end
        end)
    elseif spinConn then
        spinConn:Disconnect()
        spinConn=nil
    end
end)

addLabel(tabMisc,70,"Fly (Uçar)")
addBtn(tabMisc,98,function() return "Fly [".. (states.fly and "Açık" or "Kapalı") .. "]" end, function()
    states.fly = not states.fly
    if states.fly then
        flyConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Camera.CFrame.LookVector*70
            end
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn=nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

addLabel(tabMisc,142,"Noclip (Duvar içinden geç)")
addBtn(tabMisc,172,function() return "Noclip [" .. (states.noclip and "Açık" or "Kapalı") .. "]" end,function()
    states.noclip = not states.noclip
    if states.noclip then
        ncConn=RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide=false
                    end
                end
            end
        end)
    elseif ncConn then
        ncConn:Disconnect()
        ncConn=nil
        if LocalPlayer.Character then
            for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide=true
                end
            end
        end
    end
end)

addLabel(tabMisc,216,"Invisible (Görünmez Yap)")
addBtn(tabMisc,246,function() return "Invisible ["..(states.invisible and "Açık" or "Kapalı").."]" end,function()
    states.invisible=not states.invisible
    if LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = (states.invisible and 1 or 0)
            end
        end
    end
end)

addLabel(tabMisc,288,"Godmode (Ölümsüzlük)")
addBtn(tabMisc,318,function() return "Godmode ["..(states.godmode and "Açık" or "Kapalı").."]" end,function()
    states.godmode = not states.godmode
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        hum.MaxHealth = (states.godmode and math.huge or 100)
        hum.Health = hum.MaxHealth
    end
end)

-- Oyuncu Seçici Dropdown
local selectedTarget = nil
local function updateDropdown(dropdown)
    local text = "Hedef Oyuncu: " .. (selectedTarget and selectedTarget.Name or "Seçilmedi")
    dropdown.Text = text
end

local function makePlayerDropdown(tab,ypos)
    local dd = Instance.new("TextButton",tab)
    dd.Size = UDim2.new(0,185,0,28)
    dd.Position = UDim2.new(0,215,0,ypos)
    dd.TextColor3 = Color3.new(1,1,1)
    dd.BackgroundColor3 = Color3.fromRGB(45,51,57)
    dd.Font = Enum.Font.SourceSans
    dd.TextSize = 16
    updateDropdown(dd)

    dd.MouseButton1Click:Connect(function()
        local popup = Instance.new("Frame",ScreenGui)
        popup.Size = UDim2.new(0,160,0,22*#Players:GetPlayers())
        popup.Position = UDim2.new(0,MainFrame.Position.X.Offset+420,0,MainFrame.Position.Y.Offset+88)
        popup.BackgroundColor3 = Color3.fromRGB(30,30,30)
        popup.BorderSizePixel=2
        popup.Active = true
        for i,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local pBtn = Instance.new("TextButton",popup)
                pBtn.Size = UDim2.new(1,0,0,22)
                pBtn.Position = UDim2.new(0,0,0,22*(i-1))
                pBtn.Text = plr.Name
                pBtn.BackgroundColor3 = Color3.fromRGB(46,46,54)
                pBtn.Font = Enum.Font.SourceSans
                pBtn.TextColor3 = Color3.new(1,1,1)
                pBtn.TextSize=14
                pBtn.AutoButtonColor=true
                pBtn.MouseButton1Click:Connect(function()
                    selectedTarget = plr
                    updateDropdown(dd)
                    popup:Destroy()
                end)
            end
        end
        -- Oto kapat
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not popup:IsAncestorOf(game:GetService("Players").LocalPlayer:GetMouse().Target) then
                if popup then popup:Destroy() end
                if conn then conn:Disconnect() end
            end
        end)
    end)
    return dd
end

-- PLAYER HILELERI
addLabel(tabPlayer,2,"Özel Oyuncu Hileleri")
local playerDropdown = makePlayerDropdown(tabPlayer,28)

-- Araba Fırlat
addBtn(tabPlayer,66,"Araba Fırlat",function()
    for _,v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("VehicleSeat") then
            v:PivotTo(CFrame.new(v:GetPivot().Position,v:GetPivot().Position+Camera.CFrame.LookVector))
            local main = v.PrimaryPart or v:FindFirstChild("VehicleSeat")
            if main then
                main.Velocity = Camera.CFrame.LookVector*150+Vector3.new(0,30,0)
            end
        end
    end
end)

-- Yak Player
addBtn(tabPlayer,106,"Yak Player",function()
    if not selectedTarget or not selectedTarget.Character then return end
    for _,v in ipairs(selectedTarget.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.BrickColor=BrickColor.new("Bright orange")
            if not v:FindFirstChildOfClass("Fire") then
                local f=Instance.new("Fire",v)
                f.Size=8
                f.Heat=25
            end
        end
    end
    local hum=selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.Health=0 end
end)

-- Patlat Player
addBtn(tabPlayer,146,"Patlat Player",function()
    if not selectedTarget or not selectedTarget.Character then return end
    for i=1,5 do
        local root=selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local boom=Instance.new("Explosion",Workspace)
            boom.Position=root.Position
            boom.BlastRadius=7
            boom.BlastPressure=999999
            boom.ExplosionType=Enum.ExplosionType.Craters
        end
        wait(0.06)
    end
    local hum=selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum.Health=0 end
end)

-- Git Player (kendini seçili oyuncuya ışınla)
addBtn(tabPlayer,186,"Git Player",function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame=selectedTarget.Character.HumanoidRootPart.CFrame+Vector3.new(0,2,0)
    end
end)

-- Yanina Çek (seçili oyuncuyu yanına çek)
addBtn(tabPlayer,226,"Yanina Çek",function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedTarget.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,2,0)
    end
end)

-- Aimbot Sistemi (FOV dahil)
RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local closest, dist = nil, math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos,onScr = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).magnitude
                if mag<dist and onScr and mag<states.fov then closest=p dist=mag end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            Mouse.TargetFilter=closest.Character
            Camera.CFrame=CFrame.new(Camera.CFrame.Position,closest.Character.Head.Position)
        end
    end
end)

-- SilentAim Hooklama
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if states.silentaim and getnamecallmethod and getnamecallmethod()=="FindPartOnRayWithIgnoreList" then
        local args={...}
        local target=nil
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                target = p.Character.Head.Position
                break
            end
        end
        if target then
            args[1].Origin=Camera.CFrame.Position
            args[1].Direction=(target-Camera.CFrame.Position).unit*500
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- Kısayolla Menü Aç/Kapat
UserInputService.InputBegan:Connect(function(input,gp)
    if input.KeyCode==Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- End
