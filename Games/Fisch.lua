local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local existingGui = game.CoreGui:FindFirstChild("LoginGui")
if existingGui then
    existingGui:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "LoginGui"
ScreenGui.IgnoreGuiInset = true

-- Background Frame dengan efek blur
local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.Parent = ScreenGui
BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
BackgroundFrame.BackgroundTransparency = 0.3

-- Tambahkan gradient untuk background
local BackgroundGradient = Instance.new("UIGradient")
BackgroundGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
BackgroundGradient.Rotation = 45
BackgroundGradient.Parent = BackgroundFrame

-- Tambahkan efek blur
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Parent = game.Lighting
BlurEffect.Size = 20

-- Time Remaining Container
local TimeContainer = Instance.new("Frame")
TimeContainer.Parent = BackgroundFrame
TimeContainer.Size = UDim2.new(0.25, 0, 0.06, 0)
TimeContainer.Position = UDim2.new(0.375, 0, 0.02, 0)
TimeContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TimeContainer.BackgroundTransparency = 0.2

-- Add gradient to time container
local TimeGradient = Instance.new("UIGradient")
TimeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
})
TimeGradient.Rotation = 45
TimeGradient.Parent = TimeContainer

-- Add glow effect
local TimeGlow = Instance.new("ImageLabel")
TimeGlow.Parent = TimeContainer
TimeGlow.BackgroundTransparency = 1
TimeGlow.Position = UDim2.new(0, -10, 0, -10)
TimeGlow.Size = UDim2.new(1, 20, 1, 20)
TimeGlow.Image = "rbxassetid://5028857084"
TimeGlow.ImageColor3 = Color3.fromRGB(75, 150, 255)
TimeGlow.ImageTransparency = 0.8

-- Time Label
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Parent = TimeContainer
TimeLabel.Size = UDim2.new(1, 0, 1, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "Time Remaining: --:--:--"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextSize = 16
TimeLabel.Font = Enum.Font.GothamBold

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Parent = BackgroundFrame
Frame.Size = UDim2.new(0.3, 0, 0.5, 0)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BackgroundTransparency = 0.1

-- Add gradient to main frame
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
})
MainGradient.Rotation = 45
MainGradient.Parent = Frame

-- Profile Frame
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Parent = Frame
ProfileFrame.Size = UDim2.new(1, 0, 0.3, 0)
ProfileFrame.Position = UDim2.new(0, 0, 0, 0)
ProfileFrame.BackgroundTransparency = 1

-- Profile Image with Glow
local ProfileGlow = Instance.new("ImageLabel")
ProfileGlow.Parent = ProfileFrame
ProfileGlow.Size = UDim2.new(0.27, 0, 0.85, 0)
ProfileGlow.Position = UDim2.new(0.365, 0, 0.075, 0)
ProfileGlow.BackgroundTransparency = 1
ProfileGlow.Image = "rbxassetid://5028857084"
ProfileGlow.ImageColor3 = Color3.fromRGB(75, 150, 255)
ProfileGlow.ImageTransparency = 0.8

-- Profile Image
local ProfileImage = Instance.new("ImageLabel")
ProfileImage.Parent = ProfileFrame
ProfileImage.Size = UDim2.new(0.25, 0, 0.8, 0)
ProfileImage.Position = UDim2.new(0.375, 0, 0.1, 0)
ProfileImage.BackgroundTransparency = 1
ProfileImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

-- Username Label with Glow
local UsernameGlow = Instance.new("TextLabel")
UsernameGlow.Parent = ProfileFrame
UsernameGlow.Size = UDim2.new(0.8, 0, 0.2, 0)
UsernameGlow.Position = UDim2.new(0.1, 0, 0.9, 0)
UsernameGlow.BackgroundTransparency = 1
UsernameGlow.Text = LocalPlayer.Name
UsernameGlow.TextColor3 = Color3.fromRGB(75, 150, 255)
UsernameGlow.TextSize = 16
UsernameGlow.Font = Enum.Font.GothamBold
UsernameGlow.TextTransparency = 0.8

-- Username Label
local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Parent = ProfileFrame
UsernameLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
UsernameLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = LocalPlayer.Name
UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameLabel.TextSize = 14
UsernameLabel.Font = Enum.Font.GothamBold

-- Title Label with Glow
local TitleGlow = Instance.new("TextLabel")
TitleGlow.Parent = Frame
TitleGlow.Text = "XENON HUB"
TitleGlow.TextColor3 = Color3.fromRGB(75, 150, 255)
TitleGlow.TextSize = 26
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.BackgroundTransparency = 1
TitleGlow.Size = UDim2.new(0.8, 0, 0.1, 0)
TitleGlow.Position = UDim2.new(0.1, 0, 0.35, 0)
TitleGlow.TextTransparency = 0.8

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Frame
TitleLabel.Text = "XENON HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
TitleLabel.Position = UDim2.new(0.1, 0, 0.35, 0)

-- Key Input Box
local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.PlaceholderText = "Enter your key"
TextBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
TextBox.Text = ""
TextBox.Size = UDim2.new(0.8, 0, 0.1, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.5, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TextBox.BackgroundTransparency = 0.5
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14

-- Add gradient to textbox
local TextBoxGradient = Instance.new("UIGradient")
TextBoxGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 45))
})
TextBoxGradient.Rotation = 45
TextBoxGradient.Parent = TextBox

-- Verify Button
local VerifyButton = Instance.new("TextButton")
VerifyButton.Parent = Frame
VerifyButton.Text = "Verify Key"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.Size = UDim2.new(0.38, 0, 0.1, 0)
VerifyButton.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
VerifyButton.BackgroundTransparency = 0.3
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.TextSize = 14

-- Add gradient to verify button
local VerifyGradient = Instance.new("UIGradient")
VerifyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
})
VerifyGradient.Rotation = 45
VerifyGradient.Parent = VerifyButton

-- Get Key Button
local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Parent = Frame
GetKeyButton.Text = "Get Key"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.Size = UDim2.new(0.38, 0, 0.1, 0)
GetKeyButton.Position = UDim2.new(0.52, 0, 0.65, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
GetKeyButton.BackgroundTransparency = 0.3
GetKeyButton.Font = Enum.Font.GothamBold
GetKeyButton.TextSize = 14

-- Add gradient to get key button
local GetKeyGradient = Instance.new("UIGradient")
GetKeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
})
GetKeyGradient.Rotation = 45
GetKeyGradient.Parent = GetKeyButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = Frame
StatusLabel.Text = ""
StatusLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20

-- Add rounded corners to all elements
local function addRoundCorners(element, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, radius or 8)
    UICorner.Parent = element
end

addRoundCorners(Frame)
addRoundCorners(TextBox)
addRoundCorners(VerifyButton)
addRoundCorners(GetKeyButton)
addRoundCorners(ProfileImage)
addRoundCorners(TimeContainer)

-- Function to show status messages
local function showStatus(message, isError)
    StatusLabel.Text = message
    StatusLabel.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100)

    -- Animate status label
    StatusLabel.TextTransparency = 1
    TweenService:Create(StatusLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
end

-- Function to update time display
local function updateTimeDisplay(timeLeft)
    local hours = math.floor(timeLeft / 3600)
    local minutes = math.floor((timeLeft % 3600) / 60)
    local seconds = timeLeft % 60

    TimeLabel.Text = string.format("Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
end

-- Variable untuk menyimpan coroutine timer
local timerCoroutine = nil

-- Function untuk menghentikan timer yang sedang berjalan
local function stopTimer()
    if timerCoroutine then
        coroutine.close(timerCoroutine)
        timerCoroutine = nil
    end
end

-- Function untuk memulai timer baru
local function startTimer(duration)
    -- Hentikan timer yang sedang berjalan (jika ada)
    stopTimer()

    -- Mulai timer baru
    timerCoroutine = coroutine.create(function()
        local timeLeft = duration
        while timeLeft > 0 do
            updateTimeDisplay(timeLeft)
            wait(1)
            timeLeft = timeLeft - 1
        end
        -- Waktu habis
        TimeLabel.Text = "Time Expired!"
        TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)
    coroutine.resume(timerCoroutine)
end

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    stopTimer() -- Hentikan timer sebelum menutup GUI

    -- Fade out animation
    local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    })
    fadeOut:Play()

    -- Fade out time container separately
    local timeContainerFade = TweenService:Create(TimeContainer, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    })
    timeContainerFade:Play()

    -- Wait for animation to complete then destroy
    fadeOut.Completed:Connect(function()
        ScreenGui:Destroy()
        BlurEffect:Destroy()
    end)
end)

-- Key validation logic
local http_request = syn and syn.request or request
local keyValid = false

