-- Ultra Instinct AutoDodge Mejorado para Ink Game (Roblox)
-- Muestra la hitbox real del jugador en pantalla, autododge imposible de hitear

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Animaciones de dodge
local DodgeAnims = {
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge1,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge2,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge3
}

local KnifeAnimNames = { "KnifeSwing1", "KnifeSwing1Lunge", "KnifeSwing2" }
local KnifeFolders = { Workspace.Live, ReplicatedStorage.Animations.Abilities.Knife }
local UltraDodgeDistance = 14
local DodgeDebounce = 0.22

-- UI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "UltraInstinctAutoDodgeUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 120)
frame.Position = UDim2.new(0, 30, 0, 210)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 36)
frame.Active = true
frame.Draggable = false

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 32)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Ultra Instinct AutoDodge"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(100,255,255)
title.TextSize = 18

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 160, 0, 36)
toggle.Position = UDim2.new(0, 35, 0, 38)
toggle.BackgroundColor3 = Color3.fromRGB(45, 200, 180)
toggle.Text = "AutoDodge: ON"
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 20
toggle.AutoButtonColor = true

local showHitbox = Instance.new("TextButton", frame)
showHitbox.Size = UDim2.new(0, 160, 0, 28)
showHitbox.Position = UDim2.new(0, 35, 0, 84)
showHitbox.BackgroundColor3 = Color3.fromRGB(90, 90, 155)
showHitbox.Text = "Mostrar Hitbox: OFF"
showHitbox.Font = Enum.Font.Gotham
showHitbox.TextColor3 = Color3.new(1,1,1)
showHitbox.TextSize = 16
showHitbox.AutoButtonColor = true

-- Drag universal (PC/Mobile)
do
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            frame.Position.X.Scale, startPos.X.Offset + delta.X,
            frame.Position.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ESTADO
local autododgeOn = true
local hitboxVisible = false
toggle.MouseButton1Click:Connect(function()
    autododgeOn = not autododgeOn
    toggle.Text = autododgeOn and "AutoDodge: ON" or "AutoDodge: OFF"
    toggle.BackgroundColor3 = autododgeOn and Color3.fromRGB(45,200,180) or Color3.fromRGB(70,30,30)
end)
showHitbox.MouseButton1Click:Connect(function()
    hitboxVisible = not hitboxVisible
    showHitbox.Text = hitboxVisible and "Mostrar Hitbox: ON" or "Mostrar Hitbox: OFF"
    showHitbox.BackgroundColor3 = hitboxVisible and Color3.fromRGB(100,200,80) or Color3.fromRGB(90,90,155)
end)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        autododgeOn = not autododgeOn
        toggle.Text = autododgeOn and "AutoDodge: ON" or "AutoDodge: OFF"
        toggle.BackgroundColor3 = autododgeOn and Color3.fromRGB(45,200,180) or Color3.fromRGB(70,30,30)
    end
end)

-- Obtener tu torso (hitbox)
local function getMyTorso()
    local live = Workspace:FindFirstChild("Live")
    if not live then return nil end
    local char = live:FindFirstChild(LocalPlayer.Name)
    if not char then return nil end
    return char:FindFirstChild("Torso")
end

-- Mostrar visualmente la hitbox (real)
local hitboxAdornment = nil
local function updateHitboxAdornment()
    if hitboxAdornment then
        hitboxAdornment:Destroy()
        hitboxAdornment = nil
    end
    if not hitboxVisible then return end
    local torso = getMyTorso()
    if torso then
        hitboxAdornment = Instance.new("BoxHandleAdornment")
        hitboxAdornment.Adornee = torso
        hitboxAdornment.AlwaysOnTop = true
        hitboxAdornment.ZIndex = 10
        hitboxAdornment.Size = torso.Size
        hitboxAdornment.Color3 = Color3.fromRGB(0,255,128)
        hitboxAdornment.Transparency = 0.6
        hitboxAdornment.Visible = true
        hitboxAdornment.Name = "UltraDodgeHitbox"
        hitboxAdornment.Parent = torso
    end
end

-- Mantener la hitbox visible si el botón está ON
RunService.RenderStepped:Connect(function()
    if hitboxVisible then
        updateHitboxAdornment()
    elseif hitboxAdornment then
        hitboxAdornment:Destroy()
        hitboxAdornment = nil
    end
end)

-- Detección avanzada de cuchillo
local function isKnifeDanger()
    local myTorso = getMyTorso()
    if not myTorso then return false end

    -- 1. Detectar cuchillos activos cerca del torso
    for _, folder in ipairs(KnifeFolders) do
        for _, animName in ipairs(KnifeAnimNames) do
            local obj = folder:FindFirstChild(animName)
            if obj and obj:IsA("BasePart") then
                local dist = (obj.Position - myTorso.Position).Magnitude
                if dist <= UltraDodgeDistance then
                    if obj.Velocity.Magnitude > 1 then
                        return true
                    end
                end
            end
        end
    end

    -- 2. Detectar cualquier objeto con "knife" en el nombre
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("knife") then
            if (obj.Position - myTorso.Position).Magnitude <= UltraDodgeDistance then
                if obj.Velocity.Magnitude > 1 then
                    return true
                end
            end
        end
    end

    return false
end

-- Ejecución del dodge
function playDodge()
    local torso = getMyTorso()
    local humanoid = torso and torso.Parent and torso.Parent:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local anim = humanoid:LoadAnimation(DodgeAnims[math.random(1, #DodgeAnims)])
        anim.Priority = Enum.AnimationPriority.Action
        anim:Play()
    end
end

-- Loop principal
local lastDodge = 0
RunService.RenderStepped:Connect(function()
    if not autododgeOn then return end
    if tick() - lastDodge < DodgeDebounce then return end
    if isKnifeDanger() then
        playDodge()
        lastDodge = tick()
    end
end)

print("Ultra Instinct AutoDodge cargado. Hitbox visible y autododge mejorado.")
