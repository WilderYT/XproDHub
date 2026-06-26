-- ================================================================
-- KURAMA AUTO-FARM v2.1 — Mobile Safe (Delta Executor)
-- Correcciones: SendTouchEvent, TELEPORT_DISTANCE=50, hrp.Anchored
-- ================================================================

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UserInputSvc  = game:GetService("UserInputService")
local VIM           = game:GetService("VirtualInputManager")
local TweenService  = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- ================================================================
-- CONFIGURACIÓN
-- ================================================================
local BOSS_NAME         = "Kurama_Rig_Updated.002"
local TELEPORT_DISTANCE = 50       -- FIX #2: aumentado de 8 a 50
local CHECK_THRESHOLD   = 120
local BOSS_REFRESH_RATE = 2
local SKILL_DELAY       = 0.06
local LOOP_RATE         = 0.35

local SKILL_BUTTONS = {
    {x = 2003, y = 959},
    {x = 2001, y = 772},
    {x = 1912, y = 588},
    {x = 2116, y = 606},
    {x = 2111, y = 606},
    {x = 2282, y = 697},
}

-- ================================================================
-- COLORES / TEMA
-- ================================================================
local COLORS = {
    bg        = Color3.fromRGB(15, 15, 20),
    panel     = Color3.fromRGB(22, 22, 30),
    card      = Color3.fromRGB(30, 30, 42),
    accent    = Color3.fromRGB(138, 43, 226),
    accentOff = Color3.fromRGB(55, 55, 75),
    textMain  = Color3.fromRGB(240, 240, 255),
    textSub   = Color3.fromRGB(140, 140, 170),
    green     = Color3.fromRGB(80, 220, 120),
    red       = Color3.fromRGB(220, 70, 70),
    yellow    = Color3.fromRGB(255, 210, 60),
}

-- ================================================================
-- ESTADO GLOBAL
-- ================================================================
local state = {
    farmOn      = false,
    autoTpOn    = false,
    skillSpamOn = false,
    statusText  = "IDLE",
}

-- ================================================================
-- UTILIDADES UI
-- ================================================================
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.accent
    s.Thickness = thickness or 1.5
    s.Parent = parent
    return s
end

-- ================================================================
-- HELPER: desanclar personaje de forma segura
-- ================================================================
local function unanchorPlayer()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = false
    end
end

-- ================================================================
-- CREACIÓN DEL SWITCH TOGGLE
-- ================================================================
local function createSwitch(parent, initialState, onChange)
    local isOn = initialState or false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 52, 0, 28)
    container.BackgroundColor3 = isOn and COLORS.accent or COLORS.accentOff
    container.BorderSizePixel = 0
    container.Parent = parent
    corner(container, 14)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = isOn and UDim2.new(0, 27, 0, 3) or UDim2.new(0, 3, 0, 3)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = container
    corner(knob, 11)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = container

    local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        TweenService:Create(container, tweenInfo,
            {BackgroundColor3 = isOn and COLORS.accent or COLORS.accentOff}):Play()
        TweenService:Create(knob, tweenInfo,
            {Position = isOn and UDim2.new(0, 27, 0, 3) or UDim2.new(0, 3, 0, 3)}):Play()
        onChange(isOn)
    end)

    return container, function(val)
        isOn = val
        container.BackgroundColor3 = isOn and COLORS.accent or COLORS.accentOff
        knob.Position = isOn and UDim2.new(0, 27, 0, 3) or UDim2.new(0, 3, 0, 3)
    end
end

-- ================================================================
-- CREACIÓN DE UNA FILA (icono + label + switch)
-- ================================================================
local function createRow(parent, icon, title, subtitle, initState, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, 58)
    row.BackgroundColor3 = COLORS.card
    row.BorderSizePixel = 0
    row.Parent = parent
    corner(row, 10)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 0, 36)
    iconLbl.Position = UDim2.new(0, 10, 0.5, -18)
    iconLbl.BackgroundColor3 = COLORS.accentOff
    iconLbl.BorderSizePixel = 0
    iconLbl.Text = icon
    iconLbl.TextSize = 18
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextColor3 = COLORS.textMain
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center
    iconLbl.Parent = row
    corner(iconLbl, 9)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0, 160, 0, 20)
    titleLbl.Position = UDim2.new(0, 56, 0, 9)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = COLORS.textMain
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = row

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(0, 160, 0, 16)
    subLbl.Position = UDim2.new(0, 56, 0, 30)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = subtitle
    subLbl.TextSize = 11
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextColor3 = COLORS.textSub
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Parent = row

    local switchHolder = Instance.new("Frame")
    switchHolder.Size = UDim2.new(0, 52, 0, 28)
    switchHolder.Position = UDim2.new(1, -62, 0.5, -14)
    switchHolder.BackgroundTransparency = 1
    switchHolder.Parent = row

    local _, setter = createSwitch(switchHolder, initState, onToggle)

    return row, setter
