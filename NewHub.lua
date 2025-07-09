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
showNotification("Discord link copied! Paste in your browser.")
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
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.ScrollBarThickness = 5
playerList.BorderSizePixel = 0

local playerListCorner = Instance.new("UICorner", playerList)
playerListCorner.CornerRadius = UDim.new(0, 8)

local playerListGlow = Instance.new("UIStroke", playerList)
playerListGlow.Color = Color3.fromRGB(100, 200, 255)
playerListGlow.Thickness = 1
playerListGlow.Transparency = 0.7

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0,2)
uiListLayout.Parent = playerList

local mainLabel = Instance.new("TextLabel", mainContent)
mainLabel.Size = UDim2.new(1, 0, 0, 30)
mainLabel.Position = UDim2.new(0, 0, 0, 10)
mainLabel.Text = "🚀 Main Features"
mainLabel.BackgroundTransparency = 1
mainLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
mainLabel.Font = Enum.Font.GothamBold
mainLabel.TextSize = 18

local mainLabelStroke = Instance.new("UIStroke", mainLabel)
mainLabelStroke.Color = Color3.fromRGB(0, 170, 255)
mainLabelStroke.Thickness = 1
mainLabelStroke.Transparency = 0.6

local speedBoostFrame, speedBoostSwitch, speedBoostKnob, speedBoostGlow = createCircleSwitch(mainContent, "⚡ Speed Hack", UDim2.new(0, 0, 0, 50))

local isBoosted = false
local defaultSpeed = 16
local boostedSpeed = 80
local currentConnection = nil

local function updateBoost()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end
    
    if isBoosted then
        currentConnection = RunService.Heartbeat:Connect(function()
            local character = Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
                    local moveDir = humanoid.MoveDirection
                    local currentVelocity = rootPart.Velocity
                    rootPart.Velocity = Vector3.new(
                        moveDir.X * boostedSpeed,
                        currentVelocity.Y,
                        moveDir.Z * boostedSpeed
                    )
                end
            end
        end)
    end
        end

speedBoostSwitch.MouseButton1Click:Connect(function()
    isBoosted = not isBoosted
    setSwitch(speedBoostSwitch, speedBoostKnob, speedBoostGlow, isBoosted, Color3.fromRGB(255, 165, 0))
    updateBoost()
end)

local jumpBoostFrame, jumpBoostSwitch, jumpBoostKnob, jumpBoostGlow = createCircleSwitch(mainContent, "🦘 Jump Power", UDim2.new(0, 0, 0, 88))

local isJumpBoosted = false
local defaultJumpPower = 50
local boostedJumpPower = 120

local function setJumpPower()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = isJumpBoosted and boostedJumpPower or defaultJumpPower
    end
        end

LocalPlayer.CharacterAdded:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = isJumpBoosted and boostedJumpPower or defaultJumpPower
end)

jumpBoostSwitch.MouseButton1Click:Connect(function()
    isJumpBoosted = not isJumpBoosted
    setSwitch(jumpBoostSwitch, jumpBoostKnob, jumpBoostGlow, isJumpBoosted, Color3.fromRGB(50, 255, 50))
    setJumpPower()
end)

local noclipFrame, noclipSwitch, noclipKnob, noclipGlow = createCircleSwitch(mainContent, "👻 Noclip", UDim2.new(0, 0, 0, 126))

local noclipEnabled = false
local noclipConnection = nil

local function updateNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

noclipSwitch.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    setSwitch(noclipSwitch, noclipKnob, noclipGlow, noclipEnabled, Color3.fromRGB(128, 0, 128))
    updateNoclip()
end)

local comingSoonLabel = Instance.new("TextLabel", mainContent)
comingSoonLabel.Size = UDim2.new(1, 0, 0, 40)
comingSoonLabel.Position = UDim2.new(0, 0, 0, 180)
comingSoonLabel.Text = "🔧 More features coming soon!\n✨ Stay tuned for updates"
comingSoonLabel.BackgroundTransparency = 1
comingSoonLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
comingSoonLabel.Font = Enum.Font.Gotham
comingSoonLabel.TextSize = 12

