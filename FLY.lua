-- ╔═══════════════════════════════════════════╗
-- ║       SUPERHERO FLY - Mobile Ready        ║
-- ║           by: Smith                       ║
-- ╚═══════════════════════════════════════════╝

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local player  = Players.LocalPlayer
repeat task.wait() until player.Character
local character = player.Character
local root      = character:WaitForChild("HumanoidRootPart")
local humanoid  = character:WaitForChild("Humanoid")

-- ══════════════════════════════════════════
--              CONFIGURACIÓN
-- ══════════════════════════════════════════
local CFG = {
    speed        = 60,
    maxSpeed     = 500,
    minSpeed     = 10,
    speedStep    = 10,
    acceleration = 0.14,
    tiltAngle    = 60,
}

-- ══════════════════════════════════════════
--              ESTADO GLOBAL
-- ══════════════════════════════════════════
local flying   = false
local velocity = Vector3.zero
local joystick = Vector2.zero   -- input del thumbstick izquierdo
local bv, bg, flyConn = nil, nil, nil

-- ══════════════════════════════════════════
--        CAPTURA JOYSTICK MÓVIL
-- ══════════════════════════════════════════

-- Capturamos el ThumbstickMoved nativamente
UserInputService.InputChanged:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        joystick = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

-- ══════════════════════════════════════════
--         DIRECCIÓN DE MOVIMIENTO
-- ══════════════════════════════════════════

local function getDirection()
    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    -- ── Joystick móvil ─────────────────────
    if joystick.Magnitude > 0.1 then
        local flat = (cam.CFrame.LookVector * Vector3.new(1,0,1)).Unit
        local right = (cam.CFrame.RightVector * Vector3.new(1,0,1)).Unit
        dir = (flat * joystick.Y + right * joystick.X)
    end

    -- ── Teclado (PC fallback) ───────────────
    local cf = cam.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end

    -- Subir / bajar
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or
       UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) then
        dir += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
       UserInputService:IsKeyDown(Enum.KeyCode.ButtonB) then
        dir -= Vector3.new(0, 1, 0)
    end

    return dir
end

-- ══════════════════════════════════════════
--          VUELO SUPERHÉROE
-- ══════════════════════════════════════════

local function lerpV3(a, b, t)
    return a + (b - a) * t
end

local function enableFly()
    flying = true
    humanoid.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.Velocity  = Vector3.zero
    bv.MaxForce  = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent    = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.D         = 150
    bg.P         = 3000
    bg.CFrame    = root.CFrame
    bg.Parent    = root

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local cam    = workspace.CurrentCamera
        local input  = getDirection()
        local target = input.Magnitude > 0.01
            and input.Unit * CFG.speed
            or  Vector3.zero

        -- Inercia suave
        velocity = lerpV3(velocity, target, CFG.acceleration)
        bv.Velocity = velocity

        -- Velocidad horizontal para calcular inclinación
        local hSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

        if hSpeed > 1.5 then
            -- Dirección horizontal
            local hDir    = Vector3.new(velocity.X, 0, velocity.Z).Unit
            local lookCF  = CFrame.lookAt(root.Position, root.Position + hDir)
            local ratio   = math.clamp(hSpeed / CFG.speed, 0, 1)
            local tilt    = math.rad(CFG.tiltAngle) * ratio

            -- Aplica inclinación hacia adelante (vuelo superman)
            bg.CFrame = lookCF * CFrame.Angles(-tilt, 0, 0)
        else
            -- Hover: erguido mirando hacia la cámara
            local _, yaw, _ = cam.CFrame:ToEulerAnglesYXZ()
            bg.CFrame = CFrame.new(root.Position) * CFrame.fromEulerAnglesYXZ(0, yaw, 0)
        end
    end)
end

local function disableFly()
    flying = false
    velocity = Vector3.zero
    humanoid.PlatformStand = false
    if bv       then bv:Destroy();        bv       = nil end
    if bg       then bg:Destroy();        bg       = nil end
    if flyConn  then flyConn:Disconnect(); flyConn = nil end
end

-- ══════════════════════════════════════════
--      BOTONES MÓVIL: SUBIR / BAJAR
-- ══════════════════════════════════════════
-- Se agregan como botones en pantalla para móvil

