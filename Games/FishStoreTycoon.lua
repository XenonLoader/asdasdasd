
local getgenv: () -> ({[string]: any}) = getfenv().getgenv

getgenv().ScriptVersion = "v1.0.1"
getgenv().Changelog = [[
• Wait for update
]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/XenonLoader/NewRepo/refs/heads/main/Cr.lua"))()

local ApplyUnsupportedName: (Name: string, Condition: boolean) -> (string) = getgenv().ApplyUnsupportedName

local Flags: {[string]: {["CurrentValue"]: any, ["CurrentOption"]: {string}}} = getgenv().Flags

local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFunctions: {[string]: RemoteFunction} = ReplicatedStorage.RemoteFunctions
local RemoteEvents: {[string]: RemoteEvent} = ReplicatedStorage.RemoteEvents

local Window = getgenv().Window

if not Window then
	return
end

local Tab = Window:CreateTab("Automatics", "repeat")

Tab:CreateSection("Main")

Tab:CreateToggle({
    Name = "🗑️ • Auto Sell Junk",
    CurrentValue = false,
    Flag = "SellJunk",
    Callback = function(Value)
        while Flags.SellJunk.CurrentValue and task.wait() do
            local args = {
                [1] = getNil("Shelf36", "Model")
            }
            RemoteFunctions.SellJunk:InvokeServer()
        end
    end,
})


getgenv().CreateUniversalTabs()
