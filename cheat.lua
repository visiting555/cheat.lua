local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnticheatTestSuite"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ANTICHEAT TEST SUITE"
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 0)
SidebarCorner.Parent = Sidebar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -180, 1, -50)
ContentFrame.Position = UDim2.new(0, 180, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local TabButtons = {}
local TabContents = {}

local function CreateTabButton(name, icon, order)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Tab"
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 10 + (order * 50))
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Button.Text = "  " .. icon .. "  " .. name
    Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Sidebar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    return Button
end

local function CreateTabContent(name)
    local Frame = Instance.new("ScrollingFrame")
    Frame.Name = name .. "Content"
    Frame.Size = UDim2.new(1, -20, 1, -20)
    Frame.Position = UDim2.new(0, 10, 0, 10)
    Frame.BackgroundTransparency = 1
    Frame.ScrollBarThickness = 4
    Frame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    Frame.CanvasSize = UDim2.new(0, 0, 0, 600)
    Frame.Visible = false
    Frame.Parent = ContentFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.Parent = Frame
    
    return Frame
end

local function SwitchTab(tabName)
    for name, content in pairs(TabContents) do
        content.Visible = (name == tabName)
    end
    for name, button in pairs(TabButtons) do
        if name == tabName then
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfo"
PlayerInfoFrame.Size = UDim2.new(1, -20, 0, 80)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerInfoFrame.Parent = Sidebar

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0, 8)
PlayerInfoCorner.Parent = PlayerInfoFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.Position = UDim2.new(0, 10, 0, 15)
AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
AvatarImage.Parent = PlayerInfoFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 25)
AvatarCorner.Parent = AvatarImage

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Name = "PlayerName"
PlayerNameLabel.Size = UDim2.new(0, 110, 0, 20)
PlayerNameLabel.Position = UDim2.new(0, 70, 0, 15)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = LocalPlayer.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 14
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerNameLabel.Parent = PlayerInfoFrame

local PlayTimeLabel = Instance.new("TextLabel")
PlayTimeLabel.Name = "PlayTime"
PlayTimeLabel.Size = UDim2.new(0, 110, 0, 20)
PlayTimeLabel.Position = UDim2.new(0, 70, 0, 40)
PlayTimeLabel.BackgroundTransparency = 1
PlayTimeLabel.Text = "00:00:00"
PlayTimeLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
PlayTimeLabel.TextSize = 12
PlayTimeLabel.Font = Enum.Font.Gotham
PlayTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayTimeLabel.Parent = PlayerInfoFrame

spawn(function()
    local startTime = tick()
    while true do
        wait(1)
        local elapsed = tick() - startTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        PlayTimeLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end
end)

local CharacterNameLabel = Instance.new("TextLabel")
CharacterNameLabel.Name = "CharacterName"
CharacterNameLabel.Size = UDim2.new(0, 110, 0, 15)
CharacterNameLabel.Position = UDim2.new(0, 70, 0, 58)
CharacterNameLabel.BackgroundTransparency = 1
CharacterNameLabel.Text = "Character: Loading..."
CharacterNameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CharacterNameLabel.TextSize = 10
CharacterNameLabel.Font = Enum.Font.Gotham
CharacterNameLabel.TextXAlignment = Enum.TextXAlignment.Left
CharacterNameLabel.Parent = PlayerInfoFrame

LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    CharacterNameLabel.Text = "Character: " .. char.Name
end)

if LocalPlayer.Character then
    CharacterNameLabel.Text = "Character: " .. LocalPlayer.Character.Name
end

local SettingsTab = CreateTabContent("Settings")
local ESPTab = CreateTabContent("ESP")
local AimbotTab = CreateTabContent("Aimbot")
local MovementTab = CreateTabContent("Movement")
local TeleportTab = CreateTabContent("Teleport")
local VisualsTab = CreateTabContent("Visuals")
local CharacterTab = CreateTabContent("Character")

TabButtons["Settings"] = CreateTabButton("Settings", "⚙", 0)
TabButtons["ESP"] = CreateTabButton("ESP", "👁", 1)
TabButtons["Aimbot"] = CreateTabButton("Aimbot", "🎯", 2)
TabButtons["Movement"] = CreateTabButton("Movement", "✈", 3)
TabButtons["Teleport"] = CreateTabButton("Teleport", "🌀", 4)
TabButtons["Visuals"] = CreateTabButton("Visuals", "👤", 5)
TabButtons["Character"] = CreateTabButton("Character", "🎭", 6)

