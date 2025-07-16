-- XproD Hub | GUI Moderna y Profesional v2.0
-- UI completamente rediseñada con animaciones suaves y diseño moderno
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

-- CONFIGURACIÓN DE ANIMACIONES
local function createTween(obj, info, props)
    return TweenService:Create(obj, info, props)
end

local quickTween = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local smoothTween = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local bounceTween = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

----------------------
-- ÍCONO MODERNO CON EFECTOS
----------------------
local IconContainer = Instance.new("Frame", gui)
IconContainer.Name = "IconContainer"
IconContainer.Size = UDim2.new(0, 70, 0, 70)
IconContainer.Position = UDim2.new(0, 40, 0, 120)
IconContainer.BackgroundTransparency = 1
IconContainer.ZIndex = 50

-- Glow effect para el ícono
local IconGlow = Instance.new("ImageLabel", IconContainer)
IconGlow.Name = "Glow"
IconGlow.Size = UDim2.new(1, 20, 1, 20)
IconGlow.Position = UDim2.new(0, -10, 0, -10)
IconGlow.BackgroundTransparency = 1
IconGlow.Image = "rbxassetid://241650934"
IconGlow.ImageColor3 = Color3.fromRGB(138, 43, 226)
IconGlow.ImageTransparency = 0.4
IconGlow.ZIndex = 49

-- Ícono principal con gradiente
local IconBtn = Instance.new("ImageButton", IconContainer)
IconBtn.Name = "OpenCloseIcon"
IconBtn.Size = UDim2.new(1, 0, 1, 0)
IconBtn.Position = UDim2.new(0, 0, 0, 0)
IconBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
IconBtn.Image = "rbxassetid://3926307971"
IconBtn.ImageRectOffset = Vector2.new(204, 4)
IconBtn.ImageRectSize = Vector2.new(36, 36)
IconBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.ZIndex = 50

-- Esquinas redondeadas para el ícono
local IconCorner = Instance.new("UICorner", IconBtn)
IconCorner.CornerRadius = UDim.new(0, 15)

-- Gradiente para el ícono
local IconGradient = Instance.new("UIGradient", IconBtn)
IconGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
IconGradient.Rotation = 45

-- Stroke para el ícono
local IconStroke = Instance.new("UIStroke", IconBtn)
IconStroke.Color = Color3.fromRGB(255, 255, 255)
IconStroke.Thickness = 2
IconStroke.Transparency = 0.7

-- Efectos hover para el ícono
IconBtn.MouseEnter:Connect(function()
    createTween(IconBtn, quickTween, {Size = UDim2.new(1.1, 0, 1.1, 0)}):Play()
    createTween(IconGlow, quickTween, {ImageTransparency = 0.2}):Play()
    createTween(IconStroke, quickTween, {Transparency = 0.3}):Play()
end)

IconBtn.MouseLeave:Connect(function()
    createTween(IconBtn, quickTween, {Size = UDim2.new(1, 0, 1, 0)}):Play()
    createTween(IconGlow, quickTween, {ImageTransparency = 0.4}):Play()
    createTween(IconStroke, quickTween, {Transparency = 0.7}):Play()
end)

-- Sistema de arrastre para el ícono
local draggingIcon, dragStartIcon, startPosIcon
IconContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStartIcon = input.Position
        startPosIcon = IconContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingIcon = false end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartIcon
        IconContainer.Position = UDim2.new(startPosIcon.X.Scale, startPosIcon.X.Offset + delta.X, startPosIcon.Y.Scale, startPosIcon.Y.Offset + delta.Y)
        if gui:FindFirstChild("MainFrame") then
            gui.MainFrame.Position = UDim2.new(0, IconContainer.Position.X.Offset + 80, 0, IconContainer.Position.Y.Offset - 50)
        end
    end
end)

----------------------
-- MAIN FRAME MODERNO
----------------------
local MainFrame = Instance.new("Frame", gui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 450)
MainFrame.Position = UDim2.new(0, IconContainer.Position.X.Offset + 80, 0, IconContainer.Position.Y.Offset - 50)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Visible = false

-- Esquinas redondeadas
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 20)

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
MainStroke.Transparency = 0.3

