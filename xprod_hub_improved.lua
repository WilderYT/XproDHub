-- XproD Hub | GUI profesional: Solo equipa la sword tras respawn/muerte si tienes activado autofarm,
-- nunca alterna ni spamea. Solución definitiva para HUD toggle.

-- GLOBALS
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

----------------------
-- ÍCONO VISUAL
----------------------
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

----------------------
-- MAIN HUB FRAME
----------------------
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 410)
MainFrame.Position = UDim2.new(0, IconBtn.Position.X.Offset + 60, 0, IconBtn.Position.Y.Offset - 50)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 22, 32)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Visible = true

-- Deco y border
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

-- Frame Move
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
IconBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

----------------------
-- MENU LATERAL
----------------------
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

----------------------
-- TRAINING PANEL
----------------------
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

----------------------
-- AVISO SWORD: El farm usará la sword que tengas actualmente equipada en tu hotbar/hud
----------------------
local SwordInfo = Instance.new("TextLabel", TrainPanel)
SwordInfo.Text = "⚔️ El farmeo usará la espada equipada en tu HUD (botón inferior central).\n"..
"Si quieres cambiarla, hazlo manualmente una vez en el menú Swords."
SwordInfo.Font = Enum.Font.Gotham
SwordInfo.TextSize = 15
SwordInfo.TextColor3 = Color3.fromRGB(185, 225, 255)
SwordInfo.BackgroundTransparency = 1
SwordInfo.Position = UDim2.new(0, 18, 0, 285)
SwordInfo.Size = UDim2.new(1, -36, 0, 40)
SwordInfo.TextWrapped = true
SwordInfo.TextYAlignment = Enum.TextYAlignment.Top
SwordInfo.ZIndex = 14

----------------------
-- SWITCHES
----------------------
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

----------------------
-- EQUIP SWORD SOLO TRAS RESPAWN Y SOLO SI AUTOFARM/TRAINSWORD ESTÁN ACTIVOS
----------------------
local plr = game:GetService("Players").LocalPlayer

local function clickSwordButton()
    local mainGui = plr.PlayerGui:FindFirstChild("Main")
    if mainGui and mainGui:FindFirstChild("Hotkeys") and mainGui.Hotkeys:FindFirstChild("Button_4") then
        local btn = mainGui.Hotkeys.Button_4
        if typeof(firesignal) == "function" then
            firesignal(btn.MouseButton1Click)
        else
            local vim = game:GetService("VirtualInputManager")
            local absPos = btn.AbsolutePosition
            local absSize = btn.AbsoluteSize
            local x = absPos.X + absSize.X/2
            local y = absPos.Y + absSize.Y/2
            vim:SendMouseButtonEvent(x, y, 0, true, btn, 1)
            vim:SendMouseButtonEvent(x, y, 0, false, btn, 1)
        end
    end
end

-- Solo equipa la sword tras respawn/muerte y solo si autofarm o trainsword están activos
local function onCharacter(char)
    spawn(function()
        wait(1.2) -- Espera a que cargue el personaje
        if getgenv().XproD_AutoFarmBandit or getgenv().XproD_TrainSword then
            clickSwordButton()
        end
    end)
end

plr.CharacterAdded:Connect(onCharacter)
if plr.Character then
    onCharacter(plr.Character)
end

----------------------
-- FUNCIONES DE TRAIN/FARM MEJORADAS
----------------------
local Remote = game:GetService("ReplicatedStorage").RemoteEvents
local RunService = game:GetService("RunService")

-- Sistema de detección de lag para ajustar velocidad automáticamente
local lastFrameTime = tick()
local function getOptimalDelay(baseDelay)
    local currentTime = tick()
    local deltaTime = currentTime - lastFrameTime
    lastFrameTime = currentTime
    
    -- Si hay lag (frame time > 0.1s), aumenta el delay
    if deltaTime > 0.1 then
        return baseDelay + 0.1
    end
    return baseDelay
end

-- Función mejorada para Train Sword con sistema anti-detección
local function trainSword()
    pcall(function()
        Remote.SwordTrainingEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
    end)
end

-- Función mejorada para Speed Training
local function trainSpeed()
    pcall(function()
        Remote.SpeedTrainingEvent:FireServer()
        Remote.SpeedPopUpEvent:FireServer()
    end)
end

-- Función mejorada para Agility Training
local function trainAgility()
    pcall(function()
        Remote.AgilityTrainingEvent:FireServer()
        Remote.AgilityPopUpEvent:FireServer()
    end)
end

local function attackWithSword()
    pcall(function()
        Remote.SwordAttackEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
    end)
