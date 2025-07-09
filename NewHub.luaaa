local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local DISCORD_LINK = "https://discord.gg/HT4TwYGh5g"

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
logo.Text = "●"
logo.TextColor3 = Color3.fromRGB(255,0,130)
logo.TextStrokeTransparency = 0.3
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 74

local title = Instance.new("TextLabel", bg)
title.Position = UDim2.new(0, 0, 0, 92)
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundTransparency = 1
title.Text = "Makal Hub Join"
title.TextColor3 = Color3.fromRGB(255,0,130)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28

local desc = Instance.new("TextLabel", bg)
desc.Position = UDim2.new(0, 0, 0, 124)
desc.Size = UDim2.new(1, 0, 0, 44)
desc.BackgroundTransparency = 1
desc.Text = "To use the script, join Discord server\nand come back here to unlock the script!"
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
unlockBtn.Text = "already joined"
unlockBtn.Font = Enum.Font.GothamBold
unlockBtn.TextSize = 20
unlockBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", unlockBtn).CornerRadius = UDim.new(0, 12)

local function showNotification(message)
if gui:FindFirstChild("Notif") then gui.Notif:Destroy() end

local notif = Instance.new("Frame")
notif.Name = "Notif"
notif.Parent = gui
notif.Size = UDim2.new(0, 320, 0, 60)
notif.AnchorPoint = Vector2.new(0, 1)
notif.Position = UDim2.new(0, 20, 1, -100)
notif.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
notif.BackgroundTransparency = 1
notif.BorderSizePixel = 0
notif.ClipsDescendants = true
notif.ZIndex = 100
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 16)

local notifGlow = Instance.new("UIStroke", notif)
notifGlow.Color = Color3.fromRGB(100, 200, 255)
notifGlow.Thickness = 2
notifGlow.Transparency = 1

local head = Instance.new("TextLabel", notif)
head.Size = UDim2.new(1, -18, 0, 20)
head.Position = UDim2.new(0,9,0,4)
head.BackgroundTransparency = 1
head.Text = "Makal Hub says:"
head.Font = Enum.Font.GothamBlack
head.TextSize = 16
head.TextColor3 = Color3.fromRGB(68, 176, 255)
head.TextXAlignment = Enum.TextXAlignment.Left
head.TextYAlignment = Enum.TextYAlignment.Top
head.TextStrokeTransparency = 0.7
head.TextTransparency = 1
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
msg.TextTransparency = 1
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
credits.TextTransparency = 1
credits.ZIndex = 101

TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.22
}):Play()

TweenService:Create(notifGlow, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    Transparency = 0.5
}):Play()

TweenService:Create(head, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

TweenService:Create(msg, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

TweenService:Create(credits, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

wait(2.5)

TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(notifGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
    Transparency = 1
}):Play()

TweenService:Create(head, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
    TextTransparency = 1
}):Play()

TweenService:Create(msg, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
    TextTransparency = 1
}):Play()

TweenService:Create(credits, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
    TextTransparency = 1
}):Play()

wait(0.3)
notif:Destroy()
end

discordBtn.MouseButton1Click:Connect(function()
if setclipboard then setclipboard(DISCORD_LINK) end
showNotification("Discord link copied! Paste in your browser to join.")
end)

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

local switchGlow = Instance.new("UIStroke", switch)
switchGlow.Color = Color3.fromRGB(100, 200, 255)
switchGlow.Thickness = 0
switchGlow.Transparency = 1

local knob = Instance.new("Frame", switch)
knob.Size = UDim2.new(0, 26, 0, 26)
knob.Position = UDim2.new(0, 4, 0, 4)
knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
knob.BorderSizePixel = 0
local knobCircle = Instance.new("UICorner", knob)
knobCircle.CornerRadius = UDim.new(1,0)

switch.MouseEnter:Connect(function()
    TweenService:Create(switchGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Thickness = 2,
        Transparency = 0.5
    }):Play()
    TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 36, 0, 36)
    }):Play()
end)

switch.MouseLeave:Connect(function()
    TweenService:Create(switchGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Thickness = 0,
        Transparency = 1
    }):Play()
    TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 34, 0, 34)
    }):Play()
end)

return frame, switch, knob, switchGlow
end

local function createMobileTab(parent, text, position, isActive)
local tab = Instance.new("TextButton", parent)
tab.Size = UDim2.new(0.32, -4, 0, 26)
tab.Position = position
tab.BackgroundColor3 = isActive and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 80)
tab.Text = text
tab.Font = Enum.Font.GothamBold
tab.TextSize = 11
tab.TextColor3 = Color3.new(1,1,1)
tab.BorderSizePixel = 0

local corner = Instance.new("UICorner", tab)
corner.CornerRadius = UDim.new(0, 4)

local tabGlow = Instance.new("UIStroke", tab)
tabGlow.Color = Color3.fromRGB(0, 170, 255)
tabGlow.Thickness = isActive and 1.5 or 0
tabGlow.Transparency = isActive and 0.4 or 1

tab.MouseEnter:Connect(function()
    TweenService:Create(tabGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Thickness = 1.5,
        Transparency = 0.6
    }):Play()
    TweenService:Create(tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0.32, -2, 0, 28)
    }):Play()
end)

tab.MouseLeave:Connect(function()
    if tab.BackgroundColor3 ~= Color3.fromRGB(0, 170, 255) then
        TweenService:Create(tabGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Thickness = 0,
            Transparency = 1
        }):Play()
    end
    TweenService:Create(tab, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0.32, -4, 0, 26)
    }):Play()
end)

return tab, tabGlow
end

local function setSwitch(switch, knob, switchGlow, active, accentColor)
local targetColor = accentColor or Color3.fromRGB(0,170,255)

