-- ============================================
-- SCRIPT INTEGRADO: Brawl Empire (Estilo Rayfield)
-- Créditos: Smith | Con selector de Idioma
-- ============================================

-- Verificar si estamos en Roblox
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- ============================================
-- 1) CONFIGURACIÓN Y SISTEMA DE IDIOMAS
-- ============================================
local CURRENT_LANG = "Spanish" -- Idioma por defecto ("Spanish" o "English")

local Texts = {
    Spanish = {
        WindowTitle = "Brawl Empire | Hub Profesional",
        LoadingTitle = "Cargando Brawl Empire...",
        LoadingSubtitle = "por Smith",
        TabMain = "Funciones Principales",
        TabConfig = "Configuración",
        SecCombat = "Combate",
        ToggleSilent = "Silent Aim Real",
        ToggleWall = "Anti-Paredes (Raycast)",
        SecFarm = "Farming",
        ToggleFarm = "Auto Farm Coins",
        SecVisual = "Visuales",
        ToggleESP = "ESP Jugadores (Highlight)",
        SecAimSettings = "Ajustes de AimBot",
        DropTarget = "Modo de Objetivo",
        SliderFOV = "Campo de Visión (FOV)",
        SliderDist = "Distancia de chequeo",
        LangName = "Idioma / Language",
        MsgLoaded = "Script Cargado Exitosamente!",
        MsgLoadedContent = "Brawl Empire | Hub está listo para usarse (por Smith).",
        MsgSilentOn = "Activado",
        MsgSilentOff = "Desactivado",
        MsgFarmOn = "Recolectando Monedas",
        MsgFarmOff = "Detenido"
    },
    English = {
        WindowTitle = "Brawl Empire | Professional Hub",
        LoadingTitle = "Loading Brawl Empire...",
        LoadingSubtitle = "by Smith",
        TabMain = "Main Features",
        TabConfig = "Settings",
        SecCombat = "Combat",
        ToggleSilent = "Real Silent Aim",
        ToggleWall = "WallCheck (Raycast)",
        SecFarm = "Farming",
        ToggleFarm = "Auto Farm Coins",
        SecVisual = "Visuals",
        ToggleESP = "Player ESP (Highlight)",
        SecAimSettings = "AimBot Settings",
        DropTarget = "Target Mode",
        SliderFOV = "Field of View (FOV)",
        SliderDist = "Check Distance",
        LangName = "Language / Idioma",
        MsgLoaded = "Script Loaded Successfully!",
        MsgLoadedContent = "Brawl Empire | Hub is ready to use (by Smith).",
        MsgSilentOn = "Activated",
        MsgSilentOff = "Deactivated",
        MsgFarmOn = "Collecting Coins",
        MsgFarmOff = "Stopped"
    }
}

local function T(key)
    return Texts[CURRENT_LANG][key] or key
end

local CONFIG = {
    TargetMode = "closest",
    AimPart = "Head",
    FOV = 180,
    CheckDistance = 300,
    DamageAmount = 100,
    WallCheck = true,
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    FarmDistance = 600,
    FarmCooldown = 0.25
}

local isSilentAimActive = false
local isAutoFarmActive = false
local lastFired = 0
local COOLDOWN_TIME = 0.35

-- ============================================
-- 2) LÓGICA DE FUNCIONES
-- ============================================

local function getEnemies()
    local enemies = {}
    local myTeam = player.Team
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                if CONFIG.TargetMode == "team" then
                    if myTeam and plr.Team and plr.Team ~= myTeam then table.insert(enemies, plr) end
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
    if not myChar or not myChar:FindFirstChild("Head") then return false end
    local tool = myChar:FindFirstChildOfClass("Tool")
    local origin = (tool and tool:FindFirstChild("Handle")) and tool.Handle.Position or myChar.Head.Position
    local targetPos = targetPart.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {myChar, camera}
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, targetPos - origin, raycastParams)
    if not result then return true end
    local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
    return hitModel and hitModel == targetPart.Parent
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
                if angleDeg <= CONFIG.FOV and isVisible(part) then
                    if dist < closestDist then
                        closestDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

local function trySilentShoot()
    if not isSilentAimActive then return end
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
        if result then targetPos = result.Position end
    end
    pcall(function()
        pistolFireRemote:FireServer(Vector3.new(originPos.X, originPos.Y, originPos.Z), Vector3.new(targetPos.X, targetPos.Y, targetPos.Z))
        if weaponDamageRemote and isVisible(targetPart) then weaponDamageRemote:FireServer(targetHumanoid, CONFIG.DamageAmount) end
    end)
end

