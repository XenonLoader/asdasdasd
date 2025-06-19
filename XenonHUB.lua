if (game:GetService("CoreGui")):FindFirstChild("Xenon") and (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then
	(game:GetService("CoreGui")).Xenon:Destroy();
	(game:GetService("CoreGui")).ScreenGui:Destroy();
end;

-- Enhanced Color Palette with more vibrant colors
_G.Primary = Color3.fromRGB(115, 115, 120);
_G.Dark = Color3.fromRGB(25, 25, 30);
_G.Third = Color3.fromRGB(255, 50, 75);
_G.Accent = Color3.fromRGB(120, 120, 255);
_G.Success = Color3.fromRGB(75, 255, 75);
_G.Warning = Color3.fromRGB(255, 200, 50);
_G.Gradient1 = Color3.fromRGB(255, 100, 150);
_G.Gradient2 = Color3.fromRGB(100, 150, 255);

function CreateRounded(Parent, Size)
	local Rounded = Instance.new("UICorner");
	Rounded.Name = "Rounded";
	Rounded.Parent = Parent;
	Rounded.CornerRadius = UDim.new(0, Size);
end;

function CreateGradient(Parent, ColorSequence)
	local Gradient = Instance.new("UIGradient");
	Gradient.Color = ColorSequence;
	Gradient.Parent = Parent;
	return Gradient;
end;

function CreateStroke(Parent, Color, Thickness)
	local Stroke = Instance.new("UIStroke");
	Stroke.Color = Color or Color3.fromRGB(60, 60, 65);
	Stroke.Thickness = Thickness or 1;
	Stroke.Parent = Parent;
	return Stroke;
end;

function CreateShadow(Parent)
	local Shadow = Instance.new("ImageLabel");
	Shadow.Name = "Shadow";
	Shadow.Parent = Parent;
	Shadow.BackgroundTransparency = 1;
	Shadow.Image = "rbxassetid://6014261993";
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0);
	Shadow.ImageTransparency = 0.8;
	Shadow.Position = UDim2.new(0, -15, 0, -15);
	Shadow.Size = UDim2.new(1, 30, 1, 30);
	Shadow.ZIndex = -1;
	return Shadow;
end;

-- Enhanced Particle System for Loading Animation
function CreateParticle(Parent, Color, Size, Speed)
	local Particle = Instance.new("Frame");
	Particle.Name = "Particle";
	Particle.Parent = Parent;
	Particle.BackgroundColor3 = Color;
	Particle.Size = UDim2.new(0, Size, 0, Size);
	Particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0);
	Particle.BackgroundTransparency = 0.3;
	CreateRounded(Particle, Size / 2);
	
	-- Animate particle
	local TweenInfo = TweenInfo.new(Speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true);
	local Tween = game:GetService("TweenService"):Create(Particle, TweenInfo, {
		Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0),
		BackgroundTransparency = 0.8
	});
	Tween:Play();
	
	return Particle;
end;

local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");

function MakeDraggable(topbarobject, object)
	local Dragging = nil;
	local DragInput = nil;
	local DragStart = nil;
	local StartPosition = nil;
	local function Update(input)
		local Delta = input.Position - DragStart;
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y);
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {
			Position = pos
		});
		Tween:Play();
	end;
	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
			DragStart = input.Position;
			StartPosition = object.Position;
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false;
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

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Parent = game.CoreGui;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

local OutlineButton = Instance.new("Frame");
OutlineButton.Name = "OutlineButton";
OutlineButton.Parent = ScreenGui;
OutlineButton.ClipsDescendants = true;
OutlineButton.BackgroundColor3 = _G.Dark;
OutlineButton.BackgroundTransparency = 0;
OutlineButton.Position = UDim2.new(0, 10, 0, 10);
OutlineButton.Size = UDim2.new(0, 50, 0, 50);
CreateRounded(OutlineButton, 12);
CreateStroke(OutlineButton, Color3.fromRGB(40, 40, 45), 1);

-- Add glow effect to main button
local ButtonGlow = Instance.new("ImageLabel");
ButtonGlow.Name = "ButtonGlow";
ButtonGlow.Parent = OutlineButton;
ButtonGlow.BackgroundTransparency = 1;
ButtonGlow.Image = "rbxassetid://6014261993";
ButtonGlow.ImageColor3 = _G.Third;
ButtonGlow.ImageTransparency = 0.9;
ButtonGlow.Position = UDim2.new(0, -10, 0, -10);
ButtonGlow.Size = UDim2.new(1, 20, 1, 20);
ButtonGlow.ZIndex = -1;

local ImageButton = Instance.new("ImageButton");
ImageButton.Parent = OutlineButton;
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0);
ImageButton.Size = UDim2.new(0, 40, 0, 40);
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
ImageButton.BackgroundColor3 = _G.Dark;
ImageButton.ImageColor3 = Color3.fromRGB(250, 250, 250);
ImageButton.ImageTransparency = 0;
ImageButton.BackgroundTransparency = 0;
ImageButton.Image = "rbxassetid://105059922903197";
ImageButton.AutoButtonColor = false;
MakeDraggable(ImageButton, OutlineButton);
CreateRounded(ImageButton, 10);

-- Enhanced hover effects for main button with glow
ImageButton.MouseEnter:Connect(function()
	TweenService:Create(ImageButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 42, 0, 42),
		ImageColor3 = _G.Third
	}):Play();
	TweenService:Create(OutlineButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	}):Play();
	TweenService:Create(ButtonGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		ImageTransparency = 0.7
	}):Play();
end);

ImageButton.MouseLeave:Connect(function()
	TweenService:Create(ImageButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 40, 0, 40),
		ImageColor3 = Color3.fromRGB(250, 250, 250)
	}):Play();
	TweenService:Create(OutlineButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		BackgroundColor3 = _G.Dark
	}):Play();
	TweenService:Create(ButtonGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		ImageTransparency = 0.9
	}):Play();
end);

ImageButton.MouseButton1Click:connect(function()
	(game.CoreGui:FindFirstChild("Xenon")).Enabled = not (game.CoreGui:FindFirstChild("Xenon")).Enabled;
end);

local NotificationFrame = Instance.new("ScreenGui");
NotificationFrame.Name = "NotificationFrame";
NotificationFrame.Parent = game.CoreGui;
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global;

local NotificationList = {};

local function RemoveOldestNotification()
	if #NotificationList > 0 then
		local removed = table.remove(NotificationList, 1);
		removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Quad", 0.4, true, function()
			removed[1]:Destroy();
		end);
	end;
end;

spawn(function()
	while wait() do
		if #NotificationList > 0 then
			wait(2);
			RemoveOldestNotification();
		end;
	end;
end);

local Update = {};

function Update:Notify(desc)
	local Frame = Instance.new("Frame");
	local Image = Instance.new("ImageLabel");
	local Title = Instance.new("TextLabel");
	local Desc = Instance.new("TextLabel");
	local OutlineFrame = Instance.new("Frame");
	
	OutlineFrame.Name = "OutlineFrame";
	OutlineFrame.Parent = NotificationFrame;
	OutlineFrame.ClipsDescendants = true;
	OutlineFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 1);
	OutlineFrame.BackgroundTransparency = 0.4;
	OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0);
	OutlineFrame.Size = UDim2.new(0, 412, 0, 72);
	
	Frame.Name = "Frame";
	Frame.Parent = OutlineFrame;
	Frame.ClipsDescendants = true;
	Frame.AnchorPoint = Vector2.new(0.5, 0.5);
	Frame.BackgroundColor3 = _G.Dark;
	Frame.BackgroundTransparency = 0.1;
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
	Frame.Size = UDim2.new(0, 400, 0, 60);
	
	Image.Name = "Icon";
	Image.Parent = Frame;
	Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	Image.BackgroundTransparency = 1;
	Image.Position = UDim2.new(0, 8, 0, 8);
	Image.Size = UDim2.new(0, 45, 0, 45);
	Image.Image = "rbxassetid://105059922903197";
	
	Title.Parent = Frame;
	Title.BackgroundColor3 = _G.Primary;
	Title.BackgroundTransparency = 1;
	Title.Position = UDim2.new(0, 55, 0, 14);
	Title.Size = UDim2.new(0, 10, 0, 20);
	Title.Font = Enum.Font.GothamBold;
	Title.Text = "Xenon";
	Title.TextColor3 = Color3.fromRGB(255, 255, 255);
	Title.TextSize = 16;
	Title.TextXAlignment = Enum.TextXAlignment.Left;
	
	Desc.Parent = Frame;
	Desc.BackgroundColor3 = _G.Primary;
	Desc.BackgroundTransparency = 1;
	Desc.Position = UDim2.new(0, 55, 0, 33);
	Desc.Size = UDim2.new(0, 10, 0, 10);
	Desc.Font = Enum.Font.GothamSemibold;
	Desc.TextTransparency = 0.3;
	Desc.Text = desc;
	Desc.TextColor3 = Color3.fromRGB(200, 200, 200);
	Desc.TextSize = 12;
	Desc.TextXAlignment = Enum.TextXAlignment.Left;
	
	CreateRounded(Frame, 10);
	CreateRounded(OutlineFrame, 12);
	CreateStroke(Frame, Color3.fromRGB(40, 40, 45), 1);
	
	OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.1, 0), "Out", "Quad", 0.4, true);
	table.insert(NotificationList, {
		OutlineFrame,
		title
	});
end;

