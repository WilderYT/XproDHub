-- XproD Hub | GUI Moderna y Funcional v2.1
-- UI moderna y completamente funcional con switches operativos
-- Solo equipa la sword tras respawn/muerte si tienes activado autofarm

-- GLOBALS
getgenv().XproD_TrainSpeed = getgenv().XproD_TrainSpeed or false
getgenv().XproD_TrainAgility = getgenv().XproD_TrainAgility or false
getgenv().XproD_TrainSword = getgenv().XproD_TrainSword or false
getgenv().XproD_AutoFarmBandit = getgenv().XproD_AutoFarmBandit or false
getgenv().XproD_BringBandits = getgenv().XproD_BringBandits or false
getgenv().XproD_AntiAFK = getgenv().XproD_AntiAFK or false

pcall(function() game.CoreGui.XproD_Hub:Destroy() end)

local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Name = "XproD_Hub"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

-- Configuración de animaciones simples
local function simpleTween(obj, time, props)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

----------------------
-- ÍCONO MODERNO FUNCIONAL
----------------------
local IconFrame = Instance.new("Frame", gui)
IconFrame.Name = "IconFrame"
IconFrame.Size = UDim2.new(0, 60, 0, 60)
IconFrame.Position = UDim2.new(0, 50, 0, 120)
IconFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
IconFrame.BorderSizePixel = 0
IconFrame.ZIndex = 50

-- Esquinas redondeadas
local IconCorner = Instance.new("UICorner", IconFrame)
IconCorner.CornerRadius = UDim.new(0, 15)

-- Gradiente
local IconGradient = Instance.new("UIGradient", IconFrame)
IconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
IconGradient.Rotation = 45

-- Stroke
local IconStroke = Instance.new("UIStroke", IconFrame)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.6

-- Botón invisible para clicks
local IconBtn = Instance.new("TextButton", IconFrame)
IconBtn.Size = UDim2.new(1, 0, 1, 0)
IconBtn.Position = UDim2.new(0, 0, 0, 0)
IconBtn.BackgroundTransparency = 1
IconBtn.Text = "X"
IconBtn.Font = Enum.Font.GothamBold
IconBtn.TextSize = 24
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.ZIndex = 51

-- Efectos hover simples
IconBtn.MouseEnter:Connect(function()
    simpleTween(IconFrame, 0.2, {Size = UDim2.new(0, 65, 0, 65)})
    simpleTween(IconStroke, 0.2, {Transparency = 0.3})
end)

IconBtn.MouseLeave:Connect(function()
    simpleTween(IconFrame, 0.2, {Size = UDim2.new(0, 60, 0, 60)})
    simpleTween(IconStroke, 0.2, {Transparency = 0.6})
end)

-- Sistema de arrastre funcional
local dragging = false
local dragStart = nil
local startPos = nil

IconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = IconFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        IconFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Mover el frame principal también
        if gui:FindFirstChild("MainFrame") and gui.MainFrame.Visible then
            gui.MainFrame.Position = UDim2.new(0, IconFrame.Position.X.Offset + 70, 0, IconFrame.Position.Y.Offset - 40)
        end
    end
end)

----------------------
-- FRAME PRINCIPAL MODERNO
----------------------
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0, 120, 0, 80)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Visible = false

-- Esquinas redondeadas
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 16)

-- Gradiente de fondo
local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 50))
}
MainGradient.Rotation = 135

-- Stroke moderno
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.4

-- Toggle funcional
local isOpen = false
IconBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Position = UDim2.new(0, IconFrame.Position.X.Offset + 70, 0, IconFrame.Position.Y.Offset - 40)
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        simpleTween(MainFrame, 0.4, {Size = UDim2.new(0, 520, 0, 420)})
    else
        simpleTween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0)})
        wait(0.3)
        MainFrame.Visible = false
    end
end)

----------------------
-- SIDEBAR
----------------------
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 130, 1, 0)
SideBar.Position = UDim2.new(0, 0, 0, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 11

local SideCorner = Instance.new("UICorner", SideBar)
SideCorner.CornerRadius = UDim.new(0, 16)

-- Header
local Header = Instance.new("Frame", SideBar)
Header.Size = UDim2.new(1, 0, 0, 70)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.ZIndex = 12

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 16)

-- Título
local Title = Instance.new("TextLabel", Header)
Title.Text = "XproD Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Size = UDim2.new(1, -20, 0, 25)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 13

