-- XenHub Library - Improved Version with Search and Multi-Select
-- Features: Better organization, search functionality, multi-select dropdown

if (game:GetService("CoreGui")):FindFirstChild("Xenon") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
	(game:GetService("CoreGui")).Xenon:Destroy();
	(game:GetService("CoreGui")).ScreenGui:Destroy();
end

-- Global Configuration
_G.Primary = Color3.fromRGB(100, 100, 100)
_G.Dark = Color3.fromRGB(22, 22, 26)
_G.Third = Color3.fromRGB(255, 0, 0)

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

-- Utility Functions
local Utils = {}

function Utils.CreateRounded(Parent, Size)
	local Rounded = Instance.new("UICorner")
	Rounded.Name = "Rounded"
	Rounded.Parent = Parent
	Rounded.CornerRadius = UDim.new(0, Size)
	return Rounded
end

function Utils.MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	
	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {
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

function Utils.FilterOptions(options, searchText)
	if not searchText or searchText == "" then
		return options
	end
	
	local filtered = {}
	local lowerSearch = string.lower(searchText)
	
	for _, option in pairs(options) do
		if string.find(string.lower(tostring(option)), lowerSearch) then
			table.insert(filtered, option)
		end
	end
	
	return filtered
end

-- Toggle Button Creation
local function CreateToggleButton()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game.CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local OutlineButton = Instance.new("Frame")
	OutlineButton.Name = "OutlineButton"
	OutlineButton.Parent = ScreenGui
	OutlineButton.ClipsDescendants = true
	OutlineButton.BackgroundColor3 = _G.Dark
	OutlineButton.BackgroundTransparency = 0
	OutlineButton.Position = UDim2.new(0, 10, 0, 10)
	OutlineButton.Size = UDim2.new(0, 50, 0, 50)
	Utils.CreateRounded(OutlineButton, 12)
	
	local ImageButton = Instance.new("ImageButton")
	ImageButton.Parent = OutlineButton
	ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageButton.Size = UDim2.new(0, 40, 0, 40)
	ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageButton.BackgroundColor3 = _G.Dark
	ImageButton.ImageColor3 = Color3.fromRGB(250, 250, 250)
	ImageButton.ImageTransparency = 0
	ImageButton.BackgroundTransparency = 0
	ImageButton.Image = "rbxassetid://105059922903197"
	ImageButton.AutoButtonColor = false
	Utils.MakeDraggable(ImageButton, OutlineButton)
	Utils.CreateRounded(ImageButton, 10)
	
	ImageButton.MouseButton1Click:Connect(function()
		local xenonGui = game.CoreGui:FindFirstChild("Xenon")
		if xenonGui then
			xenonGui.Enabled = not xenonGui.Enabled
		end
	end)
end

-- Notification System
local NotificationSystem = {}
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function RemoveOldestNotification()
	if #NotificationList > 0 then
		local removed = table.remove(NotificationList, 1)
		removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
			removed[1]:Destroy()
		end)
	end
end

spawn(function()
	while wait() do
		if #NotificationList > 0 then
			wait(2)
			RemoveOldestNotification()
		end
	end
end)

function NotificationSystem:Notify(desc)
	local Frame = Instance.new("Frame")
	local Image = Instance.new("ImageLabel")
	local Title = Instance.new("TextLabel")
	local Desc = Instance.new("TextLabel")
	local OutlineFrame = Instance.new("Frame")
	
	OutlineFrame.Name = "OutlineFrame"
	OutlineFrame.Parent = NotificationFrame
	OutlineFrame.ClipsDescendants = true
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 1)
	OutlineFrame.BackgroundTransparency = 0.4
	OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
	OutlineFrame.Size = UDim2.new(0, 412, 0, 72)
	
	Frame.Name = "Frame"
	Frame.Parent = OutlineFrame
	Frame.ClipsDescendants = true
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundColor3 = _G.Dark
	Frame.BackgroundTransparency = 0.1
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 400, 0, 60)
	
	Image.Name = "Icon"
	Image.Parent = Frame
	Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Image.BackgroundTransparency = 1
	Image.Position = UDim2.new(0, 8, 0, 8)
	Image.Size = UDim2.new(0, 45, 0, 45)
	Image.Image = "rbxassetid://105059922903197"
	
	Title.Parent = Frame
	Title.BackgroundColor3 = _G.Primary
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 55, 0, 14)
	Title.Size = UDim2.new(0, 10, 0, 20)
	Title.Font = Enum.Font.GothamBold
	Title.Text = "Xenon"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	Desc.Parent = Frame
	Desc.BackgroundColor3 = _G.Primary
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0, 55, 0, 33)
	Desc.Size = UDim2.new(0, 10, 0, 10)
	Desc.Font = Enum.Font.GothamSemibold
	Desc.TextTransparency = 0.3
	Desc.Text = desc
	Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
	Desc.TextSize = 12
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	
	Utils.CreateRounded(Frame, 10)
	Utils.CreateRounded(OutlineFrame, 12)
	
	OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.1, 0), "Out", "Quad", 0.4, true)
	table.insert(NotificationList, {OutlineFrame, title})
end

-- Loading System
local LoadingSystem = {}

