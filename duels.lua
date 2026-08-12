-- ============================================
-- SCRIPT INTEGRATED: Brawl Empire (Rayfield Hub)
-- Credits: Smith | Language: English
-- ============================================

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local CONFIG = {
    TargetMode = "closest",
    AimPart = "Head",
    FOV = 180,
    CheckDistance = 300,
    DamageAmount = 100,
    WallCheck = true, -- Integrated directly into Silent Aim
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    FarmDistance = 600,
    FarmCooldown = 0.25,
    AutoStreakEnabled = false
}

local isSilentAimActive = false
local isAutoFarmActive = false
local lastFired = 0
local COOLDOWN_TIME = 0.35

-- ============================================
-- 1) CORE FUNCTIONS
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

-- Auto Farm Coins Loop
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

-- Auto Win / Streak Logic (Simulates finishing objectives/defeating remaining enemies quickly to farm match wins)
task.spawn(function()
    while task.wait(2) do
        if CONFIG.AutoStreakEnabled then
            pcall(function()
                -- Automatically targets and clears remaining enemies to secure round wins rapidly
                for _, enemy in ipairs(getEnemies()) do
                    if enemy.Character and enemy.Character:FindFirstChild("Humanoid") then
                        local hum = enemy.Character.Humanoid
                        local root = enemy.Character:FindFirstChild("HumanoidRootPart")
                        local weaponDamageRemote = replicatedStorage:FindFirstChild("WeaponDamage")
                        if hum and hum.Health > 0 and root and weaponDamageRemote then
                            -- Instantly applies finishing damage to secure the match win loop
                            weaponDamageRemote:FireServer(hum, 500)
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
-- 2) RAYFIELD UI (ENGLISH)
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Brawl Empire | Professional Hub",
   LoadingTitle = "Loading Brawl Empire...",
   LoadingSubtitle = "by Smith",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "BrawlEmpireConfig",
      FileName = "Main"
   },
   KeySystem = false,
})

-- Main Tab
local TabMain = Window:CreateTab("Main", "target")

local SectionCombat = TabMain:CreateSection("Combat")

local ToggleSilent = TabMain:CreateToggle({
   Name = "Silent Aim (Includes WallCheck)",
   CurrentValue = isSilentAimActive,
   Flag = "SilentAimFlag",
   Callback = function(Value)
      isSilentAimActive = Value
      local msg = Value and "Activated" or "Deactivated"
      Rayfield:Notify({Title = "Silent Aim", Content = msg, Duration = 3})
   end,
})

local ToggleWall = TabMain:CreateToggle({
   Name = "Bypass Walls (Raycast)",
   CurrentValue = CONFIG.WallCheck,
   Flag = "WallCheckFlag",
   Callback = function(Value)
      CONFIG.WallCheck = Value
   end,
})

local SectionFarm = TabMain:CreateSection("Farming & Streaks")

local ToggleFarm = TabMain:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = isAutoFarmActive,
   Flag = "AutoFarmFlag",
   Callback = function(Value)
      isAutoFarmActive = Value
      local msg = Value and "Collecting Coins" or "Stopped"
      Rayfield:Notify({Title = "Auto Farm", Content = msg, Duration = 3})
   end,
})

local ToggleStreak = TabMain:CreateToggle({
   Name = "Auto Win / Farm Streaks",
   CurrentValue = CONFIG.AutoStreakEnabled,
   Flag = "AutoStreakFlag",
   Callback = function(Value)
      CONFIG.AutoStreakEnabled = Value
      local msg = Value and "Auto Win Enabled" or "Auto Win Disabled"
      Rayfield:Notify({Title = "Streak Farm", Content = msg, Duration = 3})
   end,
})

local SectionVisual = TabMain:CreateSection("Visuals")

local ToggleESP = TabMain:CreateToggle({
   Name = "Player ESP (Highlight)",
   CurrentValue = CONFIG.ESPEnabled,
   Flag = "ESPFlag",
   Callback = function(Value)
      CONFIG.ESPEnabled = Value
   end,
})

-- Settings Tab
local TabConfig = Window:CreateTab("Settings", "settings")

local SectionAimSettings = TabConfig:CreateSection("AimBot Settings")

local DropdownTarget = TabConfig:CreateDropdown({
   Name = "Target Mode",
   Options = {"closest", "team", "all"},
   CurrentOption = {CONFIG.TargetMode},
   Flag = "TargetModeFlag",
   Callback = function(Option)
      CONFIG.TargetMode = Option[1]
   end,
})

local SliderFOV = TabConfig:CreateSlider({
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

local SliderDist = TabConfig:CreateSlider({
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

Rayfield:Notify({
   Title = "Script Loaded Successfully!",
   Content = "Brawl Empire | Hub is ready to use (by Smith).",
   Duration = 5,
   Image = "infinity"
})
