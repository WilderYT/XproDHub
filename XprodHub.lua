-- XproD Hub | GUI profesional con icono visual para cerrar/abrir (círculo morado con X, movible)
-- Speed (autocorrer real, versión solicitada) y Agility Training (versión solicitada), créditos by Smith

getgenv().XproD_TrainSpeed = getgenv().XproD_TrainSpeed or false
getgenv().XproD_TrainAgility = getgenv().XproD_TrainAgility or false

pcall(function() game.CoreGui.XproD_Hub:Destroy() end)
local uis = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Name = "XproD_Hub"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

-- ÍCONO VISUAL PARA ABRIR/CERRAR (círculo morado con X, movible)
local IconBtn = Instance.new("ImageButton", gui)
IconBtn.Name = "OpenCloseIcon"
IconBtn.Size = UDim2.new(0, 54, 0, 54)
IconBtn.Position = UDim2.new(0, 40, 0, 120)
IconBtn.BackgroundTransparency = 1
IconBtn.Image = "rbxassetid://3926307971" -- SpriteSheet público Roblox
IconBtn.ImageRectOffset = Vector2.new(204, 4) -- Esto toma el icono de X circular
IconBtn.ImageRectSize = Vector2.new(36, 36)
IconBtn.ImageColor3 = Color3.fromRGB(181, 82, 255)
IconBtn.ZIndex = 50

-- IconBtn MOVIBLE
local draggingIcon, dragStartIcon, startPosIcon
IconBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStartIcon = input.Position
        startPosIcon = IconBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingIcon = false end
        end)
    end
end)
uis.InputChanged:Connect(function(input)
    if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartIcon
        IconBtn.Position = UDim2.new(startPosIcon.X.Scale, startPosIcon.X.Offset + delta.X, startPosIcon.Y.Scale, startPosIcon.Y.Offset + delta.Y)
        if gui:FindFirstChild("MainFrame") then
            gui.MainFrame.Position = UDim2.new(0, IconBtn.Position.X.Offset + 60, 0, IconBtn.Position.Y.Offset - 50)
        end
    end
end)

-- MAIN HUB FRAME (movible, aparece/desaparece con el icono)
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 320)
MainFrame.Position = UDim2.new(0, IconBtn.Position.X.Offset + 60, 0, IconBtn.Position.Y.Offset - 50)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 22, 32)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Visible = true

-- Fondo decorativo líneas/capas
local DecoBG = Instance.new("ImageLabel", MainFrame)
DecoBG.Size = UDim2.new(1, 0, 1, 0)
DecoBG.Position = UDim2.new(0, 0, 0, 0)
DecoBG.BackgroundTransparency = 1
DecoBG.Image = "rbxassetid://15195781313"
DecoBG.ImageTransparency = 0.94
DecoBG.ZIndex = 8

local function border(obj)
    local UIStroke = Instance.new("UIStroke", obj)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(185, 80, 255)
    UIStroke.Transparency = 0.15
    return UIStroke
end
border(MainFrame)

-- Mueve MainFrame junto al icono
local draggingFr, dragStartFr, startPosFr, offset
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFr = true
        dragStartFr = input.Position
        startPosFr = MainFrame.Position
        offset = IconBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingFr = false end
        end)
    end
end)
uis.InputChanged:Connect(function(input)
    if draggingFr and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartFr
        MainFrame.Position = UDim2.new(startPosFr.X.Scale, startPosFr.X.Offset + delta.X, startPosFr.Y.Scale, startPosFr.Y.Offset + delta.Y)
        IconBtn.Position = UDim2.new(0, MainFrame.Position.X.Offset - 60, 0, MainFrame.Position.Y.Offset + 50)
    end
end)

-- Al hacer click el icono, oculta o muestra el frame
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- MENU LATERAL, switches, créditos y funcionalidad igual que antes
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.Position = UDim2.new(0, 0, 0, 0)
SideBar.BackgroundTransparency = 0.15
SideBar.BackgroundColor3 = Color3.fromRGB(18, 16, 25)
SideBar.ZIndex = 11
border(SideBar)

local SideLogo = Instance.new("ImageLabel", SideBar)
SideLogo.Size = UDim2.new(0, 36, 0, 36)
SideLogo.Position = UDim2.new(0, 8, 0, 8)
SideLogo.BackgroundTransparency = 1
SideLogo.Image = "rbxassetid://14594347870"
SideLogo.ImageColor3 = Color3.fromRGB(191, 82, 255)
SideLogo.ZIndex = 13