TabContents["Settings"] = SettingsTab
TabContents["ESP"] = ESPTab
TabContents["Aimbot"] = AimbotTab
TabContents["Movement"] = MovementTab
TabContents["Teleport"] = TeleportTab
TabContents["Visuals"] = VisualsTab
TabContents["Character"] = CharacterTab

for name, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

local MenuColor = Color3.fromRGB(0, 200, 255)

local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = MenuColor
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    local SectionContent = Instance.new("Frame")
    SectionContent.Size = UDim2.new(1, -20, 0, 0)
    SectionContent.Position = UDim2.new(0, 10, 0, 35)
    SectionContent.AutomaticSize = Enum.AutomaticSize.Y
    SectionContent.BackgroundTransparency = 1
    SectionContent.Parent = Section
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = SectionContent
    
    return Section, SectionContent
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 50, 0, 25)
    Toggle.Position = UDim2.new(1, -55, 0, 5)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Toggle.Text = ""
    Toggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = Toggle
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0, 2)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Toggle
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(0, 10)
    CircleCorner.Parent = Circle
    
    local State = false
    
    Toggle.MouseButton1Click:Connect(function()
        State = not State
        if State then
            TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = MenuColor}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 28, 0, 2)}):Play()
        else
            TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
        callback(State)
    end)
    
    return Frame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = MenuColor
    ValueLabel.TextSize = 14
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 6)
    SliderBg.Position = UDim2.new(0, 0, 0, 30)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Frame
    
    local SliderBgCorner = Instance.new("UICorner")
    SliderBgCorner.CornerRadius = UDim.new(0, 3)
    SliderBgCorner.Parent = SliderBg
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = MenuColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 3)
    SliderFillCorner.Parent = SliderFill
    
    local Dragging = false
    
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (pos * (max - min)))
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    return Frame
end

local function CreateColorPicker(parent, text, defaultColor, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local ColorPreview = Instance.new("TextButton")
    ColorPreview.Size = UDim2.new(0, 60, 0, 25)
    ColorPreview.Position = UDim2.new(1, -65, 0, 7)
    ColorPreview.BackgroundColor3 = defaultColor
    ColorPreview.Text = ""
    ColorPreview.Parent = Frame
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 6)
    PreviewCorner.Parent = ColorPreview
    
    local RSlider = CreateSlider(Frame, "R", 0, 255, defaultColor.R * 255, function() end)
    RSlider.Position = UDim2.new(0, 0, 0, 40)
    RSlider.Visible = false
    
    local GSlider = CreateSlider(Frame, "G", 0, 255, defaultColor.G * 255, function() end)
    GSlider.Position = UDim2.new(0, 0, 0, 95)
    GSlider.Visible = false
    
    local BSlider = CreateSlider(Frame, "B", 0, 255, defaultColor.B * 255, function() end)
    BSlider.Position = UDim2.new(0, 0, 0, 150)
    BSlider.Visible = false
    
    local Expanded = false
    
    ColorPreview.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        RSlider.Visible = Expanded
        GSlider.Visible = Expanded
        BSlider.Visible = Expanded
        if Expanded then
            Frame.Size = UDim2.new(1, 0, 0, 200)
        else
            Frame.Size = UDim2.new(1, 0, 0, 40)
        end
    end)
    
    local function UpdateColor()
        local r = tonumber(RSlider:FindFirstChildOfClass("TextLabel", true) and RSlider:FindFirstChildOfClass("TextLabel", true).Text) or defaultColor.R * 255
        local g = tonumber(GSlider:FindFirstChildOfClass("TextLabel", true) and GSlider:FindFirstChildOfClass("TextLabel", true).Text) or defaultColor.G * 255
        local b = tonumber(BSlider:FindFirstChildOfClass("TextLabel", true) and BSlider:FindFirstChildOfClass("TextLabel", true).Text) or defaultColor.B * 255
        local newColor = Color3.fromRGB(r, g, b)
        ColorPreview.BackgroundColor3 = newColor
        callback(newColor)
    end
    
    return Frame
end

