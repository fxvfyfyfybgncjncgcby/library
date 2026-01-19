--[[
   _____ _ _          __   __
  / ____(_) |         \ \ / /
 | |  __ _| |_ __ _ _ _\ V / 
 | | |_ | | __/ _` | '_ \> <  
 | |__| | | || (_| | | | > <  
  \_____|_|\__\__,_|_| |_/_/\_\
  
  GitanX UI Library v1.0
  Une bibliothèque UI moderne et performante
  Créée par GitanX Team
]]

local GitanX = {
    Options = {},
    Flags = {},
    Folder = "GitanX",
    ThemeColor = Color3.fromRGB(138, 43, 226) -- Violet par défaut
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- Utilitaires
local function Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragFrame = dragFrame or frame
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

-- Création de la GUI principale
function GitanX:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "GitanX UI"
    config.Size = config.Size or UDim2.new(0, 550, 0, 400)
    config.Theme = config.Theme or self.ThemeColor
    
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }
    
    -- Container principal
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "GitanXUI",
        Parent = gethui and gethui() or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local MainFrame = CreateInstance("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = config.Size,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    })
    
    CreateInstance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Ombre
    CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 30, 1, 30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 0
    })
    
    -- Barre de titre
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0
    })
    
    CreateInstance("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold
    })
    
    -- Boutons de contrôle
    local CloseButton = CreateInstance("TextButton", {
        Name = "Close",
        Parent = TitleBar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })
    
    CreateInstance("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "Minimize",
        Parent = TitleBar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -50, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    CreateInstance("UICorner", {
        Parent = MinimizeButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Navigation des onglets
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0
    })
    
    local TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    CreateInstance("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Container de contenu
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0
    })
    
    -- Fonctionnalités de la fenêtre
    MakeDraggable(MainFrame, TitleBar)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 200, 0, 40)})
            MinimizeButton.Text = "□"
        else
            Tween(MainFrame, {Size = config.Size})
            MinimizeButton.Text = "─"
        end
    end)
    
    -- Fonction pour créer un onglet
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        tabConfig.Name = tabConfig.Name or "Tab"
        tabConfig.Icon = tabConfig.Icon or "📄"
        
        local Tab = {
            Elements = {}
        }
        
        -- Bouton d'onglet
        local TabButton = CreateInstance("TextButton", {
            Name = tabConfig.Name,
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false
        })
        
        CreateInstance("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        local TabIcon = CreateInstance("TextLabel", {
            Name = "Icon",
            Parent = TabButton,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0, 20, 1, 0),
            BackgroundTransparency = 1,
            Text = tabConfig.Icon,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 16
        })
        
        local TabTitle = CreateInstance("TextLabel", {
            Name = "Title",
            Parent = TabButton,
            Position = UDim2.new(0, 35, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            BackgroundTransparency = 1,
            Text = tabConfig.Name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham
        })
        
        -- Contenu de l'onglet
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = tabConfig.Name .. "Content",
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        
        CreateInstance("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        CreateInstance("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        -- Fonction d'activation de l'onglet
        local function ActivateTab()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                otherTab.Icon.TextColor3 = Color3.fromRGB(200, 200, 200)
                otherTab.Title.TextColor3 = Color3.fromRGB(200, 200, 200)
                otherTab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = config.Theme
            TabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(ActivateTab)
        
        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Title = TabTitle
        Tab.Content = TabContent
        
        -- ÉLÉMENTS DE L'ONGLET
        
        -- Bouton
        function Tab:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}
            buttonConfig.Name = buttonConfig.Name or "Button"
            buttonConfig.Callback = buttonConfig.Callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Name = buttonConfig.Name,
                Parent = TabContent,
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })
            
            CreateInstance("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 6)
            })
            
            local ButtonText = CreateInstance("TextLabel", {
                Parent = Button,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = buttonConfig.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
            end)
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = config.Theme}, 0.1)
                task.wait(0.1)
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.1)
                pcall(buttonConfig.Callback)
            end)
            
            return Button
        end
        
        -- Toggle
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            toggleConfig.Name = toggleConfig.Name or "Toggle"
            toggleConfig.Default = toggleConfig.Default or false
            toggleConfig.Callback = toggleConfig.Callback or function() end
            
            local toggled = toggleConfig.Default
            
            local Toggle = CreateInstance("Frame", {
                Name = toggleConfig.Name,
                Parent = TabContent,
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0
            })
            
            CreateInstance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 6)
            })
            
            local ToggleText = CreateInstance("TextLabel", {
                Parent = Toggle,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleConfig.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            local ToggleButton = CreateInstance("TextButton", {
                Parent = Toggle,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20),
                BackgroundColor3 = toggled and config.Theme or Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Text = ""
            })
            
            CreateInstance("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(1, 0)
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                Parent = ToggleButton,
                Size = UDim2.new(0, 16, 0, 16),
                Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            })
            
            CreateInstance("UICorner", {
                Parent = ToggleIndicator,
                CornerRadius = UDim.new(1, 0)
            })
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Tween(ToggleButton, {
                    BackgroundColor3 = toggled and config.Theme or Color3.fromRGB(60, 60, 60)
                })
                
                Tween(ToggleIndicator, {
                    Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                })
                
                pcall(toggleConfig.Callback, toggled)
            end)
            
            return {
                SetValue = function(self, value)
                    toggled = value
                    Tween(ToggleButton, {
                        BackgroundColor3 = toggled and config.Theme or Color3.fromRGB(60, 60, 60)
                    })
                    Tween(ToggleIndicator, {
                        Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    })
                end
            }
        end
        
        -- Slider
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            sliderConfig.Name = sliderConfig.Name or "Slider"
            sliderConfig.Min = sliderConfig.Min or 0
            sliderConfig.Max = sliderConfig.Max or 100
            sliderConfig.Default = sliderConfig.Default or 50
            sliderConfig.Callback = sliderConfig.Callback or function() end
            
            local value = sliderConfig.Default
            
            local Slider = CreateInstance("Frame", {
                Name = sliderConfig.Name,
                Parent = TabContent,
                Size = UDim2.new(1, -10, 0, 50),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0
            })
            
            CreateInstance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })
            
            local SliderText = CreateInstance("TextLabel", {
                Parent = Slider,
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = sliderConfig.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            local SliderValue = CreateInstance("TextLabel", {
                Parent = Slider,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = config.Theme,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Font = Enum.Font.GothamBold
            })
            
            local SliderBar = CreateInstance("Frame", {
                Parent = Slider,
                Position = UDim2.new(0, 10, 1, -15),
                Size = UDim2.new(1, -20, 0, 6),
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0
            })
            
            CreateInstance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            local SliderFill = CreateInstance("Frame", {
                Parent = SliderBar,
                Size = UDim2.new((value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min), 0, 1, 0),
                BackgroundColor3 = config.Theme,
                BorderSizePixel = 0
            })
            
            CreateInstance("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(1, 0)
            })
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percentage)
                    
                    SliderValue.Text = tostring(value)
                    Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                    
                    pcall(sliderConfig.Callback, value)
                end
            end)
            
            return {
                SetValue = function(self, newValue)
                    value = math.clamp(newValue, sliderConfig.Min, sliderConfig.Max)
                    local percentage = (value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    SliderValue.Text = tostring(value)
                    Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)})
                end
            }
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local Label = CreateInstance("TextLabel", {
                Parent = TabContent,
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundTransparency = 1,
                Text = text or "Label",
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham
            })
            
            return {
                SetText = function(self, newText)
                    Label.Text = newText
                end
            }
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            ActivateTab()
        end
        
        return Tab
    end
    
    -- Notification système
    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        notifConfig.Title = notifConfig.Title or "Notification"
        notifConfig.Content = notifConfig.Content or ""
        notifConfig.Duration = notifConfig.Duration or 3
        
        local Notification = CreateInstance("Frame", {
            Parent = ScreenGui,
            Position = UDim2.new(1, -320, 1, 100),
            Size = UDim2.new(0, 300, 0, 80),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0
        })
        
        CreateInstance("UICorner", {
            Parent = Notification,
            CornerRadius = UDim.new(0, 8)
        })
        
        local NotifTitle = CreateInstance("TextLabel", {
            Parent = Notification,
            Position = UDim2.new(0, 15, 0, 10),
            Size = UDim2.new(1, -30, 0, 20),
            BackgroundTransparency = 1,
            Text = notifConfig.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.GothamBold
        })
        
        local NotifContent = CreateInstance("TextLabel", {
            Parent = Notification,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 1, -45),
            BackgroundTransparency = 1,
            Text = notifConfig.Content,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Font = Enum.Font.Gotham
        })
        
        Tween(Notification, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back)
        
        task.delay(notifConfig.Duration, function()
            Tween(Notification, {Position = UDim2.new(1, -320, 1, 100)}, 0.3)
            task.wait(0.3)
            Notification:Destroy()
        end)
    end
    
    return Window
end

return GitanX
