-- Xenhub.lua - Modern UI Library
-- Improved version with better design, animations, and code structure

-- Cleanup existing instances
if game:GetService("CoreGui"):FindFirstChild("Xenon") and game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
    game:GetService("CoreGui").Xenon:Destroy()
    game:GetService("CoreGui").ScreenGui:Destroy()
end

-- Modern Color Palette
_G.Colors = {
    Primary = Color3.fromRGB(88, 101, 242),      -- Modern purple
    Secondary = Color3.fromRGB(99, 102, 241),    -- Lighter purple
    Background = Color3.fromRGB(17, 24, 39),     -- Dark background
    Surface = Color3.fromRGB(31, 41, 55),        -- Card background
    SurfaceLight = Color3.fromRGB(55, 65, 81),   -- Lighter surface
    Text = Color3.fromRGB(243, 244, 246),        -- Primary text
    TextSecondary = Color3.fromRGB(156, 163, 175), -- Secondary text
    Success = Color3.fromRGB(34, 197, 94),       -- Green
    Warning = Color3.fromRGB(251, 191, 36),      -- Yellow
    Error = Color3.fromRGB(239, 68, 68),         -- Red
    Border = Color3.fromRGB(75, 85, 99),         -- Border color
    Accent = Color3.fromRGB(168, 85, 247)        -- Accent purple
}

-- Legacy support
_G.Primary = _G.Colors.SurfaceLight
_G.Dark = _G.Colors.Background
_G.Third = _G.Colors.Primary

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

-- Utility Functions
local Utils = {}

function Utils.CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Name = "Corner"
    corner.Parent = parent
    corner.CornerRadius = UDim.new(0, radius or 8)
    return corner
end

function Utils.CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Stroke"
    stroke.Parent = parent
    stroke.Color = color or _G.Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.3
    return stroke
end

function Utils.CreateGradient(parent, colors, direction)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = parent
    if colors then
        gradient.Color = colors
    end
    if direction then
        gradient.Rotation = direction
    end
    return gradient
end

function Utils.CreateShadow(parent)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = parent.Parent
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.Position = UDim2.new(0, 2, 0, 2)
    shadow.Size = parent.Size
    shadow.ZIndex = parent.ZIndex - 1
    Utils.CreateCorner(shadow, 12)
    return shadow
end

function Utils.Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utils.MakeDraggable(dragHandle, object)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        Utils.Tween(object, {Position = newPos}, 0.1)
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                update(input)
            end
        end
    end)
end

-- Notification System
local NotificationManager = {}
NotificationManager.notifications = {}
NotificationManager.maxNotifications = 5

