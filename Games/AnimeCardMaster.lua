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

local http_request = syn and syn.request or request
local keyValid = false

local function kickPlayer(reason, isDisabled)
    local notification = Instance.new("ScreenGui")
    notification.Name = "KickNotification"
    notification.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.3, 0, 0.15, 0)
    frame.Position = UDim2.new(0.35, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BackgroundTransparency = 0.1
    frame.Parent = notification

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    -- Title of notification
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.9, 0, 0.3, 0)
    title.Position = UDim2.new(0.05, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = isDisabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 150, 0)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Text = isDisabled and "KEY DISABLED BY ADMIN" or "KEY EXPIRED"
    title.Parent = frame

    -- Message
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(0.9, 0, 0.5, 0)
    message.Position = UDim2.new(0.05, 0, 0.4, 0)
    message.BackgroundTransparency = 1
    message.TextColor3 = Color3.fromRGB(255, 255, 255)
    message.TextSize = 16
    message.Font = Enum.Font.Gotham
    message.Text = reason
    message.TextWrapped = true
    message.Parent = frame

    -- Add glow effect
    local glow = Instance.new("ImageLabel")
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0, -15, 0, -15)
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = isDisabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 150, 0)
    glow.ImageTransparency = 0.8
    glow.Parent = frame

    -- Wait for 3 seconds before kicking
    wait(3)
    LocalPlayer:Kick(reason)
end

local function startTimer(duration)
    -- Hentikan timer yang sedang berjalan (jika ada)
    stopTimer()

    local currentKey = TextBox.Text -- Store the current key

    -- Mulai timer baru
    timerCoroutine = coroutine.create(function()
        local timeLeft = duration
        while timeLeft > 0 do
            -- Check key status every 30 seconds
            if timeLeft % 30 == 0 then
                local url = "https://tlfsfctfofjgppfrdcpm.supabase.co/functions/v1/validate-key"
                local success, response = pcall(function()
                    return http_request({
                        Url = url,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsZnNmY3Rmb2ZqZ3BwZnJkY3BtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczMTkxNjgsImV4cCI6MjA1Mjg5NTE2OH0.yv_fnGPcP2TWB19V7TtY1IfLlyBMRofx_8kDk1fb6GY"
                        },
                        Body = HttpService:JSONEncode({ key = currentKey })
                    })
                end)

                if success then
                    local data = HttpService:JSONDecode(response.Body)
                    if not data.valid then
                        if data.message == "Key is disabled" then
                            TimeLabel.Text = "Key Disabled!"
                            TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                            kickPlayer("Your key has been disabled by an administrator.\nPlease contact support for assistance.", true)
                            return
                        else
                            TimeLabel.Text = "Invalid Key!"
                            TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                            kickPlayer("Your key is invalid.\nPlease get a new key at xenonhub.xyz", false)
                            return
                        end
                    end
                end
            end

            updateTimeDisplay(timeLeft)
            wait(1)
            timeLeft = timeLeft - 1
        end
        -- Waktu habis
        TimeLabel.Text = "Time Expired!"
        TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        kickPlayer("Your key has expired.\nPlease get a new key at xenonhub.xyz", false)
    end)
    coroutine.resume(timerCoroutine)
end

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
        showStatus("Failed to connect to server", true)
        return
    end

    -- Add error handling for JSON parsing
    if response.StatusCode == 200 then
        local success, data = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

        if not success then
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
--------------MAIN KEY UPDATE --------------------------------
local Fluent = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

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
local vu = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
-- Anti-AFK System
LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local Tabs = {
    InfoCard = Window:CreateTab({ Title = "Main", Icon = "house" }),
    Main = Window:CreateTab({ Title = "Info Card", Icon = "id-card" }),
    Shop = Window:CreateTab({ Title = "Shop", Icon = "shopping-bag" }),
    Potion = Window:CreateTab({ Title = "Potion", Icon = "flask-round" }),
	Dupe = Window:CreateTab({ Title = "Dupe", Icon = "bomb" }),
    Settings = Window:CreateTab({ Title = "Credits", Icon = "info" })
}

