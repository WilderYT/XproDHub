-- ============================================
-- SCRIPT UPDATED: Brawl Empire (Rayfield Hub)
-- Restore: Visible Yellow Line (Beam/Tracer)
-- ============================================

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local CONFIG = {
    TargetMode = "closest",
    AimPart = "Head",
    FOV = 180,
    CheckDistance = 500,
    DamageAmount = 100,
    WallCheck = true,
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    FarmDistance = 600,
    FarmCooldown = 0.25,
    AutoWinEnabled = false
}

local isSilentAimActive = false
local isAutoFarmActive = false
local lastFired = 0
local COOLDOWN_TIME = 0.35
local isInterfaceHidden = false

-- ============================================
-- 1) CORE FUNCTIONS & RESTORED TRACER LINE
-- ============================================

pcall(function()
    local duelEvents = replicatedStorage:FindFirstChild("DuelEvents")
    if duelEvents then
        local pistolFireRemote = duelEvents:FindFirstChild("PistolFire")
        if pistolFireRemote then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            
            mt.__namecall = newclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                -- Restauramos el envío original para que la línea amarilla (tracer) se dibuje correctamente al disparar
                if method == "FireServer" and self == pistolFireRemote then
                    -- Mantiene el flujo legítimo del vector visual hacia el objetivo
                end
                
                return oldNamecall(self, unpack(args))
            end)
            setreadonly(mt, true)
        end
    end
