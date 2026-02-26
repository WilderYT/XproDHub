-- ╔═══════════════════════════════════════════╗
-- ║         Smith Fly v10 - Final Fix         ║
-- ╚═══════════════════════════════════════════╝

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
repeat task.wait() until player.Character
local character = player.Character
local root      = character:WaitForChild("HumanoidRootPart")
local humanoid  = character:WaitForChild("Humanoid")

local CFG = {
    speed        = 60,
    maxSpeed     = 500,
    minSpeed     = 10,
    speedStep    = 10,
    accel        = 0.1,   -- suavidad (0=lento 1=instantáneo)
    tiltAngle    = 35,    -- inclinación al volar adelante
}

local flying   = false
local velocity = Vector3.zero
local bv, bg, flyConn = nil, nil, nil

local function lerp(a, b, t) return a + (b - a) * t end
local function lerpV3(a, b, t)
    return Vector3.new(lerp(a.X,b.X,t), lerp(a.Y,b.Y,t), lerp(a.Z,b.Z,t))
end

local function enableFly()
    flying = true
    humanoid.PlatformStand = true

    bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent   = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.D = 300
    bg.P = 6000
    bg.CFrame = root.CFrame
    bg.Parent = root

    flyConn = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local cam   = workspace.CurrentCamera
        local camCF = cam.CFrame

        -- ── Dirección horizontal desde joystick / WASD ──────────
        -- MoveDirection ya viene orientado según la cámara en Roblox
        -- Solo usamos X y Z (horizontal), ignoramos Y
        local md = humanoid.MoveDirection  -- Vector3 normalizado del joystick
        local hDir = Vector3.new(md.X, 0, md.Z)

        -- ── Dirección vertical desde ángulo de cámara ────────────
        -- pitch de la cámara: si miras arriba → sube, abajo → baja
        local camPitch = camCF.LookVector.Y  -- va de -1 (abajo) a 1 (arriba)
        -- Solo activa vertical si hay input horizontal O si pitch es significativo
        local vertSpeed = 0
        if math.abs(camPitch) > 0.15 then
            vertSpeed = camPitch * CFG.speed
        end

        -- ── Construir velocidad objetivo ─────────────────────────
        local targetH = hDir.Magnitude > 0.05
            and hDir.Unit * CFG.speed
            or  Vector3.zero

        local target = Vector3.new(targetH.X, vertSpeed, targetH.Z)

        -- Suavizado con inercia
        velocity = lerpV3(velocity, target, CFG.accel)
        bv.Velocity = velocity

        -- ── Rotación del cuerpo ──────────────────────────────────
        local hVel = Vector3.new(velocity.X, 0, velocity.Z)
        local hSpd = hVel.Magnitude

        if hSpd > 1 then
            -- Apunta hacia donde va horizontalmente
            local lookTarget = root.Position + hVel.Unit
            -- CFrame base mirando la dirección horizontal, UP siempre arriba
            local baseCF = CFrame.lookAt(root.Position, lookTarget, Vector3.new(0,1,0))
            -- Inclinación proporcional a velocidad (nunca boca abajo)
            local ratio = math.clamp(hSpd / CFG.speed, 0, 1)
            local tilt  = math.rad(CFG.tiltAngle) * ratio
            bg.CFrame = baseCF * CFrame.Angles(-tilt, 0, 0)
        else
            -- Hover: erguido mirando hacia donde apunta la cámara (yaw)
            local _, yaw, _ = camCF:ToEulerAnglesYXZ()
            bg.CFrame = CFrame.new(root.Position)
                      * CFrame.fromEulerAnglesYXZ(0, yaw, 0)
        end
    end)
end

local function disableFly()
    flying = false; velocity = Vector3.zero
    humanoid.PlatformStand = false
    if bv      then bv:Destroy();         bv      = nil end
    if bg      then bg:Destroy();         bg      = nil end
    if flyConn then flyConn:Disconnect(); flyConn = nil end
end

-- ══════════════════════════════════════════
--                   GUI
-- ══════════════════════════════════════════
local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function()
    local old = guiParent:FindFirstChild("SmithFlyGUI")
    if old then old:Destroy() end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "SmithFlyGUI"
sg.ResetOnSpawn = false
pcall(function() sg.DisplayOrder = 999 end)
sg.Parent = guiParent

local function addCorner(p, r)
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 12)
end
local function addStroke(p, col)
    local s = Instance.new("UIStroke", p)
    s.Color = col; s.Thickness = 2
end

local TAP_THRESHOLD = 12

local function makeTapHandler(btn, cb)
    local pp = nil
    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            pp = Vector2.new(inp.Position.X, inp.Position.Y)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.Touch
        or  inp.UserInputType == Enum.UserInputType.MouseButton1) and pp then
            local d = (Vector2.new(inp.Position.X, inp.Position.Y) - pp).Magnitude
            pp = nil
            if d < TAP_THRESHOLD then cb() end
        end
    end)
end