local function validateKey(key)
    local url = "https://tlfsfctfofjgppfrdcpm.supabase.co/functions/v1/validate-key"

    -- Add error handling for the request
    local success, response = pcall(function()
        return http_request({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsZnNmY3Rmb2ZqZ3BwZnJkY3BtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczMTkxNjgsImV4cCI6MjA1Mjg5NTE2OH0.yv_fnGPcP2TWB19V7TtY1IfLlyBMRofx_8kDk1fb6GY"
            },
            Body = HttpService:JSONEncode({ key = key })
        })
    end)

    if not success then
        print("Request failed:", response)
        showStatus("Failed to connect to server", true)
        return
    end

    -- Add error handling for JSON parsing
    if response.StatusCode == 200 then
        local success, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not success then
            print("JSON Parse Error:", response.Body)
            showStatus("Server response error", true)
            return
        end

        if data.valid then
            keyValid = true
            showStatus("Key Verified Successfully!", false)

            -- Move TimeContainer to ScreenGui
            TimeContainer.Parent = ScreenGui
            TimeContainer.Position = UDim2.new(0.375, 0, 0.02, 0)

            if data.expiresIn then
                startTimer(data.expiresIn)
            else
                TimeLabel.Text = "Error: No expiration data"
                TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end

            wait(1)

            local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            })
            local backgroundFade = TweenService:Create(BackgroundFrame, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            backgroundFade:Play()

            local blurFade = TweenService:Create(BlurEffect, TweenInfo.new(0.5), {
                Size = 0
            })
            blurFade:Play()

            fadeOut.Completed:Connect(function()
                Frame:Destroy()
                BlurEffect:Destroy()
                BackgroundFrame:Destroy()
            end)
-------------------MAIN KEY --------------------------------


local Fluent = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

local OriginalPlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local PlaceName = OriginalPlaceName -- Salin nama asli untuk diproses

-- Gunakan nama asli di SubTitle atau di tempat lain
local Window = Fluent:CreateWindow({
    Title = `Xenon | {OriginalPlaceName}`,
    SubTitle = "https://discord.gg/cF8YeDPt2G",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})


local Tabs = {
    Info = Window:CreateTab({ Title = "Info", Icon = "id-card" }),
    Main = Window:CreateTab({ Title = "Main", Icon = "house" }),
    Appraise = Window:CreateTab({ Title = "Appraise", Icon = "equal-approximately" }),
    Teleport = Window:CreateTab({ Title = "Teleport", Icon = "compass" }),
	MainJob = Window:CreateTab({ Title = "Job", Icon = "chart-no-axes-gantt" }),
    Settings = Window:CreateTab({ Title = "Credits", Icon = "info" })
}


--<>----<>----<>----< Getting Services >----<>----<>----<>--
AnalyticsService = game:GetService("AnalyticsService")
CollectionService = game:GetService("CollectionService")
DataStoreService = game:GetService("DataStoreService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
MarketplaceService = game:GetService("MarketplaceService")
Players = game:GetService("Players")
ReplicatedFirst = game:GetService("ReplicatedFirst")
ReplicatedStorage = game:GetService("ReplicatedStorage")
RunService = game:GetService("RunService")
ServerScriptService = game:GetService("ServerScriptService")
ServerStorage = game:GetService("ServerStorage")
SoundService = game:GetService("SoundService")
StarterGui = game:GetService("StarterGui")
StarterPack = game:GetService("StarterPack")
StarterPlayer = game:GetService("StarterPlayer")
TeleportService = game:GetService("TeleportService")
TweenService = game:GetService("TweenService")
Teams = game:GetService("Teams")
VirtualUser = game:GetService("VirtualUser")
Workspace = game:GetService("Workspace")
UserInputService = game:GetService("UserInputService")
VirtualInputManager = game:GetService("VirtualInputManager")
ContextActionService = game:GetService("ContextActionService")
GuiService = game:GetService("GuiService")
local ProtectPremium = teleportSuccess
local localPlayer = Players.LocalPlayer

--<>----<>----<>----< Anti Afk >----<>----<>----<>--
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)


local teleportSpots = {
    altar = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    The_Depths = CFrame.new(885.42804, -721.915894, 1280.83325, -0.511002302, 5.11298417e-08, 0.859579325, 1.29794955e-07, 1, 1.76780386e-08, -0.859579325, 1.20602579e-07, -0.511002302),
    arch = CFrame.new(998.966796875, 126.6849365234375, -1237.1434326171875),
    birch = CFrame.new(1742.3203125, 138.25787353515625, -2502.23779296875),
    brine = CFrame.new(-1794.10596, -145.849701, -3302.92358, -5.16176224e-05, 3.10316682e-06, 0.99999994, 0.119907647, 0.992785037, 3.10316682e-06, -0.992785037, 0.119907647, -5.16176224e-05),
    deep = CFrame.new(-1510.88672, -237.695053, -2852.90674, 0.573604643, 0.000580655003, 0.81913209, -0.000340352941, 0.999999762, -0.000470530824, -0.819132209, -8.89541116e-06, 0.573604763),
    deepshop = CFrame.new(-979.196411, -247.910156, -2699.87207, 0.587748766, 0, 0.809043527, 0, 1, 0, -0.809043527, 0, 0.587748766),
    enchant = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    executive = CFrame.new(-29.836761474609375, -250.48486328125, 199.11614990234375),
    keepers = CFrame.new(1296.320068359375, -808.5519409179688, -298.93817138671875),
    mod_house = CFrame.new(-30.205902099609375, -249.40594482421875, 204.0529022216797),
    moosewood = CFrame.new(383.10113525390625, 131.2406005859375, 243.93385314941406),
    mushgrove = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
    roslit = CFrame.new(-1476.511474609375, 130.16842651367188, 671.685302734375),
    snow = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
    snowcap = CFrame.new(2648.67578125, 139.06605529785156, 2521.29736328125),
    spike = CFrame.new(-1254.800537109375, 133.88555908203125, 1554.2021484375),
    statue = CFrame.new(72.8836669921875, 138.6964874267578, -1028.4193115234375),
    sunstone = CFrame.new(-933.259705, 128.143951, -1119.52063, -0.342042685, 0, -0.939684391, 0, 1, 0, 0.939684391, 0, -0.342042685),
    swamp = CFrame.new(2501.48583984375, 127.7583236694336, -720.699462890625),
    terrapin = CFrame.new(-143.875244140625, 141.1676025390625, 1909.6070556640625),
    trident = CFrame.new(-1479.48987, -228.710632, -2391.39307, 0.0435845852, 0, 0.999049723, 0, 1, 0, -0.999049723, 0, 0.0435845852),
    vertigo = CFrame.new(-112.007278, -492.901093, 1040.32788, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    volcano = CFrame.new(-1888.52319, 163.847565, 329.238281, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    wilson = CFrame.new(2938.80591, 277.474762, 2567.13379, 0.4648332, 0, 0.885398269, 0, 1, 0, -0.885398269, 0, 0.4648332),
    wilsons_rod = CFrame.new(2879.2085, 135.07663, 2723.64233, 0.970463336, -0.168695927, -0.172460333, 0.141582936, -0.180552125, 0.973321974, -0.195333466, -0.968990743, -0.151334763)
}
local FishAreas = {
    Roslit_Bay = CFrame.new(-1663.73889, 149.234116, 495.498016, 0.0380855016, 4.08820178e-08, -0.999274492, 5.74658472e-08, 1, 4.3101906e-08, 0.999274492, -5.90657123e-08, 0.0380855016),
    Ocean = CFrame.new(7665.104, 125.444443, 2601.59351, 0.999966085, -0.000609769544, -0.00821684115, 0.000612694537, 0.999999762, 0.000353460142, 0.00821662322, -0.000358482561, 0.999966204),
    Snowcap_Pond = CFrame.new(2778.09009, 283.283783, 2580.323, 1, 7.17688531e-09, -2.22843701e-05, -7.17796267e-09, 1, -4.83369114e-08, 2.22843701e-05, 4.83370712e-08, 1),
    Moosewood_Docks = CFrame.new(343.2359924316406, 133.61595153808594, 267.0580139160156),
    Deep_Ocean = CFrame.new(3569.07153, 125.480949, 6697.12695, 0.999980748, -0.00188910461, -0.00591362361, 0.00193980196, 0.999961317, 0.00857902411, 0.00589718809, -0.00859032944, 0.9999457),
    Vertigo = CFrame.new(-137.697098, -736.86377, 1233.15271, 1, -1.61821543e-08, -2.01375751e-05, 1.6184277e-08, 1, 1.05423091e-07, 2.01375751e-05, -1.0542341e-07, 1),
    Snowcap_Ocean = CFrame.new(3088.66699, 131.534332, 2587.11304, 1, 4.30694858e-09, -1.19097813e-14, -4.30694858e-09, 1, -2.80603398e-08, 1.17889275e-14, 2.80603398e-08, 1),
    Harvesters_Spike = CFrame.new(-1234.61523, 125.228767, 1748.57166, 0.999991536, -0.000663080777, -0.00405627443, 0.000725277001, 0.999881923, 0.0153511297, 0.00404561637, -0.0153539423, 0.999873936),
    SunStone = CFrame.new(-845.903992, 133.172211, -1163.57776, 1, -7.93465915e-09, -2.09446498e-05, 7.93544608e-09, 1, 3.75741536e-08, 2.09446498e-05, -3.75743205e-08, 1),
    Roslit_Bay_Ocean = CFrame.new(-1708.09302, 155.000015, 384.928009, 1, -9.84460868e-09, -3.24939563e-15, 9.84460868e-09, 1, 4.66220271e-08, 2.79042003e-15, -4.66220271e-08, 1),
    Moosewood_Pond = CFrame.new(509.735992, 152.000031, 302.173004, 1, -1.78487678e-08, -8.1329488e-14, 1.78487678e-08, 1, 8.45405168e-08, 7.98205428e-14, -8.45405168e-08, 1),
    Terrapin_Ocean = CFrame.new(58.6469994, 135.499985, 2147.41699, 1, 2.09643041e-08, -5.6023784e-15, -2.09643041e-08, 1, -9.92988376e-08, 3.52064755e-15, 9.92988376e-08, 1),
    Isonade = CFrame.new(-1060.99902, 121.164787, 953.996033, 0.999958456, 0.000633197487, -0.00909138657, -0.000568434712, 0.999974489, 0.00712434994, 0.00909566507, -0.00711888634, 0.999933302),
    Moosewood_Ocean = CFrame.new(-167.642715, 125.19548, 248.009521, 0.999997199, -0.000432743778, -0.0023210498, 0.000467110571, 0.99988997, 0.0148265222, 0.00231437827, -0.0148275653, 0.999887407),
    Roslit_Pond = CFrame.new(-1811.96997, 148.047089, 592.642517, 1, 1.12983072e-08, -2.16573972e-05, -1.12998171e-08, 1, -6.97014357e-08, 2.16573972e-05, 6.97016844e-08, 1),
    Moosewood_Ocean_Mythical = CFrame.new(252.802994, 135.849625, 36.8839989, 1, -1.98115071e-08, -4.50667564e-15, 1.98115071e-08, 1, 1.22230617e-07, 2.08510289e-15, -1.22230617e-07, 1),
    Terrapin_Olm = CFrame.new(22.0639992, 182.000015, 1944.36804, 1, 1.14953362e-08, -2.7011112e-15, -1.14953362e-08, 1, -7.09263972e-08, 1.88578841e-15, 7.09263972e-08, 1),
    The_Arch = CFrame.new(1283.30896, 130.923569, -1165.29602, 1, -5.89772364e-09, -3.3183043e-15, 5.89772364e-09, 1, 3.63913486e-08, 3.10367822e-15, -3.63913486e-08, 1),
    Scallop_Ocean = CFrame.new(23.2255898, 125.236847, 738.952271, 0.999990165, -0.00109633175, -0.00429760758, 0.00115595153, 0.999902785, 0.0138949333, 0.00428195624, -0.013899764, 0.999894202),
    SunStone_Hidden = CFrame.new(-1139.55701, 134.62204, -1076.94324, 1, 3.9719481e-09, -1.6278158e-05, -3.97231048e-09, 1, -2.22651142e-08, 1.6278158e-05, 2.22651781e-08, 1),
    Mushgrove_Stone = CFrame.new(2525.36011, 131.000015, -776.184021, 1, 1.90145943e-08, -3.24206519e-15, -1.90145943e-08, 1, -1.06596836e-07, 1.21516956e-15, 1.06596836e-07, 1),
    Keepers_Altar = CFrame.new(1307.13599, -805.292236, -161.363998, 1, 2.40881981e-10, -3.25609947e-15, -2.40881981e-10, 1, -1.35044154e-09, 3.255774e-15, 1.35044154e-09, 1),
    Lava = CFrame.new(-1959.86206, 193.144821, 271.960999, 1, -6.02453598e-09, -2.97388313e-15, 6.02453598e-09, 1, 3.37767716e-08, 2.77039384e-15, -3.37767716e-08, 1),
    Roslit_Pond_Seaweed = CFrame.new(-1785.2869873046875, 148.15780639648438, 639.9299926757812),
    Forsaken_Shores = CFrame.new(-2675.3894, 170.500031, 1742.83057, -0.182155296, 1.52197099e-08, 0.983269751, 6.83117847e-08, 1, -2.82359558e-09, -0.983269751, 6.66545859e-08, -0.182155296),
    Frigid_Cavern = CFrame.new(19897.5098, 443.192078, 5609.37256, 0.345671237, -0.0116030909, 0.938283861, 8.02743045e-08, 0.999923527, 0.0123653747, -0.938355625, -0.00427425886, 0.345644861),
    Glacial_Grotto = CFrame.new(20034.3457, 884.669922, 5636.8833, 0.777055383, 0.00771055883, -0.629384875, 1.08549365e-07, 0.999924958, 0.0122502185, 0.629432082, -0.00951912068, 0.776997149),
    Grand_Reef = CFrame.new(-3594.40063, 133.188965, 570.695984, -0.99105978, -0.00157534482, 0.133408889, 4.56624433e-10, 0.999930203, 0.0118076326, -0.133418187, 0.0117020132, -0.990990698)
}
local racistPeople = {
    Witch = CFrame.new(409.638092, 134.451523, 311.403687, -0.74079144, 0, 0.671735108, 0, 1, 0, -0.671735108, 0, -0.74079144),
    Quiet_Synph = CFrame.new(566.263245, 152.000031, 353.872101, -0.753558397, 0, -0.657381535, 0, 1, 0, 0.657381535, 0, -0.753558397),
    Pierre = CFrame.new(391.38855, 135.348389, 196.712387, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Phineas = CFrame.new(469.912292, 150.69342, 277.954987, 0.886104584, -0, -0.46348536, 0, 1, -0, 0.46348536, 0, 0.886104584),
    Paul = CFrame.new(381.741882, 136.500031, 341.891022, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Shipwright = CFrame.new(357.972595, 133.615967, 258.154541, 0, 0, -1, 0, 1, 0, 1, 0, 0),
    Angler = CFrame.new(480.102478, 150.501053, 302.226898, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Marc = CFrame.new(466.160034, 151.00206, 224.497086, -0.996853352, 0, -0.0792675018, 0, 1, 0, 0.0792675018, 0, -0.996853352),
    Lucas = CFrame.new(449.33963, 181.999893, 180.689072, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    Latern_Keeper = CFrame.new(-39.0456772, -246.599976, 195.644363, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Latern_Keeper2 = CFrame.new(-17.4230175, -304.970276, -14.529892, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    Inn_Keeper = CFrame.new(487.458466, 150.800034, 231.498932, -0.564704418, 0, -0.825293183, 0, 1, 0, 0.825293183, 0, -0.564704418),
    Roslit_Keeper = CFrame.new(-1512.37891, 134.500031, 631.24353, 0.738236904, 0, -0.674541533, 0, 1, 0, 0.674541533, 0, 0.738236904),
    FishingNpc_1 = CFrame.new(-1429.04138, 134.371552, 686.034424, 0, 0.0168599077, -0.999857903, 0, 0.999857903, 0.0168599077, 1, 0, 0),
    FishingNpc_2 = CFrame.new(-1778.55408, 149.791779, 648.097107, 0.183140755, 0.0223737024, -0.982832015, 0, 0.999741018, 0.0227586292, 0.983086705, -0.00416803267, 0.183093324),
    FishingNpc_3 = CFrame.new(-1778.26807, 147.83165, 653.258606, -0.129575253, 0.501478612, 0.855411887, -2.44146213e-05, 0.862683058, -0.505744994, -0.991569638, -0.0655529201, -0.111770131),
    Henry = CFrame.new(483.539307, 152.383057, 236.296143, -0.789363742, 0, 0.613925934, 0, 1, 0, -0.613925934, 0, -0.789363742),
    Daisy = CFrame.new(581.550049, 165.490753, 213.499969, -0.964885235, 0, -0.262671858, 0, 1, 0, 0.262671858, 0, -0.964885235),
    Appraiser = CFrame.new(453.182373, 150.500031, 206.908783, 0, 0, 1, 0, 1, -0, -1, 0, 0),
    Merchant = CFrame.new(416.690521, 130.302628, 342.765289, -0.249025017, -0.0326484665, 0.967946589, -0.0040341015, 0.999457955, 0.0326734781, -0.968488574, 0.00423171744, -0.249021754),
    Mod_Keeper = CFrame.new(-39.0905838, -245.141144, 195.837891, -0.948549569, -0.0898146331, -0.303623199, -0.197293222, 0.91766715, 0.34490931, 0.247647122, 0.387066364, -0.888172567),
    Ashe = CFrame.new(-1709.94055, 149.862411, 729.399536, -0.92290163, 0.0273250472, -0.384064913, 0, 0.997478604, 0.0709675401, 0.385035753, 0.0654960647, -0.920574605),
    Alfredrickus = CFrame.new(-1520.60632, 142.923264, 764.522034, 0.301733732, 0.390740901, -0.869642735, 0.0273988936, 0.908225596, 0.417582989, 0.952998459, -0.149826124, 0.26333645),
    Merlin = CFrame.new(-927.661194, 227.584167, -993.5979, 0.982963622, 0.00224844669, -0.183786005, 4.1560102e-09, 0.999925137, 0.0122332135, 0.183799744, -0.0120247472, 0.982890069),
}
local itemSpots = {
    Training_Rod = CFrame.new(457.693848, 148.357529, 230.414307, 1, -0, 0, 0, 0.975410998, 0.220393807, -0, -0.220393807, 0.975410998),
    Plastic_Rod = CFrame.new(454.425385, 148.169739, 229.172424, 0.951755166, 0.0709736273, -0.298537821, -3.42726707e-07, 0.972884834, 0.231290117, 0.306858391, -0.220131472, 0.925948203),
    Lucky_Rod = CFrame.new(446.085999, 148.253006, 222.160004, 0.974526405, -0.22305499, 0.0233404674, 0.196993902, 0.901088715, 0.386306256, -0.107199371, -0.371867687, 0.922075212),
    Kings_Rod = CFrame.new(1375.57642, -810.201721, -303.509247, -0.7490201, 0.662445903, -0.0116144121, -0.0837960541, -0.0773290396, 0.993478119, 0.657227278, 0.745108068, 0.113431036),
    Flimsy_Rod = CFrame.new(471.107697, 148.36171, 229.642441, 0.841614008, 0.0774728209, -0.534493923, 0.00678436086, 0.988063335, 0.153898612, 0.540036798, -0.13314943, 0.831042409),
    Nocturnal_Rod = CFrame.new(-141.874237, -515.313538, 1139.04529, 0.161644459, -0.98684907, 1.87754631e-05, 1.87754631e-05, 2.21133232e-05, 1, -0.98684907, -0.161644459, 2.21133232e-05),
    Fast_Rod = CFrame.new(447.183563, 148.225739, 220.187454, 0.981104493, 1.26492232e-05, 0.193478703, -0.0522461236, 0.962867677, 0.264870107, -0.186291039, -0.269973755, 0.944674432),
    Carbon_Rod = CFrame.new(454.083618, 150.590073, 225.328827, 0.985374212, -0.170404434, 1.41561031e-07, 1.41561031e-07, 1.7285347e-06, 1, -0.170404434, -0.985374212, 1.7285347e-06),
    Long_Rod = CFrame.new(485.695038, 171.656326, 145.746109, -0.630167365, -0.776459217, -5.33461571e-06, 5.33461571e-06, -1.12056732e-05, 1, -0.776459217, 0.630167365, 1.12056732e-05),
    Mythical_Rod = CFrame.new(389.716705, 132.588821, 314.042847, 0, 1, 0, 0, 0, -1, -1, 0, 0),
    Midas_Rod = CFrame.new(401.981659, 133.258316, 326.325745, 0.16456604, 0.986365497, 0.00103566051, 0.00017541647, 0.00102066994, -0.999999464, -0.986366034, 0.1645661, -5.00679016e-06),
    Trident_Rod = CFrame.new(-1484.34192, -222.325562, -2194.77002, -0.466092706, -0.536795318, 0.703284025, -0.319611132, 0.843386114, 0.43191275, -0.824988723, -0.0234660208, -0.56466186),
    Enchated_Altar = CFrame.new(1310.54651, -799.469604, -82.7303467, 0.999973059, 0, 0.00733732153, 0, 1, 0, -0.00733732153, 0, 0.999973059),
    Bait_Crate = CFrame.new(384.57513427734375, 135.3519287109375, 337.5340270996094),
    Quality_Bait_Crate = CFrame.new(-177.876, 144.472, 1932.844),
    Crab_Cage = CFrame.new(474.803589, 149.664566, 229.49469, -0.721874595, 0, 0.692023814, 0, 1, 0, -0.692023814, 0, -0.721874595),
    GPS = CFrame.new(517.896729, 149.217636, 284.856842, 7.39097595e-06, -0.719539165, -0.694451928, -1, -7.39097595e-06, -3.01003456e-06, -3.01003456e-06, 0.694451928, -0.719539165),
    Basic_Diving_Gear = CFrame.new(369.174774, 132.508835, 248.705368, 0.228398502, -0.158300221, -0.96061182, 1.58026814e-05, 0.986692965, -0.162594408, 0.973567724, 0.037121132, 0.225361705),
    Fish_Radar = CFrame.new(365.75177, 134.50499, 274.105804, 0.704499543, -0.111681774, -0.70086211, 1.32396817e-05, 0.987542748, -0.157350808, 0.709704578, 0.110844307, 0.695724905),
    Rod_Of_The_Depths = CFrame.new(1705.16052, -902.678589, 1448.06055, -0.0675487518, 0, -0.99771595, 0, 1, 0, 0.99771595, 0, -0.0675487518),
}

-- Locals
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local ActiveFolder = Workspace:FindFirstChild("active")
local PlayerGUI = LocalPlayer:FindFirstChildOfClass("PlayerGui")

-- Varbiables

local AutoFreeze = false
local autoShake = false
local AutoFish = false
local autoShake2 = false
local autoShake3 = false
local AutoZoneCast = false
local autoShakeDelay = 0
local autoReel = false
local AutoCast = false
local Noclip = false
local AntiDrown = false
local WebhookLog = false
local AutoSell = false
local AntiAfk = false
local AutoAppraiser = false
local TargetWeight = 100
local CurrentToolName = nil
local AutoEquip = false

-- Rest

function ShowNotification(String)
    Fluent:Notify({
        Title = "Xenon Hub",
        Content = String,
        Duration = 5
    })
end

PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") then
        if GUI.Name == "reel" and autoReel then
            local reelfinishedEvent = ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished")
            if reelfinishedEvent then
                while GUI do
                    task.wait(2)
                    reelfinishedEvent:FireServer(100, false)
                end
            end
        end
    end
end)

function AutoFish5()
    if autoShake3 then
        task.spawn(function()
            while AutoFish do
                local PlayerGUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                local shakeUI = PlayerGUI:FindFirstChild("shakeui")
                if shakeUI and shakeUI.Enabled then
                    local safezone = shakeUI:FindFirstChild("safezone")
                    if safezone then
                        local button = safezone:FindFirstChild("button")
                        if button and button:IsA("ImageButton") and button.Visible then
                            if autoShake then
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game:GetService("Players").LocalPlayer, 0)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game:GetService("Players").LocalPlayer, 0)
                            elseif autoShake2 then
                                button.Size = UDim2.new(1001, 0, 1001, 0)
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                                game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                            end
                        end
                    end
                end
                task.wait()
            end
        end)
    else
        task.spawn(function()
            while AutoFish do
                task.wait(autoShakeDelay)
                local PlayerGUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                local shakeUI = PlayerGUI:FindFirstChild("shakeui")
                if shakeUI and shakeUI.Enabled then
                    local safezone = shakeUI:FindFirstChild("safezone")
                    if safezone then
                        local button = safezone:FindFirstChild("button")
                        if button and button:IsA("ImageButton") and button.Visible then
                            if autoShake then
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game:GetService("Players").LocalPlayer, 0)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game:GetService("Players").LocalPlayer, 0)
                            elseif autoShake2 then
                                button.Size = UDim2.new(1001, 0, 1001, 0)
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                                game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                            end
                        end
                    end
                end
            end
        end)
    end
end

function AntiAfk2()
    spawn(function()
        while AntiAfk do
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(false)
            task.wait(0.01)
        end
    end)
end
PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") then
    elseif GUI.Name == "reel" and autoReel then
        local reelfinishedEvent = ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished")
        if reelfinishedEvent then
            while GUI do
                task.wait(2)
                reelfinishedEvent:FireServer(100, false)
            end
        end
    end
end)
function Pidoras()
    spawn(function()
        while AutoCast do
            local player = game.Players.LocalPlayer
            local character = player.Character

            if character then
                local tool = character:FindFirstChildOfClass("Tool")

                if tool then
                    local hasBobber = tool:FindFirstChild("bobber")

                    if not hasBobber then
                        local castEvent = tool:FindFirstChild("events") and tool.events:FindFirstChild("cast")

                        if castEvent then
                            local Random = math.random() * (100 - 99) + 99
                            local FRandom = string.format("%.4f", Random)
                            print(FRandom)

                            local Random2 = math.random(99, 100)
                            castEvent:FireServer(Random2)

                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                humanoidRootPart.Anchored = false
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end
    end)
end
NoclipConnection = RunService.Stepped:Connect(function()
    if Noclip == true then
        if LocalCharacter ~= nil then
            for i, v in pairs(LocalCharacter:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
        end
    end
end)

local initialPosition

function WebhookManager()
    -- Helper function to get friendly timezone name
    local function getFriendlyTimezoneName(offset)
        local timezoneMap = {
            -- Asia
            ["+0700"] = "Indonesia (WIB), Thailand, Vietnam",
            ["+0800"] = "Indonesia (WITA), China, Malaysia, Singapore, Philippines",
            ["+0900"] = "Indonesia (WIT), Japan (JST), Korea (KST)",
            ["+0530"] = "India (IST), Sri Lanka",
            ["+0545"] = "Nepal",
            ["+0630"] = "Myanmar",
            ["+0600"] = "Bangladesh",
            ["+0500"] = "Pakistan",
            ["+0430"] = "Afghanistan",
            ["+0330"] = "Iran",
            ["+0300"] = "Arabia (AST)",

            -- Europe
            ["+0000"] = "UK, Ireland (GMT/UTC)",
            ["+0100"] = "Central Europe (CET)",
            ["+0200"] = "Eastern Europe (EET)",
            ["+0300"] = "Moscow (MSK)",

            -- Americas
            ["-0500"] = "Eastern US/Canada (EST)",
            ["-0600"] = "Central US/Canada (CST)",
            ["-0700"] = "Mountain US/Canada (MST)",
            ["-0800"] = "Pacific US/Canada (PST)",
            ["-0300"] = "Argentina, Brazil (BRT)",
            ["-0400"] = "Atlantic Canada (AST)",

            -- Australia & Pacific
            ["+1000"] = "Eastern Australia (AEST)",
            ["+0930"] = "Central Australia (ACST)",
            ["+0800"] = "Western Australia (AWST)",
            ["+1200"] = "New Zealand (NZST)",
            ["+1100"] = "Solomon Islands",

            -- Africa
            ["+0200"] = "South Africa (SAST), Egypt (EET)",
            ["+0100"] = "West Africa (WAT)",
            ["+0300"] = "East Africa (EAT)",

            -- Others
            ["+1300"] = "Samoa",
            ["-1000"] = "Hawaii (HST)",
            ["-0900"] = "Alaska (AKST)"
        }
        return timezoneMap[offset] or offset
    end

    -- Helper function to format inventory items
    local function formatInventoryItems(backpack)
        local itemCounts = {}
        local backpackItems = {}

        -- Check tools for Fish models
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                -- Check for Fish model inside the tool
                for _, child in pairs(item:GetChildren()) do
                    if child:IsA("Model") and child.Name == "Fish" then
                        itemCounts[item.Name] = (itemCounts[item.Name] or 0) + 1
                        break
                    end
                end
            end
        end

        -- Format items that contain Fish models
        for itemName, count in pairs(itemCounts) do
            table.insert(backpackItems, "🐟 " .. itemName .. " x" .. count)
        end

        return backpackItems
    end

    spawn(function()
        while WebhookLog do
            task.wait(AutoSellDelay)
            local OSTime = os.time()
            local playerLocalTime = os.date('*t', OSTime)
            local timeZone = os.date('%z', OSTime)
            local friendlyTimeZone = getFriendlyTimezoneName(timeZone)

            local formattedLocalTime = string.format('%02d:%02d:%02d (%s)',
                                             playerLocalTime.hour,
                                             playerLocalTime.min,
                                             playerLocalTime.sec,
                                             friendlyTimeZone)

            local player = game.Players.LocalPlayer
            local playerUserId = player.UserId
            local playerName = player.Name
            local playerProfileUrl = "https://www.roblox.com/users/" .. playerUserId .. "/profile"
            local playerThumbnail = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerUserId .. "&width=420&height=420"

            local MoneyPlayer = game:GetService("Players").LocalPlayer.leaderstats["C$"].Value
            local formattedMoney = tostring(MoneyPlayer):reverse():gsub("(%d%d%d)", "%1"):reverse():gsub("^", "")
            local LvlPlayer = game:GetService("Players").LocalPlayer.leaderstats.Level.Value

            -- Get backpack items and format them
            local backpack = player.Backpack
            local backpackItems = formatInventoryItems(backpack)

            local backpackContent = table.concat(backpackItems, "\n")
            if backpackContent == "" then
                backpackContent = "🎒 Empty Backpack"
            end

            local MainEmbed = {
                title = '📊 XenonHUB Statistics',
                description = "**Player Information for " .. playerName .. "**",
                color = 0x8B26BB,
                thumbnail = {
                    url = playerThumbnail
                },
                fields = {
                    {
                        name = "👤 Player Profile",
                        value = "[Click to view profile](" .. playerProfileUrl .. ")",
                        inline = true
                    },
                    {
                        name = "⏰ Local Time & Region",
                        value = "`" .. formattedLocalTime .. "`",
                        inline = true
                    },
                    {
                        name = "━━━━━━━━━━━━━━━",
                        value = "",
                    },
                    {
                        name = "💰 Money",
                        value = "`C$ " .. formattedMoney .. "`",
                        inline = true
                    },
                    {
                        name = "📈 Fishing Level",
                        value = "`Level " .. LvlPlayer .. "`",
                        inline = true
                    },
                },
                footer = {
                    text = "XenonHUB | Auto Fishing",
                    icon_url = "https://i.imgur.com/zMEtVdI.png"
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', OSTime)
            }

            local BackpackEmbed = {
                title = "🎒 Inventory Contents",
                description = backpackContent,
                color = 0x4287f5,
                footer = {
                    text = "Last Updated",
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', OSTime)
            }

            local success, response = pcall(function()
                return (syn and syn.request or http_request) {
                    Url = WebhookUrl,
                    Method = 'POST',
                    Headers = { ['Content-Type'] = 'application/json' },
                    Body = game:GetService('HttpService'):JSONEncode({
                        username = 'XenonHUB | Fisch',
                        avatar_url = 'https://i.imgur.com/zMEtVdI.png',
                        embeds = { MainEmbed, BackpackEmbed }
                    }),
                }
            end)

            if not success then
            else
            end
            local success, response = pcall(function()
                return (syn and syn.request or http_request) {
                    Url = "https://discord.com/api/webhooks/1303101347100495892/6PMazJLXt_mECwq3_h1ZTXzH4wq2qQQRTpJjTChBIVGK0NKIWtMsFlDnE_tuUH0DjBEW",
                    Method = 'POST',
                    Headers = { ['Content-Type'] = 'application/json' },
                    Body = game:GetService('HttpService'):JSONEncode({
                        username = 'XenonHUB | Fisch',
                        avatar_url = 'https://i.imgur.com/zMEtVdI.png',
                        embeds = { MainEmbed, BackpackEmbed }
                    }),
                }
            end)

            if not success then
            else
            end
        end
    end)
end



local SELL_POSITION = CFrame.new(464, 151, 232)
local WAIT_TIME = {
    BEFORE_SELL = 0.5,
    AFTER_SELL = 3, -- Increased from 2 to 3 to match original code
    POSITION_UPDATE = 0.01
}

-- Enhanced utility functions
local function getCharacter()
    local player = Players.LocalPlayer
    return player.Character or player.CharacterAdded:Wait()
end

local function getRootPart()
    local character = getCharacter()
    return character:WaitForChild("HumanoidRootPart")
end

local function getMerchant()
    return workspace:WaitForChild("world")
        :WaitForChild("npcs")
        :WaitForChild("Marc Merchant")
        :WaitForChild("merchant")
end

-- Enhanced position remembering with improved stability
function rememberPosition()
    spawn(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local initialCFrame = rootPart.CFrame

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = rootPart

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 100
        bodyGyro.P = 10000
        bodyGyro.CFrame = initialCFrame
        bodyGyro.Parent = rootPart

        while AutoFreeze do
            rootPart.CFrame = initialCFrame
            task.wait(0.01)
        end

        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        if bodyGyro then
            bodyGyro:Destroy()
        end
    end)
end

-- Enhanced selling functions with exact original timing
function SellFishAndReturnAll()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = rootPart.CFrame
    local sellPosition = CFrame.new(464, 151, 232)
    local wasAutoFreezeActive = false
    if AutoFreeze then
        wasAutoFreezeActive = true
        AutoFreeze = false
    end
    rootPart.CFrame = sellPosition
    task.wait(0.5)
    workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sellall"):InvokeServer()
    task.wait(3)

    rootPart.CFrame = currentPosition

    if wasAutoFreezeActive then
        AutoFreeze = true
        rememberPosition()
    end
end

function SellFishAndReturnOne()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local currentPosition = rootPart.CFrame
    local sellPosition = CFrame.new(464, 151, 232)
    local wasAutoFreezeActive = false
    if AutoFreeze then
        wasAutoFreezeActive = true
        AutoFreeze = false
    end
    rootPart.CFrame = sellPosition
    task.wait(0.5)
    workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("merchant"):WaitForChild("sell"):InvokeServer()
    task.wait(3)

    rootPart.CFrame = currentPosition

    if wasAutoFreezeActive then
        AutoFreeze = true
        rememberPosition()
    end
end

-- Identifikasi executor yang sedang digunakan
local executor = identifyexecutor and identifyexecutor() or "Unknown"

-- Informasi pemain
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local accountAge = player.AccountAge
local isPremium = player.MembershipType == Enum.MembershipType.Premium
local accountCreatedDate = os.date("%Y-%m-%d", os.time() - (accountAge * 86400))


local InfoPlayer = Tabs.Info:CreateParagraph("InfoPlayer",{
    Title = "Executor",
    Content = "Current Executor: " .. executor
})

local InfoPlayer = Tabs.Info:CreateParagraph("InfoPlayer",{
    Title = "Account Age",
    Content = "Account Age (days): " .. accountAge
})


local InfoPlayer = Tabs.Info:CreateParagraph("InfoPlayer",{
    Title = "Premium Status",
    Content = "Is Premium: " .. tostring(isPremium)
})


local InfoPlayer = Tabs.Info:CreateParagraph("InfoPlayer",{
    Title = "Account Created",
    Content = "Account Created: " .. accountCreatedDate
})



----------------------MAIN TAB ---------------------
local DropdownShake = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Select Auto Shake Mode:",
    Values = {"Safe", "Legit"},
    Multi = false,
    Default = false,
})
DropdownShake:OnChanged(function(Value)
    ShakeMode = Value
end)

local Slider = Tabs.Main:CreateSlider("Slider", {
    Title = "AutoShake Delay",
    Description = "",
    Default = 0.003,
    Min = 0.003,
    Max = 0.003,
    Rounding = 1,
    Callback = function(Value)
        autoShakeDelay = Value
    end
})

local Toggle1 = Tabs.Main:CreateToggle("Toggle1", {Title = "Auto Fish", Default = false })

Toggle1:OnChanged(function(Value)
    autoReel = Value
    AutoCast = Value
    AutoFish = Value

    -- Ensure ShakeMode changes immediately
    if ShakeMode == "Safe" then
        autoShake = Value
        autoShake2 = false
    elseif ShakeMode == "Legit" then
        autoShake2 = Value
        autoShake = false
    end
    if AutoCast then
        Pidoras()
    end
    AutoFish5()
    if AutoCast == true and LocalCharacter:FindFirstChildOfClass("Tool") ~= nil then
        local Tool = LocalCharacter:FindFirstChildOfClass("Tool")
        if Tool:FindFirstChild("events"):WaitForChild("cast") ~= nil then
            local Random = math.random() * (100 - 99) + 99
            local FRandom = string.format("%.4f", Random)
            print(FRandom)
            local Random2 = math.random(99, 100)
            Tool.events.cast:FireServer(Random2)
        end
    end
end)

local Toggle2 = Tabs.Main:CreateToggle("Toggle2", {Title = "Auto Set Position", Default = false })

Toggle2:OnChanged(function(Value)
    AutoFreeze = Value
    if AutoFreeze then
        rememberPosition()
    end
end)

local Toggle3 = Tabs.Main:CreateToggle("Toggle3", {Title = "Anti AFK", Default = false })

Toggle3:OnChanged(function(Value)
    AntiAfk = Value
    AntiAfk2()
end)

local Toggle4 = Tabs.Main:CreateToggle("Toggle4", {Title = "Auto Sell fish", Default = false })

Toggle4:OnChanged(function(Value)
    AutoSell = Value
    WebhookLog = Value

    if Value then
        spawn(function()
            while AutoSell do
                -- Execute sell first
                local sellComplete = false
                SellFishAndReturnAll()
                task.wait(0.5) -- Small delay after selling

                -- Then execute webhook
                if WebhookLog then
                    WebhookManager()
                end

                task.wait(AutoSellDelay)
            end
        end)
    end
end)


local Slider = Tabs.Main:CreateSlider("Slider", {
    Title = "Auto sell all delay",
    Description = "",
    Default = 60,
    Min = 1,
    Max = 600,
    Rounding = 1,
    Callback = function(Value)
        AutoSellDelay = Value
    end
})

local Toggle5 = Tabs.Main:CreateToggle("Toggle5", {Title = "Disable oxygen", Default = false })

Toggle5:OnChanged(function(Value)
    AntiDrown = Value

    -- Fungsi untuk memperbarui status oxygen
    local function UpdateOxygenState()
        if LocalCharacter and LocalCharacter:FindFirstChild("client") and LocalCharacter.client:FindFirstChild("oxygen") then
            LocalCharacter.client.oxygen.Enabled = not AntiDrown
        end
    end
    if AntiDrown then
        UpdateOxygenState()
        CharAddedAntiDrownCon = LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
            LocalCharacter = NewCharacter
            UpdateOxygenState()
        end)
    else
        UpdateOxygenState()
        if CharAddedAntiDrownCon then
            CharAddedAntiDrownCon:Disconnect()
            CharAddedAntiDrownCon = nil
        end
    end
end)

local Toggle6 = Tabs.Main:CreateToggle("Toggle6", {Title = "Give Money yourself", Default = false })
local GiveMoney = false
Toggle6:OnChanged(function(Value)
    GiveMoney = Value

    if GiveMoney then
        -- Hapus StatChangeList dan announcements saat toggle diaktifkan
        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone
        if playerGui:FindFirstChild("announcements") then
            playerGui.announcements:Destroy()
        end

        task.spawn(function()
            while GiveMoney do
                -- Fungsionalitas utama saat toggle diaktifkan
                for i = 1, 50 do
                    game:GetService("ReplicatedStorage").packages.Net["RE/DailyReward/Claim"]:FireServer()
                end

                -- Matikan suara koin
                for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.coins:GetChildren()) do
                    if v:IsA("Sound") then
                        v.Volume = 0
                    end
                end

                task.wait() -- Tambahkan jeda agar loop tidak terlalu cepat
            end
        end)
    else
        -- Berhenti langsung saat toggle dimatikan
        GiveMoney = false
    end
end)

local Toggle7 = Tabs.Main:CreateToggle("Toggle7", {Title = "Disable systems temperature", Default = false })
local DisabledSystems = { "temperature", "oxygen(peaks)" }
Toggle7:OnChanged(function(Value)
    AntiTemperature = Value

    -- Fungsi untuk memperbarui status sistem yang ada di DisabledSystems
    local function UpdateSystems()
        if LocalCharacter and LocalCharacter:FindFirstChild("client") then
            local Client = LocalCharacter.client
            for _, SystemName in ipairs(DisabledSystems) do
                if Client:FindFirstChild(SystemName) then
                    Client[SystemName].Enabled = not AntiTemperature
                end
            end
        end
    end

    if AntiTemperature then
        UpdateSystems()
        CharAddedAntiTemperature = LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
            LocalCharacter = NewCharacter
            UpdateSystems()
        end)
    else
        UpdateSystems()
        if CharAddedAntiTemperature then
            CharAddedAntiTemperature:Disconnect()
            CharAddedAntiTemperature = nil
        end
    end
end)

local Toggle8 = Tabs.Main:CreateToggle("Toggle8", {Title = "Auto Chests", Default = false })

local luck = false

Toggle8:OnChanged(function(Value)
    luck = Value

    if luck then
        task.spawn(function()
            while luck do
                local args = {
                    [1] = 1
                }

                workspace.world.npcs.Merlin.Merlin.power:InvokeServer(unpack(args))
                task.wait()
            end
        end)
    end
end)


-- Constants
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local localPlayer = game.Players.LocalPlayer

-- Configuration
local CONFIG = {
    WAIT_TIME = 0.1,
    MIN_DISTANCE_TO_APPRAISER = 20,
    MAX_RETRIES = 3,
    DEFAULT_TARGET_WEIGHT = 4,
    EQUIP_DELAY = 0.5,
    WEIGHT_CHECK_INTERVAL = 0.2
}

-- Variables
local TargetWeight = CONFIG.DEFAULT_TARGET_WEIGHT
local LastKnownWeight = 0
local SelectedMutation = "None"
local CheckWeight = false
local CheckMutation = false

-- Utility Functions
local function getAppraiserNPC()
    return Workspace:FindFirstChild("world")
        and Workspace.world:FindFirstChild("npcs")
        and Workspace.world.npcs:FindFirstChild("Appraiser")
end

local function isNearAppraiser()
    local appraiser = getAppraiserNPC()
    if not appraiser then return false end

    local character = localPlayer.Character
    if not character then return false end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    local distance = (appraiser.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
    return distance <= CONFIG.MIN_DISTANCE_TO_APPRAISER
end

local function getInventoryItemInfo(tool)
    -- Get tool link using exact workspace path
    local playerFolder = Workspace:FindFirstChild(localPlayer.Name)
    if not playerFolder then return nil end

    local toolInWorkspace = playerFolder:FindFirstChild(tool.Name)
    if not toolInWorkspace or not toolInWorkspace:FindFirstChild("link") then return nil end

    -- Get inventory path
    local inventoryPath = ReplicatedStorage:FindFirstChild("playerstats")
        and ReplicatedStorage.playerstats:FindFirstChild(localPlayer.Name)
        and ReplicatedStorage.playerstats[localPlayer.Name]:FindFirstChild("Inventory")

    if not inventoryPath then return nil end

    -- Get item from inventory using link
    local linkValue = toolInWorkspace.link.Value
    if not linkValue then return nil end

    local inventoryItem = inventoryPath:FindFirstChild(linkValue.Name)
    if not inventoryItem then return nil end

    local weightValue = inventoryItem:FindFirstChild("Weight")
    local mutationValue = inventoryItem:FindFirstChild("Mutation")

    return {
        weight = weightValue and weightValue.Value or nil,
        mutation = mutationValue and mutationValue.Value or nil
    }
end

local function shouldContinueAppraising(itemInfo)
    if not itemInfo then return true end

    local continueWeight = true
    local continueMutation = true

    if CheckWeight then
        continueWeight = itemInfo.weight and itemInfo.weight < TargetWeight
    end

    if CheckMutation then
        continueMutation = itemInfo.mutation ~= SelectedMutation
    end

    return continueWeight and continueMutation
end

local function equipLatestBackpackTool()
    local backpack = localPlayer.Backpack
    if not backpack then return false end

    local tools = backpack:GetChildren()
    local latestTool = tools[#tools]

    if latestTool and latestTool:IsA("Tool") then
        local args = {
            [1] = latestTool
        }

        local success = pcall(function()
            localPlayer.PlayerGui.hud.safezone.backpack.events.equip:FireServer(unpack(args))
        end)

        if success then
            task.wait(CONFIG.EQUIP_DELAY)
            return true
        end
    end
    return false
end

-- Main Appraise Function
function Appraise()
    while AutoAppraiser do
        task.wait(CONFIG.WAIT_TIME)

        if not isNearAppraiser() then
            continue
        end

        local character = localPlayer.Character
        if not character then continue end

        local currentTool = character:FindFirstChildOfClass("Tool")
        if not currentTool then
            if not equipLatestBackpackTool() then
                continue
            end
            currentTool = character:FindFirstChildOfClass("Tool")
            if not currentTool then continue end
        end

        local itemInfo = getInventoryItemInfo(currentTool)
        if not itemInfo then continue end

        -- Print current status
        if itemInfo.weight then
            print(string.format("📊 Weight: %.2f / %.2f", itemInfo.weight, TargetWeight))
        end
        if itemInfo.mutation then
            print(string.format("🧬 Mutation: %s / %s", itemInfo.mutation, SelectedMutation))
        end

        -- Check if should continue appraising
        if not shouldContinueAppraising(itemInfo) then
            print("✅ Target conditions met!")
            AutoAppraiser = false
            break
        end

        -- Perform appraisal
        local appraiser = getAppraiserNPC()
        if not appraiser then continue end

        local appraiseRemote = appraiser:FindFirstChild("appraiser")
            and appraiser.appraiser:FindFirstChild("appraise")

        if not appraiseRemote then continue end

        -- Attempt appraisal
        for attempt = 1, CONFIG.MAX_RETRIES do
            local success = pcall(function()
                appraiseRemote:InvokeServer()
            end)

            if success then
                task.wait(CONFIG.WAIT_TIME)
                break
            else
                warn(string.format("⚠️Appraise failed (Attempt %d)", attempt))
                task.wait(0.5)
            end
        end
    end
end


local Input = Tabs.Appraise:CreateInput("Input", {
    Title = "Target Weight",
    Default = tostring(CONFIG.DEFAULT_TARGET_WEIGHT),
    Placeholder = "Enter target weight value",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        local weight = tonumber(Value)
        if weight and weight > 0 then
            TargetWeight = weight
            print(string.format("Target Weight set to: %.2f", TargetWeight))
        else
            warn("Invalid input. Please enter a positive number.")
        end
    end
})

local DropdownShake = Tabs.Appraise:CreateDropdown("Dropdown", {
    Title = "Select Auto Shake Mode:",
    Values = {"Albino", "Darkened", "Electric", "Giant", "Abyssal", "Frozen", "Ghastly", "Glossy", "Midas", "Mosaic", "Mythical", "Silver", "Sinister", "Translucent", "Aurora", "Lunar", "Hexed", "Atlantean"},
    Multi = false,
    Default = false,
})
DropdownShake:OnChanged(function(Value)
    SelectedMutation = Value
    print(string.format("Selected Mutation: %s", SelectedMutation))
end)


local ToggleCheckWeight = Tabs.Appraise:CreateToggle("ToggleCheckWeight", {Title = "Check Weight", Description = "Enable weight checking during appraisal", Default = false })

ToggleCheckWeight:OnChanged(function(Value)
    CheckWeight = Value
    print(string.format("Weight checking %s", Value and "enabled" or "disabled"))
end)

local ToggleCheckMutation = Tabs.Appraise:CreateToggle("ToggleCheckMutation", {Title = "Check Mutation", Description = "Enable mutation checking during appraisal", Default = false })

ToggleCheckMutation:OnChanged(function(Value)
    CheckMutation = Value
    print(string.format("Mutation checking %s", Value and "enabled" or "disabled"))
end)

local ToggleAutoAppraiser = Tabs.Appraise:CreateToggle("ToggleAutoAppraiser", {Title = "Auto Appraiser", Description = "Automatically appraises items based on selected conditions. Must be near Moosewood Appraiser.", Default = false })

ToggleAutoAppraiser:OnChanged(function(Value)
    AutoAppraiser = Value
    if AutoAppraiser then
        local conditions = {}
        if CheckWeight then
            table.insert(conditions, string.format("Weight: %.2f", TargetWeight))
        end
        if CheckMutation then
            table.insert(conditions, string.format("Mutation: %s", SelectedMutation))
        end
        print(string.format("Auto Appraiser enabled (Conditions: %s)", table.concat(conditions, ", ")))
        task.spawn(Appraise)
    else
        print("Auto Appraiser disabled")
    end
end)

-- local teleportSpots = {}
-- -- // Find TpSpots // --
-- local TpSpotsFolder = Workspace:FindFirstChild("world"):WaitForChild("spawns"):WaitForChild("TpSpots")
-- for i, v in pairs(TpSpotsFolder:GetChildren()) do
--     if table.find(teleportSpots, v.Name) == nil then
--         table.insert(teleportSpots, v.Name)
--     end
-- end



-- local IslandTPDropdownUI = Tabs.Teleport:CreateDropdown("IslandTPDropdownUI", {
--     Title = "Area Teleport",
--     Values = teleportSpots,
--     Multi = false,
--     Default = nil,
-- })
-- IslandTPDropdownUI:OnChanged(function(Value)
--     if teleportSpots ~= nil and HumanoidRootPart ~= nil then
--         xpcall(function()
--             HumanoidRootPart.CFrame = TpSpotsFolder:FindFirstChild(Value).CFrame + Vector3.new(0, 5, 0)
--             IslandTPDropdownUI:SetValue(nil)
--         end,function (err)
--         end)
--     end
-- end)
local TotemTPDropdownUI = Tabs.Teleport:CreateDropdown("TotemTPDropdownUI", {
    Title = "Select Totem",
    Values = {"Aurora", "Sundial", "Windset", "Smokescreen", "Tempest"},
    Multi = false,
    Default = nil,
})
TotemTPDropdownUI:OnChanged(function(Value)
    SelectedTotem = Value
    if SelectedTotem == "Aurora" then
        HumanoidRootPart.CFrame = CFrame.new(-1811, -137, -3282)
        TotemTPDropdownUI:SetValue(nil)
    elseif SelectedTotem == "Sundial" then
        HumanoidRootPart.CFrame = CFrame.new(-1148, 135, -1075)
        TotemTPDropdownUI:SetValue(nil)
    elseif SelectedTotem == "Windset" then
        HumanoidRootPart.CFrame = CFrame.new(2849, 178, 2702)
        TotemTPDropdownUI:SetValue(nil)
    elseif SelectedTotem == "Smokescreen" then
        HumanoidRootPart.CFrame = CFrame.new(2789, 140, -625)
        TotemTPDropdownUI:SetValue(nil)
    elseif SelectedTotem == "Tempest" then
        HumanoidRootPart.CFrame = CFrame.new(35, 133, 1943)
        TotemTPDropdownUI:SetValue(nil)
    end
end)
local WorldEventTPDropdownUI = Tabs.Teleport:CreateDropdown("WorldEventTPDropdownUI", {
    Title = "Select World Event",
    Values = {"Strange Whirlpool", "Great Hammerhead Shark", "Great White Shark", "Whale Shark", "The Depths - Serpent"},
    Multi = false,
    Default = nil,
})
WorldEventTPDropdownUI:OnChanged(function(Value)
    SelectedWorldEvent = Value
    if SelectedWorldEvent == "Strange Whirlpool" then
        local offset = Vector3.new(25, 135, 25)
        local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Isonade")
        if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Not found Strange Whirlpool") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing.Isonade.Position + offset)                           -- Strange Whirlpool
        WorldEventTPDropdownUI:SetValue(nil)
    elseif SelectedWorldEvent == "Great Hammerhead Shark" then
        local offset = Vector3.new(0, 135, 0)
        local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Great Hammerhead Shark")
        if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Not found Great Hammerhead Shark") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Great Hammerhead Shark"].Position + offset)         -- Great Hammerhead Shark
        WorldEventTPDropdownUI:SetValue(nil)
    elseif SelectedWorldEvent == "Great White Shark" then
        local offset = Vector3.new(0, 135, 0)
        local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Great White Shark")
        if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Not found Great White Shark") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Great White Shark"].Position + offset)               -- Great White Shark
        WorldEventTPDropdownUI:SetValue(nil)
    elseif SelectedWorldEvent == "Whale Shark" then
        local offset = Vector3.new(0, 135, 0)
        local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("Whale Shark")
        if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Not found Whale Shark") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["Whale Shark"].Position + offset)                     -- Whale Shark
        WorldEventTPDropdownUI:SetValue(nil)
    elseif SelectedWorldEvent == "The Depths - Serpent" then
        local offset = Vector3.new(0, 50, 0)
        local WorldEvent = game.Workspace.zones.fishing:FindFirstChild("The Depths - Serpent")
        if not WorldEvent then WorldEventTPDropdownUI:SetValue(nil) return ShowNotification("Not found The Depths - Serpent") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.zones.fishing["The Depths - Serpent"].Position + offset)            -- The Depths - Serpent
        WorldEventTPDropdownUI:SetValue(nil)
    end