local creditsTitle = Instance.new("TextLabel", creditsContent)
creditsTitle.Size = UDim2.new(1, 0, 0, 25)
creditsTitle.Position = UDim2.new(0, 0, 0, 0)
creditsTitle.Text = "👑 Credits & Team"
creditsTitle.BackgroundTransparency = 1
creditsTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
creditsTitle.Font = Enum.Font.GothamBlack
creditsTitle.TextSize = 16

local creditsTitleStroke = Instance.new("UIStroke", creditsTitle)
creditsTitleStroke.Color = Color3.fromRGB(255, 215, 0)
creditsTitleStroke.Thickness = 1
creditsTitleStroke.Transparency = 0.5

spawn(function()
    while creditsTitle.Parent do
        TweenService:Create(creditsTitleStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(255, 100, 255)
        }):Play()
        wait(1.5)
        TweenService:Create(creditsTitleStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(255, 215, 0)
        }):Play()
        wait(1.5)
    end
end)

local creditsScrollFrame = Instance.new("ScrollingFrame", creditsContent)
creditsScrollFrame.Size = UDim2.new(1, 0, 0, 210)
creditsScrollFrame.Position = UDim2.new(0, 0, 0, 30)
creditsScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
creditsScrollFrame.BackgroundTransparency = 0.8
creditsScrollFrame.BorderSizePixel = 0
creditsScrollFrame.ScrollBarThickness = 4
creditsScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
creditsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
creditsScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local creditsScrollCorner = Instance.new("UICorner", creditsScrollFrame)
creditsScrollCorner.CornerRadius = UDim.new(0, 8)

local creditsScrollGlow = Instance.new("UIStroke", creditsScrollFrame)
creditsScrollGlow.Color = Color3.fromRGB(255, 215, 0)
creditsScrollGlow.Thickness = 1.5
creditsScrollGlow.Transparency = 0.6

local scrollTween = nil
creditsScrollFrame.MouseEnter:Connect(function()
    if scrollTween then scrollTween:Cancel() end
    scrollTween = TweenService:Create(creditsScrollGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Transparency = 0.3,
        Thickness = 2
    })
    scrollTween:Play()
end)

creditsScrollFrame.MouseLeave:Connect(function()
    if scrollTween then scrollTween:Cancel() end
    scrollTween = TweenService:Create(creditsScrollGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Transparency = 0.6,
        Thickness = 1.5
    })
    scrollTween:Play()
end)