local InputValue = ""
local paragraphs = {} -- Table to store created paragraphs

local CardNameInput = Tabs.Main:CreateInput("CardNameInput", {
    Title = "Enter Card Name",
    Placeholder = "Example: Shield girl",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        InputValue = Value
    end
})

-- Destroy Button
local DestroyButton = Tabs.Main:CreateButton({
    Title = "Clear Information",
    Description = "Clear all displayed card information",
    Callback = function()
        -- Destroy all stored paragraphs
        for _, paragraph in pairs(paragraphs) do
            if paragraph then
                paragraph:Destroy()
            end
        end
        -- Clear the paragraphs table
        table.clear(paragraphs)
    end
})

local DisplayButton = Tabs.Main:CreateButton({
    Title = "Display Cards",
    Description = "Search and display all matching cards",
    Callback = function()
        -- Destroy existing paragraphs before creating new ones
        for _, paragraph in pairs(paragraphs) do
            if paragraph then
                paragraph:Destroy()
            end
        end
        table.clear(paragraphs)

        -- Input Validation
        if not InputValue or InputValue == "" then
            paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("ErrorParagraph", {
                Title = "Error",
                Content = "Please enter a card name first!"
            })
            return
        end

        local player = game:GetService("Players").LocalPlayer
        if not player then return end

        local correctBagPanel
        for _, gui in ipairs(player.PlayerGui:GetChildren()) do
            if gui.Name == "BagPanel" then
                local hasCardName = false
                for _, descendant in ipairs(gui:GetDescendants()) do
                    if descendant:IsA("TextLabel") and descendant.Name == "CardName" then
                        hasCardName = true
                        correctBagPanel = gui
                        break
                    end
                end
                if hasCardName then break end
            end
        end

        if not correctBagPanel then
            paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("ErrorParagraph", {
                Title = "Error",
                Content = "Error: You need open backpack"
            })
            return
        end

        local cardList = correctBagPanel.Main.Left.List.CardList
        if not cardList then
            paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("ErrorParagraph", {
                Title = "Error",
                Content = "Error: Could not find the card list"
            })
            return
        end

        local foundCards = 0 -- Counter for found cards

        -- Iterate through all cards
        for _, Card in ipairs(cardList:GetChildren()) do
            local cardName = Card:FindFirstChild("CardName", true)
            if cardName and cardName:IsA("TextLabel") then
                if string.find(string.lower(cardName.Text), string.lower(InputValue)) then
                    foundCards = foundCards + 1

                    -- Create header for each card
                    paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("CardHeader_" .. foundCards, {
                        Title = "Card #" .. foundCards,
                        Content = string.rep("-", 20) -- Separator line
                    })

                    -- Card Name
                    paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("DisplayParagraph_" .. foundCards, {
                        Title = "Card Name",
                        Content = cardName.Text
                    })

                    -- Amount
                    local amount = Card:FindFirstChild("Amount", true)
                    paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("AmountParagraph_" .. foundCards, {
                        Title = "Amount",
                        Content = amount and amount:IsA("TextLabel") and amount.Text or "No amount information available"
                    })

                    -- Skill
                    local skill = Card:FindFirstChild("Skill", true)
                    paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("SkillParagraph_" .. foundCards, {
                        Title = "Skill",
                        Content = skill and skill:IsA("TextLabel") and skill.Text or "No skill information available"
                    })

                    -- Skill Title
                    local skillTitle = Card:FindFirstChild("SkillTitle", true)
                    paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("SkillTitleParagraph_" .. foundCards, {
                        Title = "Skill Title",
                        Content = skillTitle and skillTitle:IsA("TextLabel") and skillTitle.Text or "No skill title information available"
                    })
                end
            end
        end

        -- Show message if no cards were found
        if foundCards == 0 then
            paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("ErrorParagraph", {
                Title = "Error",
                Content = "No cards found with name: " .. InputValue
            })
        else
            -- Show total cards found
            paragraphs[#paragraphs + 1] = Tabs.Main:CreateParagraph("TotalParagraph", {
                Title = "Total Cards Found",
                Content = "Found " .. foundCards .. " matching cards"
            })
        end
    end
})






