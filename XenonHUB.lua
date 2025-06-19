-- Enhanced XenHub Library with Premium UI Design and Smooth Load Animation
-- Fixed version with proper error handling and improved functionality

-- Clean up existing instances
if game:GetService("CoreGui"):FindFirstChild("Xenon") then
	game:GetService("CoreGui").Xenon:Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
	game:GetService("CoreGui").ScreenGui:Destroy()
end

-- Enhanced Color Palette with Premium Theme
_G.Primary = Color3.fromRGB(115, 115, 120)
_G.Dark = Color3.fromRGB(18, 18, 22)
_G.Third = Color3.fromRGB(255, 65, 95)
_G.Accent = Color3.fromRGB(120, 140, 255)
_G.Success = Color3.fromRGB(85, 255, 85)
_G.Warning = Color3.fromRGB(255, 215, 65)
_G.Background = Color3.fromRGB(25, 25, 30)
_G.Surface = Color3.fromRGB(35, 35, 40)

-- Utility Functions
local function CreateRounded(Parent, Size)
	local Rounded = Instance.new("UICorner")
	Rounded.Name = "Rounded"
	Rounded.Parent = Parent
	Rounded.CornerRadius = UDim.new(0, Size)
	return Rounded
end

local function CreateGradient(Parent, ColorSequence)
	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence
	Gradient.Parent = Parent
	return Gradient
end

local function CreateStroke(Parent, Color, Thickness)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color or Color3.fromRGB(60, 60, 65)
	Stroke.Thickness = Thickness or 1
	Stroke.Parent = Parent
	return Stroke
end

local function CreateShadow(Parent)
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Parent = Parent
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://6014261993"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.7
	Shadow.Position = UDim2.new(0, -20, 0, -20)
	Shadow.Size = UDim2.new(1, 40, 1, 40)
	Shadow.ZIndex = -1
	return Shadow
end

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Draggable Function
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	
	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
			Position = pos
		})
		Tween:Play()
	end
	
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "XenonScreenGui"

-- Enhanced Main Toggle Button with Premium Design
local OutlineButton = Instance.new("Frame")
OutlineButton.Name = "OutlineButton"
OutlineButton.Parent = ScreenGui
OutlineButton.ClipsDescendants = true
OutlineButton.BackgroundColor3 = _G.Dark
OutlineButton.BackgroundTransparency = 0
OutlineButton.Position = UDim2.new(0, 15, 0, 15)
OutlineButton.Size = UDim2.new(0, 55, 0, 55)
CreateRounded(OutlineButton, 15)
CreateStroke(OutlineButton, Color3.fromRGB(50, 50, 55), 1.5)
CreateShadow(OutlineButton)

-- Add subtle glow effect
local GlowFrame = Instance.new("Frame")
GlowFrame.Name = "GlowFrame"
GlowFrame.Parent = OutlineButton
GlowFrame.BackgroundColor3 = _G.Third
GlowFrame.BackgroundTransparency = 0.9
GlowFrame.Size = UDim2.new(1, 4, 1, 4)
GlowFrame.Position = UDim2.new(0, -2, 0, -2)
GlowFrame.ZIndex = -1
CreateRounded(GlowFrame, 17)

local ImageButton = Instance.new("ImageButton")
ImageButton.Parent = OutlineButton
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.Size = UDim2.new(0, 42, 0, 42)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundColor3 = _G.Dark
ImageButton.ImageColor3 = Color3.fromRGB(250, 250, 250)
ImageButton.ImageTransparency = 0
ImageButton.BackgroundTransparency = 0
ImageButton.Image = "rbxassetid://105059922903197"
ImageButton.AutoButtonColor = false
CreateRounded(ImageButton, 12)

MakeDraggable(ImageButton, OutlineButton)

-- Enhanced hover effects with smooth animations
ImageButton.MouseEnter:Connect(function()
	TweenService:Create(ImageButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 45, 0, 45),
		ImageColor3 = _G.Third
	}):Play()
	TweenService:Create(OutlineButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		BackgroundColor3 = Color3.fromRGB(35, 35, 40),
		Size = UDim2.new(0, 58, 0, 58)
	}):Play()
	TweenService:Create(GlowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		BackgroundTransparency = 0.7
	}):Play()
end)

ImageButton.MouseLeave:Connect(function()
	TweenService:Create(ImageButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		Size = UDim2.new(0, 42, 0, 42),
		ImageColor3 = Color3.fromRGB(250, 250, 250)
	}):Play()
	TweenService:Create(OutlineButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		BackgroundColor3 = _G.Dark,
		Size = UDim2.new(0, 55, 0, 55)
	}):Play()
	TweenService:Create(GlowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
		BackgroundTransparency = 0.9
	}):Play()
end)

-- Enhanced Notification System
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function RemoveOldestNotification()
	if #NotificationList > 0 then
		local removed = table.remove(NotificationList, 1)
		if removed and removed[1] and removed[1].Parent then
			-- Enhanced exit animation
			TweenService:Create(removed[1], TweenInfo.new(0.5, Enum.EasingStyle.Back), {
				Position = UDim2.new(1.5, 0, removed[1].Position.Y.Scale, 0),
				Rotation = 15
			}):Play()
			wait(0.5)
			if removed[1] and removed[1].Parent then
				removed[1]:Destroy()
			end
		end
	end
end

spawn(function()
	while wait(1) do
		if #NotificationList > 0 then
			wait(3)
			RemoveOldestNotification()
		end
	end
end)

-- Configuration and Settings Management
local SettingsLib = {
	SaveSettings = true,
	LoadAnimation = true
}

-- Safe file operations with error handling
local function LoadConfig()
	local success, error = pcall(function()
		if readfile and writefile and isfile and isfolder then
			if not isfolder("Xenon") then
				makefolder("Xenon")
			end
			if not isfolder("Xenon/Library/") then
				makefolder("Xenon/Library/")
			end
			local fileName = "Xenon/Library/" .. Players.LocalPlayer.Name .. ".json"
			if not isfile(fileName) then
				writefile(fileName, HttpService:JSONEncode(SettingsLib))
			else
				local Decode = HttpService:JSONDecode(readfile(fileName))
				for i, v in pairs(Decode) do
					SettingsLib[i] = v
				end
			end
			print("Library Loaded!")
		else
			warn("Status : Undetected Executor")
		end
	end)
	if not success then
		warn("Failed to load config: " .. tostring(error))
	end
end