end

-- LOOPS MEJORADOS CON SISTEMA ANTI-DETECCIÓN
local function speedFarmLoop()
    while getgenv().XproD_TrainSpeed do
        trainSpeed()
        local delay = getOptimalDelay(0.35) -- Delay base de 0.35s, se ajusta según lag
        wait(delay + math.random(0, 0.1)) -- Añade variación aleatoria
    end
end

local function agilityFarmLoop()
    while getgenv().XproD_TrainAgility do
        trainAgility()
        local delay = getOptimalDelay(0.35) -- Delay base de 0.35s, se ajusta según lag
        wait(delay + math.random(0, 0.1)) -- Añade variación aleatoria
    end
end

local function swordFarmLoop()
    while getgenv().XproD_TrainSword do
        trainSword()
        local delay = getOptimalDelay(0.3) -- Delay base de 0.3s para sword training
        wait(delay + math.random(0, 0.05)) -- Variación más pequeña para sword
    end
end

local function tpToBandit(bandit)
    if bandit and bandit:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = bandit.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

local function getAllBandits()
    local npcs = workspace:FindFirstChild("NPCs") and workspace.NPCs:GetChildren() or {}
    local bandits = {}
    for _,npc in pairs(npcs) do
        if npc.Name == "Bandit " and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            table.insert(bandits, npc)
        end
    end
    return bandits
end

local function bringAllBanditsToMe()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _,bandit in pairs(getAllBandits()) do
        if bandit:FindFirstChild("HumanoidRootPart") then
            bandit.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3),0,math.random(-3,3))
        end
    end
end

local function autoFarmBanditLoop()
    while getgenv().XproD_AutoFarmBandit do
        if getgenv().XproD_BringBandits then
            bringAllBanditsToMe()
            wait(1)
        end
        local bandits = getAllBandits()
        for _,bandit in ipairs(bandits) do
            if not getgenv().XproD_AutoFarmBandit then break end
            tpToBandit(bandit)
            while bandit and bandit.Parent and bandit:FindFirstChild("Humanoid") and bandit.Humanoid.Health > 0 and getgenv().XproD_AutoFarmBandit do
                attackWithSword()
                local delay = getOptimalDelay(0.25)
                wait(delay + math.random(0, 0.05))
            end
            wait(0.2)
        end
        wait(0.5)
    end
end

----------------------
-- SISTEMA ANTI-AFK MEJORADO
----------------------
local function antiAFKLoop()
    local lastMoveTime = tick()
    while getgenv().XproD_AntiAFK do
        local currentTime = tick()
        if currentTime - lastMoveTime > 60 then -- Cada 60 segundos
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Movimiento muy sutil para evitar detección
                hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1,1) * 0.1, 0, math.random(-1,1) * 0.1)
                lastMoveTime = currentTime
            end
        end
        wait(30) -- Check cada 30 segundos
    end
end

----------------------
-- LANZADORES MEJORADOS CON CONTROL DE CONCURRENCIA
----------------------
local activeLoops = {}

local function startLoop(name, func)
    if not activeLoops[name] then
        activeLoops[name] = true
        spawn(function()
            func()
            activeLoops[name] = nil
        end)
    end
end

spawn(function()
    while true do
        if getgenv().XproD_TrainSpeed and not activeLoops["speed"] then
            startLoop("speed", speedFarmLoop)
        end
        if getgenv().XproD_TrainAgility and not activeLoops["agility"] then
            startLoop("agility", agilityFarmLoop)
        end
        if getgenv().XproD_TrainSword and not activeLoops["sword"] then
            startLoop("sword", swordFarmLoop)
        end
        if getgenv().XproD_AutoFarmBandit and not activeLoops["bandit"] then
            startLoop("bandit", autoFarmBanditLoop)
        end
        if getgenv().XproD_AntiAFK and not activeLoops["antiafk"] then
            startLoop("antiafk", antiAFKLoop)
        end
        wait(1)
    end
end)

----------------------
-- NOTIFICACIONES DE ESTADO
----------------------
spawn(function()
    wait(2)
    local function notify(text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XproD Hub";
            Text = text;
            Duration = 3;
        })
    end
    notify("✅ XproD Hub cargado correctamente!")
    notify("⚔️ Train Sword optimizado para clicks soportables")
end)

print("🚀 XproD Hub - Sistema mejorado de entrenamiento cargado")
print("⚔️ Train Sword: Delays optimizados para evitar detección")
print("🎯 Sistema anti-lag: Se ajusta automáticamente según rendimiento")
print("🔄 Anti-AFK: Movimientos sutiles cada 60 segundos")