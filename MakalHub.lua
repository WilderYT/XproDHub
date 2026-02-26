-- ///////////////////////////////////////////
-- //   SMITH BLADE BALL - AUTO PARRY v4   //
-- //   Detección dinámica de bola         //
-- //   Remote: kebaind (confirmado)       //
-- ///////////////////////////////////////////

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ============================================
-- REMOTE (confirmado por SmithSpy)
-- ============================================
local ParryRemote = nil

local function FindKebaind()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local r = remotes:FindFirstChild("kebaind")
        if r then return r end
    end
    -- fallback búsqueda total
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name == "kebaind" then
            return v
        end
    end
    return nil
end

task.spawn(function()
    while not ParryRemote do
        ParryRemote = FindKebaind()
        if not ParryRemote then task.wait(1) end
    end
    print("[SmithHub] Remote encontrado: " .. ParryRemote:GetFullName())
end)

-- ============================================
-- DETECCIÓN DINÁMICA DE BOLA
-- Blade Ball instancia la bola en runtime,
-- monitoreamos DescendantAdded en Workspace
-- ============================================
local TrackedBalls = {}  -- tabla de bolas activas

local function IsBall(obj)
    if not obj:IsA("BasePart") then return false end
    -- La bola de Blade Ball es esférica, pequeña, y tiene velocidad alta
    -- Detectamos por forma, tamaño y que tenga NetworkOwnership
    local name = obj.Name:lower()
    -- Nombres conocidos
    if name:find("ball") or name:find("blade") or name:find("proj") then
        return true
    end
    -- Detección por forma: SphereHandleAdornment o Sphere
    if obj.Shape == Enum.PartType.Ball then
        return true
    end
    -- Detección por tamaño pequeño (la bola mide ~2x2x2 o menos)
    local size = obj.Size
    if size.X <= 4 and size.Y <= 4 and size.Z <= 4 then
        -- y que sea esférica o casi
        if math.abs(size.X - size.Y) < 0.5 and math.abs(size.Y - size.Z) < 0.5 then
            -- y que tenga velocidad (está en movimiento)
            if obj.AssemblyLinearVelocity.Magnitude > 10 then
                return true
            end
        end
    end
    return false
end

-- Escanear bolas ya existentes
local function ScanWorkspace()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if IsBall(obj) then
            TrackedBalls[obj] = true
            print("[SmithHub] Bola detectada (scan): " .. obj.Name .. " @ " .. obj:GetFullName())
        end
    end
end

-- Escuchar nuevas bolas que se instancien
Workspace.DescendantAdded:Connect(function(obj)
    task.wait()  -- esperar un frame para que tenga velocidad
    if IsBall(obj) then
        TrackedBalls[obj] = true
        print("[SmithHub] Bola detectada (nueva): " .. obj.Name .. " @ " .. obj:GetFullName())
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if TrackedBalls[obj] then
        TrackedBalls[obj] = nil
    end
end)

ScanWorkspace()

-- ============================================
-- CONFIGURACIÓN
-- ============================================
local Settings = {
    AutoParry     = true,
    Notifications = true,
    ParryRange    = 40,    -- studs — rango amplio para no perderse la bola
    MinApproach   = -5,    -- permite parry incluso si se aleja un poco (esquivar rebotes)
}

local lastParry   = 0
local COOLDOWN    = 0.3

-- ============================================
-- LÓGICA AUTO PARRY
-- ============================================
local statusLabel

local function TryAutoParry()
    if not ParryRemote then return end
    local now = tick()
    if now - lastParry < COOLDOWN then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end

    for ball, _ in pairs(TrackedBalls) do
        if ball and ball.Parent then
            local vel      = ball.AssemblyLinearVelocity
            local dist     = (ball.Position - hrp.Position).Magnitude
            local toPlayer = (hrp.Position - ball.Position).Unit
            local approach = vel:Dot(toPlayer)  -- >0 = se acerca, <0 = se aleja

            -- Predecir posición futura
            local futurePos  = ball.Position + vel * 0.25
            local futureDist = (futurePos - hrp.Position).Magnitude

            local shouldParry = dist <= Settings.ParryRange
                and (approach > Settings.MinApproach or futureDist < dist * 0.85)

            if shouldParry then
                ParryRemote:FireServer()
                lastParry = now

                if Settings.Notifications and statusLabel then
                    statusLabel.Text = "⚡ PARRY! " .. math.floor(dist) .. "st"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
                    task.delay(0.6, function()
                        if Settings.AutoParry then
                            statusLabel.Text = "● AUTO PARRY ACTIVO"
                            statusLabel.TextColor3 = Color3.fromRGB(130, 255, 130)
                        end
                    end)
                end
                break
            end
        else
            -- Limpiar referencias muertas
            TrackedBalls[ball] = nil
        end
    end
