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
local Network = ReplicatedStorage:WaitForChild("Source"):WaitForChild("Network")
local RemoteFunctions: {[string]: RemoteFunction} = Network:WaitForChild("RemoteFunctions")
local RemoteEvents: {[string]: RemoteEvent} = Network:WaitForChild("RemoteEvents")
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
    Title = `Xenon | {OriginalPlaceName}`,
    SubTitle = "https://discord.gg/3ZQBHpfQ5X",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
    Main = Window:CreateTab({ Title = "Main", Icon = "house" }),
    Teleport = Window:CreateTab({ Title = "Teleport", Icon = "earth" }),
    Walking = Window:CreateTab({ Title = "Auto Walk", Icon = "fast-forward" }),
    Enchant = Window:CreateTab({ Title = "Enchant", Icon = "shovel" }),
    Pinneds = Window:CreateTab({ Title = "Pin", Icon = "pin" }),
    Settingss = Window:CreateTab({ Title = "Misc", Icon = "info" })
}
-- Anti-AFK System
LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)
local toggleStateAutoDig = false
local toggleStateDigPileOnly = false
local processing = false
local autoWalkEnabled = false
local isMinigameActive = false
local shouldMove = false
-- Improved pile completion checking
local function checkAnyPileCompleted()
    for _, pile in pairs(Workspace.Map.TreasurePiles:GetChildren()) do
        if pile:IsA("Model") and isPileOwnedByLocalPlayer(pile) then
            local progress = pile:GetAttribute("Progress") or 0
            local maxProgress = pile:GetAttribute("MaxProgress") or 100
            if progress >= maxProgress then
                return true
            end
        end
    end
    return false
end
local function createNewPile()
    local Digsargs = {
        [1] = {
            ["Command"] = "DigIntoSandSound"
        }
    }
    ReplicatedStorage.Source.Network.RemoteEvents.Digging:FireServer(unpack(Digsargs))
    task.wait(0.5)
    local createArgs = {
        [1] = {
            ["Command"] = "CreatePile"
        }
    }
    return ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(createArgs))
end
local function isPileOwnedByLocalPlayer(pile)
    local owner = pile:GetAttribute("Owner")
    return owner and owner == LocalPlayer.UserId
end
local function isPileCompleted(pile)
    local progress = pile:GetAttribute("Progress") or 0
    local maxProgress = pile:GetAttribute("MaxProgress") or 100
    return progress >= maxProgress
end
local function digPile(pileIndex)
    local enterMinigameArgs = {
        [1] = {
            ["Command"] = "EnterMinigame",
            ["TargetPileIndex"] = pileIndex
        }
    }
    ReplicatedStorage.Source.Network.RemoteEvents.Digging:FireServer(unpack(enterMinigameArgs))
    task.wait(0.5)
    local digArgs = {
        [1] = {
            ["Command"] = "DigPile",
            ["TargetPileIndex"] = pileIndex
        }
    }
    return ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(digArgs))
end
-- Improved treasure pile processing
local function processTreasurePiles()
    if processing then return end
    processing = true
    while toggleStateAutoDig do
        if not isMinigameActive then
            local foundPile = false
            local completedPile = false
            for _, pile in pairs(Workspace.Map.TreasurePiles:GetChildren()) do
                if not toggleStateAutoDig or isMinigameActive then break end
                if pile:IsA("Model") and isPileOwnedByLocalPlayer(pile) then
                    foundPile = true
                    local pileIndex = tonumber(pile.Name)
                    -- Set progress equal to maxProgress
                    local maxProgress = pile:GetAttribute("MaxProgress") or 1000
                    pile:SetAttribute("Progress", maxProgress)
                    if isPileCompleted(pile) then
                        completedPile = true
                        shouldMove = true
                        break
                    end
                    digPile(pileIndex)
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                    task.wait()
                end
            end
            if not foundPile or completedPile then
                createNewPile()
            end
        end
        task.wait(3)
    end
    processing = false
end

HandleConnection(Workspace.Map.TreasurePiles.ChildAdded:Connect(function(pile)
    if toggleStateAutoDig then
        syncProgress(pile)
    end
end), "ProgressSync")

HandleConnection(Workspace.Map.TreasurePiles.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and toggleStateAutoDig then
        descendant.AttributeChanged:Connect(function(attributeName)
            if attributeName == "MaxProgress" then
                syncProgress(descendant)
            end
        end)
    end
end), "AttributeSync")


local isDigMinigameLocked = false
local activeConnections = {}