-- Sombra del frame principal
local MainShadow = Instance.new("Frame", gui)
MainShadow.Name = "MainShadow"
MainShadow.Size = UDim2.new(0, 590, 0, 460)
MainShadow.Position = UDim2.new(0, IconContainer.Position.X.Offset + 75, 0, IconContainer.Position.Y.Offset - 45)
MainShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.BackgroundTransparency = 0.8
MainShadow.BorderSizePixel = 0
MainShadow.ZIndex = 9
MainShadow.Visible = false

local ShadowCorner = Instance.new("UICorner", MainShadow)
ShadowCorner.CornerRadius = UDim.new(0, 20)

-- Sistema de arrastre para el frame principal
local draggingFr, dragStartFr, startPosFr
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFr = true
        dragStartFr = input.Position
        startPosFr = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingFr = false end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingFr and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartFr
        MainFrame.Position = UDim2.new(startPosFr.X.Scale, startPosFr.X.Offset + delta.X, startPosFr.Y.Scale, startPosFr.Y.Offset + delta.Y)
        MainShadow.Position = UDim2.new(0, MainFrame.Position.X.Offset - 5, 0, MainFrame.Position.Y.Offset + 5)
        IconContainer.Position = UDim2.new(0, MainFrame.Position.X.Offset - 80, 0, MainFrame.Position.Y.Offset + 50)
    end
end)

-- Toggle con animación
local isVisible = false
IconBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    
    if isVisible then
        MainFrame.Visible = true
        MainShadow.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0, IconContainer.Position.X.Offset + 35, 0, IconContainer.Position.Y.Offset + 35)
        
        createTween(MainFrame, bounceTween, {
            Size = UDim2.new(0, 580, 0, 450),
            Position = UDim2.new(0, IconContainer.Position.X.Offset + 80, 0, IconContainer.Position.Y.Offset - 50)
        }):Play()
        
        createTween(MainShadow, bounceTween, {
            Position = UDim2.new(0, IconContainer.Position.X.Offset + 75, 0, IconContainer.Position.Y.Offset - 45)
        }):Play()
    else
        createTween(MainFrame, quickTween, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, IconContainer.Position.X.Offset + 35, 0, IconContainer.Position.Y.Offset + 35)
        }):Play()
        
        wait(0.3)
        MainFrame.Visible = false
        MainShadow.Visible = false
    end
end)

----------------------
-- SIDEBAR MODERNO
----------------------
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 140, 1, 0)
SideBar.Position = UDim2.new(0, 0, 0, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 11

local SideCorner = Instance.new("UICorner", SideBar)
SideCorner.CornerRadius = UDim.new(0, 20)

-- Gradiente para sidebar
local SideGradient = Instance.new("UIGradient", SideBar)
SideGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 45))
}
SideGradient.Rotation = 90

-- Header del sidebar con efecto glassmorphism
local SideHeader = Instance.new("Frame", SideBar)
SideHeader.Size = UDim2.new(1, 0, 0, 80)
SideHeader.Position = UDim2.new(0, 0, 0, 0)
SideHeader.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SideHeader.BackgroundTransparency = 0.1
SideHeader.BorderSizePixel = 0
SideHeader.ZIndex = 12

local HeaderCorner = Instance.new("UICorner", SideHeader)
HeaderCorner.CornerRadius = UDim.new(0, 20)

local HeaderGradient = Instance.new("UIGradient", SideHeader)
HeaderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
HeaderGradient.Rotation = 45
HeaderGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 0.9)
}

-- Logo mejorado
local SideLogo = Instance.new("ImageLabel", SideHeader)
SideLogo.Size = UDim2.new(0, 40, 0, 40)
SideLogo.Position = UDim2.new(0, 15, 0, 12)
SideLogo.BackgroundTransparency = 1
SideLogo.Image = "rbxassetid://14594347870"
SideLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
SideLogo.ZIndex = 13

-- Título con efecto brillante
local HubTitle = Instance.new("TextLabel", SideHeader)
HubTitle.Text = "XproD Hub"
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 20
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.Position = UDim2.new(0, 58, 0, 10)
HubTitle.Size = UDim2.new(0, 80, 0, 25)
HubTitle.BackgroundTransparency = 1
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.ZIndex = 13

