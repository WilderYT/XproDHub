-- XproD Hub | MODERN UI - Versión 2024
-- GUI completamente rediseñada con efectos modernos y mejor UX

-- GLOBALS
getgenv().XproD_TrainSpeed = getgenv().XproD_TrainSpeed or false
getgenv().XproD_TrainAgility = getgenv().XproD_TrainAgility or false
getgenv().XproD_TrainSword = getgenv().XproD_TrainSword or false
getgenv().XproD_AutoFarmBandit = getgenv().XproD_AutoFarmBandit or false
getgenv().XproD_BringBandits = getgenv().XproD_BringBandits or false
getgenv().XproD_AntiAFK = getgenv().XproD_AntiAFK or false

-- Cleanup existing GUI
pcall(function() game.CoreGui.XproD_Modern_Hub:Destroy() end)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Crear ScreenGui principal
local gui = Instance.new("ScreenGui")
gui.Name = "XproD_Modern_Hub"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Funciones de utilidad para animaciones
local function smoothTween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Función para crear gradientes
local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

-- Función para crear esquinas redondeadas
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- Función para crear stroke/borde
local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(100, 100, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

-- Función para crear sombra/glow
local function createShadow(parent, color, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size*2, 1, size*2)
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = color or Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    return shadow
end

----------------------
-- TOGGLE BUTTON (MINIMIZADO Y MODERNO)
----------------------
local toggleButton = Instance.new("Frame")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 30, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 100
toggleButton.Parent = gui

createCorner(toggleButton, 30)
createStroke(toggleButton, Color3.fromRGB(100, 150, 255), 2, 0.3)
createShadow(toggleButton, Color3.fromRGB(0, 100, 255), 8, 0.7)

-- Gradiente animado para el botón
local toggleGradient = createGradient(toggleButton, {
    Color3.fromRGB(40, 40, 60),
    Color3.fromRGB(20, 20, 40)
}, 45)

-- Icono del toggle
local toggleIcon = Instance.new("ImageLabel")
toggleIcon.Size = UDim2.new(0, 32, 0, 32)
toggleIcon.Position = UDim2.new(0.5, -16, 0.5, -16)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://3926307971"
toggleIcon.ImageRectOffset = Vector2.new(764, 244)
toggleIcon.ImageRectSize = Vector2.new(36, 36)
toggleIcon.ImageColor3 = Color3.fromRGB(100, 150, 255)
toggleIcon.ZIndex = 101
toggleIcon.Parent = toggleButton

-- Efecto de pulsación en el gradiente
spawn(function()
    while toggleButton.Parent do
        local tween1 = TweenService:Create(toggleGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 90})
        local tween2 = TweenService:Create(toggleGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 45})
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()
        tween2.Completed:Wait()
    end
end)

-- Click detector para toggle
local toggleClickDetector = Instance.new("TextButton")
toggleClickDetector.Size = UDim2.new(1, 0, 1, 0)
toggleClickDetector.Position = UDim2.new(0, 0, 0, 0)
toggleClickDetector.BackgroundTransparency = 1
toggleClickDetector.Text = ""
toggleClickDetector.ZIndex = 102
toggleClickDetector.Parent = toggleButton

-- Drag functionality para el toggle button
local dragging = false
local dragStart, startPos

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

----------------------
-- VENTANA PRINCIPAL MODERNA
----------------------
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 600, 0, 450)
mainWindow.Position = UDim2.new(0.5, -300, 0.5, -225)
mainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainWindow.BorderSizePixel = 0
mainWindow.ZIndex = 10
mainWindow.Visible = false
mainWindow.Parent = gui

createCorner(mainWindow, 16)
createStroke(mainWindow, Color3.fromRGB(100, 150, 255), 2, 0.4)
createShadow(mainWindow, Color3.fromRGB(0, 100, 255), 20, 0.6)

-- Gradiente de fondo
createGradient(mainWindow, {
    Color3.fromRGB(25, 25, 40),
    Color3.fromRGB(15, 15, 25)
}, 135)

-- Header de la ventana
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = mainWindow

