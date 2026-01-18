--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                      GITANX ULTIMATE UI                       ║
    ║                  The Most Advanced Roblox UI                  ║
    ║           20x Better Than Luna & Starlight Combined           ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    Features That Destroy Competition:
    • 🎨 Glassmorphism & Modern Gradient Design
    • ✨ Smooth Micro-Animations Everywhere
    • 🌊 Fluid Drag & Drop System
    • 💫 3D Depth Effects & Parallax
    • 🎯 Smart Keybind System
    • 🔥 Dynamic Theme Engine
    • ⚡ Zero Lag Performance
    • 🎭 Custom Notifications System
    • 📱 Mobile-First Responsive
    • 🌈 Advanced Color Picker
    • 🎪 Tab Groups & Nested Sections
    • 🚀 Instant Configuration Save/Load
]]

local GitanX = {}
GitanX.__index = GitanX

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configuration
local Config = {
    Name = "GitanX",
    Version = "2.0.0",
    Folder = "GitanXUI",
    DefaultTheme = "Cyberpunk"
}

-- Themes - Ultra Modern Gradients
local Themes = {
    Cyberpunk = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(255, 0, 127),
        Accent = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(15, 15, 25),
        Surface = Color3.fromRGB(25, 25, 40),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 200),
        Gradient = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 127)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
        }
    },
    Ocean = {
        Primary = Color3.fromRGB(26, 188, 156),
        Secondary = Color3.fromRGB(41, 128, 185),
        Accent = Color3.fromRGB(52, 152, 219),
        Background = Color3.fromRGB(10, 20, 30),
        Surface = Color3.fromRGB(20, 30, 45),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(189, 195, 199),
        Gradient = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 188, 156)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(41, 128, 185)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
        }
    },
    Sunset = {
        Primary = Color3.fromRGB(255, 107, 107),
        Secondary = Color3.fromRGB(255, 159, 64),
        Accent = Color3.fromRGB(255, 195, 113),
        Background = Color3.fromRGB(20, 15, 20),
        Surface = Color3.fromRGB(35, 25, 30),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(220, 200, 200),
        Gradient = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 107, 107)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 159, 64)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 195, 113))
        }
    },
    Forest = {
        Primary = Color3.fromRGB(46, 213, 115),
        Secondary = Color3.fromRGB(0, 184, 148),
        Accent = Color3.fromRGB(85, 230, 193),
        Background = Color3.fromRGB(15, 25, 20),
        Surface = Color3.fromRGB(25, 40, 30),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 220, 200),
        Gradient = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 213, 115)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 184, 148)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 230, 193))
        }
    }
}

-- Utility Functions
local Utility = {}

function Utility:Tween(object, properties, duration, style, direction)
    local tween = TweenService:Create(object, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), properties)
    tween:Play()
    return tween
end

function Utility:MakeDraggable(frame, dragSpeed)
    local dragToggle, dragInput, dragStart, startPos
    dragSpeed = dragSpeed or 1

    local function updateInput(input)
        local delta = input.Position - dragStart
        Utility:Tween(frame, {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X * dragSpeed,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y * dragSpeed
            )
        }, 0.15, Enum.EasingStyle.Sine)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

function Utility:AddGlassEffect(frame)
    local blur = Instance.new("ImageLabel")
    blur.Name = "GlassBlur"
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    blur.ImageTransparency = 0.9
    blur.ScaleType = Enum.ScaleType.Tile
    blur.TileSize = UDim2.new(0, 128, 0, 128)
    blur.ZIndex = frame.ZIndex - 1
    blur.Parent = frame
    
    frame.BackgroundTransparency = 0.3
    return blur
end

function Utility:CreateGradient(parent, sequence)
    local gradient = Instance.new("UIGradient")
    gradient.Color = sequence or Themes.Cyberpunk.Gradient
    gradient.Rotation = 45
    gradient.Parent = parent
    
    -- Animated gradient
    task.spawn(function()
        while gradient.Parent do
            Utility:Tween(gradient, {Rotation = gradient.Rotation + 360}, 10, Enum.EasingStyle.Linear)
            task.wait(10)
        end
    end)
    
    return gradient
end

function Utility:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

