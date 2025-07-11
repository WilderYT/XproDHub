-- Ultra Instinct AutoDodge v5 (FPS Ultra Optimized)
-- Solo activa dodge si hay seeker knife cerca y mirando al torso
-- No hay bajones de FPS ni lag de cámara

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local DodgeAnims = {
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge1,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge2,
    ReplicatedStorage.Animations.Abilities.Dodge.Dodge3
}

local UltraDodgeDistance = 11
local DodgeCooldown = 0.65
local CheckInterval = 0.1

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
title.Text = "Ultra Instinct AutoDodge v5"
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

-- Universal drag (PC/Mobile)
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

local autododgeOn, hitboxVisible = true, false
toggle.MouseButton1Click:Connect(function()
    autododgeOn = not autododgeOn
    toggle.Text = autododgeOn and "AutoDodge: ON" or "AutoDodge: OFF"
    toggle.BackgroundColor3 = autododgeOn and Color3.fromRGB(45,200,180) or Color3.fromRGB(70,30,30)
end)
showHitbox.MouseButton1Click:Connect(function()
    hitboxVisible = not hitboxVisible
    showHitbox.Text = hitboxVisible and "Mostrar Hitbox: ON" or "Mostrar Hitbox: OFF"
    showHitbox.BackgroundColor3 = hitboxVisible and Color3.fromRGB(100,200,80) or Color3.fromRGB(90,90,155)
    updateHitboxAdornment()
end)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        autododgeOn = not autododgeOn
        toggle.Text = autododgeOn and "AutoDodge: ON" or "AutoDodge: OFF"
        toggle.BackgroundColor3 = autododgeOn and Color3.fromRGB(45,200,180) or Color3.fromRGB(70,30,30)
    end
end)

-- Hitbox visual (solo se actualiza cuando cambia el estado)
local hitboxAdornment = nil
function updateHitboxAdornment()
    if hitboxAdornment then hitboxAdornment:Destroy() hitboxAdornment = nil end
    if not hitboxVisible then return end
    local live = Workspace:FindFirstChild("Live")
    if live then
        local char = live:FindFirstChild(LocalPlayer.Name)
        local torso = char and char:FindFirstChild("Torso")
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
end

-- Solo actualiza adornment si cambia el botón
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        updateHitboxAdornment()
    end
end)

-- Detección cara a cara seeker knife (optimizado)
local function isSeekerKnifeFaceToFace()
    local live = Workspace:FindFirstChild("Live")
    if not live then return false end
    local myChar = live:FindFirstChild(LocalPlayer.Name)
    local myTorso = myChar and myChar:FindFirstChild("Torso")
    if not myTorso then return false end

    -- Busca solo en workspace.Live para eficiencia
    for _, seeker in ipairs(live:GetChildren()) do
        if seeker ~= myChar then
            for _, obj in ipairs(seeker:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("knife") then
                    local dist = (obj.Position - myTorso.Position).Magnitude
                    if dist <= UltraDodgeDistance then
                        local dirToTorso = (myTorso.Position - obj.Position).Unit
                        local knifeLook = obj.CFrame.LookVector.Unit
                        if knifeLook:Dot(dirToTorso) > 0.8 then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Mobile: detectar y pulsar el botón Dodge en inventario (sin importar slot)
local function pressMobileDodgeButton()
    for _, guiObj in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if (guiObj:IsA("TextButton") or guiObj:IsA("ImageButton")) and guiObj.Visible then
            if guiObj.Text and guiObj.Text:lower():find("dodge") then guiObj:Activate() return true end
            if guiObj.Name and guiObj.Name:lower():find("dodge") then guiObj:Activate() return true end
        end
    end
    return false
end

-- PC: activar dodge con tecla (por defecto '4')
local function pressPCDodgeKey()
    -- Puedes cambiar la tecla aquí si no es '4'
    local dodgeKey = Enum.KeyCode.Four
    UIS.InputBegan:Fire(dodgeKey)
end

-- Loop optimizado (no por frame)
local lastDodge = 0
spawn(function()
    while true do
        if autododgeOn and (tick() - lastDodge > DodgeCooldown) then
            if isSeekerKnifeFaceToFace() then
                if UIS.TouchEnabled then
                    pressMobileDodgeButton()
                else
                    pressPCDodgeKey()
                end
                lastDodge = tick()
            end
        end
        wait(CheckInterval)
    end
end)

print("Ultra Instinct AutoDodge v5 ultra optimizado. Sin lag, solo dodge si hay seeker knife cara a cara.")
