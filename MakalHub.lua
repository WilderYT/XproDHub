-- Squid Game ESP MakalHub con switches circulares (Discord gate, ESPs, Names ESP y Tp Hidden mejorado con lista de jugadores y switch UI moderno)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local DISCORD_LINK = "https://discord.gg/HT4TwYGh5g"

-- ========== DISCORD ACCESS SCREEN ==========
local gui = Instance.new("ScreenGui")
gui.Name = "SG_ESP_Discord_GATE"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local bg = Instance.new("Frame")
bg.Name = "BG"
bg.Parent = gui
bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
bg.BackgroundTransparency = 0.1
bg.Size = UDim2.new(0, 320, 0, 280)
bg.Position = UDim2.new(0.5, -160, 0.5, -140)
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 18)

local logo = Instance.new("TextLabel", bg)
logo.Position = UDim2.new(0.5, -40, 0, 18)
logo.Size = UDim2.new(0, 80, 0, 80)
logo.BackgroundTransparency = 1
logo.Text = "🔴"
logo.TextColor3 = Color3.fromRGB(255,0,130)
logo.TextStrokeTransparency = 0.3
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 74

local title = Instance.new("TextLabel", bg)
title.Position = UDim2.new(0, 0, 0, 92)
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundTransparency = 1
title.Text = "Makal Hub ESP"
title.TextColor3 = Color3.fromRGB(255,0,130)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28

local desc = Instance.new("TextLabel", bg)
desc.Position = UDim2.new(0, 0, 0, 124)
desc.Size = UDim2.new(1, 0, 0, 44)
desc.BackgroundTransparency = 1
desc.Text = "To use the ESP, join our Discord server\nand come back here to unlock the script!"
desc.TextColor3 = Color3.fromRGB(210,210,210)
desc.Font = Enum.Font.Gotham
desc.TextSize = 18
desc.TextWrapped = true

local discordBtn = Instance.new("TextButton", bg)
discordBtn.Position = UDim2.new(0.1, 0, 0, 180)
discordBtn.Size = UDim2.new(0.8, 0, 0, 36)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
discordBtn.Text = "Join Discord"
discordBtn.Font = Enum.Font.GothamBlack
discordBtn.TextSize = 20
discordBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 12)

local unlockBtn = Instance.new("TextButton", bg)
unlockBtn.Position = UDim2.new(0.1, 0, 0, 228)
unlockBtn.Size = UDim2.new(0.8, 0, 0, 36)
unlockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
unlockBtn.Text = "I have joined"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextSize = 20
unlockBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", unlockBtn).CornerRadius = UDim.new(0, 12)

-- ========== CUSTOM TOAST NOTIFICATION ==========
local function showNotification(message)
    if gui:FindFirstChild("Notif") then gui.Notif:Destroy() end

    local notif = Instance.new("Frame")
    notif.Name = "Notif"
    notif.Parent = gui
    notif.Size = UDim2.new(0, 320, 0, 50)
    notif.AnchorPoint = Vector2.new(0, 1)
    notif.Position = UDim2.new(0, 20, 1, -100)
    notif.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
    notif.BackgroundTransparency = 0.22
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.ZIndex = 100
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 16)

    local head = Instance.new("TextLabel", notif)
    head.Size = UDim2.new(1, -18, 0, 20)
    head.Position = UDim2.new(0,9,0,4)
    head.BackgroundTransparency = 1
    head.Text = "Makal Hub ESP Says:"
    head.Font = Enum.Font.GothamBlack
    head.TextSize = 16
    head.TextColor3 = Color3.fromRGB(68, 176, 255)
    head.TextXAlignment = Enum.TextXAlignment.Left
    head.TextYAlignment = Enum.TextYAlignment.Top
    head.TextStrokeTransparency = 0.7
    head.ZIndex = 101

    local msg = Instance.new("TextLabel", notif)
    msg.Size = UDim2.new(1, -18, 0, 18)
    msg.Position = UDim2.new(0, 9, 0, 22)
    msg.BackgroundTransparency = 1
    msg.Text = message
    msg.Font = Enum.Font.Gotham
    msg.TextSize = 15
    msg.TextColor3 = Color3.fromRGB(255,255,255)
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.ZIndex = 101

    local credits = Instance.new("TextLabel", notif)
    credits.Size = UDim2.new(1, -18, 0, 14)
    credits.Position = UDim2.new(0,9,1,-16)
    credits.BackgroundTransparency = 1
    credits.Text = "credits by Smith"
    credits.Font = Enum.Font.Gotham
    credits.TextSize = 12
    credits.TextColor3 = Color3.fromRGB(160, 160, 160)
    credits.TextXAlignment = Enum.TextXAlignment.Left
    credits.ZIndex = 101

    notif.BackgroundTransparency = 1
    head.TextTransparency = 1
    msg.TextTransparency = 1
    credits.TextTransparency = 1
    for i = 0, 1, 0.18 do
        notif.BackgroundTransparency = 0.22 - (i * 0.15)
        head.TextTransparency = 1 - i
        msg.TextTransparency = 1 - i
        credits.TextTransparency = 1 - i
        wait(0.01)
    end

    wait(2.2)

    for i = 0, 1, 0.13 do
        notif.BackgroundTransparency = 0.07 + (i * 0.15)
        head.TextTransparency = i
        msg.TextTransparency = i
        credits.TextTransparency = i
        wait(0.01)
    end
    notif:Destroy()
