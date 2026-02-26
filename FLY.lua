-- ╔══════════════════════════════╗
-- ║   FLY SCRIPT - Delta Ready   ║
-- ║   GUI con ON/OFF + Velocidad ║
-- ╚══════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Esperar el character correctamente
repeat task.wait() until player.Character
local character = player.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

-- ══════════════════════════════
--       FUNCIONES DE VUELO
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

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        bodyVelocity.Velocity = (dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero)
        bodyGyro.CFrame = cam.CFrame
    end)
end

local function disableFly()
    flying = false
    humanoid.PlatformStand = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
end

-- ══════════════════════════════
--     GUI - COMPATIBLE DELTA
-- ══════════════════════════════

-- Limpiar GUI previa si existe
local oldGui = (gethui and gethui() or game:GetService("CoreGui")):FindFirstChild("DeltaFlyGUI")
if oldGui then oldGui:Destroy() end

-- Parent correcto para executors
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.DisplayOrder = 999 end)
screenGui.Parent = guiParent

-- Marco principal
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 230, 0, 190)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(110, 80, 255)
stroke.Thickness = 2

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✈  FLY SCRIPT"
titleLabel.TextColor3 = Color3.fromRGB(190, 160, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 28)
statusLabel.Position = UDim2.new(0, 0, 0, 47)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Estado: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = frame

-- Botón toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 180, 0, 38)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 82)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "ACTIVAR VUELO"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 9)

-- Label velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 24)
speedLabel.Position = UDim2.new(0, 0, 0, 130)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

-- Botón MENOS
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 60, 0, 32)
minusBtn.Position = UDim2.new(0, 20, 0, 158)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 110)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 20
minusBtn.Font = Enum.Font.GothamBold
minusBtn.BorderSizePixel = 0
minusBtn.Parent = frame
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 8)

-- Botón MAS
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 60, 0, 32)
plusBtn.Position = UDim2.new(1, -80, 0, 158)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 110)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 20
plusBtn.Font = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0
plusBtn.Parent = frame
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 8)

-- ══════════════════════════════
--        EVENTOS BOTONES
-- ══════════════════════════════

toggleBtn.MouseButton1Click:Connect(function()
    if not flying then
        enableFly()
        toggleBtn.Text = "DESACTIVAR VUELO"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        statusLabel.Text = "● Estado: ON"
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    else
        disableFly()
        toggleBtn.Text = "ACTIVAR VUELO"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "● Estado: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

plusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, 10, 500)
    speedLabel.Text = "Velocidad: " .. flySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, 10, 500)
    speedLabel.Text = "Velocidad: " .. flySpeed
end)

-- Reset al respawnear
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    flying = false
    flyConnection = nil
    toggleBtn.Text = "ACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    statusLabel.Text = "● Estado: OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
end)

print("[FlyScript] Cargado correctamente ✓")
