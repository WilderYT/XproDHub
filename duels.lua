-- SCRIPT COMPLETO: Aimbot + Disparo automático con simulación de legitimidad
-- Requiere: RemoteSpy para identificar el RemoteEvent de disparo exacto

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- ============================================
-- CONFIGURACIÓN (AJUSTAR SEGÚN REMOTESPY)
-- ============================================
local CONFIG = {
    TargetName = "wushang52",
    WeaponDamageRemote = "WeaponDamage",  -- Nombre del RemoteEvent de daño
    ShootRemote = "Shoot",                -- RemoteEvent para disparar (si existe)
    ToolName = "Gun",                     -- Nombre de tu arma equipada
    AimPart = "Head",                     -- Parte a apuntar (Head, HumanoidRootPart)
    Smoothness = 0.3,                     -- 0 = instantáneo, 1 = muy lento
    FOV = 120,                            -- Ángulo de campo de visión para activar
    ShootKey = Enum.KeyCode.MouseButton1, -- Tecla para disparar
    AutoShoot = true,                     -- Disparar automático al apuntar
    CheckDistance = 100,                  -- Distancia máxima para apuntar
}

-- ============================================
-- 1) OBTENER REMOTES DINÁMICAMENTE
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
    warn("⚠️ RemoteEvent de daño NO encontrado. Usa RemoteSpy para identificar el nombre correcto.")
    return
end

print("✅ WeaponDamage encontrado: " .. weaponDamageRemote.Name)

-- ============================================
-- 2) FUNCIÓN DE AIMBOT (CÁLCULO VECTORIAL)
-- ============================================
local function getTargetPosition()
    local target = game.Players:FindFirstChild(CONFIG.TargetName)
    if not target or not target.Character then return nil end
    
    local targetPart = target.Character:FindFirstChild(CONFIG.AimPart)
    if not targetPart then
        targetPart = target.Character:FindFirstChild("HumanoidRootPart")
    end
    if not targetPart then return nil end
    
    -- Obtener posición con corrección por movimiento (predicción básica)
    local velocity = targetPart.Velocity or Vector3.new(0,0,0)
    local prediction = velocity * 0.1  -- 100ms de predicción
    return targetPart.Position + prediction
end

local function calculateAimAngle(targetPos)
    if not targetPos then return nil end
    
    local cameraPos = camera.CFrame.Position
    local direction = (targetPos - cameraPos).Unit
    
    -- Calcular ángulos (en radianes)
    local pitch = math.asin(-direction.Y)
    local yaw = math.atan2(-direction.X, -direction.Z)
    
    return pitch, yaw
end

local function setCameraLookAt(targetPos, smooth)
    if not targetPos then return false end
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
    
    if smooth and smooth > 0 then
        -- Interpolación suave (Slerp)
        local lerpFactor = math.min(smooth, 1)
        local newCFrame = currentCFrame:Lerp(targetCFrame, lerpFactor)
        camera.CFrame = newCFrame
    else
        camera.CFrame = targetCFrame
    end
    return true
end

-- ============================================
-- 3) FUNCIÓN DE DISPARO LEGÍTIMO
-- ============================================
local function performShoot()
    -- Verificar que el arma esté equipada
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if not tool or tool.Name ~= CONFIG.ToolName then
        -- Buscar arma en el inventario y equiparla
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
    
    -- Obtener Humanoid del objetivo
    local target = game.Players:FindFirstChild(CONFIG.TargetName)
    if not target or not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- DISPARO CON REMOTE (si existe)
    if shootRemote then
        -- Simular disparo enviando el RemoteEvent
        shootRemote:FireServer(tool, humanoid)
    else
        -- Si no hay Remote de disparo, usar WeaponDamage directamente
        weaponDamageRemote:FireServer(humanoid, 8238)
    end
    
    -- Simular animación de disparo (opcional)
    local handle = tool:FindFirstChild("Handle")
    if handle then
        local oldPos = handle.Position
        handle.Velocity = handle.CFrame.LookVector * -50  -- Retroceso simulado
        task.wait(0.05)
        handle.Velocity = Vector3.new(0,0,0)
    end
    
    return true
end

-- ============================================
-- 4) BUCLE PRINCIPAL CON AIMBOT + SHOOT
-- ============================================
local isActive = true
local lastShootTime = 0
local shootCooldown = 0.15  -- Segundos entre disparos

runService.RenderStepped:Connect(function()
    if not isActive then return end
    
    local targetPos = getTargetPosition()
    if not targetPos then return end
    
    -- Verificar distancia
    local distance = (targetPos - camera.CFrame.Position).Magnitude
    if distance > CONFIG.CheckDistance then return end
    
    -- Calcular ángulo de desviación (FOV check)
    local camLook = camera.CFrame.LookVector
    local toTarget = (targetPos - camera.CFrame.Position).Unit
    local angle = math.acos(camLook:Dot(toTarget))
    local angleDeg = math.deg(angle)
    
    if angleDeg > CONFIG.FOV then return end
    
    -- Aplicar aimbot con suavizado
    setCameraLookAt(targetPos, CONFIG.Smoothness)
    
    -- Disparo automático o manual
    if CONFIG.AutoShoot then
        local now = tick()
        if now - lastShootTime >= shootCooldown then
            local success = performShoot()
            if success then
                lastShootTime = now
            end
        end
    end
end)

-- ============================================
-- 5) DISPARO MANUAL CON TECLA (opcional)
-- ============================================
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.ShootKey then
        performShoot()
    end
end)

-- ============================================
-- 6) TOGGLE ACTIVAR/DESACTIVAR (F1)
-- ============================================
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        isActive = not isActive
        print("Aimbot " .. (isActive and "ACTIVADO" or "DESACTIVADO"))
    end
end)

print("✅ Aimbot + AutoShoot cargado. F1 para toggle. Apuntando a: " .. CONFIG.TargetName)
print("📌 Si no dispara, usa RemoteSpy y ajusta CONFIG.ShootRemote")