end

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    showNotification("Copied! Paste in your browser or Discord to join.")
end)

-- ESP UTILS
local function isKiller(plr)
    local hasKnife = false
    if plr.Backpack then
        for _,item in pairs(plr.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("knife") then
                hasKnife = true
            end
        end
    end
    if plr.Character then
        for _,item in pairs(plr.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("knife") then
                hasKnife = true
            end
        end
    end
    return hasKnife
end
local function isHidden(plr)
    return not isKiller(plr)
end
local function clearESPType(isForKiller)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local adornName = plr.Name.."_SGESP"
            local box = workspace:FindFirstChild(adornName)
            if box then
                if isForKiller and isKiller(plr) then
                    box:Destroy()
                elseif (not isForKiller) and isHidden(plr) then
                    box:Destroy()
                end
            end
        end
    end
end
local function makeESP(plr, color)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and not workspace:FindFirstChild(plr.Name.."_SGESP") then
        local root = plr.Character.HumanoidRootPart
        local box = Instance.new("BoxHandleAdornment")
        box.Name = plr.Name.."_SGESP"
        box.Adornee = root
        box.Parent = workspace
        box.Size = Vector3.new(3,6,2)
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Color3 = color
        box.Transparency = 0.7
        box.Visible = true
    end
end

-- === FUNCIÓN DE TELEPORT/LISTA DE JUGADORES ===
local selectedPlayer = nil
local tpEnabled = false
local hitboxSize = Vector3.new(7,7,7)

local function touchHitbox(targetChar)
    local part = Instance.new("Part")
    part.Size = hitboxSize
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Position = targetChar.HumanoidRootPart.Position
    part.Parent = workspace

    part.Touched:Connect(function(hit)
        if hit.Parent == targetChar then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end)
    task.delay(0.2, function()
        part:Destroy()
    end)
end

local function teleportLoop()
    while wait(0.03) do
        if not tpEnabled then continue end
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
          and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if selectedPlayer ~= LocalPlayer then
                LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2)
            end
            touchHitbox(selectedPlayer.Character)
        end
    end
end

-- ========== SWITCHES REDONDEADOS MODERNOS ==========
local function createCircleSwitch(parent, label, position)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 38)
    frame.Position = position
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = label
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 34, 0, 34)
    switch.Position = UDim2.new(1, -44, 0.5, -17)
    switch.BackgroundColor3 = Color3.fromRGB(85, 85, 100)
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.BorderSizePixel = 0

    local circle = Instance.new("UICorner", switch)
    circle.CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = UDim2.new(0, 4, 0, 4)
    knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    knob.BorderSizePixel = 0
    local knobCircle = Instance.new("UICorner", knob)
    knobCircle.CornerRadius = UDim.new(1,0)

    return frame, switch, knob
end

local function setSwitch(switch, knob, active, accentColor)
    if active then
        switch.BackgroundColor3 = accentColor or Color3.fromRGB(0,170,255)
        knob.Position = UDim2.new(1, -30, 0, 4)
        knob.BackgroundColor3 = accentColor or Color3.fromRGB(0,170,255)
    else
        switch.BackgroundColor3 = Color3.fromRGB(85,85,100)
        knob.Position = UDim2.new(0, 4, 0, 4)
        knob.BackgroundColor3 = Color3.fromRGB(180,180,200)
    end
end

-- ========== CARGA UI PRINCIPAL ==========
unlockBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
    gui:Destroy()

    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "SquidGameUI"

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 300)
    mainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local mainGlow = Instance.new("UIStroke")
    mainGlow.Parent = mainFrame
    mainGlow.Color = Color3.fromRGB(100, 200, 255)
    mainGlow.Thickness = 2
    mainGlow.Transparency = 0.3

    local mainGradient = Instance.new("UIGradient")
    mainGradient.Parent = mainFrame
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 75)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 55))
    }
    mainGradient.Rotation = 45

    local title = Instance.new("TextLabel", mainFrame)
    title.Text = "🦑Makal hub"
    title.Size = UDim2.new(1, -70, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Parent = title
    titleStroke.Color = Color3.fromRGB(100, 200, 255)
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.5

    local closeButton = Instance.new("TextButton", mainFrame)
    closeButton.Text = "✖"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 2.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.BorderSizePixel = 0

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local closeGlow = Instance.new("UIStroke")
    closeGlow.Parent = closeButton
    closeGlow.Color = Color3.fromRGB(255, 100, 100)
    closeGlow.Thickness = 1
    closeGlow.Transparency = 0.4

    local minimizeButton = Instance.new("TextButton", mainFrame)
    minimizeButton.Text = "-"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 2.5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 140, 220)
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 16
    minimizeButton.BorderSizePixel = 0

    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeButton

    local minimizeGlow = Instance.new("UIStroke")
    minimizeGlow.Parent = minimizeButton
    minimizeGlow.Color = Color3.fromRGB(100, 150, 255)
    minimizeGlow.Thickness = 1
    minimizeGlow.Transparency = 0.4

    -- Estados
    local espHiddenActive, espSeeksActive, tpHiddenActive, namesESPActive = false, false, false, false

    -- Switches UI
    local espHiddenFrame, espHiddenSwitch, espHiddenKnob = createCircleSwitch(mainFrame, "ESP Hidden", UDim2.new(0, 10, 0,