local creditsInfo = Instance.new("TextLabel", creditsScrollFrame)
creditsInfo.Size = UDim2.new(1, -10, 0, 380)
creditsInfo.Position = UDim2.new(0, 5, 0, 10)
creditsInfo.Text = [[🎯 Created by: Smith
💻 Developer: Makal Hub Team
🎨 UI Designer: Elmejorsiuuu
⚡ Animator: Elemjorsiuuu

📱 Version: 2.2.0 Mobile Optimized
🚀 Features: ESP, Speed Boost, Jump Power
✨ Mobile-Friendly UI Design
🎮 Smooth Touch Controls

🔧 Technical Details:
• Optimized for mobile devices
• Touch-friendly interface
• Smaller UI elements
• Efficient performance
• Smooth animations

🌟 Special Thanks:
• Beta testers community
• Discord supporters
• Mobile users feedback
• Bug reporters

💜 Thanks for using Makal Hub!
🔥 Join our Discord for updates
⭐ Rate us 5 stars if you enjoy!

🎉 Free Features:
• Unlimited ESP range
• Advanced teleportation
• Custom speed values

📞 Support:
Discord: discord.gg/HT4TwYGh5g
Updates: Check our Discord
Bugs: Report in #bug-reports]]
creditsInfo.BackgroundTransparency = 1
creditsInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
creditsInfo.Font = Enum.Font.Gotham
creditsInfo.TextSize = 11
creditsInfo.TextWrapped = true
creditsInfo.TextXAlignment = Enum.TextXAlignment.Left
creditsInfo.TextYAlignment = Enum.TextYAlignment.Top

local profileFrame = Instance.new("Frame", mainFrame)
profileFrame.Size = UDim2.new(1, -20, 0, 50)
profileFrame.Position = UDim2.new(0, 10, 1, -60)
profileFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
profileFrame.BorderSizePixel = 0

local profileCorner = Instance.new("UICorner", profileFrame)
profileCorner.CornerRadius = UDim.new(0, 8)

local profileGlow = Instance.new("UIStroke", profileFrame)
profileGlow.Color = Color3.fromRGB(0, 170, 255)
profileGlow.Thickness = 1.5
profileGlow.Transparency = 0.4

spawn(function()
    while profileFrame.Parent do
        TweenService:Create(profileGlow, TweenInfo.new(3, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(255, 100, 255),
            Transparency = 0.2
        }):Play()
        wait(3)
        TweenService:Create(profileGlow, TweenInfo.new(3, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(0, 170, 255),
            Transparency = 0.6
        }):Play()
        wait(3)
    end
end)

local avatarFrame = Instance.new("Frame", profileFrame)
avatarFrame.Size = UDim2.new(0, 32, 0, 32)
avatarFrame.Position = UDim2.new(0, 8, 0.5, -16)
avatarFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
avatarFrame.BorderSizePixel = 0

local avatarCorner = Instance.new("UICorner", avatarFrame)
avatarCorner.CornerRadius = UDim.new(0, 16)

local avatarGlow = Instance.new("UIStroke", avatarFrame)
avatarGlow.Color = Color3.fromRGB(100, 200, 255)
avatarGlow.Thickness = 1.5
avatarGlow.Transparency = 0.5

local avatarImage = Instance.new("ImageLabel", avatarFrame)
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"

local avatarImageCorner = Instance.new("UICorner", avatarImage)
avatarImageCorner.CornerRadius = UDim.new(0, 16)

spawn(function()
    while avatarFrame.Parent do
        TweenService:Create(avatarGlow, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(255, 200, 100),
            Transparency = 0.3
        }):Play()
        wait(2)
        TweenService:Create(avatarGlow, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(100, 200, 255),
            Transparency = 0.7
        }):Play()
        wait(2)
    end
end)

local usernameLabel = Instance.new("TextLabel", profileFrame)
usernameLabel.Size = UDim2.new(0, 130, 0, 16)
usernameLabel.Position = UDim2.new(0, 48, 0, 6)
usernameLabel.Text = "👤 "..LocalPlayer.Name
usernameLabel.BackgroundTransparency = 1
usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 12
usernameLabel.TextXAlignment = Enum.TextXAlignment.Left

local usernameStroke = Instance.new("UIStroke", usernameLabel)
usernameStroke.Color = Color3.fromRGB(100, 200, 255)
usernameStroke.Thickness = 0.5
usernameStroke.Transparency = 0.7

local userIdLabel = Instance.new("TextLabel", profileFrame)
userIdLabel.Size = UDim2.new(0, 130, 0, 14)
userIdLabel.Position = UDim2.new(0, 48, 0, 22)
userIdLabel.Text = "🆔 ID: "..LocalPlayer.UserId
userIdLabel.BackgroundTransparency = 1
userIdLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
userIdLabel.Font = Enum.Font.Gotham
userIdLabel.TextSize = 9
userIdLabel.TextXAlignment = Enum.TextXAlignment.Left

local statusLabel = Instance.new("TextLabel", profileFrame)
statusLabel.Size = UDim2.new(0, 70, 0, 14)
statusLabel.Position = UDim2.new(1, -75, 0, 6)
statusLabel.Text = "🟢 Online"
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Right

local levelLabel = Instance.new("TextLabel", profileFrame)
levelLabel.Size = UDim2.new(0, 70, 0, 14)
levelLabel.Position = UDim2.new(1, -75, 0, 22)
levelLabel.Text = " Free"
levelLabel.BackgroundTransparency = 1
levelLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextSize = 9
levelLabel.TextXAlignment = Enum.TextXAlignment.Right

