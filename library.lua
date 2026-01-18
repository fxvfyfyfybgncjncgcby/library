--[[
    GitanX UI Library
    Combinaison de Luna et Starlight Interface Suite
    Créé pour GitanX Hub
]]

local GitanX = {}
GitanX.__index = GitanX

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utilitaires
local function Tween(Object, Properties, Duration, Style, Direction)
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(Duration, Style, Direction)
    local tween = TweenService:Create(Object, tweenInfo, Properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local dragging = false
    local dragInput, mousePos, framePos

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.15)
        end
    end)
end

-- Thèmes
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Tertiary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 65)
    },
    Light = {
        Primary = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 240),
        Tertiary = Color3.fromRGB(225, 225, 230),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(20, 20, 25),
        SubText = Color3.fromRGB(100, 100, 105),
        Border = Color3.fromRGB(200, 200, 205)
    },
    Ocean = {
        Primary = Color3.fromRGB(15, 25, 40),
        Secondary = Color3.fromRGB(25, 35, 50),
        Tertiary = Color3.fromRGB(35, 45, 60),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 200, 220),
        Border = Color3.fromRGB(45, 55, 70)
    },
    Sunset = {
        Primary = Color3.fromRGB(40, 20, 30),
        Secondary = Color3.fromRGB(50, 30, 40),
        Tertiary = Color3.fromRGB(60, 40, 50),
        Accent = Color3.fromRGB(255, 100, 150),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(220, 180, 200),
        Border = Color3.fromRGB(70, 50, 60)
    }
}

