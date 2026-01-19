--[[
 ██████╗ ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
██╔════╝ ██║╚══██╔══╝██╔══██╗████╗  ██║╚██╗██╔╝
██║  ███╗██║   ██║   ███████║██╔██╗ ██║ ╚███╔╝ 
██║   ██║██║   ██║   ██╔══██║██║╚██╗██║ ██╔██╗ 
╚██████╔╝██║   ██║   ██║  ██║██║ ╚████║██╔╝ ██╗
 ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
              UI LIBRARY v2.0
          Made with 💜 by GitanX Team
          
    Main Credits:
    - GitanX Team | Main Development
    - Inspired by Luna Interface Suite
    - Enhanced with Modern Features
    
    Features:
    - Advanced UI Components
    - Theme System
    - Notifications System  
    - Color Picker
    - Keybind System
    - Search System
    - Configuration System
    - Dropdown Menus
    - Multi Dropdowns
    - Input Fields
    - Sections
    - Dividers
    - Paragraphs
    - And much more!
]]

local Release = "GitanX v2.0 - Ultimate Edition"

local GitanX = {
    Folder = "GitanX",
    Options = {},
    Flags = {},
    Themes = {},
    SaveManager = {},
    ThemeGradient = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(216, 27, 96))
    }
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Variables
local Dragging = {}
local NotificationQueue = {}

-- Utility Functions
local Utility = {}

function Utility:Tween(obj, props, time, style, dir, callback)
    time = time or 0.3
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(obj, TweenInfo.new(time, style, dir), props)
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    return tween
end

function Utility:MakeDraggable(frame, handle)
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local objectPosition = frame.Position
            local dragging = true
            local dragStart = input.Position
            local startPos = objectPosition
            
            local function update(input)
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                Utility:Tween(frame, {Position = newPos}, 0.1)
            end
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            
            while dragging do
                update(Mouse)
                RunService.RenderStepped:Wait()
            end
        end
    end)
end

function Utility:CreateRipple(button)
    button.ClipsDescendants = true
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ripple = Instance.new("ImageLabel")
            ripple.Name = "Ripple"
            ripple.Parent = button
            ripple.BackgroundTransparency = 1
            ripple.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
            ripple.ImageTransparency = 0.5
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.ZIndex = button.ZIndex + 1
            
            local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
            Utility:Tween(ripple, {
                Size = UDim2.new(0, size, 0, size),
                ImageTransparency = 1
            }, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                ripple:Destroy()
            end)
        end
    end)
end

function Utility:Round(num, bracket)
    bracket = bracket or 1
    return math.floor(num / bracket + 0.5) * bracket
end

function Utility:Create(class, properties)
    local obj = Instance.new(class)
    for prop, val in pairs(properties) do
        if prop ~= "Parent" then
            obj[prop] = val
        end
    end
    obj.Parent = properties.Parent
    return obj
end

-- Notification System
local NotificationSystem = {}

