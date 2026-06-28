--[[
Roblox Gelişmiş Hile Menüsü: Aimbot, ESP, Spinbot, Fly, Noclip, Invisible, Godmode, SilentAim, Araba Fırlat,
Yak Player, Patlat Player, Git Player, Yanina Çek, FOV Changer (TAM ÇALIŞIR!)
NOT: Eğitim/deneme içindir!
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GelistirilmisHileMenu"
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 530, 0, 590)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -295)
MainFrame.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
MainFrame.BackgroundTransparency = 0.18
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true
MainFrame.ClipsDescendants = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,38)
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "ROBLOX HİLE MENÜSÜ (F ile Aç/Kapat)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(0,247,252)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local tabFrame = Instance.new("Frame", MainFrame)
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,38)
tabFrame.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", MainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -78)
contentFrame.Position = UDim2.new(0,0,0,78)
contentFrame.BackgroundTransparency = 1

local Tabs = {}
local CurrentTab = nil

local function createTab(name)
    local numTabs = #Tabs
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0.24, -4, 1, -8)
    tabBtn.Position = UDim2.new(numTabs*0.25 + 0.017, 0, 0, 4)
    tabBtn.BackgroundColor3 = Color3.fromRGB(39,39,47)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 18
    tabBtn.Text = name
    tabBtn.AutoButtonColor = true
    tabBtn.TextColor3 = Color3.fromRGB(235,235,255)
    tabBtn.BorderSizePixel = 0

    local cFrame = Instance.new("Frame", contentFrame)
    cFrame.Size = UDim2.new(1,0,1,0)
    cFrame.Position = UDim2.new(0,0,0,0)
    cFrame.BackgroundTransparency = 1
    cFrame.Visible = (#Tabs==0)
    table.insert(Tabs, {Button = tabBtn, Frame = cFrame})

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(39,39,47)
        end
        cFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(70, 105, 130)
        CurrentTab = cFrame
    end)
    if #Tabs==1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(70,105,130)
        cFrame.Visible = true
        CurrentTab = cFrame
    end
    return cFrame
end

local tabAimbot = createTab("Aimbot/FOV")
local tabESP    = createTab("ESP/Görsel")
local tabMisc   = createTab("Misc/Movement")
local tabPlayer = createTab("Oyuncu Hileleri")

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
local flyConn, spinConn, noclipConn = nil, nil, nil
local flySpeed = 70
local flyKeys = {W=false,S=false,A=false,D=false,Q=false,E=false}
local invisibleConn = nil

