local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local MenuColor = Color3.fromRGB(220, 20, 60)
local ESPColor = Color3.fromRGB(255, 0, 0)
local AdminColor = Color3.fromRGB(255, 0, 0)
local OwnerColor = Color3.fromRGB(255, 215, 0)

local ESPStates = {
    Chams = false,
    Box = false,
    Name = false,
    Skeleton = false,
    Tracer = false,
    Enabled = false
}

local SilentAimEnabled = false
local KillAllEnabled = false
local KillTargetEnabled = false
local AntiAFKEnabled = false
local FakeAdminEnabled = false
local FakeOwnerEnabled = false
local ChatAdminEnabled = false
local ChatOwnerEnabled = false
local FOVEnabled = false
local RainbowCharEnabled = false
local GlassCharEnabled = false
local ShowFPSEnabled = false
local FlyCarEnabled = false
local CarNoclipEnabled = false
local WalkSpeedEnabled = false
local WalkSpeedValue = 16
local FlyEnabled = false
local FlySpeedValue = 50
local NoClipEnabled = false
local TeleportTarget = nil
local KillTarget = nil
local MouthTarget = nil
local CustomFOV = 70
local CarSpeedValue = 100
local FPSLabel = nil
local RainbowConnection = nil
local AntiAFKConnection = nil
local FlyConnection = nil
local NoClipConnection = nil
local SpinConnection = nil
local MouthConnection = nil
local MenuVisible = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "sarabazaki.lua"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 800, 0, 550)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 100
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 500, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "sarabazaki.lua"
TitleLabel.TextColor3 = MenuColor
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 101
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
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
Sidebar.Size = UDim2.new(0, 200, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 50
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 0)
SidebarCorner.Parent = Sidebar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -200, 1, -45)
ContentFrame.Position = UDim2.new(0, 200, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 1
ContentFrame.Parent = MainFrame

local TabButtons = {}
local TabContents = {}

local function CreateTabButton(name, icon, order)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Tab"
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, 10 + (order * 45))
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.Text = "  " .. icon .. "  " .. name
    Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.ZIndex = 51
    Button.Parent = Sidebar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
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
    Frame.CanvasSize = UDim2.new(0, 0, 0, 1000)
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
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

local PlayerInfoFrame = Instance.new("Frame")
PlayerInfoFrame.Name = "PlayerInfo"
PlayerInfoFrame.Size = UDim2.new(1, -20, 0, 90)
PlayerInfoFrame.Position = UDim2.new(0, 10, 0, 10)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerInfoFrame.ZIndex = 52
PlayerInfoFrame.Parent = Sidebar

local PlayerInfoCorner = Instance.new("UICorner")
PlayerInfoCorner.CornerRadius = UDim.new(0, 6)
PlayerInfoCorner.Parent = PlayerInfoFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Size = UDim2.new(0, 55, 0, 55)
AvatarImage.Position = UDim2.new(0, 10, 0, 17)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.ZIndex = 53
AvatarImage.Parent = PlayerInfoFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(0, 27)
AvatarCorner.Parent = AvatarImage

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Name = "PlayerName"
PlayerNameLabel.Size = UDim2.new(0, 110, 0, 20)
PlayerNameLabel.Position = UDim2.new(0, 75, 0, 17)
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
PlayTimeLabel.Position = UDim2.new(0, 75, 0, 38)
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
CharacterNameLabel.Position = UDim2.new(0, 75, 0, 58)
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

local MovementTab = CreateTabContent("Movement")
local ESPTab = CreateTabContent("ESP")
local CombatTab = CreateTabContent("Combat")
local VisualsTab = CreateTabContent("Visuals")
local MiscTab = CreateTabContent("Misc")
local TrollingTab = CreateTabContent("Trolling")

TabButtons["Movement"] = CreateTabButton("Movement", "✈", 0)
TabButtons["ESP"] = CreateTabButton("ESP", "👁", 1)
TabButtons["Combat"] = CreateTabButton("Combat", "⚔", 2)
TabButtons["Visuals"] = CreateTabButton("Visuals", "👤", 3)
TabButtons["Misc"] = CreateTabButton("Misc", "⚙", 4)
TabButtons["Trolling"] = CreateTabButton("Trolling", "🎭", 5)

TabContents["Movement"] = MovementTab
TabContents["ESP"] = ESPTab
TabContents["Combat"] = CombatTab
TabContents["Visuals"] = VisualsTab
TabContents["Misc"] = MiscTab
TabContents["Trolling"] = TrollingTab

for name, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)
end