end

-- ============================================
-- UI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SmithBladeBallV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
elseif gethui then
    ScreenGui.Parent = gethui()
else
    pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 275, 0, 255)
Main.Position = UDim2.new(0.5, -137, 0.04, 0)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", Main)
ms.Color = Color3.fromRGB(140, 60, 255)
ms.Thickness = 2

-- TopBar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 8, 45)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)
local tf = Instance.new("Frame", TopBar)
tf.Size = UDim2.new(1, 0, 0.5, 0)
tf.Position = UDim2.new(0, 0, 0.5, 0)
tf.BackgroundColor3 = Color3.fromRGB(22, 8, 45)
tf.BorderSizePixel = 0

local TitleLbl = Instance.new("TextLabel", TopBar)
TitleLbl.Size = UDim2.new(1, -42, 1, 0)
TitleLbl.Position = UDim2.new(0, 12, 0, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "⚔  SMITH BLADE BALL"
TitleLbl.TextColor3 = Color3.fromRGB(210, 170, 255)
TitleLbl.TextSize = 14
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -36, 0.5, -14)
MinBtn.BackgroundColor3 = Color3.fromRGB(90, 30, 170)
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 7)

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, 0, 1, -42)
Content.Position = UDim2.new(0, 0, 0, 42)
Content.BackgroundTransparency = 1

local Sep = Instance.new("Frame", Content)
Sep.Size = UDim2.new(0.88, 0, 0, 1)
Sep.Position = UDim2.new(0.06, 0, 0, 6)
Sep.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
Sep.BorderSizePixel = 0

-- Status principal
local StatusLbl = Instance.new("TextLabel", Content)
StatusLbl.Size = UDim2.new(1, -18, 0, 24)
StatusLbl.Position = UDim2.new(0, 10, 0, 12)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "● AUTO PARRY ACTIVO"
StatusLbl.TextColor3 = Color3.fromRGB(130, 255, 130)
StatusLbl.TextSize = 12
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLabel = StatusLbl

-- Remote status
local RemoteLbl = Instance.new("TextLabel", Content)
RemoteLbl.Size = UDim2.new(1, -18, 0, 16)
RemoteLbl.Position = UDim2.new(0, 10, 0, 34)
RemoteLbl.BackgroundTransparency = 1
RemoteLbl.Text = "🔍 Buscando remote kebaind..."
RemoteLbl.TextColor3 = Color3.fromRGB(200, 160, 100)
RemoteLbl.TextSize = 10
RemoteLbl.Font = Enum.Font.Gotham
RemoteLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Ball status
local BallLbl = Instance.new("TextLabel", Content)
BallLbl.Size = UDim2.new(1, -18, 0, 16)
BallLbl.Position = UDim2.new(0, 10, 0, 48)
BallLbl.BackgroundTransparency = 1
BallLbl.Text = "⚽ Bolas detectadas: 0"
BallLbl.TextColor3 = Color3.fromRGB(180, 180, 255)
BallLbl.TextSize = 10
BallLbl.Font = Enum.Font.Gotham
BallLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Actualizar remote label cuando se encuentre
task.spawn(function()
    while not ParryRemote do task.wait(0.5) end
    RemoteLbl.Text = "✓ Remote: kebaind activo"
    RemoteLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
end)