-- ENHANCED LOADING ANIMATION SYSTEM
function Update:StartLoad()
	local Loader = Instance.new("ScreenGui");
	Loader.Parent = game.CoreGui;
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	Loader.DisplayOrder = 1000;
	
	local LoaderFrame = Instance.new("Frame");
	LoaderFrame.Name = "LoaderFrame";
	LoaderFrame.Parent = Loader;
	LoaderFrame.ClipsDescendants = true;
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5);
	LoaderFrame.BackgroundTransparency = 0;
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0);
	LoaderFrame.BorderSizePixel = 0;
	
	-- Add animated background gradient
	local BackgroundGradient = CreateGradient(LoaderFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
	}));
	BackgroundGradient.Rotation = 45;
	
	-- Animate background gradient
	spawn(function()
		while LoaderFrame.Parent do
			TweenService:Create(BackgroundGradient, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Rotation = BackgroundGradient.Rotation + 360
			}):Play();
			wait(3);
		end;
	end);
	
	local MainLoaderFrame = Instance.new("Frame");
	MainLoaderFrame.Name = "MainLoaderFrame";
	MainLoaderFrame.Parent = LoaderFrame;
	MainLoaderFrame.ClipsDescendants = false;
	MainLoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
	MainLoaderFrame.BackgroundTransparency = 0.1;
	MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	MainLoaderFrame.Size = UDim2.new(0.6, 0, 0.6, 0);
	MainLoaderFrame.BorderSizePixel = 0;
	CreateRounded(MainLoaderFrame, 20);
	CreateStroke(MainLoaderFrame, _G.Third, 2);
	
	-- Add glow effect to main loader frame
	local LoaderGlow = Instance.new("ImageLabel");
	LoaderGlow.Name = "LoaderGlow";
	LoaderGlow.Parent = MainLoaderFrame;
	LoaderGlow.BackgroundTransparency = 1;
	LoaderGlow.Image = "rbxassetid://6014261993";
	LoaderGlow.ImageColor3 = _G.Third;
	LoaderGlow.ImageTransparency = 0.8;
	LoaderGlow.Position = UDim2.new(0, -30, 0, -30);
	LoaderGlow.Size = UDim2.new(1, 60, 1, 60);
	LoaderGlow.ZIndex = -1;
	
	-- Animate glow pulsing
	spawn(function()
		while LoaderGlow.Parent do
			TweenService:Create(LoaderGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				ImageTransparency = 0.5
			}):Play();
			wait(1.5);
		end;
	end);
	
	-- Create particle system
	local ParticleContainer = Instance.new("Frame");
	ParticleContainer.Name = "ParticleContainer";
	ParticleContainer.Parent = LoaderFrame;
	ParticleContainer.BackgroundTransparency = 1;
	ParticleContainer.Size = UDim2.new(1, 0, 1, 0);
	ParticleContainer.ZIndex = 1;
	
	-- Spawn particles
	for i = 1, 15 do
		spawn(function()
			wait(i * 0.1);
			CreateParticle(ParticleContainer, _G.Third, math.random(3, 8), math.random(2, 5));
		end);
	end;
	
	-- Enhanced Title with gradient text effect
	local TitleLoader = Instance.new("TextLabel");
	TitleLoader.Parent = MainLoaderFrame;
	TitleLoader.Text = "XENON";
	TitleLoader.Font = Enum.Font.FredokaOne;
	TitleLoader.TextSize = 60;
	TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255);
	TitleLoader.BackgroundTransparency = 1;
	TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	TitleLoader.Position = UDim2.new(0.5, 0, 0.25, 0);
	TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0);
	TitleLoader.TextTransparency = 0;
	TitleLoader.TextStrokeTransparency = 0.8;
	TitleLoader.TextStrokeColor3 = _G.Third;
	
	-- Add gradient to title
	local TitleGradient = CreateGradient(TitleLoader, ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Third),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, _G.Accent)
	}));
	TitleGradient.Rotation = 45;
	
	-- Animate title entrance
	TitleLoader.TextTransparency = 1;
	TitleLoader.Position = UDim2.new(0.5, 0, 0.15, 0);
	TweenService:Create(TitleLoader, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		TextTransparency = 0,
		Position = UDim2.new(0.5, 0, 0.25, 0)
	}):Play();
	
	-- Enhanced subtitle with typewriter effect
	local SubtitleLoader = Instance.new("TextLabel");
	SubtitleLoader.Parent = MainLoaderFrame;
	SubtitleLoader.Text = "";
	SubtitleLoader.Font = Enum.Font.GothamBold;
	SubtitleLoader.TextSize = 16;
	SubtitleLoader.TextColor3 = Color3.fromRGB(200, 200, 200);
	SubtitleLoader.BackgroundTransparency = 1;
	SubtitleLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	SubtitleLoader.Position = UDim2.new(0.5, 0, 0.4, 0);
	SubtitleLoader.Size = UDim2.new(0.8, 0, 0.1, 0);
	SubtitleLoader.TextTransparency = 0;
	
	-- Typewriter effect for subtitle
	local subtitleText = "Initializing Advanced Hub System...";
	spawn(function()
		wait(1);
		for i = 1, #subtitleText do
			SubtitleLoader.Text = string.sub(subtitleText, 1, i);
			wait(0.05);
		end;
	end);
	
	-- Enhanced loading description with animated dots
	local DescriptionLoader = Instance.new("TextLabel");
	DescriptionLoader.Parent = MainLoaderFrame;
	DescriptionLoader.Text = "Loading";
	DescriptionLoader.Font = Enum.Font.Gotham;
	DescriptionLoader.TextSize = 14;
	DescriptionLoader.TextColor3 = Color3.fromRGB(150, 150, 150);
	DescriptionLoader.BackgroundTransparency = 1;
	DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5);
	DescriptionLoader.Position = UDim2.new(0.5, 0, 0.55, 0);
	DescriptionLoader.Size = UDim2.new(0.8, 0, 0.1, 0);
	DescriptionLoader.TextTransparency = 0;
	
	-- Enhanced loading bar with gradient and glow
	local LoadingBarBackground = Instance.new("Frame");
	LoadingBarBackground.Parent = MainLoaderFrame;
	LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 50);
	LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5);
	LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0);
	LoadingBarBackground.Size = UDim2.new(0.8, 0, 0.06, 0);
	LoadingBarBackground.ClipsDescendants = true;
	LoadingBarBackground.BorderSizePixel = 0;
	LoadingBarBackground.ZIndex = 2;
	CreateRounded(LoadingBarBackground, 25);
	CreateStroke(LoadingBarBackground, Color3.fromRGB(60, 60, 70), 1);
	
	local LoadingBar = Instance.new("Frame");
	LoadingBar.Parent = LoadingBarBackground;
	LoadingBar.BackgroundColor3 = _G.Third;
	LoadingBar.Size = UDim2.new(0, 0, 1, 0);
	LoadingBar.ZIndex = 3;
	CreateRounded(LoadingBar, 25);
	
	-- Add gradient to loading bar
	local BarGradient = CreateGradient(LoadingBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, _G.Third),
		ColorSequenceKeypoint.new(0.5, _G.Gradient1),
		ColorSequenceKeypoint.new(1, _G.Accent)
	}));
	
	-- Add glow to loading bar
	local BarGlow = Instance.new("ImageLabel");
	BarGlow.Name = "BarGlow";
	BarGlow.Parent = LoadingBar;
	BarGlow.BackgroundTransparency = 1;
	BarGlow.Image = "rbxassetid://6014261993";
	BarGlow.ImageColor3 = _G.Third;
	BarGlow.ImageTransparency = 0.7;
	BarGlow.Position = UDim2.new(0, -10, 0, -10);
	BarGlow.Size = UDim2.new(1, 20, 1, 20);
	BarGlow.ZIndex = 2;
	
	-- Percentage display
	local PercentageLabel = Instance.new("TextLabel");
	PercentageLabel.Parent = MainLoaderFrame;
	PercentageLabel.Text = "0%";
	PercentageLabel.Font = Enum.Font.GothamBold;
	PercentageLabel.TextSize = 18;
	PercentageLabel.TextColor3 = _G.Third;
	PercentageLabel.BackgroundTransparency = 1;
	PercentageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
	PercentageLabel.Position = UDim2.new(0.5, 0, 0.82, 0);
	PercentageLabel.Size = UDim2.new(0.2, 0, 0.1, 0);
	
	-- Loading stages
	local loadingStages = {
		"Initializing Core Systems...",
		"Loading User Interface...",
		"Connecting to Services...",
		"Preparing Features...",
		"Finalizing Setup...",
		"Ready to Launch!"
	};
	
	local tweenService = game:GetService("TweenService");
	local dotCount = 0;
	local running = true;
	local currentStage = 1;
	
	-- Enhanced loading animation with stages
	local function updateLoadingStage()
		if currentStage <= #loadingStages then
			-- Fade out current text
			TweenService:Create(DescriptionLoader, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				TextTransparency = 1
			}):Play();
			
			wait(0.3);
			
			-- Update text and fade in
			DescriptionLoader.Text = loadingStages[currentStage];
			TweenService:Create(DescriptionLoader, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				TextTransparency = 0
			}):Play();
			
			currentStage = currentStage + 1;
		end;
	end;
	
	-- Progressive loading animation
	local barTweenInfoPart1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
		Size = UDim2.new(0.3, 0, 1, 0)
	});
	
	local barTweenInfoPart2 = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
	local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
		Size = UDim2.new(1, 0, 1, 0)
	});
	
	-- Animate percentage counter
	spawn(function()
		for i = 0, 100 do
			PercentageLabel.Text = i .. "%";
			if i <= 30 then
				wait(0.05);
			elseif i <= 70 then
				wait(0.03);
			else
				wait(0.02);
			end;
		end;
	end);
	
	-- Update loading stages
	spawn(function()
		for i = 1, #loadingStages do
			wait(0.8);
			updateLoadingStage();
		end;
	end);
	
	barTweenPart1:Play();
	
	function Update:Loaded()
		barTweenPart2:Play();
	end;
	
	barTweenPart1.Completed:Connect(function()
		running = true;
		barTweenPart2.Completed:Connect(function()
			wait(0.5);
			running = false;
			
			-- Success animation
			TweenService:Create(DescriptionLoader, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
				TextColor3 = _G.Success,
				TextSize = 16
			}):Play();
			
			TweenService:Create(PercentageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
				TextColor3 = _G.Success,
				TextSize = 20
			}):Play();
			
			-- Fade out animation
			wait(1);
			TweenService:Create(LoaderFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
				BackgroundTransparency = 1
			}):Play();
			
			TweenService:Create(MainLoaderFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			}):Play();
			
			wait(0.8);
			Loader:Destroy();
		end);
	end);
	
	-- Animated dots for loading text
	spawn(function()
		while running do
			dotCount = (dotCount + 1) % 4;
			local dots = string.rep(".", dotCount);
			if running and DescriptionLoader.Text ~= "Ready to Launch!" then
				-- Don't override stage text
			end;
			wait(0.5);
		end;
	end);
end;