local function handleMinigame(digMinigame)
    if not digMinigame then return end
    local cursor = digMinigame:FindFirstChild("Cursor")
    local area = digMinigame:FindFirstChild("Area")
    if not cursor or not area then return end
    if activeConnections[digMinigame] then
        activeConnections[digMinigame]:Disconnect()
        activeConnections[digMinigame] = nil
    end
    if isDigMinigameLocked or autoClickAndDigEnabled then
        activeConnections[digMinigame] = RunService.Heartbeat:Connect(function()
            if cursor and cursor.Parent and area and area.Parent then
                cursor.Position = area.Position
                area.Size = UDim2.new(1, 0, 0.56400001, 0)
                local pileIndex = digMinigame:GetAttribute("TargetPileIndex")
                if pileIndex then
                    local digArgs = {
                        [1] = {
                            ["Command"] = "DigPile",
                            ["TargetPileIndex"] = pileIndex
                        }
                    }
                    ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(digArgs))
                end
            else
                if activeConnections[digMinigame] then
                    activeConnections[digMinigame]:Disconnect()
                    activeConnections[digMinigame] = nil
                end
            end
        end)
    end
    digMinigame.AncestryChanged:Connect(function(_, parent)
        if not parent and activeConnections[digMinigame] then
            activeConnections[digMinigame]:Disconnect()
            activeConnections[digMinigame] = nil
        end
    end)
end
local function setupMinigameMonitoring()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local mainGui = PlayerGui:WaitForChild("Main")
    mainGui.ChildAdded:Connect(function(child)
        if child.Name == "DigMinigame" then
            isMinigameActive = true
            task.wait()
            handleMinigame(child)
        end
    end)
    mainGui.ChildRemoved:Connect(function(child)
        if child.Name == "DigMinigame" then
            isMinigameActive = false
            if activeConnections[child] then
                activeConnections[child]:Disconnect()
                activeConnections[child] = nil
            end
        end
    end)
    for _, child in ipairs(mainGui:GetChildren()) do
        if child.Name == "DigMinigame" then
            isMinigameActive = true
            handleMinigame(child)
        end
    end
end
-- Enhanced Auto Walk System with Model Detection
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local PS = game:GetService("PathfindingService")
local path = PS:CreatePath({
    AgentRadius = 2,
    AgentJumpHeight = 10,
    AgentMaxSlope = 10,
    AgentCanJump = true,
    AgentCanClimb = true
})
local savedPosition = nil
local radius = 20