if active then
    TweenService:Create(switch, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundColor3 = targetColor
    }):Play()
    TweenService:Create(knob, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -30, 0, 4),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    switchGlow.Color = targetColor
else
    TweenService:Create(switch, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(85,85,100)
    }):Play()
    TweenService:Create(knob, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = Color3.fromRGB(180,180,200)
    }):Play()
end
end

unlockBtn.MouseButton1Click:Connect(function()
gui.Enabled = false
gui:Destroy()

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "SquidGameUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
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
mainGlow.Thickness = 3
mainGlow.Transparency = 0.3

local mainGradient = Instance.new("UIGradient")
mainGradient.Parent = mainFrame
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 65, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 55))
}
mainGradient.Rotation = 45

spawn(function()
    while mainFrame.Parent do
        for i = 0, 360, 2 do
            if not mainFrame.Parent then break end
            mainGradient.Rotation = i
            wait(0.05)
        end
    end
end)

local title = Instance.new("TextLabel", mainFrame)
title.Text = "🦑 Makal Hub"
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

local titleStroke = Instance.new("UIStroke")
titleStroke.Parent = title
titleStroke.Color = Color3.fromRGB(100, 200, 255)
titleStroke.Thickness = 1
titleStroke.Transparency = 0.5

spawn(function()
    while title.Parent do
        TweenService:Create(titleStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(255, 100, 200)
        }):Play()
        wait(2)
        TweenService:Create(titleStroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(100, 200, 255)
        }):Play()
        wait(2)
    end
end)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Text = "✕"
closeButton.Size = UDim2.new(0, 26, 0, 26)
closeButton.Position = UDim2.new(1, -30, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local closeGlow = Instance.new("UIStroke")
closeGlow.Parent = closeButton
closeGlow.Color = Color3.fromRGB(255, 100, 100)
closeGlow.Thickness = 0
closeGlow.Transparency = 1

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Thickness = 1.5,
        Transparency = 0.4
    }):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 28, 0, 28)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Thickness = 0,
        Transparency = 1
    }):Play()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 26, 0, 26)
    }):Play()
end)

local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Text = "−"
minimizeButton.Size = UDim2.new(0, 26, 0, 26)
minimizeButton.Position = UDim2.new(1, -60, 0, 2)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 140, 220)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 14
minimizeButton.BorderSizePixel = 0

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

local minimizeGlow = Instance.new("UIStroke")
minimizeGlow.Parent = minimizeButton
minimizeGlow.Color = Color3.fromRGB(100, 150, 255)
minimizeGlow.Thickness = 0
minimizeGlow.Transparency = 1

minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Thickness = 1.5,
        Transparency = 0.4
    }):Play()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 28, 0, 28)
    }):Play()
end)

minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Thickness = 0,
        Transparency = 1
    }):Play()
    TweenService:Create(minimizeButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 26, 0, 26)
    }):Play()
end)

local currentTab = "ESP"

local espTab, espTabGlow = createMobileTab(mainFrame, "ESP", UDim2.new(0, 6, 0, 35), true)
local mainTab, mainTabGlow = createMobileTab(mainFrame, "Main", UDim2.new(0.34, 0, 0, 35), false)
local creditsTab, creditsTabGlow = createMobileTab(mainFrame, "Credits", UDim2.new(0.68, -2, 0, 35), false)

local espContent = Instance.new("Frame", mainFrame)
espContent.Size = UDim2.new(1, -20, 0, 245)
espContent.Position = UDim2.new(0, 10, 0, 70)
espContent.BackgroundTransparency = 1
espContent.Visible = true

local mainContent = Instance.new("Frame", mainFrame)
mainContent.Size = UDim2.new(1, -20, 0, 245)
mainContent.Position = UDim2.new(0, 10, 0, 70)
mainContent.BackgroundTransparency = 1
mainContent.Visible = false

local creditsContent = Instance.new("Frame", mainFrame)
creditsContent.Size = UDim2.new(1, -20, 0, 245)
creditsContent.Position = UDim2.new(0, 10, 0, 70)
creditsContent.BackgroundTransparency = 1
creditsContent.Visible = false

local espHiddenActive, espSeeksActive, tpHiddenActive, namesESPActive = false, false, false, false

local espHiddenFrame, espHiddenSwitch, espHiddenKnob, espHiddenGlow = createCircleSwitch(espContent, "ESP Hidden", UDim2.new(0, 0, 0, 0))
local espSeeksFrame, espSeeksSwitch, espSeeksKnob, espSeeksGlow = createCircleSwitch(espContent, "ESP Seeks", UDim2.new(0, 0, 0, 38))
local tpHiddenFrame, tpHiddenSwitch, tpHiddenKnob, tpHiddenGlow = createCircleSwitch(espContent, "TP Hidden", UDim2.new(0, 0, 0, 76))
local namesESPFrame, namesESPSwitch, namesESPKnob, namesESPGlow = createCircleSwitch(espContent, "Names ESP", UDim2.new(0, 0, 0, 114))

local playerListLabel = Instance.new("TextLabel", espContent)
playerListLabel.Size = UDim2.new(1, 0, 0, 20)
playerListLabel.Position = UDim2.new(0, 0, 0, 152)
playerListLabel.Text = "select a player for tp:"
playerListLabel.BackgroundTransparency = 1
playerListLabel.TextColor3 = Color3.new(1,1,1)
playerListLabel.Font = Enum.Font.Gotham
playerListLabel.TextSize = 13

local playerList = Instance.new("ScrollingFrame", espContent)
playerList.Size = UDim2.new(1, 0, 0, 70)
playerList.Position = UDim2.new(0, 0, 0, 172)
playerList.BackgroundColor3 = Color3.fromRGB(45,45,45)
playerList.CanvasSize = UDim2.new(0
