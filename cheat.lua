local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local MenuColor = Color3.fromRGB(0, 200, 255)
local ESPColor = Color3.fromRGB(255, 0, 0)

local ESPStates = {
    Chams = false,
    Tracer = false,
    Box = false,
    HeadCircle = false,
    Enabled = false
}

local AimbotEnabled = false
local SilentAimEnabled = false
local AimbotFOV = 100
local FOVEnabled = false
local CustomFOV = 70
local ThirdPersonEnabled = false
local FirstPersonEnabled = false
local FlyEnabled = false
local FlySpeed = 50
local GodModeEnabled = false
local NoClipEnabled = false
local SelectedPlayer = nil
local CurrentSkin = "Default"
local MenuVisible = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sarabazaki.lua"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 750, 0, 520)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -260)
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
TopBar.ZIndex = 100
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "sarabazaki.lua"
TitleLabel.TextColor3 = MenuColor
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 101
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
CloseButton.ZIndex = 101
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 50
Sidebar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -200, 1, -50)
ContentFrame.Position = UDim2.new(0, 200, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 1
ContentFrame.Parent = MainFrame

local TabButtons = {}
local TabContents = {}

local function CreateTabButton(name, icon, order)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Tab"
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 120 + (order * 50))
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Button.Text = "  " .. icon .. "  " .. name
    Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.ZIndex = 51
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
    Frame.ScrollBarImageColor3 = MenuColor
    Frame.CanvasSize = UDim2.new(0, 0, 0, 800)
    Frame.Visible = false
    Frame.ZIndex = 2
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
            button.BackgroundColor3 = MenuColor
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfo"
PlayerInfoFrame.Size = UDim2.new(1, -20, 0, 100)
PlayerInfoFrame.Position = UDim2.new(0, 10, 0, 10)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerInfoFrame.ZIndex = 52
PlayerInfoFrame.Parent = Sidebar

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0, 8)
PlayerInfoCorner.Parent = PlayerInfoFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Size = UDim2.new(0, 60, 0, 60)
AvatarImage.Position = UDim2.new(0, 10, 0, 20)
AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.ZIndex = 53
AvatarImage.Parent = PlayerInfoFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 30)
AvatarCorner.Parent = AvatarImage

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Name = "PlayerName"
PlayerNameLabel.Size = UDim2.new(0, 110, 0, 20)
PlayerNameLabel.Position = UDim2.new(0, 80, 0, 20)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = LocalPlayer.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 14
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerNameLabel.ZIndex = 53
PlayerNameLabel.Parent = PlayerInfoFrame

local PlayTimeLabel = Instance.new("TextLabel")
PlayTimeLabel.Name = "PlayTime"
PlayTimeLabel.Size = UDim2.new(0, 110, 0, 20)
PlayTimeLabel.Position = UDim2.new(0, 80, 0, 42)
PlayTimeLabel.BackgroundTransparency = 1
PlayTimeLabel.Text = "00:00:00"
PlayTimeLabel.TextColor3 = MenuColor
PlayTimeLabel.TextSize = 12
PlayTimeLabel.Font = Enum.Font.Gotham
PlayTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayTimeLabel.ZIndex = 53
PlayTimeLabel.Parent = PlayerInfoFrame