local function findNearestOwnedModel()
    local character = player.Character
    if not character then return nil end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    local nearestModel = nil
    local shortestDistance = radius
    for _, pile in pairs(Workspace.Map.TreasurePiles:GetChildren()) do
        if pile:IsA("Model") and isPileOwnedByLocalPlayer(pile) and not isPileCompleted(pile) then
            local primaryPart = pile.PrimaryPart
            if primaryPart then
                local distance = (primaryPart.Position - rootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestModel = pile
                end
            end
        end
    end
    return nearestModel
end
local function isWaterPosition(position)
    -- Cast a ray downward from the position to check for water
    local ray = Ray.new(position + Vector3.new(0, 5, 0), Vector3.new(0, -10, 0))
    local hit, hitPosition = workspace:FindPartOnRay(ray, character, false, true)
    if hit then
        return hit.Material == Enum.Material.Water or
               hit.Name:lower():match("water") or
               hit.Transparency > 0.5
    end
    return false
end

local function getRandomTargetPosition()
    local character = player.Character
    if not character then return nil end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    -- Use saved position if available, otherwise use current position
    local basePosition = savedPosition or rootPart.Position
    -- Try up to 10 times to find a non-water position
    for i = 1, 10 do
        local randomAngle = math.random() * 2 * math.pi
        local randomDistance = math.random() * radius
        local offsetX = math.cos(randomAngle) * randomDistance
        local offsetZ = math.sin(randomAngle) * randomDistance
        local newTargetPos = basePosition + Vector3.new(offsetX, 0, offsetZ)
        -- Check if the position is not in water
        if not isWaterPosition(newTargetPos) then
            return newTargetPos
        end
    end
    return nil
end

local WALK_VIS_CONFIG = {
    SEGMENTS = 36,
    HEIGHT_OFFSET = 0.1,
    LINE_THICKNESS = 0.2,
    CIRCLE_COLOR = "Bright blue",
    CENTER_COLOR = "Really red",
    LINE_TRANSPARENCY = 0.5,
    CENTER_TRANSPARENCY = 0.3
}

local PATH_VIS_CONFIG = {
    LINE_THICKNESS = 0.2,
    WAYPOINT_SIZE = 0.5,
    LINE_COLOR = "Lime green",
    POINT_COLOR = "Really red",
    LINE_TRANSPARENCY = 0.3,
    POINT_TRANSPARENCY = 0.5
}

local TIMEOUT_DURATION = 5

local function createWalkVisualization()
    local existing = workspace:FindFirstChild("WalkVisualization")
    if existing then
        existing:Destroy()
    end

    local visualization = Instance.new("Folder")
    visualization.Name = "WalkVisualization"
    visualization.Parent = workspace

    -- Get base position
    local basePosition = savedPosition or (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position)
    if not basePosition then return end

    -- Create circle visualization
    for i = 1, WALK_VIS_CONFIG.SEGMENTS do
        local angle1 = ((i-1)/WALK_VIS_CONFIG.SEGMENTS) * math.pi * 2
        local angle2 = (i/WALK_VIS_CONFIG.SEGMENTS) * math.pi * 2

        local point1 = basePosition + Vector3.new(math.cos(angle1) * radius, WALK_VIS_CONFIG.HEIGHT_OFFSET, math.sin(angle1) * radius)
        local point2 = basePosition + Vector3.new(math.cos(angle2) * radius, WALK_VIS_CONFIG.HEIGHT_OFFSET, math.sin(angle2) * radius)

        local segment = Instance.new("Part")
        segment.Name = "XenonVisualizer"
        segment.Anchored = true
        segment.CanCollide = false
        segment.Size = Vector3.new(WALK_VIS_CONFIG.LINE_THICKNESS, WALK_VIS_CONFIG.LINE_THICKNESS, (point2 - point1).Magnitude)
        segment.CFrame = CFrame.new(point1:Lerp(point2, 0.5), point2)
        segment.Material = Enum.Material.Neon
        segment.BrickColor = BrickColor.new(WALK_VIS_CONFIG.CIRCLE_COLOR)
        segment.Transparency = WALK_VIS_CONFIG.LINE_TRANSPARENCY
        segment.Parent = visualization
    end

    -- Create center marker
    local center = Instance.new("Part")
    center.Name = "XenonVisualizer"
    center.Anchored = true
    center.CanCollide = false
    center.Shape = Enum.PartType.Ball
    center.Size = Vector3.new(1, 1, 1)
    center.Position = basePosition
    center.Material = Enum.Material.Neon
    center.BrickColor = BrickColor.new(WALK_VIS_CONFIG.CENTER_COLOR)
    center.Transparency = WALK_VIS_CONFIG.CENTER_TRANSPARENCY
    center.Parent = visualization
end

local function visualizePath(waypoints)
    -- Remove existing path visualization
    local existing = workspace:FindFirstChild("PathVisualization")
    if existing then
        existing:Destroy()
    end

    -- Create new path visualization folder
    local pathVis = Instance.new("Folder")
    pathVis.Name = "PathVisualization"
    pathVis.Parent = workspace

    -- Visualize waypoints
    for i = 1, #waypoints - 1 do
        local point1 = waypoints[i].Position
        local point2 = waypoints[i + 1].Position

        local pathSegment = Instance.new("Part")
        pathSegment.Name = "XenonVisualizer"
        pathSegment.Anchored = true
        pathSegment.CanCollide = false
        pathSegment.Size = Vector3.new(PATH_VIS_CONFIG.LINE_THICKNESS, PATH_VIS_CONFIG.LINE_THICKNESS, (point2 - point1).Magnitude)
        pathSegment.CFrame = CFrame.new(point1:Lerp(point2, 0.5), point2)
        pathSegment.Material = Enum.Material.Neon
        pathSegment.BrickColor = BrickColor.new(PATH_VIS_CONFIG.LINE_COLOR)
        pathSegment.Transparency = PATH_VIS_CONFIG.LINE_TRANSPARENCY
        pathSegment.Parent = pathVis

        -- Add waypoint marker
        local marker = Instance.new("Part")
        marker.Name = "XenonVisualizer"
        marker.Anchored = true
        marker.CanCollide = false
        marker.Shape = Enum.PartType.Ball
        marker.Size = Vector3.new(PATH_VIS_CONFIG.WAYPOINT_SIZE, PATH_VIS_CONFIG.WAYPOINT_SIZE, PATH_VIS_CONFIG.WAYPOINT_SIZE)
        marker.Position = point1
        marker.Material = Enum.Material.Neon
        marker.BrickColor = BrickColor.new(PATH_VIS_CONFIG.POINT_COLOR)
        marker.Transparency = PATH_VIS_CONFIG.POINT_TRANSPARENCY
        marker.Parent = pathVis
    end
end

local function cleanupVisualizations()
    local walkVis = workspace:FindFirstChild("WalkVisualization")
    local pathVis = workspace:FindFirstChild("PathVisualization")

    if walkVis then walkVis:Destroy() end
    if pathVis then pathVis:Destroy() end
end

local function Goto()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Create or update walk radius visualization
    createWalkVisualization()

    -- Rest of your existing Goto code...
    local nearestModel = findNearestOwnedModel()
    local targetPos
    if nearestModel and nearestModel.PrimaryPart then
        targetPos = nearestModel.PrimaryPart.Position
        if isWaterPosition(targetPos) then
            targetPos = nil
        end
    end
    if not targetPos then
        targetPos = getRandomTargetPosition()
    end
    if not targetPos then return end

    local success, errorMessage = pcall(function()
        path:ComputeAsync(rootPart.Position, targetPos)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()

        -- Visualize the computed path
        visualizePath(waypoints)

        -- Rest of your existing waypoint handling code...
        for _, waypoint in ipairs(waypoints) do
            if not autoWalkEnabled then break end
            if not isWaterPosition(waypoint.Position) then
                humanoid:MoveTo(waypoint.Position)
                if waypoint.Action == Enum.PathWaypointAction.Jump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end

                local startTime = tick()
                local reachedWaypoint = false
                local connection
                connection = humanoid.MoveToFinished:Connect(function()
                    reachedWaypoint = true
                    if connection then
                        connection:Disconnect()
                    end
                end)

                while not reachedWaypoint and (tick() - startTime) < TIMEOUT_DURATION and autoWalkEnabled do
                    task.wait()
                end

                if connection then
                    connection:Disconnect()
                end

                if reachedWaypoint and nearestModel and _ == #waypoints then
                    local pileIndex = tonumber(nearestModel.Name)
                    if pileIndex then
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        task.wait()
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                        digPile(pileIndex)
                    end
                end

                if not reachedWaypoint then break end
            else
                break
            end
        end
    end
end
-- UI Controls
local AutoDigToggle = Tabs.Main:CreateToggle("AutoDigToggle",{
    Title = "⛏️ • Auto Dig",
    Default = false,
    Callback = function(Value)
        toggleStateAutoDig = Value
        if Value then
            task.spawn(processTreasurePiles)
        end
    end
})

local MinigameAssistToggle = Tabs.Main:CreateToggle("MinigameAssistToggle",{
    Title = "🕳️ • Only Auto Minigame",
    Default = false,
    Callback = function(Value)
        isDigMinigameLocked = Value
        if not Value then
            for digMinigame, connection in pairs(activeConnections) do
                connection:Disconnect()
                activeConnections[digMinigame] = nil
            end
        else
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local mainGui = PlayerGui:WaitForChild("Main")
            for _, child in ipairs(mainGui:GetChildren()) do
                if child.Name == "DigMinigame" then
                    handleMinigame(child)
                end
            end
        end
    end
})

local DIG_CONFIG = {
    MIN_DELAY = 1, -- Minimum delay in seconds
    MAX_DELAY = 5  -- Maximum delay in seconds
}

local function getRandomDelay()
    return DIG_CONFIG.MIN_DELAY + (math.random() * (DIG_CONFIG.MAX_DELAY - DIG_CONFIG.MIN_DELAY))
end

local lastDigTime = 0

local function LegitDig()
    local player = game:GetService("Players").LocalPlayer
    local DigMinigame = player.PlayerGui.Main:FindFirstChild("DigMinigame")
    if not DigMinigame then
        return
    end

    HandleConnection(game:GetService("RunService").Heartbeat:Connect(function()
        if not player.PlayerGui.Main:FindFirstChild("DigMinigame") or not autoClickAndDigEnabled then
            return
        end

        DigMinigame.Area.Size = UDim2.new(1, 0, 0.56400001, 0)
        DigMinigame.Cursor.Position = DigMinigame.Area.Position

        local currentTime = tick()
        if currentTime - lastDigTime < getRandomDelay() then
            return
        end

        local pileIndex = DigMinigame:GetAttribute("TargetPileIndex")
        if pileIndex then
            local digArgs = {
                [1] = {
                    ["Command"] = "DigPile",
                    ["TargetPileIndex"] = pileIndex
                }
            }
            ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(digArgs))
            lastDigTime = currentTime
        end
    end), "LegitDigHeartbeat")
end

local function handleAutoClickAndDig()
    while autoClickAndDigEnabled do
        if not isMinigameActive then

            local player = game:GetService("Players").LocalPlayer
            local Tool = player.Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:GetAttribute("Type") == "Shovel" then
                Tool:Activate()

                local createArgs = {
                    [1] = {
                        ["Command"] = "CreatePile"
                    }
                }
                ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(createArgs))
            end
        else
            LegitDig()
        end
        task.wait(0.1)
    end
