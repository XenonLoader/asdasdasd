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

local Window = Fluent:CreateWindow({
    Title = "a 1.3",
    SubTitle = "by XenonHUB",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:CreateTab({ Title = "Main", Icon = "home" }),
    Settings = Window:CreateTab({ Title = "Credits", Icon = "info" })
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

-- Minigame Auto System
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

    if isDigMinigameLocked then
        activeConnections[digMinigame] = RunService.Heartbeat:Connect(function()
            if cursor and cursor.Parent and area and area.Parent then
                cursor.Position = area.Position
                
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

local radius = 20

-- Function to find nearest owned model
local function findNearestOwnedModel()
    local character = player.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local nearestModel = nil
    local shortestDistance = math.huge
    
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
        -- Check if the hit part has properties typically associated with water
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
    
    -- Try up to 10 times to find a non-water position
    for i = 1, 10 do
        local randomAngle = math.random() * 2 * math.pi
        local randomDistance = math.random() * radius
        local offsetX = math.cos(randomAngle) * randomDistance
        local offsetZ = math.sin(randomAngle) * randomDistance
        local newTargetPos = rootPart.Position + Vector3.new(offsetX, 0, offsetZ)
        
        -- Check if the position is not in water
        if not isWaterPosition(newTargetPos) then
            return newTargetPos
        end
    end
    
    -- If we couldn't find a non-water position, return nil
    return nil
end

-- Enhanced Goto function with model interaction and water avoidance
local function Goto()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- First check for owned models
    local nearestModel = findNearestOwnedModel()
    local targetPos
    
    if nearestModel and nearestModel.PrimaryPart then
        targetPos = nearestModel.PrimaryPart.Position
        -- Check if the model is not in water
        if isWaterPosition(targetPos) then
            targetPos = nil
        end
    end
    
    -- If no valid model position, get random position
    if not targetPos then
        targetPos = getRandomTargetPosition()
    end
    
    if not targetPos then return end
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(rootPart.Position, targetPos)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        
        for _, waypoint in ipairs(waypoints) do
            if not autoWalkEnabled or isMinigameActive then break end
            
            -- Check if waypoint is in water
            if not isWaterPosition(waypoint.Position) then
                humanoid:MoveTo(waypoint.Position)
                
                if waypoint.Action == Enum.PathWaypointAction.Jump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                
                local reachedWaypoint = humanoid.MoveToFinished:Wait()
                
                -- If we reached the final waypoint and it was a model
                if reachedWaypoint and nearestModel and _ == #waypoints then
                    local pileIndex = tonumber(nearestModel.Name)
                    if pileIndex then
                        -- Click the model
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        task.wait(0.1)
                        game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
                        
                        -- Enter minigame
                        digPile(pileIndex)
                    end
                end
                
                if not reachedWaypoint then break end
            else
                -- If waypoint is in water, break and try a new path
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


local function LegitDig()
    local player = game:GetService("Players").LocalPlayer
    local DigMinigame = player.PlayerGui.Main:FindFirstChild("DigMinigame")

    if not DigMinigame then
        return
    end

    local Connection
    Connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not player.PlayerGui.Main:FindFirstChild("DigMinigame") or not autoClickAndDigEnabled then
            if Connection then
                Connection:Disconnect()
            end
            return
        end

        DigMinigame.Cursor.Position = DigMinigame.Area.Position
    end)
end

local function handleAutoClickAndDig()
    while autoClickAndDigEnabled do
        if not isMinigameActive then
            -- Check for shovel tool
            local player = game:GetService("Players").LocalPlayer
            local Tool = player.Character:FindFirstChildOfClass("Tool")
            
            if Tool and Tool:GetAttribute("Type") == "Shovel" then
                Tool:Activate()
                
                -- Create new pile after activation
                local createArgs = {
                    [1] = {
                        ["Command"] = "CreatePile"
                    }
                }
                ReplicatedStorage.Source.Network.RemoteFunctions.Digging:InvokeServer(unpack(createArgs))
            end
        else
            -- Handle minigame digging
            LegitDig()
            
            -- Auto dig when in minigame
            local digMinigame = LocalPlayer.PlayerGui.Main:FindFirstChild("DigMinigame")
            if digMinigame then
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
            end
        end
        task.wait()
    end
end

-- Update the existing AutoClickDigToggle
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


LocalPlayer.PlayerGui.Main.ChildAdded:Connect(function(child)
    if child.Name == "DigMinigame" and autoClickAndDigEnabled then
        LegitDig()
    end
end)

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
        task.wait(5)
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
            local wasInMinigame = isMinigameActive
            local wasWalking = autoWalkEnabled
            
            if wasWalking then
                autoWalkEnabled = false
            end
            
            SellInventory()
            
            if wasWalking then
                task.wait(0.5)
                autoWalkEnabled = true
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

-- Add this function before the Settings Tab
local function processContainers()
    while autoRedeemContainersEnabled do
        local player = game:GetService("Players").LocalPlayer
        
        -- Check backpack for any containers/boxes
        for _, Tool in pairs(player.Backpack:GetChildren()) do
            if Tool.Name:find("Box") or Tool.Name:find("Container") or Tool.Name:find("Chest") or Tool.Name:find("Pack") then
                ReplicatedStorage.Source.Network.RemoteEvents.Treasure:FireServer({
                    Command = "RedeemContainer",
                    Container = Tool
                })
                task.wait(0.1) -- Small delay between redemptions
            end
        end
        
        -- Also check equipped tools
        if player.Character then
            for _, Tool in pairs(player.Character:GetChildren()) do
                if Tool:IsA("Tool") and (Tool.Name:find("Box") or Tool.Name:find("Container") or Tool.Name:find("Chest") or Tool.Name:find("Pack")) then
                    ReplicatedStorage.Source.Network.RemoteEvents.Treasure:FireServer({
                        Command = "RedeemContainer",
                        Container = Tool
                    })
                    task.wait(0.1)
                end
            end
        end
        
        task.wait(1) -- Wait before next check
    end
end

-- Add the new Auto Redeem Containers toggle before the Settings Tab
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


local AutoWalkToggle = Tabs.Main:CreateToggle("AutoWalkToggle",{
    Title = "Auto Walk",
    Default = false,
    Callback = function(Value)
        autoWalkEnabled = Value
        if Value then
            task.spawn(function()
                while autoWalkEnabled do
                    if not isMinigameActive then
                        Goto()
                        task.wait(1)
                    else
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
})

local Toggle = Tabs.Main:CreateToggle("Toggle",{
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

--["Badlands"] = CFrame.new(),

local teleportSpots = {
    ["Badlands"] = CFrame.new(1193.10315, 11.0881357, 374.344391, -0.927843273, 2.78985346e-09, 0.372970313, -5.50288481e-10, 1, -8.84905482e-09, -0.372970313, -8.41577741e-09, -0.927843273),
    ["Greek Temple"] = CFrame.new(1158.27454, 7.94861031, 1030.42358, -0.527037799, 3.26573124e-09, -0.849841833, -8.29276203e-08, 1, 5.52711334e-08, 0.849841833, 9.96053373e-08, -0.527037799),
    ["Lunar New Year"] = CFrame.new(551.72998, 5.63548183, 336.478516, -0.799810469, -1.71022094e-08, -0.600252628, -1.24915163e-08, 1, -1.1847284e-08, 0.600252628, -1.97751659e-09, -0.799810469),
    ["Nookville"] = CFrame.new(200.922195, 4.66936779, 0.529632807, -0.60518837, 4.73828052e-08, -0.796082318, 2.36883402e-08, 1, 4.15119104e-08, 0.796082318, 6.26465502e-09, -0.60518837),
    ["Permafrost"] = CFrame.new(699.282776, 16.2887917, 1734.53711, 0.802090406, 1.25928235e-09, -0.597202599, -2.88433433e-09, 1, -1.76525439e-09, 0.597202599, 3.13842552e-09, 0.802090406),
    ["Piratesburg"] = CFrame.new(-6.21063709, 19.9108906, 578.878967, 0.734266639, -9.59031343e-09, -0.678861201, -1.10683451e-09, 1, -1.5324229e-08, 0.678861201, 1.20034578e-08, 0.734266639),
    ["Mole Island"] = CFrame.new(559.143127, 5.76374149, 839.091858, 0.887409687, -3.80517911e-08, 0.460981578, 6.62563124e-08, 1, -4.50011619e-08, -0.460981578, 7.04774124e-08, 0.887409687),
}

local TeleportSection = Tabs.Main:CreateSection("Teleport")

local DropdownPlace = Tabs.Main:CreateDropdown("DropdownPlace", {
    Title = "Place teleport",
    Values = {"Badlands", "Greek Temple", "Lunar New Year", "Nookville", "Permafrost", "Piratesburg", "Mole Island"},
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

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)

setupMinigameMonitoring()

-- Settings Tab
Tabs.Settings:CreateParagraph({
    Title = "Discord",
    Content = "https://discord.gg/3ZQBHpfQ5X"
})

Tabs.Settings:CreateButton({
    Title = "Copy Link Discord",
    Callback = function()
        setclipboard("https://discord.gg/3ZQBHpfQ5X")
    end
})