end

-- ================================================================
-- CONSTRUCCIÓN DE LA UI PRINCIPAL
-- ================================================================
local function buildUI()
    local old = playerGui:FindFirstChild("KuramaFarmGUI")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "KuramaFarmGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, 310, 0, 330)
    panel.Position = UDim2.new(0, 20, 0.5, -165)
    panel.BackgroundColor3 = COLORS.panel
    panel.BorderSizePixel = 0
    panel.Parent = gui
    corner(panel, 16)
    stroke(panel, COLORS.accent, 1.5)

    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 44)
    dragBar.BackgroundColor3 = COLORS.bg
    dragBar.BorderSizePixel = 0
    dragBar.Parent = panel
    corner(dragBar, 16)

    local fixBar = Instance.new("Frame")
    fixBar.Size = UDim2.new(1, 0, 0, 16)
    fixBar.Position = UDim2.new(0, 0, 1, -16)
    fixBar.BackgroundColor3 = COLORS.bg
    fixBar.BorderSizePixel = 0
    fixBar.Parent = dragBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -50, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "⚡  Kurama Auto-Farm"
    titleLbl.TextSize = 15
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = COLORS.textMain
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = dragBar

    local verLbl = Instance.new("TextLabel")
    verLbl.Size = UDim2.new(0, 40, 0, 20)
    verLbl.Position = UDim2.new(1, -48, 0.5, -10)
    verLbl.BackgroundTransparency = 1
    verLbl.Text = "v2.1"
    verLbl.TextSize = 11
    verLbl.Font = Enum.Font.Gotham
    verLbl.TextColor3 = COLORS.textSub
    verLbl.TextXAlignment = Enum.TextXAlignment.Right
    verLbl.Parent = dragBar

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 1, -50)
    list.Position = UDim2.new(0, 0, 0, 50)
    list.BackgroundTransparency = 1
    list.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft  = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.PaddingTop   = UDim.new(0, 6)
    padding.Parent = list

    -- ----------------------------------------------------------------
    -- Fila 1: Auto Farm (master) — FIX #3: desancla al apagar
    -- ----------------------------------------------------------------
    createRow(list, "⚔", "Auto Farm", "Activa el farm automático",
        false, function(val)
            state.farmOn = val
            if not val then
                state.statusText = "IDLE"
                unanchorPlayer()   -- FIX #3: desancla al apagar farm
            end
        end)

    -- ----------------------------------------------------------------
    -- Fila 2: Auto Teleport — FIX #3: desancla al apagar
    -- ----------------------------------------------------------------
    createRow(list, "✈", "Auto Teleport", "Se teletransporta al boss",
        false, function(val)
            state.autoTpOn = val
            if not val then
                unanchorPlayer()   -- FIX #3: desancla al apagar teleport
            end
        end)

    -- Fila 3: Skill Spam
    createRow(list, "🌀", "Skill Spam", "Dispara habilidades en loop",
        false, function(val)
            state.skillSpamOn = val
        end)

    -- Separador
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -24, 0, 1)
    sep.BackgroundColor3 = COLORS.accentOff
    sep.BorderSizePixel = 0
    sep.Parent = list

    -- Status bar
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, -24, 0, 34)
    statusFrame.BackgroundColor3 = COLORS.bg
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = list
    corner(statusFrame, 8)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(0, 10, 0.5, -5)
    statusDot.BackgroundColor3 = COLORS.green
    statusDot.BorderSizePixel = 0
    statusDot.Parent = statusFrame
    corner(statusDot, 5)

    local statusTxt = Instance.new("TextLabel")
    statusTxt.Name = "StatusText"
    statusTxt.Size = UDim2.new(1, -30, 1, 0)
    statusTxt.Position = UDim2.new(0, 26, 0, 0)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "Status: IDLE"
    statusTxt.TextSize = 12
    statusTxt.Font = Enum.Font.GothamBold
    statusTxt.TextColor3 = COLORS.textSub
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.Parent = statusFrame

    -- Drag logic
    local dragging, dragStart, startPos = false, nil, nil
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
        end
    end)
    dragBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return statusTxt, statusDot