local HubTitle = Instance.new("TextLabel", SideBar)
HubTitle.Text = "XproD Hub"
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 18
HubTitle.TextColor3 = Color3.fromRGB(100, 255, 230)
HubTitle.Position = UDim2.new(0, 48, 0, 12)
HubTitle.Size = UDim2.new(0, 80, 0, 22)
HubTitle.BackgroundTransparency = 1
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.ZIndex = 13

local SmallTitle = Instance.new("TextLabel", SideBar)
SmallTitle.Text = "AFS"
SmallTitle.Font = Enum.Font.Gotham
SmallTitle.TextSize = 13
SmallTitle.TextColor3 = Color3.fromRGB(150, 255, 255)
SmallTitle.Position = UDim2.new(0, 54, 0, 31)
SmallTitle.Size = UDim2.new(0, 60, 0, 16)
SmallTitle.BackgroundTransparency = 1
SmallTitle.TextXAlignment = Enum.TextXAlignment.Left
SmallTitle.ZIndex = 13

local function menuBtn(text, y, selected)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.Position = UDim2.new(0, 6, 0, y)
    btn.BackgroundTransparency = selected and 0.07 or 1
    btn.BackgroundColor3 = Color3.fromRGB(50, 18, 55)
    btn.Text = "   "..text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = selected and Color3.fromRGB(90,255,255) or Color3.fromRGB(170,170,170)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 14
    btn.AutoButtonColor = false
    if selected then border(btn) end
    return btn
end
local TrainingBtn = menuBtn("Training", 62, true)
local CreditBtn = menuBtn("by Smith", 102, false)

local TrainPanel = Instance.new("Frame", MainFrame)
TrainPanel.Name = "TrainPanel"
TrainPanel.Size = UDim2.new(1, -130, 1, -30)
TrainPanel.Position = UDim2.new(0, 128, 0, 18)
TrainPanel.BackgroundTransparency = 0.13
TrainPanel.BackgroundColor3 = Color3.fromRGB(17, 15, 22)
TrainPanel.ZIndex = 12
border(TrainPanel)

local TrainTitle = Instance.new("TextLabel", TrainPanel)
TrainTitle.Text = "Train"
TrainTitle.Font = Enum.Font.GothamBold
TrainTitle.TextSize = 17
TrainTitle.TextColor3 = Color3.fromRGB(170, 80, 255)
TrainTitle.Position = UDim2.new(0, 12, 0, 4)
TrainTitle.Size = UDim2.new(1, -20, 0, 18)
TrainTitle.BackgroundTransparency = 1
TrainTitle.TextXAlignment = Enum.TextXAlignment.Left
TrainTitle.ZIndex = 13

local function makeSwitch(parent, y, label, getVal, setVal)
    local b = Instance.new("Frame", parent)
    b.Size = UDim2.new(1, -16, 0, 38)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundTransparency = 0.35
    b.BackgroundColor3 = Color3.fromRGB(34, 28, 44)
    b.ZIndex = 14
    border(b)
    local t = Instance.new("TextLabel", b)
    t.Text = label
    t.Font = Enum.Font.Gotham
    t.TextSize = 17
    t.TextColor3 = Color3.fromRGB(80,255,235)
    t.Position = UDim2.new(0, 14, 0, 5)
    t.Size = UDim2.new(1, -70, 1, -10)
    t.BackgroundTransparency = 1
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.ZIndex = 15
    local s = Instance.new("ImageButton", b)
    s.Name = "Switch"
    s.Size = UDim2.new(0, 46, 0, 22)
    s.Position = UDim2.new(1, -54, 0.5, -11)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6031068438"
    s.ImageColor3 = getVal() and Color3.fromRGB(100,255,150) or Color3.fromRGB(65,65,75)
    s.ZIndex = 16
    local c = Instance.new("Frame", s)
    c.Size = UDim2.new(0, 18, 0, 18)
    c.Position = UDim2.new(0, getVal() and 24 or 4, 0, 2)
    c.BackgroundColor3 = getVal() and Color3.fromRGB(90,255,170) or Color3.fromRGB(220,220,220)
    c.BorderSizePixel = 0
    c.ZIndex = 17
    c.BackgroundTransparency = 0
    c.Name = "Circle"
    c.AnchorPoint = Vector2.new(0,0)
    c.Parent = s
    s.MouseButton1Click:Connect(function()
        setVal(not getVal())
        s.ImageColor3 = getVal() and Color3.fromRGB(100,255,150) or Color3.fromRGB(65,65,75)
        c.Position = UDim2.new(0, getVal() and 24 or 4, 0, 2)
        c.BackgroundColor3 = getVal() and Color3.fromRGB(90,255,170) or Color3.fromRGB(220,220,220)
    end)
    return b
