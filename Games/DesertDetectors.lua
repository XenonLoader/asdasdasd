local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.4"
getgenv().Changelog = [[
🚀 Version 1.0.4
• Fixed ESP system initialization
• Improved ESP item detection
• Enhanced ESP reliability
• Added error handling for ESP
• Added item name display toggle
• Added automatic color detection from handles
• Fixed ESP visibility issues
• Added Infinite Power feature with customizable power level
]]

-- Load script initialization
loadstring(game:HttpGet("https://raw.githubusercontent.com/XenonLoader/NewRepo/refs/heads/main/Cr.lua"))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Remote Events
local GiveQuest = ReplicatedStorage:WaitForChild("Give_Quest")
local WinQuest = ReplicatedStorage:WaitForChild("Win_Quest")

-- Window Setup
local Window = getgenv().Window
if not Window then return end

-- Connection Management
local Connections = {}

local function HandleConnection(name, connection)
    if Connections[name] then
        Connections[name]:Disconnect()
    end
    Connections[name] = connection
end

local function CleanupConnections()
    for name, connection in pairs(Connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    table.clear(Connections)
end

-- Create Tabs
local MainTab = Window:CreateTab("Automatics", "repeat")
local ESPTab = Window:CreateTab("ESP", "eye")

-- Main Section
MainTab:CreateSection("Main Features")

-- Infinite Power System
local InfinitePowerConfig = {
    enabled = false,
    power = 5
}

MainTab:CreateToggle({
    Name = "⚡ Infinite Power",
    CurrentValue = false,
    Flag = "InfinitePower",
    Callback = function(Value)
        InfinitePowerConfig.enabled = Value
        
        if Value then
            local success, err = pcall(function()
                local env = getgenv()
                local old
                old = hookmetamethod(game, "__namecall", function(self, ...)
                    if self.Name == "Change_Power" and string.lower(getnamecallmethod()) == "fireserver" then
                        local v1 = ...
                        if type(v1) == "number" and v1 > 0 then
                            return old(self, math.clamp(env.digging_power or InfinitePowerConfig.power, 1, 7))
                        end
                    end
                    return old(self, ...)
                end)
                getgenv().digging_power = InfinitePowerConfig.power
            end)
            
            if not success then
                warn("Infinite Power Error:", err)
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "🔋 Power Level",
    Range = {1, 7},
    Increment = 0.1,
    Suffix = "power",
    CurrentValue = 5,
    Flag = "PowerLevel",
    Callback = function(Value)
        InfinitePowerConfig.power = Value
        getgenv().digging_power = Value
    end,
})

-- Infinite Money System
local InfiniteMoneyConfig = {
    enabled = false,
    cooldown = 0.1,
    lastUpdate = 0
}

MainTab:CreateToggle({
    Name = "💰 Infinite Money",
    CurrentValue = false,
    Flag = "InfiniteMoney",
    Callback = function(Value)
        InfiniteMoneyConfig.enabled = Value
        
        if Value then
            -- Create heartbeat connection for money farming
            HandleConnection("InfiniteMoney", RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                if currentTime - InfiniteMoneyConfig.lastUpdate >= InfiniteMoneyConfig.cooldown then
                    InfiniteMoneyConfig.lastUpdate = currentTime
                    
                    local success, err = pcall(function()
                        -- Give Quest
                        GiveQuest:FireServer({
                            "Getting Settled",
                            {
                                { 0, 0 },
                                "Any"
                            },
                            {
                                9e9
                            },
                            "Return to Diddy"
                        })
                        
                        -- Complete Quest
                        WinQuest:FireServer("Getting Settled")
                    end)
                    
                    if not success then
                        warn("Infinite Money Error:", err)
                    end
                end
            end))
        else
            if Connections.InfiniteMoney then
                Connections.InfiniteMoney:Disconnect()
            end
        end
    end,
})

-- ESP System
local ESPConfig = {
    enabled = false,
    highlights = {},
    billboardGuis = {}, -- Store BillboardGuis
    nameLabels = {},
    distanceLabels = {},
    updateRate = 0.1,
    lastUpdate = 0,
    maxDistance = 1000,
    showDistance = true,
    showNames = true,
    fillTransparency = 0.5,
    outlineTransparency = 0,
    rainbow = false,
    rainbowSpeed = 1,
    itemColors = {}
}

