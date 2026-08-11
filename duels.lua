-- Script completo con GUI para auto-farm de kills (wushang52)
-- Creado por Vrex488 - Modo automático con interruptor ON/OFF

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Auto-Farm Kills [wushang52]"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.6, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 16
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 35)
toggleButton.Position = UDim2.new(0.6, 10, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.Text = "ON"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = frame

local killCounterLabel = Instance.new("TextLabel")
killCounterLabel.Size = UDim2.new(1, 0, 0, 25)
killCounterLabel.Position = UDim2.new(0, 0, 0, 85)
killCounterLabel.BackgroundTransparency = 1
killCounterLabel.Text = "Kills: 0"
killCounterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
killCounterLabel.Font = Enum.Font.SourceSans
killCounterLabel.TextSize = 14
killCounterLabel.Parent = frame

-- Variables de control
local autoFarmActive = false
local killCount = 0
local connection = nil

-- Función de ataque
local function attackTarget()
    local p = game.Players:FindFirstChild("wushang52")
    if p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local weaponDamage = replicatedStorage:FindFirstChild("WeaponDamage")
        if weaponDamage then
            weaponDamage:FireServer(p.Character.Humanoid, 8238)
            killCount = killCount + 1
            killCounterLabel.Text = "Kills: " .. killCount
        end
    end
end

-- Función para iniciar/detener auto-farm
local function toggleAutoFarm()
    autoFarmActive = not autoFarmActive
    
    if autoFarmActive then
        statusLabel.Text = "Estado: ON"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        toggleButton.Text = "OFF"
        
        -- Iniciar bucle
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if autoFarmActive then
                attackTarget()
                wait(0.3)
            end
        end)
    else
        statusLabel.Text = "Estado: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleButton.Text = "ON"
        
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end

-- Evento del botón
toggleButton.MouseButton1Click:Connect(toggleAutoFarm)

-- Ataque manual con tecla 'X'
mouse.KeyDown:Connect(function(key)
    if key == "x" then
        attackTarget()
    end
end)

print("GUI cargada. Presiona 'X' para ataque manual. Botón ON/OFF para auto-farm.")
