-- XproD Hub | GUI Completa con Scrolling y Arrastre v2.2
-- UI moderna con scroll funcional, ícono y UI completamente movibles
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

-- Configuración de animaciones
local function simpleTween(obj, time, props)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

----------------------
-- ÍCONO COMPLETAMENTE MOVIBLE
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

-- Botón para clicks y arrastre
local IconBtn = Instance.new("TextButton", IconFrame)
IconBtn.Size = UDim2.new(1, 0, 1, 0)
IconBtn.Position = UDim2.new(0, 0, 0, 0)
IconBtn.BackgroundTransparency = 1
IconBtn.Text = "X"
IconBtn.Font = Enum.Font.GothamBold
IconBtn.TextSize = 24
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.ZIndex = 51

-- Efectos hover
IconBtn.MouseEnter:Connect(function()
    simpleTween(IconFrame, 0.2, {Size = UDim2.new(0, 65, 0, 65)})
    simpleTween(IconStroke, 0.2, {Transparency = 0.3})
end)

IconBtn.MouseLeave:Connect(function()
    simpleTween(IconFrame, 0.2, {Size = UDim2.new(0, 60, 0, 60)})
    simpleTween(IconStroke, 0.2, {Transparency = 0.6})
end)

-- Sistema de arrastre MEJORADO para el ícono
local iconDragging = false
local iconDragStart = nil
local iconStartPos = nil

IconBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = IconFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - iconDragStart
        IconFrame.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)

----------------------
-- FRAME PRINCIPAL MOVIBLE
----------------------
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 480)
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

-- HEADER MOVIBLE para el MainFrame
local DragHeader = Instance.new("Frame", MainFrame)
DragHeader.Name = "DragHeader"
DragHeader.Size = UDim2.new(1, 0, 0, 40)
DragHeader.Position = UDim2.new(0, 0, 0, 0)
DragHeader.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
DragHeader.BackgroundTransparency = 0.3
DragHeader.BorderSizePixel = 0
DragHeader.ZIndex = 11

local DragCorner = Instance.new("UICorner", DragHeader)
DragCorner.CornerRadius = UDim.new(0, 16)

-- Título en el header
local DragTitle = Instance.new("TextLabel", DragHeader)
DragTitle.Text = "⚡ XproD Hub - Arrastra aquí para mover"
DragTitle.Font = Enum.Font.GothamBold
DragTitle.TextSize = 14
DragTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DragTitle.Position = UDim2.new(0, 15, 0, 0)
DragTitle.Size = UDim2.new(1, -50, 1, 0)
DragTitle.BackgroundTransparency = 1
DragTitle.TextXAlignment = Enum.TextXAlignment.Left
DragTitle.ZIndex = 12

-- Botón de cerrar en el header
local CloseBtn = Instance.new("TextButton", DragHeader)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.ZIndex = 12

local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.CornerRadius = UDim.new(0, 8)

-- Sistema de arrastre para el MainFrame
local frameDragging = false
local frameDragStart = nil
local frameStartPos = nil

DragHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        frameDragging = true
        frameDragStart = input.Position
        frameStartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                frameDragging = false
            end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if frameDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - frameDragStart
        MainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

-- Toggle funcional
local isOpen = false

-- Click en ícono para abrir
IconBtn.MouseButton1Click:Connect(function()
    if not iconDragging then -- Solo abrir si no estamos arrastrando
        isOpen = not isOpen
        
        if isOpen then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            simpleTween(MainFrame, 0.4, {Size = UDim2.new(0, 580, 0, 480)})
        else
            simpleTween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0)})
            wait(0.3)
            MainFrame.Visible = false
        end
    end
end)

-- Click en botón cerrar
CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    simpleTween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0)})
    wait(0.3)
    MainFrame.Visible = false
end)

----------------------
-- SIDEBAR
----------------------
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 11

local SideCorner = Instance.new("UICorner", SideBar)
SideCorner.CornerRadius = UDim.new(0, 16)

-- Header del sidebar
local SideHeader = Instance.new("Frame", SideBar)
SideHeader.Size = UDim2.new(1, 0, 0, 70)
SideHeader.Position = UDim2.new(0, 0, 0, 0)
SideHeader.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SideHeader.BackgroundTransparency = 0.2
SideHeader.BorderSizePixel = 0
SideHeader.ZIndex = 12

local SideHeaderCorner = Instance.new("UICorner", SideHeader)
SideHeaderCorner.CornerRadius = UDim.new(0, 16)

-- Título del sidebar
local SideTitle = Instance.new("TextLabel", SideHeader)
SideTitle.Text = "XproD Hub"
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 18
SideTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SideTitle.Position = UDim2.new(0, 10, 0, 10)
SideTitle.Size = UDim2.new(1, -20, 0, 25)
SideTitle.BackgroundTransparency = 1
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.ZIndex = 13