-- ====== TOGGLE ======
local function CreateToggle(yPos, label, key, default)
    local Row = Instance.new("Frame", Content)
    Row.Size = UDim2.new(1, -18, 0, 38)
    Row.Position = UDim2.new(0, 9, 0, yPos)
    Row.BackgroundColor3 = Color3.fromRGB(16, 8, 30)
    Row.BorderSizePixel = 0
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 9)
    local rs = Instance.new("UIStroke", Row)
    rs.Color = Color3.fromRGB(70, 25, 130); rs.Thickness = 1

    local Lbl = Instance.new("TextLabel", Row)
    Lbl.Size = UDim2.new(1, -60, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = label
    Lbl.TextColor3 = Color3.fromRGB(220, 200, 255)
    Lbl.TextSize = 13
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local BG = Instance.new("Frame", Row)
    BG.Size = UDim2.new(0, 46, 0, 24)
    BG.Position = UDim2.new(1, -56, 0.5, -12)
    BG.BackgroundColor3 = default and Color3.fromRGB(130, 55, 255) or Color3.fromRGB(45, 45, 55)
    BG.BorderSizePixel = 0
    Instance.new("UICorner", BG).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", BG)
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton", Row)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    Btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        local on = Settings[key]
        TweenService:Create(BG, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Color3.fromRGB(130, 55, 255) or Color3.fromRGB(45, 45, 55)
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        if key == "AutoParry" then
            StatusLbl.Text = on and "● AUTO PARRY ACTIVO" or "● AUTO PARRY INACTIVO"
            StatusLbl.TextColor3 = on and Color3.fromRGB(130, 255, 130) or Color3.fromRGB(255, 90, 90)
        end
    end)
end

CreateToggle(72,  "Auto Parry",     "AutoParry",     true)
CreateToggle(118, "Notificaciones", "Notifications", true)

-- Rango
local RangeRow = Instance.new("Frame", Content)
RangeRow.Size = UDim2.new(1, -18, 0, 38)
RangeRow.Position = UDim2.new(0, 9, 0, 164)
RangeRow.BackgroundColor3 = Color3.fromRGB(16, 8, 30)
RangeRow.BorderSizePixel = 0
Instance.new("UICorner", RangeRow).CornerRadius = UDim.new(0, 9)
local rrs = Instance.new("UIStroke", RangeRow); rrs.Color = Color3.fromRGB(70,25,130); rrs.Thickness=1
local RangeLbl = Instance.new("TextLabel", RangeRow)
RangeLbl.Size = UDim2.new(1, -12, 1, 0)
RangeLbl.Position = UDim2.new(0, 12, 0, 0)
RangeLbl.BackgroundTransparency = 1
RangeLbl.Text = "Rango: " .. Settings.ParryRange .. " studs"
RangeLbl.TextColor3 = Color3.fromRGB(170, 140, 255)
RangeLbl.TextSize = 11
RangeLbl.Font = Enum.Font.Gotham
RangeLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Footer
local Footer = Instance.new("TextLabel", Content)
Footer.Size = UDim2.new(1, 0, 0, 18)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Text = "Smith Hub v4.0  •  Dynamic Ball Tracker"
Footer.TextColor3 = Color3.fromRGB(90, 60, 140)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham

-- ====== DRAG ======
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end
end)
UserInputService.InputChanged:Connect(function(i)
    if i == dragInput and dragging then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                   startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ====== MINIMIZAR ======
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    TweenService:Create(Main, TweenInfo.new(0.25), {
        Size = minimized and UDim2.new(0, 275, 0, 42) or UDim2.new(0, 275, 0, 255)
    }):Play()
    MinBtn.Text = minimized and "+" or "–"
end)

-- ====== LOOP PRINCIPAL ======
local frame = 0
RunService.Heartbeat:Connect(function()
    frame = frame + 1

    -- Actualizar contador de bolas cada 10 frames
    if frame % 10 == 0 then
        local count = 0
        for _ in pairs(TrackedBalls) do count = count + 1 end
        BallLbl.Text = "⚽ Bolas detectadas: " .. count

        -- Re-escanear workspace por si hay bolas nuevas no detectadas
        ScanWorkspace()
    end

    if Settings.AutoParry then
        TryAutoParry()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    ScanWorkspace()
end)

print("[SmithHub v4] Cargado. Monitoreando workspace para bolas...")
