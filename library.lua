local GitanX = {}
GitanX.__index = GitanX
GitanX.Version = "1.0.0"

-- ==================== CONFIGURATION ====================
local THEME = {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(30, 30, 45),
    Primary = Color3.fromRGB(80, 120, 255),
    Accent = Color3.fromRGB(255, 80, 120),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(100, 200, 100),
    Warning = Color3.fromRGB(255, 180, 80),
    Error = Color3.fromRGB(255, 100, 100),
}

local CONFIG = {
    CornerRadius = 8,
    AnimSpeed = 0.25,
    Padding = 10,
    ElementHeight = 35,
    WindowMinWidth = 300,
    WindowMinHeight = 200,
}

-- ==================== UTILITIES ====================
local function Create(className, properties)
    local obj = Instance.new(className)
    for k, v in pairs(properties or {}) do
        if k == "Parent" then continue end
        pcall(function() obj[k] = v end)
    end
    if properties and properties.Parent then
        obj.Parent = properties.Parent
    end
    return obj
end

local function Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(
        duration or CONFIG.AnimSpeed,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = game:GetService("TweenService"):Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function RoundCorner(obj, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or CONFIG.CornerRadius),
        Parent = obj
    })
end

local function AddPadding(obj, left, top, right, bottom)
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, left or CONFIG.Padding),
        PaddingTop = UDim.new(0, top or CONFIG.Padding),
        PaddingRight = UDim.new(0, right or CONFIG.Padding),
        PaddingBottom = UDim.new(0, bottom or CONFIG.Padding),
        Parent = obj
    })
end

local function AddStroke(obj, color, thickness)
    Create("UIStroke", {
        Color = color or THEME.Primary,
        Thickness = thickness or 1,
        Parent = obj
    })
end

-- ==================== NOTIFICATION SYSTEM ====================
local NotificationQueue = {}

local function ShowNotification(title, message, duration, notifType)
    local notifType = notifType or "info"
    local color = THEME.Primary
    
    if notifType == "success" then color = THEME.Success
    elseif notifType == "warning" then color = THEME.Warning
    elseif notifType == "error" then color = THEME.Error end
    
    local notif = Create("Frame", {
        Size = UDim2.new(0, 350, 0, 80),
        Position = UDim2.new(1, -370, 0, 20 + (#NotificationQueue * 100)),
        BackgroundColor3 = THEME.Secondary,
        BorderSizePixel = 0,
    })
    
    RoundCorner(notif, 10)
    AddStroke(notif, color, 2)
    
    Create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = notif
    })
    RoundCorner(notif:FindFirstChild("Frame"), 10)
    
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Text = title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        TextColor3 = THEME.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = message,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    table.insert(NotificationQueue, notif)
    
    wait(duration or 3)
    Tween(notif, {Position = UDim2.new(1, -370, 0, -100)}, 0.3)
    wait(0.3)
    notif:Destroy()
    table.remove(NotificationQueue, table.find(NotificationQueue, notif))
end

-- ==================== MAIN CLASSES ====================

-- WINDOW CLASS
local Window = {}
Window.__index = Window

function Window:new(title, size, position)
    local self = setmetatable({}, Window)
    
    self.Title = title
    self.Tabs = {}
    self.CurrentTab = nil
    self.Elements = {}
    self.Size = size or UDim2.new(0, 500, 0, 600)
    self.Position = position or UDim2.new(0.5, -250, 0.5, -300)
    
    self:_BuildUI()
    
    return self
end

