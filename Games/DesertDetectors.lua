local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.5"
getgenv().Changelog = [[
🚀 Version 1.0.5
• Added secure bypass system
• Implemented safe hook methods
• Enhanced anti-detection measures
• Improved memory management
• Added thread protection
• Optimized performance monitoring
• Added secure environment checks
]]

-- Secure environment check
local function createSecureEnvironment()
    local env = {
        _secure = true,
        _version = "1.0.5",
        _created = os.time()
    }
    
    local mt = {
        __index = function(_, k)
            if type(k) ~= "string" then return nil end
            return env[k]
        end,
        __newindex = function(_, k, v)
            if type(k) ~= "string" then return end
            env[k] = v
        end,
        __metatable = "Locked"
    }
    
    return setmetatable({}, mt)
end

local secureEnv = createSecureEnvironment()

-- Create secure hook system
local function createSecureHook(target, callback)
    local success, hook = pcall(function()
        local closure = newcclosure(function(...)
            return callback(...)
        end)
        
        local protected = protect_function(closure)
        return hookfunction(target, protected)
    end)
    
    return success and hook or nil
end

-- Memory protection
local function protectMemory()
    local success = pcall(function()
        -- Clear debug info
        debug.setupvalue = function() end
        debug.getupvalue = function() end
        debug.getupvalues = function() end
        
        -- Protect strings
        string.dump = function() return "" end
        
        -- Secure environment
        getfenv().script = nil
        getfenv().game = nil
    end)
    
    return success
end

-- Load script initialization with protection
local success = pcall(function()
    protectMemory()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XenonLoader/NewRepo/refs/heads/main/Cr.lua"))()
end)

if not success then return end

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Secure remote events
local function createSecureRemote(name)
    local remote = ReplicatedStorage:WaitForChild(name, 10)
    if not remote then return nil end
    
    return setmetatable({}, {
        __index = function(_, k)
            if k == "FireServer" then
                return function(...)
                    local args = {...}
                    if type(args[1]) ~= "table" then return end
                    return remote:FireServer(...)
                end
            end
            return remote[k]
        end,
        __metatable = "Locked"
    })
end

local GiveQuest = createSecureRemote("Give_Quest")
local WinQuest = createSecureRemote("Win_Quest")

