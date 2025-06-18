if (game:GetService("CoreGui")):FindFirstChild("Xenon") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
	(game:GetService("CoreGui")).Xenon:Destroy();
	(game:GetService("CoreGui")).ScreenGui:Destroy();
end;

-- Enhanced Color Scheme
_G.Primary = Color3.fromRGB(45, 45, 50);
_G.Dark = Color3.fromRGB(18, 18, 22);
_G.Third = Color3.fromRGB(255, 64, 64);
_G.Accent = Color3.fromRGB(100, 200, 255);
_G.Success = Color3.fromRGB(64, 255, 64);
_G.Warning = Color3.fromRGB(255, 200, 64);

-- Services
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;

-- Enhanced Device Detection with better PC/Mobile differentiation
local IsMobile = false;
local IsTablet = false;
local IsPC = true;

-- More accurate device detection
if UserInputService.TouchEnabled then
	if UserInputService.KeyboardEnabled then
		-- Has both touch and keyboard - likely tablet or convertible
		IsTablet = true;
		IsMobile = false;
		IsPC = false;
	else
		-- Touch only - mobile device
		IsMobile = true;
		IsTablet = false;
		IsPC = false;
	end
else
	-- No touch - desktop PC
	IsMobile = false;
	IsTablet = false;
	IsPC = true;
end

-- Additional check for screen size to better detect device type
local ViewportSize = workspace.CurrentCamera.ViewportSize;
if ViewportSize.X < 768 or ViewportSize.Y < 768 then
	IsMobile = true;
	IsPC = false;
	IsTablet = false;
elseif ViewportSize.X < 1024 then
	IsTablet = true;
	IsMobile = false;
	IsPC = false;
else
	IsPC = true;
	IsMobile = false;
	IsTablet = false;
end

-- Dynamic sizing based on device type
local function GetDeviceSize(mobileSize, tabletSize, pcSize)
	if IsMobile then
		return mobileSize;
	elseif IsTablet then
		return tabletSize or pcSize;
	else
		return pcSize;
	end
end

-- Enhanced Rounded Corner Function
function CreateRounded(Parent, Size, Gradient)
	local Rounded = Instance.new("UICorner");
	Rounded.Name = "Rounded";
	Rounded.Parent = Parent;
	Rounded.CornerRadius = UDim.new(0, Size);
	
	if Gradient then
		local UIGradient = Instance.new("UIGradient");
		UIGradient.Color = Gradient;
		UIGradient.Parent = Parent;
	end
end;

-- Enhanced Dragging with Faster Animation (Fixed slow animation issue)
function MakeDraggable(topbarobject, object)
	local Dragging = nil;
	local DragInput = nil;
	local DragStart = nil;
	local StartPosition = nil;
	
	local function Update(input)
		local Delta = input.Position - DragStart;
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
		-- FIXED: Reduced tween time from 0.2 to 0.05 for faster response
		local Tween = TweenService:Create(object, TweenInfo.new(0.05, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = pos
		});
		Tween:Play();
	end;
	
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
			DragStart = input.Position;
			StartPosition = object.Position;
			
			-- FIXED: Faster drag start animation
			TweenService:Create(object, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(object.Size.X.Scale, object.Size.X.Offset + 2, object.Size.Y.Scale, object.Size.Y.Offset + 2)
			}):Play();
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false;
					-- FIXED: Faster drag end animation
					TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(object.Size.X.Scale, object.Size.X.Offset - 2, object.Size.Y.Scale, object.Size.Y.Offset - 2)
					}):Play();
				end;
			end);
		end;
	end);
	
	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input;
		end;
	end);
	
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input);
		end;
	end);
end;

-- Enhanced Screen GUI with better device support
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Parent = game.CoreGui;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.ResetOnSpawn = false;

-- FIXED: Better device-specific sizing for toggle button
local buttonSize = GetDeviceSize(60, 55, 50);
local buttonIconSize = GetDeviceSize(45, 40, 35);
local buttonPosition = GetDeviceSize(15, 12, 10);

local OutlineButton = Instance.new("Frame");
OutlineButton.Name = "OutlineButton";
OutlineButton.Parent = ScreenGui;
OutlineButton.ClipsDescendants = true;
OutlineButton.BackgroundColor3 = _G.Dark;
OutlineButton.BackgroundTransparency = 0.1;
OutlineButton.Position = UDim2.new(0, buttonPosition, 0, buttonPosition);
OutlineButton.Size = UDim2.new(0, buttonSize, 0, buttonSize);
CreateRounded(OutlineButton, GetDeviceSize(15, 12, 10));

-- Add glow effect
local UIStroke = Instance.new("UIStroke");
UIStroke.Parent = OutlineButton;
UIStroke.Color = _G.Third;
UIStroke.Thickness = GetDeviceSize(3, 2, 2);
UIStroke.Transparency = 0.7;

local ImageButton = Instance.new("ImageButton");
ImageButton.Parent = OutlineButton;
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0);
ImageButton.Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize);
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
ImageButton.BackgroundColor3 = _G.Dark;
ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
ImageButton.ImageTransparency = 0;
ImageButton.BackgroundTransparency = 0;
ImageButton.Image = "rbxassetid://105059922903197";
ImageButton.AutoButtonColor = false;
MakeDraggable(ImageButton, OutlineButton);
CreateRounded(ImageButton, GetDeviceSize(12, 10, 8));

-- FIXED: Faster button animations
ImageButton.MouseEnter:Connect(function()
	if IsPC then -- Only animate on PC for better performance
		TweenService:Create(ImageButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, buttonIconSize + 3, 0, buttonIconSize + 3),
			ImageColor3 = _G.Third
		}):Play();
		TweenService:Create(UIStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.3
		}):Play();
	end
end);

ImageButton.MouseLeave:Connect(function()
	if IsPC then
		TweenService:Create(ImageButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize),
			ImageColor3 = Color3.fromRGB(255, 255, 255)
		}):Play();
		TweenService:Create(UIStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.7
		}):Play();
	end
end);

ImageButton.MouseButton1Click:connect(function()
	-- FIXED: Faster click animation
	TweenService:Create(ImageButton, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, buttonIconSize - 3, 0, buttonIconSize - 3)
	}):Play();
	
	wait(0.05);
	
	TweenService:Create(ImageButton, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize)
	}):Play();
	
	(game.CoreGui:FindFirstChild("Xenon")).Enabled = not (game.CoreGui:FindFirstChild("Xenon")).Enabled;
end);

-- Enhanced Notification System with faster animations
local NotificationFrame = Instance.new("ScreenGui");
NotificationFrame.Name = "NotificationFrame";
NotificationFrame.Parent = game.CoreGui;
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global;
NotificationFrame.ResetOnSpawn = false;

local NotificationList = {};
local MaxNotifications = 5;

local function RemoveOldestNotification()
	if #NotificationList > 0 then
		local removed = table.remove(NotificationList, 1);
		
		-- FIXED: Faster exit animation
		local exitTween = TweenService:Create(removed[1], TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = UDim2.new(1.2, 0, removed[1].Position.Y.Scale, removed[1].Position.Y.Offset),
			Size = UDim2.new(0, 0, 0, removed[1].Size.Y.Offset)
		});
		
		exitTween:Play();
		exitTween.Completed:Connect(function()
			removed[1]:Destroy();
		end);
		
		-- Reposition remaining notifications with faster animation
		for i, notification in ipairs(NotificationList) do
			TweenService:Create(notification[1], TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(0.5, 0, 0.1 + (i-1) * 0.12, 0)
			}):Play();
		end
	end;
end;

-- Auto-remove notifications
spawn(function()
	while wait() do
		if #NotificationList > 0 then
			wait(3); -- Reduced display time for faster cycling
			RemoveOldestNotification();
		end;
	end;
end);

local Update = {};

function Update:Notify(desc, notifType)
	-- Remove oldest if too many notifications
	if #NotificationList >= MaxNotifications then
		RemoveOldestNotification();
	end
	
	local Frame = Instance.new("Frame");
	local Image = Instance.new("ImageLabel");
	local Title = Instance.new("TextLabel");
	local Desc = Instance.new("TextLabel");
	local OutlineFrame = Instance.new("Frame");
	local CloseButton = Instance.new("TextButton");
	
	-- Notification type colors
	local typeColor = _G.Third;
	local typeIcon = "rbxassetid://105059922903197";
	
	if notifType == "success" then
		typeColor = _G.Success;
		typeIcon = "rbxassetid://10709769841";
	elseif notifType == "warning" then
		typeColor = _G.Warning;
		typeIcon = "rbxassetid://10709761530";
	elseif notifType == "info" then
		typeColor = _G.Accent;
		typeIcon = "rbxassetid://10709769841";
	end
	
	-- FIXED: Better responsive sizing for notifications
	local notifWidth = GetDeviceSize(350, 400, 420);
	local notifHeight = GetDeviceSize(65, 70, 75);
	
	OutlineFrame.Name = "OutlineFrame";
	OutlineFrame.Parent = NotificationFrame;
	OutlineFrame.ClipsDescendants = true;
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 1);
	OutlineFrame.BackgroundTransparency = 0.1;
	OutlineFrame.Position = UDim2.new(1.2, 0, 0.1 + #NotificationList * 0.12, 0);
	OutlineFrame.Size = UDim2.new(0, notifWidth, 0, notifHeight);
	
	-- Add border glow
	local NotifStroke = Instance.new("UIStroke");
	NotifStroke.Parent = OutlineFrame;
	NotifStroke.Color = typeColor;
	NotifStroke.Thickness = 1.5;
	NotifStroke.Transparency = 0.5;
	
	Frame.Name = "Frame";
	Frame.Parent = OutlineFrame;
	Frame.ClipsDescendants = true;
	Frame.AnchorPoint = Vector2.new(0.5, 0.5);
	Frame.BackgroundColor3 = _G.Dark;
	Frame.BackgroundTransparency = 0.05;
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
	Frame.Size = UDim2.new(1, -6, 1, -6);
	
	local iconSize = GetDeviceSize(35, 38, 40);
	local iconPos = GetDeviceSize(12, 12, 12);
	
	Image.Name = "Icon";
	Image.Parent = Frame;
	Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	Image.BackgroundTransparency = 1;
	Image.Position = UDim2.new(0, iconPos, 0, iconPos);
	Image.Size = UDim2.new(0, iconSize, 0, iconSize);
	Image.Image = typeIcon;
	Image.ImageColor3 = typeColor;
	
	local titleSize = GetDeviceSize(14, 15, 16);
	local titlePosX = GetDeviceSize(55, 58, 60);
	local titlePosY = GetDeviceSize(8, 10, 12);
	
	Title.Parent = Frame;
	Title.BackgroundColor3 = _G.Primary;
	Title.BackgroundTransparency = 1;
	Title.Position = UDim2.new(0, titlePosX, 0, titlePosY);
	Title.Size = UDim2.new(1, -titlePosX - 30, 0, 22);
	Title.Font = Enum.Font.GothamBold;
	Title.Text = "Xenon Hub";
	Title.TextColor3 = Color3.fromRGB(255, 255, 255);
	Title.TextSize = titleSize;
	Title.TextXAlignment = Enum.TextXAlignment.Left;
	
	local descSize = GetDeviceSize(11, 12, 13);
	local descPosY = GetDeviceSize(28, 32, 35);
	
	Desc.Parent = Frame;
	Desc.BackgroundColor3 = _G.Primary;
	Desc.BackgroundTransparency = 1;
	Desc.Position = UDim2.new(0, titlePosX, 0, descPosY);
	Desc.Size = UDim2.new(1, -titlePosX - 30, 0, GetDeviceSize(25, 26, 28));
	Desc.Font = Enum.Font.Gotham;
	Desc.TextTransparency = 0.2;
	Desc.Text = desc;
	Desc.TextColor3 = Color3.fromRGB(200, 200, 200);
	Desc.TextSize = descSize;
	Desc.TextXAlignment = Enum.TextXAlignment.Left;
	Desc.TextWrapped = true;
	
	-- Close button
	CloseButton.Name = "CloseButton";
	CloseButton.Parent = Frame;
	CloseButton.BackgroundTransparency = 1;
	CloseButton.Position = UDim2.new(1, -25, 0, 5);
	CloseButton.Size = UDim2.new(0, 20, 0, 20);
	CloseButton.Text = "×";
	CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200);
	CloseButton.TextSize = 18;
	CloseButton.Font = Enum.Font.GothamBold;
	
	CloseButton.MouseButton1Click:Connect(function()
		for i, notification in ipairs(NotificationList) do
			if notification[1] == OutlineFrame then
				table.remove(NotificationList, i);
				break;
			end
		end
		
		TweenService:Create(OutlineFrame, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = UDim2.new(1.2, 0, OutlineFrame.Position.Y.Scale, OutlineFrame.Position.Y.Offset),
			Size = UDim2.new(0, 0, 0, OutlineFrame.Size.Y.Offset)
		}):Play();
		
		wait(0.15);
		OutlineFrame:Destroy();
	end);
	
	CreateRounded(Frame, 12);
	CreateRounded(OutlineFrame, 15);
	
	-- FIXED: Faster entrance animation
	local entranceTween = TweenService:Create(OutlineFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.1 + #NotificationList * 0.12, 0)
	});
	
	entranceTween:Play();
	
	-- Add to notification list
	table.insert(NotificationList, {OutlineFrame, "Xenon"});
	
	-- Hover effects for desktop only
	if IsPC then
		OutlineFrame.MouseEnter:Connect(function()
			TweenService:Create(NotifStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.2
			}):Play();
		end);
		
		OutlineFrame.MouseLeave:Connect(function()
			TweenService:Create(NotifStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.5
			}):Play();
		end);
	end
