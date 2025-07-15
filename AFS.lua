-- XproD Hub | GUI profesional con icono visual, Training, Credits y Settings (Anti AFK) by Smith

-- GLOBALS EXTENDIDAS
getgenv().XproD_TrainSpeed = getgenv().XproD_TrainSpeed or false
getgenv().XproD_TrainAgility = getgenv().XproD_TrainAgility or false
getgenv().XproD_TrainSword = getgenv().XproD_TrainSword or false
getgenv().XproD_AutoFarmBandit = getgenv().XproD_AutoFarmBandit or false
getgenv().XproD_BringBandits = getgenv().XproD_BringBandits or false
getgenv().XproD_AntiAFK = getgenv().XproD_AntiAFK or false

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
IconBtn.Image = "rbxassetid://3926307971"
IconBtn.ImageRectOffset = Vector2.new(204, 4)
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
MainFrame.Size = UDim2.new(0, 540, 0, 360)
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

-- MENU LATERAL
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

-- MENU BUTTONS (Training, Credits, Settings)
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
local CreditBtn = menuBtn("Credits", 102, false)
local SettingsBtn = menuBtn("Settings", 142, false)

-- TRAINING PANEL
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

local function makeSwitch(parent, y, label, getVal, setVal, black)
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
    if black then
        s.ImageColor3 = getVal() and Color3.fromRGB(20,20,20) or Color3.fromRGB(65,65,75)
    else
        s.ImageColor3 = getVal() and Color3.fromRGB(100,255,150) or Color3.fromRGB(65,65,75)
    end
    s.ZIndex = 16
    local c = Instance.new("Frame", s)
    c.Size = UDim2.new(0, 18, 0, 18)
    c.Position = UDim2.new(0, getVal() and 24 or 4, 0, 2)
    if black then
        c.BackgroundColor3 = getVal() and Color3.fromRGB(10,10,10) or Color3.fromRGB(220,220,220)
    else
        c.BackgroundColor3 = getVal() and Color3.fromRGB(90,255,170) or Color3.fromRGB(220,220,220)
    end
    c.BorderSizePixel = 0
    c.ZIndex = 17
    c.BackgroundTransparency = 0
    c.Name = "Circle"
    c.AnchorPoint = Vector2.new(0,0)
    c.Parent = s
    s.MouseButton1Click:Connect(function()
        setVal(not getVal())
        if black then
            s.ImageColor3 = getVal() and Color3.fromRGB(20,20,20) or Color3.fromRGB(65,65,75)
            c.BackgroundColor3 = getVal() and Color3.fromRGB(10,10,10) or Color3.fromRGB(220,220,220)
        else
            s.ImageColor3 = getVal() and Color3.fromRGB(100,255,150) or Color3.fromRGB(65,65,75)
            c.BackgroundColor3 = getVal() and Color3.fromRGB(90,255,170) or Color3.fromRGB(220,220,220)
        end
        if label == "Anti AFK" then
            AntiAFKStatus.Text = getVal() and "Status: Active" or "Status: Inactive"
        end
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
makeSwitch(
    TrainPanel, 134, "Train Sword",
    function() return getgenv().XproD_TrainSword end,
    function(v) getgenv().XproD_TrainSword = v end
)
makeSwitch(
    TrainPanel, 184, "Auto Farm Bandit",
    function() return getgenv().XproD_AutoFarmBandit end,
    function(v) getgenv().XproD_AutoFarmBandit = v end
)
makeSwitch(
    TrainPanel, 234, "Bring Bandits (Gather All Bandits)",
    function() return getgenv().XproD_BringBandits end,
    function(v) getgenv().XproD_BringBandits = v end
)

-- =============== FUNCIONES DE SWORD Y FARM AUTOMÁTICO ===============

-- Detectar si la espada está equipada usando workspace.Xprodnow.EquippedSword
local function isSwordEquipped()
    return workspace:FindFirstChild("Xprodnow") and workspace.Xprodnow:FindFirstChild("EquippedSword")
end

-- Equipar la espada usando RemoteEvents si es necesario (según tu juego):
local function equipSwordProperly()
    pcall(function()
        game:GetService("ReplicatedStorage").RemoteEvents.EquipSwordEvent:FireServer()
        game:GetService("ReplicatedStorage").RemoteEvents.RequestEquipSword:FireServer()
    end)
    -- Ya no es necesario buscar la Tool en Backpack ni moverla al Character
end

-- Farm automático de Sword (entrenar estadísticas automáticamente)
local swordFarmRunning = false
local function swordFarmLoop()
    if swordFarmRunning then return end
    swordFarmRunning = true
    while getgenv().XproD_TrainSword do
        equipSwordProperly()
        -- Si la espada está equipada, simulamos un "click" para entrenar
        if isSwordEquipped() then
            pcall(function()
                -- Simular ataque (sube stats y también puede matar bandits si están cerca)
                game:GetService("ReplicatedStorage").RemoteEvents.SwordPopUpEvent:FireServer()
            end)
        end
        task.wait(0.25)
    end
    swordFarmRunning = false
end

-- FUNCIONES PARA AUTO FARM BANDIT AVANZADO
local function tpToBandit(bandit)
    if bandit and bandit:FindFirstChild("HumanoidRootPart") then
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = bandit.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

local function getAllBandits()
    local npcs = workspace.NPCs:GetChildren()
    local bandits = {}
    for _,npc in pairs(npcs) do
        if npc.Name == "Bandit " and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            table.insert(bandits, npc)
        end
    end
    return bandits
end

local function bringAllBanditsToMe()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _,bandit in pairs(getAllBandits()) do
        if bandit:FindFirstChild("HumanoidRootPart") then
            bandit.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3),0,math.random(-3,3))
        end
    end