function LoadingSystem:StartLoad()
	local Loader = Instance.new("ScreenGui")
	Loader.Parent = game.CoreGui
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Loader.DisplayOrder = 1000
	
	local LoaderFrame = Instance.new("Frame")
	LoaderFrame.Name = "LoaderFrame"
	LoaderFrame.Parent = Loader
	LoaderFrame.ClipsDescendants = true
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	LoaderFrame.BackgroundTransparency = 0
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0)
	LoaderFrame.BorderSizePixel = 0
	
	local MainLoaderFrame = Instance.new("Frame")
	MainLoaderFrame.Name = "MainLoaderFrame"
	MainLoaderFrame.Parent = LoaderFrame
	MainLoaderFrame.ClipsDescendants = true
	MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	MainLoaderFrame.BackgroundTransparency = 0
	MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainLoaderFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
	MainLoaderFrame.BorderSizePixel = 0
	
	local TitleLoader = Instance.new("TextLabel")
	TitleLoader.Parent = MainLoaderFrame
	TitleLoader.Text = "Xenon"
	TitleLoader.Font = Enum.Font.FredokaOne
	TitleLoader.TextSize = 50
	TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLoader.BackgroundTransparency = 1
	TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0)
	TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0)
	TitleLoader.TextTransparency = 0
	
	local DescriptionLoader = Instance.new("TextLabel")
	DescriptionLoader.Parent = MainLoaderFrame
	DescriptionLoader.Text = "Loading.."
	DescriptionLoader.Font = Enum.Font.Gotham
	DescriptionLoader.TextSize = 15
	DescriptionLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
	DescriptionLoader.BackgroundTransparency = 1
	DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	DescriptionLoader.Position = UDim2.new(0.5, 0, 0.6, 0)
	DescriptionLoader.Size = UDim2.new(0.8, 0, 0.2, 0)
	DescriptionLoader.TextTransparency = 0
	
	local LoadingBarBackground = Instance.new("Frame")
	LoadingBarBackground.Parent = MainLoaderFrame
	LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
	LoadingBarBackground.Size = UDim2.new(0.7, 0, 0.05, 0)
	LoadingBarBackground.ClipsDescendants = true
	LoadingBarBackground.BorderSizePixel = 0
	LoadingBarBackground.ZIndex = 2
	
	local LoadingBar = Instance.new("Frame")
	LoadingBar.Parent = LoadingBarBackground
	LoadingBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	LoadingBar.Size = UDim2.new(0, 0, 1, 0)
	LoadingBar.ZIndex = 3
	
	Utils.CreateRounded(LoadingBarBackground, 20)
	Utils.CreateRounded(LoadingBar, 20)
	
	local tweenService = game:GetService("TweenService")
	local dotCount = 0
	local running = true
	
	local barTweenInfoPart1 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
		Size = UDim2.new(0.25, 0, 1, 0)
	})
	
	local barTweenInfoPart2 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
		Size = UDim2.new(1, 0, 1, 0)
	})
	
	barTweenPart1:Play()
	
	function LoadingSystem:Loaded()
		barTweenPart2:Play()
	end
	
	barTweenPart1.Completed:Connect(function()
		running = true
		barTweenPart2.Completed:Connect(function()
			wait(1)
			running = false
			DescriptionLoader.Text = "Loaded!"
			wait(0.5)
			Loader:Destroy()
		end)
	end)
	
	spawn(function()
		while running do
			dotCount = (dotCount + 1) % 4
			local dots = string.rep(".", dotCount)
			DescriptionLoader.Text = "Please wait" .. dots
			wait(0.5)
		end
	end)
end

-- Settings System
local SettingsLib = {
	SaveSettings = true,
	LoadAnimation = true
}