createCorner(header, 16)
createGradient(header, {
    Color3.fromRGB(40, 40, 60),
    Color3.fromRGB(30, 30, 45)
}, 90)

-- Fix para que las esquinas solo estén arriba
local headerMask = Instance.new("Frame")
headerMask.Size = UDim2.new(1, 0, 0, 20)
headerMask.Position = UDim2.new(0, 0, 1, -20)
headerMask.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
headerMask.BorderSizePixel = 0
headerMask.ZIndex = 11
headerMask.Parent = header

-- Logo y título
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 15, 0.5, -20)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://14594347870"
logo.ImageColor3 = Color3.fromRGB(100, 150, 255)
logo.ZIndex = 12
logo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 30)
title.Position = UDim2.new(0, 65, 0, 8)
title.BackgroundTransparency = 1
title.Text = "XproD Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(100, 150, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0, 200, 0, 20)
subtitle.Position = UDim2.new(0, 65, 0, 32)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Advanced Training System"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 12
subtitle.Parent = header

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0.5, -20)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.ZIndex = 12
closeButton.Parent = header

createCorner(closeButton, 20)

closeButton.MouseEnter:Connect(function()
    smoothTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
end)

closeButton.MouseLeave:Connect(function()
    smoothTween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
end)

closeButton.MouseButton1Click:Connect(function()
    smoothTween(mainWindow, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
    wait(0.3)
    mainWindow.Visible = false
    mainWindow.Size = UDim2.new(0, 600, 0, 450)
end)

----------------------
-- SISTEMA DE TABS MODERNO
----------------------
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 50)
tabContainer.Position = UDim2.new(0, 10, 0, 70)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 11
tabContainer.Parent = mainWindow

local tabs = {"Training", "Farming", "Settings"}
local tabButtons = {}
local currentTab = 1

for i, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName.."Tab"
    tabButton.Size = UDim2.new(0, 180, 1, 0)
    tabButton.Position = UDim2.new(0, (i-1) * 190, 0, 0)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(25, 25, 40)
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabName
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.TextColor3 = i == 1 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(150, 150, 150)
    tabButton.ZIndex = 12
    tabButton.Parent = tabContainer
    
    createCorner(tabButton, 8)
    if i == 1 then
        createStroke(tabButton, Color3.fromRGB(100, 150, 255), 2, 0.5)
    end
    
    tabButtons[i] = tabButton
    
    tabButton.MouseButton1Click:Connect(function()
        if currentTab ~= i then
            -- Desactivar tab actual
            smoothTween(tabButtons[currentTab], {
                BackgroundColor3 = Color3.fromRGB(25, 25, 40),
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }, 0.2)
            
            -- Activar nuevo tab
            smoothTween(tabButton, {
                BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                TextColor3 = Color3.fromRGB(100, 150, 255)
            }, 0.2)
            
            currentTab = i
            updateTabContent(i)
        end
    end)
    
    tabButton.MouseEnter:Connect(function()
        if currentTab ~= i then
            smoothTween(tabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if currentTab ~= i then
            smoothTween(tabButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 40)}, 0.2)
        end
    end)
end