-- Helper Functions
local function getItemColor(item)
    local handle = item:FindFirstChild("Handle")
    if handle then
        ESPConfig.itemColors[item] = handle.Color
        return handle.Color
    end
    return Color3.new(1, 1, 1)
end

local function updateItemColor(item)
    local highlight = ESPConfig.highlights[item]
    if highlight then
        local color = getItemColor(item)
        highlight.FillColor = color
        highlight.OutlineColor = color
        
        -- Update text colors
        if ESPConfig.nameLabels[item] then
            ESPConfig.nameLabels[item].TextColor3 = color
        end
        if ESPConfig.distanceLabels[item] then
            ESPConfig.distanceLabels[item].TextColor3 = color
        end
    end
end

local function createESPForItem(item)
    if not item:FindFirstChild("Handle") then return end
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    local itemColor = getItemColor(item)
    highlight.FillColor = itemColor
    highlight.OutlineColor = itemColor
    highlight.FillTransparency = ESPConfig.fillTransparency
    highlight.OutlineTransparency = ESPConfig.outlineTransparency
    highlight.Parent = item
    ESPConfig.highlights[item] = highlight
    
    -- Create BillboardGui
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = item
    ESPConfig.billboardGuis[item] = billboardGui
    
    -- Create name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = itemColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = item.Name
    nameLabel.Parent = billboardGui
    ESPConfig.nameLabels[item] = nameLabel
    
    -- Create distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = itemColor
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.TextSize = 14
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.Parent = billboardGui
    ESPConfig.distanceLabels[item] = distanceLabel
    
    -- Monitor handle color changes
    if item:FindFirstChild("Handle") then
        HandleConnection(item:GetFullName() .. "_ColorMonitor", item.Handle:GetPropertyChangedSignal("Color"):Connect(function()
            updateItemColor(item)
        end))
    end
end

local function updateESP()
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local playerPos = humanoidRootPart.Position
    local currentTime = tick()
    
    for item, highlight in pairs(ESPConfig.highlights) do
        if item:IsDescendantOf(game) then
            local distance = (item:GetPivot().Position - playerPos).Magnitude
            local isVisible = distance <= ESPConfig.maxDistance
            
            -- Update highlight
            highlight.Enabled = isVisible
            
            -- Update BillboardGui
            if ESPConfig.billboardGuis[item] then
                ESPConfig.billboardGuis[item].Enabled = isVisible
                
                -- Update name label
                if ESPConfig.nameLabels[item] then
                    ESPConfig.nameLabels[item].Visible = isVisible and ESPConfig.showNames
                end
                
                -- Update distance label
                if ESPConfig.distanceLabels[item] then
                    ESPConfig.distanceLabels[item].Visible = isVisible and ESPConfig.showDistance
                    if isVisible then
                        ESPConfig.distanceLabels[item].Text = string.format("%.1f studs", distance)
                    end
                end
            end
            
            -- Update rainbow colors
            if ESPConfig.rainbow and isVisible then
                local hue = (currentTime * ESPConfig.rainbowSpeed) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                highlight.FillColor = color
                highlight.OutlineColor = color
                
                if ESPConfig.nameLabels[item] then
                    ESPConfig.nameLabels[item].TextColor3 = color
                end
                if ESPConfig.distanceLabels[item] then
                    ESPConfig.distanceLabels[item].TextColor3 = color
                end
            end
        else
            -- Cleanup removed items
            highlight:Destroy()
            ESPConfig.highlights[item] = nil
            
            if ESPConfig.billboardGuis[item] then
                ESPConfig.billboardGuis[item]:Destroy()
                ESPConfig.billboardGuis[item] = nil
            end
            
            ESPConfig.nameLabels[item] = nil
            ESPConfig.distanceLabels[item] = nil
            ESPConfig.itemColors[item] = nil
            
            if Connections[item:GetFullName() .. "_ColorMonitor"] then
                Connections[item:GetFullName() .. "_ColorMonitor"]:Disconnect()
                Connections[item:GetFullName() .. "_ColorMonitor"] = nil
            end
        end
    end
end

local function cleanupESP()
    for item, highlight in pairs(ESPConfig.highlights) do
        highlight:Destroy()
        
        if ESPConfig.billboardGuis[item] then
            ESPConfig.billboardGuis[item]:Destroy()
        end
    end
    
    table.clear(ESPConfig.highlights)
    table.clear(ESPConfig.billboardGuis)
    table.clear(ESPConfig.nameLabels)
    table.clear(ESPConfig.distanceLabels)
    table.clear(ESPConfig.itemColors)
    
    for name, connection in pairs(Connections) do
        if name:find("_ColorMonitor") then
            connection:Disconnect()
            Connections[name] = nil
        end
    end