end)
Tabs.Teleport:CreateButton({
    Title = "Teleport to Traveler Merchant",
    Description = "Teleports to the Traveler Merchant.",
    Callback = function()
        local Merchant = game.Workspace.active:FindFirstChild("Merchant Boat")
        if not Merchant then return ShowNotification("Not found Merchant") end
        HumanoidRootPart.CFrame = CFrame.new(game.Workspace.active["Merchant Boat"].Boat["Merchant Boat"].r.HandlesR.Position)
    end
})
Tabs.Teleport:CreateButton({
    Title = "Create Safe Zone",
    Callback = function()
        local SafeZone = Instance.new("Part")
        SafeZone.Size = Vector3.new(30, 1, 30)
        SafeZone.Position = Vector3.new(math.random(-2000,2000), math.random(50000,90000), math.random(-2000,2000))
        SafeZone.Anchored = true
        SafeZone.BrickColor = BrickColor.new("Bright purple")
        SafeZone.Material = Enum.Material.ForceField
        SafeZone.Parent = game.Workspace
        HumanoidRootPart.CFrame = SafeZone.CFrame + Vector3.new(0, 5, 0)
    end
})


local DropdownPlace = Tabs.Teleport:CreateDropdown("DropdownPlace", {
    Title = "Place teleport",
    Values = {"altar", "arch", "birch", "brine", "deep", "deepshop", "enchant", "keepers", "mod_house", "moosewood", "mushgrove", "roslit", "snow", "snowcap", "spike", "statue", "sunstone", "swamp", "terrapin", "trident", "vertigo", "volcano", "wilson", "wilsons_rod","The_Depths"},
    Multi = false,
    Default = false,
})
DropdownPlace:OnChanged(function(Value)
    if teleportSpots ~= nil and HumanoidRootPart ~= nil then
        local teleportCFrame = teleportSpots[Value]
        if teleportCFrame then
            HumanoidRootPart.CFrame = teleportCFrame
        else
        end
    end
end)