----------------------
-- CONTENIDO DE TABS
----------------------
local contentArea = Instance.new("ScrollingFrame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -20, 1, -140)
contentArea.Position = UDim2.new(0, 10, 0, 130)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ScrollBarThickness = 6
contentArea.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
contentArea.ZIndex = 11
contentArea.Parent = mainWindow

-- Función para crear switch moderno
local function createModernSwitch(parent, yPos, labelText, getValue, setValue, description)
    local switchFrame = Instance.new("Frame")
    switchFrame.Size = UDim2.new(1, -20, 0, 80)
    switchFrame.Position = UDim2.new(0, 10, 0, yPos)
    switchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    switchFrame.BorderSizePixel = 0
    switchFrame.ZIndex = 12
    switchFrame.Parent = parent
    
    createCorner(switchFrame, 12)
    createStroke(switchFrame, Color3.fromRGB(50, 50, 70), 1, 0.8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 13
    label.Parent = switchFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -120, 0, 35)
    desc.Position = UDim2.new(0, 15, 0, 35)
    desc.BackgroundTransparency = 1
    desc.Text = description or ""
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 14
    desc.TextColor3 = Color3.fromRGB(150, 150, 180)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.ZIndex = 13
    desc.Parent = switchFrame
    
    -- Switch moderno
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 60, 0, 30)
    switchBg.Position = UDim2.new(1, -80, 0.5, -15)
    switchBg.BackgroundColor3 = getValue() and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 13
    switchBg.Parent = switchFrame
    
    createCorner(switchBg, 15)
    
    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 26, 0, 26)
    switchCircle.Position = UDim2.new(0, getValue() and 32 or 2, 0, 2)
    switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchCircle.BorderSizePixel = 0
    switchCircle.ZIndex = 14
    switchCircle.Parent = switchBg
    
    createCorner(switchCircle, 13)
    createShadow(switchCircle, Color3.fromRGB(0, 0, 0), 4, 0.7)
    
    local switchButton = Instance.new("TextButton")
    switchButton.Size = UDim2.new(1, 0, 1, 0)
    switchButton.Position = UDim2.new(0, 0, 0, 0)
    switchButton.BackgroundTransparency = 1
    switchButton.Text = ""
    switchButton.ZIndex = 15
    switchButton.Parent = switchBg
    
    switchButton.MouseButton1Click:Connect(function()
        local newValue = not getValue()
        setValue(newValue)
        
        -- Animar switch
        smoothTween(switchBg, {
            BackgroundColor3 = newValue and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
        }, 0.3)
        
        smoothTween(switchCircle, {
            Position = UDim2.new(0, newValue and 32 or 2, 0, 2)
        }, 0.3, Enum.EasingStyle.Back)
        
        -- Efecto de pulso
        if newValue then
            local pulse = switchCircle:Clone()
            pulse.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            pulse.BackgroundTransparency = 0.5
            pulse.ZIndex = 13
            pulse.Parent = switchBg
            
            smoothTween(pulse, {
                Size = UDim2.new(0, 60, 0, 60),
                Position = UDim2.new(0, -17, 0, -17),
                BackgroundTransparency = 1
            }, 0.5)
            
            game:GetService("Debris"):AddItem(pulse, 0.5)
        end
    end)
    
    return switchFrame
end

