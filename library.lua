--[[
    ██████╗ ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
    ██╔════╝ ██║╚══██╔══╝██╔══██╗████╗  ██║╚██╗██╔╝
    ██║  ███╗██║   ██║   ███████║██╔██╗ ██║ ╚███╔╝ 
    ██║   ██║██║   ██║   ██╔══██║██║╚██╗██║ ██╔██╗ 
    ╚██████╔╝██║   ██║   ██║  ██║██║ ╚████║██╔╝ ██╗
     ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
    
    GitanX - Premium UI Library for Roblox
    Version: 2.0.0
    Style: Luna-Inspired Modern 
]]

local GitanX = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

-- Enhanced Theme System (Luna-inspired)
local Themes = {
Dark = {
    Primary = Color3.fromRGB(255, 107, 53),     -- Orange
    Secondary = Color3.fromRGB(255, 68, 68),    -- Rouge
        Background = Color3.fromRGB(18, 18, 22),
        Surface = Color3.fromRGB(28, 28, 35),
        SurfaceLight = Color3.fromRGB(38, 38, 48),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(156, 156, 170),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(168, 85, 247),
        Border = Color3.fromRGB(55, 55, 70),
    },
    Luna = {
        Primary = Color3.fromRGB(99, 102, 241),
        Secondary = Color3.fromRGB(139, 92, 246),
        Background = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(25, 25, 32),
        SurfaceLight = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(167, 139, 250),
        Border = Color3.fromRGB(51, 65, 85),
    },
    Neon = {
        Primary = Color3.fromRGB(255, 0, 255),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 28),
        SurfaceLight = Color3.fromRGB(30, 30, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 220),
        Success = Color3.fromRGB(0, 255, 157),
        Warning = Color3.fromRGB(255, 191, 0),
        Error = Color3.fromRGB(255, 50, 100),
        Accent = Color3.fromRGB(138, 43, 255),
        Border = Color3.fromRGB(60, 60, 80),
    },
}

-- Main Library
function GitanX:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "GitanX"
    local CurrentTheme = config.Theme or "Dark"
    local Theme = Themes[CurrentTheme]
    local LoadingEnabled = config.LoadingEnabled ~= false
    local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Notifications = {}
    Window.CurrentTheme = CurrentTheme
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "GitanX",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Container with modern shadow
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -350, 0.5, -250),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = MainFrame,
    })
    
    -- Modern gradient overlay
    local GradientOverlay = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = GradientOverlay,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Rotation = 45,
        Parent = GradientOverlay,
    })
    
    -- Enhanced glow effect
    local Glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    -- Top Bar with modern design
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = TopBar,
    })
    
    -- Logo/Icon
    local Logo = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Logo,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Rotation = 45,
        Parent = Logo,
    })
    
    local LogoText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "G",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = Logo,
    })
    
    -- Title with modern typography
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.5, -80, 1, 0),
        Position = UDim2.new(0, 65, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    -- Subtitle
    local Subtitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -140, 0, 15),
        Position = UDim2.new(0, 65, 0, 35),
        BackgroundTransparency = 1,
        Text = "Premium UI Library",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    -- Modern accent line
local AccentLine = CreateInstance("Frame", {
    Name = "AccentLine",
    Size = UDim2.new(1, 0, 0, 2),  -- Plus fin (2 au lieu de 3)
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Parent = AccentLine,
    })
    
    -- Modern control buttons
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -50, 0, 11),
        BackgroundColor3 = Theme.SurfaceLight,
        Text = "",
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = CloseButton,
    })
    
    local CloseIcon = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "✕",
        TextColor3 = Theme.Error,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = CloseButton,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Glow, {ImageTransparency = 1}, 0.4)
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.2)
        Tween(CloseIcon, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
        Tween(CloseIcon, {TextColor3 = Theme.Error}, 0.2)
    end)
    
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(1, -100, 0, 11),
        BackgroundColor3 = Theme.SurfaceLight,
        Text = "",
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MinimizeButton,
    })
    
    local MinimizeIcon = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "−",
        TextColor3 = Theme.Warning,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = MinimizeButton,
    })
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.Warning}, 0.2)
        Tween(MinimizeIcon, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
        Tween(MinimizeIcon, {TextColor3 = Theme.Warning}, 0.2)
    end)
    
    -- Modern sidebar for tabs
    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, -70),
        Position = UDim2.new(0, 10, 0, 65),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Sidebar,
    })
    