----------------------MAIN TAB ---------------------

local Toggle = Tabs.InfoCard:CreateToggle("MyToggle", {Title = "Auto Draw", Default = false})

local runningDraw = false

Toggle:OnChanged(function(Value)
	runningDraw = Value

	if runningDraw then
		task.spawn(function()
			while runningDraw do
                local args = {
                    [1] = "DrawCard"
                }

                game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
                local args = {
                    [1] = "DrawCard",
                    [2] = true
                }

                game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
				task.wait()
			end
		end)
	end
end)


local ToggleRaid = Tabs.InfoCard:CreateToggle("ToggleRaid", {Title = "Auto Raid", Default = false})

local AutoRaid = false

ToggleRaid:OnChanged(function(Value)
	AutoRaid = Value

	if AutoRaid then
		task.spawn(function()
			while AutoRaid do
                local args = {
                    [1] = "GetReward",
                    [2] = "RaidReward"
                }

                game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
				task.wait()
			end
		end)
	end
end)

local Togglerank = Tabs.InfoCard:CreateToggle("Togglerank", {Title = "Auto rank", Default = false})

local rank = false

Togglerank:OnChanged(function(Value)
    rank = Value

    if rank then
        task.spawn(function()
            while rank do
                local args = {
                    [1] = "CardRank"
                }

                game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer(unpack(args))
                task.wait()
            end
        end)
    end
end)



local Togglefloor = Tabs.InfoCard:CreateToggle("Togglefloor", {Title = "Auto Floor", Default = false})

local floor = false

Togglefloor:OnChanged(function(Value)
    floor = Value

    if floor then
        task.spawn(function()
            while floor do
                local args = {
                    [1] = "ChallengeFloor"
                }

                game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
                task.wait(5)
            end
        end)
    end
end)

local DropdownTP = Tabs.InfoCard:CreateDropdown("Dropdown", {
    Title = "Teleport",
    Values = {"Lobby", "One Piece", "Demon Slayer", "Chiikawa", "Naruto", "Dragon Ball", "Halloween", "Brave"},
    Multi = false,
    Default = false,
})
-- ["Chiikawa"] = CFrame.new(),

local Worlds = {
    ["Brave"] = CFrame.new(1150.11279, -146.720261, -1996.32422, 0.998098791, -8.41511216e-09, 0.0616347268, 8.17921064e-10, 1, 1.23286767e-07, -0.0616347268, -1.23001954e-07, 0.998098791),
    ["Halloween"] = CFrame.new(325.991852, -91.6777649, -2156.34619, 0.996570349, 9.89327873e-08, -0.0827497467, -1.02360396e-07, 1, -3.71789142e-08, 0.0827497467, 4.55216984e-08, 0.996570349),
    ["Dragon Ball"] = CFrame.new(1796.8407, 21.5624981, -2944.67969, 0.999997556, -2.04255528e-08, -0.00221944414, 2.02309867e-08, 1, -8.7686935e-08, 0.00221944414, 8.76418156e-08, 0.999997556),
    ["Naruto"] = CFrame.new(268.788544, -31.847332, -3044.17456, 0.999592602, -3.75972187e-09, 0.0285409838, 4.22536273e-09, 1, -1.62544964e-08, -0.0285409838, 1.6368471e-08, 0.999592602),
    ["Lobby"] = CFrame.new(1138.24377, 421.270294, -2554.89648, -0.995173812, -7.56193685e-09, 0.0981281325, -5.49542234e-09, 1, 2.13296261e-08, -0.0981281325, 2.06874287e-08, -0.995173812),
    ["Chiikawa"] = CFrame.new(1117.64368, -267.412415, -3757.85742, -0.132154673, 8.34725498e-08, -0.991229117, 1.30973383e-08, 1, 8.24649646e-08, 0.991229117, -2.08433248e-09, -0.132154673),
    ["Demon Slayer"] = CFrame.new(1110.17078, 45.2797508, -3144.09521, -1, 2.09702549e-08, -6.13259044e-06, 2.09702602e-08, 1, -1.00893294e-09, 6.13259044e-06, -1.0090615e-09, -1),
    ["One Piece"] = CFrame.new(820.458069, 447.153809, -907.314087, -1, 1.17697539e-07, 7.04451552e-14, 1.17697539e-07, 1, -1.03018145e-08, -7.16576524e-14, -1.03018145e-08, -1),
}