end


local AutoClickDigToggle = Tabs.Main:CreateToggle("AutoClickDigToggle", {
    Title = "⛏️ • Auto Dig Legit",
    Default = false,
    Callback = function(Value)
        autoClickAndDigEnabled = Value
        if Value then
            task.spawn(handleAutoClickAndDig)
        end
    end
})


HandleConnection(LocalPlayer.PlayerGui.Main.ChildAdded:Connect(function(child)
    if child.Name == "DigMinigame" and autoClickAndDigEnabled then
        isMinigameActive = true
        LegitDig()
    end
end), "DigMinigameAdded")

HandleConnection(LocalPlayer.PlayerGui.Main.ChildRemoved:Connect(function(child)
    if child.Name == "DigMinigame" then
        isMinigameActive = false
    end
end), "DigMinigameRemoved")


local function SellInventory()
    local player = game:GetService("Players").LocalPlayer
    player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    local Inventory = ReplicatedStorage.Source.Network.RemoteFunctions.Player:InvokeServer({
        Command = "GetInventory"
    })
    local AnyObjects = false
    for _, Object in Inventory do
        if not Object.Attributes.Weight then
            continue
        end
        AnyObjects = true
        break
    end
    if not AnyObjects then
        task.wait(3)
        return
    end
    for _, v in workspace.Map.Islands:GetDescendants() do
        if v.Name ~= "Title" or not v:IsA("TextLabel") or v.Text ~= "Merchant" then
            continue
        end
        local Merchant = v.Parent.Parent
        local PreviousPosition = player.Character:GetPivot()
        local Capacity = player.PlayerGui.Main.Core.Inventory.Disclaimer.Capacity
        local PreviousText = Capacity.Text
        repeat
            player.Character:PivotTo(Merchant:GetPivot())
            ReplicatedStorage.Source.Network.RemoteEvents.Merchant:FireServer({
                Command = "SellAllTreasures",
                Merchant = Merchant
            })
            task.wait(0.1)
        until Capacity.Text ~= PreviousText
        player.Character:PivotTo(PreviousPosition)
        break
    end
