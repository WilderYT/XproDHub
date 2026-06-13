--[[
    Untitled Boxing Game - Modern AutoDodge Script
    Fixed: Hoisting error (dodge declared before detection functions)
    GUI: Modern glassmorphic dark theme, draggable, hide/show with RightShift
    Toggle: Animated switch
    Credit: Smith
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local Character = nil
local Humanoid = nil
local RootPart = nil
local enabled = false
local heartbeatConnection = nil
local lastRootVel = Vector3.new
local dodgeCount = 0

-- Configuration
local CONFIG = {
    DodgeDistance = 12,
    DodgeDuration = 0.25,
    DodgeCooldown = 0.3,  -- Prevents spam dodge
    VelocityThresholdM1 = 35,
    VelocityThresholdM2 = 55
}

local lastDodgeTime = 0

-- ========== DODGE FUNCTION (Declared FIRST to avoid hoisting error) ==========
local function executeDodge(attackType)
    if not enabled then return end
    if not RootPart or not Humanoid or Humanoid.Health <= 0 then return end
    if tick() - lastDodgeTime < CONFIG.DodgeCooldown then return end
    lastDodgeTime = tick()
    
    -- Find nearest opponent
    local nearestPlayer = nil
    local nearestDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local dist = (RootPart.Position - root.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestPlayer = player
            end
        end
    end
    
    if not nearestPlayer then return end
    
    local attackerRoot = nearestPlayer.Character.HumanoidRootPart
    local direction = (RootPart.Position - attackerRoot.Position).Unit
    local perpVector = Vector3.new(-direction.Z, 0, direction.X)
    local dodgePos = RootPart.Position + (perpVector * CONFIG.DodgeDistance)
    
    -- Smooth dodge tween
    local tween = TweenService:Create(RootPart, TweenInfo.new(CONFIG.DodgeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(dodgePos)})
    tween:Play()
    
    -- Visual feedback
    local highlight = Instance.new("Highlight")
    highlight.Adornee = Character
    highlight.FillColor = Color3.fromRGB(0, 200, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.4
    highlight.Parent = Character
    game:GetService("Debris"):AddItem(highlight, 0.25)
    
    -- Update stats via GUI if available
    if guiElements and guiElements.updateStats then
        guiElements.updateStats(attackType)
    end
end

-- ========== DETECTION FUNCTIONS (Call dodge AFTER it's declared) ==========
local function detectAttackByVelocity()
    if not RootPart then return end
    local currentVel = RootPart.Velocity
    local velChange = (currentVel - lastRootVel).Magnitude
    lastRootVel = currentVel
    
    if velChange > CONFIG.VelocityThresholdM1 and velChange < CONFIG.VelocityThresholdM2 then
        executeDodge("M1")
    elseif velChange >= CONFIG.VelocityThresholdM2 then
        executeDodge("M2")
    end
end

local function setupAttackDetection()
    if not Character then return end
    local humanoid = Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChild("Animator")
    if not animator then return end
    
    animator.AnimationPlayed:Connect(function(animationTrack)
        if not enabled then return end
        local animId = animationTrack.Animation.AnimationId or ""
        local lowerId = string.lower(animId)
        
        if string.find(lowerId, "light") or string.find(lowerId, "jab") or string.find(lowerId, "fast") then
            executeDodge("M1")
        elseif string.find(lowerId, "heavy") or string.find(lowerId, "hook") or string.find(lowerId, "uppercut") then
            executeDodge("M2")
        end
    end)
end

-- ========== MODERN GUI WITH ANIMATED SWITCH ==========
local guiElements = {}

local function createModernGUI()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SmithAutoDodge"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 440)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
    mainFrame.BackgroundTransparency = 0.92
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Blur overlay (background)
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Enabled = true
    -- Note: BlurEffect must be in Lighting or a ViewportFrame, not directly parented. Adding to Lighting.
    game:GetService("Lighting"):FindFirstChild("Blur") and game:GetService("Lighting"):FindFirstChild("Blur"):Destroy()
    local globalBlur = Instance.new("BlurEffect")
    globalBlur.Name = "SmithBlur"
    globalBlur.Size = 0
    globalBlur.Parent = game:GetService("Lighting")
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = mainFrame
    
    -- Stroke border
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(60, 60, 75)
    stroke.Transparency = 0.5
    stroke.Parent = mainFrame
    
    -- Shadow (simulated with a second frame behind)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 16)
    shadowCorner.Parent = shadow
    shadow.Parent = mainFrame
    
    -- Title Bar (draggable)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.Text = "SMITH AUTODODGE  •  v3.0"
    titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Hide/Show hint
    local hintText = Instance.new("TextLabel")
    hintText.Size = UDim2.new(0, 140, 1, 0)
    hintText.Position = UDim2.new(1, -156, 0, 0)
    hintText.Text = "[RightShift] Hide"
    hintText.TextColor3 = Color3.fromRGB(150, 150, 170)
    hintText.TextSize = 11
    hintText.Font = Enum.Font.Gotham
    hintText.TextXAlignment = Enum.TextXAlignment.Right
    hintText.BackgroundTransparency = 1
    hintText.Parent = titleBar
    
    -- Animated Switch (Toggle)
    local switchContainer = Instance.new("Frame")
    switchContainer.Size = UDim2.new(0, 60, 0, 28)
    switchContainer.Position = UDim2.new(1, -80, 0, 10)
    switchContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    switchContainer.BackgroundTransparency = 0.3
    switchContainer.BorderSizePixel = 0
    switchContainer.Parent = titleBar
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchContainer
    
    local switchButton = Instance.new("TextButton")
    switchButton.Size = UDim2.new(0, 26, 0, 26)
    switchButton.Position = UDim2.new(0, 2, 0.5, -13)
    switchButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    switchButton.BackgroundTransparency = 0
    switchButton.BorderSizePixel = 0
    switchButton.Text = ""
    switchButton.AutoButtonColor = false
    switchButton.Parent = switchContainer
    
    local switchBtnCorner = Instance.new("UICorner")
    switchBtnCorner.CornerRadius = UDim.new(1, 0)
    switchBtnCorner.Parent = switchButton
    
    local switchShadow = Instance.new("UIShadow")
    switchShadow.Parent = switchButton
    
    -- Stats Panel
    local statsPanel = Instance.new("Frame")
    statsPanel.Size = UDim2.new(0.86, 0, 0, 90)
    statsPanel.Position = UDim2.new(0.07, 0, 0.15, 0)
    statsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    statsPanel.BackgroundTransparency = 0.5
    statsPanel.BorderSizePixel = 0
    statsPanel.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 10)
    statsCorner.Parent = statsPanel
    
    local dodgeCountLabel = Instance.new("TextLabel")
    dodgeCountLabel.Size = UDim2.new(1, -20, 0.5, -5)
    dodgeCountLabel.Position = UDim2.new(0, 10, 0, 8)
    dodgeCountLabel.Text = "DODGES: 0"
    dodgeCountLabel.TextColor3 = Color3.fromRGB(200, 210, 255)
    dodgeCountLabel.TextSize = 16
    dodgeCountLabel.Font = Enum.Font.GothamBold
    dodgeCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    dodgeCountLabel.BackgroundTransparency = 1
    dodgeCountLabel.Parent = statsPanel
    
    local lastDodgeLabel = Instance.new("TextLabel")
    lastDodgeLabel.Size = UDim2.new(1, -20, 0.5, -5)
    lastDodgeLabel.Position = UDim2.new(0, 10, 0.5, 8)
    lastDodgeLabel.Text = "LAST: ---"
    lastDodgeLabel.TextColor3 = Color3.fromRGB(160, 160, 190)
    lastDodgeLabel.TextSize = 13
    lastDodgeLabel.Font = Enum.Font.Gotham
    lastDodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
    lastDodgeLabel.BackgroundTransparency = 1
    lastDodgeLabel.Parent = statsPanel
    
    -- Status LED indicator
    local statusLed = Instance.new("Frame")
    statusLed.Size = UDim2.new(0, 10, 0, 10)
    statusLed.Position = UDim2.new(0.86, 0, 0.27, 0)
    statusLed.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    local ledCorner = Instance.new("UICorner")
    ledCorner.CornerRadius = UDim.new(1, 0)
    ledCorner.Parent = statusLed
    statusLed.Parent = mainFrame
    
    -- Info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.86, 0, 0, 40)
    infoLabel.Position = UDim2.new(0.07, 0, 0.42, 0)
    infoLabel.Text = "◆ Auto-detects M1/M2 attacks\n◆ Perfect sidestep dodge\n◆ Undetectable velocity method"
    infoLabel.TextColor3 = Color3.fromRGB(130, 130, 160)
    infoLabel.TextSize = 11
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.BackgroundTransparency = 1
    infoLabel.Parent = mainFrame
    
    -- Credit label
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(1, 0, 0, 30)
    creditLabel.Position = UDim2.new(0, 0, 1, -36)
    creditLabel.Text = "by Smith  •  premium script"
    creditLabel.TextColor3 = Color3.fromRGB(100, 100, 130)
    creditLabel.TextSize = 11
    creditLabel.Font = Enum.Font.Gotham
    creditLabel.TextXAlignment = Enum.TextXAlignment.Center
    creditLabel.BackgroundTransparency = 1
    creditLabel.Parent = mainFrame
    
    -- Draggable logic
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Animated switch click handler
    local switchOn = false
    local switchAnim
    
    local function updateSwitchUI(state)
        local targetPos = state and 32 or 2
        local targetColor = state and Color3.fromRGB(70, 200, 100) or Color3.fromRGB(220, 70, 70)
        local targetContainerColor = state and Color3.fromRGB(50, 100, 70) or Color3.fromRGB(45, 45, 55)
        
        local tween1 = TweenService:Create(switchButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, targetPos, 0.5, -13)})
        local tween2 = TweenService:Create(switchButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor})
        local tween3 = TweenService:Create(switchContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetContainerColor})
        tween1:Play()
        tween2:Play()
        tween3:Play()
    end
    
    switchButton.MouseButton1Click:Connect(function()
        switchOn = not switchOn
        enabled = switchOn
        updateSwitchUI(switchOn)
        
        if enabled then
            if Character and RootPart then
                if heartbeatConnection then heartbeatConnection:Disconnect() end
                heartbeatConnection = RunService.Heartbeat:Connect(detectAttackByVelocity)
            end
            statusLed.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            globalBlur.Size = 6
        else
            if heartbeatConnection then heartbeatConnection:Disconnect() end
            heartbeatConnection = nil
            statusLed.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            globalBlur.Size = 0
        end
    end)
    
    -- Hide/Show with RightShift
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            guiVisible = not guiVisible
            mainFrame.Visible = guiVisible
            hintText.Text = guiVisible and "[RightShift] Hide" or "[RightShift] Show"
        end
    end)
    
    -- Stats update function
    local function updateStatsUI(attackType)
        dodgeCount = dodgeCount + 1
        dodgeCountLabel.Text = "DODGES: " .. dodgeCount
        lastDodgeLabel.Text = "LAST: " .. attackType .. "  •  " .. os.date("%H:%M:%S")
        
        -- Flash LED
        statusLed.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        task.wait(0.1)
        if enabled then
            statusLed.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        else
            statusLed.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end
    
    return {
        updateStats = updateStatsUI,
        setEnabled = function(state)
            switchOn = state
            enabled = state
            updateSwitchUI(state)
            if state then
                if heartbeatConnection then heartbeatConnection:Disconnect() end
                heartbeatConnection = RunService.Heartbeat:Connect(detectAttackByVelocity)
                statusLed.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                globalBlur.Size = 6
            else
                if heartbeatConnection then heartbeatConnection:Disconnect() end
                heartbeatConnection = nil
                statusLed.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                globalBlur.Size = 0
            end
        end
    }
end

-- ========== INITIALIZATION ==========
local function onCharacterAdded(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    lastRootVel = RootPart.Velocity
    setupAttackDetection()
    
    if enabled and not heartbeatConnection then
        heartbeatConnection = RunService.Heartbeat:Connect(detectAttackByVelocity)
    end
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Create GUI and store elements
guiElements = createModernGUI()

warn("Smith AutoDodge v3.0 loaded | Press RightShift to hide/show | Credit: Smith")