end

local function attackBandit(bandit)
    equipSwordProperly()
    -- Si la espada está equipada, simula el click de ataque igual que en el farm de sword
    if isSwordEquipped() then
        pcall(function()
            game:GetService("ReplicatedStorage").RemoteEvents.SwordPopUpEvent:FireServer()
        end)
    end
end

local banditFarmRunning = false
local function autoFarmBanditLoop()
    if banditFarmRunning then return end
    banditFarmRunning = true
    while getgenv().XproD_AutoFarmBandit do
        if getgenv().XproD_BringBandits then
            bringAllBanditsToMe()
            task.wait(1)
        end
        local bandits = getAllBandits()
        for _,bandit in ipairs(bandits) do
            if not getgenv().XproD_AutoFarmBandit then break end
            tpToBandit(bandit)
            while bandit and bandit.Parent and bandit:FindFirstChild("Humanoid") and bandit.Humanoid.Health > 0 and getgenv().XproD_AutoFarmBandit do
                attackBandit(bandit)
                task.wait(0.25)
            end
            task.wait(0.2)
        end
        task.wait(0.5)
    end
    banditFarmRunning = false
end

-- FARMEOS (Speed y Agility) -- igual que antes, si tienes funciones para ellos, agrégalas aquí

-- Lanzadores iniciales
if getgenv().XproD_TrainSpeed then spawn(speedFarmLoop) end
if getgenv().XproD_TrainAgility then spawn(agilityFarmLoop) end
if getgenv().XproD_TrainSword then spawn(swordFarmLoop) end
if getgenv().XproD_AutoFarmBandit then spawn(autoFarmBanditLoop) end

local oldSpeed, oldAgility, oldSword, oldBandit = false, false, false, false
local oldBringBandits = false
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
    if getgenv().XproD_TrainSword and not oldSword then
        oldSword = true
        spawn(swordFarmLoop)
    elseif not getgenv().XproD_TrainSword and oldSword then
        oldSword = false
    end
    if getgenv().XproD_AutoFarmBandit and not oldBandit then
        oldBandit = true
        spawn(autoFarmBanditLoop)
    elseif not getgenv().XproD_AutoFarmBandit and oldBandit then
        oldBandit = false
    end
end)

-- ANTI AFK LOGIC -- igual que antes
local antiAfkConnection
local function enableAntiAFK()
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    local vu = game:service'VirtualUser'
    antiAfkConnection = game:service'Players'.LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        AntiAFKStatus.Text = "Roblox tried to kick u but i kicked him instead"
        wait(2)
        AntiAFKStatus.Text = "Status: Active"
    end)
end
local function disableAntiAFK()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

-- On/Off logic for Anti AFK (live update)
spawn(function()
    while true do
        if getgenv().XproD_AntiAFK and not antiAfkConnection then
            enableAntiAFK()
            AntiAFKStatus.Text = "Status: Active"
        elseif not getgenv().XproD_AntiAFK and antiAfkConnection then
            disableAntiAFK()
            AntiAFKStatus.Text = "Status: Inactive"
        end
        wait(0.5)
    end
end)

-- PANEL DE CRÉDITOS MEJORADO
-- ... (igual que tu script actual)

-- SETTINGS Y SWITCHING LOGIC
-- ... (igual que tu script actual)
