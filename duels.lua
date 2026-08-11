-- ============================================
-- SCRIPT INTEGRADO: Silent Aim Real v4.4 (Anti-Disparos Fantasmas / Tool.Activated Puro)
-- ============================================
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- CONFIGURACIÓN INICIAL
-- ============================================
local CONFIG = {
    TargetMode = "closest",  -- "closest" | "team" | "all"
    AimPart = "Head",
    FOV = 180,
    CheckDistance = 300,
    DamageAmount = 100,      
    WallCheck = true,        -- Evita disparar a través de paredes y bordes
    
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
}

local isMobile = userInputService.TouchEnabled and not userInputService.MouseEnabled

-- ============================================
-- 1) TARGETING DINÁMICO Y RAYCAST ESTRICTO
-- ============================================
local function getEnemies()
    local enemies = {}
    local myTeam = player.Team
    
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local humanoid = plr.Character.Humanoid
            if humanoid.Health > 0 then
                if CONFIG.TargetMode == "team" then
                    if myTeam and plr.Team and plr.Team ~= myTeam then
                        table.insert(enemies, plr)
                    end
                else
                    table.insert(enemies, plr)
                end
            end
        end
    end
    return enemies
end

local function isVisible(targetPart)
    if not CONFIG.WallCheck then return true end
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("Head") or not myChar:FindFirstChild("HumanoidRootPart") then return false end
    
    local tool = myChar:FindFirstChildOfClass("Tool")
    local originHead = myChar.Head.Position
    local originRoot = myChar.HumanoidRootPart.Position
    local originTool = (tool and tool:FindFirstChild("Handle")) and tool.Handle.Position or originRoot
    
    local targetPos = targetPart.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {myChar, camera}
    raycastParams.IgnoreWater = true
    
    local resultHead = workspace:Raycast(originHead, targetPos - originHead, raycastParams)
    local resultTool = workspace:Raycast(originTool, targetPos - originTool, raycastParams)
    
    local function checkHit(result)
        if not result then return true end
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel == targetPart.Parent then
            return true
        end
        return false
    end
    
    if checkHit(resultHead) and checkHit(resultTool) then
        return true
    end
    
    return false
end

local function getClosestEnemyWithinFOV()
    local enemies = getEnemies()
    if #enemies == 0 then return nil end
    
    local cameraPos = camera.CFrame.Position
    local closest = nil
    local closestDist = math.huge
    
    for _, plr in ipairs(enemies) do
        local part = plr.Character:FindFirstChild(CONFIG.AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local dist = (part.Position - cameraPos).Magnitude
            if dist <= CONFIG.CheckDistance then
                local toTarget = (part.Position - cameraPos).Unit
                local angleDeg = math.deg(math.acos(math.clamp(camera.CFrame.LookVector:Dot(toTarget), -1, 1)))
                if angleDeg <= CONFIG.FOV then
                    if isVisible(part) then
                        if dist < closestDist then
                            closestDist = dist
                            closest = plr
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================
-- 2) SILENT AIM INTELIGENTE (ENGANCHADO A TOOL.ACTIVATED)
-- ============================================
local isActive = false
local lastFired = 0
local COOLDOWN_TIME = 0.35 

local function trySilentShoot()
    if not isActive then return end
    
    local myChar = player.Character
    if not myChar then return end
    
    local tool = myChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    if tick() - lastFired < COOLDOWN_TIME then return end
    
    local target = getClosestEnemyWithinFOV()
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(CONFIG.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = target.Character:FindFirstChild("Humanoid")
    if not targetPart or not targetHumanoid then return end
    
    local duelEvents = replicatedStorage:FindFirstChild("DuelEvents")
    if not duelEvents then return end
    
    local pistolFireRemote = duelEvents:FindFirstChild("PistolFire")
    local weaponDamageRemote = replicatedStorage:FindFirstChild("WeaponDamage")
    
    if not pistolFireRemote then return end
    
    lastFired = tick()
    
    local originPos = tool:FindFirstChild("Handle") and tool.Handle.Position or myChar.Head.Position
    local targetPos = targetPart.Position
    
    if CONFIG.WallCheck then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {myChar, camera}
        local result = workspace:Raycast(originPos, (targetPos - originPos), raycastParams)
        if result then
            targetPos = result.Position
        end
    end
    
    pcall(function()
        pistolFireRemote:FireServer(Vector3.new(originPos.X, originPos.Y, originPos.Z), Vector3.new(targetPos.X, targetPos.Y, targetPos.Z))
        
        if weaponDamageRemote and isVisible(targetPart) then
            weaponDamageRemote:FireServer(targetHumanoid, CONFIG.DamageAmount)
        end
    end)
end

-- VINCULACIÓN NATIVA SEGURA: Solo se ejecuta cuando el juego detecta que tu arma fue activada legítimamente.
local function setupTool(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            trySilentShoot()
        end)
    end
end

if player.Character then
    for _, item in ipairs(player.Character:GetChildren()) do
        setupTool(item)
    end
    player.Character.ChildAdded:Connect(setupTool)
end

player.CharacterAdded:Connect(function(newChar)
    newChar.ChildAdded:Connect(setupTool)
end)

-- ============================================
-- 3) ESP (HIGHLIGHT NATIVO)
-- ============================================
local espHighlights = {}

