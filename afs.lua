-- ================================================================
-- DELTA AUTO-FARM SCRIPT FOR KURAMA BOSS (MOBILE TOUCH SIMULATION)
-- Uses VirtualInputManager to send mouse clicks on skill buttons.
-- Includes a toggleable UI with on/off switch.
-- ================================================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")

-- ================================================================
-- CONFIGURATION: Skill button coordinates (from user data)
-- Format: {x = number, y = number}
-- ================================================================
local SKILL_BUTTONS = {
    {x = 2003, y = 959},  -- Button 1
    {x = 2001, y = 772},  -- Button 2
    {x = 1912, y = 588},  -- Button 3
    {x = 2116, y = 606},  -- Button 4
    {x = 2111, y = 606},  -- Button 5
    {x = 2282, y = 697}   -- Button 6
}

-- Boss identifier
local BOSS_NAME = "Kurama_Rig_Updated.002"

-- Teleport distance threshold (if farther than this, teleport)
local TELEPORT_THRESHOLD = 150

-- ================================================================
-- SERVICES
-- ================================================================
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- ================================================================
-- UI CREATION (ScreenGui with toggle button)
-- ================================================================
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FarmToggleGUI"
    screenGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 60)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = screenGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 1, -10)
    button.Position = UDim2.new(0, 5, 0, 5)
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    button.Text = "▶ FARM ON"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Parent = frame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 120, 0, 20)
    statusLabel.Position = UDim2.new(0, 20, 0, 70)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: IDLE"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextScaled = true
    statusLabel.Parent = screenGui

    return button, statusLabel
end

local toggleButton, statusLabel = createUI()

-- ================================================================
-- STATE VARIABLES
-- ================================================================
local farmingEnabled = false
local bossCache = nil
local lastBossCheck = 0

-- ================================================================
-- HELPER FUNCTIONS
-- ================================================================

-- Find boss by exact name
local function findBoss()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == BOSS_NAME then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                return obj
            end
        end
    end
    return nil
end

-- Simulate a click on a skill button using VirtualInputManager
local function clickSkill(x, y)
    -- Move mouse to position (absolute screen coordinates)
    VIM:SendMouseMoveEvent(x, y, 0)
    task.wait(0.02)
    -- Press left button down
    VIM:SendMouseButtonEvent(x, y, 0, true, 0, 0)
    task.wait(0.08)  -- hold duration
    -- Release
    VIM:SendMouseButtonEvent(x, y, 0, false, 0, 0)
end

-- Teleport player near boss (offset upward to avoid clipping)
local function teleportToBoss(bossPos)
    local targetPos = bossPos + Vector3.new(0, 8, 0)
    humanoidRoot.CFrame = CFrame.new(targetPos)
end

-- Spam all skills in sequence
local function spamSkills()
    for _, btn in ipairs(SKILL_BUTTONS) do
        clickSkill(btn.x, btn.y)
        task.wait(0.05)  -- small delay between skills
    end
end

-- ================================================================
-- MAIN FARMING LOOP (runs every 0.3 seconds)
-- ================================================================
local function farmLoop()
    while task.wait(0.3) do
        if not farmingEnabled then
            statusLabel.Text = "Status: OFF"
            continue
        end

        statusLabel.Text = "Status: SCANNING..."

        -- Find boss (refresh cache every 2 seconds)
        local currentTime = tick()
        if currentTime - lastBossCheck > 2 then
            bossCache = findBoss()
            lastBossCheck = currentTime
        end

        local boss = bossCache
        if not boss then
            statusLabel.Text = "Status: NO BOSS"
            continue
        end

        local bossHRP = boss:FindFirstChild("HumanoidRootPart")
        local bossHumanoid = boss:FindFirstChildOfClass("Humanoid")
        if not bossHRP or not bossHumanoid then
            statusLabel.Text = "Status: BOSS INVALID"
            continue
        end

        if bossHumanoid.Health <= 0 then
            statusLabel.Text = "Status: BOSS DEAD"
            -- Optionally wait for respawn
            continue
        end

        -- Check distance to boss
        local distance = (humanoidRoot.Position - bossHRP.Position).Magnitude
        if distance > TELEPORT_THRESHOLD then
            statusLabel.Text = "Status: TELEPORTING..."
            teleportToBoss(bossHRP.Position)
            task.wait(0.2)  -- wait for teleport to settle
        end

        -- Spam skills
        statusLabel.Text = "Status: FARMING..."
        spamSkills()
    end
end

-- ================================================================
-- TOGGLE BUTTON EVENT
-- ================================================================
toggleButton.MouseButton1Click:Connect(function()
    farmingEnabled = not farmingEnabled
    if farmingEnabled then
        toggleButton.Text = "■ FARM OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        statusLabel.Text = "Status: STARTING..."
        -- Reset boss cache on start
        bossCache = nil
    else
        toggleButton.Text = "▶ FARM ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        statusLabel.Text = "Status: STOPPED"
    end
end)

-- ================================================================
-- START THE LOOP
-- ================================================================
spawn(farmLoop)

-- ================================================================
-- INITIAL TOAST
-- ================================================================
print("[palofsc] Auto-Farm script loaded. Toggle UI to start.")
