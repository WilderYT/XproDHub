--[[
    Untitled Boxing Game - Perfect AutoDodge Script
    Detects M1 (Light) and M2 (Heavy) attacks
    GUI: Minimalist glassmorphic design (Parented to PlayerGui)
    Credit: Smith
    Executor: Synapse X, Krnl, ScriptWare, Solara
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = nil
local Humanoid = nil
local RootPart = nil

-- Configuration
local CONFIG = {
    DodgeDistance = 12,        -- Studs to dodge sideways
    DodgeDuration = 0.25,      -- Seconds
    ReactionTime = 0.05,       -- 50ms reaction (undetectable)
    M1AnimationPattern = "RightHook",   -- Typical light attack anim
    M2AnimationPattern = "Uppercut"     -- Typical heavy attack anim
}

-- Attack Detection via Animation Track Monitoring
local function setupAttackDetection()
    local animator = Character:WaitForChild("Humanoid"):WaitForChild("Animator")
    local activeTracks = {}
    
    animator.AnimationPlayed:Connect(function(animationTrack)
        local animName = animationTrack.Animation.AnimationId
        if animationTrack.IsPlaying and not activeTracks[animationTrack] then
            activeTracks[animationTrack] = true
            
            if string.find(animName, "Light") or string.find(animName, "Jab") then
                dodge("M1")
            elseif string.find(animName, "Heavy") or string.find(animName, "Hook") then
                dodge("M2")
            end
            
            animationTrack.Stopped:Wait()
            activeTracks[animationTrack] = nil
        end
    end)
end

-- Alternative Detection via HumanoidRootPart Velocity Change
local lastRootVel = Vector3.new
local function detectAttackByVelocity()
    local currentVel = RootPart.Velocity
    local velChange = (currentVel - lastRootVel).Magnitude
    
    if velChange > 25 and velChange < 80 then
        if velChange < 45 then
            dodge("M1")
        else
            dodge("M2")
        end
    end
    lastRootVel = currentVel
end

-- Perfect Dodge Execution
local function dodge(attackType)
    if not RootPart or not Humanoid or Humanoid.Health <= 0 then return end
    
    local nearestPlayer, nearestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
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
    
    local tweenInfo = TweenInfo.new(
        CONFIG.DodgeDuration,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(dodgePos)})
    tween:Play()
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = Character
    highlight.FillColor = Color3.fromRGB(0, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.5
    highlight.Parent = Character
    game:GetService("Debris"):AddItem(highlight, 0.3)
end

-- GUI Creation (Minimalist - Smith Style) - FIXED: Uses PlayerGui instead of CoreGui
local function createGUI()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SmithAutoDodge"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 380)
    mainFrame.Position = UDim2.new(0, 15, 0.5, -190)
    mainFrame.BackgroundTransparency = 0.85
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1.5
    uiStroke.Color = Color3.fromRGB(100, 100, 255)
    uiStroke.Transparency = 0.6
    uiStroke.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = "Smith AutoDodge v2.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = false
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = titleBar
    
    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 12, 0, 12)
    led.Position = UDim2.new(1, -25, 0.5, -6)
    led.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    led.BackgroundTransparency = 0.2
    led.Parent = titleBar
    
    local ledCorner = Instance.new("UICorner")
    ledCorner.CornerRadius = UDim.new(1, 0)
    ledCorner.Parent = led
    
    local pulse = game:GetService("TweenService"):Create(led, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {BackgroundTransparency = 0.7})
    pulse:Play()
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.8, 0, 0, 45)
    toggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
    toggleButton.Text = "ENABLE"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 16
    toggleButton.Font = Enum.Font.GothamSemibold
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleButton.BackgroundTransparency = 0.4
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleButton
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0.8, 0, 0, 80)
    statsFrame.Position = UDim2.new(0.1, 0, 0.45, 0)
    statsFrame.BackgroundTransparency = 0.8
    statsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    local dodgeCountLabel = Instance.new("TextLabel")
    dodgeCountLabel.Size = UDim2.new(1, -20, 0.5, -5)
    dodgeCountLabel.Position = UDim2.new(0, 10, 0, 5)
    dodgeCountLabel.Text = "Dodges: 0"
    dodgeCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    dodgeCountLabel.TextSize = 14
    dodgeCountLabel.Font = Enum.Font.Gotham
    dodgeCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    dodgeCountLabel.BackgroundTransparency = 1
    dodgeCountLabel.Parent = statsFrame
    
    local lastDodgeLabel = Instance.new("TextLabel")
    lastDodgeLabel.Size = UDim2.new(1, -20, 0.5, -5)
    lastDodgeLabel.Position = UDim2.new(0, 10, 0.5, 5)
    lastDodgeLabel.Text = "Last: ---"
    lastDodgeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    lastDodgeLabel.TextSize = 14
    lastDodgeLabel.Font = Enum.Font.Gotham
    lastDodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
    lastDodgeLabel.BackgroundTransparency = 1
    lastDodgeLabel.Parent = statsFrame
    
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
    
    local dodgeCount = 0
    local function updateStats(attackType)
        dodgeCount = dodgeCount + 1
        dodgeCountLabel.Text = "Dodges: " .. dodgeCount
        lastDodgeLabel.Text = "Last: " .. attackType .. " | " .. os.date("%H:%M:%S")
        
        led.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        task.wait(0.15)
        led.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
    
    local originalDodge = dodge
    dodge = function(attackType)
        originalDodge(attackType)
        updateStats(attackType)
    end
    
    local enabled = false
    local connection = nil
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggleButton.Text = "ENABLED ✓"
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            led.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if Character then
                connection = RunService.Heartbeat:Connect(function()
                    if not enabled then return end
                    detectAttackByVelocity()
                end)
            end
        else
            toggleButton.Text = "DISABLED"
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            led.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
    
    return {updateStats = updateStats}
end

-- Initialize
local function onCharacterAdded(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    lastRootVel = RootPart.Velocity
    setupAttackDetection()
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

createGUI()
warn("Smith AutoDodge v2.0 - Loaded | Credit: Smith (PlayerGui version)")