local function createMobileBtn(guiParent, text, posX, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 70, 0, 70)
    btn.Position         = UDim2.new(posX, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.Text             = text
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.TextSize         = 26
    btn.Font             = Enum.Font.GothamBold
    btn.BorderSizePixel  = 0
    btn.ZIndex           = 10
    btn.Parent           = guiParent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color     = Color3.fromRGB(90, 60, 230)
    stroke.Thickness = 2

    -- Mantener presionado = vuelo continuo
    local holding = false
    btn.MouseButton1Down:Connect(function() holding = true end)
    btn.MouseButton1Up:Connect(function()   holding = false end)
    btn.TouchStart:Connect(function()  holding = true end)
    btn.TouchEnd:Connect(function()    holding = false end)

    RunService.RenderStepped:Connect(function()
        if holding and flying and bv then
            callback()
        end
    end)

    return btn
end

-- ══════════════════════════════════════════
--               GUI PRINCIPAL
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

-- ─── Marco principal ───────────────────────
local frame = Instance.new("Frame")
frame.Name             = "Main"
frame.Size             = UDim2.new(0, 250, 0, 215)
frame.Position         = UDim2.new(0, 14, 0.30, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 8, 22)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
frame.Parent           = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke", frame)
mainStroke.Color     = Color3.fromRGB(100, 65, 245)
mainStroke.Thickness = 2

-- ─── Header ────────────────────────────────
local header = Instance.new("Frame")
header.Size             = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(22, 12, 55)
header.BorderSizePixel  = 0
header.Parent           = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size                = UDim2.new(1, 0, 0, 28)
titleLbl.Position            = UDim2.new(0, 0, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.Text                = "🦸  SUPERHERO FLY"
titleLbl.TextColor3          = Color3.fromRGB(185, 145, 255)
titleLbl.TextSize             = 15
titleLbl.Font                = Enum.Font.GothamBold
titleLbl.Parent              = header

local creditLbl = Instance.new("TextLabel")
creditLbl.Size                = UDim2.new(1, 0, 0, 16)
creditLbl.Position            = UDim2.new(0, 0, 0, 30)
creditLbl.BackgroundTransparency = 1
creditLbl.Text                = "by: Smith"
creditLbl.TextColor3          = Color3.fromRGB(130, 100, 200)
creditLbl.TextSize            = 11
creditLbl.Font                = Enum.Font.GothamSemibold
creditLbl.Parent              = header

-- ─── Estado ────────────────────────────────
local statusLbl = Instance.new("TextLabel")
statusLbl.Size                = UDim2.new(1, -20, 0, 26)
statusLbl.Position            = UDim2.new(0, 10, 0, 54)
statusLbl.BackgroundTransparency = 1
statusLbl.Text                = "⬤  Estado: APAGADO"
statusLbl.TextXAlignment      = Enum.TextXAlignment.Left
statusLbl.TextColor3          = Color3.fromRGB(255, 70, 70)
statusLbl.TextSize            = 13
statusLbl.Font                = Enum.Font.GothamSemibold
statusLbl.Parent              = frame

-- ─── Toggle ────────────────────────────────
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0, 210, 0, 42)
toggleBtn.Position         = UDim2.new(0.5, -105, 0, 86)
toggleBtn.BackgroundColor3 = Color3.fromRGB(175, 35, 35)
toggleBtn.Text             = "▶  ACTIVAR VUELO"
toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize         = 13
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.BorderSizePixel  = 0
toggleBtn.Parent           = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 11)

-- ─── Velocidad ─────────────────────────────
local speedLbl = Instance.new("TextLabel")
speedLbl.Size                = UDim2.new(1, -20, 0, 24)
speedLbl.Position            = UDim2.new(0, 10, 0, 140)
speedLbl.BackgroundTransparency = 1
speedLbl.Text                = "Velocidad: " .. CFG.speed
speedLbl.TextXAlignment      = Enum.TextXAlignment.Center
speedLbl.TextColor3          = Color3.fromRGB(180, 180, 255)
speedLbl.TextSize            = 13
speedLbl.Font                = Enum.Font.Gotham
speedLbl.Parent              = frame

-- ─── Botones − y + ─────────────────────────
local function makeSpeedBtn(txt, posX)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 75, 0, 36)
    b.Position         = UDim2.new(posX, 0, 0, 168)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 95)
    b.Text             = txt
    b.TextColor3       = Color3.fromRGB(255, 255, 255)
    b.TextSize         = 22
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.Parent           = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    return b
end

local minusBtn = makeSpeedBtn("−", 0.08)
local plusBtn  = makeSpeedBtn("+", 0.62)

-- ─── Botones subir/bajar móvil ──────────────
-- Aparecen a la derecha de la pantalla cuando vuela
local upBtn   = createMobileBtn(sg, "▲", 0.88, 0.62, function()
    if bv then bv.Velocity = bv.Velocity + Vector3.new(0, 8, 0) end
end)
local downBtn = createMobileBtn(sg, "▼", 0.88, 0.74, function()
    if bv then bv.Velocity = bv.Velocity - Vector3.new(0, 8, 0) end
end)
upBtn.Visible   = false
downBtn.Visible = false

-- ══════════════════════════════════════════
--              EVENTOS
-- ══════════════════════════════════════════

local function setOn()
    enableFly()
    toggleBtn.Text             = "⏹  DESACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 155, 35)
    statusLbl.Text             = "⬤  Estado: VOLANDO"
    statusLbl.TextColor3       = Color3.fromRGB(60, 255, 60)
    upBtn.Visible              = true
    downBtn.Visible            = true
end

local function setOff()
    disableFly()
    toggleBtn.Text             = "▶  ACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(175, 35, 35)
    statusLbl.Text             = "⬤  Estado: APAGADO"
    statusLbl.TextColor3       = Color3.fromRGB(255, 70, 70)
    upBtn.Visible              = false
    downBtn.Visible            = false
end

toggleBtn.MouseButton1Click:Connect(function()
    if not flying then setOn() else setOff() end
end)

plusBtn.MouseButton1Click:Connect(function()
    CFG.speed = math.clamp(CFG.speed + CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

minusBtn.MouseButton1Click:Connect(function()
    CFG.speed = math.clamp(CFG.speed - CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

player.CharacterAdded:Connect(function(char)
    character = char
    root      = char:WaitForChild("HumanoidRootPart")
    humanoid  = char:WaitForChild("Humanoid")
    flying    = false
    velocity  = Vector3.zero
    joystick  = Vector2.zero
    setOff()
end)

print("[HeroFly by Smith] ✓ Listo")