local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
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
    Label.Size = UDim2.new(0, 250, 1, 0)
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
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
            TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
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
    Label.Size = UDim2.new(0, 250, 0, 20)
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
    SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
        OptionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = MenuColor
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    return Button
end

local MovementSection, MovementContent = CreateSection(MovementTab, "Movement")

CreateToggle(MovementContent, "WalkSpeed", function(state)
    WalkSpeedEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        humanoid.WalkSpeed = WalkSpeedValue
    else
        humanoid.WalkSpeed = 16
    end
end)

CreateSlider(MovementContent, "WalkSpeed Value", 16, 200, 50, function(value)
    WalkSpeedValue = value
    if WalkSpeedEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end)

CreateToggle(MovementContent, "Fly", function(state)
    FlyEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
        if FlyConnection then FlyConnection:Disconnect() end
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
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
                hrp.Velocity = direction.Unit * FlySpeedValue
            else
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end)
    else
        humanoid.PlatformStand = false
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
    end
end)

CreateSlider(MovementContent, "Fly Speed", 10, 200, 50, function(value)
    FlySpeedValue = value
end)

CreateToggle(MovementContent, "NoClip", function(state)
    NoClipEnabled = state
    if state then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.Stepped:Connect(function()
            if not NoClipEnabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

local TeleportSection, TeleportContent = CreateSection(MovementTab, "Teleport")

local TeleportDropdown = CreateDropdown(TeleportContent, "Select Target", {"Loading..."}, function(selected)
    TeleportTarget = selected
end)

local function UpdateTeleportList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    
    local dropdownBtn = TeleportDropdown:FindFirstChild("Dropdown")
    if dropdownBtn then
        dropdownBtn.Text = list[1] or "No Players"
        local optionsFrame = dropdownBtn:FindFirstChild("OptionsFrame")
        if optionsFrame then
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for i, name in ipairs(list) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 101
                btn.Parent = optionsFrame
                
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = name
                    optionsFrame.Visible = false
                    TeleportTarget = name
                end)
            end
            optionsFrame.Size = UDim2.new(0, 150, 0, math.max(#list * 25, 25))
        end
    end
end

UpdateTeleportList()
Players.PlayerAdded:Connect(UpdateTeleportList)
Players.PlayerRemoving:Connect(UpdateTeleportList)

CreateButton(TeleportContent, "Teleport", function()
    if not TeleportTarget then return end
    local targetPlayer = Players:FindFirstChild(TeleportTarget)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
end)

local ESPSection, ESPContent = CreateSection(ESPTab, "ESP")

CreateToggle(ESPContent, "Enable ESP", function(state)
    ESPStates.Enabled = state
end)

CreateToggle(ESPContent, "Chams ESP", function(state)
    ESPStates.Chams = state
end)

CreateToggle(ESPContent, "Box ESP", function(state)
    ESPStates.Box = state
end)

CreateToggle(ESPContent, "Name ESP", function(state)
    ESPStates.Name = state
end)

CreateToggle(ESPContent, "Skeleton ESP", function(state)
    ESPStates.Skeleton = state
end)

CreateToggle(ESPContent, "Tracer ESP", function(state)
    ESPStates.Tracer = state
end)

CreateColorPicker(ESPContent, "ESP Color", ESPColor, function(color)
    ESPColor = color
end)

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = ScreenGui

local function WorldToScreen(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
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
            
            local headPos, headVisible = WorldToScreen(head.Position)
            local hrpPos, hrpVisible = WorldToScreen(hrp.Position)
            
            if not headVisible and not hrpVisible then continue end
            
            local topPos = head.Position + Vector3.new(0, 0.5, 0)
            local bottomPos = hrp.Position - Vector3.new(0, 3, 0)
            local topScreen, topVis = WorldToScreen(topPos)
            local bottomScreen, bottomVis = WorldToScreen(bottomPos)
            
            if not topVis and not bottomVis then continue end
            
            local height = math.abs(bottomScreen.Y - topScreen.Y)
            local width = height * 0.5
            
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
            
            if ESPStates.Box then
                local boxFrame = Instance.new("Frame")
                boxFrame.Name = player.Name .. "_Box"
                boxFrame.Size = UDim2.new(0, width, 0, height)
                boxFrame.Position = UDim2.new(0, (topScreen.X + bottomScreen.X) / 2 - width / 2, 0, topScreen.Y)
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
            
            if ESPStates.Name and headVisible then
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = player.Name .. "_Name"
                nameLabel.Size = UDim2.new(0, 100, 0, 20)
                nameLabel.Position = UDim2.new(0, headPos.X - 50, 0, headPos.Y - 25)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = ESPColor
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextStrokeTransparency = 0
                nameLabel.ZIndex = 5
                nameLabel.Parent = ESPFolder
            end
            
            if ESPStates.Skeleton then
                local joints = {
                    {"Head", "UpperTorso"},
                    {"UpperTorso", "LowerTorso"},
                    {"UpperTorso", "LeftUpperArm"},
                    {"LeftUpperArm", "LeftLowerArm"},
                    {"LeftLowerArm", "LeftHand"},
                    {"UpperTorso", "RightUpperArm"},
                    {"RightUpperArm", "RightLowerArm"},
                    {"RightLowerArm", "RightHand"},
                    {"LowerTorso", "LeftUpperLeg"},
                    {"LeftUpperLeg", "LeftLowerLeg"},
                    {"LeftLowerLeg", "LeftFoot"},
                    {"LowerTorso", "RightUpperLeg"},
                    {"RightUpperLeg", "RightLowerLeg"},
                    {"RightLowerLeg", "RightFoot"}
                }
                
                for _, joint in ipairs(joints) do
                    local part1 = character:FindFirstChild(joint[1])
                    local part2 = character:FindFirstChild(joint[2])
                    if part1 and part2 then
                        local pos1, vis1 = WorldToScreen(part1.Position)
                        local pos2, vis2 = WorldToScreen(part2.Position)
                        if vis1 and vis2 then
                            local distance = (pos1 - pos2).Magnitude
                            local angle = math.atan2(pos2.Y - pos1.Y, pos2.X - pos1.X)
                            
                            local bone = Instance.new("Frame")
                            bone.Name = player.Name .. "_Bone"
                            bone.AnchorPoint = Vector2.new(0.5, 0.5)
                            bone.Size = UDim2.new(0, distance, 0, 1)
                            bone.Position = UDim2.new(0, (pos1.X + pos2.X) / 2, 0, (pos1.Y + pos2.Y) / 2)
                            bone.BackgroundColor3 = ESPColor
                            bone.BorderSizePixel = 0
                            bone.Rotation = math.deg(angle)
                            bone.ZIndex = 5
                            bone.Parent = ESPFolder
                        end
                    end
                end
            end
            
            if ESPStates.Tracer and hrpVisible then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                local distance = (hrpPos - screenCenter).Magnitude
                local angle = math.atan2(hrpPos.Y - screenCenter.Y, hrpPos.X - screenCenter.X)
                
                local tracer = Instance.new("Frame")
                tracer.Name = player.Name .. "_Tracer"
                tracer.AnchorPoint = Vector2.new(0.5, 0.5)
                tracer.Size = UDim2.new(0, distance, 0, 1)
                tracer.Position = UDim2.new(0, (screenCenter.X + hrpPos.X) / 2, 0, (screenCenter.Y + hrpPos.Y) / 2)
                tracer.BackgroundColor3 = ESPColor
                tracer.BorderSizePixel = 0
                tracer.Rotation = math.deg(angle)
                tracer.ZIndex = 5
                tracer.Parent = ESPFolder
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)

local CombatSection, CombatContent = CreateSection(CombatTab, "Combat")

CreateToggle(CombatContent, "Silent Aim", function(state)
    SilentAimEnabled = state
end)

CreateToggle(CombatContent, "Kill All", function(state)
    KillAllEnabled = state
    if state then
        spawn(function()
            while KillAllEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

local KillTargetSection, KillTargetContent = CreateSection(CombatTab, "Kill Target")

local KillDropdown = CreateDropdown(KillTargetContent, "Select Target", {"Loading..."}, function(selected)
    KillTarget = selected
end)

local function UpdateKillList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    
    local dropdownBtn = KillDropdown:FindFirstChild("Dropdown")
    if dropdownBtn then
        dropdownBtn.Text = list[1] or "No Players"
        local optionsFrame = dropdownBtn:FindFirstChild("OptionsFrame")
        if optionsFrame then
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for i, name in ipairs(list) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 101
                btn.Parent = optionsFrame
                
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = name
                    optionsFrame.Visible = false
                    KillTarget = name
                end)
            end
            optionsFrame.Size = UDim2.new(0, 150, 0, math.max(#list * 25, 25))
        end
    end
end

UpdateKillList()
Players.PlayerAdded:Connect(UpdateKillList)
Players.PlayerRemoving:Connect(UpdateKillList)

CreateButton(KillTargetContent, "Kill", function()
    if not KillTarget then return end
    local targetPlayer = Players:FindFirstChild(KillTarget)
    if not targetPlayer or not targetPlayer.Character then return end
    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end)

local VisualsSection, VisualsContent = CreateSection(VisualsTab, "Visuals")

CreateToggle(VisualsContent, "FOV Changer", function(state)
    FOVEnabled = state
    if state then
        Camera.FieldOfView = CustomFOV
    else
        Camera.FieldOfView = 70
    end
end)

CreateSlider(VisualsContent, "FOV Value", 30, 120, 70, function(value)
    CustomFOV = value
    if FOVEnabled then
        Camera.FieldOfView = value
    end
end)

CreateToggle(VisualsContent, "Rainbow Character", function(state)
    RainbowCharEnabled = state
    if state then
        if RainbowConnection then RainbowConnection:Disconnect() end
        RainbowConnection = RunService.RenderStepped:Connect(function()
            if not RainbowCharEnabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = color
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

CreateToggle(VisualsContent, "Glass Character", function(state)
    GlassCharEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if state then
                part.Transparency = 0.5
                part.Material = Enum.Material.Glass
            else
                part.Transparency = 0
                part.Material = Enum.Material.Plastic
            end
        end
    end
end)

CreateToggle(VisualsContent, "Show FPS", function(state)
    ShowFPSEnabled = state
    if state then
        if not FPSLabel then
            FPSLabel = Instance.new("TextLabel")
            FPSLabel.Size = UDim2.new(0, 100, 0, 30)
            FPSLabel.Position = UDim2.new(0, 10, 0, 10)
            FPSLabel.BackgroundTransparency = 0.5
            FPSLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            FPSLabel.TextSize = 16
            FPSLabel.Font = Enum.Font.GothamBold
            FPSLabel.Parent = ScreenGui
        end
        FPSLabel.Visible = true
        
        local lastUpdate = tick()
        local frameCount = 0
        
        RunService.RenderStepped:Connect(function()
            if not ShowFPSEnabled then return end
            frameCount = frameCount + 1
            local now = tick()
            if now - lastUpdate >= 1 then
                FPSLabel.Text = "FPS: " .. frameCount
                frameCount = 0
                lastUpdate = now
            end
        end)
    else
        if FPSLabel then
            FPSLabel.Visible = false
        end
    end
end)

local MiscSection, MiscContent = CreateSection(MiscTab, "Misc")

CreateToggle(MiscContent, "Anti AFK", function(state)
    AntiAFKEnabled = state
    if state then
        if AntiAFKConnection then AntiAFKConnection:Disconnect() end
        AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            if not AntiAFKEnabled then return end
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end
    end
end)

CreateButton(MiscContent, "TP Car", function()
    for _, vehicle in pairs(workspace:GetDescendants()) do
        if vehicle:IsA("VehicleSeat") or vehicle:IsA("Seat") then
            if vehicle.Name:lower():find("seat") or vehicle.Name:lower():find("driver") or vehicle.Name:lower():find("car") then
                local character = LocalPlayer.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = vehicle.CFrame + Vector3.new(0, 3, 0)
                        wait(0.5)
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Sit = true
                            vehicle:Sit(humanoid)
                        end
                        break
                    end
                end
            end
        end
    end
end)

CreateToggle(MiscContent, "Fly Car", function(state)
    FlyCarEnabled = state
    if state then
        RunService.RenderStepped:Connect(function()
            if not FlyCarEnabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or not humanoid.SeatPart then return end
            
            local seat = humanoid.SeatPart
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                seat.Velocity = direction.Unit * 100
            end
        end)
    end
end)

CreateToggle(MiscContent, "Car Noclip", function(state)
    CarNoclipEnabled = state
    if state then
        RunService.Stepped:Connect(function()
            if not CarNoclipEnabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid or not humanoid.SeatPart then return end
            
            for _, part in pairs(humanoid.SeatPart.Parent:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

CreateSlider(MiscContent, "Car Speed", 50, 500, 100, function(value)
    CarSpeedValue = value
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.SeatPart then return end
    
    local vehicle = humanoid.SeatPart.Parent
    for _, part in pairs(vehicle:GetDescendants()) do
        if part:IsA("VehicleSeat") then
            part.MaxSpeed = value
        end
    end
end)

local TrollingSection, TrollingContent = CreateSection(TrollingTab, "Trolling")

CreateToggle(TrollingContent, "Fake Admin", function(state)
    FakeAdminEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local adminTag = head:FindFirstChild("AdminTag")
    if adminTag then adminTag:Destroy() end
    
    if state then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "AdminTag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "[ADMIN]"
        label.TextColor3 = AdminColor
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.Parent = billboard
        
        billboard.Parent = head
    end
end)

CreateColorPicker(TrollingContent, "Admin Color", AdminColor, function(color)
    AdminColor = color
    if FakeAdminEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local head = character:FindFirstChild("Head")
        if not head then return end
        local adminTag = head:FindFirstChild("AdminTag")
        if adminTag then
            local label = adminTag:FindFirstChildOfClass("TextLabel")
            if label then
                label.TextColor3 = color
            end
        end
    end
end)

CreateToggle(TrollingContent, "Fake Owner", function(state)
    FakeOwnerEnabled = state
    local character = LocalPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local ownerTag = head:FindFirstChild("OwnerTag")
    if ownerTag then ownerTag:Destroy() end
    
    if state then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "OwnerTag"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "[OWNER]"
        label.TextColor3 = OwnerColor
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.Parent = billboard
        
        billboard.Parent = head
    end
end)

CreateColorPicker(TrollingContent, "Owner Color", OwnerColor, function(color)
    OwnerColor = color
    if FakeOwnerEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        local head = character:FindFirstChild("Head")
        if not head then return end
        local ownerTag = head:FindFirstChild("OwnerTag")
        if ownerTag then
            local label = ownerTag:FindFirstChildOfClass("TextLabel")
            if label then
                label.TextColor3 = color
            end
        end
    end
end)

CreateToggle(TrollingContent, "Chat Admin", function(state)
    ChatAdminEnabled = state
end)

CreateToggle(TrollingContent, "Chat Owner", function(state)
    ChatOwnerEnabled = state
end)

local MouthSection, MouthContent = CreateSection(TrollingTab, "Ağzına Ver")

local MouthDropdown = CreateDropdown(MouthContent, "Select Target", {"Loading..."}, function(selected)
    MouthTarget = selected
end)

local function UpdateMouthList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    
    local dropdownBtn = MouthDropdown:FindFirstChild("Dropdown")
    if dropdownBtn then
        dropdownBtn.Text = list[1] or "No Players"
        local optionsFrame = dropdownBtn:FindFirstChild("OptionsFrame")
        if optionsFrame then
            for _, child in pairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for i, name in ipairs(list) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 25)
                btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.Text = name
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.TextSize = 12
                btn.Font = Enum.Font.Gotham
                btn.ZIndex = 101
                btn.Parent = optionsFrame
                
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = name
                    optionsFrame.Visible = false
                    MouthTarget = name
                end)
            end
            optionsFrame.Size = UDim2.new(0, 150, 0, math.max(#list * 25, 25))
        end
    end
end

UpdateMouthList()
Players.PlayerAdded:Connect(UpdateMouthList)
Players.PlayerRemoving:Connect(UpdateMouthList)

CreateButton(MouthContent, "Ağzına Ver", function()
    if not MouthTarget then return end
    local targetPlayer = Players:FindFirstChild(MouthTarget)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    if not targetHead then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if MouthConnection then MouthConnection:Disconnect() end
    MouthConnection = RunService.RenderStepped:Connect(function()
        if not MouthTarget then
            MouthConnection:Disconnect()
            MouthConnection = nil
            return
        end
        
        local target = Players:FindFirstChild(MouthTarget)
        if not target or not target.Character then
            MouthConnection:Disconnect()
            MouthConnection = nil
            return
        end
        
        local head = target.Character:FindFirstChild("Head")
        if not head then
            MouthConnection:Disconnect()
            MouthConnection = nil
            return
        end
        
        local offset = CFrame.new(0, -0.8, 0.5) * CFrame.Angles(math.rad(90), 0, 0)
        hrp.CFrame = head.CFrame * offset
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        local offset2 = CFrame.new(0, math.sin(tick() * 5) * 0.1, 0)
        hrp.CFrame = head.CFrame * offset * offset2
    end)
end)

CreateButton(MouthContent, "Stop", function()
    MouthTarget = nil
    if MouthConnection then
        MouthConnection:Disconnect()
        MouthConnection = nil
    end
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)

if TextChatService.ChatInputBarConfiguration then
    TextChatService.SendingMessage:Connect(function(message)
        if ChatAdminEnabled then
            message.Text = "[ADMIN] " .. LocalPlayer.Name .. ": " .. message.Text
        elseif ChatOwnerEnabled then
            message.Text = "[OWNER] " .. LocalPlayer.Name .. ": " .. message.Text
        end
    end)
end

SwitchTab("Movement")

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
    
    if WalkSpeedEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end
    
    if FlyEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end
end)
