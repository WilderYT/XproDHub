-- ╔═══════════════════════════════════════════╗
-- ║      SUPERHERO FLY v4 - Mobile Fixed      ║
-- ║              by: Smith                    ║
-- ╚═══════════════════════════════════════════╝

local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UserInputService     = game:GetService("UserInputService")

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
local flying    = false
local velocity  = Vector3.zero
local joystick  = Vector2.zero
local goUp      = false
local goDown    = false
local bv, bg, flyConn = nil, nil, nil

-- ══════════════════════════════════════════
--      CAPTURA JOYSTICK MÓVIL
-- ══════════════════════════════════════════
UserInputService.InputChanged:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        joystick = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        joystick = Vector2.zero
    end
end)

-- ══════════════════════════════════════════
--         DIRECCIÓN DE MOVIMIENTO
-- ══════════════════════════════════════════
local function getDirection()
    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    -- Joystick móvil
    if joystick.Magnitude > 0.1 then
        local flat  = Vector3.new(cam.CFrame.LookVector.X,  0, cam.CFrame.LookVector.Z)
        local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
        if flat.Magnitude  > 0 then flat  = flat.Unit  end
        if right.Magnitude > 0 then right = right.Unit end
        dir = flat * joystick.Y + right * joystick.X
    end

    -- Teclado PC (fallback)
    local cf = cam.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end

    -- Subir / bajar (teclado)
    if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

    -- Botones táctiles subir/bajar
    if goUp   then dir += Vector3.new(0, 1, 0) end
    if goDown then dir -= Vector3.new(0, 1, 0) end

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

        local input  = getDirection()
        local target = input.Magnitude > 0.01
            and input.Unit * CFG.speed
            or  Vector3.zero

        velocity    = lerpV3(velocity, target, CFG.acceleration)
        bv.Velocity = velocity

        local hSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

        if hSpeed > 1.5 then
            local hDir   = Vector3.new(velocity.X, 0, velocity.Z).Unit
            local lookCF = CFrame.lookAt(root.Position, root.Position + hDir)
            local ratio  = math.clamp(hSpeed / CFG.speed, 0, 1)
            local tilt   = math.rad(CFG.tiltAngle) * ratio
            bg.CFrame    = lookCF * CFrame.Angles(-tilt, 0, 0)
        else
            local _, yaw, _ = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
            bg.CFrame = CFrame.new(root.Position) * CFrame.fromEulerAnglesYXZ(0, yaw, 0)
        end
    end)
end

local function disableFly()
    flying  = false
    goUp    = false
    goDown  = false
    velocity = Vector3.zero
    humanoid.PlatformStand = false
    if bv      then bv:Destroy();         bv      = nil end
    if bg      then bg:Destroy();         bg      = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
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

-- Marco principal
local frame = Instance.new("Frame")
frame.Name             = "Main"
frame.Size             = UDim2.new(0, 250, 0, 215)
frame.Position         = UDim2.new(0, 14, 0.28, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 8, 22)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
frame.Parent           = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
local ms = Instance.new("UIStroke", frame)
ms.Color = Color3.fromRGB(100, 65, 245); ms.Thickness = 2