end;

-- Enhanced Loading Screen with faster animations
function Update:StartLoad()
	local Loader = Instance.new("ScreenGui");
	Loader.Parent = game.CoreGui;
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	Loader.DisplayOrder = 1000;
	Loader.ResetOnSpawn = false;
	
	local LoaderFrame = Instance.new("Frame");
	LoaderFrame.Name = "LoaderFrame";
	LoaderFrame.Parent = Loader;
	LoaderFrame.ClipsDescendants = true;
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12);
	LoaderFrame.BackgroundTransparency = 0;
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0);
	LoaderFrame.BorderSizePixel = 0;
	
	-- Add animated background
	local BackgroundGradient = Instance.new("UIGradient");
	BackgroundGradient.Parent = LoaderFrame;
	BackgroundGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 12)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
	});
	BackgroundGradient.Rotation = 45;
	
	-- FIXED: Faster background gradient animation
	spawn(function()
		while LoaderFrame.Parent do
			TweenService:Create(BackgroundGradient, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Rotation = BackgroundGradient.Rotation + 360
			}):Play();
			wait(1.5);
		end
	end);
	
	local MainLoaderFrame = Instance.new("Frame");
	MainLoaderFrame.Name = "MainLoaderFrame";
	MainLoaderFrame.Parent = LoaderFrame;
	MainLoaderFrame.ClipsDescendants = true;
	MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12);
	MainLoaderFrame.BackgroundTransparency = 1;
	MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	MainLoaderFrame.Size = UDim2.new(0.8, 0, 0.6, 0);
	MainLoaderFrame.BorderSizePixel = 0;
	
	-- Enhanced logo with glow effect
	local LogoFrame = Instance.new("Frame");
	LogoFrame.Parent = MainLoaderFrame;
	LogoFrame.BackgroundTransparency = 1;
	LogoFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	LogoFrame.Position = UDim2.new(0.5, 0, 0.25, 0);
	LogoFrame.Size = UDim2.new(0, 100, 0, 100);
	
	local LogoImage = Instance.new("ImageLabel");
	LogoImage.Parent = LogoFrame;
	LogoImage.BackgroundTransparency = 1;
	LogoImage.AnchorPoint = Vector2.new(0.5, 0.5);
	LogoImage.Position = UDim2.new(0.5, 0, 0.5, 0);
	LogoImage.Size = UDim2.new(0, 80, 0, 80);
	LogoImage.Image = "rbxassetid://105059922903197";
	LogoImage.ImageColor3 = _G.Third;
	CreateRounded(LogoImage, 20);
	
	-- Logo glow effect
	local LogoGlow = Instance.new("ImageLabel");
	LogoGlow.Parent = LogoFrame;
	LogoGlow.BackgroundTransparency = 1;
	LogoGlow.AnchorPoint = Vector2.new(0.5, 0.5);
	LogoGlow.Position = UDim2.new(0.5, 0, 0.5, 0);
	LogoGlow.Size = UDim2.new(0, 100, 0, 100);
	LogoGlow.Image = "rbxassetid://105059922903197";
	LogoGlow.ImageColor3 = _G.Third;
	LogoGlow.ImageTransparency = 0.7;
	LogoGlow.ZIndex = -1;
	CreateRounded(LogoGlow, 25);
	
	-- FIXED: Faster logo glow animation
	spawn(function()
		while LogoGlow.Parent do
			TweenService:Create(LogoGlow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Size = UDim2.new(0, 120, 0, 120),
				ImageTransparency = 0.9
			}):Play();
			wait(1);
		end
	end);
	
	local titleSize = GetDeviceSize(35, 40, 45);
	
	local TitleLoader = Instance.new("TextLabel");
	TitleLoader.Parent = MainLoaderFrame;
	TitleLoader.Text = "XENON HUB";
	TitleLoader.Font = Enum.Font.GothamBold;
	TitleLoader.TextSize = titleSize;
	TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255);
	TitleLoader.BackgroundTransparency = 1;
	TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	TitleLoader.Position = UDim2.new(0.5, 0, 0.45, 0);
	TitleLoader.Size = UDim2.new(0.8, 0, 0.15, 0);
	TitleLoader.TextTransparency = 0;
	
	-- Add text gradient effect
	local TextGradient = Instance.new("UIGradient");
	TextGradient.Parent = TitleLoader;
	TextGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, _G.Third),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	});
	
	local versionSize = GetDeviceSize(12, 13, 14);
	
	local VersionLoader = Instance.new("TextLabel");
	VersionLoader.Parent = MainLoaderFrame;
	VersionLoader.Text = "Enhanced Edition v4.0";
	VersionLoader.Font = Enum.Font.Gotham;
	VersionLoader.TextSize = versionSize;
	VersionLoader.TextColor3 = Color3.fromRGB(150, 150, 150);
	VersionLoader.BackgroundTransparency = 1;
	VersionLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	VersionLoader.Position = UDim2.new(0.5, 0, 0.55, 0);
	VersionLoader.Size = UDim2.new(0.8, 0, 0.1, 0);
	
	local descSize = GetDeviceSize(13, 15, 16);
	
	local DescriptionLoader = Instance.new("TextLabel");
	DescriptionLoader.Parent = MainLoaderFrame;
	DescriptionLoader.Text = "Initializing...";
	DescriptionLoader.Font = Enum.Font.Gotham;
	DescriptionLoader.TextSize = descSize;
	DescriptionLoader.TextColor3 = Color3.fromRGB(200, 200, 200);
	DescriptionLoader.BackgroundTransparency = 1;
	DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	DescriptionLoader.Position = UDim2.new(0.5, 0, 0.7, 0);
	DescriptionLoader.Size = UDim2.new(0.8, 0, 0.1, 0);
	DescriptionLoader.TextTransparency = 0;
	
	-- Enhanced Loading Bar
	local barHeight = GetDeviceSize(6, 7, 8);
	
	local LoadingBarBackground = Instance.new("Frame");
	LoadingBarBackground.Parent = MainLoaderFrame;
	LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
	LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5);
	LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.8, 0);
	LoadingBarBackground.Size = UDim2.new(0.6, 0, 0, barHeight);
	LoadingBarBackground.ClipsDescendants = true;
	LoadingBarBackground.BorderSizePixel = 0;
	LoadingBarBackground.ZIndex = 2;
	
	local LoadingBar = Instance.new("Frame");
	LoadingBar.Parent = LoadingBarBackground;
	LoadingBar.BackgroundColor3 = _G.Third;
	LoadingBar.Size = UDim2.new(0, 0, 1, 0);
	LoadingBar.ZIndex = 3;
	
	-- Add loading bar glow
	local BarGlow = Instance.new("Frame");
	BarGlow.Parent = LoadingBar;
	BarGlow.BackgroundColor3 = _G.Third;
	BarGlow.BackgroundTransparency = 0.5;
	BarGlow.Size = UDim2.new(1, 4, 1, 4);
	BarGlow.Position = UDim2.new(0, -2, 0, -2);
	BarGlow.ZIndex = 2;
	
	CreateRounded(LoadingBarBackground, GetDeviceSize(3, 3, 4));
	CreateRounded(LoadingBar, GetDeviceSize(3, 3, 4));
	CreateRounded(BarGlow, GetDeviceSize(4, 4, 5));
	
	local tweenService = game:GetService("TweenService");
	local dotCount = 0;
	local running = true;
	
	-- Enhanced loading phases
	local loadingPhases = {
		"Initializing components...",
		"Loading interface...",
		"Connecting services...",
		"Preparing features...",
		"Almost ready..."
	};
	
	local currentPhase = 1;
	
	-- FIXED: Faster loading bar animations
	local barTweenInfoPart1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
		Size = UDim2.new(0.3, 0, 1, 0)
	});
	
	local barTweenInfoPart2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
		Size = UDim2.new(1, 0, 1, 0)
	});
	
	barTweenPart1:Play();
	
	function Update:Loaded()
		barTweenPart2:Play();
		DescriptionLoader.Text = "Loading complete!";
	end;
	
	barTweenPart1.Completed:Connect(function()
		running = true;
		barTweenPart2.Completed:Connect(function()
			wait(0.25);
			running = false;
			DescriptionLoader.Text = "Welcome to Xenon Hub!";
			
			-- FIXED: Faster exit animation
			TweenService:Create(MainLoaderFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play();
			
			wait(0.25);
			Loader:Destroy();
		end);
	end);
	
	-- FIXED: Faster loading text animation
	spawn(function()
		while running do
			if currentPhase <= #loadingPhases then
				DescriptionLoader.Text = loadingPhases[currentPhase];
				currentPhase = currentPhase + 1;
				wait(0.4);
			else
				dotCount = (dotCount + 1) % 4;
				local dots = string.rep(".", dotCount);
				DescriptionLoader.Text = "Finalizing" .. dots;
				wait(0.15);
			end
		end;
	end);
end;

-- Enhanced Settings Library
local SettingsLib = {
	SaveSettings = true,
	LoadAnimation = true,
	Theme = "Dark",
	MobileOptimized = IsMobile,
	AnimationSpeed = 2.0, -- Increased default speed
	NotificationDuration = 3
};

(getgenv()).LoadConfig = function()
	if readfile and writefile and isfile and isfolder then
		if not isfolder("Xenon") then
			makefolder("Xenon");
		end;
		if not isfolder("Xenon/Library/") then
			makefolder("Xenon/Library/");
		end;
		if not isfile(("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(SettingsLib));
		else
			local success, Decode = pcall(function()
				return (game:GetService("HttpService")):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
			end);
			
			if success then
				for i, v in pairs(Decode) do
					SettingsLib[i] = v;
				end;
			end
		end;
		print("✅ Xenon Library Configuration Loaded!");
	else
		warn("⚠️ Executor doesn't support file operations");
	end;
end;

(getgenv()).SaveConfig = function()
	if readfile and writefile and isfile and isfolder then
		if not isfile(("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			(getgenv()).LoadConfig();
		else
			local Array = {};
			for i, v in pairs(SettingsLib) do
				Array[i] = v;
			end;
			writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(Array));
		end;
	end;
end;

(getgenv()).LoadConfig();

function Update:SaveSettings()
	return SettingsLib.SaveSettings;
end;

function Update:LoadAnimation()
	return SettingsLib.LoadAnimation;
end;

-- Enhanced Window Creation with better device detection
function Update:Window(Config)
	assert(Config.SubTitle, "SubTitle is required");
	
	-- FIXED: Better responsive window sizing
	local WindowConfig = {
		Size = Config.Size or UDim2.new(0, GetDeviceSize(380, 480, 550), 0, GetDeviceSize(500, 450, 400)),
		TabWidth = Config.TabWidth or GetDeviceSize(120, 130, 140)
	};
	
	local osfunc = {};
	local uihide = false;
	local abc = false;
	local currentpage = "";
	local keybind = keybind or Enum.KeyCode.RightControl;
	
	-- Enhanced Main GUI
	local Xenon = Instance.new("ScreenGui");
	Xenon.Name = "Xenon";
	Xenon.Parent = game.CoreGui;
	Xenon.DisplayOrder = 999;
	Xenon.ResetOnSpawn = false;
	
	local OutlineMain = Instance.new("Frame");
	OutlineMain.Name = "OutlineMain";
	OutlineMain.Parent = Xenon;
	OutlineMain.ClipsDescendants = true;
	OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5);
	OutlineMain.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	OutlineMain.BackgroundTransparency = 0.1;
	OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0);
	OutlineMain.Size = UDim2.new(0, 0, 0, 0);
	
	-- Add enhanced border
	local MainStroke = Instance.new("UIStroke");
	MainStroke.Parent = OutlineMain;
	MainStroke.Color = _G.Third;
	MainStroke.Thickness = GetDeviceSize(3, 2, 2);
	MainStroke.Transparency = 0.6;
	
	CreateRounded(OutlineMain, 18);
	
	local Main = Instance.new("Frame");
	Main.Name = "Main";
	Main.Parent = OutlineMain;
	Main.ClipsDescendants = true;
	Main.AnchorPoint = Vector2.new(0.5, 0.5);
	Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22);
	Main.BackgroundTransparency = 0;
	Main.Position = UDim2.new(0.5, 0, 0.5, 0);
	Main.Size = WindowConfig.Size;
	
	-- FIXED: Faster window opening animation
	OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20), "Out", "Back", 0.3, true);
	
	-- Add subtle gradient background
	local MainGradient = Instance.new("UIGradient");
	MainGradient.Parent = Main;
	MainGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 22, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22))
	});
	MainGradient.Rotation = 45;
	
	CreateRounded(Main, 15);
	
	-- Enhanced Drag Button with better device support
	local dragButtonSize = GetDeviceSize(20, 19, 18);
	
	local DragButton = Instance.new("Frame");
	DragButton.Name = "DragButton";
	DragButton.Parent = Main;
	DragButton.Position = UDim2.new(1, 8, 1, 8);
	DragButton.AnchorPoint = Vector2.new(1, 1);
	DragButton.Size = UDim2.new(0, dragButtonSize, 0, dragButtonSize);
	DragButton.BackgroundColor3 = _G.Primary;
	DragButton.BackgroundTransparency = 0.3;
	DragButton.ZIndex = 10;
	
	local DragIcon = Instance.new("ImageLabel");
	DragIcon.Parent = DragButton;
	DragIcon.BackgroundTransparency = 1;
	DragIcon.AnchorPoint = Vector2.new(0.5, 0.5);
	DragIcon.Position = UDim2.new(0.5, 0, 0.5, 0);
	DragIcon.Size = UDim2.new(0, 12, 0, 12);
	DragIcon.Image = "rbxassetid://10734886735";
	DragIcon.ImageColor3 = Color3.fromRGB(200, 200, 200);
	
	CreateRounded(DragButton, 99);
	
	-- Enhanced Top Bar
	local topBarHeight = GetDeviceSize(50, 47, 45);
	
	local Top = Instance.new("Frame");
	Top.Name = "Top";
	Top.Parent = Main;
	Top.BackgroundColor3 = Color3.fromRGB(15, 15, 18);
	Top.Size = UDim2.new(1, 0, 0, topBarHeight);
	Top.BackgroundTransparency = 0.3;
	CreateRounded(Top, 8);
	
	-- Add top bar gradient
	local TopGradient = Instance.new("UIGradient");
	TopGradient.Parent = Top;
	TopGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18))
	});
	TopGradient.Rotation = 90;
	
	-- Enhanced Title with better device support
	local titleSize = GetDeviceSize(18, 19, 20);
	local titlePosX = GetDeviceSize(20, 19, 18);
	
	local NameHub = Instance.new("TextLabel");
	NameHub.Name = "NameHub";
	NameHub.Parent = Top;
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	NameHub.BackgroundTransparency = 1;
	NameHub.RichText = true;
	NameHub.Position = UDim2.new(0, titlePosX, 0.5, 0);
	NameHub.AnchorPoint = Vector2.new(0, 0.5);
	NameHub.Size = UDim2.new(0, 1, 0, GetDeviceSize(28, 26, 25));
	NameHub.Font = Enum.Font.GothamBold;
	NameHub.Text = "XENON";
	NameHub.TextSize = titleSize;
	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255);
	NameHub.TextXAlignment = Enum.TextXAlignment.Left;
	
	local nameHubSize = (game:GetService("TextService")):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge));
	NameHub.Size = UDim2.new(0, nameHubSize.X, 0, GetDeviceSize(28, 26, 25));
	
	local subtitleSize = GetDeviceSize(13, 14, 15);
	
	local SubTitle = Instance.new("TextLabel");
	SubTitle.Name = "SubTitle";
	SubTitle.Parent = NameHub;
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	SubTitle.BackgroundTransparency = 1;
	SubTitle.Position = UDim2.new(0, nameHubSize.X + 10, 0.5, 0);
	SubTitle.Size = UDim2.new(0, 1, 0, GetDeviceSize(22, 21, 20));
	SubTitle.Font = Enum.Font.Gotham;
	SubTitle.AnchorPoint = Vector2.new(0, 0.5);
	SubTitle.Text = Config.SubTitle;
	SubTitle.TextSize = subtitleSize;
	SubTitle.TextColor3 = _G.Third;
	
	local SubTitleSize = (game:GetService("TextService")):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge));
	SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, GetDeviceSize(22, 21, 20));
	
	-- Enhanced Control Buttons with better device sizing
	local controlButtonSize = GetDeviceSize(25, 23, 22);
	local controlButtonSpacing = GetDeviceSize(35, 32, 30);
	local controlButtonPosX = GetDeviceSize(-18, -16, -15);
	
	local CloseButton = Instance.new("ImageButton");
	CloseButton.Name = "CloseButton";
	CloseButton.Parent = Top;
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100);
	CloseButton.BackgroundTransparency = 0.8;
	CloseButton.AnchorPoint = Vector2.new(1, 0.5);
	CloseButton.Position = UDim2.new(1, controlButtonPosX, 0.5, 0);
	CloseButton.Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize);
	CloseButton.Image = "rbxassetid://7743878857";
	CloseButton.ImageTransparency = 0;
	CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
	CreateRounded(CloseButton, 6);
	
	-- FIXED: Faster button animations
	CloseButton.MouseEnter:Connect(function()
		if IsPC then
			TweenService:Create(CloseButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3,
				Size = UDim2.new(0, controlButtonSize + 2, 0, controlButtonSize + 2)
			}):Play();
		end
	end);
	
	CloseButton.MouseLeave:Connect(function()
		if IsPC then
			TweenService:Create(CloseButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8,
				Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize)
			}):Play();
		end
	end);
	
	CloseButton.MouseButton1Click:connect(function()
		-- FIXED: Faster close animation
		TweenService:Create(OutlineMain, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.45, 0)
		}):Play();
		
		wait(0.2);
		(game.CoreGui:FindFirstChild("Xenon")).Enabled = false;
	end);
	
	local MinimizeButton = Instance.new("ImageButton");
	MinimizeButton.Name = "MinimizeButton";
	MinimizeButton.Parent = Top;
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100);
	MinimizeButton.BackgroundTransparency = 0.8;
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5);
	MinimizeButton.Position = UDim2.new(1, controlButtonPosX - controlButtonSpacing, 0.5, 0);
	MinimizeButton.Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize);
	MinimizeButton.Image = "rbxassetid://10734898355";
	MinimizeButton.ImageTransparency = 0;
	MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
	CreateRounded(MinimizeButton, 6);
	
	MinimizeButton.MouseEnter:Connect(function()
		if IsPC then
			TweenService:Create(MinimizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3,
				Size = UDim2.new(0, controlButtonSize + 2, 0, controlButtonSize + 2)
			}):Play();
		end
	end);
	
	MinimizeButton.MouseLeave:Connect(function()
		if IsPC then
			TweenService:Create(MinimizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8,
				Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize)
			}):Play();
		end
	end);
	
	MinimizeButton.MouseButton1Click:connect(function()
		(game.CoreGui:FindFirstChild("Xenon")).Enabled = false;
	end);
	
	local ResizeButton = Instance.new("ImageButton");
	ResizeButton.Name = "ResizeButton";
	ResizeButton.Parent = Top;
	ResizeButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100);
	ResizeButton.BackgroundTransparency = 0.8;
	ResizeButton.AnchorPoint = Vector2.new(1, 0.5);
	ResizeButton.Position = UDim2.new(1, controlButtonPosX - (controlButtonSpacing * 2), 0.5, 0);
	ResizeButton.Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize);
	ResizeButton.Image = "rbxassetid://10734886735";
	ResizeButton.ImageTransparency = 0;
	ResizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
	CreateRounded(ResizeButton, 6);
	
	ResizeButton.MouseEnter:Connect(function()
		if IsPC then
			TweenService:Create(ResizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3,
				Size = UDim2.new(0, controlButtonSize + 2, 0, controlButtonSize + 2)
			}):Play();
		end
	end);
	
	ResizeButton.MouseLeave:Connect(function()
		if IsPC then
			TweenService:Create(ResizeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8,
				Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize)
			}):Play();
		end
	end);
	
	-- Enhanced Settings System
	local BackgroundSettings = Instance.new("Frame");
	BackgroundSettings.Name = "BackgroundSettings";
	BackgroundSettings.Parent = OutlineMain;
	BackgroundSettings.ClipsDescendants = true;
	BackgroundSettings.Active = true;
	BackgroundSettings.AnchorPoint = Vector2.new(0, 0);
	BackgroundSettings.BackgroundColor3 = Color3.fromRGB(5, 5, 8);
	BackgroundSettings.BackgroundTransparency = 0.2;
	BackgroundSettings.Position = UDim2.new(0, 0, 0, 0);
	BackgroundSettings.Size = UDim2.new(1, 0, 1, 0);
	BackgroundSettings.Visible = false;
	CreateRounded(BackgroundSettings, 18);
	
	local SettingsFrame = Instance.new("Frame");
	SettingsFrame.Name = "SettingsFrame";
	SettingsFrame.Parent = BackgroundSettings;
	SettingsFrame.ClipsDescendants = true;
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	SettingsFrame.BackgroundTransparency = 0;
	SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	SettingsFrame.Size = UDim2.new(0.8, 0, 0.8, 0);
	CreateRounded(SettingsFrame, 15);
	
	-- Add settings frame border
	local SettingsStroke = Instance.new("UIStroke");
	SettingsStroke.Parent = SettingsFrame;
	SettingsStroke.Color = _G.Third;
	SettingsStroke.Thickness = 1.5;
	SettingsStroke.Transparency = 0.5;
	
	local CloseSettings = Instance.new("ImageButton");
	CloseSettings.Name = "CloseSettings";
	CloseSettings.Parent = SettingsFrame;
	CloseSettings.BackgroundColor3 = Color3.fromRGB(255, 100, 100);
	CloseSettings.BackgroundTransparency = 0.8;
	CloseSettings.AnchorPoint = Vector2.new(1, 0);
	CloseSettings.Position = UDim2.new(1, -15, 0, 15);
	CloseSettings.Size = UDim2.new(0, 25, 0, 25);
	CloseSettings.Image = "rbxassetid://10747384394";
	CloseSettings.ImageTransparency = 0;
	CloseSettings.ImageColor3 = Color3.fromRGB(255, 255, 255);
	CreateRounded(CloseSettings, 6);
	
	CloseSettings.MouseButton1Click:connect(function()
		-- FIXED: Faster settings close animation
		TweenService:Create(SettingsFrame, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		}):Play();
		
		wait(0.15);
		BackgroundSettings.Visible = false;
		
		TweenService:Create(SettingsFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.8, 0, 0.8, 0)
		}):Play();
	end);
	
	local SettingsButton = Instance.new("ImageButton");
	SettingsButton.Name = "SettingsButton";
	SettingsButton.Parent = Top;
	SettingsButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255);
	SettingsButton.BackgroundTransparency = 0.8;
	SettingsButton.AnchorPoint = Vector2.new(1, 0.5);
	SettingsButton.Position = UDim2.new(1, controlButtonPosX - (controlButtonSpacing * 3), 0.5, 0);
	SettingsButton.Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize);
	SettingsButton.Image = "rbxassetid://10734950020";
	SettingsButton.ImageTransparency = 0;
	SettingsButton.ImageColor3 = Color3.fromRGB(255, 255, 255);
	CreateRounded(SettingsButton, 6);
	
	SettingsButton.MouseEnter:Connect(function()
		if IsPC then
			TweenService:Create(SettingsButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3,
				Size = UDim2.new(0, controlButtonSize + 2, 0, controlButtonSize + 2)
			}):Play();
		end
	end);
	
	SettingsButton.MouseLeave:Connect(function()
		if IsPC then
			TweenService:Create(SettingsButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.8,
				Size = UDim2.new(0, controlButtonSize, 0, controlButtonSize)
			}):Play();
		end
	end);
	
	SettingsButton.MouseButton1Click:connect(function()
		BackgroundSettings.Visible = true;
		
		-- FIXED: Faster settings open animation
		SettingsFrame.Size = UDim2.new(0, 0, 0, 0);
		TweenService:Create(SettingsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.8, 0, 0.8, 0)
		}):Play();
	end);
	
	-- Enhanced Settings Content
	local settingsTitleSize = GetDeviceSize(18, 20, 22);
	
	local TitleSettings = Instance.new("TextLabel");
	TitleSettings.Name = "TitleSettings";
	TitleSettings.Parent = SettingsFrame;
	TitleSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TitleSettings.BackgroundTransparency = 1;
	TitleSettings.Position = UDim2.new(0, 25, 0, 20);
	TitleSettings.Size = UDim2.new(1, -50, 0, 25);
	TitleSettings.Font = Enum.Font.GothamBold;
	TitleSettings.AnchorPoint = Vector2.new(0, 0);
	TitleSettings.Text = "⚙️ Library Settings";
	TitleSettings.TextSize = settingsTitleSize;
	TitleSettings.TextColor3 = Color3.fromRGB(255, 255, 255);
	TitleSettings.TextXAlignment = Enum.TextXAlignment.Left;
	
	local SettingsMenuList = Instance.new("Frame");
	SettingsMenuList.Name = "SettingsMenuList";
	SettingsMenuList.Parent = SettingsFrame;
	SettingsMenuList.ClipsDescendants = true;
	SettingsMenuList.AnchorPoint = Vector2.new(0, 0);
	SettingsMenuList.BackgroundColor3 = Color3.fromRGB(18, 18, 22);
	SettingsMenuList.BackgroundTransparency = 0.3;
	SettingsMenuList.Position = UDim2.new(0, 15, 0, 60);
	SettingsMenuList.Size = UDim2.new(1, -30, 1, -80);
	CreateRounded(SettingsMenuList, 12);
	
	local ScrollSettings = Instance.new("ScrollingFrame");
	ScrollSettings.Name = "ScrollSettings";
	ScrollSettings.Parent = SettingsMenuList;
	ScrollSettings.Active = true;
	ScrollSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollSettings.Position = UDim2.new(0, 0, 0, 0);
	ScrollSettings.BackgroundTransparency = 1;
	ScrollSettings.Size = UDim2.new(1, 0, 1, 0);
	ScrollSettings.ScrollBarThickness = GetDeviceSize(6, 5, 4);
	ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y;
	ScrollSettings.ScrollBarImageColor3 = _G.Third;
	
	local SettingsListLayout = Instance.new("UIListLayout");
	SettingsListLayout.Name = "SettingsListLayout";
	SettingsListLayout.Parent = ScrollSettings;
	SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	SettingsListLayout.Padding = UDim.new(0, GetDeviceSize(12, 11, 10));
	
	local PaddingScroll = Instance.new("UIPadding");
	PaddingScroll.Name = "PaddingScroll";
	PaddingScroll.Parent = ScrollSettings;
	PaddingScroll.PaddingTop = UDim.new(0, 15);
	PaddingScroll.PaddingBottom = UDim.new(0, 15);
	PaddingScroll.PaddingLeft = UDim.new(0, 15);
	PaddingScroll.PaddingRight = UDim.new(0, 15);
	
	-- Enhanced Settings Components with faster animations
	function CreateCheckbox(title, state, callback)
		local checked = state or false;
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
		Background.BackgroundTransparency = 0.3;
		Background.Size = UDim2.new(1, 0, 0, GetDeviceSize(45, 42, 40));
		CreateRounded(Background, 8);
		
		-- Add hover effect for desktop
		if IsPC then
			Background.MouseEnter:Connect(function()
				TweenService:Create(Background, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.1
				}):Play();
			end);
			
			Background.MouseLeave:Connect(function()
				TweenService:Create(Background, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.3
				}):Play();
			end);
		end
		
		local checkboxTitleSize = GetDeviceSize(14, 14, 15);
		local checkboxSize = GetDeviceSize(25, 23, 22);
		local checkboxPosX = GetDeviceSize(18, 16, 15);
		
		local Title = Instance.new("TextLabel");
		Title.Name = "Title";
		Title.Parent = Background;
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, GetDeviceSize(55, 52, 50), 0.5, 0);
		Title.Size = UDim2.new(1, GetDeviceSize(-85, -82, -80), 0, GetDeviceSize(25, 23, 22));
		Title.Font = Enum.Font.Gotham;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.Text = title or "";
		Title.TextSize = checkboxTitleSize;
		Title.TextColor3 = Color3.fromRGB(220, 220, 220);
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		local Checkbox = Instance.new("ImageButton");
		Checkbox.Name = "Checkbox";
		Checkbox.Parent = Background;
		Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
		Checkbox.BackgroundTransparency = 0;
		Checkbox.AnchorPoint = Vector2.new(0, 0.5);
		Checkbox.Position = UDim2.new(0, checkboxPosX, 0.5, 0);
		Checkbox.Size = UDim2.new(0, checkboxSize, 0, checkboxSize);
		Checkbox.Image = "rbxassetid://10709790644";
		Checkbox.ImageTransparency = 1;
		Checkbox.ImageColor3 = Color3.fromRGB(255, 255, 255);
		CreateRounded(Checkbox, 6);
		
		-- Add checkbox border
		local CheckboxStroke = Instance.new("UIStroke");
		CheckboxStroke.Parent = Checkbox;
		CheckboxStroke.Color = _G.Third;
		CheckboxStroke.Thickness = 1.5;
		CheckboxStroke.Transparency = 0.7;
		
		Checkbox.MouseButton1Click:Connect(function()
			checked = not checked;
			
			-- FIXED: Faster checkbox animation
			if checked then
				TweenService:Create(Circle, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					BackgroundColor3 = _G.Third,
					Size = UDim2.new(0, checkboxSize + 2, 0, checkboxSize + 2)
				}):Play();
				TweenService:Create(Checkbox, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageTransparency = 0
				}):Play();
				TweenService:Create(CheckboxStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.3
				}):Play();
				
				wait(0.05);
				TweenService:Create(Checkbox, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, checkboxSize, 0, checkboxSize)
				}):Play();
			else
				TweenService:Create(Checkbox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(60, 60, 65),
					ImageTransparency = 1
				}):Play();
				TweenService:Create(CheckboxStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.7
				}):Play();
			end;
			
			pcall(callback, checked);
		end);
		
		-- Set initial state
		if checked then
			Checkbox.ImageTransparency = 0;
			Checkbox.BackgroundColor3 = _G.Third;
			CheckboxStroke.Transparency = 0.3;
		else
			Checkbox.ImageTransparency = 1;
			Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
			CheckboxStroke.Transparency = 0.7;
		end;
		
		pcall(callback, checked);
	end;
	
	function CreateButton(title, callback)
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
		Background.BackgroundTransparency = 1;
		Background.Size = UDim2.new(1, 0, 0, GetDeviceSize(45, 42, 40));
		
		local buttonHeight = GetDeviceSize(40, 37, 35);
		local buttonTextSize = GetDeviceSize(14, 14, 15);
		
		local Button = Instance.new("TextButton");
		Button.Name = "Button";
		Button.Parent = Background;
		Button.BackgroundColor3 = _G.Third;
		Button.BackgroundTransparency = 0.1;
		Button.Size = UDim2.new(0.9, 0, 0, buttonHeight);
		Button.Font = Enum.Font.GothamBold;
		Button.Text = title or "Button";
		Button.AnchorPoint = Vector2.new(0.5, 0.5);
		Button.Position = UDim2.new(0.5, 0, 0.5, 0);
		Button.TextColor3 = Color3.fromRGB(255, 255, 255);
		Button.TextSize = buttonTextSize;
		Button.AutoButtonColor = false;
		CreateRounded(Button, 8);
		
		-- Add button border
		local ButtonStroke = Instance.new("UIStroke");
		ButtonStroke.Parent = Button;
		ButtonStroke.Color = _G.Third;
		ButtonStroke.Thickness = 1.5;
		ButtonStroke.Transparency = 0.5;
		
		-- FIXED: Faster button animations
		Button.MouseEnter:Connect(function()
			if IsPC then
				TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0,
					Size = UDim2.new(0.9, 0, 0, buttonHeight + 2)
				}):Play();
				TweenService:Create(ButtonStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.2
				}):Play();
			end
		end);
		
		Button.MouseLeave:Connect(function()
			if IsPC then
				TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.1,
					Size = UDim2.new(0.9, 0, 0, buttonHeight)
				}):Play();
				TweenService:Create(ButtonStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.5
				}):Play();
			end
		end);
		
		Button.MouseButton1Click:Connect(function()
			-- FIXED: Faster click animation
			TweenService:Create(Button, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.85, 0, 0, buttonHeight - 2)
			}):Play();
			
			wait(0.05);
			
			TweenService:Create(Button, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.9, 0, 0, buttonHeight)
			}):Play();
			
			callback();
		end);
	end;
	
	-- Create Enhanced Settings
	CreateCheckbox("💾 Save Settings", SettingsLib.SaveSettings, function(state)
		SettingsLib.SaveSettings = state;
		(getgenv()).SaveConfig();
		Update:Notify("Settings " .. (state and "will be saved" or "won't be saved"), state and "success" or "warning");
	end);
	
	CreateCheckbox("🎬 Loading Animation", SettingsLib.LoadAnimation, function(state)
		SettingsLib.LoadAnimation = state;
		(getgenv()).SaveConfig();
		Update:Notify("Loading animation " .. (state and "enabled" or "disabled"), "info");
	end);
	
	CreateCheckbox("📱 Mobile Optimized", SettingsLib.MobileOptimized, function(state)
		SettingsLib.MobileOptimized = state;
		(getgenv()).SaveConfig();
		Update:Notify("Mobile optimization " .. (state and "enabled" or "disabled"), "info");
	end);
	
	CreateButton("🗑️ Reset Configuration", function()
		if isfolder("Xenon") then
			delfolder("Xenon");
		end;
		Update:Notify("Configuration has been reset successfully!", "success");
		wait(1);
		-- Reload the interface
		if Xenon then
			Xenon:Destroy();
		end
	end);
	
	CreateButton("📋 Copy Debug Info", function()
		local debugInfo = "Xenon Hub Debug Info:\n";
		debugInfo = debugInfo .. "Version: Enhanced Edition v4.0\n";
		debugInfo = debugInfo .. "Device: " .. (IsMobile and "Mobile" or (IsTablet and "Tablet" or "Desktop")) .. "\n";
		debugInfo = debugInfo .. "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown") .. "\n";
		debugInfo = debugInfo .. "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name;
		
		if setclipboard then
			setclipboard(debugInfo);
			Update:Notify("Debug information copied to clipboard!", "success");
		else
			Update:Notify("Clipboard not supported on this executor", "warning");
		end
	end);
	
	-- Enhanced Tab System
	local Tab = Instance.new("Frame");
	Tab.Name = "Tab";
	Tab.Parent = Main;
	Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 28);
	Tab.Position = UDim2.new(0, 12, 0, Top.Size.Y.Offset + 8);
	Tab.BackgroundTransparency = 0.2;
	Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 20);
	CreateRounded(Tab, 10);
	
	-- Add tab gradient
	local TabGradient = Instance.new("UIGradient");
	TabGradient.Parent = Tab;
	TabGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 32)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24))
	});
	TabGradient.Rotation = 90;
	
	local ScrollTab = Instance.new("ScrollingFrame");
	ScrollTab.Name = "ScrollTab";
	ScrollTab.Parent = Tab;
	ScrollTab.Active = true;
	ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollTab.Position = UDim2.new(0, 0, 0, 0);
	ScrollTab.BackgroundTransparency = 1;
	ScrollTab.Size = UDim2.new(1, 0, 1, 0);
	ScrollTab.ScrollBarThickness = GetDeviceSize(6, 4, 3);
	ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y;
	ScrollTab.ScrollBarImageColor3 = _G.Third;
	
	local TabListLayout = Instance.new("UIListLayout");
	TabListLayout.Name = "TabListLayout";
	TabListLayout.Parent = ScrollTab;
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	TabListLayout.Padding = UDim.new(0, GetDeviceSize(4, 3, 3));
	
	local PPD = Instance.new("UIPadding");
	PPD.Name = "PPD";
	PPD.Parent = ScrollTab;
	PPD.PaddingTop = UDim.new(0, 8);
	PPD.PaddingBottom = UDim.new(0, 8);
	PPD.PaddingLeft = UDim.new(0, 6);
	PPD.PaddingRight = UDim.new(0, 6);
	
	-- Enhanced Page System
	local Page = Instance.new("Frame");
	Page.Name = "Page";
	Page.Parent = Main;
	Page.BackgroundColor3 = Color3.fromRGB(20, 20, 26);
	Page.Position = UDim2.new(0, Tab.Size.X.Offset + 22, 0, Top.Size.Y.Offset + 8);
	Page.Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 35, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 20);
	Page.BackgroundTransparency = 0.3;
	CreateRounded(Page, 10);
	
	-- Add page gradient
	local PageGradient = Instance.new("UIGradient");
	PageGradient.Parent = Page;
	PageGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 24))
	});
	PageGradient.Rotation = 135;
	
	local MainPage = Instance.new("Frame");
	MainPage.Name = "MainPage";
	MainPage.Parent = Page;
	MainPage.ClipsDescendants = true;
	MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	MainPage.BackgroundTransparency = 1;
	MainPage.Size = UDim2.new(1, 0, 1, 0);
	
	local PageList = Instance.new("Folder");
	PageList.Name = "PageList";
	PageList.Parent = MainPage;
	
	local UIPageLayout = Instance.new("UIPageLayout");
	UIPageLayout.Parent = PageList;
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	UIPageLayout.EasingDirection = Enum.EasingDirection.InOut;
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quart;
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical;
	UIPageLayout.Padding = UDim.new(0, 15);
	UIPageLayout.TweenTime = 0.2; -- FIXED: Faster page transitions
	UIPageLayout.GamepadInputEnabled = false;
	UIPageLayout.ScrollWheelInputEnabled = false;
	UIPageLayout.TouchInputEnabled = false;
	
	-- Enhanced Dragging
	MakeDraggable(Top, OutlineMain);
	
	-- Enhanced Keyboard Shortcuts
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightControl then
			local xenonGui = game.CoreGui:FindFirstChild("Xenon");
			if xenonGui then
				xenonGui.Enabled = not xenonGui.Enabled;
				
				if xenonGui.Enabled then
					-- FIXED: Faster show animation
					OutlineMain.Size = UDim2.new(0, 0, 0, 0);
					OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20), "Out", "Back", 0.25, true);
				end
			end
		end;
	end);
	
	-- Enhanced Resize System with faster animations
	local Dragging = false;
	DragButton.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
			
			-- FIXED: Faster visual feedback for resize start
			TweenService:Create(DragButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.1,
				Size = UDim2.new(0, dragButtonSize + 2, 0, dragButtonSize + 2)
			}):Play();
		end;
	end);
	
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if Dragging then
				Dragging = false;
				
				-- FIXED: Faster visual feedback for resize end
				TweenService:Create(DragButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.3,
					Size = UDim2.new(0, dragButtonSize, 0, dragButtonSize)
				}):Play();
			end
		end;
	end);
	
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local newWidth = math.clamp(Input.Position.X - Main.AbsolutePosition.X, WindowConfig.Size.X.Offset, math.huge);
			local newHeight = math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, WindowConfig.Size.Y.Offset, math.huge);
			
			-- FIXED: Faster resize animation
			TweenService:Create(OutlineMain, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, newWidth + 20, 0, newHeight + 20)
			}):Play();
			
			TweenService:Create(Main, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, newWidth, 0, newHeight)
			}):Play();
			
			TweenService:Create(Page, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, newWidth - Tab.Size.X.Offset - 35, 0, newHeight - Top.Size.Y.Offset - 20)
			}):Play();
			
			TweenService:Create(Tab, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, WindowConfig.TabWidth, 0, newHeight - Top.Size.Y.Offset - 20)
			}):Play();
		end;
	end);
	
	-- Enhanced Tab Creation System
	local uitab = {};
	function uitab:Tab(text, img)
		local TabButton = Instance.new("TextButton");
		local Title = Instance.new("TextLabel");
		local IDK = Instance.new("ImageLabel");
		local SelectedTab = Instance.new("Frame");
		
		local tabHeight = GetDeviceSize(42, 40, 38);
		local tabTextSize = GetDeviceSize(13, 13, 12);
		local tabIconSize = GetDeviceSize(20, 19, 18);
		local tabIconPosX = GetDeviceSize(12, 11, 10);
		local tabTitlePosX = GetDeviceSize(38, 36, 35);
		
		TabButton.Parent = ScrollTab;
		TabButton.Name = text .. "Unique";
		TabButton.Text = "";
		TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
		TabButton.BackgroundTransparency = 0.8;
		TabButton.Size = UDim2.new(1, 0, 0, tabHeight);
		TabButton.Font = Enum.Font.Gotham;
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		TabButton.TextSize = tabTextSize;
		TabButton.TextTransparency = 0.9;
		TabButton.AutoButtonColor = false;
		CreateRounded(TabButton, 8);
		
		-- Add tab border
		local TabStroke = Instance.new("UIStroke");
		TabStroke.Parent = TabButton;
		TabStroke.Color = _G.Third;
		TabStroke.Thickness = 1;
		TabStroke.Transparency = 0.9;
		
		SelectedTab.Name = "SelectedTab";
		SelectedTab.Parent = TabButton;
		SelectedTab.BackgroundColor3 = _G.Third;
		SelectedTab.BackgroundTransparency = 0;
		SelectedTab.Size = UDim2.new(0, 4, 0, 0);
		SelectedTab.Position = UDim2.new(0, -2, 0.5, 0);
		SelectedTab.AnchorPoint = Vector2.new(0, 0.5);
		CreateRounded(SelectedTab, 2);
		
		Title.Parent = TabButton;
		Title.Name = "Title";
		Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, tabTitlePosX, 0.5, 0);
		Title.Size = UDim2.new(1, -tabTitlePosX - 7, 0, GetDeviceSize(22, 21, 20));
		Title.Font = Enum.Font.GothamMedium;
		Title.Text = text;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.TextColor3 = Color3.fromRGB(200, 200, 200);
		Title.TextTransparency = 0.3;
		Title.TextSize = GetDeviceSize(13, 13, 14);
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		IDK.Name = "IDK";
		IDK.Parent = TabButton;
		IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		IDK.BackgroundTransparency = 1;
		IDK.ImageTransparency = 0.2;
		IDK.Position = UDim2.new(0, tabIconPosX, 0.5, 0);
		IDK.Size = UDim2.new(0, tabIconSize, 0, tabIconSize);
		IDK.AnchorPoint = Vector2.new(0, 0.5);
		IDK.Image = img;
		IDK.ImageColor3 = Color3.fromRGB(200, 200, 200);
		
		-- Enhanced Tab Page
		local MainFramePage = Instance.new("ScrollingFrame");
		MainFramePage.Name = text .. "_Page";
		MainFramePage.Parent = PageList;
		MainFramePage.Active = true;
		MainFramePage.BackgroundColor3 = _G.Dark;
		MainFramePage.Position = UDim2.new(0, 0, 0, 0);
		MainFramePage.BackgroundTransparency = 1;
		MainFramePage.Size = UDim2.new(1, 0, 1, 0);
		MainFramePage.ScrollBarThickness = GetDeviceSize(6, 5, 4);
		MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y;
		MainFramePage.ScrollBarImageColor3 = _G.Third;
		
		local UIPadding = Instance.new("UIPadding");
		local UIListLayout = Instance.new("UIListLayout");
		UIPadding.Parent = MainFramePage;
		UIPadding.PaddingTop = UDim.new(0, 12);
		UIPadding.PaddingBottom = UDim.new(0, 12);
		UIPadding.PaddingLeft = UDim.new(0, 12);
		UIPadding.PaddingRight = UDim.new(0, 12);
		
		UIListLayout.Padding = UDim.new(0, GetDeviceSize(8, 7, 6));
		UIListLayout.Parent = MainFramePage;
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
		
		-- FIXED: Faster Tab Click Handler
		TabButton.MouseButton1Click:Connect(function()
			-- Reset all tabs
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.8
					}):Play();
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 4, 0, 0)
					}):Play();
					TweenService:Create(v.IDK, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4,
						ImageColor3 = Color3.fromRGB(200, 200, 200)
					}):Play();
					TweenService:Create(v.Title, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4,
						TextColor3 = Color3.fromRGB(200, 200, 200)
					}):Play();
					if v:FindFirstChild("UIStroke") then
						TweenService:Create(v.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Transparency = 0.9
						}):Play();
					end
				end;
			end
			
			-- Activate current tab
			TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3
			}):Play();
			TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 4, 0, GetDeviceSize(25, 23, 22))
			}):Play();
			TweenService:Create(IDK, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 0,
				ImageColor3 = _G.Third
			}):Play();
			TweenService:Create(Title, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play();
			TweenService:Create(TabStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.5
			}):Play();
			
			-- Switch page
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page";
				if v.Name == currentpage then
					UIPageLayout:JumpTo(v);
				end;
			end;
		end);
		
		-- FIXED: Faster hover effects for desktop
		if IsPC then
			TabButton.MouseEnter:Connect(function()
				if TabButton.BackgroundTransparency > 0.5 then -- Only if not active
					TweenService:Create(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.6
					}):Play();
					TweenService:Create(TabStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.7
					}):Play();
				end
			end);
			
			TabButton.MouseLeave:Connect(function()
				if TabButton.BackgroundTransparency > 0.5 then -- Only if not active
					TweenService:Create(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.8
					}):Play();
					TweenService:Create(TabStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.9
					}):Play();
				end
			end);
		end
		
		-- Auto-select first tab
		if abc == false then
			-- Reset all tabs first
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.8
					}):Play();
					TweenService:Create(v.SelectedTab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 4, 0, 0)
					}):Play();
					TweenService:Create(v.IDK, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4,
						ImageColor3 = Color3.fromRGB(200, 200, 200)
					}):Play();
					TweenService:Create(v.Title, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4,
						TextColor3 = Color3.fromRGB(200, 200, 200)
					}):Play();
				end;
			end
			
			-- Activate first tab
			TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.3
			}):Play();
			TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 4, 0, GetDeviceSize(25, 23, 22))
			}):Play();
			TweenService:Create(IDK, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ImageTransparency = 0,
				ImageColor3 = _G.Third
			}):Play();
			TweenService:Create(Title, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 0,
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play();
			TweenService:Create(TabStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.5
			}):Play();
			
			UIPageLayout:JumpToIndex(1);
			abc = true;
		end;
		
		-- Enhanced Canvas Size Updates
		(game:GetService("RunService")).Stepped:Connect(function()
			pcall(function()
				MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 24);
				ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 16);
				ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 30);
			end);
		end);
		
		-- Enhanced Fullscreen Toggle with faster animations
		local defaultSize = true;
		ResizeButton.MouseButton1Click:Connect(function()
			if defaultSize then
				defaultSize = false;
				
				-- FIXED: Faster fullscreen animation
				TweenService:Create(OutlineMain, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -20, 1, -20)
				}):Play();
				
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, -40, 1, -40)
				}):Play();
				
				wait(0.1);
				
				TweenService:Create(Page, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 35, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 20)
				}):Play();
				
				TweenService:Create(Tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 20)
				}):Play();
				
				ResizeButton.Image = "rbxassetid://10734895698";
				Update:Notify("Switched to fullscreen mode", "info");
			else
				defaultSize = true;
				
				-- FIXED: Faster windowed animation
				TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, WindowConfig.Size.X.Offset, 0, WindowConfig.Size.Y.Offset)
				}):Play();
				
				TweenService:Create(OutlineMain, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 0, 0.45, 0),
					Size = UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20)
				}):Play();
				
				wait(0.1);
				
				TweenService:Create(Page, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 35, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 20)
				}):Play();
				
				TweenService:Create(Tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 20)
				}):Play();
				
				ResizeButton.Image = "rbxassetid://10734886735";
				Update:Notify("Switched to windowed mode", "info");
			end;
		end);
		
		-- Enhanced Component Creation Functions with faster animations
		local main = {};
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame");
			local TextLabel = Instance.new("TextLabel");
			local TextButton = Instance.new("TextButton");
			local ImageLabel = Instance.new("ImageLabel");
			local ArrowRight = Instance.new("ImageLabel");
			
			local buttonHeight = GetDeviceSize(45, 42, 40);
			local buttonTextSize = GetDeviceSize(14, 14, 15);
			local buttonIconSize = GetDeviceSize(32, 30, 28);
			local arrowIconSize = GetDeviceSize(20, 19, 18);
			
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Button.BackgroundTransparency = 0.2;
			Button.Size = UDim2.new(1, 0, 0, buttonHeight);
			CreateRounded(Button, 8);
			
			-- Add button border
			local ButtonStroke = Instance.new("UIStroke");
			ButtonStroke.Parent = Button;
			ButtonStroke.Color = _G.Third;
			ButtonStroke.Thickness = 1;
			ButtonStroke.Transparency = 0.8;
			
			TextButton.Name = "TextButton";
			TextButton.Parent = Button;
			TextButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			TextButton.BackgroundTransparency = 0.9;
			TextButton.AnchorPoint = Vector2.new(1, 0.5);
			TextButton.Position = UDim2.new(1, -8, 0.5, 0);
			TextButton.Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize);
			TextButton.Font = Enum.Font.Gotham;
			TextButton.Text = "";
			TextButton.TextXAlignment = Enum.TextXAlignment.Left;
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextButton.TextSize = 15;
			TextButton.AutoButtonColor = false;
			CreateRounded(TextButton, 6);
			
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = TextButton;
			ImageLabel.BackgroundColor3 = _G.Primary;
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
			ImageLabel.Size = UDim2.new(0, GetDeviceSize(18, 17, 16), 0, GetDeviceSize(18, 17, 16));
			ImageLabel.Image = "rbxassetid://10734898355";
			ImageLabel.ImageTransparency = 0;
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255);
			
			TextLabel.Name = "TextLabel";
			TextLabel.Parent = Button;
			TextLabel.BackgroundColor3 = _G.Primary;
			TextLabel.BackgroundTransparency = 1;
			TextLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextLabel.Position = UDim2.new(0, GetDeviceSize(45, 42, 40), 0.5, 0);
			TextLabel.Size = UDim2.new(1, GetDeviceSize(-85, -82, -75), 1, 0);
			TextLabel.Font = Enum.Font.Gotham;
			TextLabel.RichText = true;
			TextLabel.Text = text;
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
			TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220);
			TextLabel.TextSize = buttonTextSize;
			TextLabel.ClipsDescendants = true;
			
			ArrowRight.Name = "ArrowRight";
			ArrowRight.Parent = Button;
			ArrowRight.BackgroundColor3 = _G.Primary;
			ArrowRight.BackgroundTransparency = 1;
			ArrowRight.AnchorPoint = Vector2.new(0, 0.5);
			ArrowRight.Position = UDim2.new(0, GetDeviceSize(15, 13, 12), 0.5, 0);
			ArrowRight.Size = UDim2.new(0, arrowIconSize, 0, arrowIconSize);
			ArrowRight.Image = "rbxassetid://10709768347";
			ArrowRight.ImageTransparency = 0;
			ArrowRight.ImageColor3 = _G.Third;
			
			-- FIXED: Faster button animations
			if IsPC then
				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.1
					}):Play();
					TweenService:Create(ButtonStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
					TweenService:Create(ArrowRight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, GetDeviceSize(15, 13, 12) + 2, 0.5, 0)
					}):Play();
				end);
				
				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.2
					}):Play();
					TweenService:Create(ButtonStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.8
					}):Play();
					TweenService:Create(ArrowRight, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, GetDeviceSize(15, 13, 12), 0.5, 0)
					}):Play();
				end);
			end
			
			TextButton.MouseButton1Click:Connect(function()
				-- FIXED: Faster click animation
				TweenService:Create(TextButton, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, buttonIconSize - 3, 0, buttonIconSize - 3)
				}):Play();
				
				TweenService:Create(ImageLabel, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageColor3 = _G.Third
				}):Play();
				
				wait(0.05);
				
				TweenService:Create(TextButton, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize)
				}):Play();
				
				TweenService:Create(ImageLabel, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				}):Play();
				
				callback();
			end);
		end;
		
		function main:Toggle(text, config, desc, callback)
			config = config or false;
			local toggled = config;
			
			local Button = Instance.new("TextButton");
			local Title = Instance.new("TextLabel");
			local Desc = Instance.new("TextLabel");
			local ToggleFrame = Instance.new("Frame");
			local ToggleImage = Instance.new("TextButton");
			local Circle = Instance.new("Frame");
			
			local toggleHeight = GetDeviceSize(50, 46, 40);
			local toggleTitleSize = GetDeviceSize(14, 14, 15);
			local toggleDescSize = GetDeviceSize(11, 11, 12);
			local toggleFrameWidth = GetDeviceSize(40, 38, 36);
			local toggleFrameHeight = GetDeviceSize(22, 21, 20);
			local toggleCircleSize = GetDeviceSize(16, 15, 14);
			
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Button.BackgroundTransparency = 0.2;
			Button.AutoButtonColor = false;
			Button.Font = Enum.Font.SourceSans;
			Button.Text = "";
			Button.TextColor3 = Color3.fromRGB(0, 0, 0);
			Button.TextSize = 11;
			CreateRounded(Button, 8);
			
			-- Add toggle border
			local ToggleStroke = Instance.new("UIStroke");
			ToggleStroke.Parent = Button;
			ToggleStroke.Color = _G.Third;
			ToggleStroke.Thickness = 1;
			ToggleStroke.Transparency = 0.8;
			
			Title.Parent = Button;
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title.BackgroundTransparency = 1;
			Title.Size = UDim2.new(1, 0, 0, GetDeviceSize(25, 23, 22));
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.TextColor3 = Color3.fromRGB(220, 220, 220);
			Title.TextSize = toggleTitleSize;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			Title.AnchorPoint = Vector2.new(0, 0.5);
			
			Desc.Parent = Title;
			Desc.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
			Desc.BackgroundTransparency = 1;
			Desc.Position = UDim2.new(0, 0, 0, GetDeviceSize(25, 23, 22));
			Desc.Size = UDim2.new(0, 300, 0, GetDeviceSize(18, 17, 16));
			Desc.Font = Enum.Font.Gotham;
			Desc.TextColor3 = Color3.fromRGB(150, 150, 150);
			Desc.TextSize = toggleDescSize;
			Desc.TextXAlignment = Enum.TextXAlignment.Left;
			
			if desc then
				Desc.Text = desc;
				Title.Position = UDim2.new(0, GetDeviceSize(18, 16, 15), 0.5, -8);
				Desc.Position = UDim2.new(0, 0, 0, GetDeviceSize(25, 23, 22));
				Button.Size = UDim2.new(1, 0, 0, toggleHeight);
			else
				Title.Position = UDim2.new(0, GetDeviceSize(18, 16, 15), 0.5, 0);
				Desc.Visible = false;
				Button.Size = UDim2.new(1, 0, 0, GetDeviceSize(40, 38, 36));
			end;
			
			ToggleFrame.Name = "ToggleFrame";
			ToggleFrame.Parent = Button;
			ToggleFrame.BackgroundColor3 = _G.Dark;
			ToggleFrame.BackgroundTransparency = 1;
			ToggleFrame.Position = UDim2.new(1, GetDeviceSize(-50, -47, -45), 0.5, 0);
			ToggleFrame.Size = UDim2.new(0, toggleFrameWidth, 0, toggleFrameHeight);
			ToggleFrame.AnchorPoint = Vector2.new(1, 0.5);
			CreateRounded(ToggleFrame, 12);
			
			ToggleImage.Name = "ToggleImage";
			ToggleImage.Parent = ToggleFrame;
			ToggleImage.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
			ToggleImage.BackgroundTransparency = 0.2;
			ToggleImage.Position = UDim2.new(0, 0, 0, 0);
			ToggleImage.AnchorPoint = Vector2.new(0, 0);
			ToggleImage.Size = UDim2.new(1, 0, 1, 0);
			ToggleImage.Text = "";
			ToggleImage.AutoButtonColor = false;
			CreateRounded(ToggleImage, 12);
			
			-- Add toggle glow
			local ToggleGlow = Instance.new("UIStroke");
			ToggleGlow.Parent = ToggleImage;
			ToggleGlow.Color = _G.Third;
			ToggleGlow.Thickness = 1.5;
			ToggleGlow.Transparency = 0.9;
			
			Circle.Name = "Circle";
			Circle.Parent = ToggleImage;
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Circle.BackgroundTransparency = 0;
			Circle.Position = UDim2.new(0, 3, 0.5, 0);
			Circle.Size = UDim2.new(0, toggleCircleSize, 0, toggleCircleSize);
			Circle.AnchorPoint = Vector2.new(0, 0.5);
			CreateRounded(Circle, 10);
			
			-- FIXED: Faster toggle animations
			ToggleImage.MouseButton1Click:Connect(function()
				if toggled == false then
					toggled = true;
					
					-- FIXED: Faster on animation
					TweenService:Create(Circle, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, toggleFrameWidth - toggleCircleSize - 3, 0.5, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play();
					
					TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = _G.Third,
						BackgroundTransparency = 0
					}):Play();
					
					TweenService:Create(ToggleGlow, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
				else
					toggled = false;
					
					-- FIXED: Faster off animation
					TweenService:Create(Circle, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, 3, 0.5, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					}):Play();
					
					TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(60, 60, 65),
						BackgroundTransparency = 0.2
					}):Play();
					
					TweenService:Create(ToggleGlow, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.9
					}):Play();
				end;
				
				pcall(callback, toggled);
			end);
			
			-- FIXED: Faster hover effects for desktop
			if IsPC then
				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.1
					}):Play();
					TweenService:Create(ToggleStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
				end);
				
				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.2
					}):Play();
					TweenService:Create(ToggleStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.8
					}):Play();
				end);
			end
			
			-- Set initial state
			if config == true then
				toggled = true;
				Circle.Position = UDim2.new(0, toggleFrameWidth - toggleCircleSize - 3, 0.5, 0);
				ToggleImage.BackgroundColor3 = _G.Third;
				ToggleImage.BackgroundTransparency = 0;
				ToggleGlow.Transparency = 0.5;
				pcall(callback, toggled);
			end;
		end;
		
		function main:Dropdown(text, option, var, callback)
			local isdropping = false;
			local Dropdown = Instance.new("Frame");
			local DropdownFrameScroll = Instance.new("Frame");
			local DropTitle = Instance.new("TextLabel");
			local DropScroll = Instance.new("ScrollingFrame");
			local UIListLayout = Instance.new("UIListLayout");
			local UIPadding = Instance.new("UIPadding");
			local SelectItems = Instance.new("TextButton");
			local ArrowDown = Instance.new("ImageLabel");
			
			local dropdownHeight = GetDeviceSize(45, 43, 42);
			local dropdownTitleSize = GetDeviceSize(14, 14, 15);
			local dropdownSelectWidth = GetDeviceSize(120, 115, 110);
			local dropdownSelectHeight = GetDeviceSize(28, 26, 25);
			local dropdownListHeight = GetDeviceSize(120, 115, 110);
			
			Dropdown.Name = "Dropdown";
			Dropdown.Parent = MainFramePage;
			Dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Dropdown.BackgroundTransparency = 0.2;
			Dropdown.ClipsDescendants = false;
			Dropdown.Size = UDim2.new(1, 0, 0, dropdownHeight);
			CreateRounded(Dropdown, 8);
			
			-- Add dropdown border
			local DropdownStroke = Instance.new("UIStroke");
			DropdownStroke.Parent = Dropdown;
			DropdownStroke.Color = _G.Third;
			DropdownStroke.Thickness = 1;
			DropdownStroke.Transparency = 0.8;
			
			DropTitle.Name = "DropTitle";
			DropTitle.Parent = Dropdown;
			DropTitle.BackgroundColor3 = _G.Primary;
			DropTitle.BackgroundTransparency = 1;
			DropTitle.Size = UDim2.new(1, 0, 0, GetDeviceSize(25, 23, 22));
			DropTitle.Font = Enum.Font.Gotham;
			DropTitle.Text = text;
			DropTitle.TextColor3 = Color3.fromRGB(220, 220, 220);
			DropTitle.TextSize = dropdownTitleSize;
			DropTitle.TextXAlignment = Enum.TextXAlignment.Left;
			DropTitle.Position = UDim2.new(0, GetDeviceSize(18, 16, 15), 0, GetDeviceSize(8, 7, 6));
			DropTitle.AnchorPoint = Vector2.new(0, 0);
			
			SelectItems.Name = "SelectItems";
			SelectItems.Parent = Dropdown;
			SelectItems.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
			SelectItems.TextColor3 = Color3.fromRGB(200, 200, 200);
			SelectItems.BackgroundTransparency = 0.3;
			SelectItems.Position = UDim2.new(1, GetDeviceSize(-12, -11, -10), 0, GetDeviceSize(8, 7, 6));
			SelectItems.Size = UDim2.new(0, dropdownSelectWidth, 0, dropdownSelectHeight);
			SelectItems.AnchorPoint = Vector2.new(1, 0);
			SelectItems.Font = Enum.Font.Gotham;
			SelectItems.AutoButtonColor = false;
			SelectItems.TextSize = GetDeviceSize(12, 12, 11);
			SelectItems.ZIndex = 1;
			SelectItems.ClipsDescendants = true;
			SelectItems.Text = "   Select Item";
			SelectItems.TextXAlignment = Enum.TextXAlignment.Left;
			CreateRounded(SelectItems, 6);
			
			ArrowDown.Name = "ArrowDown";
			ArrowDown.Parent = Dropdown;
			ArrowDown.BackgroundColor3 = _G.Primary;
			ArrowDown.BackgroundTransparency = 1;
			ArrowDown.AnchorPoint = Vector2.new(1, 0);
			ArrowDown.Position = UDim2.new(1, GetDeviceSize(-140, -135, -125), 0, GetDeviceSize(15, 14, 13));
			ArrowDown.Size = UDim2.new(0, GetDeviceSize(16, 15, 14), 0, GetDeviceSize(16, 15, 14));
			ArrowDown.Image = "rbxassetid://10709790948";
			ArrowDown.ImageTransparency = 0;
			ArrowDown.ImageColor3 = Color3.fromRGB(200, 200, 200);
			
			DropdownFrameScroll.Name = "DropdownFrameScroll";
			DropdownFrameScroll.Parent = Dropdown;
			DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 26);
			DropdownFrameScroll.BackgroundTransparency = 0.1;
			DropdownFrameScroll.ClipsDescendants = true;
			DropdownFrameScroll.Size = UDim2.new(1, 0, 0, dropdownListHeight);
			DropdownFrameScroll.Position = UDim2.new(0, 0, 0, GetDeviceSize(50, 48, 47));
			DropdownFrameScroll.Visible = false;
			DropdownFrameScroll.AnchorPoint = Vector2.new(0, 0);
			CreateRounded(DropdownFrameScroll, 8);
			
			-- Add dropdown list border
			local DropListStroke = Instance.new("UIStroke");
			DropListStroke.Parent = DropdownFrameScroll;
			DropListStroke.Color = _G.Third;
			DropListStroke.Thickness = 1;
			DropListStroke.Transparency = 0.6;
			
			DropScroll.Name = "DropScroll";
			DropScroll.Parent = DropdownFrameScroll;
			DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y;
			DropScroll.Active = true;
			DropScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			DropScroll.BackgroundTransparency = 1;
			DropScroll.BorderSizePixel = 0;
			DropScroll.Position = UDim2.new(0, 0, 0, 8);
			DropScroll.Size = UDim2.new(1, 0, 1, -16);
			DropScroll.AnchorPoint = Vector2.new(0, 0);
			DropScroll.ClipsDescendants = true;
			DropScroll.ScrollBarThickness = GetDeviceSize(6, 5, 4);
			DropScroll.ScrollBarImageColor3 = _G.Third;
			DropScroll.ZIndex = 3;
			
			local PaddingDrop = Instance.new("UIPadding");
			PaddingDrop.PaddingLeft = UDim.new(0, 12);
			PaddingDrop.PaddingRight = UDim.new(0, 12);
			PaddingDrop.PaddingTop = UDim.new(0, 6);
			PaddingDrop.PaddingBottom = UDim.new(0, 6);
			PaddingDrop.Parent = DropScroll;
			PaddingDrop.Name = "PaddingDrop";
			
			UIListLayout.Parent = DropScroll;
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			UIListLayout.Padding = UDim.new(0, GetDeviceSize(3, 3, 2));
			
			-- Create dropdown items
			for i, v in next, option do
				local Item = Instance.new("TextButton");
				local SelectedItems = Instance.new("Frame");
				
				local itemHeight = GetDeviceSize(35, 33, 32);
				local itemTextSize = GetDeviceSize(13, 12, 12);
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
				Item.BackgroundTransparency = 0.8;
				Item.Size = UDim2.new(1, 0, 0, itemHeight);
				Item.Font = Enum.Font.Gotham;
				Item.Text = tostring(v);
				Item.TextColor3 = Color3.fromRGB(200, 200, 200);
				Item.TextSize = itemTextSize;
				Item.TextTransparency = 0.3;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				Item.AutoButtonColor = false;
				CreateRounded(Item, 6);
				
				local ItemPadding = Instance.new("UIPadding");
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, GetDeviceSize(35, 33, 32));
				
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 4, 0.6, 0);
				SelectedItems.Position = UDim2.new(0, GetDeviceSize(12, 11, 10), 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				CreateRounded(SelectedItems, 2);
				
				-- FIXED: Faster item animations
				if IsPC then
					Item.MouseEnter:Connect(function()
						TweenService:Create(Item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundTransparency = 0.5,
							TextTransparency = 0.1
						}):Play();
					end);
					
					Item.MouseLeave:Connect(function()
						if Item.BackgroundTransparency > 0.6 then -- Only if not selected
							TweenService:Create(Item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
								BackgroundTransparency = 0.8,
								TextTransparency = 0.3
							}):Play();
						end
					end);
				end
				
				-- Set initial state if var is provided
				if var and tostring(var) == tostring(v) then
					SelectItems.Text = "   " .. tostring(v);
					Item.BackgroundTransparency = 0.3;
					Item.TextTransparency = 0;
					SelectedItems.BackgroundTransparency = 0;
					pcall(callback, v);
				end
				
				Item.MouseButton1Click:Connect(function()
					SelectItems.ClipsDescendants = true;
					callback(Item.Text);
					
					-- Reset all items
					for i, item in next, DropScroll:GetChildren() do
						if item:IsA("TextButton") then
							local selectedIndicator = item:FindFirstChild("SelectedItems");
							TweenService:Create(item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
								BackgroundTransparency = 0.8,
								TextTransparency = 0.3
							}):Play();
							if selectedIndicator then
								TweenService:Create(selectedIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
									BackgroundTransparency = 1
								}):Play();
							end
						end;
					end
					
					-- Activate selected item
					TweenService:Create(Item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.3,
						TextTransparency = 0
					}):Play();
					TweenService:Create(SelectedItems, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0
					}):Play();
					
					SelectItems.Text = "   " .. Item.Text;
				end);
			end;
			
			DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12);
			
			-- FIXED: Faster dropdown toggle
			SelectItems.MouseButton1Click:Connect(function()
				if isdropping == false then
					isdropping = true;
					
					-- FIXED: Faster open animation
					DropdownFrameScroll.Visible = true;
					DropdownFrameScroll.Size = UDim2.new(1, 0, 0, 0);
					
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, dropdownListHeight)
					}):Play();
					
					TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, dropdownHeight + dropdownListHeight + 5)
					}):Play();
					
					TweenService:Create(ArrowDown, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 180,
						ImageColor3 = _G.Third
					}):Play();
					
					TweenService:Create(DropdownStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
				else
					isdropping = false;
					
					-- FIXED: Faster close animation
					TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, 0)
					}):Play();
					
					TweenService:Create(Dropdown, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, dropdownHeight)
					}):Play();
					
					TweenService:Create(ArrowDown, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 0,
						ImageColor3 = Color3.fromRGB(200, 200, 200)
					}):Play();
					
					TweenService:Create(DropdownStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.8
					}):Play();
					
					wait(0.15);
					DropdownFrameScroll.Visible = false;
				end;
			end);
			
			-- FIXED: Faster hover effects for desktop
			if IsPC then
				Dropdown.MouseEnter:Connect(function()
					TweenService:Create(Dropdown, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.1
					}):Play();
					TweenService:Create(DropdownStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.6
					}):Play();
				end);
				
				Dropdown.MouseLeave:Connect(function()
					if not isdropping then
						TweenService:Create(Dropdown, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundTransparency = 0.2
						}):Play();
						TweenService:Create(DropdownStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Transparency = 0.8
						}):Play();
					end
				end);
			end
			
			local dropfunc = {};
			function dropfunc:Add(t)
				local Item = Instance.new("TextButton");
				local SelectedItems = Instance.new("Frame");
				
				local itemHeight = GetDeviceSize(35, 33, 32);
				local itemTextSize = GetDeviceSize(13, 12, 12);
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
				Item.BackgroundTransparency = 0.8;
				Item.Size = UDim2.new(1, 0, 0, itemHeight);
				Item.Font = Enum.Font.Gotham;
				Item.Text = tostring(t);
				Item.TextColor3 = Color3.fromRGB(200, 200, 200);
				Item.TextSize = itemTextSize;
				Item.TextTransparency = 0.3;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				Item.AutoButtonColor = false;
				CreateRounded(Item, 6);
				
				local ItemPadding = Instance.new("UIPadding");
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, GetDeviceSize(35, 33, 32));
				
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 4, 0.6, 0);
				SelectedItems.Position = UDim2.new(0, GetDeviceSize(12, 11, 10), 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				CreateRounded(SelectedItems, 2);
				
				Item.MouseButton1Click:Connect(function()
					callback(Item.Text);
					
					-- Reset all items
					for i, item in next, DropScroll:GetChildren() do
						if item:IsA("TextButton") then
							local selectedIndicator = item:FindFirstChild("SelectedItems");
							TweenService:Create(item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
								BackgroundTransparency = 0.8,
								TextTransparency = 0.3
							}):Play();
							if selectedIndicator then
								TweenService:Create(selectedIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
									BackgroundTransparency = 1
								}):Play();
							end
						end;
					end
					
					-- Activate selected item
					TweenService:Create(Item, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.3,
						TextTransparency = 0
					}):Play();
					TweenService:Create(SelectedItems, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0
					}):Play();
					
					SelectItems.Text = "   " .. Item.Text;
				end);
				
				DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12);
			end;
			
			function dropfunc:Clear()
				SelectItems.Text = "   Select Item";
				isdropping = false;
				DropdownFrameScroll.Visible = false;
				Dropdown.Size = UDim2.new(1, 0, 0, dropdownHeight);
				ArrowDown.Rotation = 0;
				ArrowDown.ImageColor3 = Color3.fromRGB(200, 200, 200);
				
				for i, v in next, DropScroll:GetChildren() do
					if v:IsA("TextButton") then
						v:Destroy();
					end;
				end;
			end;
			
			return dropfunc;
		end;
		
		function main:Slider(text, min, max, set, callback)
			local Slider = Instance.new("Frame");
			local Title = Instance.new("TextLabel");
			local ValueText = Instance.new("TextLabel");
			local bar = Instance.new("Frame");
			local bar1 = Instance.new("Frame");
			local circlebar = Instance.new("Frame");
			
			local sliderHeight = GetDeviceSize(40, 39, 38);
			local sliderTitleSize = GetDeviceSize(14, 14, 15);
			local sliderBarWidth = GetDeviceSize(110, 105, 100);
			local sliderBarHeight = GetDeviceSize(6, 6, 5);
			local sliderCircleSize = GetDeviceSize(16, 15, 14);
			
			Slider.Name = "Slider";
			Slider.Parent = MainFramePage;
			Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Slider.BackgroundTransparency = 0.2;
			Slider.Size = UDim2.new(1, 0, 0, sliderHeight);
			CreateRounded(Slider, 8);
			
			-- Add slider border
			local SliderStroke = Instance.new("UIStroke");
			SliderStroke.Parent = Slider;
			SliderStroke.Color = _G.Third;
			SliderStroke.Thickness = 1;
			SliderStroke.Transparency = 0.8;
			
			Title.Parent = Slider;
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0, GetDeviceSize(18, 16, 15), 0.5, 0);
			Title.Size = UDim2.new(1, 0, 0, GetDeviceSize(22, 21, 20));
			Title.Font = Enum.Font.Gotham;
			Title.Text = text;
			Title.AnchorPoint = Vector2.new(0, 0.5);
			Title.TextColor3 = Color3.fromRGB(220, 220, 220);
			Title.TextSize = sliderTitleSize;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			
			ValueText.Parent = bar;
			ValueText.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			ValueText.BackgroundTransparency = 1;
			ValueText.Position = UDim2.new(0, GetDeviceSize(-45, -42, -40), 0.5, 0);
			ValueText.Size = UDim2.new(0, GetDeviceSize(35, 33, 32), 0, GetDeviceSize(22, 21, 20));
			ValueText.Font = Enum.Font.GothamBold;
			ValueText.Text = tostring(set);
			ValueText.AnchorPoint = Vector2.new(0, 0.5);
			ValueText.TextColor3 = _G.Third;
			ValueText.TextSize = GetDeviceSize(13, 13, 14);
			ValueText.TextXAlignment = Enum.TextXAlignment.Right;
			
			bar.Name = "bar";
			bar.Parent = Slider;
			bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55);
			bar.Size = UDim2.new(0, sliderBarWidth, 0, sliderBarHeight);
			bar.Position = UDim2.new(1, GetDeviceSize(-15, -13, -12), 0.5, 0);
			bar.BackgroundTransparency = 0.3;
			bar.AnchorPoint = Vector2.new(1, 0.5);
			CreateRounded(bar, 3);
			
			bar1.Name = "bar1";
			bar1.Parent = bar;
			bar1.BackgroundColor3 = _G.Third;
			bar1.BackgroundTransparency = 0;
			bar1.Size = UDim2.new((set - min) / (max - min), 0, 1, 0);
			CreateRounded(bar1, 3);
			
			circlebar.Name = "circlebar";
			circlebar.Parent = bar1;
			circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			circlebar.Position = UDim2.new(1, 0, 0.5, 0);
			circlebar.AnchorPoint = Vector2.new(0.5, 0.5);
			circlebar.Size = UDim2.new(0, sliderCircleSize, 0, sliderCircleSize);
			CreateRounded(circlebar, 10);
			
			-- Add circle glow
			local CircleGlow = Instance.new("UIStroke");
			CircleGlow.Parent = circlebar;
			CircleGlow.Color = _G.Third;
			CircleGlow.Thickness = 2;
			CircleGlow.Transparency = 0.7;
			
			local Value = set;
			local Dragging = false;
			
			-- FIXED: Faster slider interactions
			circlebar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
					
					-- FIXED: Faster visual feedback for drag start
					TweenService:Create(circlebar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, sliderCircleSize + 3, 0, sliderCircleSize + 3)
					}):Play();
					TweenService:Create(CircleGlow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.3
					}):Play();
				end;
			end);
			
			bar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
					
					TweenService:Create(circlebar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, sliderCircleSize + 3, 0, sliderCircleSize + 3)
					}):Play();
					TweenService:Create(CircleGlow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.3
					}):Play();
				end;
			end);
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if Dragging then
						Dragging = false;
						
						-- FIXED: Faster visual feedback for drag end
						TweenService:Create(circlebar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, sliderCircleSize, 0, sliderCircleSize)
						}):Play();
						TweenService:Create(CircleGlow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Transparency = 0.7
						}):Play();
					end
				end;
			end);
			
			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					local percentage = math.clamp((Input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1);
					Value = math.floor(min + (max - min) * percentage);
					
					-- FIXED: Faster slider animation
					TweenService:Create(bar1, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(percentage, 0, 1, 0)
					}):Play();
					
					ValueText.Text = tostring(Value);
					pcall(callback, Value);
				end;
			end);
			
			-- FIXED: Faster hover effects for desktop
			if IsPC then
				Slider.MouseEnter:Connect(function()
					TweenService:Create(Slider, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.1
					}):Play();
					TweenService:Create(SliderStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
				end);
				
				Slider.MouseLeave:Connect(function()
					if not Dragging then
						TweenService:Create(Slider, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundTransparency = 0.2
						}):Play();
						TweenService:Create(SliderStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Transparency = 0.8
						}):Play();
					end
				end);
			end
			
			-- Initialize callback
			pcall(callback, Value);
		end;
		
		function main:Textbox(text, disappear, callback)
			local Textbox = Instance.new("Frame");
			local TextboxLabel = Instance.new("TextLabel");
			local RealTextbox = Instance.new("TextBox");
			
			local textboxHeight = GetDeviceSize(40, 39, 38);
			local textboxTitleSize = GetDeviceSize(14, 14, 15);
			local textboxInputWidth = GetDeviceSize(100, 95, 90);
			local textboxInputHeight = GetDeviceSize(28, 26, 25);
			local textboxInputTextSize = GetDeviceSize(12, 12, 13);
			
			Textbox.Name = "Textbox";
			Textbox.Parent = MainFramePage;
			Textbox.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Textbox.BackgroundTransparency = 0.2;
			Textbox.Size = UDim2.new(1, 0, 0, textboxHeight);
			CreateRounded(Textbox, 8);
			
			-- Add textbox border
			local TextboxStroke = Instance.new("UIStroke");
			TextboxStroke.Parent = Textbox;
			TextboxStroke.Color = _G.Third;
			TextboxStroke.Thickness = 1;
			TextboxStroke.Transparency = 0.8;
			
			TextboxLabel.Name = "TextboxLabel";
			TextboxLabel.Parent = Textbox;
			TextboxLabel.BackgroundColor3 = _G.Primary;
			TextboxLabel.BackgroundTransparency = 1;
			TextboxLabel.Position = UDim2.new(0, GetDeviceSize(18, 16, 15), 0.5, 0);
			TextboxLabel.Text = text;
			TextboxLabel.Size = UDim2.new(1, 0, 0, GetDeviceSize(22, 21, 20));
			TextboxLabel.Font = Enum.Font.Gotham;
			TextboxLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextboxLabel.TextColor3 = Color3.fromRGB(220, 220, 220);
			TextboxLabel.TextSize = textboxTitleSize;
			TextboxLabel.TextTransparency = 0;
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left;
			
			RealTextbox.Name = "RealTextbox";
			RealTextbox.Parent = Textbox;
			RealTextbox.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
			RealTextbox.BackgroundTransparency = 0.3;
			RealTextbox.Position = UDim2.new(1, GetDeviceSize(-12, -11, -10), 0.5, 0);
			RealTextbox.AnchorPoint = Vector2.new(1, 0.5);
			RealTextbox.Size = UDim2.new(0, textboxInputWidth, 0, textboxInputHeight);
			RealTextbox.Font = Enum.Font.Gotham;
			RealTextbox.Text = "";
			RealTextbox.PlaceholderText = "Enter text...";
			RealTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120);
			RealTextbox.TextColor3 = Color3.fromRGB(255, 255, 255);
			RealTextbox.TextSize = textboxInputTextSize;
			RealTextbox.TextTransparency = 0;
			RealTextbox.ClipsDescendants = true;
			CreateRounded(RealTextbox, 6);
			
			-- Add textbox input border
			local InputStroke = Instance.new("UIStroke");
			InputStroke.Parent = RealTextbox;
			InputStroke.Color = _G.Third;
			InputStroke.Thickness = 1;
			InputStroke.Transparency = 0.8;
			
			-- FIXED: Faster textbox interactions
			RealTextbox.Focused:Connect(function()
				TweenService:Create(InputStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.3
				}):Play();
				TweenService:Create(RealTextbox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.1
				}):Play();
			end);
			
			RealTextbox.FocusLost:Connect(function()
				TweenService:Create(InputStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.8
				}):Play();
				TweenService:Create(RealTextbox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.3
				}):Play();
				
				callback(RealTextbox.Text);
			end);
			
			-- FIXED: Faster hover effects for desktop
			if IsPC then
				Textbox.MouseEnter:Connect(function()
					TweenService:Create(Textbox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.1
					}):Play();
					TweenService:Create(TextboxStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.5
					}):Play();
				end);
				
				Textbox.MouseLeave:Connect(function()
					TweenService:Create(Textbox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.2
					}):Play();
					TweenService:Create(TextboxStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Transparency = 0.8
					}):Play();
				end);
			end
		end;
		
		function main:Label(text)
			local Frame = Instance.new("Frame");
			local Label = Instance.new("TextLabel");
			local ImageLabel = Instance.new("ImageLabel");
			
			local labelHeight = GetDeviceSize(35, 33, 32);
			local labelTextSize = GetDeviceSize(14, 14, 15);
			local labelIconSize = GetDeviceSize(18, 17, 16);
			
			Frame.Name = "Frame";
			Frame.Parent = MainFramePage;
			Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 32);
			Frame.BackgroundTransparency = 0.5;
			Frame.Size = UDim2.new(1, 0, 0, labelHeight);
			CreateRounded(Frame, 8);
			
			Label.Name = "Label";
			Label.Parent = Frame;
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Label.BackgroundTransparency = 1;
			Label.Size = UDim2.new(1, GetDeviceSize(-45, -42, -40), 0, GetDeviceSize(22, 21, 20));
			Label.Font = Enum.Font.Gotham;
			Label.Position = UDim2.new(0, GetDeviceSize(40, 37, 35), 0.5, 0);
			Label.AnchorPoint = Vector2.new(0, 0.5);
			Label.TextColor3 = Color3.fromRGB(200, 200, 200);
			Label.TextSize = labelTextSize;
			Label.Text = text;
			Label.TextXAlignment = Enum.TextXAlignment.Left;
			
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = Frame;
			ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.ImageTransparency = 0;
			ImageLabel.Position = UDim2.new(0, GetDeviceSize(15, 13, 12), 0.5, 0);
			ImageLabel.Size = UDim2.new(0, labelIconSize, 0, labelIconSize);
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
			ImageLabel.Image = "rbxassetid://10723415903";
			ImageLabel.ImageColor3 = _G.Third;
			
			local labelfunc = {};
			function labelfunc:Set(newtext)
				Label.Text = newtext;
				
				-- FIXED: Faster text update animation
				TweenService:Create(Label, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0.5
				}):Play();
				
				wait(0.05);
				
				TweenService:Create(Label, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0
				}):Play();
			end;
			
			return labelfunc;
		end;
		
		function main:Seperator(text)
			local Seperator = Instance.new("Frame");
			local Sep1 = Instance.new("TextLabel");
			local Sep2 = Instance.new("TextLabel");
			local Sep3 = Instance.new("TextLabel");
			
			local separatorHeight = GetDeviceSize(40, 39, 38);
			local separatorTextSize = GetDeviceSize(15, 15, 16);
			
			Seperator.Name = "Seperator";
			Seperator.Parent = MainFramePage;
			Seperator.BackgroundColor3 = _G.Primary;
			Seperator.BackgroundTransparency = 1;
			Seperator.Size = UDim2.new(1, 0, 0, separatorHeight);
			
			-- Enhanced separator with gradient lines
			Sep1.Name = "Sep1";
			Sep1.Parent = Seperator;
			Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep1.BackgroundTransparency = 0;
			Sep1.AnchorPoint = Vector2.new(0, 0.5);
			Sep1.Position = UDim2.new(0, 0, 0.5, 0);
			Sep1.Size = UDim2.new(0.2, 0, 0, 2);
			Sep1.BorderSizePixel = 0;
			Sep1.Text = "";
			CreateRounded(Sep1, 1);
			
			local Grad1 = Instance.new("UIGradient");
			Grad1.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 32)),
				ColorSequenceKeypoint.new(0.3, _G.Third),
				ColorSequenceKeypoint.new(0.7, _G.Third),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 32))
			});
			Grad1.Parent = Sep1;
			
			Sep2.Name = "Sep2";
			Sep2.Parent = Seperator;
			Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep2.BackgroundTransparency = 1;
			Sep2.AnchorPoint = Vector2.new(0.5, 0.5);
			Sep2.Position = UDim2.new(0.5, 0, 0.5, 0);
			Sep2.Size = UDim2.new(1, 0, 0, GetDeviceSize(25, 24, 22));
			Sep2.Font = Enum.Font.GothamBold;
			Sep2.Text = text;
			Sep2.TextColor3 = Color3.fromRGB(255, 255, 255);
			Sep2.TextSize = separatorTextSize;
			
			-- Add text glow effect
			local TextGlow = Instance.new("UIStroke");
			TextGlow.Parent = Sep2;
			TextGlow.Color = _G.Third;
			TextGlow.Thickness = 1;
			TextGlow.Transparency = 0.8;
			
			Sep3.Name = "Sep3";
			Sep3.Parent = Seperator;
			Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep3.BackgroundTransparency = 0;
			Sep3.AnchorPoint = Vector2.new(1, 0.5);
			Sep3.Position = UDim2.new(1, 0, 0.5, 0);
			Sep3.Size = UDim2.new(0.2, 0, 0, 2);
			Sep3.BorderSizePixel = 0;
			Sep3.Text = "";
			CreateRounded(Sep3, 1);
			
			local Grad3 = Instance.new("UIGradient");
			Grad3.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 32)),
				ColorSequenceKeypoint.new(0.3, _G.Third),
				ColorSequenceKeypoint.new(0.7, _G.Third),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 32))
			});
			Grad3.Parent = Sep3;
		end;
		
		function main:Line()
			local Linee = Instance.new("Frame");
			local Line = Instance.new("Frame");
			
			local lineHeight = GetDeviceSize(25, 23, 22);
			
			Linee.Name = "Linee";
			Linee.Parent = MainFramePage;
			Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Linee.BackgroundTransparency = 1;
			Linee.Position = UDim2.new(0, 0, 0.119999997, 0);
			Linee.Size = UDim2.new(1, 0, 0, lineHeight);
			
			Line.Name = "Line";
			Line.Parent = Linee;
			Line.BackgroundColor3 = Color3.new(125, 125, 125);
			Line.BorderSizePixel = 0;
			Line.Position = UDim2.new(0, 0, 0.5, 0);
			Line.Size = UDim2.new(1, 0, 0, 2);
			Line.AnchorPoint = Vector2.new(0, 0.5);
			CreateRounded(Line, 1);
			
			-- Enhanced line gradient
			local UIGradient = Instance.new("UIGradient");
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 32)),
				ColorSequenceKeypoint.new(0.2, Color3.fromRGB(60, 60, 65)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 85)),
				ColorSequenceKeypoint.new(0.8, Color3.fromRGB(60, 60, 65)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 32))
			});
			UIGradient.Parent = Line;
		end;
		
		return main;
	end;
	
	return uitab;
end;

-- Final initialization
Update:Notify("🚀 Xenon Hub Enhanced Edition loaded successfully!", "success");

return Update;
