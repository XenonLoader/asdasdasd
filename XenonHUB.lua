-- ========================================
-- XenHub UI Library - Enhanced Premium Version
-- ========================================

-- Clean up existing instances
if game:GetService("CoreGui"):FindFirstChild("Xenon") and game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
    game:GetService("CoreGui").Xenon:Destroy()
    game:GetService("CoreGui").ScreenGui:Destroy()
end

-- ========================================
-- ENHANCED GLOBAL CONFIGURATION
-- ========================================
_G.Primary = Color3.fromRGB(45, 45, 55)
_G.Dark = Color3.fromRGB(18, 18, 22)
_G.Third = Color3.fromRGB(120, 120, 255)
_G.Accent = Color3.fromRGB(75, 85, 255)
_G.Success = Color3.fromRGB(34, 197, 94)
_G.Warning = Color3.fromRGB(251, 191, 36)
_G.Error = Color3.fromRGB(239, 68, 68)
_G.Surface = Color3.fromRGB(28, 28, 35)
_G.Border = Color3.fromRGB(55, 55, 65)

-- ========================================
-- ENHANCED UTILITY FUNCTIONS
-- ========================================

-- Create modern rounded corners with shadow
function CreateRounded(Parent, Size, Shadow)
    local Rounded = Instance.new("UICorner")
    Rounded.Name = "Rounded"
    Rounded.Parent = Parent
    Rounded.CornerRadius = UDim.new(0, Size)
    
    -- Add shadow effect
    if Shadow then
        local ShadowFrame = Instance.new("Frame")
        ShadowFrame.Name = "Shadow"
        ShadowFrame.Parent = Parent.Parent
        ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ShadowFrame.BackgroundTransparency = 0.7
        ShadowFrame.Position = UDim2.new(0, 2, 0, 2)
        ShadowFrame.Size = Parent.Size
        ShadowFrame.ZIndex = Parent.ZIndex - 1
        CreateRounded(ShadowFrame, Size)
    end
end

-- Enhanced gradient creation
function CreateGradient(Parent, Colors, Direction)
    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = Parent
    if Colors then
        Gradient.Color = Colors
    end
    if Direction then
        Gradient.Rotation = Direction
    end
    return Gradient
end

-- Create modern stroke/border
function CreateStroke(Parent, Color, Thickness)
    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Parent
    Stroke.Color = Color or _G.Border
    Stroke.Thickness = Thickness or 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return Stroke
end

-- Enhanced button hover effects
function AddHoverEffect(Button, HoverColor, OriginalColor)
    local TweenService = game:GetService("TweenService")
    local HoverTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, HoverTween, {BackgroundColor3 = HoverColor}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, HoverTween, {BackgroundColor3 = OriginalColor}):Play()
    end)
end

-- ========================================
-- ENHANCED DRAGGING SYSTEM
-- ========================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale, 
            StartPosition.X.Offset + Delta.X, 
            StartPosition.Y.Scale, 
            StartPosition.Y.Offset + Delta.Y
        )
        local Tween = TweenService:Create(object, TweenInfo.new(0.1), {Position = pos})
        Tween:Play()
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            -- Add drag visual feedback
            TweenService:Create(object, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    TweenService:Create(object, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
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

-- ========================================
-- ENHANCED TOGGLE BUTTON CREATION
-- ========================================
local function CreateToggleButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local OutlineButton = Instance.new("Frame")
    OutlineButton.Name = "OutlineButton"
    OutlineButton.Parent = ScreenGui
    OutlineButton.ClipsDescendants = true
    OutlineButton.BackgroundColor3 = _G.Surface
    OutlineButton.BackgroundTransparency = 0
    OutlineButton.Position = UDim2.new(0, 10, 0, 10)
    OutlineButton.Size = UDim2.new(0, 55, 0, 55)
    CreateRounded(OutlineButton, 16, true)
    CreateStroke(OutlineButton, _G.Border, 2)
    
    -- Add gradient background
    CreateGradient(OutlineButton, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Primary)
    }), 45)
    
    local ImageButton = Instance.new("ImageButton")
    ImageButton.Parent = OutlineButton
    ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    ImageButton.Size = UDim2.new(0, 35, 0, 35)
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageButton.BackgroundTransparency = 1
    ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.ImageTransparency = 0
    ImageButton.Image = "rbxassetid://105059922903197"
    ImageButton.AutoButtonColor = false
    
    -- Enhanced hover effect
    AddHoverEffect(OutlineButton, _G.Primary, _G.Surface)
    
    -- Click animation
    ImageButton.MouseButton1Down:Connect(function()
        TweenService:Create(ImageButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)}):Play()
    end)
    
    ImageButton.MouseButton1Up:Connect(function()
        TweenService:Create(ImageButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 35, 0, 35)}):Play()
    end)
    
    MakeDraggable(ImageButton, OutlineButton)
    
    ImageButton.MouseButton1Click:Connect(function()
        local xenonGui = game.CoreGui:FindFirstChild("Xenon")
        if xenonGui then
            xenonGui.Enabled = not xenonGui.Enabled
        end
    end)
end

-- ========================================
-- ENHANCED NOTIFICATION SYSTEM
-- ========================================
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1)
        removed[1]:TweenPosition(UDim2.new(0.5, 0, -0.2, 0), "Out", "Back", 0.4, true, function()
            removed[1]:Destroy()
        end)
    end
end

-- Auto-remove notifications with enhanced timing
spawn(function()
    while wait() do
        if #NotificationList > 0 then
            wait(3.5)
            RemoveOldestNotification()
        end
    end
end)

-- ========================================
-- ENHANCED SETTINGS SYSTEM
-- ========================================
local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true,
    Theme = "Dark",
    AccentColor = "Blue"
}

getgenv().LoadConfig = function()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("Xenon") then
            makefolder("Xenon")
        end
        if not isfolder("Xenon/Library/") then
            makefolder("Xenon/Library/")
        end
        
        local configPath = "Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"
        if not isfile(configPath) then
            writefile(configPath, game:GetService("HttpService"):JSONEncode(SettingsLib))
        else
            local Decode = game:GetService("HttpService"):JSONDecode(readfile(configPath))
            for i, v in pairs(Decode) do
                SettingsLib[i] = v
            end
        end
        print("Library Loaded!")
    else
        return warn("Status : Undetected Executor")
    end
end

getgenv().SaveConfig = function()
    if readfile and writefile and isfile and isfolder then
        local configPath = "Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"
        if not isfile(configPath) then
            getgenv().LoadConfig()
        else
            local Array = {}
            for i, v in pairs(SettingsLib) do
                Array[i] = v
            end
            writefile(configPath, game:GetService("HttpService"):JSONEncode(Array))
        end
    else
        return warn("Status : Undetected Executor")
    end
end

-- Load configuration on startup
getgenv().LoadConfig()

-- ========================================
-- ENHANCED MAIN UPDATE OBJECT
-- ========================================
local Update = {}

