-- Flight Script with GUI | By: Script
-- Compatible con Delta Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil

-- ══════════════════════════════
--         FUNCIONES VUELO
-- ══════════════════════════════

local function enableFly()
    flying = true
    humanoid.PlatformStand = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = humanoidRootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.D = 100
    bodyGyro.P = 1000
    bodyGyro.Parent = humanoidRootPart

    connection = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local camera = workspace.CurrentCamera
        local direction = Vector3.zero
        local cf = camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        bodyVelocity.Velocity = direction * flySpeed
        bodyGyro.CFrame = cf
    end)
end

local function disableFly()
    flying = false
    humanoid.PlatformStand = false

    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if connection then connection:Disconnect() end
end

-- ══════════════════════════════
--           GUI
-- ══════════════════════════════

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Stroke (borde)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 80, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
title.BorderSizePixel = 0
title.Text = "✈  FLY SCRIPT"
title.TextColor3 = Color3.fromRGB(180, 150, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Label estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = mainFrame

-- Botón ON/OFF
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 36)
toggleBtn.Position = UDim2.new(0.075, 0, 0, 82)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleBtn.Text = "ACTIVAR VUELO"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- Label velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 128)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Botones velocidad
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 50, 0, 30)
minusBtn.Position = UDim2.new(0.08, 0, 0, 148)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
minusBtn.Text = "  -  "
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 18
minusBtn.Font = Enum.Font.GothamBold
minusBtn.BorderSizePixel = 0
minusBtn.Parent = mainFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = minusBtn

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 50, 0, 30)
plusBtn.Position = UDim2.new(0.62, 0, 0, 148)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
plusBtn.Text = "  +  "
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 18
plusBtn.Font = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0
plusBtn.Parent = mainFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plusBtn

-- ══════════════════════════════
--         LÓGICA BOTONES
-- ══════════════════════════════

toggleBtn.MouseButton1Click:Connect(function()
    if not flying then
        enableFly()
        toggleBtn.Text = "DESACTIVAR VUELO"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        statusLabel.Text = "Estado: ON ✔"
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        disableFly()
        toggleBtn.Text = "ACTIVAR VUELO"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        statusLabel.Text = "Estado: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

plusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, 10, 500)
    speedLabel.Text = "Velocidad: " .. flySpeed
    if bodyVelocity then
        -- se actualiza automáticamente en el loop
    end
end)

minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, 10, 500)
    speedLabel.Text = "Velocidad: " .. flySpeed
end)

-- Re-obtener character si respawnea
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    flying = false
    toggleBtn.Text = "ACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    statusLabel.Text = "Estado: OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
end)
