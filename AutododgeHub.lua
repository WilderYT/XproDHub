-- Crackeddssss Baiii Xynnn! Not very clean though it might have broken functions
-- Chunk : nil
-- Services
local localPlayer = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local workspaceService = game:GetService("Workspace")
game:GetService("SoundService")
game:GetService("TweenService")

-- Main Screen GUI
local mainGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
mainGui.Name = "DelfiScript_UI"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 300, 0, 320)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(80, 80, 100)

-- Title Label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "DelfiScript"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.new(1, 1, 1)

-- Top Button Container
local topButtonFrame = Instance.new("Frame", mainFrame)
topButtonFrame.Size = UDim2.new(1, -20, 0, 30)
topButtonFrame.Position = UDim2.new(0, 10, 0, 35)
topButtonFrame.BackgroundTransparency = 1

-- Tabs
local mainTabButton = Instance.new("TextButton", topButtonFrame)
mainTabButton.Size = UDim2.new(0, 90, 1, 0)
mainTabButton.Position = UDim2.new(0, 0, 0, 0)
mainTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
mainTabButton.Text = "Main"
mainTabButton.Font = Enum.Font.GothamBold
mainTabButton.TextSize = 14
mainTabButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", mainTabButton).CornerRadius = UDim.new(0, 6)

local mainTabFrame = Instance.new("Frame", mainFrame)
mainTabFrame.Size = UDim2.new(1, -20, 1, -80)
mainTabFrame.Position = UDim2.new(0, 10, 0, 70)
mainTabFrame.BackgroundTransparency = 1
mainTabFrame.Visible = true

local visualTabButton = Instance.new("TextButton", topButtonFrame)
visualTabButton.Size = UDim2.new(0, 90, 1, 0)
visualTabButton.Position = UDim2.new(0, 95, 0, 0)
visualTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
visualTabButton.Text = "Visual"
visualTabButton.Font = Enum.Font.GothamBold
visualTabButton.TextSize = 14
visualTabButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", visualTabButton).CornerRadius = UDim.new(0, 6)

local visualTabFrame = Instance.new("Frame", mainFrame)
visualTabFrame.Size = UDim2.new(1, -20, 1, -80)
visualTabFrame.Position = UDim2.new(0, 10, 0, 70)
visualTabFrame.BackgroundTransparency = 1
visualTabFrame.Visible = false

local miscTabButton = Instance.new("TextButton", topButtonFrame)
miscTabButton.Size = UDim2.new(0, 90, 1, 0)
miscTabButton.Position = UDim2.new(0, 190, 0, 0)
miscTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
miscTabButton.Text = "Misc"
miscTabButton.Font = Enum.Font.GothamBold
miscTabButton.TextSize = 14
miscTabButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", miscTabButton).CornerRadius = UDim.new(0, 6)

local miscTabFrame = Instance.new("Frame", mainFrame)
miscTabFrame.Size = UDim2.new(1, -20, 1, -80)
miscTabFrame.Position = UDim2.new(0, 10, 0, 70)
miscTabFrame.BackgroundTransparency = 1
miscTabFrame.Visible = false

-- Tab Switching
visualTabButton.MouseButton1Click:Connect(function()
    visualTabFrame.Visible = true
    miscTabFrame.Visible = false
    mainTabFrame.Visible = false
end)

miscTabButton.MouseButton1Click:Connect(function()
    visualTabFrame.Visible = false
    miscTabFrame.Visible = true
    mainTabFrame.Visible = false
end)

mainTabButton.MouseButton1Click:Connect(function()
    visualTabFrame.Visible = false
    miscTabFrame.Visible = false
    mainTabFrame.Visible = true
end)
-- Infinite Jump Button
local infiniteJumpButton = Instance.new("TextButton", mainTabFrame)
infiniteJumpButton.Size = UDim2.new(1, -20, 0, 40)
infiniteJumpButton.Position = UDim2.new(0, 10, 0, 10)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
infiniteJumpButton.Text = "🔼 Infinite Jump"
infiniteJumpButton.Font = Enum.Font.GothamBold
infiniteJumpButton.TextSize = 16
infiniteJumpButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", infiniteJumpButton).CornerRadius = UDim.new(0, 8)

infiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
end)

userInputService.JumpRequest:Connect(function()
    if localPlayer.Character then
        localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Heal on Heartbeat
runService.Heartbeat:Connect(function()
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-- Speed Hack Button
local speedHackButton = Instance.new("TextButton", mainTabFrame)
speedHackButton.Size = UDim2.new(1, -20, 0, 40)
speedHackButton.Position = UDim2.new(0, 10, 0, 160)
speedHackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
speedHackButton.Text = "🏃Speed Hack"
speedHackButton.Font = Enum.Font.GothamBold
speedHackButton.TextSize = 16
speedHackButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", speedHackButton).CornerRadius = UDim.new(0, 8)

local speedHackConnection

speedHackButton.MouseButton1Click:Connect(function()
    speedHackButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
    local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 54
        if speedHackConnection then speedHackConnection:Disconnect() end
        speedHackConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            humanoid.WalkSpeed = 54
        end)
    end
end)

localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 54
    if speedHackConnection then speedHackConnection:Disconnect() end
    speedHackConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        humanoid.WalkSpeed = 54
    end)
end)

-- Noclip Button
local noclipButton = Instance.new("TextButton", mainTabFrame)
noclipButton.Size = UDim2.new(1, -20, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 60)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
noclipButton.Text = "🚪 Noclip"
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 16
noclipButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", noclipButton).CornerRadius = UDim.new(0, 8)

noclipButton.MouseButton1Click:Connect(function()
    noclipButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
end)

runService.Stepped:Connect(function()
    if localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Float Menu Frame
local floatMenuFrame = Instance.new("Frame", mainGui)
floatMenuFrame.Size = UDim2.new(0, 200, 0, 90)
floatMenuFrame.Position = UDim2.new(0, 20, 0.5, -45)
floatMenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
floatMenuFrame.BackgroundTransparency = 0.2
floatMenuFrame.Visible = false
floatMenuFrame.Active = true
floatMenuFrame.Draggable = true
Instance.new("UICorner", floatMenuFrame).CornerRadius = UDim.new(0, 8)

-- Float & Move Forward Button
local floatForwardButton = Instance.new("TextButton", floatMenuFrame)
floatForwardButton.Size = UDim2.new(1, -20, 0, 30)
floatForwardButton.Position = UDim2.new(0, 10, 0, 10)
floatForwardButton.Text = "📍 Float & Move Forward"
floatForwardButton.Font = Enum.Font.GothamBold
floatForwardButton.TextSize = 16
floatForwardButton.TextColor3 = Color3.new(1, 1, 1)
floatForwardButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
Instance.new("UICorner", floatForwardButton).CornerRadius = UDim.new(0, 8)

local floatTimerLabel = Instance.new("TextLabel", floatMenuFrame)
floatTimerLabel.Size = UDim2.new(1, -20, 0, 30)
floatTimerLabel.Position = UDim2.new(0, 10, 0, 50)
floatTimerLabel.Text = "⏳ Timer: 0.0s"
floatTimerLabel.Font = Enum.Font.Gotham
floatTimerLabel.TextSize = 16
floatTimerLabel.TextColor3 = Color3.new(1, 1, 1)
floatTimerLabel.BackgroundTransparency = 1
-- Float & Move Forward Logic
floatForwardButton.MouseButton1Click:Connect(function()
    local rootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    floatForwardButton.Text = "✅ Active (click to stop)"

    local bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.P = 1500

    local bodyPosition = Instance.new("BodyPosition", rootPart)
    bodyPosition.Position = rootPart.Position + Vector3.new(0, 15, 0)
    bodyPosition.MaxForce = Vector3.new(0, 100000, 0)
    bodyPosition.P = 2000
    bodyPosition.D = 1000
end)

-- Float Button (toggle menu visibility)
local floatButton = Instance.new("TextButton", mainTabFrame)
floatButton.Size = UDim2.new(1, -20, 0, 40)
floatButton.Position = UDim2.new(0, 10, 0, 110)
floatButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
floatButton.Text = "🕊️ Float"
floatButton.Font = Enum.Font.GothamBold
floatButton.TextSize = 16
floatButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", floatButton).CornerRadius = UDim.new(0, 8)

floatButton.MouseButton1Click:Connect(function()
    floatMenuFrame.Visible = not floatMenuFrame.Visible
end)

---------------------------------------------------------------------
-- Misc Tab: Instant Steal
---------------------------------------------------------------------
local instantStealButton = Instance.new("TextButton", miscTabFrame)
instantStealButton.Size = UDim2.new(1, -20, 0, 40)
instantStealButton.Position = UDim2.new(0, 10, 0, 10)
instantStealButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
instantStealButton.Text = "⚡ Instant Steal"
instantStealButton.Font = Enum.Font.GothamBold
instantStealButton.TextSize = 16
instantStealButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", instantStealButton).CornerRadius = UDim.new(0, 8)

instantStealButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://pastefy.app/dAjYZBnq/raw"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Youifpg/Steal-a-Brianrot/refs/heads/main/InSTANTSTEAL.lua"))()
end)

