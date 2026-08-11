-- SCRIPT CORREGIDO Y OPTIMIZADO: Aimbot + ESP Dinámico
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- ============================================
-- CONFIGURACIÓN
-- ============================================
local CONFIG = {
    TargetMode = "closest",  -- "closest" | "team" | "all"
    AimPart = "Head",
    FOV = 150,
    CheckDistance = 200,
    
    Smoothness = 0.25,
    AutoShoot = true,
    ShootCooldown = 0.1,
    
    ESPEnabled = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
}

local isMobile = userInputService.TouchEnabled
local isPC = not isMobile

-- ============================================
-- BÚSQUEDA SEGURA DE REMOTES DE COMBATE
-- ============================================
local function getCombatRemotes()
    local remotes = {}
    for _, child in ipairs(replicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name:lower()
            if string.find(name, "shoot") or string.find(name, "fire") or string.find(name, "damage") or string.find(name, "hit") or string.find(name, "gun") then
                table.insert(remotes, child)
            end
        end
    end
    return remotes
end

local availableRemotes = getCombatRemotes()

-- ============================================
-- 1) TARGETING DINÁMICO
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

local function getClosestEnemy()
    local enemies = getEnemies()
    if #enemies == 0 then return nil end
    
    local cameraPos = camera.CFrame.Position
    local closest = nil
    local closestDist = math.huge
    
    for _, plr in ipairs(enemies) do
        local part = plr.Character:FindFirstChild(CONFIG.AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
        if part then
            local dist = (part.Position - cameraPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr
            end
        end
    end
    return closest
end

local function getTargetPosition(target)
    if not target or not target.Character then return nil end
    local part = target.Character:FindFirstChild(CONFIG.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return nil end
    return part.Position
end

-- ============================================
-- 2) AIMBOT (CÁMARA SUAVIZADA)
-- ============================================
local function setCameraLookAt(targetPos, smooth)
    if not targetPos then return false end
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
    if smooth and smooth > 0 then
        camera.CFrame = currentCFrame:Lerp(targetCFrame, math.min(smooth, 1))
    else
        camera.CFrame = targetCFrame
    end
    return true
end

-- ============================================
-- 3) SISTEMA DE DISPARO SEGURO
-- ============================================
local function performShoot(target)
    if not target or not target.Character then return false end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not rootPart then return false end
    
    -- Disparar a todos los remotes encontrados para asegurar impacto si el juego los valida
    for _, remote in ipairs(availableRemotes) do
        pcall(function()
            remote:FireServer(humanoid)
            remote:FireServer(rootPart)
            remote:FireServer(target.Character)
        end)
    end
    return true
end

-- ============================================
-- 4) ESP (HIGHLIGHT NATIVO)
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

-- ============================================
-- 5) BUCLE PRINCIPAL
-- ============================================
local isActive = true
local lastShootTime = 0
local currentTarget = nil

runService.RenderStepped:Connect(function()
    if not isActive then return end
    
    updateESP()
    
    currentTarget = getClosestEnemy()
    if not currentTarget then return end
    
    local targetPos = getTargetPosition(currentTarget)
    if not targetPos then return end
    
    local distance = (targetPos - camera.CFrame.Position).Magnitude
    if distance > CONFIG.CheckDistance then return end
    
    local camLook = camera.CFrame.LookVector
    local toTarget = (targetPos - camera.CFrame.Position).Unit
    local angle = math.acos(math.clamp(camLook:Dot(toTarget), -1, 1))
    local angleDeg = math.deg(angle)
    
    if angleDeg > CONFIG.FOV then return end
    
    setCameraLookAt(targetPos, CONFIG.Smoothness)
    
    if CONFIG.AutoShoot then
        local now = tick()
        if now - lastShootTime >= CONFIG.ShootCooldown then
            if performShoot(currentTarget) then
                lastShootTime = now
            end
        end
    end
end)

-- ============================================
-- 6) CONTROLES (PC / MÓVIL)
-- ============================================
if isPC then
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            isActive = not isActive
            print("Aimbot " .. (isActive and "ACTIVADO" or "DESACTIVADO"))
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            if currentTarget then performShoot(currentTarget) end
        end
    end)
else
    local touchCount = 0
    local lastTouchTime = 0
    userInputService.TouchTapInWorld:Connect(function()
        local now = tick()
        if now - lastTouchTime < 0.5 then
            touchCount = touchCount + 1
            if touchCount >= 3 then
                isActive = not isActive
                print("Aimbot " .. (isActive and "ACTIVADO" or "DESACTIVADO"))
                touchCount = 0
            end
        else
            touchCount = 1
        end
        lastTouchTime = now
        
        if currentTarget then performShoot(currentTarget) end
    end)
end

-- ============================================
-- 7) INTERFAZ (UI)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 60)
frame.Position = UDim2.new(0.5, -110, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0.5, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🟢 ON"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.Font = Enum.Font.SourceSansBold
statusText.TextSize = 18
statusText.Parent = frame

local targetText = Instance.new("TextLabel")
targetText.Size = UDim2.new(1, 0, 0.5, 0)
targetText.Position = UDim2.new(0, 0, 0.5, 0)
targetText.BackgroundTransparency = 1
targetText.Text = "Objetivo: Ninguno"
targetText.TextColor3 = Color3.fromRGB(200, 200, 200)
targetText.Font = Enum.Font.SourceSans
targetText.TextSize = 14
targetText.Parent = frame

runService.Heartbeat:Connect(function()
    if isActive then
        statusText.Text = "🟢 ON"
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusText.Text = "🔴 OFF"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    
    if currentTarget then
        targetText.Text = "Objetivo: " .. currentTarget.Name
    else
        targetText.Text = "Objetivo: Ninguno"
    end
end)

print("✅ Script v2 cargado con éxito.")