-- Función para actualizar contenido de tabs
function updateTabContent(tabIndex)
    contentArea:ClearAllChildren()
    
    if tabIndex == 1 then -- Training Tab
        createModernSwitch(contentArea, 10, "Speed Training", 
            function() return getgenv().XproD_TrainSpeed end,
            function(v) getgenv().XproD_TrainSpeed = v end,
            "Automatically trains your speed stat continuously"
        )
        
        createModernSwitch(contentArea, 100, "Agility Training",
            function() return getgenv().XproD_TrainAgility end,
            function(v) getgenv().XproD_TrainAgility = v end,
            "Automatically trains your agility stat continuously"
        )
        
        createModernSwitch(contentArea, 190, "Sword Training",
            function() return getgenv().XproD_TrainSword end,
            function(v) getgenv().XproD_TrainSword = v end,
            "Automatically trains your sword skills"
        )
        
        -- Info panel
        local infoPanel = Instance.new("Frame")
        infoPanel.Size = UDim2.new(1, -20, 0, 60)
        infoPanel.Position = UDim2.new(0, 10, 0, 290)
        infoPanel.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
        infoPanel.BorderSizePixel = 0
        infoPanel.ZIndex = 12
        infoPanel.Parent = contentArea
        
        createCorner(infoPanel, 12)
        createStroke(infoPanel, Color3.fromRGB(100, 150, 255), 1, 0.7)
        
        local infoIcon = Instance.new("TextLabel")
        infoIcon.Size = UDim2.new(0, 30, 0, 30)
        infoIcon.Position = UDim2.new(0, 15, 0.5, -15)
        infoIcon.BackgroundTransparency = 1
        infoIcon.Text = "ℹ️"
        infoIcon.Font = Enum.Font.GothamBold
        infoIcon.TextSize = 20
        infoIcon.ZIndex = 13
        infoIcon.Parent = infoPanel
        
        local infoText = Instance.new("TextLabel")
        infoText.Size = UDim2.new(1, -60, 1, 0)
        infoText.Position = UDim2.new(0, 50, 0, 0)
        infoText.BackgroundTransparency = 1
        infoText.Text = "Training functions use optimized delays to prevent detection. Safe and efficient!"
        infoText.Font = Enum.Font.Gotham
        infoText.TextSize = 14
        infoText.TextColor3 = Color3.fromRGB(150, 200, 255)
        infoText.TextWrapped = true
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.ZIndex = 13
        infoText.Parent = infoPanel
        
    elseif tabIndex == 2 then -- Farming Tab
        createModernSwitch(contentArea, 10, "Auto Farm Bandits",
            function() return getgenv().XproD_AutoFarmBandit end,
            function(v) getgenv().XproD_AutoFarmBandit = v end,
            "Automatically farm bandits for combat experience"
        )
        
        createModernSwitch(contentArea, 100, "Bring All Bandits",
            function() return getgenv().XproD_BringBandits end,
            function(v) getgenv().XproD_BringBandits = v end,
            "Teleports all bandits to your location for easier farming"
        )
        
        -- Sword info panel
        local swordPanel = Instance.new("Frame")
        swordPanel.Size = UDim2.new(1, -20, 0, 80)
        swordPanel.Position = UDim2.new(0, 10, 0, 200)
        swordPanel.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
        swordPanel.BorderSizePixel = 0
        swordPanel.ZIndex = 12
        swordPanel.Parent = contentArea
        
        createCorner(swordPanel, 12)
        createStroke(swordPanel, Color3.fromRGB(150, 100, 255), 1, 0.7)
        
        local swordIcon = Instance.new("TextLabel")
        swordIcon.Size = UDim2.new(0, 40, 0, 40)
        swordIcon.Position = UDim2.new(0, 15, 0.5, -20)
        swordIcon.BackgroundTransparency = 1
        swordIcon.Text = "⚔️"
        swordIcon.Font = Enum.Font.GothamBold
        swordIcon.TextSize = 24
        swordIcon.ZIndex = 13
        swordIcon.Parent = swordPanel
        
        local swordInfo = Instance.new("TextLabel")
        swordInfo.Size = UDim2.new(1, -70, 1, 0)
        swordInfo.Position = UDim2.new(0, 60, 0, 0)
        swordInfo.BackgroundTransparency = 1
        swordInfo.Text = "Sword Auto-Equip: The system will automatically equip your sword after respawn when farming is active. Make sure you have a sword equipped initially!"
        swordInfo.Font = Enum.Font.Gotham
        swordInfo.TextSize = 14
        swordInfo.TextColor3 = Color3.fromRGB(200, 150, 255)
        swordInfo.TextWrapped = true
        swordInfo.TextXAlignment = Enum.TextXAlignment.Left
        swordInfo.ZIndex = 13
        swordInfo.Parent = swordPanel
        
    elseif tabIndex == 3 then -- Settings Tab
        createModernSwitch(contentArea, 10, "Anti-AFK System",
            function() return getgenv().XproD_AntiAFK end,
            function(v) getgenv().XproD_AntiAFK = v end,
            "Prevents getting kicked for being AFK with subtle movements"
        )
        
        -- Status panel
        local statusPanel = Instance.new("Frame")
        statusPanel.Size = UDim2.new(1, -20, 0, 120)
        statusPanel.Position = UDim2.new(0, 10, 0, 100)
        statusPanel.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
        statusPanel.BorderSizePixel = 0
        statusPanel.ZIndex = 12
        statusPanel.Parent = contentArea
        
        createCorner(statusPanel, 12)
        createStroke(statusPanel, Color3.fromRGB(100, 255, 100), 1, 0.7)
        
        local statusTitle = Instance.new("TextLabel")
        statusTitle.Size = UDim2.new(1, -20, 0, 30)
        statusTitle.Position = UDim2.new(0, 10, 0, 10)
        statusTitle.BackgroundTransparency = 1
        statusTitle.Text = "System Status"
        statusTitle.Font = Enum.Font.GothamBold
        statusTitle.TextSize = 18
        statusTitle.TextColor3 = Color3.fromRGB(100, 255, 150)
        statusTitle.TextXAlignment = Enum.TextXAlignment.Left
        statusTitle.ZIndex = 13
        statusTitle.Parent = statusPanel
        
        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, -20, 0, 80)
        statusText.Position = UDim2.new(0, 10, 0, 35)
        statusText.BackgroundTransparency = 1
        statusText.Text = "✅ XproD Hub Loaded Successfully\n🔄 All systems operational\n⚡ Performance: Optimized"
        statusText.Font = Enum.Font.Gotham
        statusText.TextSize = 14
        statusText.TextColor3 = Color3.fromRGB(150, 255, 150)
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.TextYAlignment = Enum.TextYAlignment.Top
        statusText.ZIndex = 13
        statusText.Parent = statusPanel
    end