DropdownTP:OnChanged(function(Value)
    if Worlds ~= nil and HumanoidRootPart ~= nil then
        local WorldPosition = Worlds[Value]
        if WorldPosition then
            if typeof(WorldPosition) == "Vector3" then
                HumanoidRootPart.CFrame = CFrame.new(WorldPosition)
            elseif typeof(WorldPosition) == "CFrame" then
                HumanoidRootPart.CFrame = WorldPosition
            else
            end
        end
    else
    end
end)

----------------------Shop TAB ---------------------
local selectedPotion = nil
local isPotion = false

local PotionList = {
    ["Luck Potion 1"] = 1001,
    ["Luck Potion 2"] = 1002,
    ["Luck Potion 3"] = 1003,
    ["Quality Potion 1"] = 1004,
    ["Quality Potion 2"] = 1005,
    ["Quality Potion 3"] = 1006,
    ["Potion Potion 50%"] = 1007,
    ["Quality Potion 50%"] = 1008
}

local PotionInput = 0

local Input1 = Tabs.Shop:CreateInput("Input", {
    Title = "Input",
    Placeholder = "Potion",
    Numeric = true, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Text)
        PotionInput = tonumber(Text) or 0
    end
})

local Dropdown = Tabs.Shop:CreateDropdown("Dropdown", {
    Title = "Select Potion",
    Values = {"Luck Potion 1", "Luck Potion 2" ,"Luck Potion 3", "Quality Potion 1", "Quality Potion 2", "Quality Potion 3", "Potion Potion 50%", "Quality Potion 50%"},
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Option)
    selectedPotion = PotionList[Option]
end)

local ToggleBuy = Tabs.Shop:CreateToggle("ToggleBuy", {Title = "Buy", Default = false})

ToggleBuy:OnChanged(function(Value)
    isPotion = Value
    while isPotion do
        if not PotionInput or PotionInput <= 0 then
            Fluent:Notify({
                Title = "Notification",
                Content = "Please enter a valid Potion Input!",
                SubContent = "Input field cannot be empty or zero.",
                Duration = 5 -- Notification lasts for 5 seconds
            })
            isPotion = false -- Stop the loop to prevent spamming notifications
            break
        end

        if selectedPotion then
            local args = {
                [1] = "BuyItem",
                [2] = selectedPotion,
                [3] = PotionInput,
                [4] = "PotionShopData"
            }

            game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
        else
            Fluent:Notify({
                Title = "Notification",
                Content = "Please select a potion from the dropdown!",
                SubContent = "Potion selection is required.",
                Duration = 5 -- Notification lasts for 5 seconds
            })
            isPotion = false -- Stop the loop to prevent spamming notifications
            break
        end

        task.wait()
    end
end)

----------------------POTION TAB ---------------------
local selectedUsePotion = nill
local isUsePotion = false

local PotionList = {
    ["Luck Potion 1"] = 1001,
    ["Luck Potion 2"] = 1002,
    ["Luck Potion 3"] = 1003,
    ["Quality Potion 1"] = 1004,
    ["Quality Potion 2"] = 1005,
    ["Quality Potion 3"] = 1006,
    ["Potion Potion 50%"] = 1007,
    ["Quality Potion 50%"] = 1008
}

local DropdownPotions = Tabs.Potion:CreateDropdown("DropdownPotions", {
    Title = "Select Potion",
    Values = {"Luck Potion 1", "Luck Potion 2" ,"Luck Potion 3", "Quality Potion 1", "Quality Potion 2", "Quality Potion 3", "Potion Potion 50%", "Quality Potion 50%"},
    Multi = false,
    Default = 1,
})