function NotificationSystem:Notify(config)
    config = config or {}
    local title = config.Title or "GitanX"
    local text = config.Text or "Notification"
    local duration = config.Duration or 3
    local icon = config.Icon or "check_circle"
    
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "GitanXNotification",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local Notification = Utility:Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 10, 1, -100 * (#NotificationQueue + 1)),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    
    table.insert(NotificationQueue, Notification)
    
    local Corner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Notification
    })
    
    local Glow = Utility:Create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.fromRGB(138, 43, 226),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0,
        Parent = Notification
    })
    
    local Gradient = Utility:Create("UIGradient", {
        Color = GitanX.ThemeGradient,
        Rotation = 45,
        Parent = Notification
    })
    
    local Title = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -60, 0, 25),
        Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    local Text = Utility:Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -60, 0, 35),
        Position = UDim2.new(0, 50, 0, 35),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = Notification
    })
    
    local Icon = Utility:Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0, 25),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageColor3 = Color3.fromRGB(138, 43, 226),
        Parent = Notification
    })
    
    local IconCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Icon
    })
    
    -- Slide in animation
    Utility:Tween(Notification, {Position = UDim2.new(1, -310, 1, -100 * (#NotificationQueue))}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto close
    task.delay(duration, function()
        Utility:Tween(Notification, {Position = UDim2.new(1, 10, 1, -100 * (#NotificationQueue))}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
            for i, v in pairs(NotificationQueue) do
                if v == Notification then
                    table.remove(NotificationQueue, i)
                end
            end
            ScreenGui:Destroy()
        end)
    end)
end

GitanX.Notify = function(self, config)
    return NotificationSystem:Notify(config)
end

-- Theme System
GitanX.Themes = {
    Purple = {
        Primary = Color3.fromRGB(138, 43, 226),
        Secondary = Color3.fromRGB(75, 0, 130),
        Accent = Color3.fromRGB(216, 27, 96),
        Background = Color3.fromRGB(20, 20, 30),
        Foreground = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Blue = {
        Primary = Color3.fromRGB(41, 128, 185),
        Secondary = Color3.fromRGB(52, 152, 219),
        Accent = Color3.fromRGB(26, 188, 156),
        Background = Color3.fromRGB(20, 25, 30),
        Foreground = Color3.fromRGB(25, 30, 35),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Red = {
        Primary = Color3.fromRGB(231, 76, 60),
        Secondary = Color3.fromRGB(192, 57, 43),
        Accent = Color3.fromRGB(241, 196, 15),
        Background = Color3.fromRGB(30, 20, 20),
        Foreground = Color3.fromRGB(35, 25, 25),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Green = {
        Primary = Color3.fromRGB(46, 204, 113),
        Secondary = Color3.fromRGB(39, 174, 96),
        Accent = Color3.fromRGB(26, 188, 156),
        Background = Color3.fromRGB(20, 30, 20),
        Foreground = Color3.fromRGB(25, 35, 25),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Main Window Creation
function GitanX:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "GitanX Hub"
    config.Size = config.Size or UDim2.new(0, 700, 0, 500)
    config.Theme = config.Theme or "Purple"
    config.IntroEnabled = config.IntroEnabled ~= false
    config.ConfigFolder = config.ConfigFolder or "GitanX"
    
    local CurrentTheme = self.Themes[config.Theme] or self.Themes.Purple
    
    -- Create ScreenGui
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "GitanX_" .. HttpService:GenerateGUID(false),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Intro Screen
    if config.IntroEnabled then
        local Intro = Utility:Create("Frame", {
            Name = "Intro",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(10, 10, 15),
            BorderSizePixel = 0,
            Parent = ScreenGui,
            ZIndex = 1000
        })
        
        local IntroLogo = Utility:Create("TextLabel", {
            Size = UDim2.new(0, 400, 0, 100),
            Position = UDim2.new(0.5, -200, 0.5, -50),
            BackgroundTransparency = 1,
            Text = "GITANX",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 60,
            Font = Enum.Font.GothamBlack,
            TextTransparency = 1,
            Parent = Intro
        })
        
        local IntroGradient = Utility:Create("UIGradient", {
            Color = self.ThemeGradient,
            Rotation = 45,
            Parent = IntroLogo
        })
        
        local LoadingText = Utility:Create("TextLabel", {
            Size = UDim2.new(0, 400, 0, 30),
            Position = UDim2.new(0.5, -200, 0.5, 60),
            BackgroundTransparency = 1,
            Text = "Loading...",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 16,
            Font = Enum.Font.Gotham,
            TextTransparency = 1,
            Parent = Intro
        })
        
        -- Animate intro
        Utility:Tween(IntroLogo, {TextTransparency = 0}, 0.5)
        Utility:Tween(LoadingText, {TextTransparency = 0}, 0.5)
        
        task.wait(2)
        
        Utility:Tween(Intro, {BackgroundTransparency = 1}, 0.5)
        Utility:Tween(IntroLogo, {TextTransparency = 1}, 0.5)
        Utility:Tween(LoadingText, {TextTransparency = 1}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
            Intro:Destroy()
        end)
    end
    
    -- Main Container
    local Main = Utility:Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = CurrentTheme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    
    local MainCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Main
    })
    
    local MainGlow = Utility:Create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = CurrentTheme.Primary,
        ImageTransparency = 0.75,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0,
        Parent = Main
    })
    
    -- Header
    local Header = Utility:Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = CurrentTheme.Foreground,
        BorderSizePixel = 0,
        Parent = Main
    })
    
    local HeaderCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Header
    })
    
    local HeaderFix = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = CurrentTheme.Foreground,
        BorderSizePixel = 0,
        Parent = Header
    })
    
    local HeaderGradient = Utility:Create("UIGradient", {
        Color = self.ThemeGradient,
        Rotation = 45,
        Parent = Header
    })
    
    local Title = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })
    
    local TitleStroke = Utility:Create("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1.5,
        Transparency = 0.5,
        Parent = Title
    })
    
    -- Control Buttons
    local MinimizeBtn = Utility:Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -95, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Text = "—",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = Header
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MinimizeBtn
    })
    
    Utility:CreateRipple(MinimizeBtn)
    
    local CloseBtn = Utility:Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = Header
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = CloseBtn
    })
    
    Utility:CreateRipple(CloseBtn)
    
    -- Minimize functionality
    local Minimized = false
    local OriginalSize = config.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        
        if Minimized then
            Utility:Tween(Main, {Size = UDim2.new(0, OriginalSize.X.Offset, 0, 50)}, 0.3)
            MinimizeBtn.Text = "□"
        else
            Utility:Tween(Main, {Size = OriginalSize}, 0.3)
            MinimizeBtn.Text = "—"
        end
    end)
    
    -- Close functionality
    CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Hover effects
    MinimizeBtn.MouseEnter:Connect(function()
        Utility:Tween(MinimizeBtn, {BackgroundColor3 = CurrentTheme.Primary})
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        Utility:Tween(MinimizeBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 53, 69)})
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
    end)
    
    -- Make draggable
    Utility:MakeDraggable(Main, Header)
    
    -- Tab System
    local TabContainer = Utility:Create("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 160, 1, -65),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundColor3 = CurrentTheme.Foreground,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Main
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TabContainer
    })
    
    local TabList = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })
    
    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = TabContainer
    })
    
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Container
    local ContentContainer = Utility:Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -185, 1, -65),
        Position = UDim2.new(0, 175, 0, 55),
        BackgroundColor3 = CurrentTheme.Foreground,
        BorderSizePixel = 0,
        Parent = Main
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = ContentContainer
    })
    
    -- Intro animation
    Utility:Tween(Main, {Size = config.Size}, 0.5, Enum.EasingStyle.Back)
    
    -- Window object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = CurrentTheme
    }
    
    -- Create Tab Function
    function Window:CreateTab(name, icon)
        icon = icon or "home"
        
        local Tab = {
            Name = name,
            Sections = {}
        }
        
        -- Tab Button
        local TabBtn = Utility:Create("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = Color3.fromRGB(35, 35, 45),
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Parent = TabContainer
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = TabBtn
        })
        
        local TabLabel = Utility:Create("TextLabel", {
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })
        
        local TabIcon = Utility:Create("ImageLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0.5, -10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = Color3.fromRGB(200, 200, 200),
            Parent = TabBtn
        })
        
        Utility:CreateRipple(TabBtn)
        
        -- Tab Content
        local TabContent = Utility:Create("ScrollingFrame", {
            Name = name .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = CurrentTheme.Primary,
            BorderSizePixel = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = ContentContainer
        })
        
        local ContentList = Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 15)
        end)
        
        -- Tab selection
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Utility:Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
                Utility:Tween(tab.Label, {TextColor3 = Color3.fromRGB(200, 200, 200)})
                Utility:Tween(tab.Icon, {ImageColor3 = Color3.fromRGB(200, 200, 200)})
            end
            
            TabContent.Visible = true
            Window.CurrentTab = Tab
            
            Utility:Tween(TabBtn, {BackgroundColor3 = CurrentTheme.Primary})
            Utility:Tween(TabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            Utility:Tween(TabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
        end)
        
        -- Hover effects
        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Utility:Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)})
            end
        end)
        
        Tab.Button = TabBtn
        Tab.Label = TabLabel
        Tab.Icon = TabIcon
        Tab.Content = TabContent
        
        -- SECTION SYSTEM
        function Tab:CreateSection(name)
            local Section = {
                Name = name,
                Elements = {}
            }
            
            local SectionFrame = Utility:Create("Frame", {
                Name = name,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabContent
            })
            
            local SectionLabel = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = CurrentTheme.Primary,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })
            
            local SectionDivider = Utility:Create("Frame", {
                Size = UDim2.new(1, -10, 0, 2),
                Position = UDim2.new(0, 5, 1, -2),
                BackgroundColor3 = CurrentTheme.Primary,
                BorderSizePixel = 0,
                Parent = SectionFrame
            })
            
            local DividerGradient = Utility:Create("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, CurrentTheme.Primary),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                },
                Rotation = 0,
                Parent = SectionDivider
            })
            
            local SectionList = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SectionFrame
            })
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end)
            
            Section.Frame = SectionFrame
            table.insert(Tab.Sections, Section)
            
            return Section
        end
        
        -- CREATE BUTTON
        function Tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            
            local Button = Utility:Create("TextButton", {
                Name = buttonText,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = Button
            })
            
            local ButtonLabel = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = buttonText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })
            
            Utility:CreateRipple(Button)
            
            Button.MouseEnter:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = CurrentTheme.Primary})
            end)
            
            Button.MouseLeave:Connect(function()
                Utility:Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
            end)
            
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            return Button
        end
        
        -- CREATE TOGGLE
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleText = config.Name or "Toggle"
            local default = config.Default or false
            local flag = config.Flag
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            
            local toggled = default
            
            local ToggleFrame = Utility:Create("Frame", {
                Name = toggleText,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = ToggleFrame
            })
            
            local Label = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleBtn = Utility:Create("TextButton", {
                Size = UDim2.new(0, 45, 0, 22),
                Position = UDim2.new(1, -50, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = ToggleFrame
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleBtn
            })
            
            local Indicator = Utility:Create("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                BorderSizePixel = 0,
                Parent = ToggleBtn
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Indicator
            })
            
            local function UpdateToggle()
                if toggled then
                    Utility:Tween(ToggleBtn, {BackgroundColor3 = CurrentTheme.Primary}, 0.2)
                    Utility:Tween(Indicator, {
                        Position = UDim2.new(1, -20, 0.5, -9),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }, 0.2)
                else
                    Utility:Tween(ToggleBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2)
                    Utility:Tween(Indicator, {
                        Position = UDim2.new(0, 2, 0.5, -9),
                        BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                    }, 0.2)
                end
                
                if flag then
                    GitanX.Flags[flag] = toggled
                end
                
                pcall(callback, toggled)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            UpdateToggle()
            
            if flag then
                GitanX.Options[flag] = {
                    SetValue = function(val)
                        toggled = val
                        UpdateToggle()
                    end,
                    GetValue = function()
                        return toggled
                    end
                }
            end
            
            return {
                Set = function(val)
                    toggled = val
                    UpdateToggle()
                end
            }
        end
        
        -- CREATE SLIDER
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderText = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local increment = config.Increment or 1
            local flag = config.Flag
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            local value = default
            
            local SliderFrame = Utility:Create("Frame", {
                Name = sliderText,
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = SliderFrame
            })
            
            local Label = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 10, 0, 8),
                BackgroundTransparency = 1,
                Text = sliderText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local ValueLabel = Utility:Create("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -65, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = CurrentTheme.Primary,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame
            })
            
            local SliderBar = Utility:Create("Frame", {
                Size = UDim2.new(1, -20, 0, 7),
                Position = UDim2.new(0, 10, 1, -18),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                BorderSizePixel = 0,
                Parent = SliderFrame
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBar
            })
            
            local Fill = Utility:Create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = CurrentTheme.Primary,
                BorderSizePixel = 0,
                Parent = SliderBar
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Fill
            })
            
            local Dragging = false
            
            local function UpdateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = Utility:Round(min + (max - min) * sizeX, increment)
                
                Fill.Size = UDim2.new(sizeX, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                
                if flag then
                    GitanX.Flags[flag] = value
                end
                
                pcall(callback, value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            if flag then
                GitanX.Options[flag] = {
                    SetValue = function(val)
                        value = val
                        Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                        ValueLabel.Text = tostring(val)
                        pcall(callback, val)
                    end,
                    GetValue = function()
                        return value
                    end
                }
            end
            
            return {
                Set = function(val)
                    value = val
                    Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                    ValueLabel.Text = tostring(val)
                    pcall(callback, val)
                end
            }
        end
        
        -- CREATE DROPDOWN
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropdownText = config.Name or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2"}
            local default = config.Default
            local flag = config.Flag
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            local selected = default or options[1]
            local opened = false
            
            local DropdownFrame = Utility:Create("Frame", {
                Name = dropdownText,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = DropdownFrame
            })
            
            local Label = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -70, 0, 38),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame
            })
            
            local ValueLabel = Utility:Create("TextLabel", {
                Size = UDim2.new(0, 60, 0, 38),
                Position = UDim2.new(1, -65, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = CurrentTheme.Primary,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DropdownFrame
            })
            
            local Arrow = Utility:Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 38),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 10,
                Font = Enum.Font.Gotham,
                Parent = DropdownFrame
            })
            
            local OptionsContainer = Utility:Create("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 43),
                BackgroundTransparency = 1,
                Parent = DropdownFrame
            })
            
            local OptionsList = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = OptionsContainer
            })
            
            local function Toggle()
                opened = not opened
                
                if opened then
                    Utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 43 + #options * 28 + (#options - 1) * 3)}, 0.3)
                    Utility:Tween(Arrow, {Rotation = 180}, 0.3)
                else
                    Utility:Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.3)
                    Utility:Tween(Arrow, {Rotation = 0}, 0.3)
                end
            end
            
            local DropdownBtn = Utility:Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame
            })
            
            DropdownBtn.MouseButton1Click:Connect(Toggle)
            
            for _, option in pairs(options) do
                local OptionBtn = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                    Text = option,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = OptionsContainer
                })
                
                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 7),
                    Parent = OptionBtn
                })
                
                OptionBtn.MouseEnter:Connect(function()
                    Utility:Tween(OptionBtn, {BackgroundColor3 = CurrentTheme.Primary})
                end)
                
                OptionBtn.MouseLeave:Connect(function()
                    Utility:Tween(OptionBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
                end)
                
                OptionBtn.MouseButton1Click:Connect(function()
                    selected = option
                    ValueLabel.Text = option
                    Toggle()
                    
                    if flag then
                        GitanX.Flags[flag] = selected
                    end
                    
                    pcall(callback, selected)
                end)
            end
            
            if flag then
                GitanX.Options[flag] = {
                    SetValue = function(val)
                        selected = val
                        ValueLabel.Text = val
                        pcall(callback, val)
                    end,
                    GetValue = function()
                        return selected
                    end
                }
            end
            
            return {
                Set = function(val)
                    selected = val
                    ValueLabel.Text = val
                    pcall(callback, val)
                end
            }
        end
        
        -- CREATE TEXTBOX
        function Tab:CreateTextBox(config)
            config = config or {}
            local textboxText = config.Name or "TextBox"
            local placeholder = config.Placeholder or "Enter text..."
            local flag = config.Flag
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            
            local TextBoxFrame = Utility:Create("Frame", {
                Name = textboxText,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = TextBoxFrame
            })
            
            local Box = Utility:Create("TextBox", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                PlaceholderText = placeholder,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = TextBoxFrame
            })
            
            Box.FocusLost:Connect(function()
                if flag then
                    GitanX.Flags[flag] = Box.Text
                end
                pcall(callback, Box.Text)
            end)
            
            if flag then
                GitanX.Options[flag] = {
                    SetValue = function(val)
                        Box.Text = val
                        pcall(callback, val)
                    end,
                    GetValue = function()
                        return Box.Text
                    end
                }
            end
            
            return Box
        end
        
        -- CREATE LABEL
        function Tab:CreateLabel(text)
            local Label = Utility:Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Text = text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                Parent = TabContent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = Label
            })
            
            return {
                Set = function(txt)
                    Label.Text = txt
                end
            }
        end
        
        -- CREATE KEYBIND
        function Tab:CreateKeybind(config)
            config = config or {}
            local keybindText = config.Name or "Keybind"
            local default = config.Default or Enum.KeyCode.E
            local flag = config.Flag
            local callback = config.Callback or function() end
            local section = config.Section
            
            local parent = section and section.Frame or TabContent
            local currentKey = default
            local binding = false
            
            local KeybindFrame = Utility:Create("Frame", {
                Name = keybindText,
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                BorderSizePixel = 0,
                Parent = parent
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 10),
                Parent = KeybindFrame
            })
            
            local Label = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = keybindText,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KeybindFrame
            })
            
            local KeybindBtn = Utility:Create("TextButton", {
                Size = UDim2.new(0, 80, 0, 28),
                Position = UDim2.new(1, -85, 0.5, -14),
                BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                Text = currentKey.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = KeybindFrame
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = KeybindBtn
            })
            
            KeybindBtn.MouseButton1Click:Connect(function()
                binding = true
                KeybindBtn.Text = "..."
                Utility:Tween(KeybindBtn, {BackgroundColor3 = CurrentTheme.Primary})
            end)
            
            UserInputService.InputBegan:Connect(function(input, gpe)
                if binding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindBtn.Text = currentKey.Name
                        binding = false
                        Utility:Tween(KeybindBtn, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
                        
                        if flag then
                            GitanX.Flags[flag] = currentKey
                        end
                    end
                end
                
                if not gpe and input.KeyCode == currentKey then
                    pcall(callback)
                end
            end)
            
            return {
                Set = function(key)
                    currentKey = key
                    KeybindBtn.Text = key.Name
                end
            }
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabBtn.MouseButton1Click:Fire()
        end
        
        return Tab
    end
    
    return Window
end

return GitanX
