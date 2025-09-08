-- TrainStatUI - Script para entrenar Sword y Speed con switches y UI movible

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- RemoteEvents
local EquipStatUpdateEvent = ReplicatedStorage:WaitForChild("Event"):WaitForChild("EquipStatUpdateEvent")
local ShowStatEffect = ReplicatedStorage:WaitForChild("Event"):WaitForChild("ShowStatEffect")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrainStatUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true -- Necesario para drag
Frame.Draggable = true -- Hace la UI movible
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

-- Train Logic
local function trainSword()
    if swordActive then
        -- Equip Sword via remote event (NO .Activate!)
        EquipStatUpdateEvent:FireServer("Sword")
    end
end

local function trainSpeed()
    if speedActive then
        -- Activa speed via remote event
        EquipStatUpdateEvent:FireServer("Speed")
        ShowStatEffect:FireServer("Speed", 1)
    end
end

-- Loop cada 4 segundos
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

-- DRAG UI (para compatibilidad universal, si Draggable da problemas en dispositivos móviles)
local dragging
local dragInput
local dragStart
local startPos

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
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
