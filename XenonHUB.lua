-- Inisialisasi warna tema
_G.Primary = Color3.fromRGB(40, 40, 40) -- Abu-abu gelap
_G.Dark = Color3.fromRGB(20, 20, 20) -- Latar belakang gelap
_G.Third = Color3.fromRGB(0, 120, 255) -- Aksen biru neon

-- Fungsi untuk membuat sudut membulat
function CreateRounded(Parent, Size)
    local Rounded = Instance.new("UICorner")
    Rounded.Name = "Rounded"
    Rounded.Parent = Parent
    Rounded.CornerRadius = UDim.new(0, Size)
end

-- Fungsi untuk membuat elemen draggable
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = pos}):Play()
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

-- Inisialisasi ScreenGui utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "XenonUI"

-- Tombol Floating
local OutlineButton = Instance.new("Frame")
OutlineButton.Name = "OutlineButton"
OutlineButton.Parent = ScreenGui
OutlineButton.ClipsDescendants = true
OutlineButton.BackgroundColor3 = _G.Dark
OutlineButton.BackgroundTransparency = 0.2
OutlineButton.Position = UDim2.new(0, 10, 0, 10)
OutlineButton.Size = UDim2.new(0, 60, 0, 60)
CreateRounded(OutlineButton, 15)

local ImageButton = Instance.new("ImageButton")
ImageButton.Parent = OutlineButton
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundColor3 = _G.Dark
ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 0.3
ImageButton.Image = "rbxassetid://105059922903197" -- Ganti dengan ikon modern
ImageButton.AutoButtonColor = false
CreateRounded(ImageButton, 12)

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 1
ButtonStroke.Color = _G.Third
ButtonStroke.Transparency = 0.8
ButtonStroke.Parent = OutlineButton

MakeDraggable(ImageButton, OutlineButton)

ImageButton.MouseButton1Click:Connect(function()
    local xenon = game.CoreGui:FindFirstChild("Xenon")
    if xenon then
        xenon.Enabled = not xenon.Enabled
    end
end)

-- Efek hover untuk tombol
ImageButton.MouseEnter:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(ButtonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
        Transparency = 0.5
    }):Play()
end)

ImageButton.MouseLeave:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
        BackgroundTransparency = 0.2
    }):Play()
    TweenService:Create(ButtonStroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
        Transparency = 0.8
    }):Play()
end)

-- Notifikasi
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = game.CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function RemoveOldestNotification()
    if #NotificationList > 0 then
        local removed = table.remove(NotificationList, 1)
        TweenService:Create(removed[1], TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, -0.2, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.5)
        removed[1]:Destroy()
    end
end

spawn(function()
    while wait(3) do
        if #NotificationList > 0 then
            RemoveOldestNotification()
        end
    end
end)

-- Fungsi utama
local Update = {}