end)

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
    local myChar = player.Character
    if not myChar then return end
    local tool = myChar:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local isKnife = tool.Name:lower():find("kuromi") or tool.Name:lower():find("cuchillo") or tool:FindFirstChild("MacheteScript")
    
    if isKnife then
        pcall(function()
            tool:Activate()
        end)
        return
    end

    if not isSilentAimActive and not CONFIG.AutoWinEnabled then return end
    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    if tick() - lastFired < COOLDOWN_TIME then return end
    
    local target = getClosestEnemyWithinFOV()
    if not target or not target.Character then return end
    local targetHumanoid = target.Character:FindFirstChild("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then return end
    local targetPart = target.Character:FindFirstChild(CONFIG.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    local duelEvents = replicatedStorage:FindFirstChild("DuelEvents")
    if not duelEvents then return end
    local pistolFireRemote = duelEvents:FindFirstChild("PistolFire")
    local weaponDamageRemote = replicatedStorage:FindFirstChild("WeaponDamage")
    if not pistolFireRemote then return end
    
    lastFired = tick()

    pcall(function()
        for i = 1, 2 do
            local direction = (targetPart.Position - camera.CFrame.Position).Unit
            pistolFireRemote:FireServer(targetPart.Position, direction)
            if weaponDamageRemote then 
                weaponDamageRemote:FireServer(targetHumanoid, CONFIG.DamageAmount) 
            end
            task.wait(0.05)
        end
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
                if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChildOfClass("Humanoid") and myChar.Humanoid.Health > 0 then
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

task.spawn(function()
    while task.wait(2.5) do
        if CONFIG.AutoWinEnabled then
            pcall(function()
                local myChar = player.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                local humanoid = myChar:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then return end
                
                local rootPart = myChar.HumanoidRootPart
                local enemies = getEnemies()
                if #enemies > 0 then
                    local target = enemies[1]
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = target.Character.HumanoidRootPart
                        rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.1)
                        trySilentShoot()
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
-- 2) RAYFIELD UI
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLTD/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
   Name = "Brawl Empire | Professional Hub",
   LoadingTitle = "Loading Brawl Empire...",
   LoadingSubtitle = "by Smith & Xprodnow",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

local TabMain = Window:CreateTab("Main", "target")
local SectionCombat = TabMain:CreateSection("Combat")

TabMain:CreateToggle({
   Name = "Silent Aim (With Network Prediction Fix)",
   CurrentValue = isSilentAimActive,
   Flag = "SilentAimFlag",
   Callback = function(Value)
      isSilentAimActive = Value
   end,
})

local SectionFarm = TabMain:CreateSection("Farming & Streaks")

TabMain:CreateToggle({
   Name = "Auto Win / Farm Streaks",
   CurrentValue = CONFIG.AutoWinEnabled,
   Flag = "AutoWinFlag",
   Callback = function(Value)
      CONFIG.AutoWinEnabled = Value
   end,
})

TabMain:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = isAutoFarmActive,
   Flag = "AutoFarmFlag",
   Callback = function(Value)
      isAutoFarmActive = Value
   end,
})

TabMain:CreateSection("Visuals")
TabMain:CreateToggle({
   Name = "Player ESP (Highlight)",
   CurrentValue = CONFIG.ESPEnabled,
   Flag = "ESPFlag",
   Callback = function(Value)
      CONFIG.ESPEnabled = Value
   end,
})

local TabConfig = Window:CreateTab("Settings", "settings")
TabConfig:CreateSection("AimBot Settings")

TabConfig:CreateDropdown({
   Name = "Target Mode",
   Options = {"closest", "team", "all"},
   CurrentOption = {CONFIG.TargetMode},
   Flag = "TargetModeFlag",
   Callback = function(Option)
      CONFIG.TargetMode = Option[1]
   end,
})

TabConfig:CreateSlider({
   Name = "Field of View (FOV)",
   Range = {10, 360},
   Increment = 5,
   Suffix = "degrees",
   CurrentValue = CONFIG.FOV,
   Flag = "FOVFlag",
   Callback = function(Value)
      CONFIG.FOV = Value
   end,
})

TabConfig:CreateSlider({
   Name = "Check Distance",
   Range = {50, 1000},
   Increment = 10,
   Suffix = "studs",
   CurrentValue = CONFIG.CheckDistance,
   Flag = "DistFlag",
   Callback = function(Value)
      CONFIG.CheckDistance = Value
   end,
})

local function getUIContainers()
    local containers = {}
    if gethui then pcall(function() table.insert(containers, gethui()) end) end
    pcall(function() table.insert(containers, game:GetService("CoreGui")) end)
    if player:FindFirstChild("PlayerGui") then pcall(function() table.insert(containers, player.PlayerGui) end) end
    return containers
end

local ToggleHideUI
local function setShowButtonTransparency(invisible)
    pcall(function()
        for _, container in ipairs(getUIContainers()) do
            for _, desc in ipairs(container:GetDescendants()) do
                if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text == "Show Rayfield" then
                    local buttonObj = desc:IsA("TextButton") and desc or desc:FindFirstAncestorOfClass("TextButton") or desc.Parent
                    if buttonObj then
                        local targets = {buttonObj}
                        for _, child in ipairs(buttonObj:GetDescendants()) do table.insert(targets, child) end
                        for _, elem in ipairs(targets) do
                            if invisible then
                                if not elem:GetAttribute("SavedTransp") then
                                    elem:SetAttribute("SavedTransp", true)
                                    if elem:IsA("GuiObject") then elem:SetAttribute("OrigBgTrans", elem.BackgroundTransparency) end
                                    if elem:IsA("TextLabel") or elem:IsA("TextButton") then elem:SetAttribute("OrigTextTrans", elem.TextTransparency) end
                                    if elem:IsA("ImageLabel") or elem:IsA("ImageButton") then elem:SetAttribute("OrigImgTrans", elem.ImageTransparency) end
                                    if elem:IsA("UIStroke") then elem:SetAttribute("OrigStrokeTrans", elem.Transparency) end
                                end
                                if elem:IsA("TextLabel") or elem:IsA("TextButton") then elem.TextTransparency = 1
                                elseif elem:IsA("ImageLabel") or elem:IsA("ImageButton") then elem.ImageTransparency = 1
                                elseif elem:IsA("UIStroke") then elem.Transparency = 1 end
                                if elem:IsA("GuiObject") then elem.BackgroundTransparency = 1 end
                            else
                                if elem:GetAttribute("SavedTransp") then
                                    if elem:IsA("TextLabel") or elem:IsA("TextButton") then elem.TextTransparency = elem:GetAttribute("OrigTextTrans") or 0 end
                                    if elem:IsA("ImageLabel") or elem:IsA("ImageButton") then elem.ImageTransparency = elem:GetAttribute("OrigImgTrans") or 0 end
                                    if elem:IsA("UIStroke") then elem.Transparency = elem:GetAttribute("OrigStrokeTrans") or 0 end
                                    if elem:IsA("GuiObject") then elem.BackgroundTransparency = elem:GetAttribute("OrigBgTrans") or 0 end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

TabConfig:CreateSection("Interface Settings")
ToggleHideUI = TabConfig:CreateToggle({
   Name = "Hide Interface (Invisible Button)",
   CurrentValue = false,
   Flag = "HideInterfaceFlag",
   Callback = function(Value)
      isInterfaceHidden = Value
      setShowButtonTransparency(Value)
   end,
})

runService.RenderStepped:Connect(function()
    if isInterfaceHidden then setShowButtonTransparency(true) end
end)

Rayfield:Notify({
   Title = "Script Loaded!",
   Content = "Brawl Empire | Tracer Line Restored.",
   Duration = 5,
   Image = "infinity"
})