-- Enhanced notification function
function Update:Notify(desc, type)
    local notificationType = type or "info"
    local typeColors = {
        info = _G.Third,
        success = _G.Success,
        warning = _G.Warning,
        error = _G.Error
    }
    
    local OutlineFrame = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local Image = Instance.new("ImageLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")
    local ProgressBar = Instance.new("Frame")
    local Progress = Instance.new("Frame")
    
    -- Enhanced Outline Frame Setup
    OutlineFrame.Name = "OutlineFrame"
    OutlineFrame.Parent = NotificationFrame
    OutlineFrame.ClipsDescendants = true
    OutlineFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 1)
    OutlineFrame.BackgroundTransparency = 0.1
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
    OutlineFrame.Size = UDim2.new(0, 420, 0, 80)
    CreateRounded(OutlineFrame, 16, true)
    CreateStroke(OutlineFrame, typeColors[notificationType], 2)
    
    -- Enhanced gradient
    CreateGradient(OutlineFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Dark),
        ColorSequenceKeypoint.new(1, _G.Surface)
    }), 45)
    
    -- Main Frame Setup
    Frame.Name = "Frame"
    Frame.Parent = OutlineFrame
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(1, -10, 1, -10)
    
    -- Enhanced Icon Setup
    Image.Name = "Icon"
    Image.Parent = Frame
    Image.BackgroundTransparency = 1
    Image.Position = UDim2.new(0, 15, 0, 15)
    Image.Size = UDim2.new(0, 40, 0, 40)
    Image.Image = "rbxassetid://105059922903197"
    Image.ImageColor3 = typeColors[notificationType]
    
    -- Enhanced Title Setup
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 65, 0, 15)
    Title.Size = UDim2.new(1, -80, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Xenon"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Enhanced Description Setup
    Desc.Parent = Frame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 65, 0, 35)
    Desc.Size = UDim2.new(1, -80, 0, 15)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = desc
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Progress Bar
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = Frame
    ProgressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ProgressBar.Position = UDim2.new(0, 0, 1, -4)
    ProgressBar.Size = UDim2.new(1, 0, 0, 4)
    CreateRounded(ProgressBar, 2)
    
    Progress.Name = "Progress"
    Progress.Parent = ProgressBar
    Progress.BackgroundColor3 = typeColors[notificationType]
    Progress.Size = UDim2.new(1, 0, 1, 0)
    CreateRounded(Progress, 2)
    
    -- Enhanced animation
    OutlineFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.1 + (#NotificationList) * 0.12, 0), 
        "Out", "Back", 0.5, true
    )
    
    -- Progress bar animation
    TweenService:Create(Progress, TweenInfo.new(3.5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
    
    table.insert(NotificationList, {OutlineFrame, "Xenon"})
end

-- Enhanced loading screen function
function Update:StartLoad()
    local Loader = Instance.new("ScreenGui")
    Loader.Parent = game.CoreGui
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Loader.DisplayOrder = 1000
    
    local LoaderFrame = Instance.new("Frame")
    LoaderFrame.Name = "LoaderFrame"
    LoaderFrame.Parent = Loader
    LoaderFrame.ClipsDescendants = true
    LoaderFrame.BackgroundColor3 = _G.Dark
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoaderFrame.Size = UDim2.new(1.5, 0, 1.5, 0)
    LoaderFrame.BorderSizePixel = 0
    
    -- Add animated gradient background
    CreateGradient(LoaderFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Dark),
        ColorSequenceKeypoint.new(0.5, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Dark)
    }))
    
    local MainLoaderFrame = Instance.new("Frame")
    MainLoaderFrame.Name = "MainLoaderFrame"
    MainLoaderFrame.Parent = LoaderFrame
    MainLoaderFrame.ClipsDescendants = true
    MainLoaderFrame.BackgroundTransparency = 1
    MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainLoaderFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    
    -- Enhanced Title with glow effect
    local TitleLoader = Instance.new("TextLabel")
    TitleLoader.Parent = MainLoaderFrame
    TitleLoader.Text = "Xenon"
    TitleLoader.Font = Enum.Font.FredokaOne
    TitleLoader.TextSize = 60
    TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLoader.BackgroundTransparency = 1
    TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0)
    TitleLoader.Size = UDim2.new(0.8, 0, 0.2, 0)
    CreateStroke(TitleLoader, _G.Third, 2)
    
    -- Enhanced Description
    local DescriptionLoader = Instance.new("TextLabel")
    DescriptionLoader.Parent = MainLoaderFrame
    DescriptionLoader.Text = "Loading Premium UI..."
    DescriptionLoader.Font = Enum.Font.GothamMedium
    DescriptionLoader.TextSize = 16
    DescriptionLoader.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLoader.BackgroundTransparency = 1
    DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    DescriptionLoader.Position = UDim2.new(0.5, 0, 0.55, 0)
    DescriptionLoader.Size = UDim2.new(0.8, 0, 0.1, 0)
    
    -- Enhanced Loading Bar Background
    local LoadingBarBackground = Instance.new("Frame")
    LoadingBarBackground.Parent = MainLoaderFrame
    LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
    LoadingBarBackground.Size = UDim2.new(0.6, 0, 0.08, 0)
    LoadingBarBackground.ClipsDescendants = true
    LoadingBarBackground.BorderSizePixel = 0
    LoadingBarBackground.ZIndex = 2
    CreateRounded(LoadingBarBackground, 25)
    CreateStroke(LoadingBarBackground, _G.Border, 2)
    
    -- Enhanced Loading Bar with gradient
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Parent = LoadingBarBackground
    LoadingBar.BackgroundColor3 = _G.Third
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.ZIndex = 3
    CreateRounded(LoadingBar, 25)
    
    -- Add animated gradient to loading bar
    CreateGradient(LoadingBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Third),
        ColorSequenceKeypoint.new(0.5, _G.Accent),
        ColorSequenceKeypoint.new(1, _G.Third)
    }))
    
    -- Enhanced Animation setup
    local tweenService = game:GetService("TweenService")
    local dotCount = 0
    local running = true
    
    -- Title glow animation
    spawn(function()
        while running do
            TweenService:Create(TitleLoader, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextTransparency = 0.3
            }):Play()
            wait(1)
            TweenService:Create(TitleLoader, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextTransparency = 0
            }):Play()
            wait(1)
        end
    end)
    
    local barTweenInfoPart1 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local barTweenPart1 = tweenService:Create(LoadingBar, barTweenInfoPart1, {
        Size = UDim2.new(0.4, 0, 1, 0)
    })
    
    local barTweenInfoPart2 = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local barTweenPart2 = tweenService:Create(LoadingBar, barTweenInfoPart2, {
        Size = UDim2.new(1, 0, 1, 0)
    })
    
    barTweenPart1:Play()
    
    function Update:Loaded()
        barTweenPart2:Play()
    end
    
    barTweenPart1.Completed:Connect(function()
        running = true
        barTweenPart2.Completed:Connect(function()
            wait(1)
            running = false
            DescriptionLoader.Text = "Ready to use!"
            wait(0.8)
            -- Fade out animation
            TweenService:Create(Loader, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
            wait(0.5)
            Loader:Destroy()
        end)
    end)
    
    -- Enhanced animated dots
    spawn(function()
        while running do
            dotCount = (dotCount + 1) % 4
            local dots = string.rep(".", dotCount)
            DescriptionLoader.Text = "Loading Premium UI" .. dots
            wait(0.4)
        end
    end)
end

-- Settings functions
function Update:SaveSettings()
    return SettingsLib.SaveSettings
end

function Update:LoadAnimation()
    return SettingsLib.LoadAnimation
end

-- ========================================
-- ENHANCED MAIN WINDOW CREATION
-- ========================================
function Update:Window(Config)
    assert(Config.SubTitle, "v4.1")
    
    local WindowConfig = {
        Size = Config.Size,
        TabWidth = Config.TabWidth
    }
    
    local osfunc = {}
    local uihide = false
    local abc = false
    local currentpage = ""
    local keybind = keybind or Enum.KeyCode.RightControl
    local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "")
    
    -- Enhanced Main GUI Creation
    local Xenon = Instance.new("ScreenGui")
    Xenon.Name = "Xenon"
    Xenon.Parent = game.CoreGui
    Xenon.DisplayOrder = 999
    
    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.Parent = Xenon
    OutlineMain.ClipsDescendants = true
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.BackgroundColor3 = _G.Surface
    OutlineMain.BackgroundTransparency = 0.1
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
    OutlineMain.Size = UDim2.new(0, 0, 0, 0)
    CreateRounded(OutlineMain, 18, true)
    CreateStroke(OutlineMain, _G.Border, 2)
    
    -- Add animated gradient background
    CreateGradient(OutlineMain, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Dark),
        ColorSequenceKeypoint.new(0.3, _G.Surface),
        ColorSequenceKeypoint.new(0.7, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Dark)
    }), 45)
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = OutlineMain
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = _G.Dark
    Main.BackgroundTransparency = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = WindowConfig.Size
    CreateRounded(Main, 15)
    
    -- Animate window opening with enhanced easing
    OutlineMain:TweenSize(
        UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20), 
        "Out", "Back", 0.6, true
    )
    
    -- ========================================
    -- ENHANCED TOP BAR CREATION
    -- ========================================
    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = _G.Surface
    Top.Size = UDim2.new(1, 0, 0, 45)
    Top.BackgroundTransparency = 0
    CreateRounded(Top, 15)
    CreateStroke(Top, _G.Border, 1)
    
    -- Add gradient to top bar
    CreateGradient(Top, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Primary)
    }), 90)
    
    -- Enhanced Hub Name
    local NameHub = Instance.new("TextLabel")
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.RichText = true
    NameHub.Position = UDim2.new(0, 20, 0.5, 0)
    NameHub.AnchorPoint = Vector2.new(0, 0.5)
    NameHub.Size = UDim2.new(0, 1, 0, 25)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = "Xenon"
    NameHub.TextSize = 22
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    CreateStroke(NameHub, _G.Third, 1)
    
    local nameHubSize = game:GetService("TextService"):GetTextSize(
        NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge)
    )
    NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25)
    
    -- Enhanced Subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = NameHub
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, nameHubSize.X + 10, 0.5, 0)
    SubTitle.Size = UDim2.new(0, 1, 0, 20)
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.AnchorPoint = Vector2.new(0, 0.5)
    SubTitle.Text = Config.SubTitle
    SubTitle.TextSize = 14
    SubTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    
    local SubTitleSize = game:GetService("TextService"):GetTextSize(
        SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge)
    )
    SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25)
    
    -- ========================================
    -- ENHANCED CONTROL BUTTONS
    -- ========================================
    
    -- Enhanced Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top
    CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Image = "rbxassetid://7743878857"
    CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(CloseButton, 8)
    
    AddHoverEffect(CloseButton, Color3.fromRGB(220, 38, 38), Color3.fromRGB(239, 68, 68))
    
    CloseButton.MouseButton1Click:Connect(function()
        local xenonGui = game.CoreGui:FindFirstChild("Xenon")
        if xenonGui then
            xenonGui.Enabled = not xenonGui.Enabled
        end
    end)
    
    -- Enhanced Resize Button
    local ResizeButton = Instance.new("ImageButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Parent = Top
    ResizeButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    ResizeButton.BackgroundTransparency = 0.2
    ResizeButton.AnchorPoint = Vector2.new(1, 0.5)
    ResizeButton.Position = UDim2.new(1, -50, 0.5, 0)
    ResizeButton.Size = UDim2.new(0, 25, 0, 25)
    ResizeButton.Image = "rbxassetid://10734886735"
    ResizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(ResizeButton, 8)
    
    AddHoverEffect(ResizeButton, Color3.fromRGB(22, 163, 74), Color3.fromRGB(34, 197, 94))
    
    -- Enhanced Settings Button
    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = Top
    SettingsButton.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    SettingsButton.BackgroundTransparency = 0.2
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
    SettingsButton.Position = UDim2.new(1, -85, 0.5, 0)
    SettingsButton.Size = UDim2.new(0, 25, 0, 25)
    SettingsButton.Image = "rbxassetid://10734950020"
    SettingsButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(SettingsButton, 8)
    
    AddHoverEffect(SettingsButton, Color3.fromRGB(100, 100, 235), Color3.fromRGB(120, 120, 255))
    
    -- ========================================
    -- ENHANCED SETTINGS PANEL
    -- ========================================
    local BackgroundSettings = Instance.new("Frame")
    BackgroundSettings.Name = "BackgroundSettings"
    BackgroundSettings.Parent = OutlineMain
    BackgroundSettings.ClipsDescendants = true
    BackgroundSettings.Active = true
    BackgroundSettings.AnchorPoint = Vector2.new(0, 0)
    BackgroundSettings.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundSettings.BackgroundTransparency = 0.4
    BackgroundSettings.Position = UDim2.new(0, 0, 0, 0)
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSettings.Visible = false
    CreateRounded(BackgroundSettings, 18)
    
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = BackgroundSettings
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsFrame.BackgroundColor3 = _G.Surface
    SettingsFrame.BackgroundTransparency = 0
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsFrame.Size = UDim2.new(0.75, 0, 0.75, 0)
    CreateRounded(SettingsFrame, 18)
    CreateStroke(SettingsFrame, _G.Border, 2)
    
    -- Add gradient background
    CreateGradient(SettingsFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Primary)
    }), 135)
    
    -- Enhanced Settings Close Button
    local CloseSettings = Instance.new("ImageButton")
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    CloseSettings.BackgroundTransparency = 0.2
    CloseSettings.AnchorPoint = Vector2.new(1, 0)
    CloseSettings.Position = UDim2.new(1, -20, 0, 20)
    CloseSettings.Size = UDim2.new(0, 25, 0, 25)
    CloseSettings.Image = "rbxassetid://10747384394"
    CloseSettings.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CreateRounded(CloseSettings, 8)
    
    AddHoverEffect(CloseSettings, Color3.fromRGB(220, 38, 38), Color3.fromRGB(239, 68, 68))
    
    CloseSettings.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = false
    end)
    
    SettingsButton.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = true
    end)
    
    -- Enhanced Settings Title
    local TitleSettings = Instance.new("TextLabel")
    TitleSettings.Name = "TitleSettings"
    TitleSettings.Parent = SettingsFrame
    TitleSettings.BackgroundTransparency = 1
    TitleSettings.Position = UDim2.new(0, 25, 0, 20)
    TitleSettings.Size = UDim2.new(1, 0, 0, 25)
    TitleSettings.Font = Enum.Font.GothamBold
    TitleSettings.Text = "Library Settings"
    TitleSettings.TextSize = 22
    TitleSettings.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left
    CreateStroke(TitleSettings, _G.Third, 1)
    
    -- Enhanced Settings Menu List
    local SettingsMenuList = Instance.new("Frame")
    SettingsMenuList.Name = "SettingsMenuList"
    SettingsMenuList.Parent = SettingsFrame
    SettingsMenuList.ClipsDescendants = true
    SettingsMenuList.BackgroundTransparency = 1
    SettingsMenuList.Position = UDim2.new(0, 0, 0, 60)
    SettingsMenuList.Size = UDim2.new(1, 0, 1, -80)
    
    local ScrollSettings = Instance.new("ScrollingFrame")
    ScrollSettings.Name = "ScrollSettings"
    ScrollSettings.Parent = SettingsMenuList
    ScrollSettings.Active = true
    ScrollSettings.BackgroundTransparency = 1
    ScrollSettings.Position = UDim2.new(0, 0, 0, 0)
    ScrollSettings.Size = UDim2.new(1, 0, 1, 0)
    ScrollSettings.ScrollBarThickness = 4
    ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.Name = "SettingsListLayout"
    SettingsListLayout.Parent = ScrollSettings
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 10)
    
    local PaddingScroll = Instance.new("UIPadding")
    PaddingScroll.Name = "PaddingScroll"
    PaddingScroll.Parent = ScrollSettings
    PaddingScroll.PaddingLeft = UDim.new(0, 25)
    PaddingScroll.PaddingRight = UDim.new(0, 25)
    
    -- ========================================
    -- ENHANCED SETTINGS COMPONENTS
    -- ========================================
    
    -- Enhanced Checkbox creation function
    local function CreateCheckbox(title, state, callback)
        local checked = state or false
        
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.ClipsDescendants = true
        Background.BackgroundColor3 = _G.Primary
        Background.BackgroundTransparency = 0.3
        Background.Size = UDim2.new(1, 0, 0, 40)
        CreateRounded(Background, 10)
        CreateStroke(Background, _G.Border, 1)
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = Background
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 50, 0.5, 0)
        Title.Size = UDim2.new(1, -70, 0, 20)
        Title.Font = Enum.Font.GothamMedium
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.Text = title or ""
        Title.TextSize = 15
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local Checkbox = Instance.new("ImageButton")
        Checkbox.Name = "Checkbox"
        Checkbox.Parent = Background
        Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        Checkbox.BackgroundTransparency = 0
        Checkbox.AnchorPoint = Vector2.new(0, 0.5)
        Checkbox.Position = UDim2.new(0, 15, 0.5, 0)
        Checkbox.Size = UDim2.new(0, 22, 0, 22)
        Checkbox.Image = "rbxassetid://10709790644"
        Checkbox.ImageTransparency = 1
        Checkbox.ImageColor3 = Color3.fromRGB(255, 255, 255)
        CreateRounded(Checkbox, 6)
        CreateStroke(Checkbox, _G.Border, 2)
        
        AddHoverEffect(Background, _G.Surface, _G.Primary)
        
        Checkbox.MouseButton1Click:Connect(function()
            checked = not checked
            if checked then
                TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    BackgroundColor3 = _G.Success,
                    ImageTransparency = 0
                }):Play()
                TweenService:Create(Checkbox:FindFirstChild("UIStroke"), TweenInfo.new(0.2), {
                    Color = _G.Success
                }):Play()
            else
                TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                    ImageTransparency = 1
                }):Play()
                TweenService:Create(Checkbox:FindFirstChild("UIStroke"), TweenInfo.new(0.2), {
                    Color = _G.Border
                }):Play()
            end
            pcall(callback, checked)
        end)
        
        -- Set initial state
        if checked then
            Checkbox.ImageTransparency = 0
            Checkbox.BackgroundColor3 = _G.Success
            Checkbox:FindFirstChild("UIStroke").Color = _G.Success
        else
            Checkbox.ImageTransparency = 1
            Checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        end
        pcall(callback, checked)
    end
    
    -- Enhanced Button creation function
    local function CreateButton(title, callback)
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.ClipsDescendants = true
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 50)
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = Background
        Button.BackgroundColor3 = _G.Third
        Button.BackgroundTransparency = 0
        Button.Size = UDim2.new(0.8, 0, 0, 40)
        Button.Font = Enum.Font.GothamBold
        Button.Text = title or "Button"
        Button.AnchorPoint = Vector2.new(0.5, 0)
        Button.Position = UDim2.new(0.5, 0, 0, 0)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.AutoButtonColor = false
        CreateRounded(Button, 10)
        CreateStroke(Button, _G.Border, 2)
        
        -- Add gradient
        CreateGradient(Button, ColorSequence.new({
            ColorSequenceKeypoint.new(0, _G.Third),
            ColorSequenceKeypoint.new(1, _G.Accent)
        }), 45)
        
        AddHoverEffect(Button, _G.Accent, _G.Third)
        
        Button.MouseButton1Down:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.75, 0, 0, 35)}):Play()
        end)
        
        Button.MouseButton1Up:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.8, 0, 0, 40)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            callback()
        end)
    end
    
    -- Create enhanced settings options
    CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
        SettingsLib.SaveSettings = state
        getgenv().SaveConfig()
    end)
    
    CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state
        getgenv().SaveConfig()
    end)
    
    CreateButton("Reset Configuration", function()
        if isfolder("Xenon") then
            delfolder("Xenon")
        end
        Update:Notify("Configuration has been reset!", "success")
    end)
    
    -- ========================================
    -- ENHANCED TAB SYSTEM
    -- ========================================
    local Tab = Instance.new("Frame")
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.BackgroundColor3 = _G.Surface
    Tab.Position = UDim2.new(0, 10, 0, Top.Size.Y.Offset + 5)
    Tab.BackgroundTransparency = 0
    Tab.Size = UDim2.new(0, WindowConfig.TabWidth, Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15)
    CreateRounded(Tab, 12)
    CreateStroke(Tab, _G.Border, 1)
    
    -- Add gradient to tab background
    CreateGradient(Tab, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Surface),
        ColorSequenceKeypoint.new(1, _G.Primary)
    }), 180)
    
    local ScrollTab = Instance.new("ScrollingFrame")
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = Tab
    ScrollTab.Active = true
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.Position = UDim2.new(0, 0, 0, 0)
    ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = ScrollTab
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    local PPD = Instance.new("UIPadding")
    PPD.Name = "PPD"
    PPD.Parent = ScrollTab
    PPD.PaddingTop = UDim.new(0, 10)
    PPD.PaddingLeft = UDim.new(0, 8)
    PPD.PaddingRight = UDim.new(0, 8)
    
    -- Enhanced Page Container
    local Page = Instance.new("Frame")
    Page.Name = "Page"
    Page.Parent = Main
    Page.BackgroundColor3 = _G.Primary
    Page.Position = UDim2.new(0, Tab.Size.X.Offset + 20, 0, Top.Size.Y.Offset + 5)
    Page.Size = UDim2.new(
        Config.Size.X.Scale, Config.Size.X.Offset - Tab.Size.X.Offset - 30, 
        Config.Size.Y.Scale, Config.Size.Y.Offset - Top.Size.Y.Offset - 15
    )
    Page.BackgroundTransparency = 0
    CreateRounded(Page, 12)
    CreateStroke(Page, _G.Border, 1)
    
    -- Add gradient to page background
    CreateGradient(Page, ColorSequence.new({
        ColorSequenceKeypoint.new(0, _G.Primary),
        ColorSequenceKeypoint.new(1, _G.Surface)
    }), 45)
    
    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Parent = Page
    MainPage.ClipsDescendants = true
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
    UIPageLayout.TweenTime = 0.3
    UIPageLayout.GamepadInputEnabled = false
    UIPageLayout.ScrollWheelInputEnabled = false
    UIPageLayout.TouchInputEnabled = false
    
    -- Make window draggable
    MakeDraggable(Top, OutlineMain)
    
    -- Toggle visibility with Insert key
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            local xenonGui = game.CoreGui:FindFirstChild("Xenon")
            if xenonGui then
                xenonGui.Enabled = not xenonGui.Enabled
            end
        end
    end)
    
    -- ========================================
    -- ENHANCED RESIZE FUNCTIONALITY
    -- ========================================
    local DragButton = Instance.new("Frame")
    DragButton.Name = "DragButton"
    DragButton.Parent = Main
    DragButton.Position = UDim2.new(1, 2, 1, 2)
    DragButton.AnchorPoint = Vector2.new(1, 1)
    DragButton.Size = UDim2.new(0, 20, 0, 20)
    DragButton.BackgroundColor3 = _G.Third
    DragButton.BackgroundTransparency = 0.3
    DragButton.ZIndex = 10
    CreateRounded(DragButton, 10)
    CreateStroke(DragButton, _G.Border, 2)
    
    local Dragging = false
    
    DragButton.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            TweenService:Create(DragButton, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            TweenService:Create(DragButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            OutlineMain.Size = UDim2.new(
                0, math.clamp(Input.Position.X - Main.AbsolutePosition.X + 20, WindowConfig.Size.X.Offset + 20, math.huge), 
                0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y + 20, WindowConfig.Size.Y.Offset + 20, math.huge)
            )
            Main.Size = UDim2.new(
                0, math.clamp(Input.Position.X - Main.AbsolutePosition.X, WindowConfig.Size.X.Offset, math.huge), 
                0, math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, WindowConfig.Size.Y.Offset, math.huge)
            )
            Page.Size = UDim2.new(
                0, math.clamp(Input.Position.X - Page.AbsolutePosition.X - 10, WindowConfig.Size.X.Offset - Tab.Size.X.Offset - 30, math.huge), 
                0, math.clamp(Input.Position.Y - Page.AbsolutePosition.Y - 10, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 15, math.huge)
            )
            Tab.Size = UDim2.new(
                0, WindowConfig.TabWidth, 
                0, math.clamp(Input.Position.Y - Tab.AbsolutePosition.Y - 10, WindowConfig.Size.Y.Offset - Top.Size.Y.Offset - 15, math.huge)
            )
        end
    end)
    
    -- ========================================
    -- ENHANCED TAB CREATION SYSTEM
    -- ========================================
    local uitab = {}
    
    function uitab:Tab(text, img)
        local TabButton = Instance.new("TextButton")
        local Title = Instance.new("TextLabel")
        
        TabButton.Parent = ScrollTab
        TabButton.Name = text .. "Unique"
        TabButton.Text = ""
        TabButton.BackgroundColor3 = _G.Primary
        TabButton.BackgroundTransparency = 0.8
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.Nunito
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 12
        TabButton.AutoButtonColor = false
        CreateRounded(TabButton, 10)
        CreateStroke(TabButton, _G.Border, 1)
        
        local SelectedTab = Instance.new("Frame")
        SelectedTab.Name = "SelectedTab"
        SelectedTab.Parent = TabButton
        SelectedTab.BackgroundColor3 = _G.Third
        SelectedTab.BackgroundTransparency = 0
        SelectedTab.Size = UDim2.new(0, 4, 0, 0)
        SelectedTab.Position = UDim2.new(0, 0, 0.5, 0)
        SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
        CreateRounded(SelectedTab, 2)
        
        Title.Parent = TabButton
        Title.Name = "Title"
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 35, 0.5, 0)
        Title.Size = UDim2.new(1, -40, 0, 30)
        Title.Font = Enum.Font.GothamMedium
        Title.Text = text
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.TextColor3 = Color3.fromRGB(200, 200, 220)
        Title.TextTransparency = 0.3
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local IDK = Instance.new("ImageLabel")
        IDK.Name = "IDK"
        IDK.Parent = TabButton
        IDK.BackgroundTransparency = 1
        IDK.ImageTransparency = 0.4
        IDK.Position = UDim2.new(0, 10, 0.5, 0)
        IDK.Size = UDim2.new(0, 18, 0, 18)
        IDK.AnchorPoint = Vector2.new(0, 0.5)
        IDK.Image = img
        IDK.ImageColor3 = Color3.fromRGB(200, 200, 220)
        
        AddHoverEffect(TabButton, _G.Surface, _G.Primary)
        
        -- Create enhanced page for this tab
        local MainFramePage = Instance.new("ScrollingFrame")
        MainFramePage.Name = text .. "_Page"
        MainFramePage.Parent = PageList
        MainFramePage.Active = true
        MainFramePage.BackgroundTransparency = 1
        MainFramePage.Position = UDim2.new(0, 0, 0, 0)
        MainFramePage.Size = UDim2.new(1, 0, 1, 0)
        MainFramePage.ScrollBarThickness = 6
        MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y
        MainFramePage.ScrollBarImageColor3 = _G.Third
        
        local UIPadding = Instance.new("UIPadding")
        local UIListLayout = Instance.new("UIListLayout")
        UIPadding.Parent = MainFramePage
        UIPadding.PaddingTop = UDim.new(0, 15)
        UIPadding.PaddingLeft = UDim.new(0, 15)
        UIPadding.PaddingRight = UDim.new(0, 15)
        UIPadding.PaddingBottom = UDim.new(0, 15)
        
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = MainFramePage
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Enhanced Tab click handler
        TabButton.MouseButton1Click:Connect(function()
            -- Reset all tabs with enhanced animations
            for i, v in next, ScrollTab:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.8
                    }):Play()
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 4, 0, 0)
                    }):Play()
                    TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0.4,
                        ImageColor3 = Color3.fromRGB(200, 200, 220)
                    }):Play()
                    TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0.3,
                        TextColor3 = Color3.fromRGB(200, 200, 220)
                    }):Play()
                end
            end
            
            -- Activate current tab with enhanced animations
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 4, 0, 25)
            }):Play()
            TweenService:Create(IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0,
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            
            -- Switch to page
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
                        BackgroundTransparency = 0.8
                    }):Play()
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 4, 0, 25)
                    }):Play()
                    TweenService:Create(v.IDK, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0.4
                    }):Play()
                    TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0.3
                    }):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 4, 0, 25)
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
        
        -- Update canvas sizes
        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 30)
                ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
                ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 50)
            end)
        end)
        
        -- Enhanced resize functionality
        local defaultSize = true
        ResizeButton.MouseButton1Click:Connect(function()
            if defaultSize then
                defaultSize = false
                OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Back", 0.3, true)
                Main:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Back", 0.5, true, function()
                    Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 30, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 15), "Out", "Quad", 0.4, true)
                    Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 15), "Out", "Quad", 0.4, true)
                end)
                OutlineMain:TweenSize(UDim2.new(1, -20, 1, -20), "Out", "Back", 0.5, true)
                ResizeButton.Image = "rbxassetid://10734895698"
            else
                defaultSize = true
                Main:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset, 0, WindowConfig.Size.Y.Offset), "Out", "Back", 0.5, true, function()
                    Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 30, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 15), "Out", "Quad", 0.4, true)
                    Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - Top.AbsoluteSize.Y - 15), "Out", "Quad", 0.4, true)
                end)
                OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 20, 0, WindowConfig.Size.Y.Offset + 20), "Out", "Back", 0.5, true)
                ResizeButton.Image = "rbxassetid://10734886735"
            end
        end)
        
        -- ========================================
        -- ENHANCED UI COMPONENTS FOR TABS
        -- ========================================
        local main = {}
        
        -- Enhanced Button Component
        function main:Button(text, callback)
            local Button = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")
            
            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Surface
            Button.BackgroundTransparency = 0
            Button.Size = UDim2.new(1, 0, 0, 45)
            CreateRounded(Button, 12)
            CreateStroke(Button, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(Button, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Name = "ImageLabel"
            ImageLabel.Parent = TextButton
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            ImageLabel.Size = UDim2.new(0, 18, 0, 18)
            ImageLabel.Image = "rbxassetid://10734898355"
            ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            
            TextButton.Name = "TextButton"
            TextButton.Parent = Button
            TextButton.BackgroundColor3 = _G.Third
            TextButton.BackgroundTransparency = 0
            TextButton.AnchorPoint = Vector2.new(1, 0.5)
            TextButton.Position = UDim2.new(1, -15, 0.5, 0)
            TextButton.Size = UDim2.new(0, 35, 0, 35)
            TextButton.Font = Enum.Font.Nunito
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            CreateRounded(TextButton, 10)
            CreateStroke(TextButton, _G.Border, 1)
            
            TextLabel.Name = "TextLabel"
            TextLabel.Parent = Button
            TextLabel.BackgroundTransparency = 1
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
            TextLabel.Size = UDim2.new(1, -70, 1, 0)
            TextLabel.Font = Enum.Font.GothamMedium
            TextLabel.RichText = true
            TextLabel.Text = text
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 15
            TextLabel.ClipsDescendants = true
            
            local ArrowRight = Instance.new("ImageLabel")
            ArrowRight.Name = "ArrowRight"
            ArrowRight.Parent = Button
            ArrowRight.BackgroundTransparency = 1
            ArrowRight.AnchorPoint = Vector2.new(0, 0.5)
            ArrowRight.Position = UDim2.new(0, 0, 0.5, 0)
            ArrowRight.Size = UDim2.new(0, 18, 0, 18)
            ArrowRight.Image = "rbxassetid://10709768347"
            ArrowRight.ImageColor3 = _G.Third
            
            AddHoverEffect(Button, _G.Primary, _G.Surface)
            AddHoverEffect(TextButton, _G.Accent, _G.Third)
            
            TextButton.MouseButton1Down:Connect(function()
                TweenService:Create(TextButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)}):Play()
            end)
            
            TextButton.MouseButton1Up:Connect(function()
                TweenService:Create(TextButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 35, 0, 35)}):Play()
            end)
            
            TextButton.MouseButton1Click:Connect(function()
                callback()
            end)
        end
        
        -- Enhanced Toggle Component
        function main:Toggle(text, config, desc, callback)
            config = config or false
            local toggled = config
            
            local Button = Instance.new("TextButton")
            local Title2 = Instance.new("TextLabel")
            local Desc = Instance.new("TextLabel")
            local ToggleFrame = Instance.new("Frame")
            local ToggleImage = Instance.new("TextButton")
            local Circle = Instance.new("Frame")
            
            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Surface
            Button.BackgroundTransparency = 0
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 11
            CreateRounded(Button, 12)
            CreateStroke(Button, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(Button, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            Title2.Parent = Button
            Title2.BackgroundTransparency = 1
            Title2.Size = UDim2.new(1, 0, 0, 35)
            Title2.Font = Enum.Font.GothamMedium
            Title2.Text = text
            Title2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title2.TextSize = 15
            Title2.TextXAlignment = Enum.TextXAlignment.Left
            Title2.AnchorPoint = Vector2.new(0, 0.5)
            
            Desc.Parent = Title2
            Desc.BackgroundTransparency = 1
            Desc.Position = UDim2.new(0, 0, 0, 25)
            Desc.Size = UDim2.new(0, 350, 0, 16)
            Desc.Font = Enum.Font.Gotham
            
            if desc then
                Desc.Text = desc
                Title2.Position = UDim2.new(0, 20, 0.5, -8)
                Desc.Position = UDim2.new(0, 0, 0, 25)
                Button.Size = UDim2.new(1, 0, 0, 55)
            else
                Title2.Position = UDim2.new(0, 20, 0.5, 0)
                Desc.Visible = false
                Button.Size = UDim2.new(1, 0, 0, 45)
            end
            
            Desc.TextColor3 = Color3.fromRGB(180, 180, 200)
            Desc.TextSize = 12
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Button
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            ToggleFrame.BackgroundTransparency = 0
            ToggleFrame.Position = UDim2.new(1, -15, 0.5, 0)
            ToggleFrame.Size = UDim2.new(0, 50, 0, 26)
            ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
            CreateRounded(ToggleFrame, 15)
            CreateStroke(ToggleFrame, _G.Border, 2)
            
            ToggleImage.Name = "ToggleImage"
            ToggleImage.Parent = ToggleFrame
            ToggleImage.BackgroundTransparency = 1
            ToggleImage.Position = UDim2.new(0, 0, 0, 0)
            ToggleImage.Size = UDim2.new(1, 0, 1, 0)
            ToggleImage.Text = ""
            ToggleImage.AutoButtonColor = false
            
            Circle.Name = "Circle"
            Circle.Parent = ToggleImage
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BackgroundTransparency = 0
            Circle.Position = UDim2.new(0, 3, 0.5, 0)
            Circle.Size = UDim2.new(0, 20, 0, 20)
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            CreateRounded(Circle, 10)
            CreateStroke(Circle, _G.Border, 1)
            
            AddHoverEffect(Button, _G.Primary, _G.Surface)
            
            ToggleImage.MouseButton1Click:Connect(function()
                if toggled == false then
                    toggled = true
                    TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 27, 0.5, 0)
                    }):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = _G.Success
                    }):Play()
                    TweenService:Create(ToggleFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.3), {
                        Color = _G.Success
                    }):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                else
                    toggled = false
                    TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 3, 0.5, 0)
                    }):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    }):Play()
                    TweenService:Create(ToggleFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.3), {
                        Color = _G.Border
                    }):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    }):Play()
                end
                pcall(callback, toggled)
            end)
            
            -- Set initial state with enhanced styling
            if config == true then
                toggled = true
                Circle.Position = UDim2.new(0, 27, 0.5, 0)
                ToggleFrame.BackgroundColor3 = _G.Success
                ToggleFrame:FindFirstChild("UIStroke").Color = _G.Success
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                pcall(callback, toggled)
            else
                Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        
        -- Enhanced Dropdown Component with Search
        function main:Dropdown(text, option, var, callback)
            local isdropping = false
            
            local Dropdown = Instance.new("Frame")
            local DropdownFrameScroll = Instance.new("Frame")
            local DropTitle = Instance.new("TextLabel")
            local SearchBox = Instance.new("TextBox")
            local DropScroll = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")
            local SelectItems = Instance.new("TextButton")
            
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = MainFramePage
            Dropdown.BackgroundColor3 = _G.Surface
            Dropdown.BackgroundTransparency = 0
            Dropdown.ClipsDescendants = false
            Dropdown.Size = UDim2.new(1, 0, 0, 50)
            CreateRounded(Dropdown, 12)
            CreateStroke(Dropdown, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(Dropdown, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            DropTitle.Name = "DropTitle"
            DropTitle.Parent = Dropdown
            DropTitle.BackgroundTransparency = 1
            DropTitle.Size = UDim2.new(1, 0, 0, 30)
            DropTitle.Font = Enum.Font.GothamMedium
            DropTitle.Text = text
            DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropTitle.TextSize = 15
            DropTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropTitle.Position = UDim2.new(0, 20, 0, 8)
            DropTitle.AnchorPoint = Vector2.new(0, 0)
            
            SelectItems.Name = "SelectItems"
            SelectItems.Parent = Dropdown
            SelectItems.BackgroundColor3 = _G.Primary
            SelectItems.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectItems.BackgroundTransparency = 0
            SelectItems.Position = UDim2.new(1, -15, 0, 8)
            SelectItems.Size = UDim2.new(0, 120, 0, 35)
            SelectItems.AnchorPoint = Vector2.new(1, 0)
            SelectItems.Font = Enum.Font.GothamMedium
            SelectItems.AutoButtonColor = false
            SelectItems.TextSize = 12
            SelectItems.ZIndex = 1
            SelectItems.ClipsDescendants = true
            SelectItems.Text = "   Select Items"
            SelectItems.TextXAlignment = Enum.TextXAlignment.Left
            CreateRounded(SelectItems, 8)
            CreateStroke(SelectItems, _G.Border, 1)
            
            AddHoverEffect(SelectItems, _G.Surface, _G.Primary)
            
            local ArrowDown = Instance.new("ImageLabel")
            ArrowDown.Name = "ArrowDown"
            ArrowDown.Parent = Dropdown
            ArrowDown.BackgroundTransparency = 1
            ArrowDown.AnchorPoint = Vector2.new(1, 0)
            ArrowDown.Position = UDim2.new(1, -140, 0, 13)
            ArrowDown.Size = UDim2.new(0, 25, 0, 25)
            ArrowDown.Image = "rbxassetid://10709790948"
            ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255)
            
            DropdownFrameScroll.Name = "DropdownFrameScroll"
            DropdownFrameScroll.Parent = Dropdown
            DropdownFrameScroll.BackgroundColor3 = _G.Surface
            DropdownFrameScroll.BackgroundTransparency = 0
            DropdownFrameScroll.ClipsDescendants = true
            DropdownFrameScroll.Size = UDim2.new(1, 0, 0, 0)
            DropdownFrameScroll.Position = UDim2.new(0, 0, 0, 55)
            DropdownFrameScroll.Visible = false
            DropdownFrameScroll.AnchorPoint = Vector2.new(0, 0)
            CreateRounded(DropdownFrameScroll, 12)
            CreateStroke(DropdownFrameScroll, _G.Border, 1)
            
            -- Add gradient to dropdown frame
            CreateGradient(DropdownFrameScroll, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 135)
            
            -- Enhanced Search Box
            SearchBox.Name = "SearchBox"
            SearchBox.Parent = DropdownFrameScroll
            SearchBox.BackgroundColor3 = _G.Primary
            SearchBox.BackgroundTransparency = 0
            SearchBox.Position = UDim2.new(0, 10, 0, 10)
            SearchBox.Size = UDim2.new(1, -20, 0, 35)
            SearchBox.Font = Enum.Font.GothamMedium
            SearchBox.PlaceholderText = "🔍 Search items..."
            SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            SearchBox.Text = ""
            SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SearchBox.TextSize = 13
            SearchBox.TextXAlignment = Enum.TextXAlignment.Left
            CreateRounded(SearchBox, 8)
            CreateStroke(SearchBox, _G.Border, 1)
            
            -- Search box padding
            local SearchPadding = Instance.new("UIPadding")
            SearchPadding.Parent = SearchBox
            SearchPadding.PaddingLeft = UDim.new(0, 12)
            SearchPadding.PaddingRight = UDim.new(0, 12)
            
            AddHoverEffect(SearchBox, _G.Surface, _G.Primary)
            
            DropScroll.Name = "DropScroll"
            DropScroll.Parent = DropdownFrameScroll
            DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y
            DropScroll.Active = true
            DropScroll.BackgroundTransparency = 1
            DropScroll.BorderSizePixel = 0
            DropScroll.Position = UDim2.new(0, 0, 0, 55)
            DropScroll.Size = UDim2.new(1, 0, 1, -55)
            DropScroll.AnchorPoint = Vector2.new(0, 0)
            DropScroll.ClipsDescendants = true
            DropScroll.ScrollBarThickness = 4
            DropScroll.ScrollBarImageColor3 = _G.Third
            DropScroll.ZIndex = 3
            
            local PaddingDrop = Instance.new("UIPadding")
            PaddingDrop.PaddingLeft = UDim.new(0, 15)
            PaddingDrop.PaddingRight = UDim.new(0, 15)
            PaddingDrop.PaddingTop = UDim.new(0, 10)
            PaddingDrop.PaddingBottom = UDim.new(0, 10)
            PaddingDrop.Parent = DropScroll
            PaddingDrop.Name = "PaddingDrop"
            
            UIListLayout.Parent = DropScroll
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 3)
            
            local allItems = {}
            
            -- Create enhanced dropdown items
            for i, v in next, option do
                local Item = Instance.new("TextButton")
                local ItemPadding = Instance.new("UIPadding")
                
                Item.Name = "Item"
                Item.Parent = DropScroll
                Item.BackgroundColor3 = _G.Primary
                Item.BackgroundTransparency = 0.8
                Item.Size = UDim2.new(1, 0, 0, 35)
                Item.Font = Enum.Font.GothamMedium
                Item.Text = tostring(v)
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 13
                Item.TextTransparency = 0.2
                Item.TextXAlignment = Enum.TextXAlignment.Left
                Item.ZIndex = 4
                Item.AutoButtonColor = false
                CreateRounded(Item, 8)
                CreateStroke(Item, _G.Border, 1)
                
                ItemPadding.Parent = Item
                ItemPadding.PaddingLeft = UDim.new(0, 12)
                
                local SelectedItems = Instance.new("Frame")
                SelectedItems.Name = "SelectedItems"
                SelectedItems.Parent = Item
                SelectedItems.BackgroundColor3 = _G.Third
                SelectedItems.BackgroundTransparency = 1
                SelectedItems.Size = UDim2.new(0, 4, 0.6, 0)
                SelectedItems.Position = UDim2.new(0, -12, 0.5, 0)
                SelectedItems.AnchorPoint = Vector2.new(0, 0.5)
                SelectedItems.ZIndex = 4
                CreateRounded(SelectedItems, 2)
                
                AddHoverEffect(Item, _G.Surface, _G.Primary)
                
                table.insert(allItems, {item = Item, text = tostring(v)})
                
                if var then
                    pcall(callback, var)
                    SelectItems.Text = "   " .. var
                    activeItem = tostring(var)
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            local SelectedItems = v:FindFirstChild("SelectedItems")
                            if activeItem == v.Text then
                                v.BackgroundTransparency = 0.2
                                v.TextTransparency = 0
                                if SelectedItems then
                                    SelectedItems.BackgroundTransparency = 0
                                end
                            end
                        end
                    end
                end
                
                Item.MouseButton1Click:Connect(function()
                    SelectItems.ClipsDescendants = true
                    callback(Item.Text)
                    activeItem = Item.Text
                    
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            local SelectedItems = v:FindFirstChild("SelectedItems")
                            if activeItem == v.Text then
                                TweenService:Create(v, TweenInfo.new(0.2), {
                                    BackgroundTransparency = 0.2,
                                    TextTransparency = 0
                                }):Play()
                                if SelectedItems then
                                    TweenService:Create(SelectedItems, TweenInfo.new(0.2), {
                                        BackgroundTransparency = 0
                                    }):Play()
                                end
                            else
                                TweenService:Create(v, TweenInfo.new(0.2), {
                                    BackgroundTransparency = 0.8,
                                    TextTransparency = 0.2
                                }):Play()
                                if SelectedItems then
                                    TweenService:Create(SelectedItems, TweenInfo.new(0.2), {
                                        BackgroundTransparency = 1
                                    }):Play()
                                end
                            end
                        end
                    end
                    SelectItems.Text = "   " .. Item.Text
                    
                    -- Close dropdown after selection
                    isdropping = false
                    TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 50)
                    }):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = 0
                    }):Play()
                    wait(0.3)
                    DropdownFrameScroll.Visible = false
                end)
            end
            
            -- Enhanced Search functionality
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = SearchBox.Text:lower()
                for _, itemData in pairs(allItems) do
                    local item = itemData.item
                    local text = itemData.text:lower()
                    
                    if searchText == "" or text:find(searchText) then
                        item.Visible = true
                        TweenService:Create(item, TweenInfo.new(0.2), {
                            BackgroundTransparency = 0.8,
                            TextTransparency = 0.2
                        }):Play()
                    else
                        item.Visible = false
                    end
                end
            end)
            
            DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
            
            SelectItems.MouseButton1Click:Connect(function()
                if isdropping == false then
                    isdropping = true
                    DropdownFrameScroll.Visible = true
                    TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 150)
                    }):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 210)
                    }):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = 180
                    }):Play()
                    
                    -- Focus search box
                    wait(0.1)
                    SearchBox:CaptureFocus()
                else
                    isdropping = false
                    TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 50)
                    }):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = 0
                    }):Play()
                    wait(0.3)
                    DropdownFrameScroll.Visible = false
                    SearchBox.Text = ""
                end
            end)
            
            local dropfunc = {}
            
            function dropfunc:Add(t)
                local Item = Instance.new("TextButton")
                local ItemPadding = Instance.new("UIPadding")
                
                Item.Name = "Item"
                Item.Parent = DropScroll
                Item.BackgroundColor3 = _G.Primary
                Item.BackgroundTransparency = 0.8
                Item.Size = UDim2.new(1, 0, 0, 35)
                Item.Font = Enum.Font.GothamMedium
                Item.Text = tostring(t)
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 13
                Item.TextTransparency = 0.2
                Item.TextXAlignment = Enum.TextXAlignment.Left
                Item.ZIndex = 4
                Item.AutoButtonColor = false
                CreateRounded(Item, 8)
                CreateStroke(Item, _G.Border, 1)
                
                ItemPadding.Parent = Item
                ItemPadding.PaddingLeft = UDim.new(0, 12)
                
                local SelectedItems = Instance.new("Frame")
                SelectedItems.Name = "SelectedItems"
                SelectedItems.Parent = Item
                SelectedItems.BackgroundColor3 = _G.Third
                SelectedItems.BackgroundTransparency = 1
                SelectedItems.Size = UDim2.new(0, 4, 0.6, 0)
                SelectedItems.Position = UDim2.new(0, -12, 0.5, 0)
                SelectedItems.AnchorPoint = Vector2.new(0, 0.5)
                SelectedItems.ZIndex = 4
                CreateRounded(SelectedItems, 2)
                
                AddHoverEffect(Item, _G.Surface, _G.Primary)
                
                table.insert(allItems, {item = Item, text = tostring(t)})
                
                Item.MouseButton1Click:Connect(function()
                    callback(Item.Text)
                    activeItem = Item.Text
                    
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            local SelectedItems = v:FindFirstChild("SelectedItems")
                            if activeItem == v.Text then
                                TweenService:Create(v, TweenInfo.new(0.2), {
                                    BackgroundTransparency = 0.2,
                                    TextTransparency = 0
                                }):Play()
                                if SelectedItems then
                                    TweenService:Create(SelectedItems, TweenInfo.new(0.2), {
                                        BackgroundTransparency = 0
                                    }):Play()
                                end
                            else
                                TweenService:Create(v, TweenInfo.new(0.2), {
                                    BackgroundTransparency = 0.8,
                                    TextTransparency = 0.2
                                }):Play()
                                if SelectedItems then
                                    TweenService:Create(SelectedItems, TweenInfo.new(0.2), {
                                        BackgroundTransparency = 1
                                    }):Play()
                                end
                            end
                        end
                    end
                    SelectItems.Text = "   " .. Item.Text
                end)
            end
            
            function dropfunc:Clear()
                SelectItems.Text = "   Select Items"
                isdropping = false
                DropdownFrameScroll.Visible = false
                for i, v in next, DropScroll:GetChildren() do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end
                allItems = {}
                SearchBox.Text = ""
            end
            
            return dropfunc
        end
        
        -- Enhanced Slider Component
        function main:Slider(text, min, max, set, callback)
            local Slider = Instance.new("Frame")
            local sliderr = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ValueText = Instance.new("TextLabel")
            local bar = Instance.new("Frame")
            local bar1 = Instance.new("Frame")
            local circlebar = Instance.new("Frame")
            
            Slider.Name = "Slider"
            Slider.Parent = MainFramePage
            Slider.BackgroundTransparency = 1
            Slider.Size = UDim2.new(1, 0, 0, 50)
            
            sliderr.Name = "sliderr"
            sliderr.Parent = Slider
            sliderr.BackgroundColor3 = _G.Surface
            sliderr.BackgroundTransparency = 0
            sliderr.Position = UDim2.new(0, 0, 0, 0)
            sliderr.Size = UDim2.new(1, 0, 0, 50)
            CreateRounded(sliderr, 12)
            CreateStroke(sliderr, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(sliderr, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            Title.Parent = sliderr
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 20, 0.5, 0)
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = text
            Title.AnchorPoint = Vector2.new(0, 0.5)
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            ValueText.Parent = bar
            ValueText.BackgroundTransparency = 1
            ValueText.Position = UDim2.new(0, -50, 0.5, 0)
            ValueText.Size = UDim2.new(0, 40, 0, 30)
            ValueText.Font = Enum.Font.GothamBold
            ValueText.Text = set
            ValueText.AnchorPoint = Vector2.new(0, 0.5)
            ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueText.TextSize = 14
            ValueText.TextXAlignment = Enum.TextXAlignment.Right
            
            bar.Name = "bar"
            bar.Parent = sliderr
            bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            bar.Size = UDim2.new(0, 140, 0, 6)
            bar.Position = UDim2.new(1, -20, 0.5, 0)
            bar.BackgroundTransparency = 0
            bar.AnchorPoint = Vector2.new(1, 0.5)
            CreateRounded(bar, 3)
            CreateStroke(bar, _G.Border, 1)
            
            bar1.Name = "bar1"
            bar1.Parent = bar
            bar1.BackgroundColor3 = _G.Third
            bar1.BackgroundTransparency = 0
            bar1.Size = UDim2.new(set / max, 0, 1, 0)
            CreateRounded(bar1, 3)
            
            -- Add gradient to slider bar
            CreateGradient(bar1, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Third),
                ColorSequenceKeypoint.new(1, _G.Accent)
            }))
            
            circlebar.Name = "circlebar"
            circlebar.Parent = bar1
            circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circlebar.Position = UDim2.new(1, 0, 0.5, 0)
            circlebar.AnchorPoint = Vector2.new(0.5, 0.5)
            circlebar.Size = UDim2.new(0, 18, 0, 18)
            CreateRounded(circlebar, 10)
            CreateStroke(circlebar, _G.Border, 2)
            
            local Value = set
            if Value == nil then
                Value = set
                pcall(function()
                    callback(Value)
                end)
            end
            
            local Dragging = false
            
            -- Enhanced hover effects
            circlebar.MouseEnter:Connect(function()
                TweenService:Create(circlebar, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 22, 0, 22)
                }):Play()
            end)
            
            circlebar.MouseLeave:Connect(function()
                if not Dragging then
                    TweenService:Create(circlebar, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, 18, 0, 18)
                    }):Play()
                end
            end)
            
            circlebar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    TweenService:Create(circlebar, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 20, 0, 20)
                    }):Play()
                end
            end)
            
            bar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    TweenService:Create(circlebar, TweenInfo.new(0.1), {
                        Size = UDim2.new(0, 20, 0, 20)
                    }):Play()
                end
            end)
            
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                    TweenService:Create(circlebar, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, 18, 0, 18)
                    }):Play()
                end
            end)
            
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    local percentage = math.clamp((Input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    Value = math.floor(((tonumber(max) - tonumber(min)) * percentage) + tonumber(min))
                    
                    pcall(function()
                        callback(Value)
                    end)
                    
                    ValueText.Text = Value
                    TweenService:Create(bar1, TweenInfo.new(0.1), {
                        Size = UDim2.new(percentage, 0, 1, 0)
                    }):Play()
                end
            end)
        end
        
        -- Enhanced Textbox Component
        function main:Textbox(text, disappear, callback)
            local Textbox = Instance.new("Frame")
            local TextboxLabel = Instance.new("TextLabel")
            local RealTextbox = Instance.new("TextBox")
            
            Textbox.Name = "Textbox"
            Textbox.Parent = MainFramePage
            Textbox.BackgroundColor3 = _G.Surface
            Textbox.BackgroundTransparency = 0
            Textbox.Size = UDim2.new(1, 0, 0, 50)
            CreateRounded(Textbox, 12)
            CreateStroke(Textbox, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(Textbox, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Parent = Textbox
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 20, 0.5, 0)
            TextboxLabel.Text = text
            TextboxLabel.Size = UDim2.new(1, 0, 0, 35)
            TextboxLabel.Font = Enum.Font.GothamMedium
            TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 15
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            RealTextbox.Name = "RealTextbox"
            RealTextbox.Parent = Textbox
            RealTextbox.BackgroundColor3 = _G.Primary
            RealTextbox.BackgroundTransparency = 0
            RealTextbox.Position = UDim2.new(1, -15, 0.5, 0)
            RealTextbox.AnchorPoint = Vector2.new(1, 0.5)
            RealTextbox.Size = UDim2.new(0, 120, 0, 35)
            RealTextbox.Font = Enum.Font.GothamMedium
            RealTextbox.Text = ""
            RealTextbox.PlaceholderText = "Enter text..."
            RealTextbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
            RealTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            RealTextbox.TextSize = 13
            RealTextbox.ClipsDescendants = true
            CreateRounded(RealTextbox, 8)
            CreateStroke(RealTextbox, _G.Border, 1)
            
            -- Add padding to textbox
            local TextPadding = Instance.new("UIPadding")
            TextPadding.Parent = RealTextbox
            TextPadding.PaddingLeft = UDim.new(0, 12)
            TextPadding.PaddingRight = UDim.new(0, 12)
            
            AddHoverEffect(Textbox, _G.Primary, _G.Surface)
            AddHoverEffect(RealTextbox, _G.Surface, _G.Primary)
            
            -- Enhanced focus effects
            RealTextbox.Focused:Connect(function()
                TweenService:Create(RealTextbox:FindFirstChild("UIStroke"), TweenInfo.new(0.2), {
                    Color = _G.Third
                }):Play()
            end)
            
            RealTextbox.FocusLost:Connect(function()
                TweenService:Create(RealTextbox:FindFirstChild("UIStroke"), TweenInfo.new(0.2), {
                    Color = _G.Border
                }):Play()
                callback(RealTextbox.Text)
            end)
        end
        
        -- Enhanced Label Component
        function main:Label(text)
            local Frame = Instance.new("Frame")
            local Label = Instance.new("TextLabel")
            local labelfunc = {}
            
            Frame.Name = "Frame"
            Frame.Parent = MainFramePage
            Frame.BackgroundColor3 = _G.Surface
            Frame.BackgroundTransparency = 0
            Frame.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Frame, 12)
            CreateStroke(Frame, _G.Border, 1)
            
            -- Add gradient background
            CreateGradient(Frame, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 45)
            
            Label.Name = "Label"
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -50, 0, 30)
            Label.Font = Enum.Font.GothamMedium
            Label.Position = UDim2.new(0, 40, 0.5, 0)
            Label.AnchorPoint = Vector2.new(0, 0.5)
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 15
            Label.Text = text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Name = "ImageLabel"
            ImageLabel.Parent = Frame
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.new(0, 15, 0.5, 0)
            ImageLabel.Size = UDim2.new(0, 18, 0, 18)
            ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
            ImageLabel.Image = "rbxassetid://10723415903"
            ImageLabel.ImageColor3 = _G.Third
            
            function labelfunc:Set(newtext)
                Label.Text = newtext
                -- Add text change animation
                TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    TextTransparency = 0.3
                }):Play()
                wait(0.1)
                TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    TextTransparency = 0
                }):Play()
            end
            
            return labelfunc
        end
        
        -- Enhanced Separator Component
        function main:Seperator(text)
            local Seperator = Instance.new("Frame")
            local Sep1 = Instance.new("Frame")
            local Sep2 = Instance.new("TextLabel")
            local Sep3 = Instance.new("Frame")
            
            Seperator.Name = "Seperator"
            Seperator.Parent = MainFramePage
            Seperator.BackgroundTransparency = 1
            Seperator.Size = UDim2.new(1, 0, 0, 50)
            
            -- Enhanced Left Line
            Sep1.Name = "Sep1"
            Sep1.Parent = Seperator
            Sep1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sep1.BackgroundTransparency = 0
            Sep1.AnchorPoint = Vector2.new(0, 0.5)
            Sep1.Position = UDim2.new(0, 0, 0.5, 0)
            Sep1.Size = UDim2.new(0.3, 0, 0, 2)
            Sep1.BorderSizePixel = 0
            CreateRounded(Sep1, 1)
            
            local Grad1 = CreateGradient(Sep1, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.3, _G.Third),
                ColorSequenceKeypoint.new(0.7, _G.Third),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            }))
            
            -- Enhanced Center Text
            Sep2.Name = "Sep2"
            Sep2.Parent = Seperator
            Sep2.BackgroundColor3 = _G.Surface
            Sep2.BackgroundTransparency = 0
            Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
            Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
            Sep2.Size = UDim2.new(0, 200, 0, 30)
            Sep2.Font = Enum.Font.GothamBold
            Sep2.Text = text
            Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Sep2.TextSize = 16
            CreateRounded(Sep2, 15)
            CreateStroke(Sep2, _G.Border, 1)
            
            -- Add gradient to separator text background
            CreateGradient(Sep2, ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Surface),
                ColorSequenceKeypoint.new(1, _G.Primary)
            }), 90)
            
            -- Enhanced Right Line
            Sep3.Name = "Sep3"
            Sep3.Parent = Seperator
            Sep3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sep3.BackgroundTransparency = 0
            Sep3.AnchorPoint = Vector2.new(1, 0.5)
            Sep3.Position = UDim2.new(1, 0, 0.5, 0)
            Sep3.Size = UDim2.new(0.3, 0, 0, 2)
            Sep3.BorderSizePixel = 0
            CreateRounded(Sep3, 1)
            
            local Grad3 = CreateGradient(Sep3, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.3, _G.Third),
                ColorSequenceKeypoint.new(0.7, _G.Third),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            }))
        end
        
        -- Enhanced Line Component
        function main:Line()
            local Linee = Instance.new("Frame")
            local Line = Instance.new("Frame")
            
            Linee.Name = "Linee"
            Linee.Parent = MainFramePage
            Linee.BackgroundTransparency = 1
            Linee.Position = UDim2.new(0, 0, 0.119999997, 0)
            Linee.Size = UDim2.new(1, 0, 0, 25)
            
            Line.Name = "Line"
            Line.Parent = Linee
            Line.BackgroundColor3 = Color3.new(125, 125, 125)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.AnchorPoint = Vector2.new(0, 0.5)
            Line.Size = UDim2.new(1, 0, 0, 2)
            CreateRounded(Line, 1)
            
            local UIGradient = CreateGradient(Line, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.3, _G.Border),
                ColorSequenceKeypoint.new(0.7, _G.Border),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            }))
        end
        
        return main
    end
    
    return uitab
end

-- Create enhanced toggle button
CreateToggleButton()

return Update
