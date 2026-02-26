-- ╔═══════════════════════════════════════╗
-- ║     SUPERHERO FLY - Delta Ready       ║
-- ║   Vuelo cinematico con inclinacion    ║
-- ╚═══════════════════════════════════════╝

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")

local player = Players.LocalPlayer
repeat task.wait() until player.Character
local character       = player.Character
local root            = character:WaitForChild("HumanoidRootPart")
local humanoid        = character:WaitForChild("Humanoid")
local animator        = humanoid:WaitForChild("Animator")

-- ══════════════════════════════════════════
--              CONFIGURACIÓN
-- ══════════════════════════════════════════
local CFG = {
    speed        = 80,       -- velocidad base
    maxSpeed     = 500,
    minSpeed     = 10,
    speedStep    = 10,
    acceleration = 0.18,     -- qué tan rápido acelera  (0-1)
    tiltAngle    = 55,       -- grados de inclinación al volar
    tiltSpeed    = 0.12,     -- suavidad de la inclinación
}

-- ══════════════════════════════════════════
--              ESTADO
-- ══════════════════════════════════════════
local flying        = false
local velocity      = Vector3.zero   -- velocidad actual suavizada
local bv, bg        = nil, nil
local flyConn       = nil

-- ══════════════════════════════════════════
--          FUNCIONES AUXILIARES
-- ══════════════════════════════════════════

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lerpV3(a, b, t)
    return Vector3.new(lerp(a.X,b.X,t), lerp(a.Y,b.Y,t), lerp(a.Z,b.Z,t))
end

local function getCamDirection()
    local cam = workspace.CurrentCamera
    local dir = Vector3.zero
    local cf  = cam.CFrame

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        dir += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        dir -= Vector3.new(0, 1, 0)
    end

    return dir
end

-- ══════════════════════════════════════════
--          LÓGICA DE VUELO PRINCIPAL
-- ══════════════════════════════════════════

local function enableFly()
    flying = true
    humanoid.PlatformStand = true

    -- Forzar animación idle/stop del humanoid
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:Stop(0.1)
    end

    bv = Instance.new("BodyVelocity")
    bv.Velocity  = Vector3.zero
    bv.MaxForce  = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent    = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.D         = 200
    bg.P         = 2000
    bg.CFrame    = root.CFrame
    bg.Parent    = root

    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not flying then return end

        local cam      = workspace.CurrentCamera
        local inputDir = getCamDirection()
        local target   = inputDir.Magnitude > 0 and inputDir.Unit * CFG.speed or Vector3.zero

        -- Suavizar velocidad (sensación de masa / inercia)
        velocity = lerpV3(velocity, target, CFG.acceleration)
        bv.Velocity = velocity

        -- ── Rotación superhéroe ──────────────────────────────
        local speed2D = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

        if speed2D > 2 then
            -- Dirección horizontal de movimiento
            local moveDir = Vector3.new(velocity.X, 0, velocity.Z).Unit

            -- CFrame mirando hacia donde vuela, luego inclinado hacia adelante
            local lookCF   = CFrame.lookAt(root.Position, root.Position + moveDir)
            -- Inclinar hacia adelante según velocidad (más rápido = más inclinado)
            local tiltRatio = math.clamp(speed2D / CFG.speed, 0, 1)
            local tilt      = math.rad(CFG.tiltAngle) * tiltRatio
            local tiltedCF  = lookCF * CFrame.Angles(-tilt, 0, 0)

            bg.CFrame = CFrame.new(root.Position) *
                CFrame.fromMatrix(
                    Vector3.zero,
                    tiltedCF.RightVector,
                    tiltedCF.UpVector,
                    -tiltedCF.LookVector
                )
        else
            -- Sin movimiento horizontal → posición vertical heroica
            local upright = CFrame.new(root.Position) * CFrame.Angles(0, bg.CFrame:ToEulerAnglesYXZ() and select(2, bg.CFrame:ToEulerAnglesYXZ()) or 0, 0)
            bg.CFrame = CFrame.new(root.Position) * CFrame.fromEulerAnglesYXZ(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        end
    end)
end

local function disableFly()
    flying = false
    velocity = Vector3.zero
    humanoid.PlatformStand = false
    if bv then bv:Destroy(); bv = nil end
    if bg then bg:Destroy(); bg = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

-- ══════════════════════════════════════════
--          GUI - COMPATIBLE DELTA
-- ══════════════════════════════════════════

local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
local old = guiParent:FindFirstChild("HeroFlyGUI")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name           = "HeroFlyGUI"
sg.ResetOnSpawn   = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() sg.DisplayOrder = 999 end)
sg.Parent = guiParent