function NotificationManager:Create(title, description, duration, notificationType)
    -- Remove oldest if at max capacity
    if #self.notifications >= self.maxNotifications then
        self:Remove(self.notifications[1])
    end
    
    local notificationFrame = Instance.new("ScreenGui")
    notificationFrame.Name = "XenonNotification"
    notificationFrame.Parent = game.CoreGui
    notificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = notificationFrame
    container.BackgroundColor3 = _G.Colors.Surface
    container.BackgroundTransparency = 0.1
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, 20, 0, 20 + (#self.notifications * 80))
    container.Size = UDim2.new(0, 350, 0, 70)
    
    Utils.CreateCorner(container, 12)
    Utils.CreateStroke(container, _G.Colors.Border, 1)
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Parent = container
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Image = "rbxassetid://105059922903197"
    icon.ImageColor3 = _G.Colors.Primary
    Utils.CreateCorner(icon, 8)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = container
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 65, 0, 12)
    titleLabel.Size = UDim2.new(1, -80, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title or "Xenon"
    titleLabel.TextColor3 = _G.Colors.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Parent = container
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 65, 0, 35)
    descLabel.Size = UDim2.new(1, -80, 0, 20)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description or ""
    descLabel.TextColor3 = _G.Colors.TextSecondary
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Color indicator based on type
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = container
    indicator.BackgroundColor3 = _G.Colors.Primary
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Size = UDim2.new(0, 4, 1, 0)
    Utils.CreateCorner(indicator, 2)
    
    if notificationType == "success" then
        indicator.BackgroundColor3 = _G.Colors.Success
    elseif notificationType == "warning" then
        indicator.BackgroundColor3 = _G.Colors.Warning
    elseif notificationType == "error" then
        indicator.BackgroundColor3 = _G.Colors.Error
    end
    
    -- Slide in animation
    container.Position = UDim2.new(1, 20, 0, 20 + (#self.notifications * 80))
    Utils.Tween(container, {Position = UDim2.new(1, -20, 0, 20 + (#self.notifications * 80))}, 0.5, Enum.EasingStyle.Back)
    
    -- Add to notifications list
    table.insert(self.notifications, {container = container, gui = notificationFrame})
    
    -- Auto remove after duration
    spawn(function()
        wait(duration or 3)
        self:Remove({container = container, gui = notificationFrame})
    end)
    
    return {container = container, gui = notificationFrame}
end

function NotificationManager:Remove(notification)
    if not notification then return end
    
    -- Find and remove from list
    for i, notif in ipairs(self.notifications) do
        if notif == notification then
            table.remove(self.notifications, i)
            break
        end
    end
    
    -- Slide out animation
    Utils.Tween(notification.container, {
        Position = UDim2.new(1, 20, notification.container.Position.Y.Scale, notification.container.Position.Y.Offset)
    }, 0.3)
    
    -- Destroy after animation
    spawn(function()
        wait(0.3)
        if notification.gui then
            notification.gui:Destroy()
        end
    end)
    
    -- Reposition remaining notifications
    for i, notif in ipairs(self.notifications) do
        Utils.Tween(notif.container, {
            Position = UDim2.new(1, -20, 0, 20 + ((i-1) * 80))
        }, 0.3)
    end
end

-- Loading Screen
local LoadingScreen = {}

function LoadingScreen:Show()
    local loader = Instance.new("ScreenGui")
    loader.Name = "XenonLoader"
    loader.Parent = game.CoreGui
    loader.ZIndexBehavior = Enum.ZIndexBehavior.Global
    loader.DisplayOrder = 1000
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Parent = loader
    background.BackgroundColor3 = _G.Colors.Background
    background.Size = UDim2.new(1, 0, 1, 0)
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = background
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.Size = UDim2.new(0, 300, 0, 150)
    
    -- Logo/Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = container
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0.5, 0)
    title.Position = UDim2.new(0.5, 0, 0, 0)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Font = Enum.Font.GothamBold
    title.Text = "XENON"
    title.TextColor3 = _G.Colors.Text
    title.TextSize = 32
    title.TextTransparency = 0
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Parent = container
    subtitle.BackgroundTransparency = 1
    subtitle.AnchorPoint = Vector2.new(0.5, 0)
    subtitle.Position = UDim2.new(0.5, 0, 0, 50)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Modern UI Library"
    title.TextColor3 = _G.Colors.TextSecondary
    subtitle.TextSize = 14
    
    -- Loading bar background
    local barBg = Instance.new("Frame")
    barBg.Name = "BarBackground"
    barBg.Parent = container
    barBg.BackgroundColor3 = _G.Colors.Surface
    barBg.AnchorPoint = Vector2.new(0.5, 0)
    barBg.Position = UDim2.new(0.5, 0, 0, 90)
    barBg.Size = UDim2.new(0.8, 0, 0, 6)
    Utils.CreateCorner(barBg, 3)
    
    -- Loading bar
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Parent = barBg
    bar.BackgroundColor3 = _G.Colors.Primary
    bar.Size = UDim2.new(0, 0, 1, 0)
    Utils.CreateCorner(bar, 3)
    
    -- Loading text
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Parent = container
    loadingText.BackgroundTransparency = 1
    loadingText.AnchorPoint = Vector2.new(0.5, 0)
    loadingText.Position = UDim2.new(0.5, 0, 0, 110)
    loadingText.Size = UDim2.new(1, 0, 0, 20)
    loadingText.Font = Enum.Font.Gotham
    loadingText.Text = "Loading..."
    loadingText.TextColor3 = _G.Colors.TextSecondary
    loadingText.TextSize = 12
    
    -- Animate loading bar
    local loadTween = Utils.Tween(bar, {Size = UDim2.new(1, 0, 1, 0)}, 2, Enum.EasingStyle.Quad)
    
    -- Animate loading text
    spawn(function()
        local dots = 0
        while loader.Parent do
            dots = (dots + 1) % 4
            loadingText.Text = "Loading" .. string.rep(".", dots)
            wait(0.5)
        end
    end)
    
    self.loader = loader
    self.loadTween = loadTween
    
    return self
end

function LoadingScreen:Complete()
    if self.loader then
        Utils.Tween(self.loader.Background, {BackgroundTransparency = 1}, 0.5)
        spawn(function()
            wait(0.5)
            self.loader:Destroy()
        end)
    end
end

-- Settings Manager
local SettingsManager = {}
SettingsManager.settings = {
    SaveSettings = true,
    LoadAnimation = true,
    Theme = "Dark"
}

function SettingsManager:Load()
    if readfile and writefile and isfile and isfolder then
        if not isfolder("Xenon") then
            makefolder("Xenon")
        end
        if not isfolder("Xenon/Settings/") then
            makefolder("Xenon/Settings/")
        end
        
        local settingsPath = "Xenon/Settings/" .. game.Players.LocalPlayer.Name .. ".json"
        if not isfile(settingsPath) then
            writefile(settingsPath, HttpService:JSONEncode(self.settings))
        else
            local success, decoded = pcall(function()
                return HttpService:JSONDecode(readfile(settingsPath))
            end)
            if success then
                for key, value in pairs(decoded) do
                    self.settings[key] = value
                end
            end
        end
    end
end

function SettingsManager:Save()
    if readfile and writefile and isfile and isfolder then
        local settingsPath = "Xenon/Settings/" .. game.Players.LocalPlayer.Name .. ".json"
        writefile(settingsPath, HttpService:JSONEncode(self.settings))
    end
end

function SettingsManager:Get(key)
    return self.settings[key]
end

function SettingsManager:Set(key, value)
    self.settings[key] = value
    self:Save()
end

-- Initialize settings
SettingsManager:Load()

-- Toggle Button (Floating Action Button)
local function CreateToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "XenonToggle"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local button = Instance.new("Frame")
    button.Name = "ToggleButton"
    button.Parent = screenGui
    button.BackgroundColor3 = _G.Colors.Primary
    button.Position = UDim2.new(0, 20, 0, 20)
    button.Size = UDim2.new(0, 56, 0, 56)
    Utils.CreateCorner(button, 28)
    Utils.CreateShadow(button)
    
    local imageButton = Instance.new("ImageButton")
    imageButton.Parent = button
    imageButton.BackgroundTransparency = 1
    imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
    imageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    imageButton.Size = UDim2.new(0, 32, 0, 32)
    imageButton.Image = "rbxassetid://105059922903197"
    imageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    imageButton.AutoButtonColor = false
    
    -- Hover effects
    imageButton.MouseEnter:Connect(function()
        Utils.Tween(button, {Size = UDim2.new(0, 60, 0, 60)}, 0.2)
        Utils.Tween(button, {BackgroundColor3 = _G.Colors.Secondary}, 0.2)
    end)
    
    imageButton.MouseLeave:Connect(function()
        Utils.Tween(button, {Size = UDim2.new(0, 56, 0, 56)}, 0.2)
        Utils.Tween(button, {BackgroundColor3 = _G.Colors.Primary}, 0.2)
    end)
    
    -- Click animation
    imageButton.MouseButton1Down:Connect(function()
        Utils.Tween(button, {Size = UDim2.new(0, 52, 0, 52)}, 0.1)
    end)
    
    imageButton.MouseButton1Up:Connect(function()
        Utils.Tween(button, {Size = UDim2.new(0, 56, 0, 56)}, 0.1)
    end)
    
    -- Toggle functionality
    imageButton.MouseButton1Click:Connect(function()
        local xenonGui = game.CoreGui:FindFirstChild("Xenon")
        if xenonGui then
            xenonGui.Enabled = not xenonGui.Enabled
        end
    end)
    
    Utils.MakeDraggable(imageButton, button)
    
    return screenGui
end

-- Main Library
local XenonLib = {}

function XenonLib:Notify(title, description, duration, notificationType)
    return NotificationManager:Create(title, description, duration, notificationType)
end

function XenonLib:StartLoad()
    return LoadingScreen:Show()
end

function XenonLib:Loaded()
    LoadingScreen:Complete()
end

function XenonLib:SaveSettings()
    return SettingsManager:Get("SaveSettings")
end

function XenonLib:LoadAnimation()
    return SettingsManager:Get("LoadAnimation")
end

function XenonLib:Window(config)
    assert(config and config.SubTitle, "Window config with SubTitle is required")
    
    local windowConfig = {
        Size = config.Size or UDim2.new(0, 600, 0, 400),
        TabWidth = config.TabWidth or 180,
        Title = config.Title or "Xenon",
        SubTitle = config.SubTitle
    }
    
    -- Create toggle button
    CreateToggleButton()
    
    -- Main GUI
    local xenonGui = Instance.new("ScreenGui")
    xenonGui.Name = "Xenon"
    xenonGui.Parent = game.CoreGui
    xenonGui.DisplayOrder = 999
    xenonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main container with shadow
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Parent = xenonGui
    mainContainer.BackgroundColor3 = _G.Colors.Background
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.Size = UDim2.new(0, 0, 0, 0)
    Utils.CreateCorner(mainContainer, 16)
    Utils.CreateShadow(mainContainer)
    
    -- Animate window opening
    Utils.Tween(mainContainer, {Size = windowConfig.Size}, 0.5, Enum.EasingStyle.Back)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainContainer
    titleBar.BackgroundColor3 = _G.Colors.Surface
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    Utils.CreateCorner(titleBar, 16)
    
    -- Title bar bottom border
    local titleBorder = Instance.new("Frame")
    titleBorder.Name = "TitleBorder"
    titleBorder.Parent = titleBar
    titleBorder.BackgroundColor3 = _G.Colors.Border
    titleBorder.BackgroundTransparency = 0.7
    titleBorder.Position = UDim2.new(0, 0, 1, -1)
    titleBorder.Size = UDim2.new(1, 0, 0, 1)
    
    -- Window title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = titleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = windowConfig.Title
    titleLabel.TextColor3 = _G.Colors.Text
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Parent = titleBar
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0, 20, 0, 25)
    subtitleLabel.Size = UDim2.new(0, 200, 0, 20)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = windowConfig.SubTitle
    subtitleLabel.TextColor3 = _G.Colors.TextSecondary
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Window controls
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.BackgroundColor3 = _G.Colors.Error
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.Position = UDim2.new(1, -15, 0.5, 0)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Image = "rbxassetid://7743878857"
    closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.AutoButtonColor = false
    Utils.CreateCorner(closeButton, 12)
    
    closeButton.MouseButton1Click:Connect(function()
        xenonGui.Enabled = false
    end)
    
    -- Minimize button
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = titleBar
    minimizeButton.BackgroundColor3 = _G.Colors.Warning
    minimizeButton.AnchorPoint = Vector2.new(1, 0.5)
    minimizeButton.Position = UDim2.new(1, -45, 0.5, 0)
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Image = "rbxassetid://10734886735"
    minimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.AutoButtonColor = false
    Utils.CreateCorner(minimizeButton, 12)
    
    -- Settings button
    local settingsButton = Instance.new("ImageButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Parent = titleBar
    settingsButton.BackgroundColor3 = _G.Colors.SurfaceLight
    settingsButton.AnchorPoint = Vector2.new(1, 0.5)
    settingsButton.Position = UDim2.new(1, -75, 0.5, 0)
    settingsButton.Size = UDim2.new(0, 24, 0, 24)
    settingsButton.Image = "rbxassetid://10734950020"
    settingsButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.AutoButtonColor = false
    Utils.CreateCorner(settingsButton, 12)
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainContainer
    contentArea.BackgroundTransparency = 1
    contentArea.Position = UDim2.new(0, 0, 0, 50)
    contentArea.Size = UDim2.new(1, 0, 1, -50)
    
    -- Sidebar for tabs
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = contentArea
    sidebar.BackgroundColor3 = _G.Colors.Surface
    sidebar.Size = UDim2.new(0, windowConfig.TabWidth, 1, 0)
    Utils.CreateCorner(sidebar, 12)
    
    -- Sidebar border
    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Name = "SidebarBorder"
    sidebarBorder.Parent = sidebar
    sidebarBorder.BackgroundColor3 = _G.Colors.Border
    sidebarBorder.BackgroundTransparency = 0.7
    sidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    
    -- Tab scroll frame
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Parent = sidebar
    tabScroll.BackgroundTransparency = 1
    tabScroll.Position = UDim2.new(0, 10, 0, 10)
    tabScroll.Size = UDim2.new(1, -20, 1, -20)
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = _G.Colors.Primary
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabScroll
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    
    -- Page container
    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "PageContainer"
    pageContainer.Parent = contentArea
    pageContainer.BackgroundTransparency = 1
    pageContainer.Position = UDim2.new(0, windowConfig.TabWidth + 10, 0, 10)
    pageContainer.Size = UDim2.new(1, -windowConfig.TabWidth - 20, 1, -20)
    
    local pageLayout = Instance.new("UIPageLayout")
    pageLayout.Parent = pageContainer
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.EasingStyle = Enum.EasingStyle.Quad
    pageLayout.EasingDirection = Enum.EasingDirection.Out
    pageLayout.TweenTime = 0.3
    pageLayout.GamepadInputEnabled = false
    pageLayout.ScrollWheelInputEnabled = false
    pageLayout.TouchInputEnabled = false
    
    -- Make window draggable
    Utils.MakeDraggable(titleBar, mainContainer)
    
    -- Keyboard shortcut
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            xenonGui.Enabled = not xenonGui.Enabled
        end
    end)
    
    -- Update canvas sizes
    RunService.Stepped:Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    local WindowAPI = {}
    local tabs = {}
    local currentTab = nil
    
    function WindowAPI:Tab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "_Tab"
        tabButton.Parent = tabScroll
        tabButton.BackgroundColor3 = _G.Colors.SurfaceLight
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        Utils.CreateCorner(tabButton, 8)
        
        -- Tab icon
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Parent = tabButton
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 12, 0.5, 0)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Image = icon or "rbxassetid://10709768347"
        tabIcon.ImageColor3 = _G.Colors.TextSecondary
        
        -- Tab label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Parent = tabButton
        tabLabel.BackgroundTransparency = 1
        tabLabel.Position = UDim2.new(0, 40, 0, 0)
        tabLabel.Size = UDim2.new(1, -50, 1, 0)
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.Text = name
        tabLabel.TextColor3 = _G.Colors.TextSecondary
        tabLabel.TextSize = 14
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Active indicator
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Parent = tabButton
        indicator.BackgroundColor3 = _G.Colors.Primary
        indicator.Position = UDim2.new(0, 0, 0.5, 0)
        indicator.AnchorPoint = Vector2.new(0, 0.5)
        indicator.Size = UDim2.new(0, 0, 0, 20)
        Utils.CreateCorner(indicator, 2)
        
        -- Page frame
        local pageFrame = Instance.new("ScrollingFrame")
        pageFrame.Name = name .. "_Page"
        pageFrame.Parent = pageContainer
        pageFrame.BackgroundTransparency = 1
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.ScrollBarThickness = 3
        pageFrame.ScrollBarImageColor3 = _G.Colors.Primary
        pageFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        pageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = pageFrame
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.Parent = pageFrame
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingBottom = UDim.new(0, 10)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 10)
        
        -- Tab click handler
        tabButton.MouseButton1Click:Connect(function()
            -- Deactivate all tabs
            for _, tab in pairs(tabs) do
                Utils.Tween(tab.button, {BackgroundTransparency = 1}, 0.2)
                Utils.Tween(tab.indicator, {Size = UDim2.new(0, 0, 0, 20)}, 0.2)
                Utils.Tween(tab.icon, {ImageColor3 = _G.Colors.TextSecondary}, 0.2)
                Utils.Tween(tab.label, {TextColor3 = _G.Colors.TextSecondary}, 0.2)
            end
            
            -- Activate current tab
            Utils.Tween(tabButton, {BackgroundTransparency = 0.9}, 0.2)
            Utils.Tween(indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2)
            Utils.Tween(tabIcon, {ImageColor3 = _G.Colors.Primary}, 0.2)
            Utils.Tween(tabLabel, {TextColor3 = _G.Colors.Text}, 0.2)
            
            -- Switch page
            pageLayout:JumpTo(pageFrame)
            currentTab = name
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= name then
                Utils.Tween(tabButton, {BackgroundTransparency = 0.95}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= name then
                Utils.Tween(tabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        -- Store tab reference
        local tabData = {
            button = tabButton,
            indicator = indicator,
            icon = tabIcon,
            label = tabLabel,
            page = pageFrame,
            layout = pageLayout
        }
        tabs[name] = tabData
        
        -- Auto-select first tab
        if #tabs == 1 then
            tabButton.MouseButton1Click()
        end
        
        -- Update canvas size
        RunService.Stepped:Connect(function()
            pageFrame.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Return tab API
        return self:CreateTabAPI(pageFrame, pageLayout)
    end
    
    return WindowAPI
end

function XenonLib:CreateTabAPI(pageFrame, pageLayout)
    local TabAPI = {}
    
    function TabAPI:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Parent = pageFrame
        button.BackgroundColor3 = _G.Colors.Primary
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Font = Enum.Font.GothamMedium
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.AutoButtonColor = false
        Utils.CreateCorner(button, 8)
        
        -- Hover effects
        button.MouseEnter:Connect(function()
            Utils.Tween(button, {BackgroundColor3 = _G.Colors.Secondary}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Utils.Tween(button, {BackgroundColor3 = _G.Colors.Primary}, 0.2)
        end)
        
        -- Click effects
        button.MouseButton1Down:Connect(function()
            Utils.Tween(button, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            Utils.Tween(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
        end)
        
        button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        
        return button
    end
    
    function TabAPI:Toggle(text, default, description, callback)
        local container = Instance.new("Frame")
        container.Name = "Toggle"
        container.Parent = pageFrame
        container.BackgroundColor3 = _G.Colors.Surface
        container.Size = UDim2.new(1, 0, 0, description and 60 or 45)
        Utils.CreateCorner(container, 8)
        Utils.CreateStroke(container, _G.Colors.Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Parent = container
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 8)
        title.Size = UDim2.new(1, -80, 0, 20)
        title.Font = Enum.Font.GothamMedium
        title.Text = text
        title.TextColor3 = _G.Colors.Text
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        if description then
            local desc = Instance.new("TextLabel")
            desc.Name = "Description"
            desc.Parent = container
            desc.BackgroundTransparency = 1
            desc.Position = UDim2.new(0, 15, 0, 28)
            desc.Size = UDim2.new(1, -80, 0, 16)
            desc.Font = Enum.Font.Gotham
            desc.Text = description
            desc.TextColor3 = _G.Colors.TextSecondary
            desc.TextSize = 11
            desc.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        -- Toggle switch
        local switchBg = Instance.new("Frame")
        switchBg.Name = "SwitchBackground"
        switchBg.Parent = container
        switchBg.BackgroundColor3 = _G.Colors.SurfaceLight
        switchBg.AnchorPoint = Vector2.new(1, 0.5)
        switchBg.Position = UDim2.new(1, -15, 0.5, 0)
        switchBg.Size = UDim2.new(0, 44, 0, 24)
        Utils.CreateCorner(switchBg, 12)
        
        local switchKnob = Instance.new("Frame")
        switchKnob.Name = "SwitchKnob"
        switchKnob.Parent = switchBg
        switchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchKnob.Position = UDim2.new(0, 2, 0.5, 0)
        switchKnob.AnchorPoint = Vector2.new(0, 0.5)
        switchKnob.Size = UDim2.new(0, 20, 0, 20)
        Utils.CreateCorner(switchKnob, 10)
        
        local switchButton = Instance.new("TextButton")
        switchButton.Name = "SwitchButton"
        switchButton.Parent = switchBg
        switchButton.BackgroundTransparency = 1
        switchButton.Size = UDim2.new(1, 0, 1, 0)
        switchButton.Text = ""
        
        local toggled = default or false
        
        local function updateToggle()
            if toggled then
                Utils.Tween(switchBg, {BackgroundColor3 = _G.Colors.Primary}, 0.2)
                Utils.Tween(switchKnob, {Position = UDim2.new(1, -22, 0.5, 0)}, 0.2)
            else
                Utils.Tween(switchBg, {BackgroundColor3 = _G.Colors.SurfaceLight}, 0.2)
                Utils.Tween(switchKnob, {Position = UDim2.new(0, 2, 0.5, 0)}, 0.2)
            end
        end
        
        switchButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateToggle()
            pcall(callback, toggled)
        end)
        
        -- Initialize
        updateToggle()
        if default then
            pcall(callback, toggled)
        end
        
        return container
    end
    
    function TabAPI:Dropdown(text, options, default, callback)
        local container = Instance.new("Frame")
        container.Name = "Dropdown"
        container.Parent = pageFrame
        container.BackgroundColor3 = _G.Colors.Surface
        container.Size = UDim2.new(1, 0, 0, 45)
        container.ClipsDescendants = false
        Utils.CreateCorner(container, 8)
        Utils.CreateStroke(container, _G.Colors.Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Parent = container
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0.6, 0, 1, 0)
        title.Font = Enum.Font.GothamMedium
        title.Text = text
        title.TextColor3 = _G.Colors.Text
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Parent = container
        dropdownButton.BackgroundColor3 = _G.Colors.SurfaceLight
        dropdownButton.AnchorPoint = Vector2.new(1, 0.5)
        dropdownButton.Position = UDim2.new(1, -15, 0.5, 0)
        dropdownButton.Size = UDim2.new(0, 120, 0, 30)
        dropdownButton.Font = Enum.Font.Gotham
        dropdownButton.Text = default or "Select..."
        dropdownButton.TextColor3 = _G.Colors.Text
        dropdownButton.TextSize = 12
        dropdownButton.AutoButtonColor = false
        Utils.CreateCorner(dropdownButton, 6)
        
        local arrow = Instance.new("ImageLabel")
        arrow.Name = "Arrow"
        arrow.Parent = dropdownButton
        arrow.BackgroundTransparency = 1
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -8, 0.5, 0)
        arrow.Size = UDim2.new(0, 12, 0, 12)
        arrow.Image = "rbxassetid://10709790948"
        arrow.ImageColor3 = _G.Colors.TextSecondary
        
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "DropdownFrame"
        dropdownFrame.Parent = container
        dropdownFrame.BackgroundColor3 = _G.Colors.Surface
        dropdownFrame.Position = UDim2.new(1, -135, 1, 5)
        dropdownFrame.Size = UDim2.new(0, 120, 0, 0)
        dropdownFrame.Visible = false
        dropdownFrame.ZIndex = 10
        Utils.CreateCorner(dropdownFrame, 6)
        Utils.CreateStroke(dropdownFrame, _G.Colors.Border, 1)
        
        local optionsList = Instance.new("ScrollingFrame")
        optionsList.Name = "OptionsList"
        optionsList.Parent = dropdownFrame
        optionsList.BackgroundTransparency = 1
        optionsList.Position = UDim2.new(0, 5, 0, 5)
        optionsList.Size = UDim2.new(1, -10, 1, -10)
        optionsList.ScrollBarThickness = 2
        optionsList.ScrollBarImageColor3 = _G.Colors.Primary
        optionsList.ScrollingDirection = Enum.ScrollingDirection.Y
        optionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Parent = optionsList
        optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optionsLayout.Padding = UDim.new(0, 2)
        
        local isOpen = false
        local selectedValue = default
        
        local function createOption(option)
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option"
            optionButton.Parent = optionsList
            optionButton.BackgroundColor3 = _G.Colors.SurfaceLight
            optionButton.BackgroundTransparency = 1
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.Font = Enum.Font.Gotham
            optionButton.Text = option
            optionButton.TextColor3 = _G.Colors.Text
            optionButton.TextSize = 11
            optionButton.AutoButtonColor = false
            Utils.CreateCorner(optionButton, 4)
            
            optionButton.MouseEnter:Connect(function()
                Utils.Tween(optionButton, {BackgroundTransparency = 0.9}, 0.1)
            end)
            
            optionButton.MouseLeave:Connect(function()
                Utils.Tween(optionButton, {BackgroundTransparency = 1}, 0.1)
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selectedValue = option
                dropdownButton.Text = option
                isOpen = false
                
                Utils.Tween(dropdownFrame, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                Utils.Tween(arrow, {Rotation = 0}, 0.2)
                
                spawn(function()
                    wait(0.2)
                    dropdownFrame.Visible = false
                    container.Size = UDim2.new(1, 0, 0, 45)
                end)
                
                pcall(callback, option)
            end)
        end
        
        -- Create options
        for _, option in ipairs(options) do
            createOption(option)
        end
        
        -- Update canvas size
        optionsList.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y)
        
        dropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            
            if isOpen then
                dropdownFrame.Visible = true
                local maxHeight = math.min(#options * 27, 150)
                container.Size = UDim2.new(1, 0, 0, 45 + maxHeight + 10)
                Utils.Tween(dropdownFrame, {Size = UDim2.new(0, 120, 0, maxHeight)}, 0.2)
                Utils.Tween(arrow, {Rotation = 180}, 0.2)
            else
                Utils.Tween(dropdownFrame, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                Utils.Tween(arrow, {Rotation = 0}, 0.2)
                
                spawn(function()
                    wait(0.2)
                    dropdownFrame.Visible = false
                    container.Size = UDim2.new(1, 0, 0, 45)
                end)
            end
        end)
        
        -- Initialize with default
        if default then
            pcall(callback, default)
        end
        
        local DropdownAPI = {}
        
        function DropdownAPI:Add(option)
            table.insert(options, option)
            createOption(option)
            optionsList.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y)
        end
        
        function DropdownAPI:Remove(option)
            for i, v in ipairs(options) do
                if v == option then
                    table.remove(options, i)
                    break
                end
            end
            
            for _, child in ipairs(optionsList:GetChildren()) do
                if child:IsA("TextButton") and child.Text == option then
                    child:Destroy()
                    break
                end
            end
            
            optionsList.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y)
        end
        
        function DropdownAPI:Clear()
            options = {}
            for _, child in ipairs(optionsList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            dropdownButton.Text = "Select..."
            optionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
        end
        
        return DropdownAPI
    end
    
    function TabAPI:Slider(text, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Name = "Slider"
        container.Parent = pageFrame
        container.BackgroundColor3 = _G.Colors.Surface
        container.Size = UDim2.new(1, 0, 0, 50)
        Utils.CreateCorner(container, 8)
        Utils.CreateStroke(container, _G.Colors.Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Parent = container
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 8)
        title.Size = UDim2.new(0.6, 0, 0, 20)
        title.Font = Enum.Font.GothamMedium
        title.Text = text
        title.TextColor3 = _G.Colors.Text
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "ValueLabel"
        valueLabel.Parent = container
        valueLabel.BackgroundTransparency = 1
        valueLabel.AnchorPoint = Vector2.new(1, 0)
        valueLabel.Position = UDim2.new(1, -15, 0, 8)
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Font = Enum.Font.GothamMedium
        valueLabel.Text = tostring(default or min)
        valueLabel.TextColor3 = _G.Colors.Primary
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "SliderTrack"
        sliderTrack.Parent = container
        sliderTrack.BackgroundColor3 = _G.Colors.SurfaceLight
        sliderTrack.Position = UDim2.new(0, 15, 1, -15)
        sliderTrack.Size = UDim2.new(1, -30, 0, 4)
        Utils.CreateCorner(sliderTrack, 2)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.Parent = sliderTrack
        sliderFill.BackgroundColor3 = _G.Colors.Primary
        sliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
        Utils.CreateCorner(sliderFill, 2)
        
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Name = "SliderKnob"
        sliderKnob.Parent = sliderTrack
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderKnob.Position = UDim2.new((default or min) / max, 0, 0.5, 0)
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        Utils.CreateCorner(sliderKnob, 8)
        Utils.CreateStroke(sliderKnob, _G.Colors.Primary, 2)
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "SliderButton"
        sliderButton.Parent = sliderTrack
        sliderButton.BackgroundTransparency = 1
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.Text = ""
        
        local dragging = false
        local currentValue = default or min
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relativeX)
            
            valueLabel.Text = tostring(currentValue)
            Utils.Tween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
            Utils.Tween(sliderKnob, {Position = UDim2.new(relativeX, 0, 0.5, 0)}, 0.1)
            
            pcall(callback, currentValue)
        end
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        -- Initialize
        if default then
            pcall(callback, currentValue)
        end
        
        return container
    end
    
    function TabAPI:Textbox(text, placeholder, callback)
        local container = Instance.new("Frame")
        container.Name = "Textbox"
        container.Parent = pageFrame
        container.BackgroundColor3 = _G.Colors.Surface
        container.Size = UDim2.new(1, 0, 0, 45)
        Utils.CreateCorner(container, 8)
        Utils.CreateStroke(container, _G.Colors.Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Parent = container
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 15, 0, 0)
        title.Size = UDim2.new(0.5, 0, 1, 0)
        title.Font = Enum.Font.GothamMedium
        title.Text = text
        title.TextColor3 = _G.Colors.Text
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local textbox = Instance.new("TextBox")
        textbox.Name = "Textbox"
        textbox.Parent = container
        textbox.BackgroundColor3 = _G.Colors.SurfaceLight
        textbox.AnchorPoint = Vector2.new(1, 0.5)
        textbox.Position = UDim2.new(1, -15, 0.5, 0)
        textbox.Size = UDim2.new(0, 150, 0, 30)
        textbox.Font = Enum.Font.Gotham
        textbox.PlaceholderText = placeholder or "Enter text..."
        textbox.PlaceholderColor3 = _G.Colors.TextSecondary
        textbox.Text = ""
        textbox.TextColor3 = _G.Colors.Text
        textbox.TextSize = 12
        textbox.ClearTextOnFocus = false
        Utils.CreateCorner(textbox, 6)
        
        -- Focus effects
        textbox.Focused:Connect(function()
            Utils.Tween(textbox, {BackgroundColor3 = _G.Colors.Primary}, 0.2)
            Utils.Tween(textbox, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)
        
        textbox.FocusLost:Connect(function()
            Utils.Tween(textbox, {BackgroundColor3 = _G.Colors.SurfaceLight}, 0.2)
            Utils.Tween(textbox, {TextColor3 = _G.Colors.Text}, 0.2)
            pcall(callback, textbox.Text)
        end)
        
        return container
    end
    
    function TabAPI:Label(text)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Parent = pageFrame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 25)
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextColor3 = _G.Colors.Text
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local LabelAPI = {}
        
        function LabelAPI:Set(newText)
            label.Text = newText
        end
        
        return LabelAPI
    end
    
    function TabAPI:Separator(text)
        local container = Instance.new("Frame")
        container.Name = "Separator"
        container.Parent = pageFrame
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 0, 30)
        
        if text then
            local leftLine = Instance.new("Frame")
            leftLine.Name = "LeftLine"
            leftLine.Parent = container
            leftLine.BackgroundColor3 = _G.Colors.Border
            leftLine.AnchorPoint = Vector2.new(0, 0.5)
            leftLine.Position = UDim2.new(0, 0, 0.5, 0)
            leftLine.Size = UDim2.new(0.4, -10, 0, 1)
            
            local separatorText = Instance.new("TextLabel")
            separatorText.Name = "SeparatorText"
            separatorText.Parent = container
            separatorText.BackgroundTransparency = 1
            separatorText.AnchorPoint = Vector2.new(0.5, 0.5)
            separatorText.Position = UDim2.new(0.5, 0, 0.5, 0)
            separatorText.Size = UDim2.new(0, 100, 1, 0)
            separatorText.Font = Enum.Font.GothamBold
            separatorText.Text = text
            separatorText.TextColor3 = _G.Colors.TextSecondary
            separatorText.TextSize = 12
            
            local rightLine = Instance.new("Frame")
            rightLine.Name = "RightLine"
            rightLine.Parent = container
            rightLine.BackgroundColor3 = _G.Colors.Border
            rightLine.AnchorPoint = Vector2.new(1, 0.5)
            rightLine.Position = UDim2.new(1, 0, 0.5, 0)
            rightLine.Size = UDim2.new(0.4, -10, 0, 1)
        else
            local line = Instance.new("Frame")
            line.Name = "Line"
            line.Parent = container
            line.BackgroundColor3 = _G.Colors.Border
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Position = UDim2.new(0.5, 0, 0.5, 0)
            line.Size = UDim2.new(1, 0, 0, 1)
        end
        
        return container
    end
    
    return TabAPI
end

-- Legacy compatibility functions
getgenv().LoadConfig = function()
    SettingsManager:Load()
end

getgenv().SaveConfig = function()
    SettingsManager:Save()
end

return XenonLib