function Window:_BuildUI()
    -- Main Frame
    self.MainFrame = Create("Frame", {
        Name = "GitanX_Window_" .. self.Title,
        Size = self.Size,
        Position = self.Position,
        BackgroundColor3 = THEME.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
    })
    
    RoundCorner(self.MainFrame, 12)
    AddStroke(self.MainFrame, THEME.Primary, 2)
    
    -- Header
    local header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = THEME.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    RoundCorner(header, 12)
    
    -- Title
    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    AddPadding(header, 15, 0, 0, 0)
    
    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -45, 0.5, -17.5),
        BackgroundColor3 = THEME.Error,
        TextColor3 = THEME.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Text = "✕",
        BorderSizePixel = 0,
        Parent = header
    })
    RoundCorner(closeBtn, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {Size = UDim2.new(0, self.Size.X.Offset, 0, 0)}, 0.2)
        wait(0.2)
        self.MainFrame:Destroy()
    end)
    
    -- Tab Bar
    self.TabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 45),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = THEME.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabBar
    })
    AddPadding(self.TabBar, 10, 5, 10, 5)
    
    -- Content Container
    self.ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, -95),
        Position = UDim2.new(0, 0, 0, 95),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    -- Scroll Frame
    self.ScrollFrame = Create("ScrollingFrame", {
        Name = "ScrollFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = THEME.Primary,
        Parent = self.ContentContainer
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.ScrollFrame
    })
    AddPadding(self.ScrollFrame, 12, 12, 12, 12)
    
    -- Auto-size scroll
    self.ScrollFrame.ChildAdded:Connect(function()
        self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, self.ScrollFrame.UIListLayout.AbsoluteContentSize.Y + 24)
    end)
end

function Window:AddTab(tabName, icon)
    local tab = {
        Name = tabName,
        Icon = icon or "📋",
        Elements = {},
        Visible = false
    }
    
    -- Tab Button
    local tabBtn = Create("TextButton", {
        Name = tabName .. "_Button",
        Size = UDim2.new(0, 100, 1, -10),
        BackgroundColor3 = THEME.Secondary,
        TextColor3 = THEME.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = tab.Icon .. " " .. tabName,
        BorderSizePixel = 0,
        Parent = self.TabBar
    })
    RoundCorner(tabBtn, 6)
    AddStroke(tabBtn, THEME.Primary, 1)
    
    -- Tab Content
    local tabContent = Create("Frame", {
        Name = tabName .. "_Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ScrollFrame
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabContent
    })
    
    tab.Button = tabBtn
    tab.Content = tabContent
    
    tabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Content.Visible = false
            Tween(self.CurrentTab.Button, {BackgroundColor3 = THEME.Secondary, TextColor3 = THEME.TextSecondary}, 0.2)
        end
        
        self.CurrentTab = tab
        tab.Content.Visible = true
        Tween(tabBtn, {BackgroundColor3 = THEME.Primary, TextColor3 = THEME.Text}, 0.2)
    end)
    
    if not self.CurrentTab then
        tabBtn:Fire()
    end
    
    table.insert(self.Tabs, tab)
    return tab
end

function Window:AddButton(tabIndex, label, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local button = Create("TextButton", {
        Name = label,
        Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight),
        BackgroundColor3 = THEME.Primary,
        TextColor3 = THEME.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Text = (icon or "▶") .. " " .. label,
        BorderSizePixel = 0,
        Parent = tab.Content
    })
    
    RoundCorner(button, 6)
    
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = THEME.Accent}, 0.15)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = THEME.Primary}, 0.15)
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    table.insert(tab.Elements, button)
    return button
end