end
local autoSellNewEnabled = false
local function processNewAutoSell()
    while autoSellNewEnabled do
        local player = game:GetService("Players").LocalPlayer
        local Capacity = player.PlayerGui.Main.Core.Inventory.Disclaimer.Capacity
        local Current = tonumber(Capacity.Text:split("(")[2]:split("/")[1])
        local Max = tonumber(Capacity.Text:split(")")[1]:split("/")[2])
        if Current and Max and Current >= Max then
            -- Store the current states
            local wasAutoWalking = autoWalkEnabled
            local wasAutoDigging = autoClickAndDigEnabled
            -- Store current position
            local currentPosition = player.Character and player.Character:GetPivot()
            -- Temporarily pause auto walk and auto dig
            autoWalkEnabled = false
            if wasAutoDigging then
                autoClickAndDigEnabled = false
            end
            -- Perform selling
            SellInventory()
            -- Wait for character to fully load after teleport
            task.wait(1.5)
            -- Make sure character exists
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Restore auto walk if it was enabled
                if wasAutoWalking then
                    task.wait(0.5)
                    autoWalkEnabled = true
                    -- Force restart the auto walk loop
                    task.spawn(function()
                        while autoWalkEnabled do
                            if not isMinigameActive then
                                Goto()
                            end
                            task.wait(0.1)
                        end
                    end)
                end
                -- Restore auto dig if it was enabled
                if wasAutoDigging then
                    task.wait(0.5)
                    autoClickAndDigEnabled = true
                    -- Force restart the auto dig loop
                    task.spawn(function()
                        handleAutoClickAndDig() -- Restart the dig loop
                    end)
                end
            end
        end
        task.wait(1)
    end
end
-- Add New Auto Sell toggle to UI
local NewAutoSellToggle = Tabs.Main:CreateToggle("NewAutoSellToggle", {
    Title = "💰 • Auto Sell Inventory at Max Capacity",
    Default = false,
    Callback = function(Value)
        autoSellNewEnabled = Value
        if Value then
            task.spawn(processNewAutoSell)
        end
    end
})
local autoRedeemContainersEnabled = false
local function processContainers()
    while autoRedeemContainersEnabled do
        local player = game:GetService("Players").LocalPlayer
        for _, Tool in pairs(player.Backpack:GetChildren()) do
            if Tool.Name:find("Box") or Tool.Name:find("Container") or Tool.Name:find("Chest") or Tool.Name:find("Pack") or Tool.Name:find("Present") or Tool.Name:find("Safe") or Tool.Name:find("Crate") then
                ReplicatedStorage.Source.Network.RemoteEvents.Treasure:FireServer({
                    Command = "RedeemContainer",
                    Container = Tool
                })
                task.wait(0.1)
            end
        end
        if player.Character then
            for _, Tool in pairs(player.Character:GetChildren()) do
                if Tool:IsA("Tool") and (Tool.Name:find("Box") or Tool.Name:find("Container") or Tool.Name:find("Chest") or Tool.Name:find("Pack") or Tool.Name:find("Present") or Tool.Name:find("Safe") or Tool.Name:find("Crate")) then
                    ReplicatedStorage.Source.Network.RemoteEvents.Treasure:FireServer({
                        Command = "RedeemContainer",
                        Container = Tool
                    })
                    task.wait(0.1)
                end
            end
        end
        task.wait(1)
    end