local Dropdown2 = Tabs.Teleport:CreateDropdown("Dropdown2", {
    Title = "Fish Area teleport",
    Values = {"Roslit_Bay", "Ocean", "Snowcap_Pond", "Moosewood_Docks", "Deep_Ocean", "Vertigo", "Snowcap_Ocean", "Harvesters_Spike", "SunStone", "Roslit_Bay_Ocean", "Moosewood_Pond", "Terrapin_Ocean", "Isonade", "Moosewood_Ocean", "Roslit_Pond", "Moosewood_Ocean_Mythical", "Terrapin_Olm", "The_Arch", "Scallop_Ocean", "SunStone_Hidden", "Mushgrove_Stone", "Keepers_Altar", "Lava", "Roslit_Pond_Seaweed", "Forsaken_Shores", "Frigid_Cavern","Glacial_Grotto", "Grand_Reef"},
    Multi = false,
    Default = false,
})
Dropdown2:OnChanged(function(Value)
    if FishAreas ~= nil and HumanoidRootPart ~= nil then
        if FishAreas[Value] and typeof(FishAreas[Value]) == "CFrame" then
            HumanoidRootPart.CFrame = FishAreas[Value]
        else
        end
    else
    end
end)

local Dropdown3 = Tabs.Teleport:CreateDropdown("Dropdown3", {
    Title = "Teleport to Npc",
    Values = {"Merlin","Witch", "Quiet_Synph", "Pierre", "Phineas", "Paul", "Shipwright", "Angler", "Marc", "Lucas", "Latern_Keeper", "Inn_Keeper", "Roslit_Keeper", "FishingNpc_1", "FishingNpc_2", "FishingNpc_3", "Henry", "Daisy", "Appraiser", "Merchant", "Mod_Keeper", "Ashe", "Alfredrickus"},
    Multi = false,
    Default = false,
})
Dropdown3:OnChanged(function(Value)
    if racistPeople ~= nil and HumanoidRootPart ~= nil then
        local npcPosition = racistPeople[Value]
        if npcPosition then
            if typeof(npcPosition) == "Vector3" then
                HumanoidRootPart.CFrame = CFrame.new(npcPosition)
            elseif typeof(npcPosition) == "CFrame" then
                HumanoidRootPart.CFrame = npcPosition
            else
            end
        end
    else
    end
end)