local function LoadConfig()
	if readfile and writefile and isfile and isfolder then
		if not isfolder("Xenon") then
			makefolder("Xenon")
		end
		if not isfolder("Xenon/Library/") then
			makefolder("Xenon/Library/")
		end
		if not isfile(("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(SettingsLib))
		else
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"))
			for i, v in pairs(Decode) do
				SettingsLib[i] = v
			end
		end
		print("Library Loaded!")
	else
		return warn("Status : Undetected Executor")
	end
end

local function SaveConfig()
	if readfile and writefile and isfile and isfolder then
		if not isfile(("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			LoadConfig()
		else
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"))
			local Array = {}
			for i, v in pairs(SettingsLib) do
				Array[i] = v
			end
			writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(Array))
		end
	else
		return warn("Status : Undetected Executor")
	end
end

LoadConfig()

-- Main Library
local XenHub = {}
XenHub.Notify = NotificationSystem.Notify
XenHub.StartLoad = LoadingSystem.StartLoad
XenHub.Loaded = LoadingSystem.Loaded

function XenHub:SaveSettings()
	if SettingsLib.SaveSettings then
		return true
	end
	return false
end

function XenHub:LoadAnimation()
	if SettingsLib.LoadAnimation then
		return true
	end
	return false
end

function XenHub:Window(Config)
	assert(Config.SubTitle, "SubTitle is required")
	
	local WindowConfig = {
		Size = Config.Size or UDim2.new(0, 600, 0, 400),
		TabWidth = Config.TabWidth or 150
	}
	
	local uihide = false
	local abc = false
	local currentpage = ""
	
	-- Create Main GUI
	local Xenon = Instance.new("ScreenGui")
	Xenon.Name = "Xenon"
	Xenon.Parent = game.CoreGui
	Xenon.DisplayOrder = 999
	
	local OutlineMain = Instance.new("Frame")
	OutlineMain.Name = "OutlineMain"
	OutlineMain.Parent = Xenon
	OutlineMain.ClipsDescendants = true
	OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	OutlineMain.BackgroundTransparency = 0.4
	OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
	OutlineMain.Size = UDim2.new(0, 0, 0, 0)
	Utils.CreateRounded(OutlineMain, 15)
	
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = OutlineMain
	Main.ClipsDescendants = true
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
	Main.BackgroundTransparency = 0
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = WindowConfig.Size
	
	OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true)
	Utils.CreateRounded(Main, 12)
	
	-- Create Top Bar
	local Top = Instance.new("Frame")
	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Top.Size = UDim2.new(1, 0, 0, 40)
	Top.BackgroundTransparency = 1
	Utils.CreateRounded(Top, 5)
	
	local NameHub = Instance.new("TextLabel")
	NameHub.Name = "NameHub"
	NameHub.Parent = Top
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameHub.BackgroundTransparency = 1
	NameHub.RichText = true
	NameHub.Position = UDim2.new(0, 15, 0.5, 0)
	NameHub.AnchorPoint = Vector2.new(0, 0.5)
	NameHub.Size = UDim2.new(0, 1, 0, 25)
	NameHub.Font = Enum.Font.GothamBold
	NameHub.Text = "Xenon"
	NameHub.TextSize = 20
	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameHub.TextXAlignment = Enum.TextXAlignment.Left
	
	local nameHubSize = TextService:GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge))
	NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25)
	
	local SubTitle = Instance.new("TextLabel")
	SubTitle.Name = "SubTitle"
	SubTitle.Parent = NameHub
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Position = UDim2.new(0, nameHubSize.X + 8, 0.5, 0)
	SubTitle.Size = UDim2.new(0, 1, 0, 20)
	SubTitle.Font = Enum.Font.Cartoon
	SubTitle.AnchorPoint = Vector2.new(0, 0.5)
	SubTitle.Text = Config.SubTitle
	SubTitle.TextSize = 15
	SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	
	local SubTitleSize = TextService:GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge))
	SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25)
	
	-- Control Buttons
	local CloseButton = Instance.new("ImageButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Top
	CloseButton.BackgroundColor3 = _G.Primary
	CloseButton.BackgroundTransparency = 1
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.Image = "rbxassetid://7743878857"
	CloseButton.ImageTransparency = 0
	CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
	Utils.CreateRounded(CloseButton, 3)
	
	CloseButton.MouseButton1Click:Connect(function()
		Xenon.Enabled = not Xenon.Enabled
	end)
	
	-- Tab System
	local Tab = Instance.new("Frame")
	Tab.Name = "Tab"
	Tab.Parent = Main
	Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Tab.Position = UDim2.new(0, 8, 0, Top.Size.Y.Offset)
	Tab.BackgroundTransparency = 1
	Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8)
	
	local ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = Tab
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	ScrollTab.Position = UDim2.new(0, 0, 0, 0)
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Size = UDim2.new(1, 0, 1, 0)
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y
	Utils.CreateRounded(Tab, 5)
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Name = "TabListLayout"
	TabListLayout.Parent = ScrollTab
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 2)
	
	local PPD = Instance.new("UIPadding")
	PPD.Name = "PPD"
	PPD.Parent = ScrollTab
	
	-- Page System
	local Page = Instance.new("Frame")
	Page.Name = "Page"
	Page.Parent = Main
	Page.BackgroundColor3 = _G.Dark
	Page.Position = UDim2.new(0, Tab.Size.X.Offset + 18, 0, Top.Size.Y.Offset)
	Page.Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 25, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8)
	Page.BackgroundTransparency = 1
	Utils.CreateRounded(Page, 3)
	
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
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical
	UIPageLayout.Padding = UDim.new(0, 10)
	UIPageLayout.TweenTime = 0
	UIPageLayout.GamepadInputEnabled = false
	UIPageLayout.ScrollWheelInputEnabled = false
	UIPageLayout.TouchInputEnabled = false
	
	Utils.MakeDraggable(Top, OutlineMain)
	
	-- Keybind Toggle
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Insert then
			Xenon.Enabled = not Xenon.Enabled
		end
	end)
	
	-- Update Canvas Sizes
	RunService.Stepped:Connect(function()
		pcall(function()
			ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
		end)
	end)
	
	-- Tab Creation Function
	local uitab = {}
	
	function uitab:Tab(text, img)
		local TabButton = Instance.new("TextButton")
		local Title = Instance.new("TextLabel")
		
		TabButton.Parent = ScrollTab
		TabButton.Name = text .. "Unique"
		TabButton.Text = ""
		TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.Font = Enum.Font.Nunito
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.TextSize = 12
		TabButton.TextTransparency = 0.9
		
		local SelectedTab = Instance.new("Frame")
		SelectedTab.Name = "SelectedTab"
		SelectedTab.Parent = TabButton
		SelectedTab.BackgroundColor3 = _G.Third
		SelectedTab.BackgroundTransparency = 0
		SelectedTab.Size = UDim2.new(0, 3, 0, 0)
		SelectedTab.Position = UDim2.new(0, 0, 0.5, 0)
		SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
		
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 100)
		UICorner.Parent = SelectedTab
		
		Title.Parent = TabButton
		Title.Name = "Title"
		Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 30, 0.5, 0)
		Title.Size = UDim2.new(0, 100, 0, 30)
		Title.Font = Enum.Font.Roboto
		Title.Text = text
		Title.AnchorPoint = Vector2.new(0, 0.5)
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextTransparency = 0.4
		Title.TextSize = 14
		Title.TextXAlignment = Enum.TextXAlignment.Left
		
		local IDK = Instance.new("ImageLabel")
		IDK.Name = "IDK"
		IDK.Parent = TabButton
		IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		IDK.BackgroundTransparency = 1
		IDK.ImageTransparency = 0.3
		IDK.Position = UDim2.new(0, 7, 0.5, 0)
		IDK.Size = UDim2.new(0, 15, 0, 15)
		IDK.AnchorPoint = Vector2.new(0, 0.5)
		IDK.Image = img or "rbxassetid://10723415903"
		
		Utils.CreateRounded(TabButton, 6)
		
		-- Create Page for Tab
		local MainFramePage = Instance.new("ScrollingFrame")
		MainFramePage.Name = text .. "_Page"
		MainFramePage.Parent = PageList
		MainFramePage.Active = true
		MainFramePage.BackgroundColor3 = _G.Dark
		MainFramePage.Position = UDim2.new(0, 0, 0, 0)
		MainFramePage.BackgroundTransparency = 1
		MainFramePage.Size = UDim2.new(1, 0, 1, 0)
		MainFramePage.ScrollBarThickness = 0
		MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y
		
		local UIPadding = Instance.new("UIPadding")
		local UIListLayout = Instance.new("UIListLayout")
		UIPadding.Parent = MainFramePage
		UIListLayout.Padding = UDim.new(0, 3)
		UIListLayout.Parent = MainFramePage
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		-- Tab Click Handler
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					}):Play()
					TweenService:Create(v.SelectedTab, TweenInfo.new(0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 0)
					}):Play()
					TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					}):Play()
				end
			end
			
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 3, 0, 15)
			}):Play()
			TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()
			TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
			
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page"
				if v.Name == currentpage then
					UIPageLayout:JumpTo(v)
				end
			end
		end)
		
		-- Auto-select first tab
		if abc == false then
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					}):Play()
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 15)
					}):Play()
					TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					}):Play()
					TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					}):Play()
				end
			end
			
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8
			}):Play()
			TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 3, 0, 15)
			}):Play()
			TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 0
			}):Play()
			TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0
			}):Play()
			
			UIPageLayout:JumpToIndex(1)
			abc = true
		end
		
		-- Update Canvas Size
		RunService.Stepped:Connect(function()
			pcall(function()
				MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
			end)
		end)
		
		-- Component Creation Functions
		local main = {}
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			local TextButton = Instance.new("TextButton")
			local Black = Instance.new("Frame")
			
			Button.Name = "Button"
			Button.Parent = MainFramePage
			Button.BackgroundColor3 = _G.Primary
			Button.BackgroundTransparency = 1
			Button.Size = UDim2.new(1, 0, 0, 36)
			Utils.CreateRounded(Button, 5)
			
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Parent = TextButton
			ImageLabel.BackgroundColor3 = _G.Primary
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			ImageLabel.Size = UDim2.new(0, 15, 0, 15)
			ImageLabel.Image = "rbxassetid://10734898355"
			ImageLabel.ImageTransparency = 0
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			Utils.CreateRounded(TextButton, 4)
			TextButton.Name = "TextButton"
			TextButton.Parent = Button
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			TextButton.BackgroundTransparency = 0.8
			TextButton.AnchorPoint = Vector2.new(1, 0.5)
			TextButton.Position = UDim2.new(1, -1, 0.5, 0)
			TextButton.Size = UDim2.new(0, 25, 0, 25)
			TextButton.Font = Enum.Font.Nunito
			TextButton.Text = ""
			TextButton.TextXAlignment = Enum.TextXAlignment.Left
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.TextSize = 15
			
			TextLabel.Name = "TextLabel"
			TextLabel.Parent = Button
			TextLabel.BackgroundColor3 = _G.Primary
			TextLabel.BackgroundTransparency = 1
			TextLabel.AnchorPoint = Vector2.new(0, 0.5)
			TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
			TextLabel.Size = UDim2.new(1, -50, 1, 0)
			TextLabel.Font = Enum.Font.Cartoon
			TextLabel.RichText = true
			TextLabel.Text = text
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextSize = 15
			TextLabel.ClipsDescendants = true
			
			local ArrowRight = Instance.new("ImageLabel")
			ArrowRight.Name = "ArrowRight"
			ArrowRight.Parent = Button
			ArrowRight.BackgroundColor3 = _G.Primary
			ArrowRight.BackgroundTransparency = 1
			ArrowRight.AnchorPoint = Vector2.new(0, 0.5)
			ArrowRight.Position = UDim2.new(0, 0, 0.5, 0)
			ArrowRight.Size = UDim2.new(0, 15, 0, 15)
			ArrowRight.Image = "rbxassetid://10709768347"
			ArrowRight.ImageTransparency = 0
			ArrowRight.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			Black.Name = "Black"
			Black.Parent = Button
			Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Black.BackgroundTransparency = 1
			Black.BorderSizePixel = 0
			Black.Position = UDim2.new(0, 0, 0, 0)
			Black.Size = UDim2.new(1, 0, 0, 33)
			Utils.CreateRounded(Black, 5)
			
			TextButton.MouseButton1Click:Connect(function()
				callback()
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
			Button.BackgroundColor3 = _G.Primary
			Button.BackgroundTransparency = 0.8
			Button.AutoButtonColor = false
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(0, 0, 0)
			Button.TextSize = 11
			Utils.CreateRounded(Button, 5)
			
			Title.Parent = Button
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, 0, 0, 35)
			Title.Font = Enum.Font.Cartoon
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 15
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.AnchorPoint = Vector2.new(0, 0.5)
			
			Desc.Parent = Title
			Desc.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			Desc.BackgroundTransparency = 1
			Desc.Position = UDim2.new(0, 0, 0, 22)
			Desc.Size = UDim2.new(0, 280, 0, 16)
			Desc.Font = Enum.Font.Gotham
			
			if desc then
				Desc.Text = desc
				Title.Position = UDim2.new(0, 15, 0.5, -5)
				Desc.Position = UDim2.new(0, 0, 0, 22)
				Button.Size = UDim2.new(1, 0, 0, 46)
			else
				Title.Position = UDim2.new(0, 15, 0.5, 0)
				Desc.Visible = false
				Button.Size = UDim2.new(1, 0, 0, 36)
			end
			
			Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
			Desc.TextSize = 10
			Desc.TextXAlignment = Enum.TextXAlignment.Left
			
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = Button
			ToggleFrame.BackgroundColor3 = _G.Dark
			ToggleFrame.BackgroundTransparency = 1
			ToggleFrame.Position = UDim2.new(1, -10, 0.5, 0)
			ToggleFrame.Size = UDim2.new(0, 35, 0, 20)
			ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
			Utils.CreateRounded(ToggleFrame, 10)
			
			ToggleImage.Name = "ToggleImage"
			ToggleImage.Parent = ToggleFrame
			ToggleImage.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			ToggleImage.BackgroundTransparency = 0.8
			ToggleImage.Position = UDim2.new(0, 0, 0, 0)
			ToggleImage.AnchorPoint = Vector2.new(0, 0)
			ToggleImage.Size = UDim2.new(1, 0, 1, 0)
			ToggleImage.Text = ""
			ToggleImage.AutoButtonColor = false
			Utils.CreateRounded(ToggleImage, 10)
			
			Circle.Name = "Circle"
			Circle.Parent = ToggleImage
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.BackgroundTransparency = 0
			Circle.Position = UDim2.new(0, 3, 0.5, 0)
			Circle.Size = UDim2.new(0, 14, 0, 14)
			Circle.AnchorPoint = Vector2.new(0, 0.5)
			Utils.CreateRounded(Circle, 10)
			
			ToggleImage.MouseButton1Click:Connect(function()
				if toggled == false then
					toggled = true
					Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Sine", 0.2, true)
					TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = _G.Third,
						BackgroundTransparency = 0
					}):Play()
				else
					toggled = false
					Circle:TweenPosition(UDim2.new(0, 4, 0.5, 0), "Out", "Sine", 0.2, true)
					TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(200, 200, 200),
						BackgroundTransparency = 0.8
					}):Play()
				end
				pcall(callback, toggled)
			end)
			
			if config == true then
				toggled = true
				Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Sine", 0.4, true)
				TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = _G.Third,
					BackgroundTransparency = 0
				}):Play()
				pcall(callback, toggled)
			end
		end
		
		-- Enhanced Dropdown with Search and Multi-Select
		function main:Dropdown(text, options, var, callback, multiSelect)
			multiSelect = multiSelect or false
			local isdropping = false
			local selectedItems = {}
			local filteredOptions = options
			local activeItem = var
			
			local Dropdown = Instance.new("Frame")
			local DropdownFrameScroll = Instance.new("Frame")
			local DropTitle = Instance.new("TextLabel")
			local DropScroll = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local UIPadding = Instance.new("UIPadding")
			local SelectItems = Instance.new("TextButton")
			local SearchBox = Instance.new("TextBox")
			
			Dropdown.Name = "Dropdown"
			Dropdown.Parent = MainFramePage
			Dropdown.BackgroundColor3 = _G.Primary
			Dropdown.BackgroundTransparency = 0.8
			Dropdown.ClipsDescendants = false
			Dropdown.Size = UDim2.new(1, 0, 0, 40)
			Utils.CreateRounded(Dropdown, 5)
			
			DropTitle.Name = "DropTitle"
			DropTitle.Parent = Dropdown
			DropTitle.BackgroundColor3 = _G.Primary
			DropTitle.BackgroundTransparency = 1
			DropTitle.Size = UDim2.new(1, 0, 0, 30)
			DropTitle.Font = Enum.Font.Cartoon
			DropTitle.Text = text
			DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropTitle.TextSize = 15
			DropTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropTitle.Position = UDim2.new(0, 15, 0, 5)
			DropTitle.AnchorPoint = Vector2.new(0, 0)
			
			SelectItems.Name = "SelectItems"
			SelectItems.Parent = Dropdown
			SelectItems.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
			SelectItems.TextColor3 = Color3.fromRGB(255, 255, 255)
			SelectItems.BackgroundTransparency = 0
			SelectItems.Position = UDim2.new(1, -5, 0, 5)
			SelectItems.Size = UDim2.new(0, 100, 0, 30)
			SelectItems.AnchorPoint = Vector2.new(1, 0)
			SelectItems.Font = Enum.Font.GothamMedium
			SelectItems.AutoButtonColor = false
			SelectItems.TextSize = 9
			SelectItems.ZIndex = 1
			SelectItems.ClipsDescendants = true
			SelectItems.Text = multiSelect and "   Select Items" or "   Select Item"
			SelectItems.TextXAlignment = Enum.TextXAlignment.Left
			
			local ArrowDown = Instance.new("ImageLabel")
			ArrowDown.Name = "ArrowDown"
			ArrowDown.Parent = Dropdown
			ArrowDown.BackgroundColor3 = _G.Primary
			ArrowDown.BackgroundTransparency = 1
			ArrowDown.AnchorPoint = Vector2.new(1, 0)
			ArrowDown.Position = UDim2.new(1, -110, 0, 10)
			ArrowDown.Size = UDim2.new(0, 20, 0, 20)
			ArrowDown.Image = "rbxassetid://10709790948"
			ArrowDown.ImageTransparency = 0
			ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			Utils.CreateRounded(SelectItems, 5)
			
			DropdownFrameScroll.Name = "DropdownFrameScroll"
			DropdownFrameScroll.Parent = Dropdown
			DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
			DropdownFrameScroll.BackgroundTransparency = 0
			DropdownFrameScroll.ClipsDescendants = true
			DropdownFrameScroll.Size = UDim2.new(1, 0, 0, 130)
			DropdownFrameScroll.Position = UDim2.new(0, 5, 0, 40)
			DropdownFrameScroll.Visible = false
			DropdownFrameScroll.AnchorPoint = Vector2.new(0, 0)
			Utils.CreateRounded(DropdownFrameScroll, 5)
			
			-- Search Box
			SearchBox.Name = "SearchBox"
			SearchBox.Parent = DropdownFrameScroll
			SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 42)
			SearchBox.BackgroundTransparency = 0
			SearchBox.Position = UDim2.new(0, 10, 0, 5)
			SearchBox.Size = UDim2.new(1, -20, 0, 25)
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.PlaceholderText = "Search..."
			SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			SearchBox.Text = ""
			SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			SearchBox.TextSize = 12
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left
			Utils.CreateRounded(SearchBox, 5)
			
			local SearchPadding = Instance.new("UIPadding")
			SearchPadding.Parent = SearchBox
			SearchPadding.PaddingLeft = UDim.new(0, 8)
			
			DropScroll.Name = "DropScroll"
			DropScroll.Parent = DropdownFrameScroll
			DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y
			DropScroll.Active = true
			DropScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropScroll.BackgroundTransparency = 1
			DropScroll.BorderSizePixel = 0
			DropScroll.Position = UDim2.new(0, 0, 0, 35)
			DropScroll.Size = UDim2.new(1, 0, 0, 90)
			DropScroll.AnchorPoint = Vector2.new(0, 0)
			DropScroll.ClipsDescendants = true
			DropScroll.ScrollBarThickness = 3
			DropScroll.ZIndex = 3
			
			local PaddingDrop = Instance.new("UIPadding")
			PaddingDrop.PaddingLeft = UDim.new(0, 10)
			PaddingDrop.PaddingRight = UDim.new(0, 10)
			PaddingDrop.Parent = DropScroll
			PaddingDrop.Name = "PaddingDrop"
			
			UIListLayout.Parent = DropScroll
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 1)
			
			UIPadding.Parent = DropScroll
			UIPadding.PaddingLeft = UDim.new(0, 5)
			
			-- Function to create dropdown items
			local function CreateDropdownItem(option)
				local Item = Instance.new("TextButton")
				local ItemPadding = Instance.new("UIPadding")
				local SelectedItems = Instance.new("Frame")
				local Checkbox = Instance.new("Frame")
				
				Item.Name = "Item"
				Item.Parent = DropScroll
				Item.BackgroundColor3 = _G.Primary
				Item.BackgroundTransparency = 1
				Item.Size = UDim2.new(1, 0, 0, 30)
				Item.Font = Enum.Font.Nunito
				Item.Text = tostring(option)
				Item.TextColor3 = Color3.fromRGB(255, 255, 255)
				Item.TextSize = 13
				Item.TextTransparency = 0.5
				Item.TextXAlignment = Enum.TextXAlignment.Left
				Item.ZIndex = 4
				
				ItemPadding.Parent = Item
				ItemPadding.PaddingLeft = UDim.new(0, multiSelect and 25 or 8)
				
				Utils.CreateRounded(Item, 5)
				
				SelectedItems.Name = "SelectedItems"
				SelectedItems.Parent = Item
				SelectedItems.BackgroundColor3 = _G.Third
				SelectedItems.BackgroundTransparency = 1
				SelectedItems.Size = UDim2.new(0, 3, 0.4, 0)
				SelectedItems.Position = UDim2.new(0, -8, 0.5, 0)
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5)
				SelectedItems.ZIndex = 4
				Utils.CreateRounded(SelectedItems, 999)
				
				-- Multi-select checkbox
				if multiSelect then
					Checkbox.Name = "Checkbox"
					Checkbox.Parent = Item
					Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
					Checkbox.BackgroundTransparency = 0
					Checkbox.Position = UDim2.new(0, -20, 0.5, 0)
					Checkbox.Size = UDim2.new(0, 15, 0, 15)
					Checkbox.AnchorPoint = Vector2.new(0, 0.5)
					Checkbox.ZIndex = 4
					Utils.CreateRounded(Checkbox, 3)
					
					local CheckIcon = Instance.new("ImageLabel")
					CheckIcon.Name = "CheckIcon"
					CheckIcon.Parent = Checkbox
					CheckIcon.BackgroundTransparency = 1
					CheckIcon.Size = UDim2.new(1, 0, 1, 0)
					CheckIcon.Image = "rbxassetid://10709790644"
					CheckIcon.ImageTransparency = 1
					CheckIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
					CheckIcon.ZIndex = 5
				end
				
				-- Handle item selection
				Item.MouseButton1Click:Connect(function()
					if multiSelect then
						local isSelected = table.find(selectedItems, tostring(option))
						if isSelected then
							-- Remove from selection
							table.remove(selectedItems, isSelected)
							Item.BackgroundTransparency = 1
							Item.TextTransparency = 0.5
							SelectedItems.BackgroundTransparency = 1
							if Checkbox then
								Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
								Checkbox:FindFirstChild("CheckIcon").ImageTransparency = 1
							end
						else
							-- Add to selection
							table.insert(selectedItems, tostring(option))
							Item.BackgroundTransparency = 0.8
							Item.TextTransparency = 0
							SelectedItems.BackgroundTransparency = 0
							if Checkbox then
								Checkbox.BackgroundColor3 = _G.Third
								Checkbox:FindFirstChild("CheckIcon").ImageTransparency = 0
							end
						end
						
						-- Update display text
						if #selectedItems > 0 then
							SelectItems.Text = "   " .. #selectedItems .. " selected"
						else
							SelectItems.Text = "   Select Items"
						end
						
						pcall(callback, selectedItems)
					else
						-- Single select
						SelectItems.ClipsDescendants = true
						callback(Item.Text)
						activeItem = Item.Text
						
						-- Update visual state
						for i, v in next, DropScroll:GetChildren() do
							if v:IsA("TextButton") then
								local itemSelectedItems = v:FindFirstChild("SelectedItems")
								if activeItem == v.Text then
									v.BackgroundTransparency = 0.8
									v.TextTransparency = 0
									if itemSelectedItems then
										itemSelectedItems.BackgroundTransparency = 0
									end
								else
									v.BackgroundTransparency = 1
									v.TextTransparency = 0.5
									if itemSelectedItems then
										itemSelectedItems.BackgroundTransparency = 1
									end
								end
							end
						end
						
						SelectItems.Text = "   " .. Item.Text
					end
				end)
				
				return Item
			end
			
			-- Function to refresh dropdown items
			local function RefreshDropdown()
				-- Clear existing items
				for _, child in pairs(DropScroll:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end
				
				-- Create new items based on filtered options
				for _, option in pairs(filteredOptions) do
					local item = CreateDropdownItem(option)
					
					-- Restore selection state for multi-select
					if multiSelect and table.find(selectedItems, tostring(option)) then
						item.BackgroundTransparency = 0.8
						item.TextTransparency = 0
						item:FindFirstChild("SelectedItems").BackgroundTransparency = 0
						local checkbox = item:FindFirstChild("Checkbox")
						if checkbox then
							checkbox.BackgroundColor3 = _G.Third
							checkbox:FindFirstChild("CheckIcon").ImageTransparency = 0
						end
					elseif not multiSelect and activeItem == tostring(option) then
						item.BackgroundTransparency = 0.8
						item.TextTransparency = 0
						item:FindFirstChild("SelectedItems").BackgroundTransparency = 0
					end
				end
				
				DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
			end
			
			-- Search functionality
			SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
				filteredOptions = Utils.FilterOptions(options, SearchBox.Text)
				RefreshDropdown()
			end)
			
			-- Initialize dropdown
			if var then
				if multiSelect then
					if type(var) == "table" then
						selectedItems = var
						SelectItems.Text = "   " .. #selectedItems .. " selected"
					else
						selectedItems = {tostring(var)}
						SelectItems.Text = "   1 selected"
					end
				else
					activeItem = tostring(var)
					SelectItems.Text = "   " .. var
				end
				pcall(callback, multiSelect and selectedItems or var)
			end
			
			RefreshDropdown()
			
			-- Toggle dropdown
			SelectItems.MouseButton1Click:Connect(function()
				if isdropping == false then
					isdropping = true
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, -10, 0, 130),
						Visible = true
					}):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 175)
					}):Play()
					TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 180
					}):Play()
				else
					isdropping = false
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, -10, 0, 0),
						Visible = false
					}):Play()
					TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 40)
					}):Play()
					TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 0
					}):Play()
				end
			end)
			
			-- Dropdown functions
			local dropfunc = {}
			
			function dropfunc:Add(t)
				table.insert(options, t)
				filteredOptions = Utils.FilterOptions(options, SearchBox.Text)
				RefreshDropdown()
			end
			
			function dropfunc:Remove(t)
				local index = table.find(options, t)
				if index then
					table.remove(options, index)
					filteredOptions = Utils.FilterOptions(options, SearchBox.Text)
					RefreshDropdown()
				end
			end
			
			function dropfunc:Clear()
				options = {}
				selectedItems = {}
				filteredOptions = {}
				activeItem = nil
				SelectItems.Text = multiSelect and "   Select Items" or "   Select Item"
				isdropping = false
				DropdownFrameScroll.Visible = false
				RefreshDropdown()
			end
			
			function dropfunc:GetSelected()
				return multiSelect and selectedItems or activeItem
			end
			
			function dropfunc:SetSelected(value)
				if multiSelect then
					selectedItems = type(value) == "table" and value or {tostring(value)}
					SelectItems.Text = "   " .. #selectedItems .. " selected"
				else
					activeItem = tostring(value)
					SelectItems.Text = "   " .. value
				end
				RefreshDropdown()
				pcall(callback, multiSelect and selectedItems or activeItem)
			end
			
			return dropfunc
		end
		
		function main:Slider(text, min, max, set, callback)
			local Value = set
			
			local Slider = Instance.new("Frame")
			local sliderr = Instance.new("Frame")
			local Title = Instance.new("TextLabel")
			local ValueText = Instance.new("TextLabel")
			local bar = Instance.new("Frame")
			local bar1 = Instance.new("Frame")
			local circlebar = Instance.new("Frame")
			
			Slider.Name = "Slider"
			Slider.Parent = MainFramePage
			Slider.BackgroundColor3 = _G.Primary
			Slider.BackgroundTransparency = 1
			Slider.Size = UDim2.new(1, 0, 0, 35)
			Utils.CreateRounded(Slider, 5)
			
			sliderr.Name = "sliderr"
			sliderr.Parent = Slider
			sliderr.BackgroundColor3 = _G.Primary
			sliderr.BackgroundTransparency = 0.8
			sliderr.Position = UDim2.new(0, 0, 0, 0)
			sliderr.Size = UDim2.new(1, 0, 0, 35)
			Utils.CreateRounded(sliderr, 5)
			
			Title.Parent = sliderr
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			Title.BackgroundTransparency = 1
			Title.Position = UDim2.new(0, 15, 0.5, 0)
			Title.Size = UDim2.new(1, 0, 0, 30)
			Title.Font = Enum.Font.Cartoon
			Title.Text = text
			Title.AnchorPoint = Vector2.new(0, 0.5)
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 15
			Title.TextXAlignment = Enum.TextXAlignment.Left
			
			ValueText.Parent = bar
			ValueText.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
			ValueText.BackgroundTransparency = 1
			ValueText.Position = UDim2.new(0, -38, 0.5, 0)
			ValueText.Size = UDim2.new(0, 30, 0, 30)
			ValueText.Font = Enum.Font.GothamMedium
			ValueText.Text = set
			ValueText.AnchorPoint = Vector2.new(0, 0.5)
			ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValueText.TextSize = 12
			ValueText.TextXAlignment = Enum.TextXAlignment.Right
			
			bar.Name = "bar"
			bar.Parent = sliderr
			bar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			bar.Size = UDim2.new(0, 100, 0, 4)
			bar.Position = UDim2.new(1, -10, 0.5, 0)
			bar.BackgroundTransparency = 0.8
			bar.AnchorPoint = Vector2.new(1, 0.5)
			Utils.CreateRounded(bar, 5)
			
			bar1.Name = "bar1"
			bar1.Parent = bar
			bar1.BackgroundColor3 = _G.Third
			bar1.BackgroundTransparency = 0
			bar1.Size = UDim2.new(set / max, 0, 0, 4)
			Utils.CreateRounded(bar1, 5)
			
			circlebar.Name = "circlebar"
			circlebar.Parent = bar1
			circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			circlebar.Position = UDim2.new(1, 0, 0, -5)
			circlebar.AnchorPoint = Vector2.new(0.5, 0)
			circlebar.Size = UDim2.new(0, 13, 0, 13)
			Utils.CreateRounded(circlebar, 100)
			
			if Value == nil then
				Value = set
				pcall(function()
					callback(Value)
				end)
			end
			
			local Dragging = false
			
			circlebar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
				end
			end)
			
			bar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
				end
			end)
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					Value = math.floor((tonumber(max) - tonumber(min)) / 100 * bar1.AbsoluteSize.X + tonumber(min)) or 0
					pcall(function()
						callback(Value)
					end)
					ValueText.Text = Value
					bar1.Size = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X, 0, 100), 0, 4)
					circlebar.Position = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X - 5, 0, 100), 0, -5)
				end
			end)
		end
		
		function main:Textbox(text, disappear, callback)
			local Textbox = Instance.new("Frame")
			local TextboxLabel = Instance.new("TextLabel")
			local RealTextbox = Instance.new("TextBox")
			
			Textbox.Name = "Textbox"
			Textbox.Parent = MainFramePage
			Textbox.BackgroundColor3 = _G.Primary
			Textbox.BackgroundTransparency = 0.8
			Textbox.Size = UDim2.new(1, 0, 0, 35)
			Utils.CreateRounded(Textbox, 5)
			
			TextboxLabel.Name = "TextboxLabel"
			TextboxLabel.Parent = Textbox
			TextboxLabel.BackgroundColor3 = _G.Primary
			TextboxLabel.BackgroundTransparency = 1
			TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0)
			TextboxLabel.Text = text
			TextboxLabel.Size = UDim2.new(1, 0, 0, 35)
			TextboxLabel.Font = Enum.Font.Nunito
			TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)
			TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextboxLabel.TextSize = 15
			TextboxLabel.TextTransparency = 0
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
			
			RealTextbox.Name = "RealTextbox"
			RealTextbox.Parent = Textbox
			RealTextbox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			RealTextbox.BackgroundTransparency = 0.8
			RealTextbox.Position = UDim2.new(1, -5, 0.5, 0)
			RealTextbox.AnchorPoint = Vector2.new(1, 0.5)
			RealTextbox.Size = UDim2.new(0, 80, 0, 25)
			RealTextbox.Font = Enum.Font.Gotham
			RealTextbox.Text = ""
			RealTextbox.TextColor3 = Color3.fromRGB(225, 225, 225)
			RealTextbox.TextSize = 11
			RealTextbox.TextTransparency = 0
			RealTextbox.ClipsDescendants = true
			Utils.CreateRounded(RealTextbox, 5)
			
			RealTextbox.FocusLost:Connect(function()
				callback(RealTextbox.Text)
			end)
		end
		
		function main:Label(text)
			local Frame = Instance.new("Frame")
			local Label = Instance.new("TextLabel")
			local labelfunc = {}
			
			Frame.Name = "Frame"
			Frame.Parent = MainFramePage
			Frame.BackgroundColor3 = _G.Primary
			Frame.BackgroundTransparency = 1
			Frame.Size = UDim2.new(1, 0, 0, 30)
			
			Label.Name = "Label"
			Label.Parent = Frame
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, -30, 0, 30)
			Label.Font = Enum.Font.Nunito
			Label.Position = UDim2.new(0, 30, 0.5, 0)
			Label.AnchorPoint = Vector2.new(0, 0.5)
			Label.TextColor3 = Color3.fromRGB(225, 225, 225)
			Label.TextSize = 15
			Label.Text = text
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Parent = Frame
			ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.ImageTransparency = 0
			ImageLabel.Position = UDim2.new(0, 10, 0.5, 0)
			ImageLabel.Size = UDim2.new(0, 14, 0, 14)
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel.Image = "rbxassetid://10723415903"
			ImageLabel.ImageColor3 = Color3.fromRGB(200, 200, 200)
			
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
			Seperator.Size = UDim2.new(1, 0, 0, 36)
			
			-- Left Line
			Sep1.Name = "Sep1"
			Sep1.Parent = Seperator
			Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep1.BackgroundTransparency = 0
			Sep1.AnchorPoint = Vector2.new(0, 0.5)
			Sep1.Position = UDim2.new(0, 0, 0.5, 0)
			Sep1.Size = UDim2.new(0.15, 0, 0, 1)
			Sep1.BorderSizePixel = 0
			Sep1.Text = ""
			
			local Grad1 = Instance.new("UIGradient")
			Grad1.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Primary),
				ColorSequenceKeypoint.new(0.5, _G.Primary),
				ColorSequenceKeypoint.new(0.6, _G.Primary),
				ColorSequenceKeypoint.new(1, _G.Dark)
			})
			Grad1.Parent = Sep1
			
			-- Center Text
			Sep2.Name = "Sep2"
			Sep2.Parent = Seperator
			Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep2.BackgroundTransparency = 1
			Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
			Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
			Sep2.Size = UDim2.new(1, 0, 0, 36)
			Sep2.Font = Enum.Font.GothamBold
			Sep2.Text = text
			Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Sep2.TextSize = 14
			
			-- Right Line
			Sep3.Name = "Sep3"
			Sep3.Parent = Seperator
			Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sep3.BackgroundTransparency = 0
			Sep3.AnchorPoint = Vector2.new(1, 0.5)
			Sep3.Position = UDim2.new(1, 0, 0.5, 0)
			Sep3.Size = UDim2.new(0.15, 0, 0, 1)
			Sep3.BorderSizePixel = 0
			Sep3.Text = ""
			
			local Grad3 = Instance.new("UIGradient")
			Grad3.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Primary),
				ColorSequenceKeypoint.new(0.5, _G.Primary),
				ColorSequenceKeypoint.new(0.6, _G.Primary),
				ColorSequenceKeypoint.new(1, _G.Dark)
			})
			Grad3.Parent = Sep3
		end
		
		function main:Line()
			local Linee = Instance.new("Frame")
			local Line = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient")
			
			Linee.Name = "Linee"
			Linee.Parent = MainFramePage
			Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Linee.BackgroundTransparency = 1
			Linee.Position = UDim2.new(0, 0, 0.119999997, 0)
			Linee.Size = UDim2.new(1, 0, 0, 20)
			
			Line.Name = "Line"
			Line.Parent = Linee
			Line.BackgroundColor3 = Color3.new(125, 125, 125)
			Line.BorderSizePixel = 0
			Line.Position = UDim2.new(0, 0, 0, 10)
			Line.Size = UDim2.new(1, 0, 0, 1)
			
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.4, _G.Primary),
				ColorSequenceKeypoint.new(0.5, _G.Primary),
				ColorSequenceKeypoint.new(0.6, _G.Primary),
				ColorSequenceKeypoint.new(1, _G.Dark)
			})
			UIGradient.Parent = Line
		end
		
		return main
	end
	
	return uitab
end

-- Initialize toggle button
CreateToggleButton()

return XenHub