DropdownPotions:OnChanged(function(Option)
    selectedUsePotion = PotionList[Option]
end)


local ToggleUsePotion = Tabs.Potion:CreateToggle("ToggleUsePotion", {Title = "Use Potion", Default = false})

ToggleUsePotion:OnChanged(function(Value)
    isUsePotion = Value
    while isUsePotion do
        if selectedUsePotion then
          local args = {
            [1] = "UseItem",
            [2] = selectedUsePotion
        }

        game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
        end
        task.wait()
    end
end)

----------------------DUPE TAB ---------------------



local NumInput = 0
local CardInput = 0
local AutoCardNumber = false -- Toggle otomatisasi Card Number
local CurrentCardNumber = 3000 -- Awal Card Number otomatis

-- Input untuk jumlah duplikasi
local Input = Tabs.Dupe:CreateInput("Input", {
    Title = "Input",
    Placeholder = "Input",
    Numeric = true, -- Hanya angka
    Finished = false, -- Callback dipanggil saat tekan enter
    Callback = function(Text)
        NumInput = tonumber(Text) or 0
    end
})

-- Input untuk Card Number
local CardInputField = Tabs.Dupe:CreateInput("CardInput", {
    Title = "Input Card Number",
    Placeholder = "Card Number",
    Numeric = true, -- Hanya angka
    Finished = false, -- Callback dipanggil saat tekan enter
    Callback = function(Text)
        if not AutoCardNumber then
            CardInput = tonumber(Text) or 0
        end
    end
})

-- Toggle untuk AutoCardNumber
local AutoCardToggle = Tabs.Dupe:CreateToggle("AutoCardToggle", {
    Title = "Auto Card Number (3000-5000)",
    Default = false
})

AutoCardToggle:OnChanged(function(Value)
    AutoCardNumber = Value
    if AutoCardNumber then
        CurrentCardNumber = 3000 -- Reset ke awal saat toggle aktif
    end
end)

-- Toggle untuk duplikasi
local ToggleDupe = Tabs.Dupe:CreateToggle("ToggleDupe", {Title = "Dupe", Default = false})
local Dupe = false

ToggleDupe:OnChanged(function(Value)
    Dupe = Value

    if Dupe then
        task.spawn(function()
            while Dupe do
                if (AutoCardNumber and CurrentCardNumber <= 5000) and NumInput > 0 then
                    local args = {
                        [1] = "SellCard",
                        [2] = CurrentCardNumber,
                        [3] = -NumInput
                    }

                    game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))

                    -- Naikkan Card Number untuk iterasi berikutnya
                    CurrentCardNumber = CurrentCardNumber + 1

                    -- Reset ke awal jika sudah mencapai 5000
                    if CurrentCardNumber > 5000 then
                        CurrentCardNumber = 3000
                    end
                elseif CardInput > 0 and NumInput > 0 then
                    local args = {
                        [1] = "SellCard",
                        [2] = CardInput,
                        [3] = -NumInput
                    }

                    game:GetService("ReplicatedStorage").Remote.RemoteEvent:FireServer(unpack(args))
                else
                    -- Tangani jika input tidak valid
                end
                task.wait()
            end
        end)
    end
end)


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



--------------EXPIRED KEY UPDATE --------------------------------

            return
        else
            -- Check for specific message types
            if data.message == "Key is disabled" then
                TimeLabel.Text = "Key Disabled!"
                TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                showStatus("KEY DISABLED", true)
                kickPlayer("Your key has been disabled by an administrator.\nPlease contact support for assistance.", true)
            else
                TimeLabel.Text = "Invalid Key!"
                TimeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                showStatus("INVALID KEY", true)
                kickPlayer("Your key is invalid.\nPlease get a new key at xenonhub.xyz", false)
            end
        end
    else
        showStatus("Server error: " .. tostring(response.StatusCode), true)
    end
end

-- Button functionality
VerifyButton.MouseButton1Click:Connect(function()
    local key = TextBox.Text

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