function Update:Notify(desc)
    local OutlineFrame = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local Shadow = Instance.new("Frame")
    local Image = Instance.new("ImageLabel")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")
    local UIStroke = Instance.new("UIStroke")

    OutlineFrame.Name = "OutlineFrame"
    OutlineFrame.Parent = NotificationFrame
    OutlineFrame.ClipsDescendants = true
    OutlineFrame.BackgroundColor3 = _G.Dark
    OutlineFrame.BackgroundTransparency = 0.3
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 1)
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
    OutlineFrame.Size = UDim2.new(0, 420, 0, 80)

    Shadow.Name = "Shadow"
    Shadow.Parent = OutlineFrame
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.ZIndex = -1
    CreateRounded(Shadow, 15)

    Frame.Name = "Frame"
    Frame.Parent = OutlineFrame
    Frame.ClipsDescendants = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = _G.Dark
    Frame.BackgroundTransparency = 0.1
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 400, 0, 60)

    UIStroke.Thickness = 1
    UIStroke.Color = _G.Third
    UIStroke.Transparency = 0.8
    UIStroke.Parent = Frame

    Image.Name = "Icon"
    Image.Parent = Frame
    Image.BackgroundTransparency = 1
    Image.Position = UDim2.new(0, 10, 0, 10)
    Image.Size = UDim2.new(0, 40, 0, 40)
    Image.Image = "rbxassetid://105059922903197"
    Image.ImageColor3 = _G.Third

    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 60, 0, 10)
    Title.Size = UDim2.new(0, 300, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Xenon"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Desc.Parent = Frame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 60, 0, 30)
    Desc.Size = UDim2.new(0, 300, 0, 20)
    Desc.Font = Enum.Font.Gotham
    Desc.Text = desc
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    CreateRounded(Frame, 12)
    CreateRounded(OutlineFrame, 15)

    -- Animasi masuk
    Frame.Position = UDim2.new(0.5, 0, 0.5, 30)
    Frame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 0.1
    }):Play()

    OutlineFrame:TweenPosition(UDim2.new(0.5, 0, 0.1 + (#NotificationList * 0.12), 0), "Out", "Sine", 0.5, true)
    table.insert(NotificationList, {OutlineFrame, Title})
end

function Update:StartLoad()
    local Loader = Instance.new("ScreenGui")
    Loader.Parent = game.CoreGui
    Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Loader.DisplayOrder = 1000

    local LoaderFrame = Instance.new("Frame")
    LoaderFrame.Name = "LoaderFrame"
    LoaderFrame.Parent = Loader
    LoaderFrame.BackgroundColor3 = _G.Dark
    LoaderFrame.BackgroundTransparency = 0
    LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoaderFrame.Size = UDim2.new(1, 0, 1, 0)

    local MainLoaderFrame = Instance.new("Frame")
    MainLoaderFrame.Name = "MainLoaderFrame"
    MainLoaderFrame.Parent = LoaderFrame
    MainLoaderFrame.ClipsDescendants = true
    MainLoaderFrame.BackgroundColor3 = _G.Dark
    MainLoaderFrame.BackgroundTransparency = 0
    MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainLoaderFrame.Size = UDim2.new(0, 300, 0, 200)
    CreateRounded(MainLoaderFrame, 15)

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    UIGradient.Parent = MainLoaderFrame

    local TitleLoader = Instance.new("TextLabel")
    TitleLoader.Parent = MainLoaderFrame
    TitleLoader.Text = "Xenon"
    TitleLoader.Font = Enum.Font.GothamBlack
    TitleLoader.TextSize = 40
    TitleLoader.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLoader.BackgroundTransparency = 1
    TitleLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    TitleLoader.Position = UDim2.new(0.5, 0, 0.3, 0)
    TitleLoader.Size = UDim2.new(0.8, 0, 0.3, 0)

    local DescriptionLoader = Instance.new("TextLabel")
    DescriptionLoader.Parent = MainLoaderFrame
    DescriptionLoader.Text = "Loading..."
    DescriptionLoader.Font = Enum.Font.Gotham
    DescriptionLoader.TextSize = 16
    DescriptionLoader.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescriptionLoader.BackgroundTransparency = 1
    DescriptionLoader.AnchorPoint = Vector2.new(0.5, 0.5)
    DescriptionLoader.Position = UDim2.new(0.5, 0, 0.5, 0)
    DescriptionLoader.Size = UDim2.new(0.8, 0, 0.2, 0)

    local LoadingBarBackground = Instance.new("Frame")
    LoadingBarBackground.Parent = MainLoaderFrame
    LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
    LoadingBarBackground.Size = UDim2.new(0.7, 0, 0.05, 0)
    CreateRounded(LoadingBarBackground, 20)

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Parent = LoadingBarBackground
    LoadingBar.BackgroundColor3 = _G.Third
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    CreateRounded(LoadingBar, 20)

    local barTweenInfoPart1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local barTweenPart1 = TweenService:Create(LoadingBar, barTweenInfoPart1, {
        Size = UDim2.new(0.25, 0, 1, 0)
    })
    local barTweenInfoPart2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local barTweenPart2 = TweenService:Create(LoadingBar, barTweenInfoPart2, {
        Size = UDim2.new(1, 0, 1, 0)
    })

    barTweenPart1:Play()

    function Update:Loaded()
        barTweenPart2:Play()
        barTweenPart2.Completed:Connect(function()
            wait(0.5)
            DescriptionLoader.Text = "Loaded!"
            wait(0.5)
            TweenService:Create(MainLoaderFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 1
            }):Play()
            wait(0.5)
            Loader:Destroy()
        end)
    end

    spawn(function()
        local dotCount = 0
        while Loader.Parent do
            dotCount = (dotCount + 1) % 4
            DescriptionLoader.Text = "Loading" .. string.rep(".", dotCount)
            wait(0.5)
        end
    end)
end

-- Pengaturan Konfigurasi
local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true
}

getgenv().LoadConfig = function()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("Xenon") then
            makefolder("Xenon")
        end
        if not isfolder("Xenon/Library/") then
            makefolder("Xenon/Library/")
        end
        if not isfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json") then
            writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", game:GetService("HttpService"):JSONEncode(SettingsLib))
        else
            local Decode = game:GetService("HttpService"):JSONDecode(readfile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json"))
            for i, v in pairs(Decode) do
                SettingsLib[i] = v
            end
        end
        Update:Notify("Library Loaded!")
    else
        Update:Notify("Undetected Executor")
    end
end

getgenv().SaveConfig = function()
    if readfile and writefile and isfile and isfolder then
        local Array = {}
        for i, v in pairs(SettingsLib) do
            Array[i] = v
        end
        writefile("Xenon/Library/" .. game.Players.LocalPlayer.Name .. ".json", game:GetService("HttpService"):JSONEncode(Array))
    else
        Update:Notify("Undetected Executor")
    end
end

getgenv().LoadConfig()

function Update:SaveSettings()
    return SettingsLib.SaveSettings
end

function Update:LoadAnimation()
    return SettingsLib.LoadAnimation
end

function Update:Window(Config)
    assert(Config.SubTitle, "SubTitle is required")
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 600, 0, 400),
        TabWidth = Config.TabWidth or 150
    }

    local Xenon = Instance.new("ScreenGui")
    Xenon.Name = "Xenon"
    Xenon.Parent = game.CoreGui
    Xenon.DisplayOrder = 999

    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.Parent = Xenon
    OutlineMain.ClipsDescendants = true
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.BackgroundColor3 = _G.Dark
    OutlineMain.BackgroundTransparency = 0.3
    OutlineMain.Position = UDim2.new(0.5, 0, 0.5, 0)
    OutlineMain.Size = UDim2.new(0, 0, 0, 0)

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    UIGradient.Parent = OutlineMain

    CreateRounded(OutlineMain, 15)

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = OutlineMain
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = _G.Dark
    Main.BackgroundTransparency = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = WindowConfig.Size
    CreateRounded(Main, 12)

    TweenService:Create(OutlineMain, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15)
    }):Play()

    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = _G.Dark
    Top.BackgroundTransparency = 0.8
    Top.Size = UDim2.new(1, 0, 0, 50)
    CreateRounded(Top, 8)

    local NameHub = Instance.new("TextLabel")
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 20, 0.5, 0)
    NameHub.AnchorPoint = Vector2.new(0, 0.5)
    NameHub.Size = UDim2.new(0, 200, 0, 30)
    NameHub.Font = Enum.Font.GothamBlack
    NameHub.Text = "Xenon"
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 22
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = NameHub
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 80, 0.5, 0)
    SubTitle.Size = UDim2.new(0, 200, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = Config.SubTitle
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubTitle.TextSize = 16
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.AnchorPoint = Vector2.new(0, 0.5)

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top
    CloseButton.BackgroundTransparency = 1
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Image = "rbxassetid://7743878857"
    CloseButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseButton, 5)
    CloseButton.MouseButton1Click:Connect(function()
        Xenon.Enabled = not Xenon.Enabled
    end)

    local ResizeButton = Instance.new("ImageButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Parent = Top
    ResizeButton.BackgroundTransparency = 1
    ResizeButton.AnchorPoint = Vector2.new(1, 0.5)
    ResizeButton.Position = UDim2.new(1, -50, 0.5, 0)
    ResizeButton.Size = UDim2.new(0, 24, 0, 24)
    ResizeButton.Image = "rbxassetid://10734886735"
    ResizeButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(ResizeButton, 5)

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = Top
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
    SettingsButton.Position = UDim2.new(1, -85, 0.5, 0)
    SettingsButton.Size = UDim2.new(0, 24, 0, 24)
    SettingsButton.Image = "rbxassetid://10734950020"
    SettingsButton.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(SettingsButton, 5)

    local BackgroundSettings = Instance.new("Frame")
    BackgroundSettings.Name = "BackgroundSettings"
    BackgroundSettings.Parent = OutlineMain
    BackgroundSettings.ClipsDescendants = true
    BackgroundSettings.Active = true
    BackgroundSettings.BackgroundColor3 = _G.Dark
    BackgroundSettings.BackgroundTransparency = 0.3
    BackgroundSettings.Position = UDim2.new(0, 0, 0, 0)
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSettings.Visible = false
    CreateRounded(BackgroundSettings, 15)

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = BackgroundSettings
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsFrame.BackgroundColor3 = _G.Dark
    SettingsFrame.BackgroundTransparency = 0
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsFrame.Size = UDim2.new(0.7, 0, 0.7, 0)
    CreateRounded(SettingsFrame, 12)

    local CloseSettings = Instance.new("ImageButton")
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundTransparency = 1
    CloseSettings.AnchorPoint = Vector2.new(1, 0)
    CloseSettings.Position = UDim2.new(1, -15, 0, 15)
    CloseSettings.Size = UDim2.new(0, 24, 0, 24)
    CloseSettings.Image = "rbxassetid://10747384394"
    CloseSettings.ImageColor3 = Color3.fromRGB(245, 245, 245)
    CreateRounded(CloseSettings, 5)
    CloseSettings.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = false
    end)

    SettingsButton.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = true
    end)

    local TitleSettings = Instance.new("TextLabel")
    TitleSettings.Name = "TitleSettings"
    TitleSettings.Parent = SettingsFrame
    TitleSettings.BackgroundTransparency = 1
    TitleSettings.Position = UDim2.new(0, 20, 0, 15)
    TitleSettings.Size = UDim2.new(1, 0, 0, 30)
    TitleSettings.Font = Enum.Font.GothamBold
    TitleSettings.Text = "Library Settings"
    TitleSettings.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleSettings.TextSize = 20
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left

    local SettingsMenuList = Instance.new("Frame")
    SettingsMenuList.Name = "SettingsMenuList"
    SettingsMenuList.Parent = SettingsFrame
    SettingsMenuList.BackgroundTransparency = 1
    SettingsMenuList.Position = UDim2.new(0, 0, 0, 50)
    SettingsMenuList.Size = UDim2.new(1, 0, 1, -70)

    local ScrollSettings = Instance.new("ScrollingFrame")
    ScrollSettings.Name = "ScrollSettings"
    ScrollSettings.Parent = SettingsMenuList
    ScrollSettings.Active = true
    ScrollSettings.BackgroundTransparency = 1
    ScrollSettings.Size = UDim2.new(1, 0, 1, 0)
    ScrollSettings.ScrollBarThickness = 3
    ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y

    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.Parent = ScrollSettings
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 10)

    local PaddingScroll = Instance.new("UIPadding")
    PaddingScroll.Parent = ScrollSettings
    PaddingScroll.PaddingLeft = UDim.new(0, 10)
    PaddingScroll.PaddingRight = UDim.new(0, 10)
    PaddingScroll.PaddingTop = UDim.new(0, 10)

    function CreateCheckbox(title, state, callback)
        local Background = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Checkbox = Instance.new("ImageButton")
        local UIStroke = Instance.new("UIStroke")

        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 30)

        Title.Parent = Background
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 50, 0.5, 0)
        Title.Size = UDim2.new(1, -50, 0, 20)
        Title.Font = Enum.Font.Gotham
        Title.Text = title
        Title.TextColor3 = Color3.fromRGB(200, 200, 200)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.AnchorPoint = Vector2.new(0, 0.5)

        Checkbox.Parent = Background
        Checkbox.BackgroundColor3 = state and _G.Third or Color3.fromRGB(100, 100, 100)
        Checkbox.BackgroundTransparency = 0.2
        Checkbox.AnchorPoint = Vector2.new(0, 0.5)
        Checkbox.Position = UDim2.new(0, 15, 0.5, 0)
        Checkbox.Size = UDim2.new(0, 24, 0, 24)
        Checkbox.Image = "rbxassetid://10709790644"
        Checkbox.ImageTransparency = state and 0 or 1
        Checkbox.ImageColor3 = Color3.fromRGB(255, 255, 255)
        CreateRounded(Checkbox, 6)

        UIStroke.Thickness = 1
        UIStroke.Color = _G.Third
        UIStroke.Transparency = 0.8
        UIStroke.Parent = Checkbox

        Checkbox.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                BackgroundColor3 = state and _G.Third or Color3.fromRGB(100, 100, 100),
                ImageTransparency = state and 0 or 1
            }):Play()
            pcall(callback, state)
        end)
    end

    function CreateButton(title, callback)
        local Background = Instance.new("Frame")
        local Button = Instance.new("TextButton")
        local UIStroke = Instance.new("UIStroke")

        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 40)

        Button.Parent = Background
        Button.BackgroundColor3 = _G.Third
        Button.BackgroundTransparency = 0.2
        Button.Size = UDim2.new(0.5, 0, 0, 30)
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.Font = Enum.Font.GothamBold
        Button.Text = title
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.AutoButtonColor = false
        CreateRounded(Button, 8)

        UIStroke.Thickness = 1
        UIStroke.Color = _G.Third
        UIStroke.Transparency = 0.8
        UIStroke.Parent = Button

        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0
            }):Play()
        end)

        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0.2
            }):Play()
        end)

        Button.MouseButton1Click:Connect(function()
            callback()
            TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0
            }):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0.2
            }):Play()
        end)
    end

    CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
        SettingsLib.SaveSettings = state
        getgenv().SaveConfig()
    end)

    CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state
        getgenv().SaveConfig()
    end)

    CreateButton("Reset Config", function()
        if isfolder("Xenon") then
            delfolder("Xenon")
        end
        Update:Notify("Config has been reset!")
    end)

    local Tab = Instance.new("Frame")
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.BackgroundTransparency = 1
    Tab.Position = UDim2.new(0, 10, 0, 50)
    Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, WindowConfig.Size.Y.Offset - 60)

    local ScrollTab = Instance.new("ScrollingFrame")
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = Tab
    ScrollTab.Active = true
    ScrollTab.BackgroundTransparency = HustleHub: https://www.hustlehub.com
    ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = ScrollTab
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local Page = Instance.new("Frame")
    Page.Name = "Page"
    Page.Parent = Main
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, WindowConfig.TabWidth + 20, 0, 50)
    Page.Size = UDim2.new(0, WindowConfig.Size.X.Offset - WindowConfig.TabWidth - 30, 0, WindowConfig.Size.Y.Offset - 60)

    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Parent = Page
    MainPage.BackgroundTransparency = 1
    MainPage.Size = UDim2.new(1, 0, 1, 0)

    local PageList = Instance.new("Folder")
    PageList.Name = "PageList"
    PageList.Parent = MainPage

    local UIPageLayout = Instance.new("UIPageLayout")
    UIPageLayout.Parent = PageList
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.EasingStyle = Enum.EasingStyle.Sine
    UIPageLayout.TweenTime = 0.3

    MakeDraggable(Top, OutlineMain)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            Xenon.Enabled = not Xenon.Enabled
        end
    end)

    local defaultSize = true
    ResizeButton.MouseButton1Click:Connect(function()
        if defaultSize then
            defaultSize = false
            OutlineMain:TweenSize(UDim2.new(1, -10, 1, -10), "Out", "Sine", 0.4, true)
            Main:TweenSize(UDim2.new(1, -25, 1, -25), "Out", "Sine", 0.4, true)
            Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 30, 0, Main.AbsoluteSize.Y - 60), "Out", "Sine", 0.4, true)
            Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - 60), "Out", "Sine", 0.4, true)
            ResizeButton.Image = "rbxassetid://10734895698"
        else
            defaultSize = true
            OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 15, 0, WindowConfig.Size.Y.Offset + 15), "Out", "Sine", 0.4, true)
            Main:TweenSize(WindowConfig.Size, "Out", "Sine", 0.4, true)
            Page:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset - WindowConfig.TabWidth - 30, 0, WindowConfig.Size.Y.Offset - 60), "Out", "Sine", 0.4, true)
            Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, WindowConfig.Size.Y.Offset - 60), "Out", "Sine", 0.4, true)
            ResizeButton.Image = "rbxassetid://10734886735"
        end
    end)

    local uitab = {}

    function uitab:Tab(text, img)
        local TabButton = Instance.new("TextButton")
        local Title = Instance.new("TextLabel")
        local Icon = Instance.new("ImageLabel")
        local SelectedTab = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")

        TabButton.Parent = ScrollTab
        TabButton.Name = text .. "Unique"
        TabButton.BackgroundColor3 = _G.Primary
        TabButton.BackgroundTransparency = 0.9
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        CreateRounded(TabButton, 8)

        local UIGradient = Instance.new("UIGradient")
        UIGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
        })
        UIGradient.Parent = TabButton

        SelectedTab.Name = "SelectedTab"
        SelectedTab.Parent = TabButton
        SelectedTab.BackgroundColor3 = _G.Third
        SelectedTab.Size = UDim2.new(0, 4, 0, 20)
        SelectedTab.Position = UDim2.new(0, 0, 0.5, 0)
        SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = SelectedTab

        Icon.Name = "Icon"
        Icon.Parent = TabButton
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0, 10, 0.5, 0)
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.Image = img
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Icon.ImageTransparency = 0.3

        Title.Parent = TabButton
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 40, 0.5, 0)
        Title.Size = UDim2.new(1, -50, 0, 20)
        Title.Font = Enum.Font.Gotham
        Title.Text = text
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextTransparency = 0.3
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.AnchorPoint = Vector2.new(0, 0.5)

        local MainFramePage = Instance.new("ScrollingFrame")
        MainFramePage.Name = text .. "_Page"
        MainFramePage.Parent = PageList
        MainFramePage.Active = true
        MainFramePage.BackgroundTransparency = 1
        MainFramePage.Size = UDim2.new(1, 0, 1, 0)
        MainFramePage.ScrollBarThickness = 3
        MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y

        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = MainFramePage
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = MainFramePage
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 10)

        TabButton.MouseButton1Click:Connect(function()
            for i, v in next, ScrollTab:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.9}):Play()
                    TweenService:Create(v.SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 4, 0, 20)}):Play()
                    TweenService:Create(v.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {ImageTransparency = 0.3}):Play()
                    TweenService:Create(v.Title, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 0.3}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 4, 0, 30)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {ImageTransparency = 0}):Play()
            TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
            UIPageLayout:JumpTo(MainFramePage)
        end)

        if not uitab[1] then
            uitab[1] = true
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7}):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 4, 0, 30)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {ImageTransparency = 0}):Play()
            TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
            UIPageLayout:JumpTo(MainFramePage)
        end

        game:GetService("RunService").Stepped:Connect(function()
            pcall(function()
                MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
                ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
                ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 20)
            end)
        end)

        local main = {}

        function main:Button(text, callback)
            local Button = Instance.new("Frame")
            local TextButton = Instance.new("TextButton")
            local TextLabel = Instance.new("TextLabel")
            local UIStroke = Instance.new("UIStroke")
            local UIGradient = Instance.new("UIGradient")

            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Primary
            Button.BackgroundTransparency = 0.9
            Button.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Button, 8)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
            })
            UIGradient.Parent = Button

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Button

            TextButton.Name = "TextButton"
            TextButton.Parent = Button
            TextButton.BackgroundColor3 = _G.Third
            TextButton.BackgroundTransparency = 0.2
            TextButton.Size = UDim2.new(0, 30, 0, 30)
            TextButton.Position = UDim2.new(1, -10, 0.5, 0)
            TextButton.AnchorPoint = Vector2.new(1, 0.5)
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            CreateRounded(TextButton, 6)

            TextLabel.Name = "TextLabel"
            TextLabel.Parent = Button
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
            TextLabel.Size = UDim2.new(1, -60, 1, 0)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 16
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)

            TextButton.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.7
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    Transparency = 0.5
                }):Play()
            end)

            TextButton.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.9
                }):Play()
                TweenService:Create(UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    Transparency = 0.8
                }):Play()
            end)

            TextButton.MouseButton1Click:Connect(function()
                callback()
                TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0
                }):Play()
                wait(0.1)
                TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.2
                }):Play()
            end)
        end

        function main:Toggle(text, config, desc, callback)
            local toggled = config or false
            local Button = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Desc = Instance.new("TextLabel")
            local ToggleFrame = Instance.new("Frame")
            local ToggleImage = Instance.new("TextButton")
            local Circle = Instance.new("Frame")
            local UIStroke = Instance.new("UIStroke")

            Button.Name = "Toggle"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = _G.Primary
            Button.BackgroundTransparency = 0.9
            Button.Size = desc and UDim2.new(1, 0, 0, 50) or UDim2.new(1, 0, 0, 40)
            CreateRounded(Button, 8)

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Button

            Title.Parent = Button
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, desc and 0.3 or 0.5, 0)
            Title.Size = UDim2.new(1, -60, 0, 20)
            Title.Font = Enum.Font.GothamBold
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 16
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.AnchorPoint = Vector2.new(0, desc and 0.3 or 0.5)

            if desc then
                Desc.Parent = Button
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 15, 0.7, 0)
                Desc.Size = UDim2.new(1, -60, 0, 16)
                Desc.Font = Enum.Font.Gotham
                Desc.Text = desc
                Desc.TextColor3 = Color3.fromRGB(150, 150, 150)
                Desc.TextSize = 12
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.AnchorPoint = Vector2.new(0, 0.7)
            end

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Button
            ToggleFrame.BackgroundColor3 = _G.Dark
            ToggleFrame.BackgroundTransparency = 0.2
            ToggleFrame.Position = UDim2.new(1, -10, 0.5, 0)
            ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
            ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
            CreateRounded(ToggleFrame, 10)

            ToggleImage.Name = "ToggleImage"
            ToggleImage.Parent = ToggleFrame
            ToggleImage.BackgroundColor3 = toggled and _G.Third or Color3.fromRGB(100, 100, 100)
            ToggleImage.BackgroundTransparency = 0
            ToggleImage.Size = UDim2.new(1, 0, 1, 0)
            ToggleImage.Text = ""
            ToggleImage.AutoButtonColor = false
            CreateRounded(ToggleImage, 10)

            Circle.Name = "Circle"
            Circle.Parent = ToggleImage
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(toggled and 0.5 or 0, toggled and 17 or 4, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.AnchorPoint = Vector2.new(toggled and 0.5 or 0, 0.5)
            CreateRounded(Circle, 10)

            ToggleImage.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    Position = UDim2.new(toggled and 0.5 or 0, toggled and 17 or 4, 0.5, 0)
                }):Play()
                TweenService:Create(ToggleImage, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                    BackgroundColor3 = toggled and _G.Third or Color3.fromRGB(100, 100, 100)
                }):Play()
                pcall(callback, toggled)
            end)
        end

        function main:Dropdown(text, option, var, callback)
            local isdropping = false
            local Dropdown = Instance.new("Frame")
            local DropTitle = Instance.new("TextLabel")
            local SelectItems = Instance.new("TextButton")
            local DropScroll = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")
            local ArrowDown = Instance.new("ImageLabel")
            local UIStroke = Instance.new("UIStroke")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = MainFramePage
            Dropdown.BackgroundColor3 = _G.Primary
            Dropdown.BackgroundTransparency = 0.9
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Dropdown, 8)

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Dropdown

            DropTitle.Name = "DropTitle"
            DropTitle.Parent = Dropdown
            DropTitle.BackgroundTransparency = 1
            DropTitle.Position = UDim2.new(0, 15, 0.5, 0)
            DropTitle.Size = UDim2.new(1, -120, 0, 20)
            DropTitle.Font = Enum.Font.GothamBold
            DropTitle.Text = text
            DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropTitle.TextSize = 16
            DropTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropTitle.AnchorPoint = Vector2.new(0, 0.5)

            SelectItems.Name = "SelectItems"
            SelectItems.Parent = Dropdown
            SelectItems.BackgroundColor3 = _G.Dark
            SelectItems.BackgroundTransparency = 0.2
            SelectItems.Position = UDim2.new(1, -10, 0.5, 0)
            SelectItems.Size = UDim2.new(0, 100, 0, 30)
            SelectItems.AnchorPoint = Vector2.new(1, 0.5)
            SelectItems.Font = Enum.Font.Gotham
            SelectItems.Text = var and "   " .. var or "   Select"
            SelectItems.TextColor3 = Color3.fromRGB(255, 255, 255)
            SelectItems.TextSize = 12
            SelectItems.TextXAlignment = Enum.TextXAlignment.Left
            SelectItems.AutoButtonColor = false
            CreateRounded(SelectItems, 6)

            ArrowDown.Name = "ArrowDown"
            ArrowDown.Parent = SelectItems
            ArrowDown.BackgroundTransparency = 1
            ArrowDown.Position = UDim2.new(1, -20, 0.5, 0)
            ArrowDown.Size = UDim2.new(0, 15, 0, 15)
            ArrowDown.AnchorPoint = Vector2.new(1, 0.5)
            ArrowDown.Image = "rbxassetid://10709790948"
            ArrowDown.ImageColor3 = Color3.fromRGB(255, 255, 255)

            DropScroll.Name = "DropScroll"
            DropScroll.Parent = Dropdown
            DropScroll.BackgroundTransparency = 1
            DropScroll.Position = UDim2.new(0, 0, 0, 45)
            DropScroll.Size = UDim2.new(1, 0, 0, 0)
            DropScroll.Visible = false
            DropScroll.ScrollBarThickness = 3
            DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y

            UIListLayout.Parent = DropScroll
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            UIPadding.Parent = DropScroll
            UIPadding.PaddingLeft = UDim.new(0, 10)
            UIPadding.PaddingRight = UDim.new(0, 10)
            UIPadding.PaddingTop = UDim.new(0, 10)

            for i, v in next, option do
                local Item = Instance.new("TextButton")
                local ItemStroke = Instance.new("UIStroke")
                Item.Name = "Item"
                Item.Parent = DropScroll
                Item.BackgroundColor3 = _G.Dark
                Item.BackgroundTransparency = 1
                Item.Size = UDim2.new(1, -10, 0, 30)
                Item.Font = Enum.Font.Gotham
                Item.Text = tostring(v)
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14
                Item.TextTransparency = var == v and 0 or 0.5
                Item.TextXAlignment = Enum.TextXAlignment.Left
                CreateRounded(Item, 6)

                ItemStroke.Thickness = 1
                ItemStroke.Color = _G.Third
                ItemStroke.Transparency = var == v and 0.5 or 1
                ItemStroke.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    SelectItems.Text = "   " .. Item.Text
                    callback(Item.Text)
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                                TextTransparency = 0.5,
                                BackgroundTransparency = 1
                            }):Play()
                            local stroke = v:FindFirstChildOfClass("UIStroke")
                            if stroke then
                                stroke.Transparency = 1
                            end
                        end
                    end
                    TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        TextTransparency = 0,
                        BackgroundTransparency = 0.8
                    }):Play()
                    ItemStroke.Transparency = 0.5
                end)
            end

            SelectItems.MouseButton1Click:Connect(function()
                isdropping = not isdropping
                if isdropping then
                    TweenService:Create(DropScroll, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Size = UDim2.new(1, 0, 0, 100),
                        Visible = true
                    }):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Size = UDim2.new(1, 0, 0, 150)
                    }):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Rotation = 180
                    }):Play()
                else
                    TweenService:Create(DropScroll, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Size = UDim2.new(1, 0, 0, 0),
                        Visible = false
                    }):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                        Rotation = 0
                    }):Play()
                end
            end)

            local dropfunc = {}

            function dropfunc:Add(t)
                local Item = Instance.new("TextButton")
                local ItemStroke = Instance.new("UIStroke")
                Item.Name = "Item"
                Item.Parent = DropScroll
                Item.BackgroundColor3 = _G.Dark
                Item.BackgroundTransparency = 1
                Item.Size = UDim2.new(1, -10, 0, 30)
                Item.Font = Enum.Font.Gotham
                Item.Text = tostring(t)
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14
                Item.TextTransparency = 0.5
                Item.TextXAlignment = Enum.TextXAlignment.Left
                CreateRounded(Item, 6)

                ItemStroke.Thickness = 1
                ItemStroke.Color = _G.Third
                ItemStroke.Transparency = 1
                ItemStroke.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    SelectItems.Text = "   " .. Item.Text
                    callback(Item.Text)
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            TweenService:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                                TextTransparency = 0.5,
                                BackgroundTransparency = 1
                            }):Play()
                            local stroke = v:FindFirstChildOfClass("UIStroke")
                            if stroke then
                                stroke.Transparency = 1
                            end
                        end
                    end
                    TweenService:Create(Item, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        TextTransparency = 0,
                        BackgroundTransparency = 0.8
                    }):Play()
                    ItemStroke.Transparency = 0.5
                end)
            end

            function dropfunc:Clear()
                SelectItems.Text = "   Select"
                isdropping = false
                DropScroll.Size = UDim2.new(1, 0, 0, 0)
                DropScroll.Visible = false
                for i, v in next, DropScroll:GetChildren() do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end
            end

            return dropfunc
        end

        function main:Slider(text, min, max, set, callback)
            local Slider = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Bar = Instance.new("Frame")
            local Bar1 = Instance.new("Frame")
            local Circle = Instance.new("Frame")
            local ValueText = Instance.new("TextLabel")
            local UIStroke = Instance.new("UIStroke")

            Slider.Name = "Slider"
            Slider.Parent = MainFramePage
            Slider.BackgroundColor3 = _G.Primary
            Slider.BackgroundTransparency = 0.9
            Slider.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Slider, 8)

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Slider

            Title.Name = "Title"
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 15, 0.5, 0)
            Title.Size = UDim2.new(1, -150, 0, 20)
            Title.Font = Enum.Font.GothamBold
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 16
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.AnchorPoint = Vector2.new(0, 0.5)

            Bar.Name = "Bar"
            Bar.Parent = Slider
            Bar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            Bar.BackgroundTransparency = 0.5
            Bar.Size = UDim2.new(0, 120, 0, 4)
            Bar.Position = UDim2.new(1, -10, 0.5, 0)
            Bar.AnchorPoint = Vector2.new(1, 0.5)
            CreateRounded(Bar, 5)

            Bar1.Name = "Bar1"
            Bar1.Parent = Bar
            Bar1.BackgroundColor3 = _G.Third
            Bar1.Size = UDim2.new((set - min) / (max - min), 0, 1, 0)
            CreateRounded(Bar1, 5)

            Circle.Name = "Circle"
            Circle.Parent = Bar1
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(1, 0, 0.5, 0)
            Circle.Size = UDim2.new(0, 10, 0, 10)
            Circle.AnchorPoint = Vector2.new(0.5, 0.5)
            CreateRounded(Circle, 5)

            ValueText.Name = "ValueText"
            ValueText.Parent = Slider
            ValueText.BackgroundTransparency = 1
            ValueText.Position = UDim2.new(1, -140, 0.5, 0)
 Secular
            ValueText.Size = UDim2.new(0, 30, 0, 20)
            ValueText.Font = Enum.Font.Gotham
            ValueText.Text = tostring(set)
            ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueText.TextSize = 12
            ValueText.TextXAlignment = Enum.TextXAlignment.Right
            ValueText.AnchorPoint = Vector2.new(1, 0.5)

            local mouse = game.Players.LocalPlayer:GetMouse()
            local Dragging = false

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local value = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1) * (max - min) + min
                    value = math.floor(value)
                    Bar1.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    Circle.Position = UDim2.new(1, 0, 0.5, 0)
                    ValueText.Text = tostring(value)
                    pcall(callback, value)
                end
            end)
        end

        function main:Textbox(text, disappear, callback)
            local Textbox = Instance.new("Frame")
            local TextboxLabel = Instance.new("TextLabel")
            local RealTextbox = Instance.new("TextBox")
            local UIStroke = Instance.new("UIStroke")

            Textbox.Name = "Textbox"
            Textbox.Parent = MainFramePage
            Textbox.BackgroundColor3 = _G.Primary
            Textbox.BackgroundTransparency = 0.9
            Textbox.Size = UDim2.new(1, 0, 0, 40)
            CreateRounded(Textbox, 8)

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Textbox

            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Parent = Textbox
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0)
            TextboxLabel.Size = UDim2.new(1, -100, 0, 20)
            TextboxLabel.Font = Enum.Font.GothamBold
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 16
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)

            RealTextbox.Name = "RealTextbox"
            RealTextbox.Parent = Textbox
            RealTextbox.BackgroundColor3 = _G.Dark
            RealTextbox.BackgroundTransparency = 0.2
            RealTextbox.Position = UDim2.new(1, -10, 0.5, 0)
            RealTextbox.Size = UDim2.new(0, 80, 0, 30)
            RealTextbox.AnchorPoint = Vector2.new(1, 0.5)
            RealTextbox.Font = Enum.Font.Gotham
            RealTextbox.Text = ""
            RealTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            RealTextbox.TextSize = 14
            CreateRounded(RealTextbox, 6)

            RealTextbox.FocusLost:Connect(function()
                if disappear then
                    RealTextbox.Text = ""
                end
                callback(RealTextbox.Text)
            end)
        end

        function main:Label(text)
            local Frame = Instance.new("Frame")
            local Label = Instance.new("TextLabel")
            local UIStroke = Instance.new("UIStroke")

            Frame.Name = "Label"
            Frame.Parent = MainFramePage
            Frame.BackgroundColor3 = _G.Primary
            Frame.BackgroundTransparency = 0.9
            Frame.Size = UDim2.new(1, 0, 0, 30)
            CreateRounded(Frame, 8)

            UIStroke.Thickness = 1
            UIStroke.Color = _G.Third
            UIStroke.Transparency = 0.8
            UIStroke.Parent = Frame

            Label.Name = "Label"
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0.5, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.AnchorPoint = Vector2.new(0, 0.5)

            local labelfunc = {}
            function labelfunc:Set(newtext)
                Label.Text = newtext
            end
            return labelfunc
        end

        function main:Seperator(text)
            local Seperator = Instance.new("Frame")
            local Sep1 = Instance.new("Frame")
            local Sep2 = Instance.new("TextLabel")
            local Sep3 = Instance.new("Frame")

            Seperator.Name = "Seperator"
            Seperator.Parent = MainFramePage
            Seperator.BackgroundTransparency = 1
            Seperator.Size = UDim2.new(1, 0, 0, 36)

            Sep1.Name = "Sep1"
            Sep1.Parent = Seperator
            Sep1.BackgroundColor3 = _G.Third
            Sep1.BackgroundTransparency = 0.5
            Sep1.AnchorPoint = Vector2.new(0, 0.5)
            Sep1.Position = UDim2.new(0, 0, 0.5, 0)
            Sep1.Size = UDim2.new(0.3, 0, 0, 2)
            CreateRounded(Sep1, 2)

            Sep2.Name = "Sep2"
            Sep2.Parent = Seperator
            Sep2.BackgroundTransparency = 1
            Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
            Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
            Sep2.Size = UDim2.new(0.4, 0, 0, 20)
            Sep2.Font = Enum.Font.GothamBold
            Sep2.Text = text
            Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Sep2.TextSize = 14

            Sep3.Name = "Sep3"
            Sep3.Parent = Seperator
            Sep3.BackgroundColor3 = _G.Third
            Sep3.BackgroundTransparency = 0.5
            Sep3.AnchorPoint = Vector2.new(1, 0.5)
            Sep3.Position = UDim2.new(1, 0, 0.5, 0)
            Sep3.Size = UDim2.new(0.3, 0, 0, 2)
            CreateRounded(Sep3, 2)
        end

        function main:Line()
            local Linee = Instance.new("Frame")
            local Line = Instance.new("Frame")
            local UIGradient = Instance.new("UIGradient")

            Linee.Name = "Linee"
            Linee.Parent = MainFramePage
            Linee.BackgroundTransparency = 1
            Linee.Size = UDim2.new(1, 0, 0, 20)

            Line.Name = "Line"
            Line.Parent = Linee
            Line.BackgroundColor3 = _G.Third
            Line.BackgroundTransparency = 0.5
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.Size = UDim2.new(1, 0, 0, 2)
            CreateRounded(Line, 2)

            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Dark),
                ColorSequenceKeypoint.new(0.5, _G.Third),
                ColorSequenceKeypoint.new(1, _G.Dark)
            })
            UIGradient.Parent = Line
        end

        return main
    end

    return uitab
end

return Update