local function addBtn(tab, xpos, ypos, width, textFN, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width or 185, 0, 30)
    btn.Position = UDim2.new(0, xpos or 18, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(48,49,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 17
    if typeof(textFN)=="function" then 
        btn.Text = textFN() 
    else 
        btn.Text = textFN or "Buton"
    end
    btn.Parent = tab
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(function()
        callback(btn)
        if typeof(textFN)=="function" then
            btn.Text = textFN()
        end
    end)
    return btn
end

local function addLabel(tab, xpos, ypos, width, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, width or 200, 0, 24)
    lbl.Position = UDim2.new(0, xpos or 18, 0, ypos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(96,212,247)
    lbl.Font = Enum.Font.SourceSansItalic
    lbl.TextSize = 16
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = tab
    return lbl
end

-- Aimbot/FOV TAB
addLabel(tabAimbot,12,8,200,"Aimbot (FOV İçinde Otomatik Hedef)")
addBtn(tabAimbot,16,36,190,function() return "Aimbot ["..(states.aimbot and "Açık" or "Kapalı").."]" end,function()
    states.aimbot = not states.aimbot
end)

addLabel(tabAimbot,12,76,200,"FOV Ayarı (30-150)")
local fovBox = Instance.new("TextBox", tabAimbot)
fovBox.Size = UDim2.new(0,100,0,28)
fovBox.Position = UDim2.new(0,16,0,98)
fovBox.BackgroundColor3 = Color3.fromRGB(34,104,84)
fovBox.TextColor3 = Color3.fromRGB(0,255,127)
fovBox.TextSize = 16
fovBox.Font = Enum.Font.SourceSansBold
fovBox.Text = tostring(states.fov)
fovBox.ClearTextOnFocus = false
fovBox.Parent = tabAimbot
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

-- ESP/Görsel TAB
addLabel(tabESP,12,8,215,"ESP (Oyuncuları Etiketle)")
addBtn(tabESP,16,36,210,function() return "ESP ["..(states.esp and "Açık" or "Kapalı").."]" end,function()
    states.esp = not states.esp
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if states.esp then
                if p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("ESPLabel") then
                    local b = Instance.new("BillboardGui")
                    b.AlwaysOnTop = true 
                    b.Size = UDim2.new(0,120,0,35) 
                    b.Name = "ESPLabel"
                    local t = Instance.new("TextLabel",b)
                    t.Size=UDim2.new(1,0,1,0)
                    t.BackgroundTransparency=1
                    t.Font=Enum.Font.SourceSansBold
                    t.TextColor3=Color3.new(1,0,0)
                    t.TextStrokeTransparency = 0.2
                    t.TextStrokeColor3 = Color3.new(0,0,0)
                    t.TextScaled=true
                    t.Text=p.Name
                    b.Parent=p.Character.Head
                end
            else
                if p.Character and p.Character:FindFirstChild("Head") then
                    local label = p.Character.Head:FindFirstChild("ESPLabel")
                    if label then label:Destroy() end
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function(char)
        repeat task.wait() until char:FindFirstChild("Head")
        if states.esp and not char.Head:FindFirstChild("ESPLabel") then
            local b = Instance.new("BillboardGui")
            b.AlwaysOnTop = true 
            b.Size = UDim2.new(0,120,0,35) 
            b.Name = "ESPLabel"
            local t = Instance.new("TextLabel",b)
            t.Size=UDim2.new(1,0,1,0)
            t.BackgroundTransparency=1
            t.Font=Enum.Font.SourceSansBold
            t.TextColor3=Color3.new(1,0,0)
            t.TextStrokeTransparency = 0.2
            t.TextStrokeColor3 = Color3.new(0,0,0)
            t.TextScaled=true
            t.Text=pl.Name
            b.Parent=char.Head
        end
    end)
end)

addLabel(tabESP,12,80,210,"SilentAim (Tetik, Gizli Aimbot)")
addBtn(tabESP,16,108,210,function() return "SilentAim ["..(states.silentaim and "Açık" or "Kapalı").."]" end,function()
    states.silentaim = not states.silentaim
end)

-- Movement/Misc TAB
addLabel(tabMisc,12,12,240,"Spinbot (Karakterini Döndürür)")
addBtn(tabMisc,16,38,145,function() return "Spinbot ["..(states.spinbot and "Açık" or "Kapalı").."]" end,function()
    states.spinbot = not states.spinbot
    if states.spinbot and not spinConn then
        spinConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(17),0)
            end
        end)
    elseif spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end
end)

addLabel(tabMisc,190,12,90,"Fly (Uçar)")
addBtn(tabMisc,200,38,95,function() return "Fly ["..(states.fly and "Açık" or "Kapalı").."]" end,function()
    states.fly = not states.fly
    if states.fly and not flyConn then
        local hrp = nil
        local flyBodyVel = nil
        flyConn = RunService.RenderStepped:Connect(function()
            LocalPlayer = Players.LocalPlayer
            hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not flyBodyVel or not flyBodyVel.Parent then
                    flyBodyVel = Instance.new("BodyVelocity")
                    flyBodyVel.MaxForce = Vector3.new(1,1,1) * 1e6
                    flyBodyVel.Velocity = Vector3.zero
                    flyBodyVel.Parent = hrp
                end
                local move = Vector3.zero
                if flyKeys.W then move = move + Camera.CFrame.LookVector end
                if flyKeys.S then move = move - Camera.CFrame.LookVector end
                if flyKeys.A then move = move - Camera.CFrame.RightVector end
                if flyKeys.D then move = move + Camera.CFrame.RightVector end
                if flyKeys.E then move = move + Camera.CFrame.UpVector end
                if flyKeys.Q then move = move - Camera.CFrame.UpVector end
                if move.Magnitude > 0 then
                    flyBodyVel.Velocity = move.Unit * flySpeed
                else
                    flyBodyVel.Velocity = Vector3.zero
                end
            end
        end)
    elseif flyConn then
        flyConn:Disconnect()
        flyConn = nil
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _,bv in ipairs(hrp:GetChildren()) do
                if bv:IsA("BodyVelocity") then
                    bv:Destroy()
                end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then flyKeys.W=true end
    if i.KeyCode == Enum.KeyCode.S then flyKeys.S=true end
    if i.KeyCode == Enum.KeyCode.A then flyKeys.A=true end
    if i.KeyCode == Enum.KeyCode.D then flyKeys.D=true end
    if i.KeyCode == Enum.KeyCode.E then flyKeys.E=true end
    if i.KeyCode == Enum.KeyCode.Q then flyKeys.Q=true end
end)
UserInputService.InputEnded:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then flyKeys.W=false end
    if i.KeyCode == Enum.KeyCode.S then flyKeys.S=false end
    if i.KeyCode == Enum.KeyCode.A then flyKeys.A=false end
    if i.KeyCode == Enum.KeyCode.D then flyKeys.D=false end
    if i.KeyCode == Enum.KeyCode.E then flyKeys.E=false end
    if i.KeyCode == Enum.KeyCode.Q then flyKeys.Q=false end