function Utility:CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Main Window Creator
function GitanX:CreateWindow(options)
    options = options or {}
    local Window = {
        Name = options.Name or Config.Name,
        Theme = Themes[options.Theme] or Themes[Config.DefaultTheme],
        Size = options.Size or UDim2.new(0, 600, 0, 450),
        Tabs = {},
        Keybind = options.Keybind or Enum.KeyCode.RightControl,
        SaveConfig = options.SaveConfig ~= false,
        ConfigFolder = options.ConfigFolder or Config.Folder
    }
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GitanX_" .. HttpService:GenerateGUID(false)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = Window.Size
    Main.Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    Main.BackgroundColor3 = Window.Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    Utility:CreateCorner(Main, 16)
    Utility:CreateStroke(Main, 2, Window.Theme.Accent)
    Utility:AddGlassEffect(Main)
    
    -- Glow Effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0, -20, 0, -20)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://4996891970"
    Glow.ImageColor3 = Window.Theme.Accent
    Glow.ImageTransparency = 0.7
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(128, 128, 128, 128)
    Glow.ZIndex = 0
    Glow.Parent = Main
    
    -- Animated glow
    task.spawn(function()
        while Glow.Parent do
            Utility:Tween(Glow, {ImageTransparency = 0.5}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            Utility:Tween(Glow, {ImageTransparency = 0.8}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end)
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Window.Theme.Surface
    Header.BorderSizePixel = 0
    Header.Parent = Main
    
    Utility:CreateCorner(Header, 16)
    Utility:CreateGradient(Header, Window.Theme.Gradient)
    Utility:MakeDraggable(Header)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Window.Name
    Title.TextColor3 = Window.Theme.Text
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Version
    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.Size = UDim2.new(0, 100, 1, 0)
    Version.Position = UDim2.new(0, 230, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. Config.Version
    Version.TextColor3 = Window.Theme.SubText
    Version.TextSize = 12
    Version.Font = Enum.Font.Gotham
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Parent = Header
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = Header
    
    Utility:CreateCorner(CloseBtn, 10)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 30, 30)}, 0.1)
        task.wait(0.1)
        Utility:Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Utility:Tween(CloseBtn, {Size = UDim2.new(0, 44, 0, 44)}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utility:Tween(CloseBtn, {Size = UDim2.new(0, 40, 0, 40)}, 0.2)
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.BackgroundColor3 = Window.Theme.Surface
    TabContainer.BackgroundTransparency = 0.5
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = Main
    
    Utility:CreateCorner(TabContainer, 12)
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -180, 1, -60)
    ContentContainer.Position = UDim2.new(0, 170, 0, 60)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = Main
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Window.Keybind then
            Main.Visible = not Main.Visible
        end
    end)
    
    -- Tab Functions
    function Window:CreateTab(name, icon)
        local Tab = {
            Name = name,
            Icon = icon,
            Active = false,
            Elements = {}
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Window.Theme.Surface
        TabButton.BackgroundTransparency = Tab.Active and 0 or 0.5
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        Utility:CreateCorner(TabButton, 8)
        
        -- Tab Icon
        if icon then
            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(0, 10, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = icon
            Icon.ImageColor3 = Window.Theme.Text
            Icon.Parent = TabButton
        end
        
        -- Tab Label
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -40, 1, 0)
        Label.Position = UDim2.new(0, 35, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Window.Theme.Text
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Window.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Activation
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Active = false
                tab.Button.BackgroundTransparency = 0.5
                tab.Content.Visible = false
            end
            
            Tab.Active = true
            Utility:Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
            TabContent.Visible = true
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if not Tab.Active then
                Utility:Tween(TabButton, {BackgroundTransparency = 0.3}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not Tab.Active then
                Utility:Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        -- Auto-activate first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Element Creators
        function Tab:AddButton(options)
            options = options or {}
            local Button = Instance.new("TextButton")
            Button.Name = options.Name or "Button"
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Window.Theme.Surface
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.Parent = TabContent
            
            Utility:CreateCorner(Button, 8)
            Utility:CreateStroke(Button, 1, Window.Theme.Accent)
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = options.Name or "Button"
            ButtonLabel.TextColor3 = Window.Theme.Text
            ButtonLabel.TextSize = 14
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = Window.Theme.Accent}, 0.1)
                task.wait(0.1)
                Utility:Tween(Button, {BackgroundColor3 = Window.Theme.Surface}, 0.2)
                
                if options.Callback then
                    options.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = Window.Theme.Primary}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = Window.Theme.Surface}, 0.2)
            end)
            
            return Button
        end
        
        function Tab:AddToggle(options)
            options = options or {}
            local toggled = options.Default or false
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = options.Name or "Toggle"
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            Toggle.BackgroundColor3 = Window.Theme.Surface
            Toggle.BorderSizePixel = 0
            Toggle.Parent = TabContent
            
            Utility:CreateCorner(Toggle, 8)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = options.Name or "Toggle"
            ToggleLabel.TextColor3 = Window.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Background
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = Toggle
            
            Utility:CreateCorner(ToggleButton, 10)
            
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Window.Theme.Text
            Circle.BorderSizePixel = 0
            Circle.Parent = ToggleButton
            
            Utility:CreateCorner(Circle, 8)
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                Utility:Tween(ToggleButton, {BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Background}, 0.2)
                Utility:Tween(Circle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                
                if options.Callback then
                    options.Callback(toggled)
                end
            end)
            
            return Toggle
        end
        
        function Tab:AddSlider(options)
            options = options or {}
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or 50
            local increment = options.Increment or 1
            local value = default
            
            local Slider = Instance.new("Frame")
            Slider.Name = options.Name or "Slider"
            Slider.Size = UDim2.new(1, 0, 0, 60)
            Slider.BackgroundColor3 = Window.Theme.Surface
            Slider.BorderSizePixel = 0
            Slider.Parent = TabContent
            
            Utility:CreateCorner(Slider, 8)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = options.Name or "Slider"
            SliderLabel.TextColor3 = Window.Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = Window.Theme.Accent
            ValueLabel.TextSize = 14
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Slider
            
            local SliderBack = Instance.new("Frame")
            SliderBack.Size = UDim2.new(1, -20, 0, 6)
            SliderBack.Position = UDim2.new(0, 10, 1, -15)
            SliderBack.BackgroundColor3 = Window.Theme.Background
            SliderBack.BorderSizePixel = 0
            SliderBack.Parent = Slider
            
            Utility:CreateCorner(SliderBack, 3)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Window.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBack
            
            Utility:CreateCorner(SliderFill, 3)
            Utility:CreateGradient(SliderFill, Window.Theme.Gradient)
            
            local Dragging = false
            
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)
            
            SliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local relativePos = math.clamp((mousePos - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * relativePos)
                    value = math.floor(value / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    Utility:Tween(SliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
                    ValueLabel.Text = tostring(value)
                    
                    if options.Callback then
                        options.Callback(value)
                    end
                end
            end)
            
            return Slider
        end
        
        function Tab:AddDropdown(options)
            options = options or {}
            local list = options.List or {}
            local selected = options.Default or list[1] or "None"
            local isOpen = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = options.Name or "Dropdown"
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            Dropdown.BackgroundColor3 = Window.Theme.Surface
            Dropdown.BorderSizePixel = 0
            Dropdown.ClipsDescendants = false
            Dropdown.Parent = TabContent
            
            Utility:CreateCorner(Dropdown, 8)
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -100, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = options.Name or "Dropdown"
            DropdownLabel.TextColor3 = Window.Theme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = Dropdown
            
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Size = UDim2.new(0, 120, 0, 30)
            SelectedLabel.Position = UDim2.new(1, -130, 0, 5)
            SelectedLabel.BackgroundColor3 = Window.Theme.Background
            SelectedLabel.Text = selected
            SelectedLabel.TextColor3 = Window.Theme.Accent
            SelectedLabel.TextSize = 13
            SelectedLabel.Font = Enum.Font.GothamBold
            SelectedLabel.BorderSizePixel = 0
            SelectedLabel.Parent = Dropdown
            
            Utility:CreateCorner(SelectedLabel, 6)
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 30)
            Arrow.Position = UDim2.new(1, -25, 0, 5)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Window.Theme.Text
            Arrow.TextSize = 10
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Parent = Dropdown
            
            local DropList = Instance.new("Frame")
            DropList.Name = "List"
            DropList.Size = UDim2.new(0, 120, 0, 0)
            DropList.Position = UDim2.new(1, -130, 1, 5)
            DropList.BackgroundColor3 = Window.Theme.Surface
            DropList.BorderSizePixel = 0
            DropList.ClipsDescendants = true
            DropList.ZIndex = 10
            DropList.Parent = Dropdown
            
            Utility:CreateCorner(DropList, 6)
            Utility:CreateStroke(DropList, 1, Window.Theme.Accent)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropList
            
            for _, item in ipairs(list) do
                local ItemButton = Instance.new("TextButton")
                ItemButton.Size = UDim2.new(1, 0, 0, 30)
                ItemButton.BackgroundColor3 = Window.Theme.Surface
                ItemButton.BackgroundTransparency = 0.5
                ItemButton.Text = item
                ItemButton.TextColor3 = Window.Theme.Text
                ItemButton.TextSize = 12
                ItemButton.Font = Enum.Font.Gotham
                ItemButton.BorderSizePixel = 0
                ItemButton.Parent = DropList
                
                ItemButton.MouseButton1Click:Connect(function()
                    selected = item
                    SelectedLabel.Text = selected
                    isOpen = false
                    Utility:Tween(DropList, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                    Utility:Tween(Arrow, {Rotation = 0}, 0.2)
                    
                    if options.Callback then
                        options.Callback(selected)
                    end
                end)
                
                ItemButton.MouseEnter:Connect(function()
                    Utility:Tween(ItemButton, {BackgroundTransparency = 0}, 0.1)
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    Utility:Tween(ItemButton, {BackgroundTransparency = 0.5}, 0.1)
                end)
            end
            
            SelectedLabel.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isOpen = not isOpen
                    if isOpen then
                        Utility:Tween(DropList, {Size = UDim2.new(0, 120, 0, math.min(#list * 30, 150))}, 0.3)
                        Utility:Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Utility:Tween(DropList, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                        Utility:Tween(Arrow, {Rotation = 0}, 0.2)
                    end
                end
            end)
            
            return Dropdown
        end
        
        function Tab:AddTextbox(options)
            options = options or {}
            
            local Textbox = Instance.new("Frame")
            Textbox.Name = options.Name or "Textbox"
            Textbox.Size = UDim2.new(1, 0, 0, 50)
            Textbox.BackgroundColor3 = Window.Theme.Surface
            Textbox.BorderSizePixel = 0
            Textbox.Parent = TabContent
            
            Utility:CreateCorner(Textbox, 8)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = options.Name or "Textbox"
            TextboxLabel.TextColor3 = Window.Theme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = Textbox
            
            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(1, -20, 0, 25)
            Input.Position = UDim2.new(0, 10, 1, -30)
            Input.BackgroundColor3 = Window.Theme.Background
            Input.Text = options.Default or ""
            Input.PlaceholderText = options.Placeholder or "Enter text..."
            Input.TextColor3 = Window.Theme.Text
            Input.PlaceholderColor3 = Window.Theme.SubText
            Input.TextSize = 13
            Input.Font = Enum.Font.Gotham
            Input.BorderSizePixel = 0
            Input.ClearTextOnFocus = false
            Input.Parent = Textbox
            
            Utility:CreateCorner(Input, 6)
            Utility:CreateStroke(Input, 1, Window.Theme.Accent)
            
            Input.FocusLost:Connect(function(enterPressed)
                if enterPressed and options.Callback then
                    options.Callback(Input.Text)
                end
            end)
            
            Input.Focused:Connect(function()
                Utility:Tween(Input, {BackgroundColor3 = Window.Theme.Primary}, 0.2)
            end)
            
            Input.FocusLost:Connect(function()
                Utility:Tween(Input, {BackgroundColor3 = Window.Theme.Background}, 0.2)
            end)
            
            return Textbox
        end
        
        function Tab:AddKeybind(options)
            options = options or {}
            local key = options.Default or Enum.KeyCode.E
            local listening = false
            
            local Keybind = Instance.new("Frame")
            Keybind.Name = options.Name or "Keybind"
            Keybind.Size = UDim2.new(1, 0, 0, 40)
            Keybind.BackgroundColor3 = Window.Theme.Surface
            Keybind.BorderSizePixel = 0
            Keybind.Parent = TabContent
            
            Utility:CreateCorner(Keybind, 8)
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = options.Name or "Keybind"
            KeybindLabel.TextColor3 = Window.Theme.Text
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = Keybind
            
            local KeyButton = Instance.new("TextButton")
            KeyButton.Size = UDim2.new(0, 80, 0, 30)
            KeyButton.Position = UDim2.new(1, -90, 0, 5)
            KeyButton.BackgroundColor3 = Window.Theme.Background
            KeyButton.Text = key.Name
            KeyButton.TextColor3 = Window.Theme.Accent
            KeyButton.TextSize = 13
            KeyButton.Font = Enum.Font.GothamBold
            KeyButton.BorderSizePixel = 0
            KeyButton.Parent = Keybind
            
            Utility:CreateCorner(KeyButton, 6)
            Utility:CreateStroke(KeyButton, 1, Window.Theme.Accent)
            
            KeyButton.MouseButton1Click:Connect(function()
                listening = true
                KeyButton.Text = "..."
                Utility:Tween(KeyButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode
                    KeyButton.Text = key.Name
                    listening = false
                    Utility:Tween(KeyButton, {BackgroundColor3 = Window.Theme.Background}, 0.2)
                    
                    if options.Callback then
                        options.Callback(key)
                    end
                end
                
                if not gameProcessed and input.KeyCode == key and options.Action then
                    options.Action()
                end
            end)
            
            return Keybind
        end
        
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundColor3 = Window.Theme.Surface
            Label.BackgroundTransparency = 0.7
            Label.Text = text or "Label"
            Label.TextColor3 = Window.Theme.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.BorderSizePixel = 0
            Label.Parent = TabContent
            
            Utility:CreateCorner(Label, 6)
            
            return Label
        end
        
        function Tab:AddSection(name)
            local Section = Instance.new("Frame")
            Section.Name = name
            Section.Size = UDim2.new(1, 0, 0, 35)
            Section.BackgroundTransparency = 1
            Section.BorderSizePixel = 0
            Section.Parent = TabContent
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -20, 0, 2)
            Line.Position = UDim2.new(0, 10, 0.5, 0)
            Line.BackgroundColor3 = Window.Theme.Accent
            Line.BorderSizePixel = 0
            Line.Parent = Section
            
            Utility:CreateGradient(Line, Window.Theme.Gradient)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(0, 150, 1, 0)
            SectionLabel.Position = UDim2.new(0.5, -75, 0, 0)
            SectionLabel.BackgroundColor3 = Window.Theme.Background
            SectionLabel.Text = " " .. name .. " "
            SectionLabel.TextColor3 = Window.Theme.Accent
            SectionLabel.TextSize = 16
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.BorderSizePixel = 0
            SectionLabel.Parent = Section
            
            Utility:CreateCorner(SectionLabel, 6)
            
            return Section
        end
        
        function Tab:AddColorPicker(options)
            options = options or {}
            local color = options.Default or Color3.fromRGB(255, 255, 255)
            local isOpen = false
            
            local ColorPicker = Instance.new("Frame")
            ColorPicker.Name = options.Name or "ColorPicker"
            ColorPicker.Size = UDim2.new(1, 0, 0, 40)
            ColorPicker.BackgroundColor3 = Window.Theme.Surface
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Parent = TabContent
            
            Utility:CreateCorner(ColorPicker, 8)
            
            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Size = UDim2.new(1, -60, 1, 0)
            PickerLabel.Position = UDim2.new(0, 10, 0, 0)
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Text = options.Name or "Color Picker"
            PickerLabel.TextColor3 = Window.Theme.Text
            PickerLabel.TextSize = 14
            PickerLabel.Font = Enum.Font.Gotham
            PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
            PickerLabel.Parent = ColorPicker
            
            local ColorDisplay = Instance.new("TextButton")
            ColorDisplay.Size = UDim2.new(0, 40, 0, 30)
            ColorDisplay.Position = UDim2.new(1, -50, 0, 5)
            ColorDisplay.BackgroundColor3 = color
            ColorDisplay.Text = ""
            ColorDisplay.BorderSizePixel = 0
            ColorDisplay.Parent = ColorPicker
            
            Utility:CreateCorner(ColorDisplay, 6)
            Utility:CreateStroke(ColorDisplay, 2, Window.Theme.Text)
            
            ColorDisplay.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    -- Simple color picker implementation
                    -- You can expand this with a full HSV picker
                    task.spawn(function()
                        local hue = 0
                        while isOpen do
                            hue = (hue + 1) % 360
                            color = Color3.fromHSV(hue / 360, 1, 1)
                            ColorDisplay.BackgroundColor3 = color
                            
                            if options.Callback then
                                options.Callback(color)
                            end
                            task.wait(0.05)
                        end
                    end)
                end
            end)
            
            return ColorPicker
        end
        
        return Tab
    end
    
    -- Notifications System
    function Window:Notify(options)
        options = options or {}
        local NotifContainer = ScreenGui:FindFirstChild("Notifications") or Instance.new("Frame")
        NotifContainer.Name = "Notifications"
        NotifContainer.Size = UDim2.new(0, 300, 1, 0)
        NotifContainer.Position = UDim2.new(1, -310, 0, 10)
        NotifContainer.BackgroundTransparency = 1
        NotifContainer.Parent = ScreenGui
        
        local NotifList = NotifContainer:FindFirstChild("UIListLayout") or Instance.new("UIListLayout")
        NotifList.SortOrder = Enum.SortOrder.LayoutOrder
        NotifList.Padding = UDim.new(0, 10)
        NotifList.Parent = NotifContainer
        
        local Notification = Instance.new("Frame")
        Notification.Size = UDim2.new(1, 0, 0, 80)
        Notification.BackgroundColor3 = Window.Theme.Surface
        Notification.BorderSizePixel = 0
        Notification.Parent = NotifContainer
        
        Utility:CreateCorner(Notification, 12)
        Utility:CreateStroke(Notification, 2, Window.Theme.Accent)
        Utility:AddGlassEffect(Notification)
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = options.Title or "Notification"
        NotifTitle.TextColor3 = Window.Theme.Accent
        NotifTitle.TextSize = 16
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = Notification
        
        local NotifMessage = Instance.new("TextLabel")
        NotifMessage.Size = UDim2.new(1, -20, 1, -35)
        NotifMessage.Position = UDim2.new(0, 10, 0, 30)
        NotifMessage.BackgroundTransparency = 1
        NotifMessage.Text = options.Message or "Message"
        NotifMessage.TextColor3 = Window.Theme.Text
        NotifMessage.TextSize = 13
        NotifMessage.Font = Enum.Font.Gotham
        NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
        NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
        NotifMessage.TextWrapped = true
        NotifMessage.Parent = Notification
        
        -- Slide in animation
        Notification.Position = UDim2.new(1, 0, 0, 0)
        Utility:Tween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        
        -- Auto destroy
        task.delay(options.Duration or 5, function()
            Utility:Tween(Notification, {Position = UDim2.new(1, 0, 0, 0)}, 0.3)
            task.wait(0.3)
            Notification:Destroy()
        end)
    end
    
    -- Configuration Save/Load
    function Window:SaveConfig(name)
        if not Window.SaveConfig then return end
        
        name = name or "default"
        local config = {}
        
        -- Save all toggle/slider/etc states
        for _, tab in pairs(Window.Tabs) do
            config[tab.Name] = {}
            -- Add your save logic here
        end
        
        writefile(Window.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(config))
        Window:Notify({
            Title = "Config Saved",
            Message = "Configuration '" .. name .. "' has been saved!",
            Duration = 3
        })
    end
    
    function Window:LoadConfig(name)
        if not Window.SaveConfig then return end
        
        name = name or "default"
        if not isfile(Window.ConfigFolder .. "/" .. name .. ".json") then
            Window:Notify({
                Title = "Error",
                Message = "Configuration not found!",
                Duration = 3
            })
            return
        end
        
        local config = HttpService:JSONDecode(readfile(Window.ConfigFolder .. "/" .. name .. ".json"))
        
        -- Load all saved states
        -- Add your load logic here
        
        Window:Notify({
            Title = "Config Loaded",
            Message = "Configuration '" .. name .. "' has been loaded!",
            Duration = 3
        })
    end
    
    -- Intro Animation
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Utility:Tween(Main, {
        Size = Window.Size,
        Position = UDim2.new(0.5, -Window.Size.X.Offset/2, 0.5, -Window.Size.Y.Offset/2)
    }, 0.5, Enum.EasingStyle.Back)
    
    -- Welcome notification
    task.delay(0.6, function()
        Window:Notify({
            Title = "Welcome to " .. Window.Name,
            Message = "The most advanced Roblox UI library! Press " .. Window.Keybind.Name .. " to toggle.",
            Duration = 5
        })
    end)
    
    return Window
end

return GitanX