end

local statusLabel, statusDot = buildUI()

-- ================================================================
-- FIX #1: simulateTouch con SendTouchEvent (mobile-safe real)
-- touchId=1, state 0=Begin, state 2=End
-- ================================================================
local function simulateTouch(x, y)
    VIM:SendTouchEvent(1, 0, x, y)   -- Press
    task.wait(0.05)
    VIM:SendTouchEvent(1, 2, x, y)   -- Release
end

local function spamSkills()
    for _, btn in ipairs(SKILL_BUTTONS) do
        if not state.skillSpamOn then break end
        simulateTouch(btn.x, btn.y)
        task.wait(SKILL_DELAY)
    end
end

-- ================================================================
-- BÚSQUEDA DEL BOSS
-- ================================================================
local bossCache, lastBossCheck = nil, 0
local function findBoss()
    local now = tick()
    if now - lastBossCheck < BOSS_REFRESH_RATE and bossCache then
        return bossCache
    end
    lastBossCheck = now
    bossCache = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == BOSS_NAME then
            if obj:FindFirstChild("RootPart") then
                bossCache = obj
                return obj
            end
        end
    end
    return nil
end

-- ================================================================
-- FIX #2 + #3: teleportToBoss con offset 50 y Anchored = true
-- ================================================================
local function teleportToBoss(bossRoot)
    local char = getCharacter()
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Anchored = true                                          -- FIX #3: ancla al teletransportar
        hrp.CFrame   = CFrame.new(bossRoot.Position
                        + Vector3.new(0, TELEPORT_DISTANCE, 0))     -- FIX #2: offset = 50
    end
end

local function distanceToBoss(bossRoot)
    local char = player.Character
    if not char then return math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    return (hrp.Position - bossRoot.Position).Magnitude
end

-- ================================================================
-- STATUS COLORS
-- ================================================================
local STATUS_COLORS = {
    IDLE        = Color3.fromRGB(140, 140, 170),
    OFF         = Color3.fromRGB(100, 100, 120),
    SCANNING    = Color3.fromRGB(255, 210, 60),
    FARMING     = Color3.fromRGB(80, 220, 120),
    TELEPORT    = Color3.fromRGB(138, 43, 226),
    ["NO BOSS"] = Color3.fromRGB(220, 70, 70),
}

local function updateStatus(text)
    state.statusText = text
    if statusLabel and statusLabel.Parent then
        statusLabel.Text      = "● " .. text
        statusLabel.TextColor3 = STATUS_COLORS[text] or COLORS.textSub
    end
    if statusDot and statusDot.Parent then
        statusDot.BackgroundColor3 = STATUS_COLORS[text] or COLORS.textSub
    end
end

-- ================================================================
-- LOOP PRINCIPAL
-- ================================================================
task.spawn(function()
    while true do
        task.wait(LOOP_RATE)

        if not state.farmOn then
            updateStatus("IDLE")
            continue
        end

        updateStatus("SCANNING")

        local boss = findBoss()
        if not boss then
            updateStatus("NO BOSS")
            continue
        end

        local bossRoot = boss:FindFirstChild("RootPart")
        if not bossRoot then
            updateStatus("NO BOSS")
            continue
        end

        -- Teleport si está activado y estamos lejos
        if state.autoTpOn then
            if distanceToBoss(bossRoot) > CHECK_THRESHOLD then
                updateStatus("TELEPORT")
                teleportToBoss(bossRoot)
                task.wait(0.2)
            end
        end

        -- Skill spam
        if state.skillSpamOn then
            updateStatus("FARMING")
            spamSkills()
        else
            updateStatus("FARMING")
        end
    end
end)

-- ================================================================
-- Seguridad: si el personaje respawnea, desanclar siempre
-- ================================================================
player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        hrp.Anchored = false
    end
    -- Apagar los switches de estado también
    state.farmOn    = false
    state.autoTpOn  = false
    bossCache       = nil
end)

print("[KuramaFarm v2.1] Cargado. Tres fixes aplicados: SendTouchEvent, offset=50, Anchored.")