end

makeSwitch(
    TrainPanel, 34, "Train Speed",
    function() return getgenv().XproD_TrainSpeed end,
    function(v) getgenv().XproD_TrainSpeed = v end
)
makeSwitch(
    TrainPanel, 84, "Train Agility",
    function() return getgenv().XproD_TrainAgility end,
    function(v) getgenv().XproD_TrainAgility = v end
)

local CreditPanel = Instance.new("Frame", MainFrame)
CreditPanel.Name = "CreditPanel"
CreditPanel.Size = TrainPanel.Size
CreditPanel.Position = TrainPanel.Position
CreditPanel.BackgroundTransparency = 1
CreditPanel.ZIndex = 12
local cT = Instance.new("TextLabel", CreditPanel)
cT.Text = "by Smith"
cT.Font = Enum.Font.GothamBold
cT.TextSize = 22
cT.TextColor3 = Color3.fromRGB(190, 120, 255)
cT.Position = UDim2.new(0, 0, 0, 45)
cT.Size = UDim2.new(1, 0, 0, 60)
cT.BackgroundTransparency = 1
cT.TextYAlignment = Enum.TextYAlignment.Top
cT.TextXAlignment = Enum.TextXAlignment.Center
cT.ZIndex = 17
CreditPanel.Visible = false

-- Cambiar panel
TrainingBtn.MouseButton1Click:Connect(function()
    TrainPanel.Visible = true
    CreditPanel.Visible = false
    TrainingBtn.BackgroundTransparency = 0.07
    TrainingBtn.TextColor3 = Color3.fromRGB(90,255,255)
    CreditBtn.BackgroundTransparency = 1
    CreditBtn.TextColor3 = Color3.fromRGB(170,170,170)
end)
CreditBtn.MouseButton1Click:Connect(function()
    TrainPanel.Visible = false
    CreditPanel.Visible = true
    TrainingBtn.BackgroundTransparency = 1
    TrainingBtn.TextColor3 = Color3.fromRGB(170,170,170)
    CreditBtn.BackgroundTransparency = 0.07
    CreditBtn.TextColor3 = Color3.fromRGB(90,255,255)
end)

-- FUNCIONALIDAD DE FARMEOS (Speed versión solicitada)
local speedFarmRunning = false
local function speedFarmLoop()
    local humanoid = nil
    local player = game.Players.LocalPlayer
    while getgenv().XproD_TrainSpeed do
        humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid:Move(Vector3.new(0,0,1), true) -- Correr recto infinitamente
        end
        -- Dispara el remote por si el server lo requiere
        pcall(function()
            game:GetService("ReplicatedStorage").RemoteEvents.SpeedTrainingEvent:FireServer(true)
        end)
        task.wait()
    end
    if humanoid then
        humanoid:Move(Vector3.new(0,0,0), true)
    end
end

-- FUNCIONALIDAD DE FARMEOS (Agility versión solicitada)
local agilityFarmRunning = false
local function agilityFarmLoop()
    if agilityFarmRunning then return end
    agilityFarmRunning = true
    while getgenv().XproD_TrainAgility do
        pcall(function()
            game:GetService("ReplicatedStorage").RemoteEvents.AgilityTrainingEvent:FireServer(true)
        end)
        task.wait()
    end
    agilityFarmRunning = false
end

if getgenv().XproD_TrainSpeed then spawn(speedFarmLoop) end
if getgenv().XproD_TrainAgility then spawn(agilityFarmLoop) end

local oldSpeed, oldAgility = false, false
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().XproD_TrainSpeed and not oldSpeed then
        oldSpeed = true
        spawn(speedFarmLoop)
    elseif not getgenv().XproD_TrainSpeed and oldSpeed then
        oldSpeed = false
    end
    if getgenv().XproD_TrainAgility and not oldAgility then
        oldAgility = true
        spawn(agilityFarmLoop)
    elseif not getgenv().XproD_TrainAgility and oldAgility then
        oldAgility = false
    end
end)