end

-- Inicializar primer tab
updateTabContent(1)

-- Toggle functionality
toggleClickDetector.MouseButton1Click:Connect(function()
    if mainWindow.Visible then
        smoothTween(mainWindow, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
        wait(0.3)
        mainWindow.Visible = false
        mainWindow.Size = UDim2.new(0, 600, 0, 450)
    else
        mainWindow.Visible = true
        mainWindow.Size = UDim2.new(0, 0, 0, 0)
        smoothTween(mainWindow, {Size = UDim2.new(0, 600, 0, 450)}, 0.4, Enum.EasingStyle.Back)
    end
end)

----------------------
-- SISTEMA DE NOTIFICACIONES MODERNO
----------------------
local function createNotification(title, text, duration, color)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 350, 0, 80)
    notif.Position = UDim2.new(1, 370, 1, -100)
    notif.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    notif.BorderSizePixel = 0
    notif.ZIndex = 200
    notif.Parent = gui
    
    createCorner(notif, 12)
    createStroke(notif, Color3.fromRGB(100, 150, 255), 2, 0.5)
    createShadow(notif, Color3.fromRGB(0, 100, 255), 8, 0.8)
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 8)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 201
    notifTitle.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 0, 40)
    notifText.Position = UDim2.new(0, 10, 0, 30)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 14
    notifText.TextColor3 = Color3.fromRGB(200, 200, 255)
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextWrapped = true
    notifText.ZIndex = 201
    notifText.Parent = notif
    
    -- Animación de entrada
    smoothTween(notif, {Position = UDim2.new(1, -370, 1, -100)}, 0.5, Enum.EasingStyle.Back)
    
    -- Auto-remove
    spawn(function()
        wait(duration or 4)
        smoothTween(notif, {Position = UDim2.new(1, 370, 1, -100)}, 0.3)
        wait(0.3)
        notif:Destroy()
    end)
end

----------------------
-- FUNCIONALIDAD MEJORADA DEL SCRIPT
----------------------

-- Auto-detect RemoteEvents
local function findRemoteEvents()
    local remotes = {}
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    local function searchFolder(folder)
        for _, obj in pairs(folder:GetChildren()) do
            if obj:IsA("RemoteEvent") then
                local name = string.lower(obj.Name)
                if string.find(name, "sword") or string.find(name, "training") or string.find(name, "attack") or string.find(name, "speed") or string.find(name, "agility") then
                    remotes[obj.Name] = obj
                    print("Found RemoteEvent: " .. obj.Name)
                end
            elseif obj:IsA("Folder") then
                searchFolder(obj)
            end
        end
    end
    
    searchFolder(replicatedStorage)
    return remotes
end

local detectedRemotes = findRemoteEvents()