local function updateESP()
    if not CONFIG.ESPEnabled then
        for _, highlight in pairs(espHighlights) do
            if highlight then highlight:Destroy() end
        end
        espHighlights = {}
        return
    end
    
    local enemies = getEnemies()
    local currentHighlights = {}
    
    for _, plr in ipairs(enemies) do
        local char = plr.Character
        if char then
            local highlight = espHighlights[plr]
            if not highlight or not highlight.Parent then
                highlight = Instance.new("Highlight")
                highlight.FillColor = CONFIG.ESPColor
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0.2
                highlight.Adornee = char
                highlight.Parent = char
                espHighlights[plr] = highlight
            end
            currentHighlights[plr] = highlight
        end
    end
    
    for plr, highlight in pairs(espHighlights) do
        if not currentHighlights[plr] then
            if highlight then highlight:Destroy() end
            espHighlights[plr] = nil
        end
    end
end

runService.RenderStepped:Connect(function()
    updateESP()
end)

-- ============================================
-- 4) INTERFAZ GRÁFICA (UI)
-- ============================================
local Theme = {
    Background   = Color3.fromRGB(15, 15, 20),
    Panel        = Color3.fromRGB(22, 22, 30),
    PanelAlt     = Color3.fromRGB(28, 28, 38),
    Stroke       = Color3.fromRGB(70, 70, 90),
    AccentBlue   = Color3.fromRGB(80, 140, 255),
    AccentPurple = Color3.fromRGB(150, 90, 255),
    TextPrimary  = Color3.fromRGB(235, 235, 245),
    TextSecondary= Color3.fromRGB(150, 150, 165),
    OnColor      = Color3.fromRGB(90, 220, 130),
    OffColor     = Color3.fromRGB(200, 70, 90),
}

local FONT = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

local function corner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = inst
    return c
end

local function stroke(inst, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

local function gradient(inst, colorA, colorB, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colorA, colorB)
    g.Rotation = rotation or 45
    g.Parent = inst
    return g
end

local function tween(inst, props, duration, style)
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrawlEmpireSilentUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local windowSize = isMobile and UDim2.fromOffset(280, 420) or UDim2.fromOffset(340, 460)

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = windowSize
main.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
main.BackgroundColor3 = Theme.Background
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 14)
stroke(main, Theme.Stroke, 1, 0.3)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Theme.Panel
header.BackgroundTransparency = 0.05
header.BorderSizePixel = 0
header.Parent = main
corner(header, 14)

local accentBar = Instance.new("Frame")
accentBar.Name = "AccentBar"
accentBar.Size = UDim2.new(0, 4, 1, -16)
accentBar.Position = UDim2.new(0, 10, 0, 8)
accentBar.BackgroundColor3 = Theme.AccentBlue
accentBar.BorderSizePixel = 0
accentBar.Parent = header
corner(accentBar, 4)
gradient(accentBar, Theme.AccentBlue, Theme.AccentPurple, 90)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 26, 0, 6)
titleLabel.Size = UDim2.new(1, -70, 0, 22)
titleLabel.Font = FONT_BOLD
titleLabel.Text = "Brawl Empire"
titleLabel.TextColor3 = Theme.TextPrimary
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 26, 0, 26)
subtitleLabel.Size = UDim2.new(1, -70, 0, 16)
subtitleLabel.Font = FONT
subtitleLabel.Text = "Silent Aim Real v4.4"
subtitleLabel.TextColor3 = Theme.TextSecondary
subtitleLabel.TextSize = 12
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 12)
closeBtn.BackgroundColor3 = Theme.PanelAlt
closeBtn.Text = "✕"
closeBtn.Font = FONT_BOLD
closeBtn.TextColor3 = Theme.TextSecondary
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
closeBtn.Parent = header
corner(closeBtn, 8)
stroke(closeBtn, Theme.Stroke, 1, 0.5)