function Window:AddToggle(tabIndex, label, default, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local container = Create("Frame", {
        Name = label .. "_Toggle",
        Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Text = (icon or "⚙") .. " " .. label,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    AddPadding(container, 10, 0, 0, 0)
    
    local toggleBg = Create("Frame", {
        Name = "ToggleBG",
        Size = UDim2.new(0, 50, 0, 24),
        Position = UDim2.new(1, -60, 0.5, -12),
        BackgroundColor3 = default and THEME.Primary or THEME.Secondary,
        BorderSizePixel = 0,
        Parent = container
    })
    RoundCorner(toggleBg, 12)
    AddStroke(toggleBg, THEME.Primary, 1)
    
    local toggleCircle = Create("Frame", {
        Name = "Circle",
        Size = UDim2.new(0, 20, 0, 20),
        Position = default and UDim2.new(0, 28, 0, 2) or UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = THEME.Text,
        BorderSizePixel = 0,
        Parent = toggleBg
    })
    RoundCorner(toggleCircle, 10)
    
    local state = default
    
    local function updateToggle(newState)
        state = newState
        Tween(toggleBg, {BackgroundColor3 = state and THEME.Primary or THEME.Secondary}, 0.2)
        Tween(toggleCircle, {Position = state and UDim2.new(0, 28, 0, 2) or UDim2.new(0, 2, 0, 2)}, 0.2)
        callback(state)
    end
    
    toggleBg.MouseButton1Click:Connect(function()
        updateToggle(not state)
    end)
    
    table.insert(tab.Elements, container)
    
    return {
        Toggle = toggleBg,
        GetState = function() return state end,
        SetState = updateToggle
    }
end

function Window:AddSlider(tabIndex, label, min, max, default, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local container = Create("Frame", {
        Name = label .. "_Slider",
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })
    
    local labelText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Text = (icon or "📊") .. " " .. label,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    AddPadding(labelText, 10, 0, 0, 0)
    
    local valueLbl = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -55, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })
    
    local sliderBg = Create("Frame", {
        Name = "SliderBG",
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = THEME.Secondary,
        BorderSizePixel = 0,
        Parent = container
    })
    RoundCorner(sliderBg, 4)
    AddStroke(sliderBg, THEME.Primary, 1)
    
    local sliderFill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = THEME.Primary,
        BorderSizePixel = 0,
        Parent = sliderBg
    })
    RoundCorner(sliderFill, 4)
    
    local value = default
    
    local function updateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percentage = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        valueLbl.Text = tostring(math.floor(value))
        callback(value)
    end
    
    sliderBg.MouseButton1Down:Connect(function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        
        local function onMouseMove()
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local mousePos = math.clamp(mouse.X - sliderPos, 0, sliderSize)
            local percentage = mousePos / sliderSize
            updateSlider(min + percentage * (max - min))
        end
        
        local connection = mouse.Move:Connect(onMouseMove)
        
        local function onMouseUp()
            connection:Disconnect()
        end
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                onMouseUp()
            end
        end)
    end)
    
    table.insert(tab.Elements, container)
    
    return {
        Slider = sliderBg,
        GetValue = function() return value end,
        SetValue = updateSlider
    }
end