-- Marco
local frame = Instance.new("Frame")
frame.Name            = "Main"
frame.Size            = UDim2.new(0, 240, 0, 200)
frame.Position        = UDim2.new(0, 18, 0.38, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BorderSizePixel = 0
frame.Active          = true
frame.Draggable       = true
frame.Parent          = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Color     = Color3.fromRGB(90, 60, 230)
stroke.Thickness = 2

-- Header
local header = Instance.new("Frame")
header.Size            = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(25, 15, 55)
header.BorderSizePixel = 0
header.Parent          = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size              = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text              = "🦸  SUPERHERO FLY"
titleLbl.TextColor3        = Color3.fromRGB(180, 140, 255)
titleLbl.TextSize          = 15
titleLbl.Font              = Enum.Font.GothamBold
titleLbl.Parent            = header

-- Estado
local statusLbl = Instance.new("TextLabel")
statusLbl.Size              = UDim2.new(1, -20, 0, 26)
statusLbl.Position          = UDim2.new(0, 10, 0, 50)
statusLbl.BackgroundTransparency = 1
statusLbl.Text              = "⬤  Estado: APAGADO"
statusLbl.TextXAlignment    = Enum.TextXAlignment.Left
statusLbl.TextColor3        = Color3.fromRGB(255, 70, 70)
statusLbl.TextSize          = 13
statusLbl.Font              = Enum.Font.GothamSemibold
statusLbl.Parent            = frame

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size            = UDim2.new(0, 200, 0, 40)
toggleBtn.Position        = UDim2.new(0.5, -100, 0, 83)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
toggleBtn.Text            = "▶  ACTIVAR VUELO"
toggleBtn.TextColor3      = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize        = 13
toggleBtn.Font            = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent          = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

-- Velocidad label
local speedLbl = Instance.new("TextLabel")
speedLbl.Size              = UDim2.new(1, -20, 0, 24)
speedLbl.Position          = UDim2.new(0, 10, 0, 135)
speedLbl.BackgroundTransparency = 1
speedLbl.Text              = "Velocidad: " .. CFG.speed
speedLbl.TextXAlignment    = Enum.TextXAlignment.Center
speedLbl.TextColor3        = Color3.fromRGB(180, 180, 255)
speedLbl.TextSize          = 13
speedLbl.Font              = Enum.Font.Gotham
speedLbl.Parent            = frame

-- Botón −
local minusBtn = Instance.new("TextButton")
minusBtn.Size            = UDim2.new(0, 70, 0, 34)
minusBtn.Position        = UDim2.new(0, 15, 0, 162)
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
minusBtn.Text            = "−"
minusBtn.TextColor3      = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize        = 22
minusBtn.Font            = Enum.Font.GothamBold
minusBtn.BorderSizePixel = 0
minusBtn.Parent          = frame
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 9)

-- Botón +
local plusBtn = Instance.new("TextButton")
plusBtn.Size            = UDim2.new(0, 70, 0, 34)
plusBtn.Position        = UDim2.new(1, -85, 0, 162)
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
plusBtn.Text            = "+"
plusBtn.TextColor3      = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize        = 22
plusBtn.Font            = Enum.Font.GothamBold
plusBtn.BorderSizePixel = 0
plusBtn.Parent          = frame
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 9)

-- ══════════════════════════════════════════
--             EVENTOS BOTONES
-- ══════════════════════════════════════════

local function setFlyOn()
    enableFly()
    toggleBtn.Text            = "⏹  DESACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
    statusLbl.Text            = "⬤  Estado: VOLANDO"
    statusLbl.TextColor3      = Color3.fromRGB(60, 255, 60)
end

local function setFlyOff()
    disableFly()
    toggleBtn.Text            = "▶  ACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    statusLbl.Text            = "⬤  Estado: APAGADO"
    statusLbl.TextColor3      = Color3.fromRGB(255, 70, 70)
end

toggleBtn.MouseButton1Click:Connect(function()
    if not flying then setFlyOn() else setFlyOff() end
end)

plusBtn.MouseButton1Click:Connect(function()
    CFG.speed = math.clamp(CFG.speed + CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

minusBtn.MouseButton1Click:Connect(function()
    CFG.speed = math.clamp(CFG.speed - CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

-- Respawn
player.CharacterAdded:Connect(function(char)
    character = char
    root      = char:WaitForChild("HumanoidRootPart")
    humanoid  = char:WaitForChild("Humanoid")
    animator  = humanoid:WaitForChild("Animator")
    flying    = false
    velocity  = Vector3.zero
    setFlyOff()
end)

print("[HeroFly] ✓ Script cargado correctamente")