local function SaveConfig()
	local success, error = pcall(function()
		if readfile and writefile and isfile and isfolder then
			local fileName = "Xenon/Library/" .. Players.LocalPlayer.Name .. ".json"
			if not isfile(fileName) then
				LoadConfig()
			else
				local Array = {}
				for i, v in pairs(SettingsLib) do
					Array[i] = v
				end
				writefile(fileName, HttpService:JSONEncode(Array))
			end
		else
			warn("Status : Undetected Executor")
		end
	end)
	if not success then
		warn("Failed to save config: " .. tostring(error))
	end
end

-- Load configuration on startup
LoadConfig()

-- Main Update Library
local Update = {}

function Update:Notify(desc)
	local Frame = Instance.new("Frame")
	local Image = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local Desc = Instance.new("TextLabel")
	local OutlineFrame = Instance.new("Frame")
	local ProgressBar = Instance.new("Frame")
	local ProgressFill = Instance.new("Frame")
	
	OutlineFrame.Name = "OutlineFrame"
	OutlineFrame.Parent = NotificationFrame
	OutlineFrame.ClipsDescendants = true
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 1)
	OutlineFrame.BackgroundTransparency = 0.1
	OutlineFrame.Position = UDim2.new(1.5, 0, 0.15, 0)
	OutlineFrame.Size = UDim2.new(0, 420, 0, 80)
	CreateRounded(OutlineFrame, 15)
	CreateShadow(OutlineFrame)
	
	Frame.Name = "Frame"
	Frame.Parent = OutlineFrame
	Frame.ClipsDescendants = true
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = _G.Background
	Frame.BackgroundTransparency = 0
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 408, 0, 68)
	CreateRounded(Frame, 12)
	CreateStroke(Frame, Color3.fromRGB(50, 50, 55), 1.5)
	
	-- Enhanced Icon with glow
	Image.Name = "Icon"
	Image.Parent = Frame
	Image.BackgroundColor3 = _G.Third
	Image.BackgroundTransparency = 0.8
	Image.Position = UDim2.new(0, 12, 0, 12)
	Image.Size = UDim2.new(0, 44, 0, 44)
	Image.Image = "rbxassetid://105059922903197"
	Image.ImageColor3 = _G.Third
	CreateRounded(Image, 10)
	
	Title.Parent = Frame
	Title.BackgroundColor3 = _G.Primary
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 65, 0, 12)
	Title.Size = UDim2.new(0, 200, 0, 22)
	Title.Font = Enum.Font.GothamBold
	Title.Text = "Xenon Hub"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 17
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	Desc.Parent = Frame
	Desc.BackgroundColor3 = _G.Primary
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0, 65, 0, 35)
	Desc.Size = UDim2.new(0, 330, 0, 20)
	Desc.Font = Enum.Font.GothamSemibold
	Desc.TextTransparency = 0.2
	Desc.Text = desc
	Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
	Desc.TextSize = 13
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Enhanced Progress Bar
	ProgressBar.Name = "ProgressBar"
	ProgressBar.Parent = Frame
	ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	ProgressBar.Position = UDim2.new(0, 0, 1, -3)
	ProgressBar.Size = UDim2.new(1, 0, 0, 3)
	ProgressBar.BorderSizePixel = 0
	
	ProgressFill.Name = "ProgressFill"
	ProgressFill.Parent = ProgressBar
	ProgressFill.BackgroundColor3 = _G.Third
	ProgressFill.Size = UDim2.new(0, 0, 1, 0)
	ProgressFill.BorderSizePixel = 0
	
	-- Animated entrance
	TweenService:Create(OutlineFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
		Position = UDim2.new(0.5, 0, 0.15 + (#NotificationList) * 0.12, 0)
	}):Play()
	
	-- Progress bar animation
	TweenService:Create(ProgressFill, TweenInfo.new(3, Enum.EasingStyle.Linear), {
		Size = UDim2.new(1, 0, 1, 0)
	}):Play()
	
	-- Icon pulse animation
	local pulseAnimation = TweenService:Create(Image, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Size = UDim2.new(0, 48, 0, 48)
	})
	pulseAnimation:Play()
	
	table.insert(NotificationList, {OutlineFrame, "notification"})
end