end)

addLabel(tabMisc,12,85,170,"Noclip (Duvarlardan Geç)")
addBtn(tabMisc,16,112,145,function() return "Noclip ["..(states.noclip and "Açık" or "Kapalı").."]" end,function()
    states.noclip = not states.noclip
    if states.noclip and not noclipConn then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

addLabel(tabMisc,190,85,145,"Invisible (Görünmez)")
addBtn(tabMisc,200,112,110,function() return "Invisible ["..(states.invisible and "Açık" or "Kapalı").."]" end,function()
    states.invisible = not states.invisible
    if invisibleConn then
        invisibleConn:Disconnect()
        invisibleConn = nil
    end
    local function setInvis(char, invis)
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = invis and 1 or 0
                v.Transparency = invis and 1 or 0
                v.CanCollide = not invis
            elseif v:IsA("Decal") or v:IsA("MeshPart") then
                v.Transparency = invis and 1 or 0
            end
        end
    end
    local char = LocalPlayer.Character
    if char then setInvis(char, states.invisible) end
    invisibleConn = LocalPlayer.CharacterAdded:Connect(function(c)
        task.wait(0.25)
        setInvis(c, states.invisible)
    end)
end)

addLabel(tabMisc,12,170,200,"Godmode (Ölümsüzlük Ver)")
addBtn(tabMisc,16,196,145,function() return "Godmode ["..(states.godmode and "Açık" or "Kapalı").."]" end,function()
    states.godmode = not states.godmode
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        hum.MaxHealth = (states.godmode and math.huge or 100)
        hum.Health = hum.MaxHealth
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if states.godmode and hum.Health < hum.MaxHealth - 10 then
                hum.MaxHealth = math.huge
                hum.Health = hum.MaxHealth
            end
        end)
    end
end)

-- Oyuncu Hileleri
addLabel(tabPlayer,12,8,260,"Oyuncu İşlemleri (Oyuncu Seç ve Hileleri Kullan)")
local selectedTarget = nil

local function updateDropdown(dropdown)
    local t = "Seçili Hedef: " .. (selectedTarget and selectedTarget.Name or "Yok")
    dropdown.Text = t
end

local function makePlayerDropdown(tab, xpos, ypos)
    local ddBtn = Instance.new("TextButton", tab)
    ddBtn.Size = UDim2.new(0,260,0,32)
    ddBtn.Position = UDim2.new(0, xpos or 18,0,ypos)
    ddBtn.BackgroundColor3 = Color3.fromRGB(44,49,66)
    ddBtn.TextColor3 = Color3.fromRGB(230,230,230)
    ddBtn.Font = Enum.Font.SourceSansBold
    ddBtn.TextSize = 17
    ddBtn.TextXAlignment = Enum.TextXAlignment.Left
    updateDropdown(ddBtn)
    ddBtn.BorderSizePixel = 0
    ddBtn.AutoButtonColor = true
    ddBtn.MouseButton1Click:Connect(function()
        local popup = Instance.new("Frame",ScreenGui)
        local playerList = {}
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(playerList, plr)
            end
        end
        popup.Size = UDim2.new(0,225,0,#playerList>0 and 32*#playerList or 32)
        popup.Position = UDim2.new(0, MainFrame.AbsolutePosition.X+MainFrame.Size.X.Offset+8, 0, MainFrame.AbsolutePosition.Y+64)
        popup.BackgroundColor3 = Color3.fromRGB(31,31,38)
        popup.BorderSizePixel = 2
        popup.ZIndex = 300
        popup.Active = true
        popup.ClipsDescendants = true
        local list = Instance.new("UIListLayout", popup)
        list.FillDirection = Enum.FillDirection.Vertical
        list.SortOrder = Enum.SortOrder.LayoutOrder
        for _,plr in ipairs(playerList) do
            local pBtn = Instance.new("TextButton", popup)
            pBtn.Size = UDim2.new(1,0,0,32)
            pBtn.BackgroundColor3 = Color3.fromRGB(46,46,54)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextColor3 = Color3.new(1,1,1)
            pBtn.TextSize=15
            pBtn.Text = plr.Name
            pBtn.BorderSizePixel = 0
            pBtn.ZIndex=301
            pBtn.MouseButton1Click:Connect(function()
                selectedTarget = plr
                updateDropdown(ddBtn)
                popup:Destroy()
            end)
        end
        local uisConn
        uisConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mouse = UserInputService:GetMouseLocation()
                if not (mouse.X > popup.AbsolutePosition.X and mouse.X < popup.AbsolutePosition.X + popup.AbsoluteSize.X and mouse.Y > popup.AbsolutePosition.Y and mouse.Y < popup.AbsolutePosition.Y + popup.AbsoluteSize.Y) then
                    popup:Destroy()
                    if uisConn then uisConn:Disconnect() end
                end
            end
        end)
    end)
    return ddBtn
