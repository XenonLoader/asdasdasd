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
local vu = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer
-- local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
-- local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
-- local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")
local Connections = {}
local function HandleConnection(connection, name)
    if typeof(connection) ~= "RBXScriptConnection" then
        return
    end
    -- Disconnect existing connection if it exists
    if Connections[name] and typeof(Connections[name]) == "RBXScriptConnection" then
        Connections[name]:Disconnect()
    end
    -- Store new connection
    Connections[name] = connection
end

local OriginalPlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local PlaceName = OriginalPlaceName

local Window = Fluent:CreateWindow({
    Title = `Xenon | {PlaceName}`,
    SubTitle = "https://discord.gg/3ZQBHpfQ5X",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
    Main = Window:CreateTab({ Title = "Main", Icon = "house" }),
    Settingss = Window:CreateTab({ Title = "Misc", Icon = "info" })
}
-- Anti-AFK System
LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

local vu = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK System
LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Fungsi untuk kick player jika ada staff masuk
local function handleStaffCheck(player)
    if player:GetRankInGroup(11987919) > 149 then
        LocalPlayer:Kick("Auto Kicked: Staff Member " .. player.Name .. " joined your game.")
    end
end

-- Kick jika staff sudah ada di game saat script dijalankan
for _, player in ipairs(Players:GetPlayers()) do
    handleStaffCheck(player)
end

-- Kick jika ada player baru yang masuk dan ternyata staff
Players.PlayerAdded:Connect(function(player)
    handleStaffCheck(player)
end)

-- Looping tambahan untuk pengecekan setiap 5 detik
spawn(function()
    while true do
        wait(5)
        for _, player in ipairs(Players:GetPlayers()) do
            handleStaffCheck(player)
        end
    end
end)

local Togglemoney = Tabs.Main:CreateToggle("Togglemoney", {Title = "Auto Get Money", Default = false})

Togglemoney:OnChanged(function(state)
    getfenv().test2 = (state and true or false)
    pcall(function()
        game:GetService("ReplicatedStorage").Quests.Contracts.CancelContract:InvokeServer(game:GetService("Players").LocalPlayer.ActiveQuests:FindFirstChildOfClass("StringValue").Name)
        game:GetService("ReplicatedStorage").Quests.Contracts.CancelContract:InvokeServer(game:GetService("Players").LocalPlayer.ActiveQuests:FindFirstChildOfClass("StringValue").Name)
        end)
        while getfenv().test2 do
            wait()
            if not  game:GetService("Players").LocalPlayer.ActiveQuests:FindFirstChild("contractBuildMaterial") then
                game:GetService("ReplicatedStorage").Quests.Contracts.StartContract:InvokeServer("contractBuildMaterial")
        repeat task.wait()
        until game:GetService("Players").LocalPlayer.ActiveQuests:FindFirstChild("contractBuildMaterial")
            end
        repeat task.wait()
        task.spawn(function()
        game:GetService("ReplicatedStorage").Quests.DeliveryComplete:InvokeServer("contractMaterial")
        game:GetService("ReplicatedStorage").Quests.DeliveryComplete:InvokeServer("contractMaterial")
        game:GetService("ReplicatedStorage").Quests.DeliveryComplete:InvokeServer("contractMaterial")
        end)
        until game:GetService("Players").LocalPlayer.ActiveQuests.contractBuildMaterial.Value == "!pw5pi3ps2"
        wait()
        game:GetService("ReplicatedStorage").Quests.Contracts.CompleteContract:InvokeServer()
        end
end)

local Togglecustomer = Tabs.Main:CreateToggle("Togglecustomer", {Title = "Auto Customer", Default = false})

Togglecustomer:OnChanged(function(state)
    getfenv().customersfarm = state

    -- Clear existing objects
    pcall(function()
        game:GetService("Workspace").GaragePlate:Destroy()
    end)

    for _, v in pairs(game:GetService("Workspace").World.Industrial.Port:GetChildren()) do
        if string.find(v.Name, "Container") then
            v:Destroy()
        end
    end

    -- Initialize variables
    local player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    getfenv().numbers = 0
    getfenv().stuck = 0
    local testvalue = 1
    local ohsoso = false
    local antiban = 0
    local waterCheckCooldown = 0
    local canTeleport = true  -- Debounce for teleportation

    while getfenv().customersfarm do
        task.wait()
        pcall(function()
            local character = player.Character
            if not character then return end

            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end

            local seatPart = humanoid.SeatPart

            if seatPart then
                local car = seatPart.Parent.Parent
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {character, car, workspace.Camera}
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.IgnoreWater = false

                -- Water detection and recovery system with improved teleportation
                local waterRaycast = workspace:Raycast(car.PrimaryPart.Position, Vector3.new(0, -10, 0), raycastParams)
                if waterRaycast and waterRaycast.Material == Enum.Material.Water and waterCheckCooldown <= 0 then
                    local closestRoad = nil
                    local minDistance = math.huge

                    for _, road in pairs(workspace.World:GetDescendants()) do
                        if road:IsA("Part") and string.find(road.Name:lower(), "road") then
                            local distance = (road.Position - car.PrimaryPart.Position).Magnitude
                            if distance < minDistance then
                                closestRoad = road
                                minDistance = distance
                            end
                        end
                    end

                    if closestRoad and canTeleport then
                        canTeleport = false
                        car:SetPrimaryPartCFrame(closestRoad.CFrame + Vector3.new(0, 5, 0))
                        car.PrimaryPart.Velocity = Vector3.zero
                        waterCheckCooldown = 60
                        task.wait(1)
                        canTeleport = true
                    end
                end

                if waterCheckCooldown > 0 then
                    waterCheckCooldown = waterCheckCooldown - 1
                end

                -- Mission handling with improved teleportation
                if player.variables.inMission.Value then
                    local destinationPart = workspace.ParkingMarkers:FindFirstChild("destinationPart")

                    if not destinationPart then
                        antiban = antiban + 1
                        if antiban > 10 then
                            player:Kick("Safety disconnect - mission error detected")
                            return
                        end
                        task.wait(1)
                    else
                        antiban = 0

                        -- Improved teleportation to destination
                        if player:DistanceFromCharacter(destinationPart.Position) < 50 and canTeleport then
                            canTeleport = false

                            -- Safe teleportation function
                            local function safeTeleport()
                                if not car.PrimaryPart.Anchored then
                                    local targetCFrame = destinationPart.CFrame + Vector3.new(0, 3, 0)
                                    car:SetPrimaryPartCFrame(targetCFrame)
                                    car.PrimaryPart.Velocity = Vector3.zero
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 304, false, game)
                                    task.wait(0.1)
                                end
                            end

                            safeTeleport()
                            task.wait(1)
                            safeTeleport()

                            -- Ensure proper parking with retry mechanism
                            local dcframe = destinationPart.CFrame
                            local retryCount = 0
                            local maxRetries = 5

                            repeat
                                task.wait()
                                if (car.PrimaryPart.Position - dcframe.Position).magnitude > 3 then
                                    car.PrimaryPart.Velocity = Vector3.zero
                                    car:PivotTo(dcframe)
                                    task.wait(0.1)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, 304, false, game)
                                    retryCount = retryCount + 1
                                end
                            until not workspace.ParkingMarkers:FindFirstChild("destinationPart")
                                or not getfenv().customersfarm
                                or retryCount >= maxRetries

                            game:GetService("VirtualInputManager"):SendKeyEvent(false, 304, false, game)
                            getfenv().numbers = getfenv().numbers + 1
                            testvalue = 1
                            canTeleport = true
                        else
                            -- Improved pathfinding
                            testvalue = testvalue - 0.02
                            if testvalue < 0 then
                                local closestRoad = nil
                                local minDistance = math.huge

                                for _, road in pairs(workspace.World:GetDescendants()) do
                                    if road:IsA("Part") and string.find(road.Name:lower(), "road") then
                                        local distance = (character.HumanoidRootPart.Position - road.Position).magnitude
                                        if distance < minDistance then
                                            closestRoad = road
                                            minDistance = distance
                                        end
                                    end
                                end

                                if closestRoad and canTeleport then
                                    canTeleport = false
                                    car:PivotTo(closestRoad.CFrame)
                                    getfenv().stuck = getfenv().stuck + 1
                                    testvalue = 1
                                    task.wait(1)
                                    canTeleport = true
                                end
                            end

                            -- Smart pathfinding with error handling
                            pcall(function()
                                if not canTeleport then return end

                                local part1 = character.HumanoidRootPart
                                local part2 = destinationPart
                                local destination = part1.CFrame:lerp(part2.CFrame, testvalue)
                                local targetPos = Vector3.new(destination.X, part2.Position.Y, destination.Z)

                                local path = PathfindingService:CreatePath({
                                    AgentRadius = 20,
                                    AgentHeight = 10,
                                    AgentCanJump = true
                                })

                                path:ComputeAsync(car.PrimaryPart.Position, targetPos)
                                local waypoints = path:GetWaypoints()

                                for _, waypoint in ipairs(waypoints) do
                                    if not getfenv().customersfarm then break end

                                    local heightCheck = workspace:Raycast(waypoint.Position, Vector3.new(0, 1000, 0), raycastParams)
                                    if not heightCheck and canTeleport then
                                        canTeleport = false
                                        car:PivotTo(CFrame.new(waypoint.Position) + Vector3.new(0, 15, 0))
                                        testvalue = 1
                                        task.wait(0.009)
                                        canTeleport = true
                                    else
                                        testvalue = 1
                                    end
                                end
                            end)
                        end
                    end
                else
                    -- Find and pick up new customers with improved logic
                    local closestCustomer, minDistance = nil, math.huge

                    for _, customer in pairs(workspace.NewCustomers:GetDescendants()) do
                        if customer.Name == "Part" and
                           customer:GetAttribute("GroupSize") and
                           customer:FindFirstChildOfClass("CFrameValue") and
                           player.variables.seatAmount.Value > customer:GetAttribute("GroupSize") and
                           customer:GetAttribute("Rating") < player.variables.vehicleRating.Value then

                            local distance = (customer.Position - customer:FindFirstChildOfClass("CFrameValue").Value.Position).magnitude
                            if distance < minDistance then
                                closestCustomer = customer
                                minDistance = distance
                            end
                        end
                    end

                    if closestCustomer and canTeleport then
                        for _, vehicle in pairs(workspace.Vehicles:GetDescendants()) do
                            if vehicle.Name == "Player" and vehicle.Value == player then
                                canTeleport = false
                                vehicle.Parent.Parent:SetPrimaryPartCFrame(closestCustomer.CFrame * CFrame.new(0, 3, 0))
                                task.wait(1)
                                fireproximityprompt(closestCustomer.Client.PromptPart.CustomerPrompt)
                                task.wait(3)
                                canTeleport = true
                            end
                        end
                    end
                end
            else
                -- Enter vehicle if not seated
                game:GetService("ReplicatedStorage").Vehicles.GetNearestSpot:InvokeServer(player.variables.carId.Value)
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Vehicles.EnterVehicleEvent:InvokeServer()
            end
        end)
    end