---------------------------------------------------------------------
-- Visual Tab: ESP Player
---------------------------------------------------------------------
local espPlayerButton = Instance.new("TextButton", visualTabFrame)
espPlayerButton.Size = UDim2.new(1, -20, 0, 40)
espPlayerButton.Position = UDim2.new(0, 10, 0, 110)
espPlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
espPlayerButton.Text = "💀 ESP Player"
espPlayerButton.Font = Enum.Font.GothamBold
espPlayerButton.TextSize = 16
espPlayerButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", espPlayerButton).CornerRadius = UDim.new(0, 8)

espPlayerButton.MouseButton1Click:Connect(function()
    local players = game:GetService("Players")
    local localPlr = players.LocalPlayer
    local espFolder = Instance.new("Folder", game:GetService("CoreGui"))
    espFolder.Name = "ESP_Storage"

    -- Function to create ESP box
    local function createESP(character)
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
            box.ZIndex = 0
            box.AlwaysOnTop = true
            box.Adornee = humanoidRoot
            box.Parent = espFolder
        end
    end

    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= localPlr and plr.Character then
            createESP(plr.Character)
        end
    end

    players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            createESP(char)
        end)
    end)

    players.PlayerRemoving:Connect(function(plr)
        for _, obj in pairs(espFolder:GetChildren()) do
            if obj:IsA("BoxHandleAdornment") and obj.Adornee and obj.Adornee:IsDescendantOf(plr.Character) then
                obj:Destroy()
            end
        end
    end)
end)

---------------------------------------------------------------------
-- Visual Tab: ESP Name
---------------------------------------------------------------------
local espNameButton = Instance.new("TextButton", visualTabFrame)
espNameButton.Size = UDim2.new(1, -20, 0, 40)
espNameButton.Position = UDim2.new(0, 10, 0, 10)
espNameButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
espNameButton.Text = "🧿 ESP Name"
espNameButton.Font = Enum.Font.GothamBold
espNameButton.TextSize = 16
espNameButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", espNameButton).CornerRadius = UDim.new(0, 8)

espNameButton.MouseButton1Click:Connect(function()
    espNameButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.Adornee = head
                billboard.AlwaysOnTop = true
                billboard.Parent = head

                local nameLabel = Instance.new("TextLabel", billboard)
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = plr.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
            end
        end
    end
end)
---------------------------------------------------------------------
-- Visual Tab: Enable Timer ESP
---------------------------------------------------------------------
local enableTimerESPButton = Instance.new("TextButton", visualTabFrame)
enableTimerESPButton.Size = UDim2.new(1, -20, 0, 40)
enableTimerESPButton.Position = UDim2.new(0, 10, 0, 60)
enableTimerESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
enableTimerESPButton.Text = "⏱️ Enable Timer ESP"
enableTimerESPButton.Font = Enum.Font.GothamBold
enableTimerESPButton.TextSize = 16
enableTimerESPButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", enableTimerESPButton).CornerRadius = UDim.new(0, 8)

