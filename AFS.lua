--[[
Script: TrainStatUI.lua
Description: Roblox Lua script that creates a UI with switches to "Train Sword" and "Train Speed".
- "Train Sword" switch: When ON, simulates the click on the SwordButton and equips the sword (using remote event).
- "Train Speed" switch: When ON, fires the remote event for Speed.
- Each stat trains every 4 seconds while ON.
- Nerfs/Buffs can be customized (as described).
Place this script in StarterGui or StarterPlayerScripts as appropriate.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- RemoteEvents
local EquipStatUpdateEvent = ReplicatedStorage:WaitForChild("Event"):WaitForChild("EquipStatUpdateEvent")
local ShowStatEffect = ReplicatedStorage:WaitForChild("Event"):WaitForChild("ShowStatEffect")
local SummonChampion = ReplicatedStorage:WaitForChild("Event"):WaitForChild("SummonChampion")
local UpdateQuestProgressGui = ReplicatedStorage:WaitForChild("Event"):WaitForChild("UpdateQuestProgressGui")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainStatUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Train Stats"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

local SwordSwitch = Instance.new("TextButton")
SwordSwitch.Size = UDim2.new(0.9, 0, 0, 30)
SwordSwitch.Position = UDim2.new(0.05, 0, 0, 40)
SwordSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SwordSwitch.Text = "Train Sword [OFF]"
SwordSwitch.TextColor3 = Color3.new(1, 1, 1)
SwordSwitch.Font = Enum.Font.SourceSans
SwordSwitch.TextSize = 18
SwordSwitch.Parent = Frame

local SpeedSwitch = Instance.new("TextButton")
SpeedSwitch.Size = UDim2.new(0.9, 0, 0, 30)
SpeedSwitch.Position = UDim2.new(0.05, 0, 0, 80)
SpeedSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedSwitch.Text = "Train Speed [OFF]"
SpeedSwitch.TextColor3 = Color3.new(1, 1, 1)
SpeedSwitch.Font = Enum.Font.SourceSans
SpeedSwitch.TextSize = 18
SpeedSwitch.Parent = Frame

-- Switch States
local swordActive = false
local speedActive = false

-- SwordButton Path (change as needed to match your actual UI)
local swordButtonPath = player.PlayerGui:FindFirstChild("Main")
  and player.PlayerGui.Main:FindFirstChild("Category")
  and player.PlayerGui.Main.Category:FindFirstChild("Hotkeys")
  and player.PlayerGui.Main.Category.Hotkeys:FindFirstChild("SwordButton") or nil

-- Train Logic
local function trainSword()
    if swordActive then
        -- Simulate click on SwordButton UI
        if swordButtonPath then
            swordButtonPath:Activate()
        end
        -- Equip Sword via remote event
        EquipStatUpdateEvent:FireServer("Sword")
        -- Special buffs/nerfs (example)
        -- Nerf Chakra damage by 30, buff by 20, buff Sword Styles by 25, nerf by 20
        -- You can implement this logic server-side if needed
    end
end

local function trainSpeed()
    if speedActive then
        -- Activate speed stat via remote event
        EquipStatUpdateEvent:FireServer("Speed")
        -- Show stat effect (visual feedback)
        ShowStatEffect:FireServer("Speed", 1)
    end
end

-- Every 4 seconds loop for both stats
spawn(function()
    while true do
        if swordActive then trainSword() end
        if speedActive then trainSpeed() end
        wait(4)
    end
end)

-- Switch Toggle Functions
SwordSwitch.MouseButton1Click:Connect(function()
    swordActive = not swordActive
    SwordSwitch.Text = swordActive and "Train Sword [ON]" or "Train Sword [OFF]"
end)

SpeedSwitch.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    SpeedSwitch.Text = speedActive and "Train Speed [ON]" or "Train Speed [OFF]"
end)

-- Optional: UI drag
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
