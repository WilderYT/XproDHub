-- Squid Game ESP Pro with Discord access screen (English, clipboard copy + notification styled and located like reference image)
getgenv().ShowHidden = true
getgenv().ShowKiller = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

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
logo.Text = "â—"
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

-- ========== CUSTOM TOAST NOTIFICATION BOTTOM LEFT (DISCORD STYLE) ==========
local function showNotification(message)
    if gui:FindFirstChild("Notif") then gui.Notif:Destroy() end

    local notif = Instance.new("Frame")
    notif.Name = "Notif"
    notif.Parent = gui
    notif.Size = UDim2.new(0, 320, 0, 50)
    notif.AnchorPoint = Vector2.new(0, 1)
    notif.Position = UDim2.new(0, 20, 1, -100) -- Bottom left, just above the joystick
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

-- Discord btn: copy link & notify user
discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    showNotification("Copied! Paste in your browser or Discord to join.")
end)

-- ========== WHEN "I HAVE JOINED" IS PRESSED ==========
unlockBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
    gui:Destroy()
    -- Now load the ESP UI (English!)
    loadstring([[
        getgenv().ShowHidden = true
        getgenv().ShowKiller = true

        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local CoreGui = game:GetService("CoreGui")
        local UIS = game:GetService("UserInputService")

        -- UI
        local gui = Instance.new("ScreenGui", CoreGui)
        gui.Name = "SG_ESP_UI_PRO"
        gui.ResetOnSpawn = false

        -- Movable Squid Game Icon
        local openBtn = Instance.new("TextButton", gui)
        openBtn.Name = "SquidIcon"
        openBtn.Size = UDim2.new(0, 60, 0, 60)
        openBtn.Position = UDim2.new(0, 20, 1, -80)
        openBtn.Text = "â—"
        openBtn.TextColor3 = Color3.fromRGB(255, 0, 130)
        openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        openBtn.BackgroundTransparency = 0.2
        openBtn.Font = Enum.Font.GothamBlack
        openBtn.TextSize = 44

        -- Movable main menu
        local frame = Instance.new("Frame", gui)
        frame.Name = "MainMenu"
        frame.Size = UDim2.new(0, 210, 0, 130)
        frame.Position = UDim2.new(0, 90, 1, -150)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BackgroundTransparency = 0.15
        frame.Visible = false
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

        local lab = Instance.new("TextLabel", frame)
        lab.Size = UDim2.new(1, 0, 0, 34)
        lab.BackgroundTransparency = 1
        lab.Text = "ðŸ¦‘Makal Hub ESPðŸ¦‘"
        lab.Font = Enum.Font.GothamBlack
        lab.TextSize = 20
        lab.TextColor3 = Color3.fromRGB(255,0,130)

        local btn1 = Instance.new("TextButton", frame)
        btn1.Size = UDim2.new(0.9, 0, 0, 32)
        btn1.Position = UDim2.new(0.05, 0, 0, 40)
        btn1.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn1.Text = "Show Hiders: ON"
        btn1.Font = Enum.Font.GothamBold
        btn1.TextSize = 18
        btn1.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 10)

        local btn2 = Instance.new("TextButton", frame)
        btn2.Size = UDim2.new(0.9, 0, 0, 32)
        btn2.Position = UDim2.new(0.05, 0, 0, 80)
        btn2.BackgroundColor3 = Color3.fromRGB(255,0,0)
        btn2.Text = "Show Killers: ON"
        btn2.Font = Enum.Font.GothamBold
        btn2.TextSize = 18
        btn2.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 10)

        openBtn.MouseButton1Click:Connect(function()
            frame.Visible = not frame.Visible
        end)
        btn1.MouseButton1Click:Connect(function()
            getgenv().ShowHidden = not getgenv().ShowHidden
            btn1.Text = "Show Hiders: "..(getgenv().ShowHidden and "ON" or "OFF")
        end)
        btn2.MouseButton1Click:Connect(function()
            getgenv().ShowKiller = not getgenv().ShowKiller
            btn2.Text = "Show Killers: "..(getgenv().ShowKiller and "ON" or "OFF")
        end)

        -- Make UI draggable
        local function makeDraggable(guiObject)
            local dragging, dragStart, startPos
            guiObject.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = guiObject.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            guiObject.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    guiObject.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
                end
            end)
        end
        makeDraggable(openBtn)
        makeDraggable(frame)

        -- Clear ESP boxes
        local function clearESP()
            for _,v in pairs(workspace:GetChildren()) do
                if v:IsA("BoxHandleAdornment") and v.Name:find("_SGESP") then
                    v:Destroy()
                end
            end
        end

        -- Detect killer role (has knife)
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

        -- Detect hider role (no knife)
        local function isHidden(plr)
            return not isKiller(plr)
        end

        -- Create ESP box
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

        while true do
            clearESP()
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if getgenv().ShowKiller and isKiller(plr) then
                        makeESP(plr, Color3.fromRGB(255,0,0))
                    elseif getgenv().ShowHidden and isHidden(plr) then
                        makeESP(plr, Color3.fromRGB(0,170,255))
                    end
                end
            end
            wait(1)
        end
    ]])()
end)