end)

local Togglemedal = Tabs.Main :CreateToggle("Togglemedal", {Title = "Auto medal", Default = false})

Togglemedal:OnChanged(function(state)
    getfenv().medals = (state and true or false)
    game:GetService("ReplicatedStorage").Race.LeaveRace:InvokeServer()
    while getfenv().medals  do
         task.wait()
   if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
     for round=1,3 do
     for what,races in pairs(game:GetService("Workspace").Races:GetChildren()) do
       if races.ClassName == "Folder" and getfenv().medals then
  game:GetService("ReplicatedStorage").Race.TimeTrial:InvokeServer(races.Name, round)
  wait()
  if game:GetService("Players").LocalPlayer.variables.race.Value == "none" then
     task.wait()
  game:GetService("ReplicatedStorage").Race.TimeTrial:InvokeServer(races.Name, round)
  else
     for a,b in pairs(game:GetService("Workspace").Vehicles:GetDescendants()) do
     if b.Name == "Player" and b.Value == game.Players.LocalPlayer then
   repeat wait()
  for i,v in pairs(game:GetService("Workspace").Races[races.Name].detects:GetChildren()) do
     if v.ClassName == "Part" and v:FindFirstChild("TouchInterest") then
        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
         firetouchinterest(b.Parent.Parent.PrimaryPart,v,0)
                 firetouchinterest(b.Parent.Parent.PrimaryPart,v,1)
     end
  end
  until game:GetService("Workspace").Races[races.Name].timeTrial:FindFirstChildOfClass("IntValue") or getfenv().medals == false
  repeat wait()
   for i,v in pairs(game:GetService("Workspace").Races[races.Name].detects:GetChildren()) do
     if v.ClassName == "Part" and v:FindFirstChild("TouchInterest") then
        v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
         firetouchinterest(b.Parent.Parent.PrimaryPart,v,0)
                 firetouchinterest(b.Parent.Parent.PrimaryPart,v,1)
     end
  end
   pcall(function()
   game:GetService("Workspace").Races[races.Name].timeTrial:FindFirstChildOfClass("IntValue").finish.CFrame=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
  firetouchinterest(b.Parent.Parent.PrimaryPart,game:GetService("Workspace").Races[races.Name].timeTrial:FindFirstChildOfClass("IntValue").finish,0)
                 firetouchinterest(b.Parent.Parent.PrimaryPart,game:GetService("Workspace").Races[races.Name].timeTrial:FindFirstChildOfClass("IntValue").finish,1)
  end)
  until game:GetService("Players").LocalPlayer.variables.race.Value == "none" or getfenv().medals == false
  end
  end
  end

  end
  end
  end
  elseif game.Players.LocalPlayer.Character.Humanoid.Sit == false then
     game:GetService("ReplicatedStorage").Vehicles.GetNearestSpot:InvokeServer(game:GetService("Players").LocalPlayer.variables.carId.Value)
     wait(0.5)
     game:GetService("ReplicatedStorage").Vehicles.EnterVehicleEvent:InvokeServer()
  end
     end
end)

