--[[
   ██████╗ ██╗████████╗ █████╗ ███╗   ██╗██╗  ██╗
  ██╔════╝ ██║╚══██╔══╝██╔══██╗████╗  ██║╚██╗██╔╝
  ██║  ███╗██║   ██║   ███████║██╔██╗ ██║ ╚███╔╝ 
  ██║   ██║██║   ██║   ██╔══██║██║╚██╗██║ ██╔██╗ 
  ╚██████╔╝██║   ██║   ██║  ██║██║ ╚████║██╔╝ ██╗
   ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
   
   GitanX Interface Library
   Version 1.0.0 - Release
   Created by GitanX Development Team
   
   Credits:
   - Main Developer: GitanX Team
   - UI Design: GitanX Studios
   - Code Base: Adapted from Luna Interface Suite
   
   Features:
   - Modern UI Design
   - Configuration System
   - Theme Customization
   - Mobile Support
   - Key System
   - Notifications
   - Multiple Element Types
]]

local Release = "Release 1.0.0"

local GitanX = { 
	Folder = "GitanX", 
	Options = {}, 
	ThemeGradient = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 85, 85)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 170, 0)), 
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 85))
	}
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- Variables
local isStudio = RunService:IsStudio()
local website = "github.com/GitanX-Dev"
local tweeninfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- Utility Functions
local function Kwargify(defaults, passed)
	for i, v in pairs(defaults) do
		if passed[i] == nil then
			passed[i] = v
		end
	end
	return passed
end