-- Fonction principale de création de fenêtre
function GitanX:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "GitanX"
    local Theme = Themes[config.Theme] or Themes.Dark
    local Size = config.Size or UDim2.new(0, 550, 0, 650)
    
    local GitanXUI = {
        Theme = Theme,
        Tabs = {},
        CurrentTab = nil
    }
    
    -- ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GitanXUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Frame principale
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Ombre
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://297694300"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(95, 95, 905, 905)
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Barre de titre
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 12)
    TitleFix.Position = UDim2.new(0, 0, 1, -12)
    TitleFix.BackgroundColor3 = Theme.Secondary
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    
    -- Titre
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Position = UDim2.new(0, 10, 0.5, -15)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://11963373994"
    Logo.ImageColor3 = Theme.Accent
    Logo.Parent = TitleBar
    
    -- Boutons de contrôle
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Name = "Controls"
    ControlsFrame.Size = UDim2.new(0, 80, 1, 0)
    ControlsFrame.Position = UDim2.new(1, -90, 0, 0)
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(0, 0, 0.5, -17.5)
    MinimizeButton.BackgroundColor3 = Theme.Tertiary
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 18
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = ControlsFrame
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(0, 45, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = ControlsFrame
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Container pour les tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 180, 1, -55)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 10)
    TabContainerCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Container pour le contenu
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -210, 1, -55)
    ContentContainer.Position = UDim2.new(0, 200, 0, 50)
    ContentContainer.BackgroundColor3 = Theme.Secondary
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentContainer
    
    -- Draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Minimize/Close
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, Size.X.Offset, 0, 45)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = Size}, 0.3)
            MinimizeButton.Text = "−"
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Effets de survol
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, 0.2)
    end)
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.2)
    end)
    
    -- Fonction pour créer un onglet
    function GitanXUI:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local Icon = config.Icon
        
        local Tab = {
            Name = TabName,
            Elements = {}
        }
        
        -- Bouton de l'onglet
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Theme.Tertiary
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = Icon or "rbxassetid://11963373994"
        TabIcon.ImageColor3 = Theme.SubText
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = TabName
        TabLabel.TextColor3 = Theme.SubText
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Page de contenu
        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "Page"
        Page.Size = UDim2.new(1, -20, 1, -20)
        Page.Position = UDim2.new(0, 10, 0, 10)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.Parent = ContentContainer
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Sélection de l'onglet
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(GitanXUI.Tabs) do
                tab.Button.BackgroundColor3 = Theme.Tertiary
                tab.Icon.ImageColor3 = Theme.SubText
                tab.Label.TextColor3 = Theme.SubText
                tab.Page.Visible = false
            end
            
            TabButton.BackgroundColor3 = Theme.Accent
            TabIcon.ImageColor3 = Theme.Text
            TabLabel.TextColor3 = Theme.Text
            Page.Visible = true
            GitanXUI.CurrentTab = Tab
        end)
        
        -- Effet de survol
        TabButton.MouseEnter:Connect(function()
            if GitanXUI.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.Border}, 0.2)
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if GitanXUI.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end
        end)
        
        -- Premier onglet actif par défaut
        if #GitanXUI.Tabs == 0 then
            TabButton.BackgroundColor3 = Theme.Accent
            TabIcon.ImageColor3 = Theme.Text
            TabLabel.TextColor3 = Theme.Text
            Page.Visible = true
            GitanXUI.CurrentTab = Tab
        end
        
        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        Tab.Page = Page
        
        table.insert(GitanXUI.Tabs, Tab)
        
        -- Fonction pour créer une section
        function Tab:CreateSection(name)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Size = UDim2.new(1, 0, 0, 35)
            Section.BackgroundTransparency = 1
            Section.Parent = Page
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = Theme.Accent
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 14
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Section
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.Position = UDim2.new(0, 0, 1, -1)
            Divider.BackgroundColor3 = Theme.Border
            Divider.BorderSizePixel = 0
            Divider.Parent = Section
            
            return Section
        end
        
        -- Fonction pour créer un bouton
        function Tab:CreateButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Theme.Tertiary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = Page
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = ButtonName
            Button.TextColor3 = Theme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 13
            Button.Parent = ButtonFrame
            
            Button.MouseButton1Click:Connect(Callback)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end)
            
            return Button
        end
        
        -- Fonction pour créer un toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local Toggled = Default
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.Tertiary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = ToggleName
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
            ToggleButton.BackgroundColor3 = Toggled and Theme.Accent or Theme.Border
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            ToggleIndicator.BackgroundColor3 = Theme.Text
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Tween(ToggleButton, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.2)
                Tween(ToggleIndicator, {Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)
                Callback(Toggled)
            end)
            
            return {
                SetValue = function(value)
                    Toggled = value
                    Tween(ToggleButton, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.2)
                    Tween(ToggleIndicator, {Position = Toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.2)
                    Callback(Toggled)
                end,
                GetValue = function()
                    return Toggled
                end
            }
        end
        
        -- Fonction pour créer un slider
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Increment = config.Increment or 1
            local Callback = config.Callback or function() end
            
            local Value = Default
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.Tertiary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = Page
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -15, 0, 20)
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SliderName
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextSize = 13
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -65, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(Value)
            SliderValue.TextColor3 = Theme.Accent
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextSize = 13
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 4)
            SliderBar.Position = UDim2.new(0, 15, 1, -12)
            SliderBar.BackgroundColor3 = Theme.Border
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local Dragging = false
            
            local function UpdateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor(Min + (Max - Min) * sizeX)
                Value = math.floor(Value / Increment) * Increment
                Value = math.clamp(Value, Min, Max)
                
                Tween(SliderFill, {Size = UDim2.new(sizeX, 0, 1, 0)}, 0.1)
                SliderValue.Text = tostring(Value)
                Callback(Value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            return {
                SetValue = function(value)
                    Value = math.clamp(value, Min, Max)
                    local sizeX = (Value - Min) / (Max - Min)
                    Tween(SliderFill, {Size = UDim2.new(sizeX, 0, 1, 0)}, 0.2)
                    SliderValue.Text = tostring(Value)
                    Callback(Value)
                end,
                GetValue = function()
                    return Value
                end
            }
        end
        
        -- Fonction pour créer un dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local Selected = Default
            local Opened = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Theme.Tertiary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = Page
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -60, 0, 40)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = DropdownName
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.TextSize = 13
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 30, 0, 30)
            DropdownButton.Position = UDim2.new(1, -40, 0, 5)
            DropdownButton.BackgroundColor3 = Theme.Border
            DropdownButton.Text = "▼"
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.Font = Enum.Font.GothamBold
            DropdownButton.TextSize = 10
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Parent = DropdownFrame
            
            local DropdownButtonCorner = Instance.new("UICorner")
            DropdownButtonCorner.CornerRadius = UDim.new(0, 6)
            DropdownButtonCorner.Parent = DropdownButton
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Size = UDim2.new(1, -10, 0, #Options * 35)
            OptionsFrame.Position = UDim2.new(0, 5, 0, 45)
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Parent = DropdownFrame
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.Padding = UDim.new(0, 5)
            OptionsList.Parent = OptionsFrame
            
            for _, option in ipairs(Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = option == Selected and Theme.Accent or Theme.Border
                OptionButton.Text = option
                OptionButton.TextColor3 = Theme.Text
                OptionButton.Font = Enum.Font.GothamSemibold
                OptionButton.TextSize = 12
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = OptionsFrame
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    Selected = option
                    for _, btn in ipairs(OptionsFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            Tween(btn, {BackgroundColor3 = btn.Text == Selected and Theme.Accent or Theme.Border}, 0.2)
                        end
                    end
                    Callback(Selected)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    if option ~= Selected then
                        Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    end
                end)
                OptionButton.MouseLeave:Connect(function()
                    if option ~= Selected then
                        Tween(OptionButton, {BackgroundColor3 = Theme.Border}, 0.2)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                Opened = not Opened
                local newSize = Opened and UDim2.new(1, 0, 0, 40 + 10 + (#Options * 35)) or UDim2.new(1, 0, 0, 40)
                Tween(DropdownFrame, {Size = newSize}, 0.3)
                DropdownButton.Text = Opened and "▲" or "▼"
            end)
            
            return {
                SetValue = function(value)
                    if table.find(Options, value) then
                        Selected = value
                        for _, btn in ipairs(OptionsFrame:GetChildren()) do
                            if btn:IsA("TextButton") then
                                Tween(btn, {BackgroundColor3 = btn.Text == Selected and Theme.Accent or Theme.Border}, 0.2)
                            end
                        end
                        Callback(Selected)
                    end
                end,
                GetValue = function()
                    return Selected
                end
            }
        end
        
        -- Fonction pour créer un textbox
        function Tab:CreateTextBox(config)
            config = config or {}
            local TextBoxName = config.Name or "TextBox"
            local Placeholder = config.Placeholder or "Enter text..."
            local Default = config.Default or ""
            local Callback = config.Callback or function() end
            
            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Name = "TextBox"
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 40)
            TextBoxFrame.BackgroundColor3 = Theme.Tertiary
            TextBoxFrame.BorderSizePixel = 0
            TextBoxFrame.Parent = Page
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 8)
            TextBoxCorner.Parent = TextBoxFrame
            
            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Size = UDim2.new(0, 100, 1, 0)
            TextBoxLabel.Position = UDim2.new(0, 15, 0, 0)
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Text = TextBoxName
            TextBoxLabel.TextColor3 = Theme.Text
            TextBoxLabel.Font = Enum.Font.GothamSemibold
            TextBoxLabel.TextSize = 13
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxLabel.Parent = TextBoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -125, 0, 30)
            TextBox.Position = UDim2.new(0, 115, 0.5, -15)
            TextBox.BackgroundColor3 = Theme.Border
            TextBox.Text = Default
            TextBox.PlaceholderText = Placeholder
            TextBox.TextColor3 = Theme.Text
            TextBox.PlaceholderColor3 = Theme.SubText
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            TextBox.BorderSizePixel = 0
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = TextBoxFrame
            
            local TextBoxBoxCorner = Instance.new("UICorner")
            TextBoxBoxCorner.CornerRadius = UDim.new(0, 6)
            TextBoxBoxCorner.Parent = TextBox
            
            TextBox.FocusLost:Connect(function()
                Callback(TextBox.Text)
            end)
            
            return {
                SetValue = function(value)
                    TextBox.Text = value
                    Callback(value)
                end,
                GetValue = function()
                    return TextBox.Text
                end
            }
        end
        
        -- Fonction pour créer un keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            local KeybindName = config.Name or "Keybind"
            local Default = config.Default or "NONE"
            local Callback = config.Callback or function() end
            
            local Keybind = Default
            local Listening = false
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind"
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Theme.Tertiary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = Page
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = KeybindName
            KeybindLabel.TextColor3 = Theme.Text
            KeybindLabel.Font = Enum.Font.GothamSemibold
            KeybindLabel.TextSize = 13
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 80, 0, 30)
            KeybindButton.Position = UDim2.new(1, -90, 0.5, -15)
            KeybindButton.BackgroundColor3 = Theme.Border
            KeybindButton.Text = Keybind
            KeybindButton.TextColor3 = Theme.Text
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.TextSize = 11
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
            KeybindButtonCorner.Parent = KeybindButton
            
            KeybindButton.MouseButton1Click:Connect(function()
                Listening = true
                KeybindButton.Text = "..."
                Tween(KeybindButton, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if Listening and not gameProcessed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        Keybind = input.KeyCode.Name
                        KeybindButton.Text = Keybind
                        Tween(KeybindButton, {BackgroundColor3 = Theme.Border}, 0.2)
                        Listening = false
                    end
                elseif Keybind ~= "NONE" and input.KeyCode == Enum.KeyCode[Keybind] and not gameProcessed then
                    Callback()
                end
            end)
            
            return {
                SetValue = function(value)
                    Keybind = value
                    KeybindButton.Text = value
                end,
                GetValue = function()
                    return Keybind
                end
            }
        end
        
        -- Fonction pour créer un label
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.SubText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Page
            
            return {
                SetText = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        -- Fonction pour créer un paragraphe
        function Tab:CreateParagraph(config)
            config = config or {}
            local Title = config.Title or "Paragraph"
            local Content = config.Content or "Content here"
            
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "Paragraph"
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 80)
            ParagraphFrame.BackgroundColor3 = Theme.Tertiary
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = Page
            
            local ParagraphCorner = Instance.new("UICorner")
            ParagraphCorner.CornerRadius = UDim.new(0, 8)
            ParagraphCorner.Parent = ParagraphFrame
            
            local ParagraphTitle = Instance.new("TextLabel")
            ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.Text = Title
            ParagraphTitle.TextColor3 = Theme.Accent
            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.TextSize = 13
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphTitle.Parent = ParagraphFrame
            
            local ParagraphContent = Instance.new("TextLabel")
            ParagraphContent.Size = UDim2.new(1, -20, 1, -35)
            ParagraphContent.Position = UDim2.new(0, 10, 0, 30)
            ParagraphContent.BackgroundTransparency = 1
            ParagraphContent.Text = Content
            ParagraphContent.TextColor3 = Theme.SubText
            ParagraphContent.Font = Enum.Font.Gotham
            ParagraphContent.TextSize = 12
            ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
            ParagraphContent.TextWrapped = true
            ParagraphContent.Parent = ParagraphFrame
            
            return {
                SetTitle = function(newTitle)
                    ParagraphTitle.Text = newTitle
                end,
                SetContent = function(newContent)
                    ParagraphContent.Text = newContent
                end
            }
        end
        
        return Tab
    end
    
    -- Notification système
    function GitanXUI:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or ""
        local Duration = config.Duration or 3
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 300, 0, 0)
        NotifFrame.Position = UDim2.new(1, -320, 1, -20)
        NotifFrame.BackgroundColor3 = Theme.Secondary
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = Title
        NotifTitle.TextColor3 = Theme.Accent
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifFrame
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 0, 40)
        NotifContent.Position = UDim2.new(0, 10, 0, 30)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = Content
        NotifContent.TextColor3 = Theme.Text
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextSize = 12
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        NotifContent.Parent = NotifFrame
        
        Tween(NotifFrame, {Size = UDim2.new(0, 300, 0, 80)}, 0.3)
        
        task.delay(Duration, function()
            Tween(NotifFrame, {Position = UDim2.new(1, 20, 1, -20)}, 0.3)
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end
    
    return GitanXUI
end

return GitanX