-- Item Information
local ItemInfo = {
    { "Fish Hook", Color3.new(0.435294, 0.435294, 0.435294), "Uncommon" },
    { "Bloxy Cola", Color3.new(0.368627, 0.247059, 0), "Uncommon" },
    { "Cap", Color3.new(0.901961, 0.678431, 0.317647), "Common" },
    { "Chest", Color3.new(0.980392, 0.819608, 0.0196078), "Rare" },
    { "Gold Bar", Color3.new(0.980392, 0.815686, 0), "Rare" },
    { "Mummy", Color3.new(0.980392, 0.690196, 0.403922), "Epic" },
    { "Bottle", Color3.new(0.623529, 0.458824, 0.231373), "Common" },
    { "Ancient Vase", Color3.new(0.666667, 0.537255, 0.32549), "Uncommon" },
    { "Pharoh's Chest", Color3.new(0.27451, 0.227451, 0.133333), "Rare" },
    { "Egyptian Cat", Color3.new(0.666667, 0.580392, 0.403922), "Legendary" },
    { "Anubis Urn", Color3.new(1, 0.901961, 0.403922), "Rare" },
    { "Falcon Urn", Color3.new(1, 0.901961, 0.403922), "Uncommon" },
    { "Diamond", Color3.new(0, 0.666667, 1), "Epic" },
    { "Skull Fossil", Color3.new(1, 0, 0), "Epic" },
    { "Sphinx", Color3.new(1, 0.784314, 0), "Mythic" },
    { "Fossil", Color3.new(1, 0.866667, 0.756863), "Legendary" },
    { "Fighter Jet", Color3.new(1, 0, 0), "Mythic" },
    { "Horse Shoe", Color3.new(0.27451, 0.27451, 0.27451), "Uncommon" },
    { "Tank", Color3.new(1, 0, 0), "Mythic" },
    { "Dish", Color3.new(0.784314, 0.784314, 0.784314), "Rare" },
    { "Satellite", Color3.new(0.588235, 0.588235, 0.588235), "Rare" },
    { "Special Stone", Color3.new(0.666667, 0.333333, 1), "Mythic" },
    { "Strange Rock", Color3.new(0, 1, 0), "Uncommon" },
    { "Strange Saucer", Color3.new(0.823529, 0.823529, 0.823529), "Epic" },
    { "Skull", Color3.new(0.7, 0.7, 0.7), "Legendary" },
    { "Big Tooth", Color3.new(0.698039, 0.576471, 0.54902), "Rare" },
    { "Meteor", Color3.new(0.698039, 0.141176, 0), "Epic" },
    { "Mythic Meteor", Color3.new(0.666667, 0.333333, 1), "Mythic" },
    { "Small Cactus", Color3.new(0, 0.470588, 0), "Epic" },
    { "Medium Cactus", Color3.new(0, 0.470588, 0), "Epic" },
    { "Big Cactus", Color3.new(0, 0.772549, 0), "Epic" },
    { "Huge Cactus", Color3.new(1, 0, 0), "Epic" },
    { "Ancient Chest", Color3.new(1, 0, 0), "Epic" },
    { "Mega Bone", Color3.new(1, 1, 1), "Mythic" },
    { "Huge Bone", Color3.new(1, 1, 1), "Epic" },
    { "Large Bone", Color3.new(1, 1, 1), "Rare" },
    { "Medium Bone", Color3.new(1, 1, 1), "Uncommon" },
    { "Small Bone", Color3.new(1, 1, 1), "Common" },
    { "Tail Fossil", Color3.new(1, 0.843137, 0.592157), "Epic" },
    { "Pharoh's Pillar", Color3.new(1, 1, 0), "Mythic" },
    { "Triceratops Skull", Color3.new(1, 0.843137, 0.592157), "Legendary" },
    { "Submarine", Color3.new(0.133333, 0.133333, 0.133333), "Mythic" },
    { "Barrel", Color3.new(0.490196, 0.313725, 0.196078), "Uncommon" },
    { "Anchor", Color3.new(0.823529, 0.823529, 0.823529), "Rare" },
    { "WW2 Helmet", Color3.new(0.137255, 0.27451, 0.113725), "Uncommon" },
    { "Key of Kufu", Color3.new(1, 0.843137, 0.0588235), "Epic" }
}

-- Secure lookup tables
local ItemColorMap = setmetatable({}, {
    __index = function(_, k)
        for _, itemData in ipairs(ItemInfo) do
            if itemData[1] == k then
                return itemData[2]
            end
        end
        return Color3.new(1, 1, 1)
    end,
    __metatable = "Locked"
})

local ItemRarityMap = setmetatable({}, {
    __index = function(_, k)
        for _, itemData in ipairs(ItemInfo) do
            if itemData[1] == k then
                return itemData[3]
            end
        end
        return "Unknown"
    end,
    __metatable = "Locked"
})

-- Window Setup
local Window = getgenv().Window
if not Window then return end

-- Secure connection management
local Connections = setmetatable({}, {
    __newindex = function(t, k, v)
        if type(v) ~= "userdata" then return end
        rawset(t, k, v)
    end,
    __metatable = "Locked"
})

local function HandleConnection(name, connection)
    if Connections[name] and Connections[name].Connected then
        Connections[name]:Disconnect()
    end
    Connections[name] = connection
end

-- Create tabs
local MainTab = Window:CreateTab("Automatics", "repeat")
local ESPTab = Window:CreateTab("ESP", "eye")

-- Power System
local PowerConfig = setmetatable({
    enabled = false,
    alwaysMax = false,
    power = 5
}, {
    __newindex = function(t, k, v)
        if type(k) ~= "string" then return end
        rawset(t, k, v)
    end,
    __metatable = "Locked"
})

-- Infinite Power System
do
    local env = getgenv()
    
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if self.Name == "Change_Power" and string.lower(getnamecallmethod()) == "fireserver" then
            local v1 = ...
            if type(v1) == "number" and v1 > 0 then
                return old(self, math.clamp(env.digging_power or 5, 0, 5))
            end
        end
        return old(self, ...)
    end)
    
    getgenv().digging_power = 7
end