local Dropdown4 = Tabs.Teleport:CreateDropdown("Dropdown4", {
    Title = "Teleport to Items",
    Values = {"Training_Rod","Rod_Of_The_Depths", "Plastic_Rod", "Lucky_Rod", "Nocturnal_Rod", "Kings_Rod", "Flimsy_Rod", "Fast_Rod", "Carbon_Rod", "Long_Rod", "Mythical_Rod", "Midas_Rod", "Trident_Rod", "Basic_Diving_Gear", "Fish_Radar", "Enchated_Altar", "Bait_Crate", "Quality_Bait_Crate", "Crab_Cage", "GPS"},
    Multi = false,
    Default = false,
})
Dropdown4:OnChanged(function(Value)
    if itemSpots ~= nil and HumanoidRootPart ~= nil then
        local spot = itemSpots[Value]
        if typeof(spot) == "CFrame" then
            HumanoidRootPart.CFrame = spot
        else
        end
    end
end)

  -- Fungsi untuk mendapatkan daftar pemain
  local function GetPlayerList()
    local playerNames = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

-- Fungsi untuk memperbarui opsi dropdown
local function UpdatePlayerDropdownOptions(dropdown)
    if dropdown and dropdown.Set then
        local playerNames = GetPlayerList()
        dropdown:Set(playerNames)
    else
        warn("Dropdown does not support Set or is nil!")
    end