local TabsContainer = CreateInstance("ScrollingFrame", {
    Name = "TabsContainer",
    Size = UDim2.new(1, -10, 1, -90),  -- Réduit pour faire place au profil
    Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        BorderSizePixel = 0,
        Parent = Sidebar,
    })
-- === PROFIL UTILISATEUR EN BAS ===
local PlayerProfile = CreateInstance("Frame", {
    Name = "PlayerProfile",
    Size = UDim2.new(1, -10, 0, 70),
    Position = UDim2.new(0, 5, 1, -75),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Parent = Sidebar,
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(0, 12),
    Parent = PlayerProfile,
})

CreateInstance("UIStroke", {
    Color = Theme.Border,
    Transparency = 0.7,
    Thickness = 1,
    Parent = PlayerProfile,
})

-- Avatar circulaire
local PlayerAvatar = CreateInstance("ImageLabel", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Theme.Primary,
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. game.Players.LocalPlayer.UserId .. "&width=150&height=150&format=png",
    BorderSizePixel = 0,
    Parent = PlayerProfile,
})

CreateInstance("UICorner", {
    CornerRadius = UDim.new(1, 0),
    Parent = PlayerAvatar,
})

CreateInstance("UIStroke", {
    Color = Theme.Primary,
    Thickness = 3,
    Parent = PlayerAvatar,
})

-- Nom du joueur
local PlayerName = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -75, 0, 22),
    Position = UDim2.new(0, 68, 0, 10),
    BackgroundTransparency = 1,
    Text = game.Players.LocalPlayer.Name,
    TextColor3 = Theme.Text,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = PlayerProfile,
})

-- DisplayName
local PlayerDisplay = CreateInstance("TextLabel", {
    Size = UDim2.new(1, -75, 0, 18),
    Position = UDim2.new(0, 68, 0, 35),
    BackgroundTransparency = 1,
    Text = "@" .. game.Players.LocalPlayer.DisplayName,
    TextColor3 = Theme.TextSecondary,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = PlayerProfile,
})
    
    -- Modern content area
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -210, 1, -70),
        Position = UDim2.new(0, 200, 0, 65),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame,
    })
    
    MakeDraggable(MainFrame, TopBar)
    
    function Window:Minimize()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 60)}, 0.3)
            MinimizeIcon.Text = "+"
            Sidebar.Visible = false
            ContentContainer.Visible = false
        else
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
            MinimizeIcon.Text = "−"
            Sidebar.Visible = true
            ContentContainer.Visible = true
        end
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            Window:Minimize()
        end
    end)
    
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        Window.CurrentTheme = themeName
        Theme = Themes[themeName]
        
        Tween(MainFrame, {BackgroundColor3 = Theme.Background}, 0.3)
        Tween(Sidebar, {BackgroundColor3 = Theme.Surface}, 0.3)
        Tween(TopBar, {BackgroundColor3 = Theme.Surface}, 0.3)
        Tween(Glow, {ImageColor3 = Theme.Primary}, 0.3)
        Tween(Title, {TextColor3 = Theme.Text}, 0.3)
        
        Window:Notify({
            Title = "Theme Changed",
            Content = themeName .. " theme applied successfully!",
            Duration = 2,
            Type = "Success"
        })
    end
    
    -- Modern loading animation
    if LoadingEnabled then
        local LoadingFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Parent = MainFrame,
            ZIndex = 10,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 16),
            Parent = LoadingFrame,
        })
        
        local LoadingText = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 200, 0, 50),
            Position = UDim2.new(0.5, -100, 0.5, -50),
            BackgroundTransparency = 1,
            Text = "GitanX",
            TextColor3 = Theme.Primary,
            TextSize = 32,
            Font = Enum.Font.GothamBold,
            Parent = LoadingFrame,
        })
        
        local LoadingSubtext = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 200, 0, 30),
            Position = UDim2.new(0.5, -100, 0.5, 10),
            BackgroundTransparency = 1,
            Text = "Loading...",
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = LoadingFrame,
        })
        
        local LoadingBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 3),
            Position = UDim2.new(0.5, -150, 0.5, 50),
            BackgroundColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Parent = LoadingFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = LoadingBar,
        })
        
        CreateInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.Primary),
                ColorSequenceKeypoint.new(1, Theme.Secondary),
            }),
            Parent = LoadingBar,
        })
        
        MainFrame.Size = UDim2.new(0, 700, 0, 500)
        
        Tween(LoadingBar, {Size = UDim2.new(0, 300, 0, 3)}, 1.5, Enum.EasingStyle.Quad)
        wait(1.5)
        
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.3)
        Tween(LoadingText, {TextTransparency = 1}, 0.3)
        Tween(LoadingSubtext, {TextTransparency = 1}, 0.3)
        Tween(LoadingBar, {BackgroundTransparency = 1}, 0.3)
        
        wait(0.3)
        LoadingFrame:Destroy()
    else
        Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
    end
    
    function Window:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local TabIcon = config.Icon or "⚡"
        
        local Tab = {}
        Tab.Elements = {}
        