local Subtitle = Instance.new("TextLabel", Header)
Subtitle.Text = "Modern Edition v2.1"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
Subtitle.Position = UDim2.new(0, 10, 0, 35)
Subtitle.Size = UDim2.new(1, -20, 0, 20)
Subtitle.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 13

----------------------
-- PANEL DE CONTENIDO
----------------------
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -140, 1, -10)
ContentArea.Position = UDim2.new(0, 135, 0, 5)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 12

-- Título del panel
local PanelTitle = Instance.new("TextLabel", ContentArea)
PanelTitle.Text = "⚡ Training Center"
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.TextSize = 20
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.Position = UDim2.new(0, 15, 0, 15)
PanelTitle.Size = UDim2.new(1, -30, 0, 30)
PanelTitle.BackgroundTransparency = 1
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 13

----------------------
-- SWITCHES FUNCIONALES MODERNOS
----------------------
local function createWorkingSwitch(parent, y, title, subtitle, icon, getVal, setVal)
    -- Container principal
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -30, 0, 70)
    container.Position = UDim2.new(0, 15, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BackgroundTransparency = 0.2
    container.BorderSizePixel = 0
    container.ZIndex = 14
    
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 12)
    
    -- Stroke sutil
    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = Color3.fromRGB(60, 60, 80)
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.5
    
    -- Ícono
    local iconLabel = Instance.new("TextLabel", container)
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 12, 0, 18)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 18
    iconLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    iconLabel.ZIndex = 15
    
    -- Título
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(1, -120, 0, 22)
    titleLabel.Position = UDim2.new(0, 52, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 15
    
    -- Subtítulo
    local subtitleLabel = Instance.new("TextLabel", container)
    subtitleLabel.Size = UDim2.new(1, -120, 0, 18)
    subtitleLabel.Position = UDim2.new(0, 52, 0, 34)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 11
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.ZIndex = 15
    
    -- Switch background
    local switchBg = Instance.new("Frame", container)
    switchBg.Size = UDim2.new(0, 50, 0, 25)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12)
    switchBg.BackgroundColor3 = getVal() and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 15
    
    local switchCorner = Instance.new("UICorner", switchBg)
    switchCorner.CornerRadius = UDim.new(0, 12)
    
    -- Switch button (círculo)
    local switchButton = Instance.new("Frame", switchBg)
    switchButton.Size = UDim2.new(0, 21, 0, 21)
    switchButton.Position = UDim2.new(0, getVal() and 27 or 2, 0, 2)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderSizePixel = 0
    switchButton.ZIndex = 16
    
    local buttonCorner = Instance.new("UICorner", switchButton)
    buttonCorner.CornerRadius = UDim.new(0, 10)
    
    -- Botón invisible para capturar clicks
    local clickButton = Instance.new("TextButton", container)
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.Position = UDim2.new(0, 0, 0, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.ZIndex = 17
    
    -- Funcionalidad del switch
    clickButton.MouseButton1Click:Connect(function()
        local newVal = not getVal()
        setVal(newVal)
        
        -- Animación del switch
        local newColor = newVal and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
        local newPos = newVal and UDim2.new(0, 27, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        simpleTween(switchBg, 0.2, {BackgroundColor3 = newColor})
        simpleTween(switchButton, 0.2, {Position = newPos})
        
        -- Feedback visual
        simpleTween(container, 0.1, {BackgroundTransparency = 0.1})
        wait(0.1)
        simpleTween(container, 0.1, {BackgroundTransparency = 0.2})
    end)
    
    -- Hover effects
    clickButton.MouseEnter:Connect(function()
        simpleTween(container, 0.2, {BackgroundTransparency = 0.1})
        simpleTween(containerStroke, 0.2, {Transparency = 0.3})
    end)
    
    clickButton.MouseLeave:Connect(function()
        simpleTween(container, 0.2, {BackgroundTransparency = 0.2})
        simpleTween(containerStroke, 0.2, {Transparency = 0.5})
    end)
    
    return container
end

-- Crear los switches funcionales
createWorkingSwitch(
    ContentArea, 60, "Speed Training", "Automatically train your character's speed", "🏃",
    function() return getgenv().XproD_TrainSpeed end,
    function(v) getgenv().XproD_TrainSpeed = v end
)

createWorkingSwitch(
    ContentArea, 140, "Agility Training", "Enhance your character's agility", "🤸",
    function() return getgenv().XproD_TrainAgility end,
    function(v) getgenv().XproD_TrainAgility = v end
)

createWorkingSwitch(
    ContentArea, 220, "Sword Training", "Train your swordsmanship skills", "⚔️",
    function() return getgenv().XproD_TrainSword end,
    function(v) getgenv().XproD_TrainSword = v end
)

createWorkingSwitch(
    ContentArea, 300, "Auto Farm Bandits", "Automatically farm bandits", "💀",
    function() return getgenv().XproD_AutoFarmBandit end,
    function(v) getgenv().XproD_AutoFarmBandit = v end
)

createWorkingSwitch(
    ContentArea, 380, "Bring Bandits", "Gather all bandits to you", "🧲",
    function() return getgenv().XproD_BringBandits end,
    function(v) getgenv().XproD_BringBandits = v end
)

-- Info section
local InfoBox = Instance.new("Frame", ContentArea)
InfoBox.Size = UDim2.new(1, -30, 0, 60)
InfoBox.Position = UDim2.new(0, 15, 1, -70)
InfoBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
InfoBox.BackgroundTransparency = 0.3
InfoBox.BorderSizePixel = 0
InfoBox.ZIndex = 14

local InfoCorner = Instance.new("UICorner", InfoBox)
InfoCorner.CornerRadius = UDim.new(0, 10)

local InfoText = Instance.new("TextLabel", InfoBox)
InfoText.Text = "⚔️ El farmeo usará la espada equipada en tu HUD. Para cambiarla, hazlo manualmente una vez."
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 12
InfoText.TextColor3 = Color3.fromRGB(200, 200, 255)
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 10, 0, 5)
InfoText.Size = UDim2.new(1, -20, 1, -10)
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Center
InfoText.ZIndex = 15

----------------------
-- FUNCIONALIDAD COMPLETA (mantenida del original)
----------------------

-- Sistema de equipar sword solo tras respawn
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

local function onCharacter(char)
    spawn(function()
        wait(1.2)
        if getgenv().XproD_AutoFarmBandit or getgenv().XproD_TrainSword then
            clickSwordButton()
        end
    end)
end

plr.CharacterAdded:Connect(onCharacter)
if plr.Character then
    onCharacter(plr.Character)
end

-- Funciones de entrenamiento
local Remote = game:GetService("ReplicatedStorage").RemoteEvents

local lastFrameTime = tick()
local function getOptimalDelay(baseDelay)
    local currentTime = tick()
    local deltaTime = currentTime - lastFrameTime
    lastFrameTime = currentTime
    
    if deltaTime > 0.1 then
        return baseDelay + 0.1
    end
    return baseDelay
end

local function trainSword()
    pcall(function()
        Remote.SwordTrainingEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
    end)
end

local function trainSpeed()
    pcall(function()
        Remote.SpeedTrainingEvent:FireServer()
        Remote.SpeedPopUpEvent:FireServer()
    end)
end

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

-- Loops de entrenamiento
local function speedFarmLoop()
    while getgenv().XproD_TrainSpeed do
        trainSpeed()
        local delay = getOptimalDelay(0.35)
        wait(delay + math.random(0, 0.1))
    end
end

local function agilityFarmLoop()
    while getgenv().XproD_TrainAgility do
        trainAgility()
        local delay = getOptimalDelay(0.35)
        wait(delay + math.random(0, 0.1))
    end
end

local function swordFarmLoop()
    while getgenv().XproD_TrainSword do
        trainSword()
        local delay = getOptimalDelay(0.3)
        wait(delay + math.random(0, 0.05))
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

local function antiAFKLoop()
    local lastMoveTime = tick()
    while getgenv().XproD_AntiAFK do
        local currentTime = tick()
        if currentTime - lastMoveTime > 60 then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1,1) * 0.1, 0, math.random(-1,1) * 0.1)
                lastMoveTime = currentTime
            end
        end
        wait(30)
    end
end

-- Sistema de loops
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

-- Notificaciones
spawn(function()
    wait(2)
    local function notify(text)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XproD Hub v2.1";
            Text = text;
            Duration = 3;
        })
    end
    notify("✅ Hub cargado correctamente!")
    notify("🎨 UI moderna funcionando!")
end)

print("🚀 XproD Hub v2.1 - Modern UI (Fixed) loaded!")
print("✅ All switches functional")
print("🎨 Modern design with stable code")
print("⚡ Optimized performance")