local function CreateDropdown(parent, text, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Dropdown = Instance.new("TextButton")
    Dropdown.Size = UDim2.new(0, 150, 0, 25)
    Dropdown.Position = UDim2.new(1, -155, 0, 5)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Dropdown.Text = options[1] or "Select"
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.TextSize = 12
    Dropdown.Font = Enum.Font.Gotham
    Dropdown.Parent = Frame
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = Dropdown
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(0, 150, 0, #options * 25)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 30)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 10
    OptionsFrame.Parent = Dropdown
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsFrame
    
    for i, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, 0, 0, 25)
        OptionBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
        OptionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        OptionBtn.Text = option
        OptionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionBtn.TextSize = 12
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.ZIndex = 11
        OptionBtn.Parent = OptionsFrame
        
        OptionBtn.MouseButton1Click:Connect(function()
            Dropdown.Text = option
            OptionsFrame.Visible = false
            callback(option)
        end)
    end
    
    Dropdown.MouseButton1Click:Connect(function()
        OptionsFrame.Visible = not OptionsFrame.Visible
    end)
    
    return Frame
end

local SettingsSection, SettingsContent = CreateSection(SettingsTab, "Menu Settings")
CreateColorPicker(SettingsContent, "Menu Accent Color", MenuColor, function(color)
    MenuColor = color
    TitleLabel.TextColor3 = color
    PlayTimeLabel.TextColor3 = color
    for _, button in pairs(TabButtons) do
        if button.BackgroundColor3 ~= Color3.fromRGB(30, 30, 40) then
            button.BackgroundColor3 = color
        end
    end
end)

local ESPSection, ESPContent = CreateSection(ESPTab, "ESP Settings")
local ESPStates = {
    Chams = false,
    Tracer = false,
    Box = false,
    HeadCircle = false,
    Enabled = false
}

local ESPColor = Color3.fromRGB(255, 0, 0)

CreateToggle(ESPContent, "Enable ESP", function(state)
    ESPStates.Enabled = state
end)

CreateToggle(ESPContent, "Chams ESP", function(state)
    ESPStates.Chams = state
end)

CreateToggle(ESPContent, "Tracer ESP", function(state)
    ESPStates.Tracer = state
end)

CreateToggle(ESPContent, "Box ESP", function(state)
    ESPStates.Box = state
end)

CreateToggle(ESPContent, "Head Circle ESP", function(state)
    ESPStates.HeadCircle = state
end)

CreateColorPicker(ESPContent, "ESP Color", ESPColor, function(color)
    ESPColor = color
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = ScreenGui

local function UpdateESP()
    ESPFolder:ClearAllChildren()
    if not ESPStates.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            
            if ESPStates.Chams then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.FillColor = ESPColor
                highlight.OutlineColor = ESPColor
                highlight.FillTransparency = 0.5
                highlight.Parent = ESPFolder
            end
            
            if ESPStates.Tracer and hrp then
                local tracer = Instance.new("LineHandleAdornment")
                tracer.Adornee = hrp
                tracer.Color3 = ESPColor
                tracer.Thickness = 2
                tracer.Length = 5
                tracer.Parent = ESPFolder
            end
            
            if ESPStates.Box and hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = hrp
                box.Color3 = ESPColor
                box.Transparency = 0.5
                box.Size = Vector3.new(4, 6, 2)
                box.Parent = ESPFolder
            end
            
            if ESPStates.HeadCircle and head then
                local circle = Instance.new("SphereHandleAdornment")
                circle.Adornee = head
                circle.Color3 = ESPColor
                circle.Transparency = 0.3
                circle.Radius = 1.5
                circle.Parent = ESPFolder
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)

local AimbotSection, AimbotContent = CreateSection(AimbotTab, "Aimbot Settings")
local AimbotEnabled = false
local SilentAimEnabled = false
local AimbotFOV = 100

CreateToggle(AimbotContent, "Enable Aimbot", function(state)
    AimbotEnabled = state
end)

CreateToggle(AimbotContent, "Silent Aim", function(state)
    SilentAimEnabled = state
end)

CreateSlider(AimbotContent, "Aimbot FOV", 10, 500, 100, function(value)
    AimbotFOV = value
end)

local FOVSection, FOVContent = CreateSection(VisualsTab, "FOV Changer")
local FOVEnabled = false
local CustomFOV = 70

CreateToggle(FOVContent, "Enable FOV Changer", function(state)
    FOVEnabled = state
    if state then
        Camera.FieldOfView = CustomFOV
    else
        Camera.FieldOfView = 70
    end
end)

CreateSlider(FOVContent, "FOV Value", 30, 120, 70, function(value)
    CustomFOV = value
    if FOVEnabled then
        Camera.FieldOfView = value
    end
end)

local CameraSection, CameraContent = CreateSection(VisualsTab, "Camera Settings")
local ThirdPersonEnabled = false
local FirstPersonEnabled = false

CreateToggle(CameraContent, "Force Third Person", function(state)
    ThirdPersonEnabled = state
    if state then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 50
        LocalPlayer.CameraMinZoomDistance = 5
    end
end)

CreateToggle(CameraContent, "Force First Person", function(state)
    FirstPersonEnabled = state
    if state then
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)

local MovementSection, MovementContent = CreateSection(MovementTab, "Movement Settings")
local FlyEnabled = false
local FlySpeed = 50
local GodModeEnabled = false

CreateToggle(MovementContent, "Enable Fly", function(state)
    FlyEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
    end
end)

CreateSlider(MovementContent, "Fly Speed", 10, 200, 50, function(value)
    FlySpeed = value
end)

CreateToggle(MovementContent, "God Mode", function(state)
    GodModeEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end)

local FlyConnection
FlyConnection = RunService.RenderStepped:Connect(function()
    if not FlyEnabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local direction = Vector3.new(0, 0, 0)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - Camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + Camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    if direction.Magnitude > 0 then
        hrp.Velocity = direction.Unit * FlySpeed
    else
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    hrp.RotVelocity = Vector3.new(0, 0, 0)
end)

local TeleportSection, TeleportContent = CreateSection(TeleportTab, "Player Teleport")
local SelectedPlayer = nil
local PlayerList = {}

local PlayerDropdown = CreateDropdown(TeleportContent, "Select Player", {"Loading..."}, function(selected)
    SelectedPlayer = selected
end)

local function UpdatePlayerList()
    PlayerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    
    local dropdownBtn = PlayerDropdown:FindFirstChildOfClass("TextButton")
    if dropdownBtn then
        dropdownBtn.Text = PlayerList[1] or "No Players"
        local optionsFrame = dropdownBtn:FindFirstChildOfClass("Frame")
        if optionsFrame then
            optionsFrame:ClearAllChildren()
            for i, name in ipairs(PlayerList) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 11
                btn.Parent = optionsFrame
                
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = name
                    optionsFrame.Visible = false
                    SelectedPlayer = name
                end)
            end
            optionsFrame.Size = UDim2.new(0, 150, 0, #PlayerList * 25)
        end
    end
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(1, 0, 0, 35)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
TeleportButton.Text = "Teleport to Selected Player"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextSize = 14
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Parent = TeleportContent

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 8)
TeleportCorner.Parent = TeleportButton