end
local AutoRedeemContainersToggle = Tabs.Main:CreateToggle("AutoRedeemContainersToggle",{
    Title = "📦 • Auto Open All Boxes",
    Default = false,
    Callback = function(Value)
        autoRedeemContainersEnabled = Value
        if Value then
            task.spawn(processContainers)
        end
    end
})
local PositionSection = Tabs.Walking:CreateSection("Position Controls")
-- Save Position Button
local SavePositionButton = Tabs.Walking:CreateButton({
    Title = "📍 Save Current Position",
    Description = "Save current position for auto walk area",
    Callback = function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            savedPosition = character.HumanoidRootPart.Position
            Fluent:Notify({
                Title = "Position Saved",
                Content = "Auto walk will now center around this position",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Could not save position. Character not found.",
                Duration = 3
            })
        end
    end
})
-- Reset Position Button
local ResetPositionButton = Tabs.Walking:CreateButton({
    Title = "🔄 Reset Saved Position",
    Description = "Reset to random walking mode",
    Callback = function()
        savedPosition = nil
        Fluent:Notify({
            Title = "Position Reset",
            Content = "Auto walk will now use random positions",
            Duration = 3
        })
    end
})

local RadiusSlider = Tabs.Walking:CreateSlider("RadiusSlider",{
    Title = "Walk Radius",
    Description = "Set the radius for auto walk area",
    Default = 20,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        radius = Value
        if autoWalkEnabled then
            createWalkVisualization() -- Update visualization when radius changes
        end
    end
})

local AutoWalkToggle = Tabs.Walking:CreateToggle("AutoWalkToggle",{
    Title = "🚶 • Auto Walk",
    Default = false,
    Callback = function(Value)
        autoWalkEnabled = Value
        if Value then
            task.spawn(function()
                while autoWalkEnabled do
                    if not isMinigameActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        Goto()
                    end
                    task.wait(0.1)
                end
            end)
        else
            cleanupVisualizations()
        end
    end
})

local Toggle = Tabs.Settingss:CreateToggle("Toggle",{
    Title = "Anti AFK",
    Default = false,
    Callback = function(Value)
        runningDraw = Value
        if runningDraw then
            task.spawn(function()
                while runningDraw do
                    local args = {
                        [1] = {
                            ["Command"] = "SetAFK",
                            ["State"] = false
                        }
                    }
                    game:GetService("ReplicatedStorage").Source.Network.RemoteEvents.Player:FireServer(unpack(args))
                    task.wait()
                end
            end)
        end
    end
})
-------------------pin tab --------------------------------
local inputValue = ""
local customPinItems = {}
local paragraphs = {}
local pinnedItemParagraphs = {}
local pinnedItemCounts = {}

-- Create sections for the Auto Pin feature
local PinSection = Tabs.Pinneds:CreateSection("Custom Auto Pin")
local PinnedSection = Tabs.Pinneds:CreateSection("Currently Pinned Items")

-- Helper function to clean and normalize item names for comparison
local function normalizeItemName(name)
    return name:lower():gsub("%s+", ""):gsub("[^%w]", "")
end

-- Helper function to check if an item should be pinned
local function shouldPinItem(toolName)
    local normalizedToolName = normalizeItemName(toolName)
    for _, itemName in ipairs(customPinItems) do
        local normalizedItemName = normalizeItemName(itemName)
        if normalizedToolName:find(normalizedItemName, 1, true) then
            return true, itemName
        end
    end
    return false, nil
end

-- Helper function to update pinned item display
local function updatePinnedItemDisplay(matchedItem, toolName, isPinned)
    if not isPinned then
        pinnedItemCounts[matchedItem] = (pinnedItemCounts[matchedItem] or 0) + 1

        if pinnedItemParagraphs[matchedItem] then
            pinnedItemParagraphs[matchedItem]:Destroy()
        end

        local counterText = pinnedItemCounts[matchedItem] > 1
            and string.format(" x%d", pinnedItemCounts[matchedItem])
            or ""

        pinnedItemParagraphs[matchedItem] = PinnedSection:CreateParagraph("PinnedItem_" .. matchedItem, {
            Title = "📌 Auto Pinned" .. counterText,
            Content = string.format("Item: %s (Matched: %s)", toolName, matchedItem)
        })
    end
end

-- Helper function to attempt pinning an item
local function attemptPin(Tool)
    if not Tool or not Tool:IsA("Tool") then return false end

    local toolId = Tool:GetAttribute("ID")
    if not toolId then return false end

    local success = pcall(function()
        ReplicatedStorage.Source.Network.RemoteFunctions.Inventory:InvokeServer({
            Command = "ToggleSlotPin",
            UID = toolId
        })
    end)

    return success
end