spawn(function()
    local startTime = tick()
    while ScreenGui and ScreenGui.Parent do
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
CharacterNameLabel.Position = UDim2.new(0, 80, 0, 62)
CharacterNameLabel.BackgroundTransparency = 1
CharacterNameLabel.Text = "Character: Loading..."
CharacterNameLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CharacterNameLabel.TextSize = 10
CharacterNameLabel.Font = Enum.Font.Gotham
CharacterNameLabel.TextXAlignment = Enum.TextXAlignment.Left
CharacterNameLabel.ZIndex = 53
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
    ValueLabel.Name = "ValueLabel"
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
    SliderBg.Name = "SliderBg"
    SliderBg.Size = UDim2.new(1, 0, 0, 6)
    SliderBg.Position = UDim2.new(0, 0, 0, 30)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Frame
    
    local SliderBgCorner = Instance.new("UICorner")
    SliderBgCorner.CornerRadius = UDim.new(0, 3)
    SliderBgCorner.Parent = SliderBg
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
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
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (pos * (max - min)))
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            callback(value)
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
    ColorPreview.Name = "ColorPreview"
    ColorPreview.Size = UDim2.new(0, 60, 0, 25)
    ColorPreview.Position = UDim2.new(1, -65, 0, 7)
    ColorPreview.BackgroundColor3 = defaultColor
    ColorPreview.Text = ""
    ColorPreview.Parent = Frame
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 6)
    PreviewCorner.Parent = ColorPreview
    
    local ExpandedFrame = Instance.new("Frame")
    ExpandedFrame.Name = "ExpandedFrame"
    ExpandedFrame.Size = UDim2.new(1, 0, 0, 160)
    ExpandedFrame.Position = UDim2.new(0, 0, 0, 40)
    ExpandedFrame.BackgroundTransparency = 1
    ExpandedFrame.Visible = false
    ExpandedFrame.Parent = Frame
    
    local RSlider = CreateSlider(ExpandedFrame, "R", 0, 255, math.floor(defaultColor.R * 255), function(v) end)
    RSlider.Position = UDim2.new(0, 0, 0, 0)
    
    local GSlider = CreateSlider(ExpandedFrame, "G", 0, 255, math.floor(defaultColor.G * 255), function(v) end)
    GSlider.Position = UDim2.new(0, 0, 0, 55)
    
    local BSlider = CreateSlider(ExpandedFrame, "B", 0, 255, math.floor(defaultColor.B * 255), function(v) end)
    BSlider.Position = UDim2.new(0, 0, 0, 110)
    
    local Expanded = false
    
    local function GetCurrentColor()
        local rVal = tonumber(RSlider.ValueLabel.Text) or math.floor(defaultColor.R * 255)
        local gVal = tonumber(GSlider.ValueLabel.Text) or math.floor(defaultColor.G * 255)
        local bVal = tonumber(BSlider.ValueLabel.Text) or math.floor(defaultColor.B * 255)
        return Color3.fromRGB(rVal, gVal, bVal)
    end
    
    ColorPreview.MouseButton1Click:Connect(function()
        Expanded = not Expanded
        ExpandedFrame.Visible = Expanded
        if Expanded then
            Frame.Size = UDim2.new(1, 0, 0, 200)
        else
            Frame.Size = UDim2.new(1, 0, 0, 40)
            local newColor = GetCurrentColor()
            ColorPreview.BackgroundColor3 = newColor
            callback(newColor)
        end
    end)
    
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
    Dropdown.Name = "Dropdown"
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
    OptionsFrame.Name = "OptionsFrame"
    OptionsFrame.Size = UDim2.new(0, 150, 0, #options * 25)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 30)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 100
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
        OptionBtn.ZIndex = 101
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

local ColorPickerFrame = CreateColorPicker(SettingsContent, "Menu Accent Color", MenuColor, function(color)
    MenuColor = color
    TitleLabel.TextColor3 = color
    PlayTimeLabel.TextColor3 = color
    for name, button in pairs(TabButtons) do
        if button.BackgroundColor3 ~= Color3.fromRGB(30, 30, 40) then
            button.BackgroundColor3 = color
        end
    end
end)

local ESPSection, ESPContent = CreateSection(ESPTab, "ESP Settings")

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

local ESPColorPicker = CreateColorPicker(ESPContent, "ESP Color", ESPColor, function(color)
    ESPColor = color
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = ScreenGui

local function WorldToScreen(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function GetCharacterBounds(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not hrp or not head then return nil end
    
    local topPos = head.Position + Vector3.new(0, 0.5, 0)
    local bottomPos = hrp.Position - Vector3.new(0, 3, 0)
    
    local topScreen, topVisible = WorldToScreen(topPos)
    local bottomScreen, bottomVisible = WorldToScreen(bottomPos)
    
    if not topVisible and not bottomVisible then return nil end
    
    local height = math.abs(bottomScreen.Y - topScreen.Y)
    local width = height * 0.5
    
    return {
        Top = topScreen,
        Bottom = bottomScreen,
        Center = Vector2.new((topScreen.X + bottomScreen.X) / 2, (topScreen.Y + bottomScreen.Y) / 2),
        Height = height,
        Width = width,
        Visible = true
    }
end

local function UpdateESP()
    for _, child in pairs(ESPFolder:GetChildren()) do
        child:Destroy()
    end
    
    if not ESPStates.Enabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if not hrp or not humanoid or humanoid.Health <= 0 then continue end
            
            local bounds = GetCharacterBounds(character)
            if not bounds then continue end
            
            if ESPStates.Chams then
                local highlight = Instance.new("Highlight")
                highlight.Name = player.Name .. "_Chams"
                highlight.Adornee = character
                highlight.FillColor = ESPColor
                highlight.OutlineColor = ESPColor
                highlight.FillTransparency = 0.6
                highlight.OutlineTransparency = 0.1
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = ESPFolder
            end
            
            if ESPStates.Tracer then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                local tracerLine = Instance.new("Frame")
                tracerLine.Name = player.Name .. "_Tracer"
                tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
                tracerLine.BackgroundColor3 = ESPColor
                tracerLine.BorderSizePixel = 0
                tracerLine.ZIndex = 5
                
                local distance = (bounds.Bottom - screenCenter).Magnitude
                local angle = math.atan2(bounds.Bottom.Y - screenCenter.Y, bounds.Bottom.X - screenCenter.X)
                
                tracerLine.Size = UDim2.new(0, distance, 0, 2)
                tracerLine.Position = UDim2.new(0, (screenCenter.X + bounds.Bottom.X) / 2, 0, (screenCenter.Y + bounds.Bottom.Y) / 2)
                tracerLine.Rotation = math.deg(angle)
                tracerLine.Parent = ESPFolder
            end
            
            if ESPStates.Box then
                local boxFrame = Instance.new("Frame")
                boxFrame.Name = player.Name .. "_Box"
                boxFrame.Size = UDim2.new(0, bounds.Width, 0, bounds.Height)
                boxFrame.Position = UDim2.new(0, bounds.Center.X - bounds.Width / 2, 0, bounds.Top.Y)
                boxFrame.BackgroundTransparency = 1
                boxFrame.BorderSizePixel = 0
                boxFrame.ZIndex = 5
                
                local topLine = Instance.new("Frame")
                topLine.Size = UDim2.new(1, 0, 0, 2)
                topLine.BackgroundColor3 = ESPColor
                topLine.BorderSizePixel = 0
                topLine.Parent = boxFrame
                
                local bottomLine = Instance.new("Frame")
                bottomLine.Size = UDim2.new(1, 0, 0, 2)
                bottomLine.Position = UDim2.new(0, 0, 1, -2)
                bottomLine.BackgroundColor3 = ESPColor
                bottomLine.BorderSizePixel = 0
                bottomLine.Parent = boxFrame
                
                local leftLine = Instance.new("Frame")
                leftLine.Size = UDim2.new(0, 2, 1, 0)
                leftLine.BackgroundColor3 = ESPColor
                leftLine.BorderSizePixel = 0
                leftLine.Parent = boxFrame
                
                local rightLine = Instance.new("Frame")
                rightLine.Size = UDim2.new(0, 2, 1, 0)
                rightLine.Position = UDim2.new(1, -2, 0, 0)
                rightLine.BackgroundColor3 = ESPColor
                rightLine.BorderSizePixel = 0
                rightLine.Parent = boxFrame
                
                boxFrame.Parent = ESPFolder
            end
            
            if ESPStates.HeadCircle and head then
                local headScreen, headVisible = WorldToScreen(head.Position)
                if headVisible then
                    local headTopScreen = WorldToScreen(head.Position + Vector3.new(0, 0.8, 0))
                    local radius = math.abs(headScreen.Y - headTopScreen.Y) * 0.6
                    
                    local circleFrame = Instance.new("Frame")
                    circleFrame.Name = player.Name .. "_HeadCircle"
                    circleFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
                    circleFrame.Position = UDim2.new(0, headScreen.X - radius, 0, headScreen.Y - radius)
                    circleFrame.BackgroundTransparency = 1
                    circleFrame.ZIndex = 5
                    
                    local circleBg = Instance.new("Frame")
                    circleBg.Size = UDim2.new(1, 0, 1, 0)
                    circleBg.BackgroundTransparency = 1
                    circleBg.BorderSizePixel = 2
                    circleBg.BorderColor3 = ESPColor
                    circleBg.Parent = circleFrame
                    
                    local circleCorner = Instance.new("UICorner")
                    circleCorner.CornerRadius = UDim.new(1, 0)
                    circleCorner.Parent = circleBg
                    
                    local circleFill = Instance.new("Frame")
                    circleFill.Size = UDim2.new(1, -4, 1, -4)
                    circleFill.Position = UDim2.new(0, 2, 0, 2)
                    circleFill.BackgroundColor3 = ESPColor
                    circleFill.BackgroundTransparency = 0.85
                    circleFill.Parent = circleBg
                    
                    local fillCorner = Instance.new("UICorner")
                    fillCorner.CornerRadius = UDim.new(1, 0)
                    fillCorner.Parent = circleFill
                    
                    circleFrame.Parent = ESPFolder
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)

local AimbotSection, AimbotContent = CreateSection(AimbotTab, "Aimbot Settings")

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

CreateToggle(CameraContent, "Force Third Person", function(state)
    ThirdPersonEnabled = state
    if state then
        FirstPersonEnabled = false
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 50
        LocalPlayer.CameraMinZoomDistance = 5
    end
end)

CreateToggle(CameraContent, "Force First Person", function(state)
    FirstPersonEnabled = state
    if state then
        ThirdPersonEnabled = false
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)

local MovementSection, MovementContent = CreateSection(MovementTab, "Movement Settings")

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

CreateToggle(MovementContent, "NoClip", function(state)
    NoClipEnabled = state
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

RunService.Stepped:Connect(function()
    if not NoClipEnabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

local TeleportSection, TeleportContent = CreateSection(TeleportTab, "Player Teleport")
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
    
    local dropdownBtn = PlayerDropdown:FindFirstChild("Dropdown")
    if dropdownBtn then
        dropdownBtn.Text = PlayerList[1] or "No Players"
        local optionsFrame = dropdownBtn:FindFirstChild("OptionsFrame")
        if optionsFrame then
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for i, name in ipairs(PlayerList) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 101
                btn.Parent = optionsFrame
                
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = name
                    optionsFrame.Visible = false
                    SelectedPlayer = name
                end)
            end
            optionsFrame.Size = UDim2.new(0, 150, 0, math.max(#PlayerList * 25, 25))
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

local Skins = {
    Chamber = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(30, 30, 40)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
            local face = Instance.new("Decal")
            face.Texture = "rbxassetid://127959113"
            face.Face = Enum.NormalId.Front
            face.Parent = head
        end
        
        local upperTorso = character:FindFirstChild("UpperTorso")
        if upperTorso then
            upperTorso.Color = Color3.fromRGB(40, 40, 55)
        end
        local lowerTorso = character:FindFirstChild("LowerTorso")
        if lowerTorso then
            lowerTorso.Color = Color3.fromRGB(35, 35, 50)
        end
    end,
    
    Jett = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(220, 220, 230)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
            local face = Instance.new("Decal")
            face.Texture = "rbxassetid://127959113"
            face.Face = Enum.NormalId.Front
            face.Parent = head
        end
        
        local upperTorso = character:FindFirstChild("UpperTorso")
        if upperTorso then
            upperTorso.Color = Color3.fromRGB(200, 210, 225)
        end
        local lowerTorso = character:FindFirstChild("LowerTorso")
        if lowerTorso then
            lowerTorso.Color = Color3.fromRGB(180, 190, 210)
        end
    end,
    
    Reyna = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(20, 20, 20)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
            local face = Instance.new("Decal")
            face.Texture = "rbxassetid://127959113"
            face.Face = Enum.NormalId.Front
            face.Parent = head
            
            local glow = Instance.new("PointLight")
            glow.Color = Color3.fromRGB(150, 0, 200)
            glow.Brightness = 2
            glow.Range = 10
            glow.Parent = head
        end
        
        local upperTorso = character:FindFirstChild("UpperTorso")
        if upperTorso then
            upperTorso.Color = Color3.fromRGB(30, 30, 30)
        end
        local lowerTorso = character:FindFirstChild("LowerTorso")
        if lowerTorso then
            lowerTorso.Color = Color3.fromRGB(25, 25, 25)
        end
    end,
    
    Pig = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(255, 180, 200)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
            
            local snout = Instance.new("Part")
            snout.Name = "Snout"
            snout.Size = Vector3.new(0.8, 0.6, 0.6)
            snout.Color = Color3.fromRGB(255, 160, 180)
            snout.Material = Enum.Material.SmoothPlastic
            snout.Parent = character
            
            local snoutWeld = Instance.new("Weld")
            snoutWeld.Part0 = head
            snoutWeld.Part1 = snout
            snoutWeld.C0 = CFrame.new(0, -0.2, 0.6)
            snoutWeld.Parent = snout
            
            local leftEar = Instance.new("Part")
            leftEar.Name = "LeftEar"
            leftEar.Size = Vector3.new(0.4, 0.6, 0.3)
            leftEar.Color = Color3.fromRGB(255, 160, 180)
            leftEar.Material = Enum.Material.SmoothPlastic
            leftEar.Parent = character
            
            local leftEarWeld = Instance.new("Weld")
            leftEarWeld.Part0 = head
            leftEarWeld.Part1 = leftEar
            leftEarWeld.C0 = CFrame.new(-0.6, 0.5, 0)
            leftEarWeld.Parent = leftEar
            
            local rightEar = Instance.new("Part")
            rightEar.Name = "RightEar"
            rightEar.Size = Vector3.new(0.4, 0.6, 0.3)
            rightEar.Color = Color3.fromRGB(255, 160, 180)
            rightEar.Material = Enum.Material.SmoothPlastic
            rightEar.Parent = character
            
            local rightEarWeld = Instance.new("Weld")
            rightEarWeld.Part0 = head
            rightEarWeld.Part1 = rightEar
            rightEarWeld.C0 = CFrame.new(0.6, 0.5, 0)
            rightEarWeld.Parent = rightEar
            
            local tail = Instance.new("Part")
            tail.Name = "Tail"
            tail.Size = Vector3.new(0.3, 0.3, 1)
            tail.Color = Color3.fromRGB(255, 160, 180)
            tail.Material = Enum.Material.SmoothPlastic
            tail.Parent = character
            
            local lowerTorso = character:FindFirstChild("LowerTorso")
            if lowerTorso then
                local tailWeld = Instance.new("Weld")
                tailWeld.Part0 = lowerTorso
                tailWeld.Part1 = tail
                tailWeld.C0 = CFrame.new(0, 0, 0.8)
                tailWeld.Parent = tail
            end
        end
    end,
    
    Cow = function()
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(240, 240, 240)
                part.Material = Enum.Material.SmoothPlastic
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
            
            local spots = {
                {Vector3.new(0, 0.5, 0.4), Vector3.new(0.3, 0.3, 0.1)},
                {Vector3.new(-0.4, 0, 0.4), Vector3.new(0.2, 0.4, 0.1)},
                {Vector3.new(0.4, -0.3, 0.3), Vector3.new(0.25, 0.25, 0.1)},
            }
            
            for _, spotData in ipairs(spots) do
                local spot = Instance.new("Part")
                spot.Name = "Spot"
                spot.Size = spotData[2]
                spot.Color = Color3.fromRGB(30, 30, 30)
                spot.Material = Enum.Material.SmoothPlastic
                spot.Parent = character
                
                local spotWeld = Instance.new("Weld")
                spotWeld.Part0 = head
                spotWeld.Part1 = spot
                spotWeld.C0 = CFrame.new(spotData[1])
                spotWeld.Parent = spot
            end
            
            local leftHorn = Instance.new("Part")
            leftHorn.Name = "LeftHorn"
            leftHorn.Size = Vector3.new(0.2, 0.5, 0.2)
            leftHorn.Color = Color3.fromRGB(200, 180, 150)
            leftHorn.Material = Enum.Material.SmoothPlastic
            leftHorn.Parent = character
            
            local leftHornWeld = Instance.new("Weld")
            leftHornWeld.Part0 = head
            leftHornWeld.Part1 = leftHorn
            leftHornWeld.C0 = CFrame.new(-0.5, 0.6, 0)
            leftHornWeld.Parent = leftHorn
            
            local rightHorn = Instance.new("Part")
            rightHorn.Name = "RightHorn"
            rightHorn.Size = Vector3.new(0.2, 0.5, 0.2)
            rightHorn.Color = Color3.fromRGB(200, 180, 150)
            rightHorn.Material = Enum.Material.SmoothPlastic
            rightHorn.Parent = character
            
            local rightHornWeld = Instance.new("Weld")
            rightHornWeld.Part0 = head
            rightHornWeld.Part1 = rightHorn
            rightHornWeld.C0 = CFrame.new(0.5, 0.6, 0)
            rightHornWeld.Parent = rightHorn
            
            local nose = Instance.new("Part")
            nose.Name = "Nose"
            nose.Size = Vector3.new(0.6, 0.4, 0.3)
            nose.Color = Color3.fromRGB(255, 180, 180)
            nose.Material = Enum.Material.SmoothPlastic
            nose.Parent = character
            
            local noseWeld = Instance.new("Weld")
            noseWeld.Part0 = head
            noseWeld.Part1 = nose
            noseWeld.C0 = CFrame.new(0, -0.2, 0.5)
            noseWeld.Parent = nose
            
            local tail = Instance.new("Part")
            tail.Name = "Tail"
            tail.Size = Vector3.new(0.2, 0.8, 0.2)
            tail.Color = Color3.fromRGB(240, 240, 240)
            tail.Material = Enum.Material.SmoothPlastic
            tail.Parent = character
            
            local lowerTorso = character:FindFirstChild("LowerTorso")
            if lowerTorso then
                local tailWeld = Instance.new("Weld")
                tailWeld.Part0 = lowerTorso
                tailWeld.Part1 = tail
                tailWeld.C0 = CFrame.new(0, 0, 0.8)
                tailWeld.Parent = tail
            end
        end
        
        for _, partName in ipairs({"UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}) do
            local part = character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                for i = 1, 3 do
                    local spot = Instance.new("Part")
                    spot.Name = "BodySpot"
                    spot.Size = Vector3.new(0.4, 0.4, 0.1)
                    spot.Color = Color3.fromRGB(30, 30, 30)
                    spot.Material = Enum.Material.SmoothPlastic
                    spot.Parent = character
                    
                    local spotWeld = Instance.new("Weld")
                    spotWeld.Part0 = part
                    spotWeld.Part1 = spot
                    spotWeld.C0 = CFrame.new(math.random(-5, 5) / 10, math.random(-5, 5) / 10, part.Size.Z / 2 + 0.05)
                    spotWeld.Parent = spot
                end
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
                part.Material = Enum.Material.Plastic
            end
        end
        
        for _, extra in pairs(character:GetChildren()) do
            if extra:IsA("Part") and (extra.Name == "Snout" or extra.Name == "LeftEar" or extra.Name == "RightEar" or extra.Name == "Tail" or extra.Name == "Spot" or extra.Name == "BodySpot" or extra.Name == "LeftHorn" or extra.Name == "RightHorn" or extra.Name == "Nose") then
                extra:Destroy()
            end
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in pairs(head:GetChildren()) do
                if decal:IsA("Decal") or decal:IsA("Texture") then
                    decal:Destroy()
                end
            end
        end
    end
end)

local BypassSection, BypassContent = CreateSection(SettingsTab, "Bypass Settings")

CreateToggle(BypassContent, "Anti-Ban Bypass", function(state)
    if state then
        local success, mt = pcall(getrawmetatable, game)
        if success and mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    warn("[BYPASS] Kick attempt blocked")
                    return nil
                end
                return oldNamecall(self, ...)
            end)
            
            local oldIndex = mt.__index
            mt.__index = newcclosure(function(self, key)
                if tostring(self) == "Humanoid" and key == "Health" then
                    return 100
                end
                return oldIndex(self, key)
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
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        end
    end
end)

CreateToggle(BypassContent, "Aimbot Bypass", function(state)
    if state then
        local success, mt = pcall(getrawmetatable, game)
        if success and mt then
            setreadonly(mt, false)
            local oldIndex = mt.__index
            mt.__index = newcclosure(function(self, key)
                if self == Camera and key == "CFrame" then
                    local cf = oldIndex(self, key)
                    return cf
                end
                return oldIndex(self, key)
            end)
        end
    end
end)

CreateToggle(BypassContent, "Anti-Cheat Bypass", function(state)
    if state then
        local success, mt = pcall(getrawmetatable, game)
        if success and mt then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if method == "FireServer" then
                    local remoteName = tostring(self)
                    if remoteName:lower():find("ban") or remoteName:lower():find("kick") or remoteName:lower():find("report") or remoteName:lower():find("cheat") or remoteName:lower():find("detect") then
                        warn("[BYPASS] Blocked remote: " .. remoteName)
                        return nil
                    end
                end
                
                if method == "InvokeServer" then
                    local remoteName = tostring(self)
                    if remoteName:lower():find("ban") or remoteName:lower():find("kick") or remoteName:lower():find("report") or remoteName:lower():find("cheat") or remoteName:lower():find("detect") then
                        warn("[BYPASS] Blocked remote: " .. remoteName)
                        return nil
                    end
                end
                
                return oldNamecall(self, ...)
            end)
        end
        
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("ban") or name:find("kick") or name:find("report") or name:find("cheat") or name:find("detect") or name:find("anticheat") then
                    pcall(function()
                        remote.OnClientEvent:Connect(function()
                            warn("[BYPASS] Blocked client event from: " .. remote.Name)
                            return nil
                        end)
                    end)
                end
            end
        end
    end
end)

SwitchTab("Settings")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.N then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
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
    
    if CurrentSkin ~= "Default" and Skins[CurrentSkin] then
        wait(0.5)
        Skins[CurrentSkin]()
    end
end)