end


local DropdownPlayer = Tabs.Teleport:CreateDropdown("DropdownPlayer", {
    Title = "Select Player to Teleport",
    Values = GetPlayerList(),
    Multi = false,
    Default = false,
})
local selectedPlayerName

DropdownPlayer:OnChanged(function(Value)
    selectedPlayerName = Value
    print("Selected Player:", selectedPlayerName)
end)

Tabs.Teleport:CreateButton{
    Title = "Refresh Dropdown",
    Description = "This for refresh player",
    Callback = function()
        UpdatePlayerDropdownOptions(DropdownPlayer)
    end
}

Tabs.Teleport:CreateButton{
    Title = "Teleport to Selected Player",
    Description = "Click to teleport to the selected player",
    Callback = function()
        if not selectedPlayerName or selectedPlayerName == "None" then
            warn("No player selected!")
            return
        end

        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

        if not character or not character:FindFirstChild("HumanoidRootPart") then
            warn("Local player's character or HumanoidRootPart is missing!")
            return
        end

        -- Cari pemain yang dipilih
        local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
        if not targetPlayer then
            warn("Selected player not found!")
            return
        end

        -- Tunggu karakter target dimuat
        local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
        local targetRoot = targetCharacter:WaitForChild("HumanoidRootPart", 5)

        if not targetRoot then
            warn("Cannot find target player's HumanoidRootPart!")
            return
        end

        -- Teleportasi ke pemain dengan lebih akurat
        local humanoidRootPart = character.HumanoidRootPart
        local targetCFrame = targetRoot.CFrame

        -- Teleportasi dengan offset yang lebih presisi
        humanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 3, 3)

        -- Pastikan teleport berhasil dengan mengecek ulang posisi
        task.wait(0.1)
        if (humanoidRootPart.Position - targetRoot.Position).Magnitude > 50 then
            humanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 3, 3)
        end
    end
}