local SettingsLib = {
	SaveSettings = true,
	LoadAnimation = true
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
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
			for i, v in pairs(Decode) do
				SettingsLib[i] = v;
			end;
		end;
		print("Library Loaded!");
	else
		return warn("Status : Undetected Executor");
	end;
end;

(getgenv()).SaveConfig = function()
	if readfile and writefile and isfile and isfolder then
		if not isfile(("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json")) then
			(getgenv()).Load();
		else
			local Decode = (game:GetService("HttpService")):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"));
			local Array = {};
			for i, v in pairs(SettingsLib) do
				Array[i] = v;
			end;
			writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", (game:GetService("HttpService")):JSONEncode(Array));
		end;
	else
		return warn("Status : Undetected Executor");
	end;
end;

(getgenv()).LoadConfig();

function Update:SaveSettings()
	if SettingsLib.SaveSettings then
		return true;
	end;
	return false;
end;

function Update:LoadAnimation()
	if SettingsLib.LoadAnimation then
		return true;
	end;
	return false;
end;

function Update:Window(Config)
	assert(Config.SubTitle, "v4");
	
	local WindowConfig = {
		Size = Config.Size,
		TabWidth = Config.TabWidth
	};
	
	local osfunc = {};
	local uihide = false;
	local abc = false;
	local currentpage = "";
	local keybind = keybind or Enum.KeyCode.RightControl;
	local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "");
	
	local Xenon = Instance.new("ScreenGui");
	Xenon.Name = "Xenon";
	Xenon.Parent = game.CoreGui;
	Xenon.DisplayOrder = 999;
	
	local OutlineMain = Instance.new("Frame");
	OutlineMain.Name = "OutlineMain";
	OutlineMain.Parent = Xenon;
	OutlineMain.ClipsDescendants = true;
	OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5);
	OutlineMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
	OutlineMain.BackgroundTransparency = 0.4;
	OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0);
	OutlineMain.Size = UDim2.new(0, 0, 0, 0);
	CreateRounded(OutlineMain, 15);
	
	-- Add main window glow effect
	local MainGlow = Instance.new("ImageLabel");
	MainGlow.Name = "MainGlow";
	MainGlow.Parent = OutlineMain;
	MainGlow.BackgroundTransparency = 1;
	MainGlow.Image = "rbxassetid://6014261993";
	MainGlow.ImageColor3 = _G.Third;
	MainGlow.ImageTransparency = 0.9;
	MainGlow.Position = UDim2.new(0, -20, 0, -20);
	MainGlow.Size = UDim2.new(1, 40, 1, 40);
	MainGlow.ZIndex = -1;
	
	local Main = Instance.new("Frame");
	Main.Name = "Main";
	Main.Parent = OutlineMain;
	Main.ClipsDescendants = true;
	Main.AnchorPoint = Vector2.new(0.5, 0.5);
	Main.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
	Main.BackgroundTransparency = 0;
	Main.Position = UDim2.new(0.5, 0, 0.5, 0);
	Main.Size = WindowConfig.Size;
	
	-- Add subtle gradient to main frame
	local MainGradient = CreateGradient(Main, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 26)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(28, 28, 32)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 26))
	}));
	MainGradient.Rotation = 90;
	
	OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true);
	CreateRounded(Main, 12);
	CreateStroke(Main, Color3.fromRGB(40, 40, 45), 1);
	
	local BtnStroke = Instance.new("UIStroke");
	local DragButton = Instance.new("Frame");
	DragButton.Name = "DragButton";
	DragButton.Parent = Main;
	DragButton.Position = UDim2.new(1, 5, 1, 5);
	DragButton.AnchorPoint = Vector2.new(1, 1);
	DragButton.Size = UDim2.new(0, 15, 0, 15);
	DragButton.BackgroundColor3 = _G.Primary;
	DragButton.BackgroundTransparency = 1;
	DragButton.ZIndex = 10;
	
	local mouse = game.Players.LocalPlayer:GetMouse();
	local uis = game:GetService("UserInputService");
	
	local CircleDragButton = Instance.new("UICorner");
	CircleDragButton.Name = "CircleDragButton";
	CircleDragButton.Parent = DragButton;
	CircleDragButton.CornerRadius = UDim.new(0, 99);
	
	-- Enhanced Top Bar with gradient
	local Top = Instance.new("Frame");
	Top.Name = "Top";
	Top.Parent = Main;
	Top.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	Top.Size = UDim2.new(1, 0, 0, 40);
	Top.BackgroundTransparency = 0.1;
	CreateRounded(Top, 5);
	
	-- Add gradient to top bar
	local TopGradient = CreateGradient(Top, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
	}));
	
	-- Add subtle border line at bottom of top bar
	local TopBorder = Instance.new("Frame");
	TopBorder.Name = "TopBorder";
	TopBorder.Parent = Top;
	TopBorder.BackgroundColor3 = _G.Third;
	TopBorder.BackgroundTransparency = 0.8;
	TopBorder.Position = UDim2.new(0, 0, 1, -1);
	TopBorder.Size = UDim2.new(1, 0, 0, 1);
	
	local NameHub = Instance.new("TextLabel");
	NameHub.Name = "NameHub";
	NameHub.Parent = Top;
	NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	NameHub.BackgroundTransparency = 1;
	NameHub.RichText = true;
	NameHub.Position = UDim2.new(0, 15, 0.5, 0);
	NameHub.AnchorPoint = Vector2.new(0, 0.5);
	NameHub.Size = UDim2.new(0, 1, 0, 25);
	NameHub.Font = Enum.Font.GothamBold;
	NameHub.Text = "XENON";
	NameHub.TextSize = 20;
	NameHub.TextColor3 = Color3.fromRGB(255, 255, 255);
	NameHub.TextXAlignment = Enum.TextXAlignment.Left;
	NameHub.TextStrokeTransparency = 0.9;
	NameHub.TextStrokeColor3 = _G.Third;
	
	local nameHubSize = (game:GetService("TextService")):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge));
	NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25);
	
	local SubTitle = Instance.new("TextLabel");
	SubTitle.Name = "SubTitle";
	SubTitle.Parent = NameHub;
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	SubTitle.BackgroundTransparency = 1;
	SubTitle.Position = UDim2.new(0, nameHubSize.X + 8, 0.5, 0);
	SubTitle.Size = UDim2.new(0, 1, 0, 20);
	SubTitle.Font = Enum.Font.Cartoon;
	SubTitle.AnchorPoint = Vector2.new(0, 0.5);
	SubTitle.Text = Config.SubTitle;
	SubTitle.TextSize = 15;
	SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150);
	
	local SubTitleSize = (game:GetService("TextService")):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge));
	SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25);
	
	local CloseButton = Instance.new("ImageButton");
	CloseButton.Name = "CloseButton";
	CloseButton.Parent = Top;
	CloseButton.BackgroundColor3 = _G.Primary;
	CloseButton.BackgroundTransparency = 1;
	CloseButton.AnchorPoint = Vector2.new(1, 0.5);
	CloseButton.Position = UDim2.new(1, -15, 0.5, 0);
	CloseButton.Size = UDim2.new(0, 20, 0, 20);
	CloseButton.Image = "rbxassetid://7743878857";
	CloseButton.ImageTransparency = 0;
	CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245);
	CreateRounded(CloseButton, 3);
	
	-- Enhanced hover effect for close button with rotation
	CloseButton.MouseEnter:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = _G.Third,
			BackgroundTransparency = 0.7,
			Rotation = 90
		}):Play();
	end);
	
	CloseButton.MouseLeave:Connect(function()
		TweenService:Create(CloseButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = Color3.fromRGB(245, 245, 245),
			BackgroundTransparency = 1,
			Rotation = 0
		}):Play();
	end);
	
	CloseButton.MouseButton1Click:connect(function()
		(game.CoreGui:FindFirstChild("Xenon")).Enabled = not (game.CoreGui:FindFirstChild("Xenon")).Enabled;
	end);
	
	local ResizeButton = Instance.new("ImageButton");
	ResizeButton.Name = "ResizeButton";
	ResizeButton.Parent = Top;
	ResizeButton.BackgroundColor3 = _G.Primary;
	ResizeButton.BackgroundTransparency = 1;
	ResizeButton.AnchorPoint = Vector2.new(1, 0.5);
	ResizeButton.Position = UDim2.new(1, -50, 0.5, 0);
	ResizeButton.Size = UDim2.new(0, 20, 0, 20);
	ResizeButton.Image = "rbxassetid://10734886735";
	ResizeButton.ImageTransparency = 0;
	ResizeButton.ImageColor3 = Color3.fromRGB(245, 245, 245);
	CreateRounded(ResizeButton, 3);
	
	-- Enhanced hover effect for resize button with scale
	ResizeButton.MouseEnter:Connect(function()
		TweenService:Create(ResizeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = _G.Accent,
			BackgroundTransparency = 0.7,
			Size = UDim2.new(0, 22, 0, 22)
		}):Play();
	end);
	
	ResizeButton.MouseLeave:Connect(function()
		TweenService:Create(ResizeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = Color3.fromRGB(245, 245, 245),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 20, 0, 20)
		}):Play();
	end);
	
	local BackgroundSettings = Instance.new("Frame");
	BackgroundSettings.Name = "BackgroundSettings";
	BackgroundSettings.Parent = OutlineMain;
	BackgroundSettings.ClipsDescendants = true;
	BackgroundSettings.Active = true;
	BackgroundSettings.AnchorPoint = Vector2.new(0, 0);
	BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	BackgroundSettings.BackgroundTransparency = 0.3;
	BackgroundSettings.Position = UDim2.new(0, 0, 0, 0);
	BackgroundSettings.Size = UDim2.new(1, 0, 1, 0);
	BackgroundSettings.Visible = false;
	CreateRounded(BackgroundSettings, 15);
	
	local SettingsFrame = Instance.new("Frame");
	SettingsFrame.Name = "SettingsFrame";
	SettingsFrame.Parent = BackgroundSettings;
	SettingsFrame.ClipsDescendants = true;
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5);
	SettingsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
	SettingsFrame.BackgroundTransparency = 0;
	SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0);
	SettingsFrame.Size = UDim2.new(0.7, 0, 0.7, 0);
	CreateRounded(SettingsFrame, 15);
	CreateStroke(SettingsFrame, Color3.fromRGB(40, 40, 45), 1);
	
	local CloseSettings = Instance.new("ImageButton");
	CloseSettings.Name = "CloseSettings";
	CloseSettings.Parent = SettingsFrame;
	CloseSettings.BackgroundColor3 = _G.Primary;
	CloseSettings.BackgroundTransparency = 1;
	CloseSettings.AnchorPoint = Vector2.new(1, 0);
	CloseSettings.Position = UDim2.new(1, -20, 0, 15);
	CloseSettings.Size = UDim2.new(0, 20, 0, 20);
	CloseSettings.Image = "rbxassetid://10747384394";
	CloseSettings.ImageTransparency = 0;
	CloseSettings.ImageColor3 = Color3.fromRGB(245, 245, 245);
	CreateRounded(CloseSettings, 3);
	
	CloseSettings.MouseButton1Click:connect(function()
		BackgroundSettings.Visible = false;
	end);
	
	local SettingsButton = Instance.new("ImageButton");
	SettingsButton.Name = "SettingsButton";
	SettingsButton.Parent = Top;
	SettingsButton.BackgroundColor3 = _G.Primary;
	SettingsButton.BackgroundTransparency = 1;
	SettingsButton.AnchorPoint = Vector2.new(1, 0.5);
	SettingsButton.Position = UDim2.new(1, -85, 0.5, 0);
	SettingsButton.Size = UDim2.new(0, 20, 0, 20);
	SettingsButton.Image = "rbxassetid://10734950020";
	SettingsButton.ImageTransparency = 0;
	SettingsButton.ImageColor3 = Color3.fromRGB(245, 245, 245);
	CreateRounded(SettingsButton, 3);
	
	-- Enhanced hover effect for settings button with rotation
	SettingsButton.MouseEnter:Connect(function()
		TweenService:Create(SettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = _G.Success,
			BackgroundTransparency = 0.7,
			Rotation = 45
		}):Play();
	end);
	
	SettingsButton.MouseLeave:Connect(function()
		TweenService:Create(SettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			ImageColor3 = Color3.fromRGB(245, 245, 245),
			BackgroundTransparency = 1,
			Rotation = 0
		}):Play();
	end);
	
	SettingsButton.MouseButton1Click:connect(function()
		BackgroundSettings.Visible = true;
	end);
	
	local TitleSettings = Instance.new("TextLabel");
	TitleSettings.Name = "TitleSettings";
	TitleSettings.Parent = SettingsFrame;
	TitleSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	TitleSettings.BackgroundTransparency = 1;
	TitleSettings.Position = UDim2.new(0, 20, 0, 15);
	TitleSettings.Size = UDim2.new(1, 0, 0, 20);
	TitleSettings.Font = Enum.Font.GothamBold;
	TitleSettings.AnchorPoint = Vector2.new(0, 0);
	TitleSettings.Text = "Library Settings";
	TitleSettings.TextSize = 20;
	TitleSettings.TextColor3 = Color3.fromRGB(245, 245, 245);
	TitleSettings.TextXAlignment = Enum.TextXAlignment.Left;
	
	local SettingsMenuList = Instance.new("Frame");
	SettingsMenuList.Name = "SettingsMenuList";
	SettingsMenuList.Parent = SettingsFrame;
	SettingsMenuList.ClipsDescendants = true;
	SettingsMenuList.AnchorPoint = Vector2.new(0, 0);
	SettingsMenuList.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
	SettingsMenuList.BackgroundTransparency = 1;
	SettingsMenuList.Position = UDim2.new(0, 0, 0, 50);
	SettingsMenuList.Size = UDim2.new(1, 0, 1, -70);
	CreateRounded(SettingsMenuList, 15);
	
	local ScrollSettings = Instance.new("ScrollingFrame");
	ScrollSettings.Name = "ScrollSettings";
	ScrollSettings.Parent = SettingsMenuList;
	ScrollSettings.Active = true;
	ScrollSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollSettings.Position = UDim2.new(0, 0, 0, 0);
	ScrollSettings.BackgroundTransparency = 1;
	ScrollSettings.Size = UDim2.new(1, 0, 1, 0);
	ScrollSettings.ScrollBarThickness = 3;
	ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y;
	CreateRounded(SettingsMenuList, 5);
	
	local SettingsListLayout = Instance.new("UIListLayout");
	SettingsListLayout.Name = "SettingsListLayout";
	SettingsListLayout.Parent = ScrollSettings;
	SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	SettingsListLayout.Padding = UDim.new(0, 8);
	
	local PaddingScroll = Instance.new("UIPadding");
	PaddingScroll.Name = "PaddingScroll";
	PaddingScroll.Parent = ScrollSettings;
	
	function CreateCheckbox(title, state, callback)
		local checked = state or false;
		
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
		Background.BackgroundTransparency = 1;
		Background.Size = UDim2.new(1, 0, 0, 20);
		
		local Title = Instance.new("TextLabel");
		Title.Name = "Title";
		Title.Parent = Background;
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, 60, 0.5, 0);
		Title.Size = UDim2.new(1, -60, 0, 20);
		Title.Font = Enum.Font.Code;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.Text = title or "";
		Title.TextSize = 15;
		Title.TextColor3 = Color3.fromRGB(200, 200, 200);
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		local Checkbox = Instance.new("ImageButton");
		Checkbox.Name = "Checkbox";
		Checkbox.Parent = Background;
		Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		Checkbox.BackgroundTransparency = 0;
		Checkbox.AnchorPoint = Vector2.new(0, 0.5);
		Checkbox.Position = UDim2.new(0, 30, 0.5, 0);
		Checkbox.Size = UDim2.new(0, 20, 0, 20);
		Checkbox.Image = "rbxassetid://10709790644";
		Checkbox.ImageTransparency = 1;
		Checkbox.ImageColor3 = Color3.fromRGB(245, 245, 245);
		CreateRounded(Checkbox, 5);
		CreateStroke(Checkbox, Color3.fromRGB(60, 60, 65), 1);
		
		-- Enhanced hover effect for checkbox with glow
		Checkbox.MouseEnter:Connect(function()
			TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0, 22, 0, 22)
			}):Play();
		end);
		
		Checkbox.MouseLeave:Connect(function()
			TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0, 20, 0, 20)
			}):Play();
		end);
		
		Checkbox.MouseButton1Click:Connect(function()
			checked = not checked;
			if checked then
				TweenService:Create(Checkbox, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
					ImageTransparency = 0,
					BackgroundColor3 = _G.Third
				}):Play();
			else
				TweenService:Create(Checkbox, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
					ImageTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				}):Play();
			end;
			pcall(callback, checked);
		end);
		
		if checked then
			Checkbox.ImageTransparency = 0;
			Checkbox.BackgroundColor3 = _G.Third;
		else
			Checkbox.ImageTransparency = 1;
			Checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		end;
		pcall(callback, checked);
	end;
	
	function CreateButton(title, callback)
		local Background = Instance.new("Frame");
		Background.Name = "Background";
		Background.Parent = ScrollSettings;
		Background.ClipsDescendants = true;
		Background.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
		Background.BackgroundTransparency = 1;
		Background.Size = UDim2.new(1, 0, 0, 30);
		
		local Button = Instance.new("TextButton");
		Button.Name = "Button";
		Button.Parent = Background;
		Button.BackgroundColor3 = _G.Third;
		Button.BackgroundTransparency = 0;
		Button.Size = UDim2.new(0.8, 0, 0, 30);
		Button.Font = Enum.Font.Code;
		Button.Text = title or "Button";
		Button.AnchorPoint = Vector2.new(0.5, 0);
		Button.Position = UDim2.new(0.5, 0, 0, 0);
		Button.TextColor3 = Color3.fromRGB(255, 255, 255);
		Button.TextSize = 15;
		Button.AutoButtonColor = false;
		CreateRounded(Button, 5);
		CreateStroke(Button, Color3.fromRGB(60, 60, 65), 1);
		
		-- Enhanced hover effect for button with gradient
		local ButtonGradient = CreateGradient(Button, ColorSequence.new({
			ColorSequenceKeypoint.new(0, _G.Third),
			ColorSequenceKeypoint.new(1, _G.Third)
		}));
		
		Button.MouseEnter:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.82, 0, 0, 32)
			}):Play();
			ButtonGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Third),
				ColorSequenceKeypoint.new(0.5, _G.Gradient1),
				ColorSequenceKeypoint.new(1, _G.Accent)
			});
		end);
		
		Button.MouseLeave:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.8, 0, 0, 30)
			}):Play();
			ButtonGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Third),
				ColorSequenceKeypoint.new(1, _G.Third)
			});
		end);
		
		Button.MouseButton1Click:Connect(function()
			callback();
		end);
	end;
	
	CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
		SettingsLib.SaveSettings = state;
		(getgenv()).SaveConfig();
	end);
	
	CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
		SettingsLib.LoadAnimation = state;
		(getgenv()).SaveConfig();
	end);
	
	CreateButton("Reset Config", function()
		if isfolder("Xenon") then
			delfolder("Xenon");
		end;
		Update:Notify("Config has been reseted!");
	end);
	
	-- Enhanced Tab System with better visual feedback
	local Tab = Instance.new("Frame");
	Tab.Name = "Tab";
	Tab.Parent = Main;
	Tab.BackgroundColor3 = Color3.fromRGB(20, 20, 25);
	Tab.Position = UDim2.new(0, 8, 0, Top.Size.Y.Offset);
	Tab.BackgroundTransparency = 0.1;
	Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8);
	CreateRounded(Tab, 8);
	CreateStroke(Tab, Color3.fromRGB(40, 40, 45), 1);
	
	-- Add gradient to tab area
	local TabGradient = CreateGradient(Tab, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
	}));
	TabGradient.Rotation = 90;
	
	local BtnStroke = Instance.new("UIStroke");
	
	local ScrollTab = Instance.new("ScrollingFrame");
	ScrollTab.Name = "ScrollTab";
	ScrollTab.Parent = Tab;
	ScrollTab.Active = true;
	ScrollTab.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
	ScrollTab.Position = UDim2.new(0, 0, 0, 0);
	ScrollTab.BackgroundTransparency = 1;
	ScrollTab.Size = UDim2.new(1, 0, 1, 0);
	ScrollTab.ScrollBarThickness = 0;
	ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y;
	CreateRounded(Tab, 5);
	
	local TabListLayout = Instance.new("UIListLayout");
	TabListLayout.Name = "TabListLayout";
	TabListLayout.Parent = ScrollTab;
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	TabListLayout.Padding = UDim.new(0, 2);
	
	local PPD = Instance.new("UIPadding");
	PPD.Name = "PPD";
	PPD.Parent = ScrollTab;
	
	local Page = Instance.new("Frame");
	Page.Name = "Page";
	Page.Parent = Main;
	Page.BackgroundColor3 = _G.Dark;
	Page.Position = UDim2.new(0, Tab.Size.X.Offset + 18, 0, Top.Size.Y.Offset);
	Page.Size = UDim2.new(Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 25, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 8);
	Page.BackgroundTransparency = 1;
	CreateRounded(Page, 3);
	
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
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad;
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical;
	UIPageLayout.Padding = UDim.new(0, 10);
	UIPageLayout.TweenTime = 0.3; -- Smoother page transitions
	UIPageLayout.GamepadInputEnabled = false;
	UIPageLayout.ScrollWheelInputEnabled = false;
	UIPageLayout.TouchInputEnabled = false;
	
	MakeDraggable(Top, OutlineMain);
	
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Insert then
			(game.CoreGui:FindFirstChild("Xenon")).Enabled = not (game.CoreGui:FindFirstChild("Xenon")).Enabled;
		end;
	end);
	
	local Dragging = false;
	
	DragButton.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true;
		end;
	end);
	
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false;
		end;
	end);
	
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			OutlineMain.Size = UDim2.new(0, math.clamp(Input.Position.X - Main.AbsolutePosition.X + 15, WindowConfig.Size.X.Offset + 15, math.huge), 0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y + 15, WindowConfig.Size.Y.Offset + 15, math.huge));
			Main.Size = UDim2.new(0, math.clamp(Input.Position.X - Main.AbsolutePosition.X, WindowConfig.Size.X.Offset, math.huge), 0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, WindowConfig.Size.Y.Offset, math.huge));
			Page.Size = UDim2.new(0, math.clamp(Input.Position.X - Page.AbsolutePosition.X - 8, WindowConfig.Size.X.Offset - Tab.Size.X.Offset - 25, math.huge), 0, math.clamp(Input.Position.Y - Page.AbsolutePosition.Y - 8, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 10, math.huge));
			Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, math.clamp(Input.Position.Y - Tab.AbsolutePosition.Y - 8, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 10, math.huge));
		end;
	end);
	
	local uitab = {};
	
	function uitab:Tab(text, img)
		local BtnStroke = Instance.new("UIStroke");
		local TabButton = Instance.new("TextButton");
		local title = Instance.new("TextLabel");
		local TUICorner = Instance.new("UICorner");
		local UICorner = Instance.new("UICorner");
		local Title = Instance.new("TextLabel");
		
		TabButton.Parent = ScrollTab;
		TabButton.Name = text .. "Unique";
		TabButton.Text = "";
		TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
		TabButton.BackgroundTransparency = 1;
		TabButton.Size = UDim2.new(1, 0, 0, 35);
		TabButton.Font = Enum.Font.Nunito;
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255);
		TabButton.TextSize = 12;
		TabButton.TextTransparency = 0.9;
		
		local SelectedTab = Instance.new("Frame");
		SelectedTab.Name = "SelectedTab";
		SelectedTab.Parent = TabButton;
		SelectedTab.BackgroundColor3 = _G.Third;
		SelectedTab.BackgroundTransparency = 0;
		SelectedTab.Size = UDim2.new(0, 3, 0, 0);
		SelectedTab.Position = UDim2.new(0, 0, 0.5, 0);
		SelectedTab.AnchorPoint = Vector2.new(0, 0.5);
		UICorner.CornerRadius = UDim.new(0, 100);
		UICorner.Parent = SelectedTab;
		
		-- Add glow to selected tab indicator
		local TabGlow = Instance.new("ImageLabel");
		TabGlow.Name = "TabGlow";
		TabGlow.Parent = SelectedTab;
		TabGlow.BackgroundTransparency = 1;
		TabGlow.Image = "rbxassetid://6014261993";
		TabGlow.ImageColor3 = _G.Third;
		TabGlow.ImageTransparency = 0.8;
		TabGlow.Position = UDim2.new(0, -5, 0, -5);
		TabGlow.Size = UDim2.new(1, 10, 1, 10);
		TabGlow.ZIndex = -1;
		
		Title.Parent = TabButton;
		Title.Name = "Title";
		Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
		Title.BackgroundTransparency = 1;
		Title.Position = UDim2.new(0, 30, 0.5, 0);
		Title.Size = UDim2.new(0, 100, 0, 30);
		Title.Font = Enum.Font.Roboto;
		Title.Text = text;
		Title.AnchorPoint = Vector2.new(0, 0.5);
		Title.TextColor3 = Color3.fromRGB(255, 255, 255);
		Title.TextTransparency = 0.4;
		Title.TextSize = 14;
		Title.TextXAlignment = Enum.TextXAlignment.Left;
		
		local IDK = Instance.new("ImageLabel");
		IDK.Name = "IDK";
		IDK.Parent = TabButton;
		IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		IDK.BackgroundTransparency = 1;
		IDK.ImageTransparency = 0.3;
		IDK.Position = UDim2.new(0, 7, 0.5, 0);
		IDK.Size = UDim2.new(0, 15, 0, 15);
		IDK.AnchorPoint = Vector2.new(0, 0.5);
		IDK.Image = img;
		CreateRounded(TabButton, 6);
		
		-- Enhanced hover effect for tab button with slide animation
		TabButton.MouseEnter:Connect(function()
			if TabButton.BackgroundTransparency == 1 then -- Not selected
				TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.9
				}):Play();
				TweenService:Create(Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 32, 0.5, 0)
				}):Play();
				TweenService:Create(IDK, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 9, 0.5, 0)
				}):Play();
			end;
		end);
		
		TabButton.MouseLeave:Connect(function()
			if TabButton.BackgroundTransparency ~= 0.8 then -- Not selected
				TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 1
				}):Play();
				TweenService:Create(Title, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 30, 0.5, 0)
				}):Play();
				TweenService:Create(IDK, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 7, 0.5, 0)
				}):Play();
			end;
		end);
		
		local MainFramePage = Instance.new("ScrollingFrame");
		MainFramePage.Name = text .. "_Page";
		MainFramePage.Parent = PageList;
		MainFramePage.Active = true;
		MainFramePage.BackgroundColor3 = _G.Dark;
		MainFramePage.Position = UDim2.new(0, 0, 0, 0);
		MainFramePage.BackgroundTransparency = 1;
		MainFramePage.Size = UDim2.new(1, 0, 1, 0);
		MainFramePage.ScrollBarThickness = 0;
		MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y;
		
		local zzzR = Instance.new("UICorner");
		zzzR.Parent = MainPage;
		zzzR.CornerRadius = UDim.new(0, 5);
		
		local UIPadding = Instance.new("UIPadding");
		local UIListLayout = Instance.new("UIListLayout");
		UIPadding.Parent = MainFramePage;
		UIListLayout.Padding = UDim.new(0, 3);
		UIListLayout.Parent = MainFramePage;
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
		
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					(TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					})):Play();
					(TweenService:Create(v.SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 0)
					})):Play();
					(TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					})):Play();
					(TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					})):Play();
				end;
				(TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.8
				})):Play();
				(TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 3, 0, 15)
				})):Play();
				(TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageTransparency = 0
				})):Play();
				(TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0
				})):Play();
			end;
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Unique", "") .. "_Page";
				if v.Name == currentpage then
					UIPageLayout:JumpTo(v);
				end;
			end;
		end);
		
		if abc == false then
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					(TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 1
					})):Play();
					(TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, 3, 0, 15)
					})):Play();
					(TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.4
					})):Play();
					(TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 0.4
					})):Play();
				end;
				(TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 0.8
				})):Play();
				(TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 3, 0, 15)
				})):Play();
				(TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					ImageTransparency = 0
				})):Play();
				(TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0
				})):Play();
			end;
			UIPageLayout:JumpToIndex(1);
			abc = true;
		end;
		
		(game:GetService("RunService")).Stepped:Connect(function()
			pcall(function()
				MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y);
				ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y);
				ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y);
			end);
		end);
		
		local defaultSize = true;
		
		ResizeButton.MouseButton1Click:Connect(function()
			if defaultSize then
				defaultSize = false;
				OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Quad", 0.2, true);
				Main:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.4, true, function()
					Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
					Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
				end);
				OutlineMain:TweenSize(UDim2.new(1, -10, 1, -10), "Out", "Quad", 0.4, true);
				ResizeButton.Image = "rbxassetid://10734895698";
			else
				defaultSize = true;
				Main:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset, 0, WindowConfig.Size.Y.Offset), "Out", "Quad", 0.4, true, function()
					Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 25, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
					Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 10), "Out", "Quad", 0.4, true);
				end);
				OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Quad", 0.4, true);
				ResizeButton.Image = "rbxassetid://10734886735";
			end;
		end);
		
		local main = {};
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local TextLabel = Instance.new("TextLabel");
			local TextButton = Instance.new("TextButton");
			local UICorner_2 = Instance.new("UICorner");
			local Black = Instance.new("Frame");
			local UICorner_3 = Instance.new("UICorner");
			
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = _G.Primary;
			Button.BackgroundTransparency = 0.8;
			Button.Size = UDim2.new(1, 0, 0, 36);
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = Button;
			CreateStroke(Button, Color3.fromRGB(50, 50, 55), 1);
			
			local ImageLabel = Instance.new("ImageLabel");
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = TextButton;
			ImageLabel.BackgroundColor3 = _G.Primary;
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
			ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
			ImageLabel.Size = UDim2.new(0, 15, 0, 15);
			ImageLabel.Image = "rbxassetid://10734898355";
			ImageLabel.ImageTransparency = 0;
			ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255);
			CreateRounded(TextButton, 4);
			
			TextButton.Name = "TextButton";
			TextButton.Parent = Button;
			TextButton.BackgroundColor3 = _G.Third;
			TextButton.BackgroundTransparency = 0;
			TextButton.AnchorPoint = Vector2.new(1, 0.5);
			TextButton.Position = UDim2.new(1, -1, 0.5, 0);
			TextButton.Size = UDim2.new(0, 25, 0, 25);
			TextButton.Font = Enum.Font.Nunito;
			TextButton.Text = "";
			TextButton.TextXAlignment = Enum.TextXAlignment.Left;
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextButton.TextSize = 15;
			CreateStroke(TextButton, Color3.fromRGB(60, 60, 65), 1);
			
			-- Enhanced button hover effects with pulse animation
			TextButton.MouseEnter:Connect(function()
				TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					BackgroundColor3 = Color3.fromRGB(255, 60, 85),
					Size = UDim2.new(0, 27, 0, 27)
				}):Play();
				TweenService:Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					Size = UDim2.new(0, 17, 0, 17)
				}):Play();
			end);
			
			TextButton.MouseLeave:Connect(function()
				TweenService:Create(TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = _G.Third,
					Size = UDim2.new(0, 25, 0, 25)
				}):Play();
				TweenService:Create(ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Size = UDim2.new(0, 15, 0, 15)
				}):Play();
			end);
			
			TextLabel.Name = "TextLabel";
			TextLabel.Parent = Button;
			TextLabel.BackgroundColor3 = _G.Primary;
			TextLabel.BackgroundTransparency = 1;
			TextLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextLabel.Position = UDim2.new(0, 20, 0.5, 0);
			TextLabel.Size = UDim2.new(1, -50, 1, 0);
			TextLabel.Font = Enum.Font.Cartoon;
			TextLabel.RichText = true;
			TextLabel.Text = text;
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextLabel.TextSize = 15;
			TextLabel.ClipsDescendants = true;
			
			local ArrowRight = Instance.new("ImageLabel");
			ArrowRight.Name = "ArrowRight";
			ArrowRight.Parent = Button;
			ArrowRight.BackgroundColor3 = _G.Primary;
			ArrowRight.BackgroundTransparency = 1;
			ArrowRight.AnchorPoint = Vector2.new(0, 0.5);
			ArrowRight.Position = UDim2.new(0, 0, 0.5, 0);
			ArrowRight.Size = UDim2.new(0, 15, 0, 15);
			ArrowRight.Image = "rbxassetid://10709768347";
			ArrowRight.ImageTransparency = 0;
			ArrowRight.ImageColor3 = Color3.fromRGB(255, 255, 255);
			
			Black.Name = "Black";
			Black.Parent = Button;
			Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
			Black.BackgroundTransparency = 1;
			Black.BorderSizePixel = 0;
			Black.Position = UDim2.new(0, 0, 0, 0);
			Black.Size = UDim2.new(1, 0, 0, 33);
			UICorner_3.CornerRadius = UDim.new(0, 5);
			UICorner_3.Parent = Black;
			
			-- Enhanced button hover effect with slide animation
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.7
				}):Play();
				TweenService:Create(ArrowRight, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 2, 0.5, 0)
				}):Play();
			end);
			
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8
				}):Play();
				TweenService:Create(ArrowRight, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 0, 0.5, 0)
				}):Play();
			end);
			
			TextButton.MouseButton1Click:Connect(function()
				callback();
			end);
		end;
		
		function main:Toggle(text, config, desc, callback)
			config = config or false;
			local toggled = config;
			
			local UICorner = Instance.new("UICorner");
			local TogglePadding = Instance.new("UIPadding");
			local UIStroke = Instance.new("UIStroke");
			local Button = Instance.new("TextButton");
			local UICorner_2 = Instance.new("UICorner");
			local Title = Instance.new("TextLabel");
			local Title2 = Instance.new("TextLabel");
			local Desc = Instance.new("TextLabel");
			local ToggleImage = Instance.new("TextButton");
			local UICorner_3 = Instance.new("UICorner");
			local UICorner_5 = Instance.new("UICorner");
			local Circle = Instance.new("Frame");
			local ToggleFrame = Instance.new("Frame");
			local UICorner_4 = Instance.new("UICorner");
			local TextBoxIcon = Instance.new("ImageLabel");
			
			Button.Name = "Button";
			Button.Parent = MainFramePage;
			Button.BackgroundColor3 = _G.Primary;
			Button.BackgroundTransparency = 0.8;
			Button.AutoButtonColor = false;
			Button.Font = Enum.Font.SourceSans;
			Button.Text = "";
			Button.TextColor3 = Color3.fromRGB(0, 0, 0);
			Button.TextSize = 11;
			CreateRounded(Button, 5);
			CreateStroke(Button, Color3.fromRGB(50, 50, 55), 1);
			
			Title2.Parent = Button;
			Title2.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title2.BackgroundTransparency = 1;
			Title2.Size = UDim2.new(1, 0, 0, 35);
			Title2.Font = Enum.Font.Cartoon;
			Title2.Text = text;
			Title2.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title2.TextSize = 15;
			Title2.TextXAlignment = Enum.TextXAlignment.Left;
			Title2.AnchorPoint = Vector2.new(0, 0.5);
			
			Desc.Parent = Title2;
			Desc.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
			Desc.BackgroundTransparency = 1;
			Desc.Position = UDim2.new(0, 0, 0, 22);
			Desc.Size = UDim2.new(0, 280, 0, 16);
			Desc.Font = Enum.Font.Gotham;
			
			if desc then
				Desc.Text = desc;
				Title2.Position = UDim2.new(0, 15, 0.5, -5);
				Desc.Position = UDim2.new(0, 0, 0, 22);
				Button.Size = UDim2.new(1, 0, 0, 46);
			else
				Title2.Position = UDim2.new(0, 15, 0.5, 0);
				Desc.Visible = false;
				Button.Size = UDim2.new(1, 0, 0, 36);
			end;
			
			Desc.TextColor3 = Color3.fromRGB(150, 150, 150);
			Desc.TextSize = 10;
			Desc.TextXAlignment = Enum.TextXAlignment.Left;
			
			ToggleFrame.Name = "ToggleFrame";
			ToggleFrame.Parent = Button;
			ToggleFrame.BackgroundColor3 = _G.Dark;
			ToggleFrame.BackgroundTransparency = 1;
			ToggleFrame.Position = UDim2.new(1, -10, 0.5, 0);
			ToggleFrame.Size = UDim2.new(0, 35, 0, 20);
			ToggleFrame.AnchorPoint = Vector2.new(1, 0.5);
			UICorner_5.CornerRadius = UDim.new(0, 10);
			UICorner_5.Parent = ToggleFrame;
			
			ToggleImage.Name = "ToggleImage";
			ToggleImage.Parent = ToggleFrame;
			ToggleImage.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			ToggleImage.BackgroundTransparency = 0.8;
			ToggleImage.Position = UDim2.new(0, 0, 0, 0);
			ToggleImage.AnchorPoint = Vector2.new(0, 0);
			ToggleImage.Size = UDim2.new(1, 0, 1, 0);
			ToggleImage.Text = "";
			ToggleImage.AutoButtonColor = false;
			CreateRounded(ToggleImage, 10);
			CreateStroke(ToggleImage, Color3.fromRGB(60, 60, 65), 1);
			
			Circle.Name = "Circle";
			Circle.Parent = ToggleImage;
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Circle.BackgroundTransparency = 0;
			Circle.Position = UDim2.new(0, 3, 0.5, 0);
			Circle.Size = UDim2.new(0, 14, 0, 14);
			Circle.AnchorPoint = Vector2.new(0, 0.5);
			UICorner_4.CornerRadius = UDim.new(0, 10);
			UICorner_4.Parent = Circle;
			CreateStroke(Circle, Color3.fromRGB(70, 70, 75), 1);
			
			-- Enhanced toggle hover effects with bounce animation
			ToggleImage.MouseEnter:Connect(function()
				TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					Size = UDim2.new(1, 2, 1, 2)
				}):Play();
			end);
			
			ToggleImage.MouseLeave:Connect(function()
				TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Size = UDim2.new(1, 0, 1, 0)
				}):Play();
			end);
			
			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.7
				}):Play();
			end);
			
			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8
				}):Play();
			end);
			
			ToggleImage.MouseButton1Click:Connect(function()
				if toggled == false then
					toggled = true;
					Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Back", 0.3, true);
					(TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = _G.Third,
						BackgroundTransparency = 0
					})):Play();
				else
					toggled = false;
					Circle:TweenPosition(UDim2.new(0, 4, 0.5, 0), "Out", "Back", 0.3, true);
					(TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(200, 200, 200),
						BackgroundTransparency = 0.8
					})):Play();
				end;
				pcall(callback, toggled);
			end);
			
			if config == true then
				toggled = true;
				Circle:TweenPosition(UDim2.new(0, 17, 0.5, 0), "Out", "Sine", 0.4, true);
				(TweenService:Create(ToggleImage, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = _G.Third,
					BackgroundTransparency = 0
				})):Play();
				pcall(callback, toggled);
			end;
		end;
		
		function main:Dropdown(text, option, var, callback)
			local isdropping = false;
			
			local Dropdown = Instance.new("Frame");
			local DropdownFrameScroll = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local UICorner_2 = Instance.new("UICorner");
			local UICorner_3 = Instance.new("UICorner");
			local UICorner_4 = Instance.new("UICorner");
			local DropTitle = Instance.new("TextLabel");
			local DropScroll = Instance.new("ScrollingFrame");
			local UIListLayout = Instance.new("UIListLayout");
			local UIPadding = Instance.new("UIPadding");
			local DropButton = Instance.new("TextButton");
			local HideButton = Instance.new("TextButton");
			local SelectItems = Instance.new("TextButton");
			local DropImage = Instance.new("ImageLabel");
			local UIStroke = Instance.new("UIStroke");
			
			Dropdown.Name = "Dropdown";
			Dropdown.Parent = MainFramePage;
			Dropdown.BackgroundColor3 = _G.Primary;
			Dropdown.BackgroundTransparency = 0.8;
			Dropdown.ClipsDescendants = false;
			Dropdown.Size = UDim2.new(1, 0, 0, 40);
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = Dropdown;
			CreateStroke(Dropdown, Color3.fromRGB(50, 50, 55), 1);
			
			DropTitle.Name = "DropTitle";
			DropTitle.Parent = Dropdown;
			DropTitle.BackgroundColor3 = _G.Primary;
			DropTitle.BackgroundTransparency = 1;
			DropTitle.Size = UDim2.new(1, 0, 0, 30);
			DropTitle.Font = Enum.Font.Cartoon;
			DropTitle.Text = text;
			DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255);
			DropTitle.TextSize = 15;
			DropTitle.TextXAlignment = Enum.TextXAlignment.Left;
			DropTitle.Position = UDim2.new(0, 15, 0, 5);
			DropTitle.AnchorPoint = Vector2.new(0, 0);
			
			SelectItems.Name = "SelectItems";
			SelectItems.Parent = Dropdown;
			SelectItems.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
			SelectItems.TextColor3 = Color3.fromRGB(255, 255, 255);
			SelectItems.BackgroundTransparency = 0;
			SelectItems.Position = UDim2.new(1, -5, 0, 5);
			SelectItems.Size = UDim2.new(0, 100, 0, 30);
			SelectItems.AnchorPoint = Vector2.new(1, 0);
			SelectItems.Font = Enum.Font.GothamMedium;
			SelectItems.AutoButtonColor = false;
			SelectItems.TextSize = 9;
			SelectItems.ZIndex = 1;
			SelectItems.ClipsDescendants = true;
			SelectItems.Text = "   Select Items";
			SelectItems.TextXAlignment = Enum.TextXAlignment.Left;
			CreateStroke(SelectItems, Color3.fromRGB(60, 60, 65), 1);
			
			local ArrowDown = Instance.new("ImageLabel");
			ArrowDown.Name = "ArrowDown";
			ArrowDown.Parent = Dropdown;
			ArrowDown.BackgroundColor3 = _G.Primary;
			ArrowDown.BackgroundTransparency = 1;
			ArrowDown.AnchorPoint = Vector2.new(1, 0);
			ArrowDown.Position = UDim2.new(1, -110, 0, 10);
			ArrowDown.Size = UDim2.new(0, 20, 0, 20);
			ArrowDown.Image = "rbxassetid://10709790948";
			ArrowDown.ImageTransparency = 0;
			ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255);
			
			CreateRounded(SelectItems, 5);
			CreateRounded(DropScroll, 5);
			
			-- Enhanced dropdown hover effects with smooth transitions
			SelectItems.MouseEnter:Connect(function()
				TweenService:Create(SelectItems, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					BackgroundColor3 = Color3.fromRGB(34, 34, 36),
					Size = UDim2.new(0, 102, 0, 32)
				}):Play();
				TweenService:Create(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					ImageColor3 = _G.Third
				}):Play();
			end);
			
			SelectItems.MouseLeave:Connect(function()
				TweenService:Create(SelectItems, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = Color3.fromRGB(24, 24, 26),
					Size = UDim2.new(0, 100, 0, 30)
				}):Play();
				TweenService:Create(ArrowDown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				}):Play();
			end);
			
			Dropdown.MouseEnter:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.7
				}):Play();
			end);
			
			Dropdown.MouseLeave:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8
				}):Play();
			end);
			
			DropdownFrameScroll.Name = "DropdownFrameScroll";
			DropdownFrameScroll.Parent = Dropdown;
			DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(24, 24, 26);
			DropdownFrameScroll.BackgroundTransparency = 0;
			DropdownFrameScroll.ClipsDescendants = true;
			DropdownFrameScroll.Size = UDim2.new(1, 0, 0, 100);
			DropdownFrameScroll.Position = UDim2.new(0, 5, 0, 40);
			DropdownFrameScroll.Visible = false;
			DropdownFrameScroll.AnchorPoint = Vector2.new(0, 0);
			UICorner_4.Parent = DropdownFrameScroll;
			UICorner_4.CornerRadius = UDim.new(0, 5);
			CreateStroke(DropdownFrameScroll, Color3.fromRGB(60, 60, 65), 1);
			
			DropScroll.Name = "DropScroll";
			DropScroll.Parent = DropdownFrameScroll;
			DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y;
			DropScroll.Active = true;
			DropScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			DropScroll.BackgroundTransparency = 1;
			DropScroll.BorderSizePixel = 0;
			DropScroll.Position = UDim2.new(0, 0, 0, 10);
			DropScroll.Size = UDim2.new(1, 0, 0, 80);
			DropScroll.AnchorPoint = Vector2.new(0, 0);
			DropScroll.ClipsDescendants = true;
			DropScroll.ScrollBarThickness = 3;
			DropScroll.ZIndex = 3;
			
			local PaddingDrop = Instance.new("UIPadding");
			PaddingDrop.PaddingLeft = UDim.new(0, 10);
			PaddingDrop.PaddingRight = UDim.new(0, 10);
			PaddingDrop.Parent = DropScroll;
			PaddingDrop.Name = "PaddingDrop";
			
			UIListLayout.Parent = DropScroll;
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
			UIListLayout.Padding = UDim.new(0, 1);
			
			UIPadding.Parent = DropScroll;
			UIPadding.PaddingLeft = UDim.new(0, 5);
			
			for i, v in next, option do
				local Item = Instance.new("TextButton");
				local CRNRitems = Instance.new("UICorner");
				local UICorner_5 = Instance.new("UICorner");
				local ItemPadding = Instance.new("UIPadding");
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = _G.Primary;
				Item.BackgroundTransparency = 1;
				Item.Size = UDim2.new(1, 0, 0, 30);
				Item.Font = Enum.Font.Nunito;
				Item.Text = tostring(v);
				Item.TextColor3 = Color3.fromRGB(255, 255, 255);
				Item.TextSize = 13;
				Item.TextTransparency = 0.5;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, 8);
				
				UICorner_5.Parent = Item;
				UICorner_5.CornerRadius = UDim.new(0, 5);
				
				local SelectedItems = Instance.new("Frame");
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 3, 0.4, 0);
				SelectedItems.Position = UDim2.new(0, -8, 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				
				CRNRitems.Parent = SelectedItems;
				CRNRitems.CornerRadius = UDim.new(0, 999);
				
				-- Enhanced dropdown item hover effects with slide animation
				Item.MouseEnter:Connect(function()
					TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
						BackgroundTransparency = 0.8,
						TextTransparency = 0.2
					}):Play();
					TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
						Position = UDim2.new(0, 2, 0, Item.Position.Y.Offset)
					}):Play();
				end);
				
				Item.MouseLeave:Connect(function()
					if activeItem ~= Item.Text then
						TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
							BackgroundTransparency = 1,
							TextTransparency = 0.5
						}):Play();
					end;
					TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
						Position = UDim2.new(0, 0, 0, Item.Position.Y.Offset)
					}):Play();
				end);
				
				if var then
					pcall(callback, var);
					SelectItems.Text = "   " .. var;
					activeItem = tostring(var);
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								v.BackgroundTransparency = 0.8;
								v.TextTransparency = 0;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 0;
								end;
							end;
						end;
					end;
				end;
				
				Item.MouseButton1Click:Connect(function()
					SelectItems.ClipsDescendants = true;
					callback(Item.Text);
					activeItem = Item.Text;
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								v.BackgroundTransparency = 0.8;
								v.TextTransparency = 0;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 0;		
								end;
							else
								v.BackgroundTransparency = 1;
								v.TextTransparency = 0.5;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 1;
								end;
							end;
						end;
					end;
					SelectItems.Text = "   " .. Item.Text;
				end);
			end;
			
			DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y);
			
			SelectItems.MouseButton1Click:Connect(function()
				if isdropping == false then
					isdropping = true;
					(TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, -10, 0, 100),
						Visible = true
					})):Play();
					(TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 145)
					})):Play();
					(TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Rotation = 180
					})):Play();
				else
					isdropping = false;
					(TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, -10, 0, 0),
						Visible = false
					})):Play();
					(TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, 40)
					})):Play();
					(TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 0
					})):Play();
				end;
			end);
			
			local dropfunc = {};
			
			function dropfunc:Add(t)
				local Item = Instance.new("TextButton");
				local CRNRitems = Instance.new("UICorner");
				local UICorner_5 = Instance.new("UICorner");
				local ItemPadding = Instance.new("UIPadding");
				
				Item.Name = "Item";
				Item.Parent = DropScroll;
				Item.BackgroundColor3 = _G.Primary;
				Item.BackgroundTransparency = 1;
				Item.Size = UDim2.new(1, 0, 0, 30);
				Item.Font = Enum.Font.Nunito;
				Item.Text = tostring(t);
				Item.TextColor3 = Color3.fromRGB(255, 255, 255);
				Item.TextSize = 13;
				Item.TextTransparency = 0.5;
				Item.TextXAlignment = Enum.TextXAlignment.Left;
				Item.ZIndex = 4;
				
				ItemPadding.Parent = Item;
				ItemPadding.PaddingLeft = UDim.new(0, 8);
				
				UICorner_5.Parent = Item;
				UICorner_5.CornerRadius = UDim.new(0, 5);
				
				local SelectedItems = Instance.new("Frame");
				SelectedItems.Name = "SelectedItems";
				SelectedItems.Parent = Item;
				SelectedItems.BackgroundColor3 = _G.Third;
				SelectedItems.BackgroundTransparency = 1;
				SelectedItems.Size = UDim2.new(0, 3, 0.4, 0);
				SelectedItems.Position = UDim2.new(0, -8, 0.5, 0);
				SelectedItems.AnchorPoint = Vector2.new(0, 0.5);
				SelectedItems.ZIndex = 4;
				
				CRNRitems.Parent = SelectedItems;
				CRNRitems.CornerRadius = UDim.new(0, 999);
				
				Item.MouseButton1Click:Connect(function()
					callback(Item.Text);
					activeItem = Item.Text;
					for i, v in next, DropScroll:GetChildren() do
						if v:IsA("TextButton") then
							local SelectedItems = v:FindFirstChild("SelectedItems");
							if activeItem == v.Text then
								v.BackgroundTransparency = 0.8;
								v.TextTransparency = 0;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 0;
								end;
							else
								v.BackgroundTransparency = 1;
								v.TextTransparency = 0.5;
								if SelectedItems then
									SelectedItems.BackgroundTransparency = 1;
								end;
							end;
						end;
					end;
					SelectItems.Text = "   " .. Item.Text;
				end);
			end;
			
			function dropfunc:Clear()
				SelectItems.Text = "   Select Items";
				isdropping = false;
				DropdownFrameScroll.Visible = false;
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
			local slidercorner = Instance.new("UICorner");
			local sliderr = Instance.new("Frame");
			local sliderrcorner = Instance.new("UICorner");
			local ImageLabel = Instance.new("ImageLabel");
			local SliderStroke = Instance.new("UIStroke");
			local Title = Instance.new("TextLabel");
			local ValueText = Instance.new("TextLabel");
			local HAHA = Instance.new("Frame");
			local AHEHE = Instance.new("TextButton");
			local bar = Instance.new("Frame");
			local bar1 = Instance.new("Frame");
			local bar1corner = Instance.new("UICorner");
			local barcorner = Instance.new("UICorner");
			local circlebar = Instance.new("Frame");
			local UICorner = Instance.new("UICorner");
			local slidervalue = Instance.new("Frame");
			local valuecorner = Instance.new("UICorner");
			local TextBox = Instance.new("TextBox");
			local UICorner_2 = Instance.new("UICorner");
			local posto = Instance.new("UIStroke");
			
			Slider.Name = "Slider";
			Slider.Parent = MainFramePage;
			Slider.BackgroundColor3 = _G.Primary;
			Slider.BackgroundTransparency = 1;
			Slider.Size = UDim2.new(1, 0, 0, 35);
			
			slidercorner.CornerRadius = UDim.new(0, 5);
			slidercorner.Name = "slidercorner";
			slidercorner.Parent = Slider;
			
			sliderr.Name = "sliderr";
			sliderr.Parent = Slider;
			sliderr.BackgroundColor3 = _G.Primary;
			sliderr.BackgroundTransparency = 0.8;
			sliderr.Position = UDim2.new(0, 0, 0, 0);
			sliderr.Size = UDim2.new(1, 0, 0, 35);
			CreateStroke(sliderr, Color3.fromRGB(50, 50, 55), 1);
			
			sliderrcorner.CornerRadius = UDim.new(0, 5);
			sliderrcorner.Name = "sliderrcorner";
			sliderrcorner.Parent = sliderr;
			
			Title.Parent = sliderr;
			Title.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			Title.BackgroundTransparency = 1;
			Title.Position = UDim2.new(0, 15, 0.5, 0);
			Title.Size = UDim2.new(1, 0, 0, 30);
			Title.Font = Enum.Font.Cartoon;
			Title.Text = text;
			Title.AnchorPoint = Vector2.new(0, 0.5);
			Title.TextColor3 = Color3.fromRGB(255, 255, 255);
			Title.TextSize = 15;
			Title.TextXAlignment = Enum.TextXAlignment.Left;
			
			ValueText.Parent = bar;
			ValueText.BackgroundColor3 = Color3.fromRGB(150, 150, 150);
			ValueText.BackgroundTransparency = 1;
			ValueText.Position = UDim2.new(0, -38, 0.5, 0);
			ValueText.Size = UDim2.new(0, 30, 0, 30);
			ValueText.Font = Enum.Font.GothamMedium;
			ValueText.Text = set;
			ValueText.AnchorPoint = Vector2.new(0, 0.5);
			ValueText.TextColor3 = Color3.fromRGB(255, 255, 255);
			ValueText.TextSize = 12;
			ValueText.TextXAlignment = Enum.TextXAlignment.Right;
			
			bar.Name = "bar";
			bar.Parent = sliderr;
			bar.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			bar.Size = UDim2.new(0, 100, 0, 4);
			bar.Position = UDim2.new(1, -10, 0.5, 0);
			bar.BackgroundTransparency = 0.8;
			bar.AnchorPoint = Vector2.new(1, 0.5);
			CreateStroke(bar, Color3.fromRGB(60, 60, 65), 1);
			
			bar1.Name = "bar1";
			bar1.Parent = bar;
			bar1.BackgroundColor3 = _G.Third;
			bar1.BackgroundTransparency = 0;
			bar1.Size = UDim2.new(set / max, 0, 0, 4);
			
			-- Add gradient to slider bar
			local SliderGradient = CreateGradient(bar1, ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Third),
				ColorSequenceKeypoint.new(0.5, _G.Gradient1),
				ColorSequenceKeypoint.new(1, _G.Accent)
			}));
			
			bar1corner.CornerRadius = UDim.new(0, 5);
			bar1corner.Name = "bar1corner";
			bar1corner.Parent = bar1;
			
			barcorner.CornerRadius = UDim.new(0, 5);
			barcorner.Name = "barcorner";
			barcorner.Parent = bar;
			
			circlebar.Name = "circlebar";
			circlebar.Parent = bar1;
			circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			circlebar.Position = UDim2.new(1, 0, 0, -5);
			circlebar.AnchorPoint = Vector2.new(0.5, 0);
			circlebar.Size = UDim2.new(0, 13, 0, 13);
			
			UICorner.CornerRadius = UDim.new(0, 100);
			UICorner.Parent = circlebar;
			CreateStroke(circlebar, Color3.fromRGB(70, 70, 75), 1);
			
			-- Enhanced slider hover effects with glow
			sliderr.MouseEnter:Connect(function()
				TweenService:Create(sliderr, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.7
				}):Play();
			end);
			
			sliderr.MouseLeave:Connect(function()
				TweenService:Create(sliderr, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8
				}):Play();
			end);
			
			circlebar.MouseEnter:Connect(function()
				TweenService:Create(circlebar, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					Size = UDim2.new(0, 16, 0, 16),
					BackgroundColor3 = _G.Third
				}):Play();
			end);
			
			circlebar.MouseLeave:Connect(function()
				TweenService:Create(circlebar,TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Size = UDim2.new(0, 13, 0, 13),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				}):Play();
			end);
			
			valuecorner.CornerRadius = UDim.new(0, 2);
			valuecorner.Name = "valuecorner";
			valuecorner.Parent = slidervalue;
			
			local mouse = game.Players.LocalPlayer:GetMouse();
			local uis = game:GetService("UserInputService");
			
			if Value == nil then
				Value = set;
				pcall(function()
					callback(Value);
				end);
			end;
			
			local Dragging = false;
			
			circlebar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
				end;
			end);
			
			bar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true;
				end;
			end);
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false;
				end;
			end);
			
			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					Value = math.floor((tonumber(max) - tonumber(min)) / 100 * bar1.AbsoluteSize.X + tonumber(min)) or 0;
					pcall(function()
						callback(Value);
					end);
					ValueText.Text = Value;
					bar1.Size = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X, 0, 100), 0, 4);
					circlebar.Position = UDim2.new(0, math.clamp(Input.Position.X - bar1.AbsolutePosition.X - 5, 0, 100), 0, -5);
				end;
			end);
		end;
		
		function main:Textbox(text, disappear, callback)
			local Textbox = Instance.new("Frame");
			local TextboxCorner = Instance.new("UICorner");
			local TextboxLabel = Instance.new("TextLabel");
			local RealTextbox = Instance.new("TextBox");
			local UICorner = Instance.new("UICorner");
			local TextBoxIcon = Instance.new("ImageLabel");
			
			Textbox.Name = "Textbox";
			Textbox.Parent = MainFramePage;
			Textbox.BackgroundColor3 = _G.Primary;
			Textbox.BackgroundTransparency = 0.8;
			Textbox.Size = UDim2.new(1, 0, 0, 35);
			
			TextboxCorner.CornerRadius = UDim.new(0, 5);
			TextboxCorner.Name = "TextboxCorner";
			TextboxCorner.Parent = Textbox;
			CreateStroke(Textbox, Color3.fromRGB(50, 50, 55), 1);
			
			TextboxLabel.Name = "TextboxLabel";
			TextboxLabel.Parent = Textbox;
			TextboxLabel.BackgroundColor3 = _G.Primary;
			TextboxLabel.BackgroundTransparency = 1;
			TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0);
			TextboxLabel.Text = text;
			TextboxLabel.Size = UDim2.new(1, 0, 0, 35);
			TextboxLabel.Font = Enum.Font.Nunito;
			TextboxLabel.AnchorPoint = Vector2.new(0, 0.5);
			TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
			TextboxLabel.TextSize = 15;
			TextboxLabel.TextTransparency = 0;
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left;
			
			RealTextbox.Name = "RealTextbox";
			RealTextbox.Parent = Textbox;
			RealTextbox.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			RealTextbox.BackgroundTransparency = 0.8;
			RealTextbox.Position = UDim2.new(1, -5, 0.5, 0);
			RealTextbox.AnchorPoint = Vector2.new(1, 0.5);
			RealTextbox.Size = UDim2.new(0, 80, 0, 25);
			RealTextbox.Font = Enum.Font.Gotham;
			RealTextbox.Text = "";
			RealTextbox.TextColor3 = Color3.fromRGB(225, 225, 225);
			RealTextbox.TextSize = 11;
			RealTextbox.TextTransparency = 0;
			RealTextbox.ClipsDescendants = true;
			CreateStroke(RealTextbox, Color3.fromRGB(60, 60, 65), 1);
			
			-- Enhanced textbox hover effects with glow
			RealTextbox.MouseEnter:Connect(function()
				TweenService:Create(RealTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
					BackgroundTransparency = 0.6,
					Size = UDim2.new(0, 82, 0, 27)
				}):Play();
			end);
			
			RealTextbox.MouseLeave:Connect(function()
				TweenService:Create(RealTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8,
					Size = UDim2.new(0, 80, 0, 25)
				}):Play();
			end);
			
			RealTextbox.Focused:Connect(function()
				TweenService:Create(RealTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = _G.Accent
				}):Play();
			end);
			
			RealTextbox.FocusLost:Connect(function()
				TweenService:Create(RealTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = Color3.fromRGB(200, 200, 200)
				}):Play();
				callback(RealTextbox.Text);
			end);
			
			Textbox.MouseEnter:Connect(function()
				TweenService:Create(Textbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.7
				}):Play();
			end);
			
			Textbox.MouseLeave:Connect(function()
				TweenService:Create(Textbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0.8
				}):Play();
			end);
			
			UICorner.CornerRadius = UDim.new(0, 5);
			UICorner.Parent = RealTextbox;
		end;
		
		function main:Label(text)
			local Frame = Instance.new("Frame");
			local Label = Instance.new("TextLabel");
			local PaddingLabel = Instance.new("UIPadding");
			local labelfunc = {};
			
			Frame.Name = "Frame";
			Frame.Parent = MainFramePage;
			Frame.BackgroundColor3 = _G.Primary;
			Frame.BackgroundTransparency = 1;
			Frame.Size = UDim2.new(1, 0, 0, 30);
			
			Label.Name = "Label";
			Label.Parent = Frame;
			Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Label.BackgroundTransparency = 1;
			Label.Size = UDim2.new(1, -30, 0, 30);
			Label.Font = Enum.Font.Nunito;
			Label.Position = UDim2.new(0, 30, 0.5, 0);
			Label.AnchorPoint = Vector2.new(0, 0.5);
			Label.TextColor3 = Color3.fromRGB(225, 225, 225);
			Label.TextSize = 15;
			Label.Text = text;
			Label.TextXAlignment = Enum.TextXAlignment.Left;
			
			local ImageLabel = Instance.new("ImageLabel");
			ImageLabel.Name = "ImageLabel";
			ImageLabel.Parent = Frame;
			ImageLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200);
			ImageLabel.BackgroundTransparency = 1;
			ImageLabel.ImageTransparency = 0;
			ImageLabel.Position = UDim2.new(0, 10, 0.5, 0);
			ImageLabel.Size = UDim2.new(0, 14, 0, 14);
			ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
			ImageLabel.Image = "rbxassetid://10723415903";
			ImageLabel.ImageColor3 = Color3.fromRGB(200, 200, 200);
			
			function labelfunc:Set(newtext)
				Label.Text = newtext;
			end;
			
			return labelfunc;
		end;
		
		function main:Seperator(text)
			local Seperator = Instance.new("Frame");
			local Sep1 = Instance.new("TextLabel");
			local Sep2 = Instance.new("TextLabel");
			local Sep3 = Instance.new("TextLabel");
			local SepRadius = Instance.new("UICorner");

			Seperator.Name = "Seperator";
			Seperator.Parent = MainFramePage;
			Seperator.BackgroundColor3 = _G.Primary;
			Seperator.BackgroundTransparency = 1;
			Seperator.Size = UDim2.new(1, 0, 0, 36);

			-- Sep1: Enhanced Left Line with animated gradient
			Sep1.Name = "Sep1";
			Sep1.Parent = Seperator;
			Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep1.BackgroundTransparency = 0;
			Sep1.AnchorPoint = Vector2.new(0, 0.5);
			Sep1.Position = UDim2.new(0, 0, 0.5, 0);
			Sep1.Size = UDim2.new(0.3, 0, 0, 2);
			Sep1.BorderSizePixel = 0;
			Sep1.Text = "";
			CreateRounded(Sep1, 1);
			
			local Grad1 = CreateGradient(Sep1, ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.3, _G.Primary),
				ColorSequenceKeypoint.new(0.7, _G.Third),
				ColorSequenceKeypoint.new(1, _G.Dark)
			}));

			-- Sep2: Enhanced Center Text with glow effect
			Sep2.Name = "Sep2";
			Sep2.Parent = Seperator;
			Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep2.BackgroundTransparency = 1;
			Sep2.AnchorPoint = Vector2.new(0.5, 0.5);
			Sep2.Position = UDim2.new(0.5, 0, 0.5, 0);
			Sep2.Size = UDim2.new(1, 0, 0, 36);
			Sep2.Font = Enum.Font.GothamBold;
			Sep2.Text = text;
			Sep2.TextColor3 = Color3.fromRGB(255, 255, 255);
			Sep2.TextSize = 14;
			Sep2.TextStrokeTransparency = 0.9;
			Sep2.TextStrokeColor3 = _G.Third;

			-- Sep3: Enhanced Right Line with animated gradient
			Sep3.Name = "Sep3";
			Sep3.Parent = Seperator;
			Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Sep3.BackgroundTransparency = 0;
			Sep3.AnchorPoint = Vector2.new(1, 0.5);
			Sep3.Position = UDim2.new(1, 0, 0.5, 0);
			Sep3.Size = UDim2.new(0.3, 0, 0, 2);
			Sep3.BorderSizePixel = 0;
			Sep3.Text = "";
			CreateRounded(Sep3, 1);
			
			local Grad3 = CreateGradient(Sep3, ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.3, _G.Third),
				ColorSequenceKeypoint.new(0.7, _G.Primary),
				ColorSequenceKeypoint.new(1, _G.Dark)
			}));
		end;
		
		function main:Line()
			local Linee = Instance.new("Frame");
			local Line = Instance.new("Frame");
			local UIGradient = Instance.new("UIGradient");
			
			Linee.Name = "Linee";
			Linee.Parent = MainFramePage;
			Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			Linee.BackgroundTransparency = 1;
			Linee.Position = UDim2.new(0, 0, 0.119999997, 0);
			Linee.Size = UDim2.new(1, 0, 0, 20);
			
			Line.Name = "Line";
			Line.Parent = Linee;
			Line.BackgroundColor3 = Color3.new(125, 125, 125);
			Line.BorderSizePixel = 0;
			Line.Position = UDim2.new(0, 0, 0, 10);
			Line.Size = UDim2.new(1, 0, 0, 2);
			CreateRounded(Line, 1);
			
			-- Enhanced gradient line with more colors
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, _G.Dark),
				ColorSequenceKeypoint.new(0.2, _G.Primary),
				ColorSequenceKeypoint.new(0.4, _G.Third),
				ColorSequenceKeypoint.new(0.6, _G.Accent),
				ColorSequenceKeypoint.new(0.8, _G.Primary),
				ColorSequenceKeypoint.new(1, _G.Dark)
			});
			UIGradient.Parent = Line;
		end;
		
		return main;
	end;
	
	return uitab;
end;

return Update;