-- Power Level Slider
MainTab:CreateSlider({
    Name = "🔋 Power Level",
    Range = {1, 7},
    Increment = 0.1,
    Suffix = "power",
    CurrentValue = 5,
    Flag = "PowerLevel",
    Callback = function(Value)
        PowerConfig.power = Value
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
            HandleConnection("InfiniteMoney", RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                if currentTime - InfiniteMoneyConfig.lastUpdate >= InfiniteMoneyConfig.cooldown then
                    InfiniteMoneyConfig.lastUpdate = currentTime
                    
                    local success = pcall(function()
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
                        
                        WinQuest:FireServer("Getting Settled")
                    end)
                    
                    if not success then
                        warn("Infinite Money Error")
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
    billboardGuis = {},
    nameLabels = {},
    distanceLabels = {},
    updateRate = 0.1,
    lastUpdate = 0,
    maxDistance = 1000,
    showDistance = true,
    showNames = true,
    showRarity = true,
    fillTransparency = 0.5,
    outlineTransparency = 0,
    rainbow = false,
    rainbowSpeed = 1,
    itemColors = {}
}

-- ESP Helper Functions
local function getItemColor(item)
    return ItemColorMap[item.Name]
end

local function getItemRarity(item)
    return ItemRarityMap[item.Name]
end

local function updateItemColor(item)
    local highlight = ESPConfig.highlights[item]
    if highlight then
        local color = getItemColor(item)
        highlight.FillColor = color
        highlight.OutlineColor = color
        
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
    
    local highlight = Instance.new("Highlight")
    local itemColor = getItemColor(item)
    highlight.FillColor = itemColor
    highlight.OutlineColor = itemColor
    highlight.FillTransparency = ESPConfig.fillTransparency
    highlight.OutlineTransparency = ESPConfig.outlineTransparency
    highlight.Parent = item
    ESPConfig.highlights[item] = highlight
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = item
    ESPConfig.billboardGuis[item] = billboardGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = itemColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = string.format("%s [%s]", item.Name, getItemRarity(item))
    nameLabel.Parent = billboardGui
    ESPConfig.nameLabels[item] = nameLabel
    
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
            
            highlight.Enabled = isVisible
            
            if ESPConfig.billboardGuis[item] then
                ESPConfig.billboardGuis[item].Enabled = isVisible
                
                if ESPConfig.nameLabels[item] then
                    ESPConfig.nameLabels[item].Visible = isVisible and ESPConfig.showNames
                    if isVisible and ESPConfig.showNames then
                        ESPConfig.nameLabels[item].Text = string.format("%s [%s]", item.Name, getItemRarity(item))
                    end
                end
                
                if ESPConfig.distanceLabels[item] then
                    ESPConfig.distanceLabels[item].Visible = isVisible and ESPConfig.showDistance
                    if isVisible and ESPConfig.showDistance then
                        ESPConfig.distanceLabels[item].Text = string.format("%.1f studs", distance)
                    end
                end
            end
            
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
            highlight:Destroy()
            ESPConfig.highlights[item] = nil
            
            if ESPConfig.billboardGuis[item] then
                ESPConfig.billboardGuis[item]:Destroy()
                ESPConfig.billboardGuis[item] = nil
            end
            
            ESPConfig.nameLabels[item] = nil
            ESPConfig.distanceLabels[item] = nil
            ESPConfig.itemColors[item] = nil
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
                local success = pcall(initializeESP)
                if not success then
                    warn("ESP Initialization Error")
                end
            end)
            
            HandleConnection("ESP", RunService.RenderStepped:Connect(function()
                local currentTime = tick()
                if currentTime - ESPConfig.lastUpdate >= ESPConfig.updateRate then
                    ESPConfig.lastUpdate = currentTime
                    pcall(updateESP)
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

ESPTab:CreateSlider({
    Name = "👁️ Fill Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Flag = "ESPFillTransparency",
    Callback = function(Value)
        ESPConfig.fillTransparency = Value
        for _, highlight in pairs(ESPConfig.highlights) do
            highlight.FillTransparency = Value
        end
    end,
})

ESPTab:CreateToggle({
    Name = "🌈 Rainbow ESP",
    CurrentValue = false,
    Flag = "RainbowESP",
    Callback = function(Value)
        ESPConfig.rainbow = Value
        if not Value then
            for item in pairs(ESPConfig.highlights) do
                updateItemColor(item)
            end
        end
    end,
})

-- Cleanup
Player.CharacterRemoving:Connect(function()
    for name, connection in pairs(Connections) do
        if connection.Connected then
            connection:Disconnect()
        end
    end
    table.clear(Connections)
end)

-- Initialize Universal Tabs
getgenv().CreateUniversalTabs()
