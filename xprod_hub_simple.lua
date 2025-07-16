-- XproD Hub v2.5 - SIMPLE INFINITE AUTOCLICKER
-- FIXED: 2-second intervals, infinite clicking until disabled
-- NO MORE COMPLEXITY - JUST WORKS!

getgenv().XproD_TrainSpeed = getgenv().XproD_TrainSpeed or false
getgenv().XproD_TrainAgility = getgenv().XproD_TrainAgility or false
getgenv().XproD_TrainSword = getgenv().XproD_TrainSword or false
getgenv().XproD_AutoFarmBandit = getgenv().XproD_AutoFarmBandit or false
getgenv().XproD_BringBandits = getgenv().XproD_BringBandits or false
getgenv().XproD_AntiAFK = getgenv().XproD_AntiAFK or false

pcall(function() game.CoreGui.XproD_Hub:Destroy() end)

local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
local RunService = game:GetService("RunService")

-- SIMPLE GUI CREATION
local gui = Instance.new("ScreenGui")
gui.Name = "XproD_Hub"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

-- Simple icon
local IconFrame = Instance.new("Frame", gui)
IconFrame.Size = UDim2.new(0, 60, 0, 60)
IconFrame.Position = UDim2.new(0, 50, 0, 120)
IconFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
IconFrame.BorderSizePixel = 0

local IconCorner = Instance.new("UICorner", IconFrame)
IconCorner.CornerRadius = UDim.new(0, 15)