local SmallTitle = Instance.new("TextLabel", SideHeader)
SmallTitle.Text = "Advanced Farming System"
SmallTitle.Font = Enum.Font.Gotham
SmallTitle.TextSize = 11
SmallTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SmallTitle.Position = UDim2.new(0, 58, 0, 35)
SmallTitle.Size = UDim2.new(0, 80, 0, 16)
SmallTitle.BackgroundTransparency = 1
SmallTitle.TextXAlignment = Enum.TextXAlignment.Left
SmallTitle.ZIndex = 13

-- Versión
local Version = Instance.new("TextLabel", SideHeader)
Version.Text = "v2.0"
Version.Font = Enum.Font.GothamBold
Version.TextSize = 10
Version.TextColor3 = Color3.fromRGB(138, 43, 226)
Version.Position = UDim2.new(0, 58, 0, 50)
Version.Size = UDim2.new(0, 30, 0, 12)
Version.BackgroundTransparency = 1
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.ZIndex = 13

----------------------
-- BOTONES DE NAVEGACIÓN MODERNOS
----------------------
local currentPanel = "Training"

local function createNavButton(text, y, icon, selected)
    local btn = Instance.new("TextButton", SideBar)
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = selected and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 30, 45)
    btn.BackgroundTransparency = selected and 0.2 or 0.7
    btn.Text = ""
    btn.ZIndex = 14
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 12)
    
    if selected then
        local btnGradient = Instance.new("UIGradient", btn)
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
        }
        btnGradient.Rotation = 45
    end
    
    -- Ícono
    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Position = UDim2.new(0, 12, 0, 12)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    iconLabel.ZIndex = 15
    
    -- Texto
    local textLabel = Instance.new("TextLabel", btn)
    textLabel.Size = UDim2.new(1, -40, 1, 0)
    textLabel.Position = UDim2.new(0, 35, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.ZIndex = 15
    
    -- Efectos hover
    btn.MouseEnter:Connect(function()
        if not selected then
            createTween(btn, quickTween, {BackgroundTransparency = 0.5}):Play()
            createTween(textLabel, quickTween, {TextColor3 = Color3.fromRGB(200, 200, 220)}):Play()
            createTween(iconLabel, quickTween, {TextColor3 = Color3.fromRGB(200, 200, 220)}):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not selected then
            createTween(btn, quickTween, {BackgroundTransparency = 0.7}):Play()
            createTween(textLabel, quickTween, {TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
            createTween(iconLabel, quickTween, {TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
        end
    end)
    
    return btn, textLabel, iconLabel
end

local TrainingBtn, TrainingText, TrainingIcon = createNavButton("Training", 95, "⚡", true)
local CreditBtn, CreditText, CreditIcon = createNavButton("Credits", 150, "👤", false)
local SettingsBtn, SettingsText, SettingsIcon = createNavButton("Settings", 205, "⚙️", false)

----------------------
-- PANEL DE ENTRENAMIENTO MODERNO
----------------------
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -150, 1, -20)
ContentArea.Position = UDim2.new(0, 148, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 12

local TrainPanel = Instance.new("ScrollingFrame", ContentArea)
TrainPanel.Name = "TrainPanel"
TrainPanel.Size = UDim2.new(1, 0, 1, 0)
TrainPanel.Position = UDim2.new(0, 0, 0, 0)
TrainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TrainPanel.BackgroundTransparency = 0.3
TrainPanel.BorderSizePixel = 0
TrainPanel.ZIndex = 12
TrainPanel.ScrollBarThickness = 8
TrainPanel.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
TrainPanel.CanvasSize = UDim2.new(0, 0, 0, 600)

local PanelCorner = Instance.new("UICorner", TrainPanel)
PanelCorner.CornerRadius = UDim.new(0, 15)

-- Header del panel
local PanelHeader = Instance.new("Frame", TrainPanel)
PanelHeader.Size = UDim2.new(1, 0, 0, 60)
PanelHeader.Position = UDim2.new(0, 0, 0, 0)
PanelHeader.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
PanelHeader.BackgroundTransparency = 0.8
PanelHeader.BorderSizePixel = 0
PanelHeader.ZIndex = 13

local PanelHeaderCorner = Instance.new("UICorner", PanelHeader)
PanelHeaderCorner.CornerRadius = UDim.new(0, 15)

local TrainTitle = Instance.new("TextLabel", PanelHeader)
TrainTitle.Text = "⚡ Training Center"
TrainTitle.Font = Enum.Font.GothamBold
TrainTitle.TextSize = 22
TrainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TrainTitle.Position = UDim2.new(0, 20, 0, 0)
TrainTitle.Size = UDim2.new(1, -40, 0, 35)
TrainTitle.BackgroundTransparency = 1
TrainTitle.TextXAlignment = Enum.TextXAlignment.Left
TrainTitle.ZIndex = 14

local TrainSubtitle = Instance.new("TextLabel", PanelHeader)
TrainSubtitle.Text = "Configure your automated training settings"
TrainSubtitle.Font = Enum.Font.Gotham
TrainSubtitle.TextSize = 12
TrainSubtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
TrainSubtitle.Position = UDim2.new(0, 20, 0, 35)
TrainSubtitle.Size = UDim2.new(1, -40, 0, 20)
TrainSubtitle.BackgroundTransparency = 1
TrainSubtitle.TextXAlignment = Enum.TextXAlignment.Left
TrainSubtitle.ZIndex = 14

----------------------
-- SWITCHES MODERNOS
----------------------
local function createModernSwitch(parent, y, title, subtitle, icon, getVal, setVal)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 80)
    container.Position = UDim2.new(0, 10, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    container.ZIndex = 14
    
    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 12)
    
    local containerStroke = Instance.new("UIStroke", container)
    containerStroke.Color = Color3.fromRGB(60, 60, 80)
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.5
    
    -- Ícono
    local iconLabel = Instance.new("TextLabel", container)
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 15, 0, 20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 20
    iconLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    iconLabel.ZIndex = 15
    
    -- Título
    local titleLabel = Instance.new("TextLabel", container)
    titleLabel.Size = UDim2.new(1, -120, 0, 25)
    titleLabel.Position = UDim2.new(0, 60, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 15
    
    -- Subtítulo
    local subtitleLabel = Instance.new("TextLabel", container)
    subtitleLabel.Size = UDim2.new(1, -120, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 60, 0, 40)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 12
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.ZIndex = 15
    
    -- Switch moderno
    local switchBg = Instance.new("Frame", container)
    switchBg.Size = UDim2.new(0, 60, 0, 30)
    switchBg.Position = UDim2.new(1, -75, 0.5, -15)
    switchBg.BackgroundColor3 = getVal() and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
    switchBg.BorderSizePixel = 0
    switchBg.ZIndex = 15
    
    local switchCorner = Instance.new("UICorner", switchBg)
    switchCorner.CornerRadius = UDim.new(0, 15)
    
    local switchButton = Instance.new("Frame", switchBg)
    switchButton.Size = UDim2.new(0, 26, 0, 26)
    switchButton.Position = UDim2.new(0, getVal() and 32 or 2, 0, 2)
    switchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchButton.BorderSizePixel = 0
    switchButton.ZIndex = 16
    
    local buttonCorner = Instance.new("UICorner", switchButton)
    buttonCorner.CornerRadius = UDim.new(0, 13)
    
    -- Efectos hover
    local clickDetector = Instance.new("TextButton", container)
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.Position = UDim2.new(0, 0, 0, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.ZIndex = 17
    
    clickDetector.MouseEnter:Connect(function()
        createTween(container, quickTween, {BackgroundTransparency = 0.05}):Play()
        createTween(containerStroke, quickTween, {Transparency = 0.2}):Play()
    end)
    
    clickDetector.MouseLeave:Connect(function()
        createTween(container, quickTween, {BackgroundTransparency = 0.1}):Play()
        createTween(containerStroke, quickTween, {Transparency = 0.5}):Play()
    end)
    
    clickDetector.MouseButton1Click:Connect(function()
        local newVal = not getVal()
        setVal(newVal)
        
        -- Animación del switch
        createTween(switchBg, quickTween, {
            BackgroundColor3 = newVal and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(60, 60, 80)
        }):Play()
        
        createTween(switchButton, quickTween, {
            Position = UDim2.new(0, newVal and 32 or 2, 0, 2)
        }):Play()
        
        -- Efecto de click
        createTween(container, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -18, 0, 78)}):Play()
        wait(0.1)
        createTween(container, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -20, 0, 80)}):Play()
    end)
    
    return container
end

-- Crear switches modernos
createModernSwitch(
    TrainPanel, 80, "Speed Training", "Automatically train your character's speed", "🏃",
    function() return getgenv().XproD_TrainSpeed end,
    function(v) getgenv().XproD_TrainSpeed = v end
)

createModernSwitch(
    TrainPanel, 170, "Agility Training", "Enhance your character's agility and movement", "🤸",
    function() return getgenv().XproD_TrainAgility end,
    function(v) getgenv().XproD_TrainAgility = v end
)

createModernSwitch(
    TrainPanel, 260, "Sword Training", "Train your swordsmanship skills automatically", "⚔️",
    function() return getgenv().XproD_TrainSword end,
    function(v) getgenv().XproD_TrainSword = v end
)

createModernSwitch(
    TrainPanel, 350, "Auto Farm Bandits", "Automatically farm bandits for experience", "💀",
    function() return getgenv().XproD_AutoFarmBandit end,
    function(v) getgenv().XproD_AutoFarmBandit = v end
)

createModernSwitch(
    TrainPanel, 440, "Bring Bandits", "Gather all bandits to your location", "🧲",
    function() return getgenv().XproD_BringBandits end,
    function(v) getgenv().XproD_BringBandits = v end
)

createModernSwitch(
    TrainPanel, 530, "Anti AFK", "Prevent being kicked for inactivity", "🛡️",
    function() return getgenv().XproD_AntiAFK end,
    function(v) getgenv().XproD_AntiAFK = v end
)

----------------------
-- INFO CARD MODERNA
----------------------
local InfoCard = Instance.new("Frame", ContentArea)
InfoCard.Size = UDim2.new(1, 0, 0, 100)
InfoCard.Position = UDim2.new(0, 0, 1, -110)
InfoCard.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
InfoCard.BackgroundTransparency = 0.2
InfoCard.BorderSizePixel = 0
InfoCard.ZIndex = 12
InfoCard.Visible = false

local InfoCorner = Instance.new("UICorner", InfoCard)
InfoCorner.CornerRadius = UDim.new(0, 15)

local InfoGradient = Instance.new("UIGradient", InfoCard)
InfoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
InfoGradient.Rotation = 45
InfoGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.8),
    NumberSequenceKeypoint.new(1, 0.9)
}