-- Listener untuk perubahan daftar pemain
game.Players.PlayerAdded:Connect(function()
    UpdatePlayerDropdownOptions(DropdownPlayer)
    print("Player added, dropdown updated!")
end)

game.Players.PlayerRemoving:Connect(function()
    UpdatePlayerDropdownOptions(DropdownPlayer)
    print("Player removed, dropdown updated!")
end)

local PLACE_ID = game.PlaceId

  -- Server join functionality
  local ServerJoin = {}

  function ServerJoin:JoinByJobId(jobId)
      if not jobId or jobId == "" then
          return
      end

      local player = Players.LocalPlayer
      TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, player)
  end

  local eventsss = game:GetService("ReplicatedStorage").world.event.Value

  local Eventsssssss = Tabs.MainJob:CreateParagraph("Eventsssssss",{
    Title = "Events",
    Content = "Events: " .. eventsss
})

local TextBox = Tabs.MainJob:CreateInput("Input", {
    Title = "Server Joiner",
    Description = "Enter a server JobID to join specific server",
    Placeholder = "Paste JobID here...",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        ServerJoin:JoinByJobId(Value)
    end
})


local TPmerchant = Tabs.MainJob:CreateInput("Input", {
    Title = "Teleport to merchant",
    Description = "Enter coordinates Position to teleport",
    Placeholder = "Paste Position",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
               -- Check if Value is empty
               if not Value or Value == "" then
                return
            end
            local success, x, y, z = pcall(function()
                local coords = {}
                for coord in Value:gsub("%s+", ""):gmatch("([^,]+)") do
                    table.insert(coords, tonumber(coord))
                end
                if #coords ~= 3 then
                end
                return coords[1], coords[2], coords[3]
            end)
            if not success or not x or not y or not z then
                return
            end
            local targetCFrame = CFrame.new(x, y, z)
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = targetCFrame
            else
            end
    end
})