local IconBtn = Instance.new("TextButton", IconFrame)
IconBtn.Size = UDim2.new(1, 0, 1, 0)
IconBtn.BackgroundTransparency = 1
IconBtn.Text = "X"
IconBtn.Font = Enum.Font.GothamBold
IconBtn.TextSize = 24
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Main frame
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 16)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "XproD Hub v2.5 - SIMPLE AUTOCLICKER"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Simple buttons
local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 350, 0, 40)
    btn.Position = UDim2.new(0, 25, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle buttons
local swordBtn = createButton("Sword Training: OFF", 60, function()
    getgenv().XproD_TrainSword = not getgenv().XproD_TrainSword
    swordBtn.Text = "Sword Training: " .. (getgenv().XproD_TrainSword and "ON" or "OFF")
    swordBtn.BackgroundColor3 = getgenv().XproD_TrainSword and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

local banditBtn = createButton("Bandit Farm: OFF", 110, function()
    getgenv().XproD_AutoFarmBandit = not getgenv().XproD_AutoFarmBandit
    banditBtn.Text = "Bandit Farm: " .. (getgenv().XproD_AutoFarmBandit and "ON" or "OFF")
    banditBtn.BackgroundColor3 = getgenv().XproD_AutoFarmBandit and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

local speedBtn = createButton("Speed Training: OFF", 160, function()
    getgenv().XproD_TrainSpeed = not getgenv().XproD_TrainSpeed
    speedBtn.Text = "Speed Training: " .. (getgenv().XproD_TrainSpeed and "ON" or "OFF")
    speedBtn.BackgroundColor3 = getgenv().XproD_TrainSpeed and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

local agilityBtn = createButton("Agility Training: OFF", 210, function()
    getgenv().XproD_TrainAgility = not getgenv().XproD_TrainAgility
    agilityBtn.Text = "Agility Training: " .. (getgenv().XproD_TrainAgility and "ON" or "OFF")
    agilityBtn.BackgroundColor3 = getgenv().XproD_TrainAgility and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 80)
end)

-- Close button
createButton("CLOSE", 260, function()
    MainFrame.Visible = false
end)

-- Toggle visibility
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- SIMPLE AUTOCLICKER FUNCTIONS
local Remote = game:GetService("ReplicatedStorage").RemoteEvents

-- Simple click function
local function simpleClick()
    pcall(function()
        if mouse and mouse.Button1Down then
            mouse.Button1Down()
            task.wait(0.05)
            mouse.Button1Up()
        end
    end)
end

-- Check if sword equipped
local function hasSword()
    local char = plr.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    return tool ~= nil
end

-- Training functions
local function doSwordTraining()
    if not hasSword() then return end
    pcall(function()
        Remote.SwordTrainingEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
        simpleClick()
    end)
end

local function doSpeedTraining()
    pcall(function()
        Remote.SpeedTrainingEvent:FireServer()
        Remote.SpeedPopUpEvent:FireServer()
    end)
end

local function doAgilityTraining()
    pcall(function()
        Remote.AgilityTrainingEvent:FireServer()
        Remote.AgilityPopUpEvent:FireServer()
    end)
end

local function attackBandit()
    if not hasSword() then return end
    pcall(function()
        Remote.SwordAttackEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
        simpleClick()
        
        -- Also activate tool
        local tool = plr.Character and plr.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
    end)
end

-- Bandit functions
local function getBandits()
    local bandits = {}
    local npcs = workspace:FindFirstChild("NPCs")
    if npcs then
        for _, npc in pairs(npcs:GetChildren()) do
            if npc.Name == "Bandit " and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                table.insert(bandits, npc)
            end
        end
    end
    return bandits
end

local function tpToBandit(bandit)
    if bandit and bandit:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = bandit.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

-- SIMPLE INFINITE LOOPS WITH EXACT 2-SECOND TIMING
local lastSwordTime = 0
local lastBanditTime = 0
local lastSpeedTime = 0
local lastAgilityTime = 0

-- Main loop using RunService.Heartbeat for precision
RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    
    -- Sword training every 2 seconds
    if getgenv().XproD_TrainSword and currentTime - lastSwordTime >= 2 then
        doSwordTraining()
        lastSwordTime = currentTime
        print("🗡️ Sword training at", currentTime)
    end
    
    -- Bandit farming every 2 seconds
    if getgenv().XproD_AutoFarmBandit and currentTime - lastBanditTime >= 2 then
        local bandits = getBandits()
        if #bandits > 0 then
            tpToBandit(bandits[1])
            attackBandit()
            lastBanditTime = currentTime
            print("💀 Bandit attack at", currentTime)
        end
    end
    
    -- Speed training every 2 seconds
    if getgenv().XproD_TrainSpeed and currentTime - lastSpeedTime >= 2 then
        doSpeedTraining()
        lastSpeedTime = currentTime
        print("🏃 Speed training at", currentTime)
    end
    
    -- Agility training every 2 seconds
    if getgenv().XproD_TrainAgility and currentTime - lastAgilityTime >= 2 then
        doAgilityTraining()
        lastAgilityTime = currentTime
        print("🤸 Agility training at", currentTime)
    end
end)

-- Sword auto-equip
local function equipSword()
    local mainGui = plr.PlayerGui:FindFirstChild("Main")
    if mainGui and mainGui:FindFirstChild("Hotkeys") and mainGui.Hotkeys:FindFirstChild("Button_4") then
        local btn = mainGui.Hotkeys.Button_4
        if typeof(firesignal) == "function" then
            firesignal(btn.MouseButton1Click)
        else
            local vim = game:GetService("VirtualInputManager")
            local pos = btn.AbsolutePosition
            local size = btn.AbsoluteSize
            vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, btn, 1)
            vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, btn, 1)
        end
    end
end

-- Auto-equip when training starts
plr.CharacterAdded:Connect(function()
    task.wait(2)
    if getgenv().XproD_TrainSword or getgenv().XproD_AutoFarmBandit then
        equipSword()
    end
end)

-- Notification
task.wait(1)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "XproD Hub v2.5";
    Text = "✅ Simple infinite autoclicker loaded! 2-second intervals guaranteed!";
    Duration = 5;
})

print("🚀 XproD Hub v2.5 - SIMPLE INFINITE AUTOCLICKER loaded!")
print("⏰ EXACT 2-second intervals using RunService.Heartbeat")
print("♾️ INFINITE clicking until you disable it")
print("🔧 SIMPLE one-method approach that works")
print("Ready for reliable farming!")