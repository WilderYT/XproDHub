-- SCRIPT COMPLETO: Aimbot + AutoShoot con soporte PC/Móvil
-- Corregido: MouseButton1 ahora usa UserInputType correctamente

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- ============================================
-- CONFIGURACIÓN (AJUSTAR SEGÚN REMOTESPY)
-- ============================================
local CONFIG = {
    TargetName = "wushang52",
    WeaponDamageRemote = "WeaponDamage",
    ShootRemote = "Shoot",  -- Cambiar según RemoteSpy
    ToolName = "Gun",
    AimPart = "Head",
    Smoothness = 0.3,
    FOV = 120,
    CheckDistance = 100,
    AutoShoot = true,
    ShootCooldown = 0.15,
}

-- ============================================
-- DETECTAR PLATAFORMA (PC / MÓVIL)
-- ============================================
local isMobile = userInputService.TouchEnabled
local isPC = not isMobile

print("📱 Plataforma detectada: " .. (isMobile and "Móvil" or "PC"))

-- ============================================
-- OBTENER REMOTES
-- ============================================
local function getRemote(name)
    local remote = replicatedStorage:FindFirstChild(name)
    if not remote then
        for _, child in ipairs(replicatedStorage:GetChildren()) do
            if child:IsA("RemoteEvent") and string.find(child.Name:lower(), name:lower()) then
                return child
            end
        end
    end
    return remote
end

local weaponDamageRemote = getRemote(CONFIG.WeaponDamageRemote)
local shootRemote = getRemote(CONFIG.ShootRemote)

if not weaponDamageRemote then
    warn("⚠️ WeaponDamage NO encontrado. Usa RemoteSpy.")
    return
end

-- ============================================
-- FUNCIONES AIMBOT
-- ============================================
local function getTargetPosition()
    local target = game.Players:FindFirstChild(CONFIG.TargetName)
    if not target or not target.Character then return nil end
    
    local targetPart = target.Character:FindFirstChild(CONFIG.AimPart)
    if not targetPart then
        targetPart = target.Character:FindFirstChild("HumanoidRootPart")
    end
    if not targetPart then return nil end
    
    local velocity = targetPart.Velocity or Vector3.new(0,0,0)
    local prediction = velocity * 0.1
    return targetPart.Position + prediction
end

local function setCameraLookAt(targetPos, smooth)
    if not targetPos then return false end
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
    
    if smooth and smooth > 0 then
        local lerpFactor = math.min(smooth, 1)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, lerpFactor)
    else
        camera.CFrame = targetCFrame
    end
    return true
end

-- ============================================
-- FUNCIÓN DE DISPARO (LEGÍTIMO)
-- ============================================
local function performShoot()
    -- Equipar arma si no está equipada
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if not tool or tool.Name ~= CONFIG.ToolName then
        local backpack = player.Backpack
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name:lower(), CONFIG.ToolName:lower()) then
                item.Parent = player.Character
                tool = item
                break
            end
        end
        if not tool then
            warn("⚠️ Arma no encontrada: " .. CONFIG.ToolName)
            return false
        end
    end
    
    local target = game.Players:FindFirstChild(CONFIG.TargetName)
    if not target or not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- Disparo por Remote
    if shootRemote then
        shootRemote:FireServer(tool, humanoid)
    else
        weaponDamageRemote:FireServer(humanoid, 8238)
    end
    
    -- Simular retroceso (solo PC, en móvil no aplica)
    if isPC then
        local handle = tool:FindFirstChild("Handle")
        if handle then
            handle.Velocity = handle.CFrame.LookVector * -50
            task.wait(0.05)
            handle.Velocity = Vector3.new(0,0,0)
        end
    end
    
    return true
end

-- ============================================
-- BUCLE PRINCIPAL (AIMBOT + AUTOSHOOT)
-- ============================================
local isActive = true
local lastShootTime = 0

runService.RenderStepped:Connect(function()
    if not isActive then return end
    
    local targetPos = getTargetPosition()
    if not targetPos then return end
    
    local distance = (targetPos - camera.CFrame.Position).Magnitude
    if distance > CONFIG.CheckDistance then return end
    
    local camLook = camera.CFrame.LookVector
    local toTarget = (targetPos - camera.CFrame.Position).Unit
    local angle = math.acos(camLook:Dot(toTarget))
    local angleDeg = math.deg(angle)
    
    if angleDeg > CONFIG.FOV then return end
    
    setCameraLookAt(targetPos, CONFIG.Smoothness)
    
    if CONFIG.AutoShoot then
        local now = tick()
        if now - lastShootTime >= CONFIG.ShootCooldown then
            local success = performShoot()
            if success then lastShootTime = now end
        end
    end
end)

-- ============================================
-- DISPARO MANUAL (PC: Click Izquierdo | MÓVIL: Tocar pantalla)
-- ============================================
if isPC then
    -- PC: Click izquierdo del mouse (CORREGIDO)
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            performShoot()
        end
    end)
else
    -- MÓVIL: Toque en pantalla (cualquier toque)
    userInputService.TouchTapInWorld:Connect(function()
        performShoot()
    end)
end

-- ============================================
-- TOGGLE ACTIVAR/DESACTIVAR (F1 en PC / Doble toque en móvil)
-- ============================================
if isPC then
    userInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F1 then
            isActive = not isActive
            print("Aimbot " .. (isActive and "ACTIVADO" or "DESACTIVADO"))
        end
    end)
else
    -- MÓVIL: Doble toque para toggle (3 toques rápidos)
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
    end)
end

-- ============================================
-- INTERFAZ SIMPLE (OPCIONAL)
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 40)
frame.Position = UDim2.new(0.5, -90, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4
frame.Parent = screenGui

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🔴 Aimbot OFF"
statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
statusText.Font = Enum.Font.SourceSansBold
statusText.TextSize = 18
statusText.Parent = frame

-- Actualizar estado en la UI
game:GetService("RunService").Heartbeat:Connect(function()
    if isActive then
        statusText.Text = "🟢 Aimbot ON - " .. CONFIG.TargetName
        statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        statusText.Text = "🔴 Aimbot OFF"
        statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

print("✅ Aimbot cargado. F1 (PC) o 3 toques (Móvil) para toggle.")
print("🎯 Apuntando a: " .. CONFIG.TargetName)
