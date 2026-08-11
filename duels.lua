-- Script mejorado con bypass de validaciones y rate limiting
-- Estrategia: simular estado de ronda válida, spam controlado y referencias frescas

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local weaponDamage = replicatedStorage:FindFirstChild("WeaponDamage")

if not weaponDamage then
    warn("WeaponDamage no encontrado")
    return
end

-- 1) FORZAR ESTADO DE RONDA (simular que estamos en juego)
local function forceRoundState()
    local roundState = replicatedStorage:FindFirstChild("RoundState") or game:GetService("ReplicatedStorage"):FindFirstChild("GameState")
    if roundState then
        -- Intentar cambiar el estado localmente (puede no tener efecto, pero útil para algunos juegos)
        if roundState:IsA("BoolValue") then roundState.Value = true end
        if roundState:IsA("StringValue") then roundState.Value = "Playing" end
        if roundState:IsA("NumberValue") then roundState.Value = 1 end
    end
    -- Simular que tenemos un arma equipada (si existe el evento de equipar)
    local equipment = player.Character:FindFirstChild("Tool")
    if not equipment then
        local fakeTool = Instance.new("Tool")
        fakeTool.Name = "FakeWeapon"
        fakeTool.Parent = player.Character
        wait(0.1)
        fakeTool:Destroy()
    end
end

-- 2) OBTENER HUMANOID FRESCO (cada ataque)
local function getFreshHumanoid(targetName)
    local target = game.Players:FindFirstChild(targetName)
    if not target or not target.Character then return nil end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    return humanoid
end

-- 3) SPAM INTELIGENTE CON JITTER (evitar rate limiting)
local function attackWithJitter(targetName)
    local humanoid = getFreshHumanoid(targetName)
    if not humanoid then return false end
    
    -- Enviar con parámetros adicionales para simular legitimidad
    local args = {
        [1] = humanoid,
        [2] = 8238,
        [3] = tick(),  -- timestamp para simular fresh
        [4] = player.Character.PrimaryPart.Position  -- posición actual
    }
    
    weaponDamage:FireServer(unpack(args))
    return true
end

-- 4) BUCLE PRINCIPAL CON BACKOFF EXPONENCIAL
local targetName = "wushang52"
local successCount = 0
local failCount = 0
local baseWait = 0.5
local maxWait = 3.0
local currentWait = baseWait

while true do
    -- Forzar estado de ronda antes de cada ciclo
    forceRoundState()
    
    local success = attackWithJitter(targetName)
    
    if success then
        successCount = successCount + 1
        failCount = 0
        currentWait = baseWait  -- Resetear wait si funciona
        print("Ataque exitoso #" .. successCount)
    else
        failCount = failCount + 1
        -- Backoff exponencial si falla
        currentWait = math.min(currentWait * 1.5, maxWait)
        print("Fallo #" .. failCount .. " - esperando " .. currentWait .. "s")
    end
    
    -- Si falla demasiado, intentar forzar respawn del objetivo
    if failCount > 10 then
        local target = game.Players:FindFirstChild(targetName)
        if target and target.Character then
            target.Character.Humanoid.Health = 0  -- Forzar muerte para respawn
        end
        failCount = 0
    end
    
    wait(currentWait + math.random(0, 20) / 100)  -- Jitter aleatorio
end