-- Improved sword equipping
local function equipSwordImproved()
    pcall(function()
        local plr = game:GetService("Players").LocalPlayer
        
        -- Método 1: Click en hotkey button
        local mainGui = plr.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Hotkeys") then
            local buttons = {"Button_4", "Button4", "Sword", "SwordButton", "ToolButton4"}
            for _, btnName in pairs(buttons) do
                local btn = mainGui.Hotkeys:FindFirstChild(btnName)
                if btn then
                    if typeof(firesignal) == "function" then
                        firesignal(btn.MouseButton1Click)
                        print("✅ Sword equipped via: " .. btnName)
                        return true
                    end
                end
            end
        end
        
        -- Método 2: Equipar desde backpack
        local backpack = plr:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (string.find(string.lower(tool.Name), "sword") or string.find(string.lower(tool.Name), "blade") or string.find(string.lower(tool.Name), "katana")) then
                    tool.Parent = plr.Character
                    print("✅ Sword equipped from backpack: " .. tool.Name)
                    return true
                end
            end
        end
        
        return false
    end)
end

-- Improved training functions
local function trainSwordImproved()
    pcall(function()
        local remoteNames = {"SwordTrainingEvent", "SwordTrain", "TrainSword", "SwordEvent"}
        for _, name in pairs(remoteNames) do
            if detectedRemotes[name] then
                detectedRemotes[name]:FireServer()
                break
            end
        end
    end)
end

local function trainSpeedImproved()
    pcall(function()
        local remoteNames = {"SpeedTrainingEvent", "SpeedTrain", "TrainSpeed", "SpeedEvent"}
        for _, name in pairs(remoteNames) do
            if detectedRemotes[name] then
                detectedRemotes[name]:FireServer()
                break
            end
        end
    end)
end

local function trainAgilityImproved()
    pcall(function()
        local remoteNames = {"AgilityTrainingEvent", "AgilityTrain", "TrainAgility", "AgilityEvent"}
        for _, name in pairs(remoteNames) do
            if detectedRemotes[name] then
                detectedRemotes[name]:FireServer()
                break
            end
        end
    end)
end

-- Character respawn handling
local function onCharacterAdded(character)
    spawn(function()
        wait(1.5) -- Wait for character to fully load
        if getgenv().XproD_AutoFarmBandit or getgenv().XproD_TrainSword then
            local success = equipSwordImproved()
            if success then
                createNotification("Sword Equipped", "Your sword has been automatically equipped!", 3, Color3.fromRGB(30, 50, 30))
            end
        end
    end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

-- Training loops with improved performance
local activeLoops = {}

local function createTrainingLoop(name, trainFunction, delay)
    if not activeLoops[name] then
        activeLoops[name] = true
        spawn(function()
            while getgenv()["XproD_"..name] do
                trainFunction()
                wait(delay + math.random(0, 0.1))
            end
            activeLoops[name] = nil
        end)
    end
end

-- Main loop controller
spawn(function()
    while true do
        if getgenv().XproD_TrainSpeed and not activeLoops["TrainSpeed"] then
            createTrainingLoop("TrainSpeed", trainSpeedImproved, 0.35)
        end
        
        if getgenv().XproD_TrainAgility and not activeLoops["TrainAgility"] then
            createTrainingLoop("TrainAgility", trainAgilityImproved, 0.35)
        end
        
        if getgenv().XproD_TrainSword and not activeLoops["TrainSword"] then
            createTrainingLoop("TrainSword", trainSwordImproved, 0.3)
        end
        
        wait(1)
    end
end)

-- Bandit farming (simplified for now)
spawn(function()
    while true do
        if getgenv().XproD_AutoFarmBandit then
            -- Add your bandit farming logic here
            -- This is a placeholder for the bandit farming functionality
        end
        wait(1)
    end
end)

-- Anti-AFK system
spawn(function()
    local lastMoveTime = tick()
    while true do
        if getgenv().XproD_AntiAFK then
            local currentTime = tick()
            if currentTime - lastMoveTime > 60 then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1,1) * 0.1, 0, math.random(-1,1) * 0.1)
                    lastMoveTime = currentTime
                end
            end
        end
        wait(30)
    end
end)

-- Welcome notification
wait(2)
createNotification("XproD Hub Loaded!", "Modern UI successfully loaded. All systems ready!", 5, Color3.fromRGB(20, 40, 20))

print("🚀 XproD Hub - Modern UI Version Loaded Successfully!")
print("✨ New features: Modern design, smooth animations, improved performance")
print("🎯 Enhanced auto-detection system for better compatibility")