end

local function updateESPTransparency()
    for _, highlight in pairs(ESPConfig.highlights) do
        highlight.FillTransparency = ESPConfig.fillTransparency
        highlight.OutlineTransparency = ESPConfig.outlineTransparency
    end
end

local function initializeESP()
    local lootFolder = workspace:FindFirstChild("Loot")
    if not lootFolder then
        lootFolder = workspace:WaitForChild("Loot", 5)
    end
    
    if lootFolder then
        for _, item in ipairs(lootFolder:GetChildren()) do
            if item:FindFirstChild("Handle") then
                createESPForItem(item)
            end
        end
        
        HandleConnection("LootItems", lootFolder.ChildAdded:Connect(function(item)
            if ESPConfig.enabled then
                task.spawn(function()
                    if item:WaitForChild("Handle", 2) then
                        createESPForItem(item)
                    end
                end)
            end
        end))
    end
    
    HandleConnection("LootFolder", workspace.ChildAdded:Connect(function(child)
        if child.Name == "Loot" and ESPConfig.enabled then
            HandleConnection("LootItems", child.ChildAdded:Connect(function(item)
                task.spawn(function()
                    if item:WaitForChild("Handle", 2) then
                        createESPForItem(item)
                    end
                end)
            end))
        end
    end))
end

-- ESP Settings
ESPTab:CreateSection("Loot ESP Configuration")

ESPTab:CreateToggle({
    Name = "🎯 Enable Loot ESP",
    CurrentValue = false,
    Flag = "LootESP",
    Callback = function(Value)
        ESPConfig.enabled = Value
        
        if Value then
            task.spawn(function()
                local success, err = pcall(initializeESP)
                if not success then
                    warn("ESP Initialization Error:", err)
                end
            end)
            
            HandleConnection("ESP", RunService.RenderStepped:Connect(function()
                local currentTime = tick()
                if currentTime - ESPConfig.lastUpdate >= ESPConfig.updateRate then
                    ESPConfig.lastUpdate = currentTime
                    local success, err = pcall(updateESP)
                    if not success then
                        warn("ESP Update Error:", err)
                    end
                end
            end))
        else
            if Connections.ESP then
                Connections.ESP:Disconnect()
            end
            if Connections.LootItems then
                Connections.LootItems:Disconnect()
            end
            cleanupESP()
        end
    end,
})

-- Show Names Toggle
ESPTab:CreateToggle({
    Name = "📝 Show Item Names",
    CurrentValue = true,
    Flag = "ShowNames",
    Callback = function(Value)
        ESPConfig.showNames = Value
        for _, nameLabel in pairs(ESPConfig.nameLabels) do
            if nameLabel then
                nameLabel.Visible = Value
            end
        end
    end,
})

-- ESP Distance Control
ESPTab:CreateSlider({
    Name = "🔭 ESP Distance",
    Range = {100, 10000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = 1000,
    Flag = "ESPDistance",
    Callback = function(Value)
        ESPConfig.maxDistance = Value
    end,
})

-- ESP Update Rate
ESPTab:CreateSlider({
    Name = "🔄 Update Rate",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "sec",
    CurrentValue = 0.1,
    Flag = "ESPUpdateRate",
    Callback = function(Value)
        ESPConfig.updateRate = Value
    end,
})

-- ESP Transparency Settings
ESPTab:CreateSlider({
    Name = "👁️ Fill Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPFillTransparency",
    Callback = function(Value)
        ESPConfig.fillTransparency = Value
        updateESPTransparency()
    end,
})

-- Rainbow ESP Toggle
ESPTab:CreateToggle({
    Name = "🌈 Rainbow ESP",
    CurrentValue = false,
    Flag = "RainbowESP",
    Callback = function(Value)
        ESPConfig.rainbow = Value
        if not Value then
            for item, highlight in pairs(ESPConfig.highlights) do
                updateItemColor(item)
            end
        end
    end,
})

-- Cleanup on script stop
Player.CharacterRemoving:Connect(CleanupConnections)

-- Initialize Universal Tabs
getgenv().CreateUniversalTabs()