enableTimerESPButton.MouseButton1Click:Connect(function()
    local localPlr = game:GetService("Players").LocalPlayer

    task.spawn(function()
        for i = 1, 100 do -- original had ~100 repetitions
            if localPlr.Character and localPlr.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in ipairs(workspaceService:GetDescendants()) do
                    if obj:IsA("TextLabel") then
                        local text = obj.Text -- mimic original access
                    end
                end
            end
            task.wait(1)
        end

        -- original final error
        error("internal 542: <25ms: infinitelooperror>")
    end)
end)
---------------------------------------------------------------------
-- Fly GUI Setup
---------------------------------------------------------------------
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "FlyGui"
flyGui.Enabled = false
flyGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Hidden button to open/close Fly GUI
local hiddenButton = Instance.new("TextButton")
hiddenButton.Size = UDim2.new(0, 50, 0, 50)
hiddenButton.Position = UDim2.new(1, -60, 1, -60)
hiddenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
hiddenButton.Text = "Fly"
hiddenButton.Font = Enum.Font.GothamBold
hiddenButton.TextSize = 14
hiddenButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", hiddenButton).CornerRadius = UDim.new(0, 8)
hiddenButton.Parent = mainGui

hiddenButton.MouseButton1Click:Connect(function()
	flyGui.Enabled = not flyGui.Enabled
end)

---------------------------------------------------------------------
-- Fly Buttons
---------------------------------------------------------------------
local flyButton = Instance.new("TextButton", flyGui)
flyButton.Size = UDim2.new(0, 100, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
flyButton.Text = "Enable Fly"
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 14
flyButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 8)

local forwardButton = Instance.new("TextButton", flyGui)
forwardButton.Size = UDim2.new(0, 100, 0, 40)
forwardButton.Position = UDim2.new(0, 10, 0, 60)
forwardButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
forwardButton.Text = "Forward"
forwardButton.Font = Enum.Font.GothamBold
forwardButton.TextSize = 14
forwardButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", forwardButton).CornerRadius = UDim.new(0, 8)

local backwardButton = Instance.new("TextButton", flyGui)
backwardButton.Size = UDim2.new(0, 100, 0, 40)
backwardButton.Position = UDim2.new(0, 10, 0, 110)
backwardButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
backwardButton.Text = "Backward"
backwardButton.Font = Enum.Font.GothamBold
backwardButton.TextSize = 14
backwardButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", backwardButton).CornerRadius = UDim.new(0, 8)

---------------------------------------------------------------------
-- Original Fly Logic
---------------------------------------------------------------------
local flying = false
local flySpeed = 50
local flyBV, flyBG

local function startFly()
	local char = localPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	-- Keep humanoid from interfering
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = true end

	-- Movement
	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = hrp

	-- Orientation
	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	flyBG.CFrame = hrp.CFrame
	flyBG.P = 1e4
	flyBG.Parent = hrp

	flying = true
end

local function stopFly()
	flying = false
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end

	if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
		localPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
	end
end

-- Toggle fly
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyButton.Text = "Enable Fly"
		flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
	else
		startFly()
		flyButton.Text = "Disable Fly"
		flyButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
	end
end)

-- Forward movement
forwardButton.MouseButton1Down:Connect(function()
	if flyBV then flyBV.Velocity = workspaceService.CurrentCamera.CFrame.LookVector * flySpeed end
end)
forwardButton.MouseButton1Up:Connect(function()
	if flyBV then flyBV.Velocity = Vector3.zero end
end)

-- Backward movement
backwardButton.MouseButton1Down:Connect(function()
	if flyBV then flyBV.Velocity = -workspaceService.CurrentCamera.CFrame.LookVector * flySpeed end
end)
backwardButton.MouseButton1Up:Connect(function()
	if flyBV then flyBV.Velocity = Vector3.zero end
end)

---------------------------------------------------------------------
-- Top Left Image Button (Open/Close Main GUI)
---------------------------------------------------------------------
local imageButton = Instance.new("ImageButton", mainGui)
imageButton.Size = UDim2.new(0, 64, 0, 64)
imageButton.Position = UDim2.new(0, 20, 0, 20)
imageButton.BackgroundTransparency = 1
imageButton.Image = "rbxassetid://101703733024777"

imageButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