local function switchTab(tabName)
    currentTab = tabName
    
    TweenService:Create(espTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    }):Play()
    TweenService:Create(mainTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    }):Play()
    TweenService:Create(creditsTab, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    }):Play()
    
    espTabGlow.Thickness = 0
    espTabGlow.Transparency = 1
    mainTabGlow.Thickness = 0
    mainTabGlow.Transparency = 1
    creditsTabGlow.Thickness = 0
    creditsTabGlow.Transparency = 1
    
    TweenService:Create(espContent, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, -300, 0, 70)
    }):Play()
    TweenService:Create(mainContent, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, -300, 0, 70)
    }):Play()
    TweenService:Create(creditsContent, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, -300, 0, 70)
    }):Play()
    
    wait(0.15)
    
    espContent.Visible = false
    mainContent.Visible = false
    creditsContent.Visible = false
    
    if tabName == "ESP" then
        TweenService:Create(espTab, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
        espTabGlow.Thickness = 1.5
        espTabGlow.Transparency = 0.4
        espContent.Visible = true
        espContent.Position = UDim2.new(0, 300, 0, 70)
        TweenService:Create(espContent, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 70)
        }):Play()
    elseif tabName == "Main" then
        TweenService:Create(mainTab, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
        mainTabGlow.Thickness = 1.5
        mainTabGlow.Transparency = 0.4
        mainContent.Visible = true
        mainContent.Position = UDim2.new(0, 300, 0, 70)
        TweenService:Create(mainContent, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 70)
        }):Play()
    elseif tabName == "Credits" then
        TweenService:Create(creditsTab, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
        creditsTabGlow.Thickness = 1.5
        creditsTabGlow.Transparency = 0.4
        creditsContent.Visible = true
        creditsContent.Position = UDim2.new(0, 300, 0, 70)
        TweenService:Create(creditsContent, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 70)
        }):Play()
    end
end

espTab.MouseButton1Click:Connect(function() switchTab("ESP") end)
mainTab.MouseButton1Click:Connect(function() switchTab("Main") end)
creditsTab.MouseButton1Click:Connect(function() switchTab("Credits") end)

local function updatePlayers()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local btnSelf = Instance.new("TextButton")
    btnSelf.Size = UDim2.new(1,0,0,22)
    btnSelf.Text = "Disable TP"
    btnSelf.Font = Enum.Font.Gotham
    btnSelf.TextColor3 = Color3.new(1,1,1)
    btnSelf.BackgroundColor3 = Color3.fromRGB(70,70,100)
    btnSelf.Parent = playerList
    btnSelf.MouseButton1Click:Connect(function()
        selectedPlayer = LocalPlayer
        for _,b in ipairs(playerList:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60,60,60)
                }):Play()
            end
        end
        TweenService:Create(btnSelf, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundColor3 = Color3.fromRGB(0,120,255)
        }):Play()
    end)
    
    local count = 0
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,22)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.new(1,1,1)
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.Parent = playerList
            
            btn.MouseEnter:Connect(function()
                if btn.BackgroundColor3 ~= Color3.fromRGB(0,120,255) then
                    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(80,80,90)
                    }):Play()
                end
            end)
            
            btn.MouseLeave:Connect(function()
                if btn.BackgroundColor3 ~= Color3.fromRGB(0,120,255) then
                    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(60,60,60)
                    }):Play()
                end
            end)
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                for _,b in ipairs(playerList:GetChildren()) do
                    if b:IsA("TextButton") then
                        TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = Color3.fromRGB(60,60,60)
                        }):Play()
                    end
                end
                TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    BackgroundColor3 = Color3.fromRGB(0,120,255)
                }):Play()
            end)
            count = count + 1
        end
    end
    playerList.CanvasSize = UDim2.new(0,0,0,24 + count*22)
        end

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)
updatePlayers()