local SideSubtitle = Instance.new("TextLabel", SideHeader)
SideSubtitle.Text = "Modern Edition v2.2"
SideSubtitle.Font = Enum.Font.Gotham
SideSubtitle.TextSize = 11
SideSubtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SideSubtitle.Position = UDim2.new(0, 10, 0, 35)
SideSubtitle.Size = UDim2.new(1, -20, 0, 20)
SideSubtitle.BackgroundTransparency = 1
SideSubtitle.TextXAlignment = Enum.TextXAlignment.Left
SideSubtitle.ZIndex = 13

----------------------
-- ÁREA DE CONTENIDO CON SCROLL
----------------------
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -150, 1, -55)
ContentArea.Position = UDim2.new(0, 145, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 12

-- SCROLLING FRAME FUNCIONAL
local ScrollFrame = Instance.new("ScrollingFrame", ContentArea)
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ScrollFrame.BackgroundTransparency = 0.3
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ZIndex = 12

-- Configuración del scroll
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ScrollFrame.ScrollBarImageTransparency = 0.3
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800) -- Altura total del contenido
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local ScrollCorner = Instance.new("UICorner", ScrollFrame)
ScrollCorner.CornerRadius = UDim.new(0, 12)

-- Título del panel dentro del scroll
local PanelTitle = Instance.new("TextLabel", ScrollFrame)
PanelTitle.Text = "⚡ Training Center"
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.TextSize = 22
PanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PanelTitle.Position = UDim2.new(0, 15, 0, 15)
PanelTitle.Size = UDim2.new(1, -40, 0, 35)
PanelTitle.BackgroundTransparency = 1
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 13

local PanelSubtitle = Instance.new("TextLabel", ScrollFrame)
PanelSubtitle.Text = "Configure todas tus opciones de entrenamiento automático"
PanelSubtitle.Font = Enum.Font.Gotham
PanelSubtitle.TextSize = 12
PanelSubtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
PanelSubtitle.Position = UDim2.new(0, 15, 0, 50)
PanelSubtitle.Size = UDim2.new(1, -40, 0, 20)
PanelSubtitle.BackgroundTransparency = 1
PanelSubtitle.TextXAlignment = Enum.TextXAlignment.Left
PanelSubtitle.ZIndex = 13

----------------------
-- SWITCHES MODERNOS CON SCROLL
----------------------
local function createAdvancedSwitch(parent, y, title, subtitle, icon, getVal, setVal)
    -- Container principal
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -30, 0, 85)
    container.Position = UDim2.new(0, 15, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BackgroundTransparency = 0.2
    container.BorderSizePixel = 0
    container.ZIndex = 14
    
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 12)
    
    -- Stroke elegante
    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = Color3.fromRGB(60, 60, 80)
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.5
    
    -- Ícono grande
    local iconLabel = Instance.new("TextLabel", container)
    iconLabel.Size = UDim2.new(0, 45, 0, 45)
    iconLabel.Position = UDim2.new(0, 15, 0, 20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    iconLabel.ZIndex = 15
    
    -- Título principal
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(1, -140, 0, 25)
    titleLabel.Position = UDim2.new(0, 70, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 15
    
    -- Subtítulo descriptivo
    local subtitleLabel = Instance.new("TextLabel", container)
    subtitleLabel.Size = UDim2.new(1, -140, 0, 35)
    subtitleLabel.Position = UDim2.new(0, 70, 0, 40)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 11
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.TextWrapped = true
    subtitleLabel.ZIndex = 15
    
    -- Switch background moderno
    local switchBg = Instance.new("Frame", container)
    switchBg.Size = UDim2.new(0, 55, 0, 28)
    switchBg.Position = UDim2.new(1, -70, 0.5, -14)
    switchBg.BackgroundColor3 = getVal() and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 15
    
    local switchCorner = Instance.new("UICorner", switchBg)
    switchCorner.CornerRadius = UDim.new(0, 14)
    
    -- Switch button (círculo)
    local switchButton = Instance.new("Frame", switchBg)
    switchButton.Size = UDim2.new(0, 24, 0, 24)
    switchButton.Position = UDim2.new(0, getVal() and 29 or 2, 0, 2)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderSizePixel = 0
    switchButton.ZIndex = 16
    
    local buttonCorner = Instance.new("UICorner", switchButton)
    buttonCorner.CornerRadius = UDim.new(0, 12)
    
    -- Estado del switch
    local statusLabel = Instance.new("TextLabel", container)
    statusLabel.Size = UDim2.new(0, 60, 0, 15)
    statusLabel.Position = UDim2.new(1, -70, 0, 10)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = getVal() and "ACTIVO" or "INACTIVO"
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 10
    statusLabel.TextColor3 = getVal() and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 100, 100)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.ZIndex = 15
    
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
        
        -- Animaciones del switch
        local newColor = newVal and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
        local newPos = newVal and UDim2.new(0, 29, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        simpleTween(switchBg, 0.25, {BackgroundColor3 = newColor})
        simpleTween(switchButton, 0.25, {Position = newPos})
        
        -- Actualizar estado
        statusLabel.Text = newVal and "ACTIVO" or "INACTIVO"
        statusLabel.TextColor3 = newVal and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 100, 100)
        
        -- Feedback visual del container
        simpleTween(container, 0.1, {BackgroundTransparency = 0.1})
        wait(0.1)
        simpleTween(container, 0.1, {BackgroundTransparency = 0.2})
    end)
    
    -- Efectos hover
    clickButton.MouseEnter:Connect(function()
        simpleTween(container, 0.2, {BackgroundTransparency = 0.1})
        simpleTween(containerStroke, 0.2, {Transparency = 0.2})
        simpleTween(iconLabel, 0.2, {TextSize = 26})
    end)
    
    clickButton.MouseLeave:Connect(function()
        simpleTween(container, 0.2, {BackgroundTransparency = 0.2})
        simpleTween(containerStroke, 0.2, {Transparency = 0.5})
        simpleTween(iconLabel, 0.2, {TextSize = 24})
    end)
    
    return container