-- ── Frame PRIMERO ───────────────────────────
local frame = Instance.new("Frame")
frame.Size             = UDim2.new(0, 250, 0, 210)
frame.Position         = UDim2.new(0, 14, 0.22, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 8, 22)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
frame.Visible          = false
frame.Parent           = sg
addCorner(frame, 16)
addStroke(frame, Color3.fromRGB(100, 65, 245))

local header = Instance.new("Frame")
header.Size             = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(22, 12, 55)
header.BorderSizePixel  = 0
header.Parent           = frame
addCorner(header, 16)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size               = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "🛸  Smith Fly"
titleLbl.TextColor3         = Color3.fromRGB(185, 145, 255)
titleLbl.TextSize           = 16
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.Parent             = header

local statusLbl = Instance.new("TextLabel")
statusLbl.Size              = UDim2.new(1, -20, 0, 26)
statusLbl.Position          = UDim2.new(0, 10, 0, 52)
statusLbl.BackgroundTransparency = 1
statusLbl.Text              = "⬤  Estado: APAGADO"
statusLbl.TextXAlignment    = Enum.TextXAlignment.Left
statusLbl.TextColor3        = Color3.fromRGB(255, 70, 70)
statusLbl.TextSize          = 13
statusLbl.Font              = Enum.Font.GothamSemibold
statusLbl.Parent            = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0, 210, 0, 44)
toggleBtn.Position         = UDim2.new(0.5, -105, 0, 84)
toggleBtn.BackgroundColor3 = Color3.fromRGB(175, 35, 35)
toggleBtn.Text             = "▶  ACTIVAR VUELO"
toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize         = 13
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.BorderSizePixel  = 0
toggleBtn.Parent           = frame
addCorner(toggleBtn, 11)

local speedLbl = Instance.new("TextLabel")
speedLbl.Size               = UDim2.new(1, -20, 0, 24)
speedLbl.Position           = UDim2.new(0, 10, 0, 140)
speedLbl.BackgroundTransparency = 1
speedLbl.Text               = "Velocidad: " .. CFG.speed
speedLbl.TextXAlignment     = Enum.TextXAlignment.Center
speedLbl.TextColor3         = Color3.fromRGB(180, 180, 255)
speedLbl.TextSize           = 13
speedLbl.Font               = Enum.Font.Gotham
speedLbl.Parent             = frame

local function makeSpeedBtn(txt, posX)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(0, 78, 0, 38)
    b.Position         = UDim2.new(posX, 0, 0, 168)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 95)
    b.Text             = txt
    b.TextColor3       = Color3.fromRGB(255, 255, 255)
    b.TextSize         = 22
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.Parent           = frame
    addCorner(b, 10)
    return b
end
local minusBtn = makeSpeedBtn("−", 0.07)
local plusBtn  = makeSpeedBtn("+", 0.61)

-- ── FAB DESPUÉS del frame ───────────────────
local fabBtn = Instance.new("TextButton")
fabBtn.Size             = UDim2.new(0, 58, 0, 58)
fabBtn.Position         = UDim2.new(0, 16, 0.80, 0)
fabBtn.BackgroundColor3 = Color3.fromRGB(22, 12, 55)
fabBtn.Text             = "🛸"
fabBtn.TextSize         = 26
fabBtn.Font             = Enum.Font.GothamBold
fabBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
fabBtn.BorderSizePixel  = 0
fabBtn.Active           = true
fabBtn.Draggable        = true
fabBtn.ZIndex           = 20
fabBtn.Parent           = sg
addCorner(fabBtn, 29)
addStroke(fabBtn, Color3.fromRGB(100, 65, 245))

-- ══════════════════════════════════════════
--              EVENTOS
-- ══════════════════════════════════════════
makeTapHandler(fabBtn, function()
    frame.Visible = not frame.Visible
    fabBtn.Text   = frame.Visible and "✕" or "🛸"
end)

local function setOn()
    enableFly()
    toggleBtn.Text             = "⏹  DESACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 155, 35)
    statusLbl.Text             = "⬤  Estado: VOLANDO"
    statusLbl.TextColor3       = Color3.fromRGB(60, 255, 60)
end
local function setOff()
    disableFly()
    toggleBtn.Text             = "▶  ACTIVAR VUELO"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(175, 35, 35)
    statusLbl.Text             = "⬤  Estado: APAGADO"
    statusLbl.TextColor3       = Color3.fromRGB(255, 70, 70)
end

makeTapHandler(toggleBtn, function()
    if not flying then setOn() else setOff() end
end)
makeTapHandler(plusBtn, function()
    CFG.speed = math.clamp(CFG.speed + CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)
makeTapHandler(minusBtn, function()
    CFG.speed = math.clamp(CFG.speed - CFG.speedStep, CFG.minSpeed, CFG.maxSpeed)
    speedLbl.Text = "Velocidad: " .. CFG.speed
end)

player.CharacterAdded:Connect(function(char)
    character = char
    root     = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    flying = false; velocity = Vector3.zero
    setOff()
end)

print("[Smith Fly] v10 ✓")