local function tween(object, goal, callback, tweenin)
	local tween = TweenService:Create(object, tweenin or tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

-- UI Loading
local GitanXUI
if isStudio then
	GitanXUI = script.Parent:WaitForChild("GitanX UI")
else
	GitanXUI = game:GetObjects("rbxassetid://86467455075715")[1]
end

if gethui then
	GitanXUI.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(GitanXUI)
	GitanXUI.Parent = CoreGui
else
	GitanXUI.Parent = CoreGui
end

GitanXUI.Enabled = false
GitanXUI.DisplayOrder = 1000000000

local Main = GitanXUI.SmartWindow
local Elements = Main.Elements.Interactions
local Navigation = Main.Navigation
local Notifications = GitanXUI.Notifications

-- Notification System
function GitanX:Notification(data)
	task.spawn(function()
		data = Kwargify({
			Title = "Notification",
			Content = "Message",
			Duration = 5,
			Icon = "info"
		}, data or {})

		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title
		newNotification.Parent = Notifications
		newNotification.Visible = true
		
		newNotification.Title.Text = data.Title
		newNotification.Description.Text = data.Content
		
		-- Animations
		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		
		tween(newNotification, {BackgroundTransparency = 0.1})
		tween(newNotification.Title, {TextTransparency = 0})
		tween(newNotification.Description, {TextTransparency = 0})
		
		wait(data.Duration)
		
		tween(newNotification, {BackgroundTransparency = 1})
		tween(newNotification.Title, {TextTransparency = 1})
		tween(newNotification.Description, {TextTransparency = 1})
		
		wait(1)
		newNotification:Destroy()
	end)
end

-- Window Creation
function GitanX:CreateWindow(WindowSettings)
	WindowSettings = Kwargify({
		Name = "GitanX Window",
		Subtitle = "Interface",
		LoadingEnabled = true,
		LoadingTitle = "GitanX Interface",
		LoadingSubtitle = "Loading...",
		KeySystem = false,
		KeySettings = {}
	}, WindowSettings or {})

	local Window = {
		Bind = Enum.KeyCode.RightShift,
		CurrentTab = nil,
		State = true
	}

	Main.Title.Title.Text = WindowSettings.Name
	Main.Title.subtitle.Text = WindowSettings.Subtitle
	Main.Visible = true
	GitanXUI.Enabled = true

	-- Tab Creation
	function Window:CreateTab(TabSettings)
		TabSettings = Kwargify({
			Name = "Tab",
			Icon = "home",
			ShowTitle = true
		}, TabSettings or {})

		local Tab = {}
		local TabButton = Navigation.Tabs["InActive Template"]:Clone()
		TabButton.Name = TabSettings.Name
		TabButton.TextLabel.Text = TabSettings.Name
		TabButton.Parent = Navigation.Tabs
		TabButton.Visible = true

		local TabPage = Elements.Template:Clone()
		TabPage.Name = TabSettings.Name
		TabPage.Title.Text = TabSettings.Name
		TabPage.Title.Visible = TabSettings.ShowTitle
		TabPage.Visible = true
		TabPage.Parent = Elements

		function Tab:Activate()
			Elements.UIPageLayout:JumpTo(TabPage)
			Window.CurrentTab = TabSettings.Name
		end

		TabButton.Interact.MouseButton1Click:Connect(function()
			Tab:Activate()
		end)

		-- Button Element
		function Tab:CreateButton(ButtonSettings)
			ButtonSettings = Kwargify({
				Name = "Button",
				Callback = function() end
			}, ButtonSettings or {})

			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Visible = true
			Button.Parent = TabPage

			Button.Interact.MouseButton1Click:Connect(function()
				pcall(ButtonSettings.Callback)
			end)

			return Button
		end

		-- Toggle Element
		function Tab:CreateToggle(ToggleSettings, Flag)
			ToggleSettings = Kwargify({
				Name = "Toggle",
				CurrentValue = false,
				Callback = function() end
			}, ToggleSettings or {})

			local Toggle = Elements.Template.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage

			local function Set(value)
				ToggleSettings.CurrentValue = value
				if value then
					tween(Toggle.toggle, {BackgroundTransparency = 0})
					tween(Toggle.toggle.val, {Position = UDim2.new(1, -23, 0.5, 0)})
				else
					tween(Toggle.toggle, {BackgroundTransparency = 1})
					tween(Toggle.toggle.val, {Position = UDim2.new(0, 5, 0.5, 0)})
				end
				pcall(ToggleSettings.Callback, value)
			end

			Toggle.Interact.MouseButton1Click:Connect(function()
				Set(not ToggleSettings.CurrentValue)
			end)

			Set(ToggleSettings.CurrentValue)

			if Flag then
				GitanX.Options[Flag] = {
					Set = Set,
					CurrentValue = ToggleSettings.CurrentValue
				}
			end

			return {
				Set = function(self, value) Set(value) end
			}
		end

		-- Slider Element
		function Tab:CreateSlider(SliderSettings, Flag)
			SliderSettings = Kwargify({
				Name = "Slider",
				Range = {0, 100},
				Increment = 1,
				CurrentValue = 50,
				Callback = function() end
			}, SliderSettings or {})

			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage

			local dragging = false

			local function Set(value)
				value = math.clamp(value, SliderSettings.Range[1], SliderSettings.Range[2])
				value = math.floor(value / SliderSettings.Increment + 0.5) * SliderSettings.Increment
				SliderSettings.CurrentValue = value
				
				local percent = (value - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
				Slider.Main.Progress.Size = UDim2.new(percent, 0, 1, 0)
				Slider.Value.Text = tostring(value)
				
				pcall(SliderSettings.Callback, value)
			end

			Slider.Interact.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			Slider.Interact.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			RunService.RenderStepped:Connect(function()
				if dragging then
					local mousePos = UserInputService:GetMouseLocation().X
					local sliderPos = Slider.Main.AbsolutePosition.X
					local sliderSize = Slider.Main.AbsoluteSize.X
					local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
					local value = SliderSettings.Range[1] + percent * (SliderSettings.Range[2] - SliderSettings.Range[1])
					Set(value)
				end
			end)

			Set(SliderSettings.CurrentValue)

			if Flag then
				GitanX.Options[Flag] = {
					Set = Set,
					CurrentValue = SliderSettings.CurrentValue
				}
			end

			return {
				Set = function(self, value) Set(value) end
			}
		end

		-- Input Element
		function Tab:CreateInput(InputSettings, Flag)
			InputSettings = Kwargify({
				Name = "Input",
				PlaceholderText = "Enter text...",
				CurrentValue = "",
				Callback = function() end
			}, InputSettings or {})

			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage

			Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
			Input.InputFrame.InputBox.Text = InputSettings.CurrentValue

			Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				InputSettings.CurrentValue = Input.InputFrame.InputBox.Text
				pcall(InputSettings.Callback, InputSettings.CurrentValue)
			end)

			if Flag then
				GitanX.Options[Flag] = {
					CurrentValue = InputSettings.CurrentValue
				}
			end

			return Input
		end

		-- Label Element
		function Tab:CreateLabel(LabelSettings)
			LabelSettings = Kwargify({
				Text = "Label",
				Style = 1
			}, LabelSettings or {})

			local Label = Elements.Template.Label:Clone()
			Label.Text.Text = LabelSettings.Text
			Label.Visible = true
			Label.Parent = TabPage

			return {
				Set = function(self, text)
					Label.Text.Text = text
				end
			}
		end

		-- Section
		function Tab:CreateSection(name)
			local Section = Elements.Template.Section:Clone()
			Section.Text = name or "Section"
			Section.Visible = true
			Section.Parent = TabPage
			return Section
		end

		return Tab
	end

	-- Save/Load Config
	function GitanX:SaveConfig(name)
		if isStudio then return false, "Config system unavailable in Studio" end
		
		local data = {objects = {}}
		
		for flag, option in pairs(GitanX.Options) do
			table.insert(data.objects, {
				flag = flag,
				value = option.CurrentValue
			})
		end
		
		local encoded = HttpService:JSONEncode(data)
		local path = GitanX.Folder .. "/configs/" .. name .. ".json"
		
		writefile(path, encoded)
		return true
	end

	function GitanX:LoadConfig(name)
		if isStudio then return false, "Config system unavailable in Studio" end
		
		local path = GitanX.Folder .. "/configs/" .. name .. ".json"
		if not isfile(path) then return false, "Config not found" end
		
		local decoded = HttpService:JSONDecode(readfile(path))
		
		for _, option in pairs(decoded.objects) do
			if GitanX.Options[option.flag] then
				if GitanX.Options[option.flag].Set then
					GitanX.Options[option.flag]:Set(option.value)
				end
			end
		end
		
		return true
	end

	return Window
end

function GitanX:Destroy()
	GitanXUI:Destroy()
end

return GitanX