-- Enhanced PinItem function with immediate pinning
local function PinItem(Tool)
    if not autoPinEnabled then return end

    -- Wait for the tool to fully load its attributes
    task.wait()

    -- Check if the tool is already pinned
    local isPinned = Tool:GetAttribute("Pinned")
    if isPinned then return end

    -- Check if the tool should be pinned
    local shouldPin, matchedItem = shouldPinItem(Tool.Name)
    if shouldPin then
        -- Attempt to pin immediately
        if attemptPin(Tool) then
            updatePinnedItemDisplay(matchedItem, Tool.Name, false)
        end
    end
end

-- Input field for item names
local ItemInput = Tabs.Pinneds:CreateInput("ItemInput", {
    Title = "Item Name to Auto Pin",
    Placeholder = "Enter item name (e.g., Mole)",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        inputValue = Value
    end
})

-- Button to add items to the list
local AddButton = Tabs.Pinneds:CreateButton({
    Title = "Add Item to Pin List",
    Description = "Add new item to auto-pin list",
    Callback = function()
        if not inputValue or inputValue == "" then
            paragraphs[#paragraphs + 1] = PinSection:CreateParagraph("ErrorParagraph", {
                Title = "Error",
                Content = "Please enter an item name first!"
            })
            return
        end

        -- Check if item is already in the list (case-insensitive)
        local normalizedInput = normalizeItemName(inputValue)
        for _, existingItem in ipairs(customPinItems) do
            if normalizeItemName(existingItem) == normalizedInput then
                paragraphs[#paragraphs + 1] = PinSection:CreateParagraph("ErrorParagraph", {
                    Title = "Error",
                    Content = "This item is already in the pin list!"
                })
                return
            end
        end

        table.insert(customPinItems, inputValue)
        paragraphs[#paragraphs + 1] = PinSection:CreateParagraph("ItemParagraph_" .. #customPinItems, {
            Title = "Auto Pin Item #" .. #customPinItems,
            Content = inputValue
        })

        -- Check existing items if auto pin is enabled
        if autoPinEnabled then
            for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                PinItem(Tool)
            end
        end

        inputValue = ""
    end
})

-- Reset button to clear the list
local ResetButton = Tabs.Pinneds:CreateButton({
    Title = "Reset Pin List",
    Description = "Clear all items from auto-pin list",
    Callback = function()
        customPinItems = {}
        pinnedItemCounts = {}

        for _, paragraph in pairs(paragraphs) do
            if paragraph then paragraph:Destroy() end
        end
        table.clear(paragraphs)

        for _, paragraph in pairs(pinnedItemParagraphs) do
            if paragraph then paragraph:Destroy() end
        end
        table.clear(pinnedItemParagraphs)
    end
})

-- Toggle for enabling/disabling the auto pin system
local AutoPinToggle = Tabs.Pinneds:CreateToggle("AutoPinToggle", {
    Title = "📌 • Auto Pin Items",
    Default = false,
    Callback = function(Value)
        autoPinEnabled = Value
        if Value and #customPinItems > 0 then
            for _, Tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                PinItem(Tool)
            end
        end
    end
})

-- Connect to backpack changes with immediate pinning
HandleConnection(LocalPlayer.Backpack.ChildAdded:Connect(function(Tool)
    if autoPinEnabled then
        PinItem(Tool)
    end
end), "PinItem")

local selectedMole = nil
local EnchantSection = Tabs.Enchant:CreateSection("Mole Enchanting")
local moleList = {
    "Royal Mole",
    "Mole",
}
-- Dropdown for mole selection
local MoleDropdown = EnchantSection:CreateDropdown("MoleDropdown",{
    Title = "Select Mole",
    Description = "Choose which mole to use for enchanting",
    Values = moleList,
    Multi = false,
    Default = 1,
})
MoleDropdown:OnChanged(function(Value)
    selectedMole = Value
end)
local EnchantButton = EnchantSection:CreateButton({
    Title = "🔮 • Quick Enchant Shovel",
    Callback = function()
        if not selectedMole then
            Fluent:Notify({
                Title = "Missing Item",
                Content = "Please select a mole first!",
                Duration = 5
            })
            return
        end
        local Backpack = Player.Backpack
        local Mole = Backpack:FindFirstChild(selectedMole)
        if not Mole then
            Fluent:Notify({
                Title = "Missing Item",
                Content = "You don't have a " .. selectedMole .. " in your backpack!",
                Duration = 5
            })
            return
        end
        for _, Item in pairs(Backpack:GetChildren()) do
            if Item:GetAttribute("Type") ~= "Shovel" then
                continue
            end
            local Result = RemoteFunctions.MolePit:InvokeServer({
                Command = "OfferEnchant",
                ID = Mole:GetAttribute("ID")
            })
            if Result ~= true then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to offer the mole",
                    Duration = 5
                })
                return
            end
            Result = RemoteFunctions.MolePit:InvokeServer({
                Command = "OfferShovel",
                ID = Item:GetAttribute("ID")
            })
            if Result ~= true then
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to offer the shovel",
                    Duration = 5
                })
                return
            end
            Fluent:Notify({
                Title = "Success",
                Content = "Successfully enchanted your shovel!",
                Duration = 5
            })
            return
        end
    end,
})
-----------------end ----------------------
local function getTeleportLocations()
    local locations = {}
    local markers = workspace.Map.LocationMarkers:GetChildren()
    for _, marker in ipairs(markers) do
        if marker:IsA("BasePart") then
            table.insert(locations, marker.Name)
        end
    end
    return locations