function Window:AddTextBox(tabIndex, label, placeholder, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local container = Create("Frame", {
        Name = label .. "_TextBox",
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Text = (icon or "✏") .. " " .. label,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    AddPadding(container, 10, 0, 0, 0)
    
    local textbox = Create("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = THEME.Secondary,
        TextColor3 = THEME.Text,
        PlaceholderColor3 = THEME.TextSecondary,
        PlaceholderText = placeholder,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        Parent = container
    })
    RoundCorner(textbox, 6)
    AddStroke(textbox, THEME.Primary, 1)
    AddPadding(textbox, 8, 0, 8, 0)
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
            textbox.Text = ""
        end
    end)
    
    table.insert(tab.Elements, container)
    return textbox
end

function Window:AddDropdown(tabIndex, label, options, default, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local container = Create("Frame", {
        Name = label .. "_Dropdown",
        Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })
    
    local dropdownBtn = Create("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = THEME.Secondary,
        TextColor3 = THEME.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = (icon or "▼") .. " " .. label .. ": " .. (default or options[1]),
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        Parent = container
    })
    RoundCorner(dropdownBtn, 6)
    AddStroke(dropdownBtn, THEME.Primary, 1)
    AddPadding(dropdownBtn, 10, 0, 0, 0)
    
    local isOpen = false
    local selectedValue = default or options[1]
    
    local dropdownList = Create("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = THEME.Secondary,
        BorderSizePixel = 0,
        Visible = false,
        Parent = container,
        ClipsDescendants = true
    })
    RoundCorner(dropdownList, 6)
    AddStroke(dropdownList, THEME.Primary, 1)
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dropdownList
    })
    
    local function toggleDropdown()
        isOpen = not isOpen
        if isOpen then
            Tween(dropdownList, {Size = UDim2.new(1, 0, 0, #options * 35 + 10)}, 0.2)
            dropdownList.Visible = true
        else
            Tween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            wait(0.2)
            dropdownList.Visible = false
        end
    end
    
    dropdownBtn.MouseButton1Click:Connect(toggleDropdown)
    
    for _, option in ipairs(options) do
        local optionBtn = Create("TextButton", {
            Name = option,
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = selectedValue == option and THEME.Primary or THEME.Secondary,
            TextColor3 = THEME.Text,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Text = option,
            BorderSizePixel = 0,
            Parent = dropdownList
        })
        RoundCorner(optionBtn, 4)
        AddPadding(optionBtn, 5, 0, 5, 0)
        
        optionBtn.MouseButton1Click:Connect(function()
            selectedValue = option
            dropdownBtn.Text = (icon or "▼") .. " " .. label .. ": " .. option
            
            for _, btn in ipairs(dropdownList:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name == option and THEME.Primary or THEME.Secondary
                end
            end
            
            callback(option)
            toggleDropdown()
        end)
    end
    
    table.insert(tab.Elements, container)
    
    return {
        GetSelected = function() return selectedValue end,
        SetSelected = function(newValue)
            selectedValue = newValue
            dropdownBtn.Text = (icon or "▼") .. " " .. label .. ": " .. newValue
        end
    }
end

function Window:AddColorPicker(tabIndex, label, default, callback, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local container = Create("Frame", {
        Name = label .. "_ColorPicker",
        Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = THEME.Text,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Text = (icon or "🎨") .. " " .. label,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    AddPadding(container, 10, 0, 0, 0)
    
    local colorDisplay = Create("Frame", {
        Name = "ColorDisplay",
        Size = UDim2.new(0, 45, 0, 30),
        Position = UDim2.new(1, -55, 0.5, -15),
        BackgroundColor3 = default or THEME.Primary,
        BorderSizePixel = 0,
        Parent = container
    })
    RoundCorner(colorDisplay, 4)
    AddStroke(colorDisplay, Color3.fromRGB(255, 255, 255), 1)
    
    colorDisplay.MouseButton1Click:Connect(function()
        local colorPicker = Create("Frame", {
            Name = "ColorPickerUI",
            Size = UDim2.new(0, 300, 0, 250),
            Position = UDim2.new(0.5, -150, 0.5, -125),
            BackgroundColor3 = THEME.Background,
            BorderSizePixel = 0,
            Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        })
        RoundCorner(colorPicker, 10)
        AddStroke(colorPicker, THEME.Primary, 2)
        
        -- Simplified color picker - you can expand this
        local closeBtn = Create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -35, 0, 5),
            BackgroundColor3 = THEME.Error,
            TextColor3 = THEME.Text,
            Text = "✕",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            BorderSizePixel = 0,
            Parent = colorPicker
        })
        RoundCorner(closeBtn, 4)
        
        closeBtn.MouseButton1Click:Connect(function()
            colorPicker:Destroy()
        end)
    end)
    
    table.insert(tab.Elements, container)
    
    return {
        ColorDisplay = colorDisplay,
        GetColor = function() return colorDisplay.BackgroundColor3 end,
        SetColor = function(color)
            colorDisplay.BackgroundColor3 = color
            callback(color)
        end
    }
end

function Window:AddLabel(tabIndex, text, icon)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        TextColor3 = THEME.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Text = (icon or "•") .. " " .. text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Content
    })
    AddPadding(label, 10, 0, 0, 0)
    
    table.insert(tab.Elements, label)
    return label
end

function Window:AddDivider(tabIndex)
    local tab = self.Tabs[tabIndex]
    if not tab then return end
    
    local divider = Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = THEME.Primary,
        BorderSizePixel = 0,
        Parent = tab.Content
    })
    
    table.insert(tab.Elements, divider)
    return divider
end

-- ==================== MAIN GITANX CLASS ====================

function GitanX.new(screenName)
    local self = setmetatable({}, GitanX)
    
    self.Name = screenName
    self.Windows = {}
    self.ScreenGui = Create("ScreenGui", {
        Name = "GitanX_" .. screenName,
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })
    
    return self
end

function GitanX:CreateWindow(title, size, position)
    local window = Window:new(title, size, position)
    window.MainFrame.Parent = self.ScreenGui
    table.insert(self.Windows, window)
    return window
end

function GitanX:Notify(title, message, duration, notifType)
    ShowNotification(title, message, duration, notifType)
end

function GitanX:Destroy()
    self.ScreenGui:Destroy()
end

return GitanX