end

-- Crear switches con scroll
createAdvancedSwitch(
    ScrollFrame, 85, "Speed Training", 
    "Entrenar velocidad automáticamente con delays optimizados para evitar detección", 
    "🏃", 
    function() return getgenv().XproD_TrainSpeed end,
    function(v) getgenv().XproD_TrainSpeed = v end
)

createAdvancedSwitch(
    ScrollFrame, 180, "Agility Training", 
    "Mejorar la agilidad del personaje de forma automática y continua", 
    "🤸", 
    function() return getgenv().XproD_TrainAgility end,
    function(v) getgenv().XproD_TrainAgility = v end
)

createAdvancedSwitch(
    ScrollFrame, 275, "Sword Training", 
    "Entrenar habilidades de espada con la espada equipada en tu HUD", 
    "⚔️", 
    function() return getgenv().XproD_TrainSword end,
    function(v) getgenv().XproD_TrainSword = v end
)

createAdvancedSwitch(
    ScrollFrame, 370, "Auto Farm Bandits", 
    "Farmear banditos automáticamente para obtener experiencia y dinero", 
    "💀", 
    function() return getgenv().XproD_AutoFarmBandit end,
    function(v) getgenv().XproD_AutoFarmBandit = v end
)

createAdvancedSwitch(
    ScrollFrame, 465, "Bring Bandits", 
    "Atraer todos los banditos hacia tu ubicación para farmeo eficiente", 
    "🧲", 
    function() return getgenv().XproD_BringBandits end,
    function(v) getgenv().XproD_BringBandits = v end
)

createAdvancedSwitch(
    ScrollFrame, 560, "Anti AFK", 
    "Prevenir que te echen por inactividad con movimientos sutiles", 
    "🛡️", 
    function() return getgenv().XproD_AntiAFK end,
    function(v) getgenv().XproD_AntiAFK = v end
)

-- Sección de información expandida
local InfoSection = Instance.new("Frame", ScrollFrame)
InfoSection.Size = UDim2.new(1, -30, 0, 120)
InfoSection.Position = UDim2.new(0, 15, 0, 660)
InfoSection.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
InfoSection.BackgroundTransparency = 0.3
InfoSection.BorderSizePixel = 0
InfoSection.ZIndex = 14

local InfoSectionCorner = Instance.new("UICorner", InfoSection)
InfoSectionCorner.CornerRadius = UDim.new(0, 12)

local InfoSectionStroke = Instance.new("UIStroke", InfoSection)
InfoSectionStroke.Color = Color3.fromRGB(138, 43, 226)
InfoSectionStroke.Thickness = 1
InfoSectionStroke.Transparency = 0.7

local InfoTitle = Instance.new("TextLabel", InfoSection)
InfoTitle.Text = "📋 Información Importante"
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 16
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.Position = UDim2.new(0, 15, 0, 10)
InfoTitle.Size = UDim2.new(1, -30, 0, 25)
InfoTitle.BackgroundTransparency = 1
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.ZIndex = 15

local InfoText = Instance.new("TextLabel", InfoSection)
InfoText.Text = "⚔️ Sistema de Espadas: El farmeo usará la espada que tengas equipada en tu HUD (botón central inferior). Para cambiarla, selecciona manualmente una diferente desde el menú de Swords.\n\n🔧 Optimizado: Todos los delays se ajustan automáticamente según el rendimiento para evitar detección."
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 12
InfoText.TextColor3 = Color3.fromRGB(200, 200, 220)
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 15, 0, 35)
InfoText.Size = UDim2.new(1, -30, 0, 75)
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
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

-- Notificaciones mejoradas
spawn(function()
    wait(2)
    local function notify(text, icon)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XproD Hub v2.2";
            Text = icon.." "..text;
            Duration = 4;
        })
    end
    notify("Hub cargado exitosamente!", "✅")
    notify("Scroll funcional activado!", "📜")
    notify("Arrastre mejorado habilitado!", "🎯")
end)

print("🚀 XproD Hub v2.2 - Complete Edition loaded!")
print("✅ Scrolling funcional implementado")
print("🎯 Arrastre completo del ícono y UI")
print("📱 Navegación mejorada")
print("⚡ Todas las funciones operativas")
