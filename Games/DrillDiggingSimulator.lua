local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "50386c8e6db647e989e8287884ed4643"
local falseData = "3dd2a83058884b4794854e49eabe047c"

KeyGuardLibrary.Set({
    publicToken = "b9810f845ef34630a8a039a0ed4b0c7b",
    privateToken = "f4bf8dc58f45478497af32dadc405cbf",
    trueData = trueData,
    falseData = falseData,
})

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local key = ""

local Windows = Fluent:CreateWindow({
    Title = "Key System",
    SubTitle = "Xenon",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    KeySys = Windows:AddTab({ Title = "Key System", Icon = "key" }),
}

local Entkey = Tabs.KeySys:AddInput("Input", {
    Title = "Enter Key",
    Description = "Enter Key Here",
    Default = "",
    Placeholder = "Enter key…",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        key = Value
    end
})

local Checkkey = Tabs.KeySys:AddButton({
    Title = "Check Key",
    Description = "Enter Key before pressing this button",
    Callback = function()
        local response = KeyGuardLibrary.validateDefaultKey(key)
        if response == trueData then
            print("Key is valid")
            -- Show success notification before destroying
            Fluent:Notify({
                Title = "Success",
                Content = "Key is valid! Loading script...",
                Duration = 2
            })

            -- Wait for notification to show before destroying
            task.wait(2)

            -- Destroy the Windows
            Windows:Destroy()
            -- Load Fluent UI Library
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local OriginalPlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local PlaceName = OriginalPlaceName

local Window = Library:CreateWindow({
    Title = `Xenon | {PlaceName}`,
    SubTitle = "https://discord.gg/3ZQBHpfQ5X",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Viow Mars",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Create Tabs
local Tabs = {
    Main = Window:CreateTab({ Title = "Main", Icon = "house" }),
    Gamepass = Window:CreateTab({ Title = "Gamepass", Icon = "ticket" }),
    DrillPower = Window:CreateTab({ Title = "Drill Power", Icon = "wrench" }),
    Settings = Window:CreateTab({Title = "Settings", Icon = "settings"})
}

--<>----<>----<>----< Anti Afk >----<>----<>----<>--
game.Players.LocalPlayer.Idled:Connect(function()
  VirtualUser:CaptureController()
  VirtualUser:ClickButton2(Vector2.new())
end)

-- Function to get all drills from backpack
local function getDrillsList()
    local drills = {}

    -- Check Backpack
    local backpack = LocalPlayer:WaitForChild("Backpack")
    for _, item in pairs(backpack:GetChildren()) do
        table.insert(drills, item.Name)
    end

    -- Check currently equipped items
    if LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(drills, item.Name)
            end
        end
    end

    -- Remove duplicates
    local uniqueDrills = {}
    local seen = {}
    for _, drill in ipairs(drills) do
        if not seen[drill] then
            seen[drill] = true
            table.insert(uniqueDrills, drill)
        end
    end

    return uniqueDrills
end

-- Create drill dropdown
local selectedDrill = nil
local DrillDropdown = Tabs.Main:CreateDropdown("DrillDropdown", {
    Title = "Select Drill",
    Values = getDrillsList(),
    Multi = false,
    Default = 1,
})

DrillDropdown:OnChanged(function(value)
    selectedDrill = value
    Library:Notify({
        Title = "Drill Selected",
        Content = "Selected drill: " .. value,
        Duration = 2
    })
end)

-- Create GiveCash toggle
local ToggleGiveCash = Tabs.Main:CreateToggle("ToggleGiveCash", {
    Title = "Auto Give Cash",
    Default = false
})

-- GiveCash function
local giveCashConnection
ToggleGiveCash:OnChanged(function(state)
    if giveCashConnection then
        giveCashConnection:Disconnect()
        giveCashConnection = nil
    end

    if state then
        giveCashConnection = RunService.Heartbeat:Connect(function()
            if not selectedDrill then
                ToggleGiveCash:SetValue(false)
                Library:Notify({
                    Title = "Error",
                    Content = "Please select a drill first!",
                    Duration = 3
                })
                return
            end

            -- Check if player exists in workspace.Players
            local playerInWorkspace = workspace.Players:FindFirstChild(LocalPlayer.Name)
            if not playerInWorkspace then return end

            -- Check if selected drill is equipped
            local equippedTool = playerInWorkspace:FindFirstChild(selectedDrill)
            if not equippedTool then
                -- Tool is not equipped, try to equip it
                local backpackTool = LocalPlayer.Backpack:FindFirstChild(selectedDrill)
                if backpackTool then
                    backpackTool.Parent = LocalPlayer.Character
                    -- Wait a frame for the tool to be equipped
                    RunService.Heartbeat:Wait()
                    equippedTool = playerInWorkspace:FindFirstChild(selectedDrill)
                end
            end

            if equippedTool then
                -- Execute GiveCash
                local args = {
                    [1] = equippedTool
                }
                game:GetService("ReplicatedStorage"):WaitForChild("GiveCash"):FireServer(unpack(args))
            end
        end)
    end
end)

-- Refresh drill list button
Tabs.Main:CreateButton({
  Title = "Refresh Drill List",
  Callback = function()
      local newDrills = getDrillsList()
      DrillDropdown:SetValues(newDrills)
      Library:Notify({
          Title = "Refresh Complete",
          Content = "Found " .. #newDrills .. " drills",
          Duration = 3
      })
  end
})

local function grabTools()
  local playerhead = game.Players.LocalPlayer.Character.Head
  local tools = game:GetService("Workspace").Worlds.Jungle.EndZone.EndCircle:GetDescendants()

  -- Loop through tools and grab them if toggle is enabled
  for _, tool in pairs(tools) do
      if not grabEnabled then
          return -- Stop grabbing if toggle is off
      end

      if tool:IsA("BasePart") then
          -- Check for TouchTransmitter in the part itself or its descendants
          local touchInterest = tool:FindFirstChildOfClass("TouchTransmitter") or tool:FindFirstChildWhichIsA("TouchTransmitter", true)
          if touchInterest then
              firetouchinterest(playerhead, tool, 0)
              wait(0.05)
              firetouchinterest(playerhead, tool, 1)
          end
      end
  end
end

local WinToggle = Tabs.Main:CreateToggle("WinToggle", {Title = "Auto Win Jungle", Default = false })

WinToggle:OnChanged(function(Value)
  grabEnabled = Value
  if grabEnabled then
      -- Start grabbing when enabled
      coroutine.wrap(function()
          while grabEnabled do
              grabTools()
              task.wait() -- Adjust delay as needed
          end
      end)()
  end
end)

-- Create Gamepass toggles
local gamepasses = LocalPlayer:WaitForChild("Data"):WaitForChild("Gamepasses")
for _, gamepass in pairs(gamepasses:GetChildren()) do
    if gamepass:IsA("BoolValue") then
        Tabs.Gamepass:CreateToggle("Toggle" .. gamepass.Name, {
            Title = gamepass.Name,
            Default = gamepass.Value
        }):OnChanged(function(state)
            gamepass.Value = state
        end)
    end
end

-- Create DrillPower slider
local drillPowerMultiplier = LocalPlayer:WaitForChild("DrillPowerMultiplier")
Tabs.DrillPower:CreateSlider("DrillPowerSlider", {
    Title = "Drill Power Multiplier",
    Default = drillPowerMultiplier.Value,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        drillPowerMultiplier.Value = value
    end
})

-- Auto-refresh drill list when tools change
LocalPlayer.Backpack.ChildAdded:Connect(function()
    DrillDropdown:SetValues(getDrillsList())
end)

LocalPlayer.Backpack.ChildRemoved:Connect(function()
    DrillDropdown:SetValues(getDrillsList())
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function()
        DrillDropdown:SetValues(getDrillsList())
    end)

    LocalPlayer.Character.ChildRemoved:Connect(function()
        DrillDropdown:SetValues(getDrillsList())
    end)
end


SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("XenonScriptHub")
SaveManager:SetFolder("XenonScriptHub/specific-game")

-- InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Xenon",
    Content = "The script has been loaded.",
    Duration = 8
}
SaveManager:LoadAutoloadConfig()


            -- Your code here after Windows is destroyed

        else
            print("Key is invalid")
            -- Show error notification
            Fluent:Notify({
                Title = "Error",
                Content = "Invalid key! Please try again.",
                Duration = 2
            })
        end
    end
})

local Getkey = Tabs.KeySys:AddButton({
    Title = "Get Key",
    Description = "Get Key here",
    Callback = function()
        setclipboard(KeyGuardLibrary.getLink())
        -- Show notification that link was copied
        Fluent:Notify({
            Title = "Success",
            Content = "Key link copied to clipboard!",
            Duration = 2
        })
    end
})

Windows:SelectTab(1)