end

local playerDropdown = makePlayerDropdown(tabPlayer, 16, 50)

addBtn(tabPlayer,16,96,185,"Araba Fırlat",function()
    for _,v in ipairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChildWhichIsA("VehicleSeat") then
            local pos = v:GetPivot().Position
            v:PivotTo(CFrame.new(pos, pos + Camera.CFrame.LookVector))
            local main = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if main then
                main.Velocity = Camera.CFrame.LookVector*150 + Vector3.new(0,40,0)
            end
        end
    end
end)

addBtn(tabPlayer,210,96,245,"Yak Player",function()
    if not selectedTarget or not selectedTarget.Character then
        return
    end
    for _,v in ipairs(selectedTarget.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.BrickColor = BrickColor.new("Bright orange")
            if not v:FindFirstChildOfClass("Fire") then
                local f = Instance.new("Fire", v)
                f.Size = 10
                f.Heat = 34
            end
        end
    end
    local hum = selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        hum:TakeDamage(hum.Health*0.99 + 2)
    end
end)

addBtn(tabPlayer,16,140,185,"Patlat Player",function()
    if not selectedTarget or not selectedTarget.Character then return end
    local root = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
    for i=1,6 do
        if root then
            local boom = Instance.new("Explosion")
            boom.Position = root.Position + Vector3.new(math.random(-2,2), math.random(-1,1), math.random(-2,2))
            boom.BlastRadius = 8
            boom.BlastPressure = 2e6
            boom.ExplosionType = Enum.ExplosionType.Craters
            boom.Parent = Workspace
        end
        task.wait(0.18)
    end
    local hum = selectedTarget.Character:FindFirstChildWhichIsA("Humanoid")
    if hum then
        hum.Health = 0
    end
end)

addBtn(tabPlayer,210,140,245,"Git Player",function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    local myroot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myroot then
        myroot.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    end
end)

addBtn(tabPlayer,16,184,185,"Yanına Çek",function()
    if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") then return end
    local myroot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myroot then
        selectedTarget.Character.HumanoidRootPart.CFrame = myroot.CFrame + Vector3.new(0,2,0)
    end
end)

addBtn(tabPlayer,210,184,245,"Oyuncuyu Takip Et",function()
    if not selectedTarget or not selectedTarget.Character or not LocalPlayer.Character then return end
    local myroot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
    if myroot and targetRoot then
        local followConn
        followConn = RunService.RenderStepped:Connect(function()
            if not selectedTarget or not selectedTarget.Character or not selectedTarget.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if followConn then followConn:Disconnect() end
            else
                local my = LocalPlayer.Character.HumanoidRootPart
                local tar = selectedTarget.Character.HumanoidRootPart
                if (tar.Position - my.Position).Magnitude > 3 then
                    my.CFrame = CFrame.new(tar.Position + Vector3.new(0,3,0))
                end
            end
        end)
        task.spawn(function()
            task.wait(8)
            if followConn then followConn:Disconnect() end
        end)
    end
end)

-- Aimbot Sistemi
local function getClosestPlayerToCursor(fov)
    local closest, dist = nil, fov or states.fov
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChildWhichIsA("Humanoid") and p.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
            local pos,onScr = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
            if mag < dist and onScr then
                closest = p
                dist = mag
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local target = getClosestPlayerToCursor(states.fov)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Mouse.TargetFilter = target.Character
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if states.silentaim and typeof(getnamecallmethod) == "function" and getnamecallmethod()=="FindPartOnRayWithIgnoreList" then
        local args={...}
        local targetPlr = getClosestPlayerToCursor(states.fov)
        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("Head") then
            args[1].Origin=Camera.CFrame.Position
            args[1].Direction=(targetPlr.Character.Head.Position-Camera.CFrame.Position).unit*900
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

UserInputService.InputBegan:Connect(function(input,gp)
    if input.KeyCode==Enum.KeyCode.F and not gp then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