espHiddenSwitch.MouseButton1Click:Connect(function()
    espHiddenActive = not espHiddenActive
    setSwitch(espHiddenSwitch, espHiddenKnob, espHiddenGlow, espHiddenActive, Color3.fromRGB(0,170,255))
    if espHiddenActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isHidden(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                makeESP(player, Color3.fromRGB(0, 140, 255))
            end
        end
    else
        clearESPType(false)
    end
end)

espSeeksSwitch.MouseButton1Click:Connect(function()
    espSeeksActive = not espSeeksActive
    setSwitch(espSeeksSwitch, espSeeksKnob, espSeeksGlow, espSeeksActive, Color3.fromRGB(255,0,0))
    if espSeeksActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isKiller(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                makeESP(player, Color3.fromRGB(255, 0, 0))
            end
        end
    else
        clearESPType(true)
    end
end)

tpHiddenSwitch.MouseButton1Click:Connect(function()
    tpHiddenActive = not tpHiddenActive
    setSwitch(tpHiddenSwitch, tpHiddenKnob, tpHiddenGlow, tpHiddenActive, Color3.fromRGB(0,180,255))
    tpEnabled = tpHiddenActive
end)

local function showNamesESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isHidden(plr) and plr.Character and plr.Character:FindFirstChild("Head") then
            if not plr.Character.Head:FindFirstChild("MakalNameESP") then
                local tag = Instance.new("BillboardGui")
                tag.Name = "MakalNameESP"
                tag.Adornee = plr.Character.Head
                tag.Parent = plr.Character.Head
                tag.Size = UDim2.new(0, 100, 0, 24)
                tag.StudsOffset = Vector3.new(0, 2, 0)
                tag.AlwaysOnTop = true
                
                local txt = Instance.new("TextLabel", tag)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = plr.Name
                txt.Font = Enum.Font.GothamBold
                txt.TextColor3 = Color3.fromRGB(0, 140, 255)
                txt.TextStrokeTransparency = 0.3
                txt.TextSize = 16
            end
        end
    end
        end

local function hideNamesESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local tag = plr.Character.Head:FindFirstChild("MakalNameESP")
            if tag then tag:Destroy() end
        end
    end
end

namesESPSwitch.MouseButton1Click:Connect(function()
    namesESPActive = not namesESPActive
    setSwitch(namesESPSwitch, namesESPKnob, namesESPGlow, namesESPActive, Color3.fromRGB(0,120,255))
    if namesESPActive then
        showNamesESP()
    else
        hideNamesESP()
    end
end)

Players.PlayerAdded:Connect(function()
    updatePlayers()
    if namesESPActive then
        wait(1)
        showNamesESP()
    end
end)

Players.PlayerRemoving:Connect(function()
    updatePlayers()
    hideNamesESP()
end)

task.spawn(teleportLoop)

closeButton.MouseButton1Click:Connect(function()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Rotation = 360
    }):Play()
    
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    
    wait(0.5)
    mainFrame:Destroy()
    clearESPType(true)
    clearESPType(false)
    tpEnabled = false
    hideNamesESP()
end)

local isMinimized = false
local minimizedSize = UDim2.new(0, 300, 0, 35)
local originalSize = mainFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
                minimizeButton.Text = "+"
        espTab.Visible = false
        mainTab.Visible = false
        creditsTab.Visible = false
        espContent.Visible = false
        mainContent.Visible = false
        creditsContent.Visible = false
        profileFrame.Visible = false
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
    else
        minimizeButton.Text = "−"
        espTab.Visible = true
        mainTab.Visible = true
        creditsTab.Visible = true
        profileFrame.Visible = true
        switchTab(currentTab)
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = originalSize}):Play()
    end
end)

mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Rotation = -180

local entranceTween = TweenService:Create(mainFrame,
    TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.02, 0, 0.3, 0),
        Rotation = 0,
        BackgroundTransparency = 0
    }
)

entranceTween:Play()

spawn(function()
    while mainFrame.Parent do
        TweenService:Create(mainGlow, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Transparency = 0.1,
            Thickness = 4
        }):Play()
        wait(2)
        TweenService:Create(mainGlow, TweenInfo.new(2, Enum.EasingStyle.Sine), {
            Transparency = 0.5,
            Thickness = 2
        }):Play()
        wait(2)
    end
end)

local UserInputService = game:GetService("UserInputService")

if UserInputService.TouchEnabled then
    local function enhanceTouchTarget(button)
        local touchArea = Instance.new("Frame")
        touchArea.Size = UDim2.new(1, 10, 1, 10)
        touchArea.Position = UDim2.new(0, -5, 0, -5)
        touchArea.BackgroundTransparency = 1
        touchArea.Parent = button
        touchArea.ZIndex = button.ZIndex + 1
        
        touchArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                button.MouseButton1Click:Fire()
            end
        end)
            end