-- Header
local header = Instance.new("Frame")
header.Size             = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(22, 12, 55)
header.BorderSizePixel  = 0
header.Parent           = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size                = UDim2.new(1, 0, 0, 30)
titleLbl.Position            = UDim2.new(0, 0, 0, 3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text                = "🦸  SUPERHERO FLY"
titleLbl.TextColor3          = Color3.fromRGB(185, 145, 255)
titleLbl.TextSize             = 15
titleLbl.Font                = Enum.Font.GothamBold
titleLbl.Parent              = header

local creditLbl = Instance.new("TextLabel")
creditLbl.Size                = UDim2.new(1, 0, 0, 18)
creditLbl.Position            = UDim2.new(0, 0, 0, 32)
creditLbl.BackgroundTransparency = 1
creditLbl.Text                = "by: Smith"
creditLbl.TextColor3          = Color3.fromRGB(130, 100, 210)
creditLbl.TextSize            = 11
creditLbl.Font                = Enum.Font.GothamSemibold
creditLbl.Parent              = header

-- Estado
local statusLbl = Instance.new("TextLabel")
statusLbl.Size                = UDim2.new(1, -20, 0, 26)
statusLbl.Position            = UDim2.new(0, 10, 0, 56)
statusLbl.BackgroundTransparency = 1
statusLbl.Text                = "⬤  Estado: APAGADO"
statusLbl.TextXAlignment      = Enum.TextXAlignment.Left
statusLbl.TextColor3          = Color3.fromRGB(255, 70, 70)
statusLbl.TextSize            = 13
statusLbl.Font                = Enum.Font.GothamSemibold
statusLbl.Parent              = frame

-- Toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0, 210, 0, 44)
toggleBtn.Position         = UDim2.new(0.5, -105, 0, 88)
toggleBtn.BackgroundColor3 = Color3.fromRGB(175, 35, 35)
toggleBtn.Text             = "▶  ACTIVAR VUELO"
toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize         = 13
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.BorderSizePixel  = 0
toggleBtn.Parent           = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 11)

-- Velocidad label
local speedLbl = Instance.new("TextLabel")
speedLbl.Size                = UDim2.new(1, -20, 0, 24)
speedLbl.Position            = UDim2.new(0, 10, 0, 144)
speedLbl.BackgroundTransparency = 1
speedLbl.Text                = "Velocidad: " .. CFG.speed
speedLbl.TextXAlignment      = Enum.TextXAlignment.Center
speedLbl.TextColor3          = Color3.fromRGB(180, 180, 255)
speedLbl.TextSize            = 13
speedLbl.Font                = Enum.Font.Gotham
speedLbl.Parent              = frame

-- Helper para botones − y +
local function makeBtn(txt, posX)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 78, 0, 38)
    b.Position         = UDim2.new(posX, 0, 0, 172)
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
local minusBtn = makeBtn("−", 0.07)
local plusBtn  = makeBtn("+", 0.61)

-- ── Botones SUBIR / BAJAR táctiles ──────────
-- Usan InputBegan/InputEnded sobre el Frame para evitar el error TouchStart
local function makeFlyBtn(sg, labelTxt, posY, onHold)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 72, 0, 72)
    btn.Position         = UDim2.new(1, -90, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 50)
    btn.Text             = labelTxt
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.TextSize         = 28
    btn.Font             = Enum.Font.GothamBold
    btn.BorderSizePixel  = 0
    btn.Visible          = false
    btn.ZIndex           = 10
    btn.Parent           = sg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", btn)
    st.Color = Color3.fromRGB(100, 65, 245); st.Thickness = 2

    -- ✅ Activated funciona tanto en touch como en mouse
    -- Para mantener presionado usamos InputBegan/Ended del botón con UserInputService
    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or
           inp.UserInputType == Enum.UserInputType.MouseButton1 then
            onHold(true)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch or
           inp.UserInputType == Enum.UserInputType.MouseButton1 then
            onHold(false)
        end
    end)

    return btn
end

local upBtn   = makeFlyBtn(sg, "▲", 0.55, function(state) goUp   = state end)
local downBtn = makeFlyBtn(sg, "▼", 0.68, function(state) goDown = state end)

-- ══════════════════════════════════════════
--              EVENTOS BOTONES
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

-- ✅ Activated = funciona en touch Y mouse, sin errores
toggleBtn.Activated:Connect(function()
    if not flying then setOn() else setOff() end
end)

plusBtn.Activated:Connect(function()
    CFG.speed = math.clamp(CFG.speed + CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

minusBtn.Activated:Connect(function()
    CFG.speed = math.clamp(CFG.speed - CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

-- Reset al respawnear
player.CharacterAdded:Connect(function(char)
    character = char
    root      = char:WaitForChild("HumanoidRootPart")
    humanoid  = char:WaitForChild("Humanoid")
    flying    = false
    velocity  = Vector3.zero
    joystick  = Vector2.zero
    goUp      = false
    goDown    = false
    setOff()
end)

print("[HeroFly by Smith] ✓ v4 cargado sin errores")