local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.fromOffset(45, 45)
openBtn.Position = UDim2.new(0, 15, 0.85, -45)
openBtn.BackgroundColor3 = Theme.Panel
openBtn.Text = "⚙️"
openBtn.TextSize = 20
openBtn.Visible = false
openBtn.Parent = screenGui
corner(openBtn, 12)
stroke(openBtn, Theme.Stroke, 1, 0.3)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.new(0, 12, 0, 62)
content.Size = UDim2.new(1, -24, 1, -74)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Theme.AccentPurple
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local itemCount = 0
local function newRow(height)
    itemCount += 1
    local row = Instance.new("Frame")
    row.Name = "Row_" .. itemCount
    row.LayoutOrder = itemCount
    row.Size = UDim2.new(1, 0, 0, height or 44)
    row.BackgroundColor3 = Theme.Panel
    row.BackgroundTransparency = 0.15
    row.BorderSizePixel = 0
    row.Parent = content
    corner(row, 10)
    stroke(row, Theme.Stroke, 1, 0.55)
    return row
end

local function addSection(text)
    itemCount += 1
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Section_" .. itemCount
    lbl.LayoutOrder = itemCount
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Font = FONT_BOLD
    lbl.Text = text:upper()
    lbl.TextColor3 = Theme.AccentPurple
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = content
end

addSection("Combate Legítimo")

-- Toggle Silent Aim
do
    local state = isActive
    local row = newRow(44)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Font = FONT
    label.Text = "Silent Aim Real"
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(1, -96, 0, 0)
    statusLabel.Size = UDim2.new(0, 40, 1, 0)
    statusLabel.Font = FONT_BOLD
    statusLabel.TextSize = 11
    statusLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(42, 22)
    track.Position = UDim2.new(1, -50, 0.5, -11)
    track.BackgroundColor3 = Theme.PanelAlt
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 11)
    stroke(track, Theme.Stroke, 1, 0.4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)

    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = row

    local function render(animated)
        if state then
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Theme.OnColor
            local goalPos = UDim2.new(0, 23, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.AccentBlue}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.AccentBlue end
        else
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Theme.OffColor
            local goalPos = UDim2.new(0, 3, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.PanelAlt}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.PanelAlt end
        end
    end
    render(false)

    button.MouseButton1Click:Connect(function()
        state = not state
        isActive = state
        render(true)
    end)
end

-- Toggle WallCheck
do
    local state = CONFIG.WallCheck
    local row = newRow(44)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Font = FONT
    label.Text = "Anti-Paredes (Raycast)"
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(1, -96, 0, 0)
    statusLabel.Size = UDim2.new(0, 40, 1, 0)
    statusLabel.Font = FONT_BOLD
    statusLabel.TextSize = 11
    statusLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(42, 22)
    track.Position = UDim2.new(1, -50, 0.5, -11)
    track.BackgroundColor3 = Theme.PanelAlt
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 11)
    stroke(track, Theme.Stroke, 1, 0.4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)

    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = row

    local function render(animated)
        if state then
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Theme.OnColor
            local goalPos = UDim2.new(0, 23, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.AccentBlue}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.AccentBlue end
        else
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Theme.OffColor
            local goalPos = UDim2.new(0, 3, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.PanelAlt}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.PanelAlt end
        end
    end
    render(false)

    button.MouseButton1Click:Connect(function()
        state = not state
        CONFIG.WallCheck = state
        render(true)
    end)
end

-- Toggle ESP
do
    local state = CONFIG.ESPEnabled
    local row = newRow(44)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -110, 1, 0)
    label.Font = FONT
    label.Text = "ESP Jugadores"
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(1, -96, 0, 0)
    statusLabel.Size = UDim2.new(0, 40, 1, 0)
    statusLabel.Font = FONT_BOLD
    statusLabel.TextSize = 11
    statusLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(42, 22)
    track.Position = UDim2.new(1, -50, 0.5, -11)
    track.BackgroundColor3 = Theme.PanelAlt
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 11)
    stroke(track, Theme.Stroke, 1, 0.4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 8)

    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = row

    local function render(animated)
        if state then
            statusLabel.Text = "ON"
            statusLabel.TextColor3 = Theme.OnColor
            local goalPos = UDim2.new(0, 23, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.AccentBlue}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.AccentBlue end
        else
            statusLabel.Text = "OFF"
            statusLabel.TextColor3 = Theme.OffColor
            local goalPos = UDim2.new(0, 3, 0.5, -8)
            if animated then tween(knob, {Position = goalPos}, 0.18) tween(track, {BackgroundColor3 = Theme.PanelAlt}, 0.18) else knob.Position = goalPos track.BackgroundColor3 = Theme.PanelAlt end
        end
    end
    render(false)

    button.MouseButton1Click:Connect(function()
        state = not state
        CONFIG.ESPEnabled = state
        render(true)
    end)
end

print("✅ Silent Aim v4.4 cargado: Conectado exclusivamente a Tool.Activated (Anti-disparos fantasmas).")