local ToggleTrophies = Tabs.Main:CreateToggle("ToggleTrophies", {Title = "Auto Trophies", Default = false})


ToggleTrophies:OnChanged(function(state)
    getfenv().Trophies = state
    game:GetService("ReplicatedStorage").Race.LeaveRace:InvokeServer()
    getfenv().showui = getfenv().Trophies

    -- Spawn fungsi untuk menampilkan atau menghapus label 'Rep'
    spawn(function()
        local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
        local MoneyGui = PlayerGui.ScreenGui.Money

        if not getfenv().showui and MoneyGui:FindFirstChild("Rep") then
            MoneyGui.Rep:Destroy()
        else
            while getfenv().showui do
                task.wait()
                if not MoneyGui:FindFirstChild("Rep") then
                    local clonedLabel = MoneyGui.CashLabel:Clone()
                    clonedLabel.Name = "Rep"
                    clonedLabel.Parent = MoneyGui
                    clonedLabel.Position = UDim2.new(3, 0, 0, 0)
                end
                SectionRep:Set("🏆:" .. tostring(game:GetService("Players").LocalPlayer.variables.rep.Value))
                MoneyGui.Rep.Text = "🏆:" .. tostring(game:GetService("Players").LocalPlayer.variables.rep.Value)
            end
        end
    end)

    -- Loop utama untuk fitur 'Auto Trophies'
    spawn(function()
        while getfenv().Trophies do
            task.wait()
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Sit then
                    if player.variables.race.Value == "none" then
                        task.wait()
                        game:GetService("ReplicatedStorage").Race.TimeTrial:InvokeServer("circuit", 5)
                    else
                        for _, vehicle in pairs(game:GetService("Workspace").Vehicles:GetDescendants()) do
                            if vehicle.Name == "Player" and vehicle.Value == player then
                                for _, detect in pairs(game:GetService("Workspace").Races["circuit"].detects:GetChildren()) do
                                    if detect:IsA("Part") and detect:FindFirstChild("TouchInterest") then
                                        detect.CFrame = character.HumanoidRootPart.CFrame
                                        firetouchinterest(vehicle.Parent.Parent.PrimaryPart, detect, 0)
                                        firetouchinterest(vehicle.Parent.Parent.PrimaryPart, detect, 1)
                                    end
                                end
                                local finishPart = game:GetService("Workspace").Races["circuit"].timeTrial:FindFirstChildOfClass("IntValue").finish
                                finishPart.CFrame = character.HumanoidRootPart.CFrame
                                firetouchinterest(vehicle.Parent.Parent.PrimaryPart, finishPart, 0)
                                firetouchinterest(vehicle.Parent.Parent.PrimaryPart, finishPart, 1)
                            end
                        end
                    end
                else
                    game:GetService("ReplicatedStorage").Vehicles.GetNearestSpot:InvokeServer(player.variables.carId.Value)
                    wait(0.5)
                    game:GetService("ReplicatedStorage").Vehicles.EnterVehicleEvent:InvokeServer()
                end
            end)
        end
    end)
end)

local Toggleoffice = Tabs.Main:CreateToggle("Toggleoffice", {Title = "Auto Upgrade Office", Default = false})



Toggleoffice:OnChanged(function(state)
    getfenv().ofs = (state and true or false)
    while getfenv().ofs do
        wait()
    if not game:GetService("Players").LocalPlayer:FindFirstChild("Office") then
    game:GetService("ReplicatedStorage").Company.StartOffice:InvokeServer()
    wait(0.2)
    end
    if game:GetService("Players").LocalPlayer.Office:GetAttribute("level") <16 then
    game:GetService("ReplicatedStorage").Company.SkipOfficeQuest:InvokeServer()
    game:GetService("ReplicatedStorage").Company.UpgradeOffice:InvokeServer()
    end
    end
end)
Tabs.Main:CreateButton({
    Title = "Unlock Taxi Radar",
    Callback = function()
        game:GetService("Players").LocalPlayer.variables.vip.Value = true
    end
})


Tabs.Settingss:CreateButton({
    Title = "Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/3ZQBHpfQ5X")
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