TeleportButton.MouseButton1Click:Connect(function()
    if not SelectedPlayer then return end
    local targetPlayer = Players:FindFirstChild(SelectedPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0)
end)

local CharacterSection, CharacterContent = CreateSection(CharacterTab, "Character Changer")
local CurrentSkin = "Default"

local Skins = {
    Chamber = function()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(50, 50, 60)
            end
        end
    end,
    Jett = function()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(200, 200, 220)
            end
        end
    end,
    Reyna = function()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(150, 0, 200)
            end
        end
    end,
    Pig = function()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(255, 180, 200)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    end,
    Cow = function()
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = Color3.fromRGB(240, 240, 240)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    end
}

CreateDropdown(CharacterContent, "Select Skin", {"Default", "Chamber", "Jett", "Reyna", "Pig", "Cow"}, function(selected)
    CurrentSkin = selected
    if Skins[selected] then
        Skins[selected]()
    elseif selected == "Default" then
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(163, 162, 165)
            end
        end
    end
end)

local BypassSection, BypassContent = CreateSection(SettingsTab, "Bypass Settings")
CreateToggle(BypassContent, "Anti-Ban Bypass", function(state)
    if state then
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
        end
    end
end)

CreateToggle(BypassContent, "Fly Bypass", function(state)
    if state then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end)

CreateToggle(BypassContent, "Aimbot Bypass", function(state)
    if state then
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldIndex = mt.__index
            mt.__index = newcclosure(function(self, key)
                if key == "CFrame" and self == Camera then
                    return oldIndex(self, key)
                end
                return oldIndex(self, key)
            end)
        end
    end
end)

SwitchTab("Settings")

local Dragging = false
local DragStart = nil
local StartPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    CharacterNameLabel.Text = "Character: " .. character.Name
    if GodModeEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
end)