enhanceTouchTarget(espTab)
    enhanceTouchTarget(mainTab)
    enhanceTouchTarget(creditsTab)
    enhanceTouchTarget(closeButton)
    enhanceTouchTarget(minimizeButton)
    enhanceTouchTarget(espHiddenSwitch)
    enhanceTouchTarget(espSeeksSwitch)
    enhanceTouchTarget(tpHiddenSwitch)
    enhanceTouchTarget(namesESPSwitch)
    enhanceTouchTarget(speedBoostSwitch)
    enhanceTouchTarget(jumpBoostSwitch)
    enhanceTouchTarget(noclipSwitch)
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

if isMobile then
    spawn(function()
        while mainFrame.Parent do
            for i = 0, 360, 5 do
                if not mainFrame.Parent then break end
                mainGradient.Rotation = i
                wait(0.1)
            end
        end
    end)
    
    spawn(function()
        while mainFrame.Parent do
            TweenService:Create(mainGlow, TweenInfo.new(3, Enum.EasingStyle.Sine), {
                Transparency = 0.2,
                Thickness = 3
            }):Play()
            wait(3)
            TweenService:Create(mainGlow, TweenInfo.new(3, Enum.EasingStyle.Sine), {
                Transparency = 0.6,
                Thickness = 2
            }):Play()
            wait(3)
        end
    end)
end

if UserInputService.TouchEnabled then
    UserInputService.TextBoxFocused:Connect(function(textBox)
        if mainFrame and mainFrame.Parent then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.02, 0, 0.1, 0)
            }):Play()
        end
    end)
    
    UserInputService.TextBoxFocusReleased:Connect(function(textBox)
        if mainFrame and mainFrame.Parent then
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.02, 0, 0.3, 0)
            }):Play()
        end
    end)
end

local function showMobileNotification(message, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 50)
    notif.Position = UDim2.new(0.5, -140, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    notif.ZIndex = 1000

local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 12)
    
    local glow = Instance.new("UIStroke", notif)
    glow.Color = Color3.fromRGB(100, 200, 255)
    glow.Thickness = 2
    glow.Transparency = 0.4
    
    local text = Instance.new("TextLabel", notif)
    text.Size = UDim2.new(1, -20, 1, 0)
    text.Position = UDim2.new(0, 10, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = message
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextWrapped = true
    
    notif.Position = UDim2.new(0.5, -140, 0, -60)
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -140, 0, 20)
    }):Play()
    
    task.wait(duration or 3)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -140, 0, -60)
    }):Play()
    
    task.wait(0.3)
    notif:Destroy()
end

task.spawn(function()
    task.wait(1)
    if UserInputService.TouchEnabled then
        showMobileNotification("📱 Mobile-Optimized UI Loaded!", 3)
        task.wait(3.5)
        showMobileNotification("👆 Tap tabs to switch between features", 4)
    end
end)

if UserInputService.TouchEnabled then
    mainFrame.Draggable = false
    
    local dragStart = nil
    local startPos = nil
    local dragging = false
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position
            startPos = mainFrame.Position
            dragging = true
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

if UserInputService.TouchEnabled then
    playerList.ScrollingEnabled = true
    creditsScrollFrame.ScrollingEnabled = true
    
    playerList.ScrollBarImageTransparency = 0.3
    creditsScrollFrame.ScrollBarImageTransparency = 0.3
end

print("🦑 Makal Hub Free v2.2")
print("📱 Mobile Features: Touch-optimized tabs, better spacing, performance improvements")
print("✨ Fixed: Mobile tab layout, touch targets, keyboard handling")
print("🎮 Enhanced: Smooth animations, better performance on mobile devices")

end)

print("🦑 Makal Hub Ultra Free v2.2 (COMPLETE)")
print("📱 Features: Mobile-optimized UI, Touch-friendly controls, Better performance")
print("🔧 Fixed: Tab layout for mobile, improved spacing and sizing")
print("✨ Enhanced: Touch detection, keyboard handling, mobile notifications")