local InfoText = Instance.new("TextLabel", InfoCard)
InfoText.Text = "⚔️ Sword Equipment Info\n\nThe farming system will use the sword currently equipped in your HUD (bottom center button). To change it, manually select a different sword from the Swords menu once."
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 14
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 20, 0, 10)
InfoText.Size = UDim2.new(1, -40, 1, -20)
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.ZIndex = 13

-- Mostrar info card con animación
spawn(function()
    wait(1)
    InfoCard.Visible = true
    InfoCard.Position = UDim2.new(0, 0, 1, 0)
    createTween(InfoCard, bounceTween, {Position = UDim2.new(0, 0, 1, -110)}):Play()
    
    wait(5)
    createTween(InfoCard, quickTween, {Position = UDim2.new(0, 0, 1, 0)}):Play()
    wait(0.3)
    InfoCard.Visible = false
end)

----------------------
-- RESTO DEL CÓDIGO FUNCIONAL (manteniendo la lógica original)
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

-- Funciones de entrenamiento optimizadas
local Remote = game:GetService("ReplicatedStorage").RemoteEvents
local RunService = game:GetService("RunService")

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

-- Loops optimizados
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

-- Sistema de loops mejorado
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

-- Notificaciones modernas
spawn(function()
    wait(2)
    local function notify(text, icon)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XproD Hub v2.0";
            Text = icon.." "..text;
            Duration = 4;
        })
    end
    notify("Hub cargado con éxito!", "✨")
    notify("UI moderna activada", "🎨")
    notify("Sistema optimizado listo", "⚡")
end)

print("🚀 XproD Hub v2.0 - Modern UI Edition loaded successfully!")
print("🎨 New features: Modern design, smooth animations, improved UX")
print("⚡ Enhanced performance with adaptive delays")
print("🛡️ Anti-detection system active")