-- Enhanced Loading Animation - FIXED VERSION
function Update:StartLoad()
	local Loader = Instance.new("ScreenGui")
	Loader.Name = "XenonLoader"
	Loader.Parent = game.CoreGui
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Loader.DisplayOrder = 1000
	
	local LoaderFrame = Instance.new("Frame")
	LoaderFrame.Name = "LoaderFrame"
	LoaderFrame.Parent = Loader
	LoaderFrame.ClipsDescendants = true
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	LoaderFrame.BackgroundTransparency = 0
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0)
	LoaderFrame.BorderSizePixel = 0
	
	-- Animated background pattern
	local BackgroundPattern = Instance.new("Frame")
	BackgroundPattern.Name = "BackgroundPattern"
	BackgroundPattern.Parent = LoaderFrame
	BackgroundPattern.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
	BackgroundPattern.BackgroundTransparency = 0.8
	BackgroundPattern.Size = UDim2.new(2, 0, 2, 0)
	BackgroundPattern.Position = UDim2.new(-0.5, 0, -0.5, 0)
	
	-- Create animated gradient background
	local BackgroundGradient = CreateGradient(BackgroundPattern, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
	}))
	
	-- Rotate background for dynamic effect
	local rotateAnimation = TweenService:Create(BackgroundPattern, TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
		Rotation = 360
	})
	rotateAnimation:Play()
	
	local MainLoaderFrame = Instance.new("Frame")
	MainLoaderFrame.Name = "MainLoaderFrame"
	MainLoaderFrame.Parent = LoaderFrame
	MainLoaderFrame.ClipsDescendants = true
	MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	MainLoaderFrame.BackgroundTransparency = 0
	MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainLoaderFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
	MainLoaderFrame.BorderSizePixel = 0
	CreateRounded(MainLoaderFrame, 20)
	CreateShadow(MainLoaderFrame)
	
	-- Enhanced Logo with Glow Effect
	local LogoFrame = Instance.new("Frame")
	LogoFrame.Name = "LogoFrame"
	LogoFrame.Parent = MainLoaderFrame
	LogoFrame.BackgroundColor3 = _G.Third
	LogoFrame.BackgroundTransparency = 0.9
	LogoFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoFrame.Position = UDim2.new(0.5, 0, 0.25, 0)
	LogoFrame.Size = UDim2.new(0, 80, 0, 80)
	CreateRounded(LogoFrame, 20)
	
	local LogoImage = Instance.new("ImageLabel")
	LogoImage.Name = "LogoImage"
	LogoImage.Parent = LogoFrame
	LogoImage.BackgroundTransparency = 1
	LogoImage.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 50, 0, 50)
	LogoImage.Image = "rbxassetid://105059922903197"
	LogoImage.ImageColor3 = _G.Third
	
	local TitleLoader = Instance.new("TextLabel")
	TitleLoader.Parent = MainLoaderFrame
	TitleLoader.Text = "XENON"
	TitleLoader.Font = Enum.Font.GothamBold
	TitleLoader.TextSize = 48
	TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLoader.BackgroundTransparency = 1
	TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	TitleLoader.Position = UDim2.new(0.5, 0, 0.45, 0)
	TitleLoader.Size = UDim2.new(0.8, 0, 0, 50)
	TitleLoader.TextTransparency = 0
	
	-- Add text glow effect
	local TextGlow = TitleLoader:Clone()
	TextGlow.Parent = TitleLoader
	TextGlow.TextColor3 = _G.Third
	TextGlow.TextTransparency = 0.7
	TextGlow.Size = UDim2.new(1, 2, 1, 2)
	TextGlow.Position = UDim2.new(0, -1, 0, -1)
	TextGlow.ZIndex = -1
	
	local SubtitleLoader = Instance.new("TextLabel")
	SubtitleLoader.Parent = MainLoaderFrame
	SubtitleLoader.Text = "Premium Script Hub"
	SubtitleLoader.Font = Enum.Font.GothamSemibold
	SubtitleLoader.TextSize = 16
	SubtitleLoader.TextColor3 = Color3.fromRGB(180, 180, 180)
	SubtitleLoader.BackgroundTransparency = 1
	SubtitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	SubtitleLoader.Position = UDim2.new(0.5, 0, 0.55, 0)
	SubtitleLoader.Size = UDim2.new(0.8, 0, 0, 25)
	SubtitleLoader.TextTransparency = 0.3
	
	local DescriptionLoader = Instance.new("TextLabel")
	DescriptionLoader.Parent = MainLoaderFrame
	DescriptionLoader.Text = "Initializing.."
	DescriptionLoader.Font = Enum.Font.Gotham
	DescriptionLoader.TextSize = 14
	DescriptionLoader.TextColor3 = Color3.fromRGB(200, 200, 200)
	DescriptionLoader.BackgroundTransparency = 1
	DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	DescriptionLoader.Position = UDim2.new(0.5, 0, 0.75, 0)
	DescriptionLoader.Size = UDim2.new(0.8, 0, 0, 25)
	DescriptionLoader.TextTransparency = 0
	
	-- Enhanced Loading Bar with Glow
	local LoadingBarContainer = Instance.new("Frame")
	LoadingBarContainer.Parent = MainLoaderFrame
	LoadingBarContainer.BackgroundTransparency = 1
	LoadingBarContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingBarContainer.Position = UDim2.new(0.5, 0, 0.85, 0)
	LoadingBarContainer.Size = UDim2.new(0.7, 0, 0, 6)
	
	local LoadingBarBackground = Instance.new("Frame")
	LoadingBarBackground.Parent = LoadingBarContainer
	LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingBarBackground.Size = UDim2.new(1, 0, 1, 0)
	LoadingBarBackground.ClipsDescendants = true
	LoadingBarBackground.BorderSizePixel = 0
	LoadingBarBackground.ZIndex = 2
	CreateRounded(LoadingBarBackground, 3)
	
	local LoadingBarGlow = Instance.new("Frame")
	LoadingBarGlow.Parent = LoadingBarContainer
	LoadingBarGlow.BackgroundColor3 = _G.Third
	LoadingBarGlow.BackgroundTransparency = 0.7
	LoadingBarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingBarGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadingBarGlow.Size = UDim2.new(1, 4, 1, 4)
	LoadingBarGlow.ZIndex = 1
	CreateRounded(LoadingBarGlow, 5)
	
	local LoadingBar = Instance.new("Frame")
	LoadingBar.Parent = LoadingBarBackground
	LoadingBar.BackgroundColor3 = _G.Third
	LoadingBar.Size = UDim2.new(0, 0, 1, 0)
	LoadingBar.ZIndex = 3
	CreateRounded(LoadingBar, 3)
	
	-- Animated gradient for loading bar
	local LoadingGradient = CreateGradient(LoadingBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Third),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 150)),
		ColorSequenceKeypoint.new(1, _G.Accent)
	}))
	
	-- Pulse animations
	local logoAnimation = TweenService:Create(LogoImage, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Rotation = 15
	})
	logoAnimation:Play()
	
	local glowAnimation = TweenService:Create(LogoFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		BackgroundTransparency = 0.5
	})
	glowAnimation:Play()
	
	local titleAnimation = TweenService:Create(TitleLoader, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		TextTransparency = 0.3
	})
	titleAnimation:Play()
	
	local running = true
	local loadingComplete = false
	
	-- Enhanced loading stages
	local loadingStages = {
		"Initializing components..",
		"Loading interface..",
		"Connecting services..",
		"Finalizing setup..",
		"Almost ready.."
	}
	local currentStage = 1
	
	-- FIXED: Create proper loading sequence with controlled timing
	local function startLoadingSequence()
		-- Stage 1: Quick initial load (0-30%)
		local barTweenInfoPart1 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local barTweenPart1 = TweenService:Create(LoadingBar, barTweenInfoPart1, {
			Size = UDim2.new(0.3, 0, 1, 0)
		})
		
		-- Stage 2: Progressive load (30-70%)
		local barTweenInfoPart2 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local barTweenPart2 = TweenService:Create(LoadingBar, barTweenInfoPart2, {
			Size = UDim2.new(0.7, 0, 1, 0)
		})
		
		-- Stage 3: Final completion (70-100%)
		local barTweenInfoPart3 = TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local barTweenPart3 = TweenService:Create(LoadingBar, barTweenInfoPart3, {
			Size = UDim2.new(1, 0, 1, 0)
		})
		
		-- Start first stage
		barTweenPart1:Play()
		DescriptionLoader.Text = loadingStages[1]
		
		-- Handle stage transitions
		barTweenPart1.Completed:Connect(function()
			if not loadingComplete then
				currentStage = 2
				DescriptionLoader.Text = loadingStages[currentStage]
				barTweenPart2:Play()
			end
		end)
		
		barTweenPart2.Completed:Connect(function()
			if not loadingComplete then
				currentStage = 3
				DescriptionLoader.Text = loadingStages[currentStage]
				wait(0.5) -- Brief pause before final stage
				currentStage = 4
				DescriptionLoader.Text = loadingStages[currentStage]
				wait(0.5)
				currentStage = 5
				DescriptionLoader.Text = loadingStages[currentStage]
				wait(1.0) -- Wait longer on "Almost ready.." stage
				barTweenPart3:Play()
			end
		end)
		
		-- FIXED: Only destroy when explicitly called via Update:Loaded()
		barTweenPart3.Completed:Connect(function()
			if not loadingComplete then
				DescriptionLoader.Text = "Ready! Waiting for completion..."
				-- Don't auto-destroy here, wait for Update:Loaded() call
			end
		end)
		
		-- Store references for external control
		Update._LoaderReferences = {
			Loader = Loader,
			MainLoaderFrame = MainLoaderFrame,
			LoaderFrame = LoaderFrame,
			DescriptionLoader = DescriptionLoader,
			running = running,
			loadingComplete = loadingComplete
		}
	end
	
	-- Start the loading sequence
	startLoadingSequence()
	
	-- Enhanced loading text animation with dots
	spawn(function()
		while running and not loadingComplete do
			local originalText = DescriptionLoader.Text
			if originalText:find("%.%.") then
				-- Remove existing dots and add animated ones
				local baseText = originalText:gsub("%.+", "")
				for i = 1, 3 do
					if not running or loadingComplete then break end
					DescriptionLoader.Text = baseText .. string.rep(".", i)
					wait(0.4)
				end
				wait(0.2)
			else
				wait(0.5)
			end
		end
	end)
