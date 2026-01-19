--[[

 ██████╗ ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
██╔════╝ ██║╚══██╔══╝██╔══██╗████╗  ██║╚██╗██╔╝
██║  ███╗██║   ██║   ███████║██╔██╗ ██║ ╚███╔╝ 
██║   ██║██║   ██║   ██╔══██║██║╚██╗██║ ██╔██╗ 
╚██████╔╝██║   ██║   ██║  ██║██║ ╚████║██╔╝ ██╗
 ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                
         UI LIBRARY - Version 1.0
    Par les créateurs de GitanX
    
]]

local GitanX = {
    Folder = "GitanX",
    Options = {},
    ThemeGradient = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 65, 108)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 75, 43)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 158, 36))
    }
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Utilitaires
local function MakeDraggable(frame)
    local dragToggle, dragInput, dragStart, startPos
    
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
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.15), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

local function CreateRainbowEffect(element)
    task.spawn(function()
        while element and element.Parent do
            for i = 0, 1, 0.01 do
                if not element or not element.Parent then break end
                pcall(function()
                    element.ImageColor3 = Color3.fromHSV(i, 1, 1)
                end)
                wait(0.03)
            end
        end
    end)
end

-- Fonctions principales
function GitanX:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "GitanX UI"
    local IntroEnabled = config.IntroEnabled ~= false
    local IntroText = config.IntroText or "Chargement..."
    
    local GitanXUI = {}
    
    -- Suppression de l'ancien GUI
    if CoreGui:FindFirstChild("GitanXUI") then
        CoreGui:FindFirstChild("GitanXUI"):Destroy()
    end
    
    -- Création du ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GitanXUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Intro
    if IntroEnabled then
        local IntroFrame = Instance.new("Frame")
        IntroFrame.Size = UDim2.new(1, 0, 1, 0)
        IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        IntroFrame.BorderSizePixel = 0
        IntroFrame.ZIndex = 1000
        IntroFrame.Parent = ScreenGui
        
        local IntroLogo = Instance.new("TextLabel")
        IntroLogo.Size = UDim2.new(0, 400, 0, 100)
        IntroLogo.Position = UDim2.new(0.5, -200, 0.4, -50)
        IntroLogo.BackgroundTransparency = 1
        IntroLogo.Text = "GITANX"
        IntroLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
        IntroLogo.TextSize = 60
        IntroLogo.Font = Enum.Font.GothamBold
        IntroLogo.TextTransparency = 1
        IntroLogo.Parent = IntroFrame
        
        local IntroDesc = Instance.new("TextLabel")
        IntroDesc.Size = UDim2.new(0, 400, 0, 30)
        IntroDesc.Position = UDim2.new(0.5, -200, 0.5, 20)
        IntroDesc.BackgroundTransparency = 1
        IntroDesc.Text = IntroText
        IntroDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
        IntroDesc.TextSize = 18
        IntroDesc.Font = Enum.Font.Gotham
        IntroDesc.TextTransparency = 1
        IntroDesc.Parent = IntroFrame
        
        -- Animation intro
        TweenService:Create(IntroLogo, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        wait(0.2)
        TweenService:Create(IntroDesc, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
        wait(1.5)
        
        TweenService:Create(IntroFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(IntroLogo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(IntroDesc, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.5)
        IntroFrame:Destroy()
    end
    
    -- Frame principale
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Ombre
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = MainFrame
    
    -- TopBar avec gradient
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local GradientBar = Instance.new("Frame")
    GradientBar.Name = "GradientBar"
    GradientBar.Size = UDim2.new(1, 0, 0, 3)
    GradientBar.Position = UDim2.new(0, 0, 1, -3)
    GradientBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GradientBar.BorderSizePixel = 0
    GradientBar.Parent = TopBar
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = GitanX.ThemeGradient
    Gradient.Rotation = 45
    Gradient.Parent = GradientBar
    
    -- Animation du gradient
    task.spawn(function()
        while GradientBar.Parent do
            Gradient.Rotation = Gradient.Rotation + 1
            if Gradient.Rotation >= 360 then
                Gradient.Rotation = 0
            end
            wait(0.05)
        end
    end)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Bouton fermer
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 65, 108)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Container pour les pages
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -160, 1, -60)
    PageContainer.Position = UDim2.new(0, 155, 0, 55)
    PageContainer.BackgroundTransparency = 1
    PageContainer.BorderSizePixel = 0
    PageContainer.Parent = MainFrame
    
    MakeDraggable(TopBar)
    
    -- Animation d'apparition
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 650, 0, 450)}):Play()
    
    function GitanXUI:CreateTab(tabName)
        local TabUI = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName.."Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 6
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 65, 108)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.Parent = PageContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(PageContainer:GetChildren()) do
                page.Visible = false
            end
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()
                end
            end
            
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 65, 108),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Page.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Page.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
            end
        end)
        
        if #TabContainer:GetChildren() == 2 then
            TabButton.MouseButton1Click:Fire()
        end
        
        function TabUI:AddButton(config)
            local ButtonText = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = ButtonText
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Button.Text = ButtonText
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.BorderSizePixel = 0
            Button.Parent = Page
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -15, 0, 35)}):Play()
                wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                Callback()
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 65, 108)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            end)
            
            return Button
        end
        
        function TabUI:AddToggle(config)
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = ToggleName
            ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Page
            
            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 8)
            TogCorner.Parent = ToggleFrame
            
            local TogLabel = Instance.new("TextLabel")
            TogLabel.Size = UDim2.new(1, -60, 1, 0)
            TogLabel.Position = UDim2.new(0, 15, 0, 0)
            TogLabel.BackgroundTransparency = 1
            TogLabel.Text = ToggleName
            TogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TogLabel.TextSize = 14
            TogLabel.Font = Enum.Font.Gotham
            TogLabel.TextXAlignment = Enum.TextXAlignment.Left
            TogLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local TogBtnCorner = Instance.new("UICorner")
            TogBtnCorner.CornerRadius = UDim.new(1, 0)
            TogBtnCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = Default
            
            if Default then
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 65, 108)
                ToggleCircle.Position = UDim2.new(1, -20, 0.5, -9)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 65, 108)}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
                end
                
                Callback(toggled)
            end)
            
            return {
                SetValue = function(value)
                    toggled = value
                    if value then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 65, 108)}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
                    end
                end
            }
        end
        
        function TabUI:AddSlider(config)
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = SliderName
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = Page
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = SliderName
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 0, 20)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(Default)
            SliderValue.TextColor3 = Color3.fromRGB(255, 65, 108)
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 8)
            SliderBar.Position = UDim2.new(0, 10, 1, -18)
            SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(255, 65, 108)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(Min + (Max - Min) * pos)
                    
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(value)
                    Callback(value)
                end
            end)
            
            return {
                SetValue = function(value)
                    value = math.clamp(value, Min, Max)
                    local pos = (value - Min) / (Max - Min)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(value)
                    Callback(value)
                end
            }
        end
        
        function TabUI:AddDropdown(config)
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = DropdownName
            DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = Page
            DropdownFrame.ClipsDescendants = true
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = DropdownFrame
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(1, -60, 0, 40)
            DropLabel.Position = UDim2.new(0, 15, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = DropdownName
            DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropLabel.TextSize = 14
            DropLabel.Font = Enum.Font.Gotham
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Parent = DropdownFrame
            
            local DropValue = Instance.new("TextLabel")
            DropValue.Size = UDim2.new(0, 100, 0, 40)
            DropValue.Position = UDim2.new(1, -140, 0, 0)
            DropValue.BackgroundTransparency = 1
            DropValue.Text = Default
            DropValue.TextColor3 = Color3.fromRGB(255, 65, 108)
            DropValue.TextSize = 13
            DropValue.Font = Enum.Font.GothamBold
            DropValue.TextXAlignment = Enum.TextXAlignment.Right
            DropValue.Parent = DropdownFrame
            
            local DropButton = Instance.new("TextButton")
            DropButton.Size = UDim2.new(0, 30, 0, 30)
            DropButton.Position = UDim2.new(1, -40, 0, 5)
            DropButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            DropButton.Text = "▼"
            DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropButton.TextSize = 12
            DropButton.Font = Enum.Font.GothamBold
            DropButton.BorderSizePixel = 0
            DropButton.Parent = DropdownFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = DropButton
            
            local OptionList = Instance.new("Frame")
            OptionList.Name = "OptionList"
            OptionList.Size = UDim2.new(1, -20, 0, 0)
            OptionList.Position = UDim2.new(0, 10, 0, 45)
            OptionList.BackgroundTransparency = 1
            OptionList.Parent = DropdownFrame
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)
            ListLayout.Parent = OptionList
            
            local expanded = false
            
            for _, option in ipairs(Options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = OptionList
                
                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 6)
                OptCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropValue.Text = option
                    Callback(option)
                    
                    expanded = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    TweenService:Create(DropButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 65, 108)}):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
                end)
            end
            
            DropButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local contentHeight = #Options * 33 + 45
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, contentHeight)}):Play()
                    TweenService:Create(DropButton, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    TweenService:Create(DropButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end
            end)
            
            return {
                SetValue = function(value)
                    DropValue.Text = value
                    Callback(value)
                end
            }
        end
        
        function TabUI:AddTextbox(config)
            local TextboxName = config.Name or "Textbox"
            local Default = config.Default or ""
            local PlaceholderText = config.PlaceholderText or "Entrez du texte..."
            local Callback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = TextboxName
            TextboxFrame.Size = UDim2.new(1, -10, 0, 70)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = Page
            
            local TextCorner = Instance.new("UICorner")
            TextCorner.CornerRadius = UDim.new(0, 8)
            TextCorner.Parent = TextboxFrame
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Size = UDim2.new(1, -20, 0, 25)
            TextLabel.Position = UDim2.new(0, 10, 0, 5)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = TextboxName
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 14
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Parent = TextboxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -20, 0, 30)
            TextBox.Position = UDim2.new(0, 10, 0, 32)
            TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            TextBox.Text = Default
            TextBox.PlaceholderText = PlaceholderText
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
            TextBox.TextSize = 13
            TextBox.Font = Enum.Font.Gotham
            TextBox.BorderSizePixel = 0
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = TextboxFrame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = TextBox
            
            TextBox.Focused:Connect(function()
                TweenService:Create(TextBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 65, 108)}):Play()
            end)
            
            TextBox.FocusLost:Connect(function(enter)
                TweenService:Create(TextBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
                if enter then
                    Callback(TextBox.Text)
                end
            end)
            
            return {
                SetValue = function(text)
                    TextBox.Text = text
                end
            }
        end
        
        function TabUI:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 30)
            Label.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BorderSizePixel = 0
            Label.Parent = Page
            
            local LabelPadding = Instance.new("UIPadding")
            LabelPadding.PaddingLeft = UDim.new(0, 15)
            LabelPadding.Parent = Label
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            return {
                SetText = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        function TabUI:AddParagraph(title, content)
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Size = UDim2.new(1, -10, 0, 80)
            ParagraphFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ParagraphFrame.BorderSizePixel = 0
            ParagraphFrame.Parent = Page
            
            local ParaCorner = Instance.new("UICorner")
            ParaCorner.CornerRadius = UDim.new(0, 8)
            ParaCorner.Parent = ParagraphFrame
            
            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 0, 25)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Text = title
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.Font = Enum.Font.GothamBold
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = ParagraphFrame
            
            local Content = Instance.new("TextLabel")
            Content.Size = UDim2.new(1, -20, 1, -30)
            Content.Position = UDim2.new(0, 10, 0, 30)
            Content.BackgroundTransparency = 1
            Content.Text = content
            Content.TextColor3 = Color3.fromRGB(180, 180, 180)
            Content.TextSize = 13
            Content.Font = Enum.Font.Gotham
            Content.TextXAlignment = Enum.TextXAlignment.Left
            Content.TextYAlignment = Enum.TextYAlignment.Top
            Content.TextWrapped = true
            Content.Parent = ParagraphFrame
            
            return {
                SetTitle = function(newTitle)
                    Title.Text = newTitle
                end,
                SetContent = function(newContent)
                    Content.Text = newContent
                end
            }
        end
        
        return TabUI
    end
    
    function GitanXUI:CreateNotification(config)
        local Title = config.Title or "Notification"
        local Content = config.Content or "Contenu de la notification"
        local Duration = config.Duration or 3
        
        local NotifContainer = ScreenGui:FindFirstChild("NotifContainer")
        if not NotifContainer then
            NotifContainer = Instance.new("Frame")
            NotifContainer.Name = "NotifContainer"
            NotifContainer.Size = UDim2.new(0, 300, 1, 0)
            NotifContainer.Position = UDim2.new(1, -310, 0, 10)
            NotifContainer.BackgroundTransparency = 1
            NotifContainer.Parent = ScreenGui
            
            local NotifLayout = Instance.new("UIListLayout")
            NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
            NotifLayout.Padding = UDim.new(0, 10)
            NotifLayout.Parent = NotifContainer
        end
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(1, 0, 0, 0)
        Notif.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Notif.BorderSizePixel = 0
        Notif.Parent = NotifContainer
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = Notif
        
        local NotifGradient = Instance.new("Frame")
        NotifGradient.Size = UDim2.new(1, 0, 0, 3)
        NotifGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifGradient.BorderSizePixel = 0
        NotifGradient.Parent = Notif
        
        local NGradient = Instance.new("UIGradient")
        NGradient.Color = GitanX.ThemeGradient
        NGradient.Rotation = 45
        NGradient.Parent = NotifGradient
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Position = UDim2.new(0, 10, 0, 8)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = Title
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 15
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = Notif
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 0, 40)
        NotifContent.Position = UDim2.new(0, 10, 0, 30)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = Content
        NotifContent.TextColor3 = Color3.fromRGB(180, 180, 180)
        NotifContent.TextSize = 13
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        NotifContent.Parent = Notif
        
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 75)}):Play()
        
        task.wait(Duration)
        
        TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.3)
        Notif:Destroy()
    end
    
    return GitanXUI
end

return GitanX