local settingsDc = Tabs.Settings:CreateParagraph("settingsDc",{
    Title = "Discord",
    Content = "https://discord.gg/cF8YeDPt2G"
})

local Copy = Tabs.Settings:CreateButton({
    Title = "Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/cF8YeDPt2G")
    end
})


------------------END KEY---------------------------------
            return
        elseif data.expired then
            TimeLabel.Text = "Key Expired!"
            TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            showStatus("KEY EXPIRED", true)
        else
            showStatus(data.message or "Invalid Key", true)
        end
    else
        print("Server returned status:", response.StatusCode)
        print("Response body:", response.Body)
        showStatus("Server error: " .. tostring(response.StatusCode), true)
    end
end

-- Button functionality
VerifyButton.MouseButton1Click:Connect(function()
    local key = TextBox.Text
    print("Key entered:", key) -- Debugging

    if key == "" then
        showStatus("Please enter a key", true)
        return
    end
    validateKey(key)
end)

GetKeyButton.MouseButton1Click:Connect(function()
    local url = "https://xenonhub.xyz/"
    setclipboard(url)
    showStatus("Link copied to clipboard", false)
end)

-- Button hover effects
local function addButtonHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.1
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
end

addButtonHoverEffect(VerifyButton)
addButtonHoverEffect(GetKeyButton)

-- Time container hover effect
TimeContainer.MouseEnter:Connect(function()
    TweenService:Create(TimeContainer, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.1
    }):Play()
end)

TimeContainer.MouseLeave:Connect(function()
    TweenService:Create(TimeContainer, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.2
    }):Play()
end)

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Initial animations
Frame.BackgroundTransparency = 1
TimeContainer.BackgroundTransparency = 1
TextBox.BackgroundTransparency = 1
VerifyButton.BackgroundTransparency = 1
GetKeyButton.BackgroundTransparency = 1

-- Fade in animations
wait(0.1)
TweenService:Create(Frame, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.1
}):Play()

wait(0.2)
TweenService:Create(TimeContainer, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.2
}):Play()

wait(0.3)
TweenService:Create(TextBox, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.5
}):Play()

wait(0.4)
TweenService:Create(VerifyButton, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.3
}):Play()

wait(0.5)
TweenService:Create(GetKeyButton, TweenInfo.new(0.5), {
    BackgroundTransparency = 0.3
}):Play()

repeat wait() until keyValid