end

-- FIXED: Proper Loaded function that actually completes the loading
function Update:Loaded()
	if Update._LoaderReferences then
		local refs = Update._LoaderReferences
		refs.loadingComplete = true
		refs.running = false
		
		-- Update final message
		refs.DescriptionLoader.Text = "Welcome to Xenon!"
		
		-- Wait a moment to show the completion message
		wait(0.8)
		
		-- Enhanced exit animation
		TweenService:Create(refs.MainLoaderFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 0, 0, 0),
			Rotation = 180
		}):Play()
		
		TweenService:Create(refs.LoaderFrame, TweenInfo.new(1, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 1
		}):Play()
		
		-- Clean up after animation
		wait(1)
		if refs.Loader and refs.Loader.Parent then
			refs.Loader:Destroy()
		end
		
		-- Clear references
		Update._LoaderReferences = nil
	end
end

function Update:SaveSettings()
	return SettingsLib.SaveSettings
end

function Update:LoadAnimation()
	return SettingsLib.LoadAnimation
end

-- Enhanced Main Window Creation
function Update:Window(Config)
	assert(Config.SubTitle, "SubTitle is required")
	
	local WindowConfig = {
		Size = Config.Size or UDim2.new(0, 600, 0, 400),
		TabWidth = Config.TabWidth or 150
	}
	
	local osfunc = {}
	local uihide = false
	local abc = false
	local currentpage = ""
	local keybind = keybind or Enum.KeyCode.RightControl
	
	local Xenon = Instance.new("ScreenGui")
	Xenon.Name = "Xenon"
	Xenon.Parent = game.CoreGui
	Xenon.DisplayOrder = 999
	
	-- Enhanced Main Window with Premium Design
	local OutlineMain = Instance.new("Frame")
	OutlineMain.Name = "OutlineMain"
	OutlineMain.Parent = Xenon
	OutlineMain.ClipsDescendants = true
	OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineMain.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	OutlineMain.BackgroundTransparency = 0.1
	OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
	OutlineMain.Size = UDim2.new(0, 0, 0, 0)
	CreateRounded(OutlineMain, 18)
	CreateShadow(OutlineMain)
	
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = OutlineMain
	Main.ClipsDescendants = true
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = _G.Background
	Main.BackgroundTransparency = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = WindowConfig.Size
	
	-- Enhanced entrance animation
	OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20), "Out", "Back", 0.6, true)
	CreateRounded(Main, 15)
	CreateStroke(Main, Color3.fromRGB(50, 50, 55), 2)
	
	-- Add subtle animated background
	local BackgroundAccent = Instance.new("Frame")
	BackgroundAccent.Name = "BackgroundAccent"
	BackgroundAccent.Parent = Main
	BackgroundAccent.BackgroundColor3 = _G.Third
	BackgroundAccent.BackgroundTransparency = 0.95
	BackgroundAccent.Size = UDim2.new(1, 0, 0, 2)
	BackgroundAccent.Position = UDim2.new(0, 0, 0, 0)
	CreateRounded(BackgroundAccent, 15)
	
	-- Animated gradient background
	local MainGradient = CreateGradient(Main, ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Background),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(28, 28, 35)),
		ColorSequenceKeypoint.new(1, _G.Background)
	}))
	
	local DragButton = Instance.new("Frame")
	DragButton.Name = "DragButton"
	DragButton.Parent = Main
	DragButton.Position = UDim2.new(1, 5, 1, 5)
	DragButton.AnchorPoint = Vector2.new(1, 1)
	DragButton.Size = UDim2.new(0, 18, 0, 18)
	DragButton.BackgroundColor3 = _G.Primary
	DragButton.BackgroundTransparency = 0.7
	DragButton.ZIndex = 10
	CreateRounded(DragButton, 9)
	
	-- Enhanced Header with Premium Design
	local Top = Instance.new("Frame")
	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	Top.Size = UDim2.new(1, 0, 0, 50)
	Top.BackgroundTransparency = 0
	CreateRounded(Top, 15)
	CreateStroke(Top, Color3.fromRGB(40, 40, 45), 1)
	
	-- Header gradient
	local HeaderGradient = CreateGradient(Top, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
	}))
	
	-- Enhanced Logo and Title Section
	local LogoContainer = Instance.new("Frame")
	LogoContainer.Name = "LogoContainer"
	LogoContainer.Parent = Top
	LogoContainer.BackgroundTransparency = 1
	LogoContainer.Position = UDim2.new(0, 15, 0.5, 0)
	LogoContainer.AnchorPoint = Vector2.new(0, 0.5)
	LogoContainer.Size = UDim2.new(0, 35, 0, 35)
	
	local Logo = Instance.new("ImageLabel")
	Logo.Name = "Logo"
	Logo.Parent = LogoContainer
	Logo.BackgroundColor3 = _G.Third
	Logo.BackgroundTransparency = 0.8
	Logo.Size = UDim2.new(1, 0, 1, 0)
	Logo.Image = "rbxassetid://105059922903197"
	Logo.ImageColor3 = _G.Third
	CreateRounded(Logo, 8)
	
	local NameHub = Instance.new("TextLabel")
	NameHub.Name = "NameHub"
	NameHub.Parent = Top
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameHub.BackgroundTransparency = 1
	NameHub.RichText = true
	NameHub.Position = UDim2.new(0, 60, 0.5, -3)
	NameHub.AnchorPoint = Vector2.new(0, 0.5)
	NameHub.Size = UDim2.new(0, 1, 0, 28)
	NameHub.Font = Enum.Font.GothamBold
	NameHub.Text = "XENON"
	NameHub.TextSize = 22
	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameHub.TextXAlignment = Enum.TextXAlignment.Left
	
	local TextService = game:GetService("TextService")
	local nameHubSize = TextService:GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge))
	NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 28)
	
	local SubTitle = Instance.new("TextLabel")
	SubTitle.Name = "SubTitle"
	SubTitle.Parent = NameHub
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Position = UDim2.new(0, nameHubSize.X + 12, 0.5, 0)
	SubTitle.Size = UDim2.new(0, 1, 0, 22)
	SubTitle.Font = Enum.Font.GothamSemibold
	SubTitle.AnchorPoint = Vector2.new(0, 0.5)
	SubTitle.Text = Config.SubTitle
	SubTitle.TextSize = 16
	SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	
	local SubTitleSize = TextService:GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge))
	SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 22)
	
	-- Enhanced Control Buttons
	local ButtonContainer = Instance.new("Frame")
	ButtonContainer.Name = "ButtonContainer"
	ButtonContainer.Parent = Top
	ButtonContainer.BackgroundTransparency = 1
	ButtonContainer.AnchorPoint = Vector2.new(1, 0.5)
	ButtonContainer.Position = UDim2.new(1, -15, 0.5, 0)
	ButtonContainer.Size = UDim2.new(0, 120, 0, 30)
	
	local ButtonLayout = Instance.new("UIListLayout")
	ButtonLayout.Parent = ButtonContainer
	ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
	ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ButtonLayout.Padding = UDim.new(0, 10)
	
	local CloseButton = Instance.new("ImageButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = ButtonContainer
	CloseButton.BackgroundColor3 = _G.Primary
	CloseButton.BackgroundTransparency = 0.8
	CloseButton.Size = UDim2.new(0, 25, 0, 25)
	CloseButton.Image = "rbxassetid://7743878857"
	CloseButton.ImageTransparency = 0
	CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
	CreateRounded(CloseButton, 6)
	
	-- Enhanced button hover effects
	CloseButton.MouseEnter:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
			ImageColor3 = _G.Third,
			BackgroundTransparency = 0.6,
			Size = UDim2.new(0, 27, 0, 27)
		}):Play()
	end)
	
	CloseButton.MouseLeave:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
			ImageColor3 = Color3.fromRGB(245, 245, 245),
			BackgroundTransparency = 0.8,
			Size = UDim2.new(0, 25, 0, 25)
		}):Play()
	end)
	
	-- Fixed close button functionality
	CloseButton.MouseButton1Click:Connect(function()
		-- Enhanced close animation
		TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 0, 0, 0),
			Rotation = 90
		}):Play()
		wait(0.4)
		local xenonGui = game.CoreGui:FindFirstChild("Xenon")
		if xenonGui then
			xenonGui.Enabled = not xenonGui.Enabled
		end
	end)
	
	-- Fixed toggle button functionality
	ImageButton.MouseButton1Click:Connect(function()
		-- Add click feedback
		TweenService:Create(ImageButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 40, 0, 40)
		}):Play()
		wait(0.1)
		TweenService:Create(ImageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 45, 0, 45)
		}):Play()
		local xenonGui = game.CoreGui:FindFirstChild("Xenon")
		if xenonGui then
			xenonGui.Enabled = not xenonGui.Enabled
		end
	end)
	
	-- Enhanced Tab System
	local Tab = Instance.new("Frame")
	Tab.Name = "Tab"
	Tab.Parent = Main
	Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	Tab.Position = UDim2.new(0, 12, 0, Top.Size.Y.Offset + 5)
	Tab.BackgroundTransparency = 0.9
	Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15)
	CreateRounded(Tab, 12)
	CreateStroke(Tab, Color3.fromRGB(45, 45, 50), 1)
	
	local ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = Tab
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	ScrollTab.Position = UDim2.new(0, 0, 0, 0)
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Size = UDim2.new(1, 0, 1, 0)
	ScrollTab.ScrollBarThickness = 3
	ScrollTab.ScrollBarImageColor3 = _G.Third
	ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Name = "TabListLayout"
	TabListLayout.Parent = ScrollTab
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 5)
	
	local PPD = Instance.new("UIPadding")
	PPD.Name = "PPD"
	PPD.Parent = ScrollTab
	PPD.PaddingTop = UDim.new(0, 8)
	PPD.PaddingBottom = UDim.new(0, 8)
	PPD.PaddingLeft = UDim.new(0, 8)
	PPD.PaddingRight = UDim.new(0, 8)
	
	-- Enhanced Page Container
	local Page = Instance.new("Frame")
	Page.Name = "Page"
	Page.Parent = Main
	Page.BackgroundColor3 = _G.Surface
	Page.Position = UDim2.new(0, Tab.Size.X.Offset + 25, 0, Top.Size.Y.Offset + 5)
	Page.Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 35, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15)
	Page.BackgroundTransparency = 0.95
	CreateRounded(Page, 12)
	CreateStroke(Page, Color3.fromRGB(40, 40, 45), 1)
	
	local MainPage = Instance.new("Frame")
	MainPage.Name = "MainPage"
	MainPage.Parent = Page
	MainPage.ClipsDescendants = true
	MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainPage.BackgroundTransparency = 1
	MainPage.Size = UDim2.new(1, 0, 1, 0)
	
	local PageList = Instance.new("Folder")
	PageList.Name = "PageList"
	PageList.Parent = MainPage
	
	local UIPageLayout = Instance.new("UIPageLayout")
	UIPageLayout.Parent = PageList
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quart
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical
	UIPageLayout.Padding = UDim.new(0, 10)
	UIPageLayout.TweenTime = 0.4
	UIPageLayout.GamepadInputEnabled = false
	UIPageLayout.ScrollWheelInputEnabled = false
	UIPageLayout.TouchInputEnabled = false
	
	MakeDraggable(Top, OutlineMain)
	
	-- Fixed keybind functionality
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Insert then
			local xenonGui = game.CoreGui:FindFirstChild("Xenon")
			if xenonGui then
				xenonGui.Enabled = not xenonGui.Enabled
			end
		end
	end)
	
	-- Auto-resize canvas functionality
	RunService.Stepped:Connect(function()
		pcall(function()
			ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16)
		end)
	end)
	
	local uitab = {}
	
	function uitab:Tab(text, img)
		local TabButton = Instance.new("TextButton")
		local Title = Instance.new("TextLabel")
		
		TabButton.Parent = ScrollTab
		TabButton.Name = text .. "Unique"
		TabButton.Text = ""
		TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		TabButton.BackgroundTransparency = 0.9
		TabButton.Size = UDim2.new(1, 0, 0, 42)
		TabButton.Font = Enum.Font.Nunito
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 12
		TabButton.TextTransparency = 0.9
		CreateRounded(TabButton, 10)
		CreateStroke(TabButton, Color3.fromRGB(50, 50, 55), 1)
		
		local SelectedTab = Instance.new("Frame")
		SelectedTab.Name = "SelectedTab"
		SelectedTab.Parent = TabButton
		SelectedTab.BackgroundColor3 = _G.Third
		SelectedTab.BackgroundTransparency = 0
		SelectedTab.Size = UDim2.new(0, 4, 0, 0)
		SelectedTab.Position = UDim2.new(0, -2, 0.5, 0)
		SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
		CreateRounded(SelectedTab, 2)
		
		Title.Parent = TabButton
		Title.Name = "Title"
		Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 38, 0.5, 0)
		Title.Size = UDim2.new(0, 120, 0, 30)
		Title.Font = Enum.Font.GothamSemibold
		Title.Text = text
		Title.AnchorPoint = Vector2.new(0, 0.5)
		Title.TextColor3 = Color3.fromRGB(180, 180, 180)
		Title.TextTransparency = 0.3
		Title.TextSize = 15
		Title.TextXAlignment = Enum.TextXAlignment.Left
		
		local IDK = Instance.new("ImageLabel")
		IDK.Name = "IDK"
		IDK.Parent = TabButton
		IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		IDK.BackgroundTransparency = 1
		IDK.ImageTransparency = 0.4
		IDK.Position = UDim2.new(0, 12, 0.5, 0)
		IDK.Size = UDim2.new(0, 18, 0, 18)
		IDK.AnchorPoint = Vector2.new(0, 0.5)
		IDK.Image = img
		IDK.ImageColor3 = Color3.fromRGB(180, 180, 180)
		
		-- Enhanced tab hover effects
		TabButton.MouseEnter:Connect(function()
			if TabButton.BackgroundTransparency == 0.9 then -- Not selected
				TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.7,
					Size = UDim2.new(1, 2, 0, 44)
				}):Play()
				TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					TextTransparency = 0.1
				}):Play()
				TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					ImageTransparency = 0.2
				}):Play()
			end
		end)
		
		TabButton.MouseLeave:Connect(function()
			if TabButton.BackgroundTransparency ~= 0.5 then -- Not selected
				TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.9,
					Size = UDim2.new(1, 0, 0, 42)
				}):Play()
				TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					TextTransparency = 0.3
				}):Play()
				TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					ImageTransparency = 0.4
				}):Play()
			end
		end)
		
		local MainFramePage = Instance.new("ScrollingFrame")
		MainFramePage.Name = text .. "_Page"
		MainFramePage.Parent = PageList
		MainFramePage.Active = true
		MainFramePage.BackgroundColor3 = _G.Dark
		MainFramePage.Position = UDim2.new(0, 0, 0, 0)
		MainFramePage.BackgroundTransparency = 1
		MainFramePage.Size = UDim2.new(1, 0, 1, 0)
		MainFramePage.ScrollBarThickness = 4
		MainFramePage.ScrollBarImageColor3 = _G.Third
		MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y
		
		local UIPadding = Instance.new("UIPadding")
		local UIListLayout = Instance.new("UIListLayout")
		UIPadding.Parent = MainFramePage
		UIPadding.PaddingTop = UDim.new(0, 10)
		UIPadding.PaddingBottom = UDim.new(0, 10)
		UIPadding.PaddingLeft = UDim.new(0, 15)
		UIPadding.PaddingRight = UDim.new(0, 15)
		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.Parent = MainFramePage
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.9,
						Size = UDim2.new(1, 0, 0, 42)
					}):Play()
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 4, 0, 0)
					}):Play()
					TweenService:Create(v.IDK, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4,
						ImageColor3 = Color3.fromRGB(180, 180, 180)
					}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						TextTransparency = 0.3,
						TextColor3 = Color3.fromRGB(180, 180, 180)
					}):Play()
				end
			end
			
			TweenService:Create(TabButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 42)
			}):Play()
			TweenService:Create(SelectedTab, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 4, 0, 25)
			}):Play()
			TweenService:Create(IDK, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				ImageTransparency = 0,
				ImageColor3 = _G.Third
			}):Play()
			TweenService:Create(Title, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				TextTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page"
				if v.Name == currentpage then
					UIPageLayout:JumpTo(v)
				end
			end
		end)
		
		if abc == false then
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.9
					}):Play()
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 4, 0, 0)
					}):Play()
					TweenService:Create(v.IDK, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						TextTransparency = 0.3
					}):Play()
				end
			end
			
			TweenService:Create(TabButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.5
			}):Play()
			TweenService:Create(SelectedTab, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 4, 0, 25)
			}):Play()
			TweenService:Create(IDK, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				ImageTransparency = 0,
				ImageColor3 = _G.Third
			}):Play()
			TweenService:Create(Title, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				TextTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			
			UIPageLayout:JumpToIndex(1)
			abc = true
		end
		
		-- Auto-resize canvas functionality
		RunService.Stepped:Connect(function()
			pcall(function()
				MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
			end)
		end)
		
		local main = {}
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			
			Button.Name = "Button"
			Button.Parent = MainFramePage
			Button.BackgroundColor3 = _G.Surface
			Button.BackgroundTransparency = 0.7
			Button.Size = UDim2.new(1, 0, 0, 45)
			CreateRounded(Button, 10)
			CreateStroke(Button, Color3.fromRGB(60, 60, 65), 1.5)
			
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Parent = TextButton
			ImageLabel.BackgroundColor3 = _G.Primary
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			ImageLabel.Size = UDim2.new(0, 18, 0, 18)
			ImageLabel.Image = "rbxassetid://10734898355"
			ImageLabel.ImageTransparency = 0
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			TextButton.Name = "TextButton"
			TextButton.Parent = Button
			TextButton.BackgroundColor3 = _G.Third
			TextButton.BackgroundTransparency = 0
			TextButton.AnchorPoint = Vector2.new(1, 0.5)
			TextButton.Position = UDim2.new(1, -10, 0.5, 0)
			TextButton.Size = UDim2.new(0, 32, 0, 32)
			TextButton.Font = Enum.Font.Nunito
			TextButton.Text = ""
			TextButton.TextXAlignment = Enum.TextXAlignment.Left
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.TextSize = 15
			CreateRounded(TextButton, 8)
			CreateStroke(TextButton, Color3.fromRGB(70, 70, 75), 1.5)
			
			-- Enhanced button hover effects
			TextButton.MouseEnter:Connect(function()
				TweenService:Create(TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundColor3 = Color3.fromRGB(255, 75, 105),
					Size = UDim2.new(0, 35, 0, 35)
				}):Play()
				TweenService:Create(ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, 20, 0, 20)
				}):Play()
			end)
			
			TextButton.MouseLeave:Connect(function()
				TweenService:Create(TextButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundColor3 = _G.Third,
					Size = UDim2.new(0, 32, 0, 32)
				}):Play()
				TweenService:Create(ImageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, 18, 0, 18)
				}):Play()
			end)
			
			TextLabel.Name = "TextLabel"
			TextLabel.Parent = Button
			TextLabel.BackgroundColor3 = _G.Primary
			TextLabel.BackgroundTransparency = 1
			TextLabel.AnchorPoint = Vector2.new(0, 0.5)
			TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
			TextLabel.Size = UDim2.new(1, -65, 1, 0)
			TextLabel.Font = Enum.Font.GothamSemibold
			TextLabel.RichText = true
			TextLabel.Text = text
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
			TextLabel.TextSize = 16
			TextLabel.ClipsDescendants = true
			
			local ArrowRight = Instance.new("ImageLabel")
			ArrowRight.Name = "ArrowRight"
			ArrowRight.Parent = Button
			ArrowRight.BackgroundColor3 = _G.Primary
			ArrowRight.BackgroundTransparency = 1
			ArrowRight.AnchorPoint = Vector2.new(0, 0.5)
			ArrowRight.Position = UDim2.new(0, 0, 0.5, 0)
			ArrowRight.Size = UDim2.new(0, 18, 0, 18)
			ArrowRight.Image = "rbxassetid://10709768347"
			ArrowRight.ImageTransparency = 0.2
			ArrowRight.ImageColor3 = _G.Third
			
			-- Enhanced button hover effect
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.5
				}):Play()
				TweenService:Create(ArrowRight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					ImageTransparency = 0,
					Size = UDim2.new(0, 20, 0, 20)
				}):Play()
			end)
			
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.7
				}):Play()
				TweenService:Create(ArrowRight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					ImageTransparency = 0.2,
					Size = UDim2.new(0, 18, 0, 18)
				}):Play()
			end)
			
			TextButton.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end
		
		function main:Toggle(text, config, desc, callback)
			config = config or false
			local toggled = config
			
			local Button = Instance.new("TextButton")
			local Title = Instance.new("TextLabel")
			local Desc = Instance.new("TextLabel")
			local ToggleFrame = Instance.new("Frame")
			local ToggleImage = Instance.new("TextButton")
			local Circle = Instance.new("Frame")
			
			Button.Name = "Button"
			Button.Parent = MainFramePage
			Button.BackgroundColor3 = _G.Surface
			Button.BackgroundTransparency = 0.7
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(0, 0, 0)
			Button.TextSize = 11
			CreateRounded(Button, 10)
			CreateStroke(Button, Color3.fromRGB(60, 60, 65), 1.5)
			
			Title.Parent = Button
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, 0, 0, 45)
			Title.Font = Enum.Font.GothamSemibold
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(240, 240, 240)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.AnchorPoint = Vector2.new(0, 0.5)
			
			Desc.Parent = Title
			Desc.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			Desc.BackgroundTransparency = 1
			Desc.Position = UDim2.new(0, 0, 0, 28)
			Desc.Size = UDim2.new(0, 350, 0, 18)
			Desc.Font = Enum.Font.Gotham
			
			if desc then
				Desc.Text = desc
				Title.Position = UDim2.new(0, 20, 0.5, -8)
				Desc.Position = UDim2.new(0, 0, 0, 28)
				Button.Size = UDim2.new(1, 0, 0, 55)
			else
				Title.Position = UDim2.new(0, 20, 0.5, 0)
				Desc.Visible = false
				Button.Size = UDim2.new(1, 0, 0, 45)
			end
			
			Desc.TextColor3 = Color3.fromRGB(170, 170, 170)
			Desc.TextSize = 12
			Desc.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = Button
			ToggleFrame.BackgroundColor3 = _G.Dark
			ToggleFrame.BackgroundTransparency = 1
			ToggleFrame.Position = UDim2.new(1, -15, 0.5, 0)
			ToggleFrame.Size = UDim2.new(0, 45, 0, 25)
			ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
			CreateRounded(ToggleFrame, 12)
			
			ToggleImage.Name = "ToggleImage"
			ToggleImage.Parent = ToggleFrame
			ToggleImage.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
			ToggleImage.BackgroundTransparency = 0
			ToggleImage.Position = UDim2.new(0, 0, 0, 0)
			ToggleImage.AnchorPoint = Vector2.new(0, 0)
			ToggleImage.Size = UDim2.new(1, 0, 1, 0)
			ToggleImage.Text = ""
			ToggleImage.AutoButtonColor = false
			CreateRounded(ToggleImage, 12)
			CreateStroke(ToggleImage, Color3.fromRGB(70, 70, 75), 1.5)
			
			Circle.Name = "Circle"
			Circle.Parent = ToggleImage
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.BackgroundTransparency = 0
			Circle.Position = UDim2.new(0, 4, 0.5, 0)
			Circle.Size = UDim2.new(0, 17, 0, 17)
			Circle.AnchorPoint = Vector2.new(0, 0.5)
			CreateRounded(Circle, 9)
			CreateStroke(Circle, Color3.fromRGB(80, 80, 85), 1)
			
			-- Enhanced toggle hover effects
			ToggleImage.MouseEnter:Connect(function()
				TweenService:Create(ToggleImage, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(1, 2, 1, 2)
				}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, 19, 0, 19)
				}):Play()
			end)
			
			ToggleImage.MouseLeave:Connect(function()
				TweenService:Create(ToggleImage, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(1, 0, 1, 0)
				}):Play()
				TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, 17, 0, 17)
				}):Play()
			end)
			
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.5
				}):Play()
			end)
			
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
					BackgroundTransparency = 0.7
				}):Play()
			end)
			
			ToggleImage.MouseButton1Click:Connect(function()
				if toggled == false then
					toggled = true
					Circle:TweenPosition(UDim2.new(0, 24, 0.5, 0), "Out", "Back", 0.3, true)
					TweenService:Create(ToggleImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						BackgroundColor3 = _G.Third,
						BackgroundTransparency = 0
					}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
				else
					toggled = false
					Circle:TweenPosition(UDim2.new(0, 4, 0.5, 0), "Out", "Back", 0.3, true)
					TweenService:Create(ToggleImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(60, 60, 65),
						BackgroundTransparency = 0
					}):Play()
					TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
				end
				pcall(callback, toggled)
			end)
			
			if config == true then
				toggled = true
				Circle:TweenPosition(UDim2.new(0, 24, 0.5, 0), "Out", "Back", 0.5, true)
				TweenService:Create(ToggleImage, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					BackgroundColor3 = _G.Third,
					BackgroundTransparency = 0
				}):Play()
				pcall(callback, toggled)
			end
		end
		
		function main:Label(text)
			local Frame = Instance.new("Frame")
			local Label = Instance.new("TextLabel")
			local labelfunc = {}
			
			Frame.Name = "Frame"
			Frame.Parent = MainFramePage
			Frame.BackgroundColor3 = _G.Surface
			Frame.BackgroundTransparency = 0.8
			Frame.Size = UDim2.new(1, 0, 0, 40)
			CreateRounded(Frame, 10)
			CreateStroke(Frame, Color3.fromRGB(60, 60, 65), 1)
			
			Label.Name = "Label"
			Label.Parent = Frame
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, -50, 0, 40)
			Label.Font = Enum.Font.GothamSemibold
			Label.Position = UDim2.new(0, 40, 0.5, 0)
			Label.AnchorPoint = Vector2.new(0, 0.5)
			Label.TextColor3 = Color3.fromRGB(220, 220, 220)
			Label.TextSize = 16
			Label.Text = text
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Parent = Frame
			ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.ImageTransparency = 0.2
			ImageLabel.Position = UDim2.new(0, 15, 0.5, 0)
			ImageLabel.Size = UDim2.new(0, 18, 0, 18)
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel.Image = "rbxassetid://10723415903"
			ImageLabel.ImageColor3 = _G.Third
			
			function labelfunc:Set(newtext)
				Label.Text = newtext
			end
			
			return labelfunc
		end
		
		function main:Seperator(text)
			local Seperator = Instance.new("Frame")
			local Sep1 = Instance.new("TextLabel")
			local Sep2 = Instance.new("TextLabel")
			local Sep3 = Instance.new("TextLabel")

			Seperator.Name = "Seperator"
			Seperator.Parent = MainFramePage
			Seperator.BackgroundColor3 = _G.Primary
			Seperator.BackgroundTransparency = 1
			Seperator.Size = UDim2.new(1, 0, 0, 45)

			-- Enhanced Left Line with Gradient
			Sep1.Name = "Sep1"
			Sep1.Parent = Seperator
			Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep1.BackgroundTransparency = 0
			Sep1.AnchorPoint = Vector2.new(0, 0.5)
			Sep1.Position = UDim2.new(0, 0, 0.5, 0)
			Sep1.Size = UDim2.new(0.3, 0, 0, 3)
			Sep1.BorderSizePixel = 0
			Sep1.Text = ""
			CreateRounded(Sep1, 2)
			
			local Grad1 = CreateGradient(Sep1, ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
				ColorSequenceKeypoint.new(0.3, _G.Primary),
				ColorSequenceKeypoint.new(0.7, _G.Third),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
			}))

			-- Enhanced Center Text
			Sep2.Name = "Sep2"
			Sep2.Parent = Seperator
			Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep2.BackgroundTransparency = 1
			Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
			Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
			Sep2.Size = UDim2.new(1, 0, 0, 45)
			Sep2.Font = Enum.Font.GothamBold
			Sep2.Text = text
			Sep2.TextColor3 = Color3.fromRGB(240, 240, 240)
			Sep2.TextSize = 16

			-- Enhanced Right Line with Gradient
			Sep3.Name = "Sep3"
			Sep3.Parent = Seperator
			Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep3.BackgroundTransparency = 0
			Sep3.AnchorPoint = Vector2.new(1, 0.5)
			Sep3.Position = UDim2.new(1, 0, 0.5, 0)
			Sep3.Size = UDim2.new(0.3, 0, 0, 3)
			Sep3.BorderSizePixel = 0
			Sep3.Text = ""
			CreateRounded(Sep3, 2)
			
			local Grad3 = CreateGradient(Sep3, ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
				ColorSequenceKeypoint.new(0.3, _G.Third),
				ColorSequenceKeypoint.new(0.7, _G.Primary),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
			}))
		end
		
		function main:Line()
			local Linee = Instance.new("Frame")
			local Line = Instance.new("Frame")
			
			Linee.Name = "Linee"
			Linee.Parent = MainFramePage
			Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Linee.BackgroundTransparency = 1
			Linee.Position = UDim2.new(0, 0, 0.119999997, 0)
			Linee.Size = UDim2.new(1, 0, 0, 25)
			
			Line.Name = "Line"
			Line.Parent = Linee
			Line.BackgroundColor3 = Color3.new(125, 125, 125)
			Line.BorderSizePixel = 0
			Line.Position = UDim2.new(0, 0, 0, 12)
			Line.Size = UDim2.new(1, 0, 0, 3)
			CreateRounded(Line, 2)
			
			local UIGradient = CreateGradient(Line, ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
				ColorSequenceKeypoint.new(0.2, _G.Primary),
				ColorSequenceKeypoint.new(0.4, _G.Third),
				ColorSequenceKeypoint.new(0.6, _G.Accent),
				ColorSequenceKeypoint.new(0.8, _G.Primary),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
			}))
		end
		
		return main
	end
	
	return uitab
end

return Update