local TabButton = CreateInstance("TextButton", {
    Name = TabName,
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Theme.Surface,  -- CHANGE LA COULEUR
    BackgroundTransparency = 0.5,  -- Met 0.5 au lieu de 1
            BorderSizePixel = 0,
            Text = "",
            Parent = TabsContainer,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = TabButton,
        })
        
local TabIndicator = CreateInstance("Frame", {
    Size = UDim2.new(0, 4, 0, 0),  -- Plus épais (4 au lieu de 3)
    Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Parent = TabButton,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = TabIndicator,
        })
        
        local TabIconLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 35, 0, 35),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Text = TabIcon,
            TextColor3 = Theme.TextSecondary,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = TabButton,
        })
        
        local TabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -55, 1, 0),
            Position = UDim2.new(0, 50, 0, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton,
        })
        
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Visible = false,
            Parent = ContentContainer,
        })
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = TabContent,
        })
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 15),
            Parent = TabContent,
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
                Tween(tab.IconLabel, {TextColor3 = Theme.TextSecondary}, 0.2)
                Tween(tab.Label, {TextColor3 = Theme.TextSecondary}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
            Tween(TabIndicator, {Size = UDim2.new(0, 3, 1, -10)}, 0.3, Enum.EasingStyle.Back)
            Tween(TabIconLabel, {TextColor3 = Theme.Primary}, 0.2)
            Tween(TabLabel, {TextColor3 = Theme.Text}, 0.2)
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.8}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Indicator = TabIndicator
        Tab.IconLabel = TabIconLabel
        Tab.Label = TabLabel
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0}, 0)
            Tween(TabIndicator, {Size = UDim2.new(0, 3, 1, -10)}, 0)
            TabIconLabel.TextColor3 = Theme.Primary
            TabLabel.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
        end
        
        TabsContainer.CanvasSize = UDim2.new(0, 0, 0, TabsContainer.UIListLayout.AbsoluteContentSize.Y)
        
        function Tab:CreateButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ButtonFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = ButtonFrame,
            })
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ButtonName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                Parent = ButtonFrame,
            })
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Surface}, 0.2)
                Callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            return Button
        end
        
        function Tab:CreateLabel(text)
            text = text or "Label"
            
            local LabelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 32),
                BackgroundTransparency = 1,
                Parent = TabContent,
            })
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextSecondary,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = LabelFrame,
            })
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local LabelObject = {}
            function LabelObject:Set(newText)
                Label.Text = newText
            end
            
            return LabelObject
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleState = Default
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ToggleFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = ToggleFrame,
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = ToggleName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame,
            })
            
            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 50, 0, 26),
                Position = UDim2.new(1, -60, 0.5, -13),
                BackgroundColor3 = Default and Theme.Success or Theme.SurfaceLight,
                Text = "",
                BorderSizePixel = 0,
                Parent = ToggleFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Default and Theme.Success or Theme.Border,
                Transparency = 0.3,
                Thickness = 2,
                Parent = ToggleButton,
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = Default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = ToggleButton,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle,
            })
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.2)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Success}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)}, 0.2, Enum.EasingStyle.Back)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Border}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)}, 0.2, Enum.EasingStyle.Back)
                end
                
                Callback(ToggleState)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local ToggleObject = {}
            function ToggleObject:Set(value)
                ToggleState = value
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.2)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Success}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                    Tween(ToggleButton.UIStroke, {Color = Theme.Border}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)}, 0.2)
                end
                Callback(ToggleState)
            end
            
            return ToggleObject
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end
            
            local SliderValue = Default
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 55),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = SliderFrame,
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 15, 0, 8),
                BackgroundTransparency = 1,
                Text = SliderName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame,
            })
            
            local SliderValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(Default),
                TextColor3 = Theme.Primary,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame,
            })
            
            local SliderBackground = CreateInstance("Frame", {
                Size = UDim2.new(1, -30, 0, 8),
                Position = UDim2.new(0, 15, 1, -18),
                BackgroundColor3 = Theme.SurfaceLight,
                BorderSizePixel = 0,
                Parent = SliderFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBackground,
            })
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = SliderBackground,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill,
            })
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.Primary),
                    ColorSequenceKeypoint.new(1, Theme.Secondary),
                }),
                Parent = SliderFill,
            })
            
            local SliderButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((Default - Min) / (Max - Min), -8, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Text = "",
                Parent = SliderBackground,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Thickness = 2,
                Parent = SliderButton,
            })
            
            local dragging = false
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
                Tween(SliderButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    Tween(SliderButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.1)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local sliderPos = SliderBackground.AbsolutePosition.X
                    local sliderSize = SliderBackground.AbsoluteSize.X
                    
                    local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                    SliderValue = math.floor(((Max - Min) * value + Min))
                    SliderValue = math.clamp(SliderValue, Min, Max)
                    
                    SliderFill.Size = UDim2.new(value, 0, 1, 0)
                    SliderButton.Position = UDim2.new(value, -8, 0.5, -8)
                    SliderValueLabel.Text = tostring(SliderValue)
                    
                    Callback(SliderValue)
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local SliderObject = {}
            function SliderObject:Set(value)
                value = math.clamp(value, Min, Max)
                SliderValue = value
                local percent = (value - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
                SliderValueLabel.Text = tostring(value)
                Callback(value)
            end
            
            return SliderObject
        end
        
        function Tab:CreateDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownValue = Default
            local DropdownOpen = false
            
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = DropdownFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = DropdownFrame,
            })
            
            local DropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, -20, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = DropdownName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame,
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(0.5, -30, 0, 32),
                Position = UDim2.new(0.5, 10, 0, 5),
                BackgroundColor3 = Theme.SurfaceLight,
                Text = Default,
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                Parent = DropdownFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownButton,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 30),
                Parent = DropdownButton,
            })
            
            local DropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.TextSecondary,
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                Parent = DropdownButton,
            })
            
            local DropdownContainer = CreateInstance("Frame", {
                Size = UDim2.new(0.5, -30, 0, 0),
                Position = UDim2.new(0.5, 10, 0, 42),
                BackgroundColor3 = Theme.SurfaceLight,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                Parent = DropdownFrame,
                ZIndex = 5,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.3,
                Thickness = 1,
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 6),
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                Parent = DropdownContainer,
            })
            
            for _, option in pairs(Options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, -12, 0, 28),
                    BackgroundColor3 = Theme.Surface,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    Parent = DropdownContainer,
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = OptionButton,
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownValue = option
                    DropdownButton.Text = option
                    DropdownOpen = false
                    Tween(DropdownContainer, {Size = UDim2.new(0.5, -30, 0, 0)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                    Callback(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Theme.Surface}, 0.2)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                if DropdownOpen then
                    DropdownContainer.Visible = true
                    local contentSize = DropdownContainer.UIListLayout.AbsoluteContentSize.Y + 12
                    Tween(DropdownContainer, {Size = UDim2.new(0.5, -30, 0, contentSize)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownContainer, {Size = UDim2.new(0.5, -30, 0, 0)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local DropdownObject = {}
            function DropdownObject:Set(value)
                DropdownValue = value
                DropdownButton.Text = value
                Callback(value)
            end
            
            return DropdownObject
        end
        
        function Tab:CreateInput(config)
            config = config or {}
            local InputName = config.Name or "Input"
            local Placeholder = config.Placeholder or "Enter text..."
            local Callback = config.Callback or function() end
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = InputFrame,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = InputFrame,
            })
            
            local InputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, -15, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = InputName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame,
            })
            
            local InputBox = CreateInstance("TextBox", {
                Size = UDim2.new(0.6, -30, 0, 32),
                Position = UDim2.new(0.4, 5, 0, 5),
                BackgroundColor3 = Theme.SurfaceLight,
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Theme.TextSecondary,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                Parent = InputFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = InputBox,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = InputBox,
            })
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Callback(InputBox.Text)
                end
                Tween(InputBox, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                Tween(InputFrame.UIStroke, {Color = Theme.Border}, 0.2)
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Surface}, 0.2)
                Tween(InputFrame.UIStroke, {Color = Theme.Primary}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            return InputBox
        end
        
        return Tab
    end
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "This is a notification"
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local NotificationColor = Theme.Primary
        if Type == "Success" then
            NotificationColor = Theme.Success
        elseif Type == "Warning" then
            NotificationColor = Theme.Warning
        elseif Type == "Error" then
            NotificationColor = Theme.Error
        end
        
        local NotificationFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 85),
            Position = UDim2.new(1, -20, 1, -100 - (#Window.Notifications * 95)),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            Parent = ScreenGui,
            ClipsDescendants = true,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = NotificationFrame,
        })
        
        CreateInstance("UIStroke", {
            Color = NotificationColor,
            Thickness = 2,
            Parent = NotificationFrame,
        })
        
        local AccentBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 5, 1, 0),
            BackgroundColor3 = NotificationColor,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, NotificationColor),
                ColorSequenceKeypoint.new(1, Theme.Secondary),
            }),
            Rotation = 90,
            Parent = AccentBar,
        })
        
        local NotificationIcon = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 35, 0, 35),
            Position = UDim2.new(0, 15, 0, 12),
            BackgroundColor3 = NotificationColor,
            BackgroundTransparency = 0.9,
            Text = Type == "Success" and "✓" or Type == "Warning" and "⚠" or Type == "Error" and "✕" or "ℹ",
            TextColor3 = NotificationColor,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = NotificationIcon,
        })
        
        local NotificationTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -115, 0, 20),
            Position = UDim2.new(0, 60, 0, 12),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotificationFrame,
        })
        
        local NotificationContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -115, 0, 45),
            Position = UDim2.new(0, 60, 0, 35),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotificationFrame,
        })
        
        local CloseBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -34, 0, 12),
            BackgroundColor3 = Theme.SurfaceLight,
            Text = "✕",
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = CloseBtn,
        })
        
        CloseBtn.MouseEnter:Connect(function()
            Tween(CloseBtn, {BackgroundColor3 = Theme.Error}, 0.2)
            Tween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)
        
        CloseBtn.MouseLeave:Connect(function()
            Tween(CloseBtn, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            Tween(CloseBtn, {TextColor3 = Theme.TextSecondary}, 0.2)
        end)
        
        table.insert(Window.Notifications, NotificationFrame)
        
        Tween(NotificationFrame, {Size = UDim2.new(0, 320, 0, 85)}, 0.4, Enum.EasingStyle.Back)
        
        CloseBtn.MouseButton1Click:Connect(function()
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 85)}, 0.2)
            wait(0.2)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
        
        spawn(function()
            wait(Duration)
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 85)}, 0.2)
            wait(0.2)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
    end
    
    return Window
end

return GitanX