local function setupTool(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(trySilentShoot)
    end
end
if player.Character then
    for _, item in ipairs(player.Character:GetChildren()) do setupTool(item) end
    player.Character.ChildAdded:Connect(setupTool)
end
player.CharacterAdded:Connect(function(newChar)
    newChar.ChildAdded:Connect(setupTool)
end)

local function getCoins()
    local coins = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "ArenaCoin" and obj:IsA("BasePart") then table.insert(coins, obj) end
    end
    return coins
end

task.spawn(function()
    while task.wait(CONFIG.FarmCooldown) do
        if isAutoFarmActive then
            pcall(function()
                local myChar = player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local rootPart = myChar.HumanoidRootPart
                    for _, coin in ipairs(getCoins()) do
                        local distancia = (coin.Position - rootPart.Position).Magnitude
                        if distancia < CONFIG.FarmDistance and distancia > 2 then
                            coin.CFrame = rootPart.CFrame - Vector3.new(0, 2, 0)
                        end
                    end
                end
            end)
        end
    end
end)

local espHighlights = {}
local function updateESP()
    if not CONFIG.ESPEnabled then
        for _, highlight in pairs(espHighlights) do if highlight then highlight:Destroy() end end
        espHighlights = {}
        return
    end
    local enemies = getEnemies()
    local currentHighlights = {}
    for _, plr in ipairs(enemies) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local highlight = espHighlights[plr]
            if not highlight or highlight.Parent ~= char then
                if highlight then highlight:Destroy() end
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
        if not currentHighlights[plr] then if highlight then highlight:Destroy() end espHighlights[plr] = nil end
    end
end
runService.RenderStepped:Connect(updateESP)

-- ============================================
-- 3) INTERFAZ GRÁFICA (RAYFIELD) CON SMITH Y IDIOMA
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = T("WindowTitle"),
   LoadingTitle = T("LoadingTitle"),
   LoadingSubtitle = T("LoadingSubtitle"),
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "BrawlEmpireConfig",
      FileName = "Main"
   },
   KeySystem = false,
})

-- Pestaña Principal
local TabPrincipal = Window:CreateTab(T("TabMain"), "target")

local SectionCombat = TabPrincipal:CreateSection(T("SecCombat"))

local ToggleSilent = TabPrincipal:CreateToggle({
   Name = T("ToggleSilent"),
   CurrentValue = isSilentAimActive,
   Flag = "SilentAimFlag",
   Callback = function(Value)
      isSilentAimActive = Value
      local msg = Value and T("MsgSilentOn") or T("MsgSilentOff")
      Rayfield:Notify({Title = "Silent Aim", Content = msg, Duration = 3})
   end,
})

local ToggleWall = TabPrincipal:CreateToggle({
   Name = T("ToggleWall"),
   CurrentValue = CONFIG.WallCheck,
   Flag = "WallCheckFlag",
   Callback = function(Value)
      CONFIG.WallCheck = Value
   end,
})

local SectionFarm = TabPrincipal:CreateSection(T("SecFarm"))

local ToggleFarm = TabPrincipal:CreateToggle({
   Name = T("ToggleFarm"),
   CurrentValue = isAutoFarmActive,
   Flag = "AutoFarmFlag",
   Callback = function(Value)
      isAutoFarmActive = Value
      local msg = Value and T("MsgFarmOn") or T("MsgFarmOff")
      Rayfield:Notify({Title = "Auto Farm", Content = msg, Duration = 3})
   end,
})

local SectionVisual = TabPrincipal:CreateSection(T("SecVisual"))

local ToggleESP = TabPrincipal:CreateToggle({
   Name = T("ToggleESP"),
   CurrentValue = CONFIG.ESPEnabled,
   Flag = "ESPFlag",
   Callback = function(Value)
      CONFIG.ESPEnabled = Value
   end,
})

-- Pestaña Configuración
local TabConfig = Window:CreateTab(T("TabConfig"), "settings")

-- Selector de Idioma
local SectionLang = TabConfig:CreateSection("Idioma / Language")
local DropdownLang = TabConfig:CreateDropdown({
   Name = T("LangName"),
   Options = {"Spanish", "English"},
   CurrentOption = {CURRENT_LANG},
   Flag = "LangFlag",
   Callback = function(Option)
      CURRENT_LANG = Option[1]
      local titleMsg = (CURRENT_LANG == "Spanish") and "Idioma cambiado" or "Language changed"
      local contentMsg = (CURRENT_LANG == "Spanish") and "Reinicia el script para aplicar todos los textos." or "Restart script to apply all texts."
      Rayfield:Notify({
         Title = titleMsg, 
         Content = contentMsg, 
         Duration = 4
      })
   end,
})

local SectionAimSettings = TabConfig:CreateSection(T("SecAimSettings"))

local DropdownTarget = TabConfig:CreateDropdown({
   Name = T("DropTarget"),
   Options = {"closest", "team", "all"},
   CurrentOption = {CONFIG.TargetMode},
   Flag = "TargetModeFlag",
   Callback = function(Option)
      CONFIG.TargetMode = Option[1]
   end,
})

local SliderFOV = TabConfig:CreateSlider({
   Name = T("SliderFOV"),
   Range = {10, 360},
   Increment = 5,
   Suffix = "grados",
   CurrentValue = CONFIG.FOV,
   Flag = "FOVFlag",
   Callback = function(Value)
      CONFIG.FOV = Value
   end,
})

local SliderDist = TabConfig:CreateSlider({
   Name = T("SliderDist"),
   Range = {50, 1000},
   Increment = 10,
   Suffix = "studs",
   CurrentValue = CONFIG.CheckDistance,
   Flag = "DistFlag",
   Callback = function(Value)
      CONFIG.CheckDistance = Value
   end,
})

Rayfield:Notify({
   Title = T("MsgLoaded"),
   Content = T("MsgLoadedContent"),
   Duration = 5,
   Image = "infinity"
})
