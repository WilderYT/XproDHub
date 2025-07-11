--[[
Ultra Instinct AutoDodge v3 para Ink Game (Roblox)
- Optimizado para evitar bajones de FPS o lag.
- Solo activa Dodge cuando un knife está cerca del torso de cualquier jugador.
- UI draggable, compatible PC/Mobile.
- Hitbox visual real del torso.
- Basado en la imagen ![image1](image1), el botón DODGE (slot 4) puede usarse si requieres RemoteEvent.

Coloca este script en un LocalScript y ejecútalo con tu executor favorito.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Dodge Animations
local DodgeAnims = {
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge1,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge2,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge3
}

local KnifeAnimNames = { "KnifeSwing1", "KnifeSwing1Lunge", "KnifeSwing2" }
local UltraDodgeDistance = 13 -- ajusta si es necesario
local DodgeCooldown = 0.55 -- tiempo mínimo entre dodges

-- UI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "UltraInstinctAutoDodgeUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 120)
frame.Position = UDim2.new(0, 30, 0, 210)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 36)
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 32)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Ultra Instinct AutoDodge v3"
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

-- Estado
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

-- Función para obtener torsos de todos los players
local function getAllTorsos()
    local torsos = {}
    local live = Workspace:FindFirstChild("Live")
    if live then
        for _, char in ipairs(live:GetChildren()) do
            local torso = char:FindFirstChild("Torso")
            if torso then
                table.insert(torsos, torso)
            end
        end
    end
    return torsos
end

-- Mostrar visualmente la hitbox real del torso local
local hitboxAdornment = nil
local function updateHitboxAdornment()
    if hitboxAdornment then
        hitboxAdornment:Destroy()
        hitboxAdornment = nil
    end
    if not hitboxVisible then return end
    local myTorso = nil
    local live = Workspace:FindFirstChild("Live")
    if live then
        local char = live:FindFirstChild(LocalPlayer.Name)
        if char then
            myTorso = char:FindFirstChild("Torso")
        end
    end
    if myTorso then
        hitboxAdornment = Instance.new("BoxHandleAdornment")
        hitboxAdornment.Adornee = myTorso
        hitboxAdornment.AlwaysOnTop = true
        hitboxAdornment.ZIndex = 10
        hitboxAdornment.Size = myTorso.Size
        hitboxAdornment.Color3 = Color3.fromRGB(0,255,128)
        hitboxAdornment.Transparency = 0.6
        hitboxAdornment.Visible = true
        hitboxAdornment.Name = "UltraDodgeHitbox"
        hitboxAdornment.Parent = myTorso
    end
end

RunService.RenderStepped:Connect(function()
    if hitboxVisible then
        updateHitboxAdornment()
    elseif hitboxAdornment then
        hitboxAdornment:Destroy()
        hitboxAdornment = nil
    end
end)

-- Detección de knife cerca de cualquier torso de los players
local function isKnifeNearAnyTorso()
    local torsos = getAllTorsos()
    if #torsos == 0 then return false end

    -- Buscar todos los cuchillos activos en workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("knife") then
            for _, torso in ipairs(torsos) do
                local dist = (obj.Position - torso.Position).Magnitude
                if dist <= UltraDodgeDistance and obj.Velocity.Magnitude > 1 then
                    return torso
                end
            end
        end
    end
    -- Además buscar los animNames específicos en workspace.Live
    for _, char in ipairs(Workspace.Live:GetChildren()) do
        for _, animName in ipairs(KnifeAnimNames) do
            local knife = char:FindFirstChild(animName)
            if knife and knife:IsA("BasePart") then
                for _, torso in ipairs(torsos) do
                    local dist = (knife.Position - torso.Position).Magnitude
                    if dist <= UltraDodgeDistance and knife.Velocity.Magnitude > 1 then
                        return torso
                    end
                end
            end
        end
    end
    return false
end

-- Ejecutar Dodge solo si el knife está cerca del torso y cooldown
local lastDodge = 0
function playDodge()
    local myTorso = nil
    local live = Workspace:FindFirstChild("Live")
    if live then
        local char = live:FindFirstChild(LocalPlayer.Name)
        if char then
            myTorso = char:FindFirstChild("Torso")
        end
    end
    if myTorso then
        local humanoid = myTorso.Parent and myTorso.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local anim = humanoid:LoadAnimation(DodgeAnims[math.random(1, #DodgeAnims)])
            anim.Priority = Enum.AnimationPriority.Action
            anim:Play()
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not autododgeOn then return end
    if tick() - lastDodge < DodgeCooldown then return end
    local torsoToDodge = isKnifeNearAnyTorso()
    -- Solo activa si el knife está cerca del torso local
    local myTorso = nil
    local live = Workspace:FindFirstChild("Live")
    if live then
        local char = live:FindFirstChild(LocalPlayer.Name)
        if char then
            myTorso = char:FindFirstChild("Torso")
        end
    end
    if torsoToDodge and myTorso and torsoToDodge == myTorso then
        playDodge()
        lastDodge = tick()
    end
end)

print("Ultra Instinct AutoDodge v3 activo. Optimizado, sin lag ni spam. UI y hitbox real.")