end
local TeleportSection = Tabs.Teleport:CreateSection("Teleport")
local DropdownPlace = Tabs.Teleport:CreateDropdown("DropdownPlace", {
    Title = "Place teleport",
    Values = getTeleportLocations(),
    Multi = false,
    Default = false,
})
DropdownPlace:OnChanged(function(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local marker = workspace.Map.LocationMarkers:FindFirstChild(Value)
            if marker and marker:IsA("BasePart") then
                humanoidRootPart.CFrame = marker.CFrame
            end
        end
    end
end)
local PreviousLocation
local function MeteorIslandTeleport(Meteor)
    if not Meteor or Meteor.Name ~= "Meteor Island" or not toggleStateAutoMeteor then
        return
    end
    local Character = LocalPlayer.Character
    if not Character then return end
    PreviousLocation = Character:GetPivot()
    Character:PivotTo(Meteor:GetPivot() + Vector3.yAxis * Meteor:GetExtentsSize().Y / 2)
end
local AutoMeteorToggle = Tabs.Teleport:CreateToggle("AutoMeteorToggle",{
    Title = "🌠 • Auto Teleport to Meteor Islands",
    Default = false,
    Callback = function(Value)
        toggleStateAutoMeteor = Value
        if Value then
            for _, v in pairs(workspace.Map.Temporary:GetChildren()) do
                MeteorIslandTeleport(v)
            end
        elseif PreviousLocation then
            LocalPlayer.Character:PivotTo(PreviousLocation)
        end
    end
})
HandleConnection(workspace.Map.Temporary.ChildAdded:Connect(MeteorIslandTeleport), "Meteor")
HandleConnection(workspace.Map.Temporary.ChildRemoved:Connect(function(Child)
    if Child.Name == "Meteor Island" and PreviousLocation and toggleStateAutoMeteor then
        LocalPlayer.Character:PivotTo(PreviousLocation)
    end
end), "MeteorRemoved")
-- Lunar Clouds Implementation
local function LunarCloudsTeleport(Lunar)
    if not Lunar or Lunar.Name ~= "Lunar Clouds" or not toggleStateAutoLunar then
        return
    end
    local Character = LocalPlayer.Character
    if not Character then return end
    PreviousLocation = Character:GetPivot()
    Character:PivotTo(Lunar:GetPivot() + Vector3.yAxis * Lunar:GetExtentsSize().Y / 2)
end
local AutoLunarToggle = Tabs.Teleport:CreateToggle("AutoLunarToggle",{
    Title = "✨ • Auto Teleport to Lunar Clouds",
    Default = false,
    Callback = function(Value)
        toggleStateAutoLunar = Value
        if Value then
            for _, v in pairs(workspace.Map.Islands:GetChildren()) do
                LunarCloudsTeleport(v)
            end
        elseif PreviousLocation then
            LocalPlayer.Character:PivotTo(PreviousLocation)
        end
    end
})
HandleConnection(workspace.Map.Islands.ChildAdded:Connect(LunarCloudsTeleport), "LunarClouds")
HandleConnection(workspace.Map.Islands.ChildRemoved:Connect(function(Child)
    if Child.Name == "Lunar Clouds" and PreviousLocation and toggleStateAutoLunar then
        LocalPlayer.Character:PivotTo(PreviousLocation)
    end
end), "LunarCloudsRemoved")
-------------------end teleport ----------------
Tabs.Settingss:CreateButton({
    Title = "Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/3ZQBHpfQ5X")
    end
})
-- Add connections for Meteor Islands
Workspace.Map.Temporary.ChildAdded:Connect(MeteorIslandTeleport)
Workspace.Map.Temporary.ChildRemoved:Connect(function(Child)
    if Child.Name == "Meteor Island" and PreviousLocation and meteorTeleportEnabled then
        LocalPlayer.Character:PivotTo(PreviousLocation)
    end
end)
-- Add connections for Lunar Clouds
Workspace.Map.Islands.ChildAdded:Connect(LunarCloudsTeleport)
Workspace.Map.Islands.ChildRemoved:Connect(function(Child)
    if Child.Name == "Lunar Clouds" and PreviousLocation and lunarCloudsTeleportEnabled then
        LocalPlayer.Character:PivotTo(PreviousLocation)
    end
end)
-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)
setupMinigameMonitoring()
