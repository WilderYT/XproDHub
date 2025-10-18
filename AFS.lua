-- AutoTrainSpeed.client.lua
-- LocalScript para crear UI con switches on/off que intentan actualizar valores en workspace.
-- Colocar este LocalScript dentro de StarterGui.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Config: las rutas solicitadas (exactamente como las diste).
local targets = {
    { key = "IlhaPrincSpeed", path = "workspace.Map.Mapa.IlhaPrinc.Speed", label = "IlhaPrinc.Speed" },
    { key = "AreaASpeed",   path = "workspace.TrainingAreas.AreaA.Speed",    label = "TrainingAreas.AreaA.Speed" },
    { key = "ClicksAgility",path = "workspace.Xprodnow.ClicksAgilitySpeedStatus", label = "Xprodnow.ClicksAgilitySpeedStatus" },
}

-- Estado
local enabled = {}
local coroutines = {}
local defaultSpeedValue = 100 -- valor por defecto si el usuario no pone nada

for _, t in ipairs(targets) do
    enabled[t.key] = false
end

-- Utility: resolver una ruta tipo "workspace.Map.Mapa.IlhaPrinc.Speed"
local function resolvePath(pathStr)
    local parts = {}
    for part in string.gmatch(pathStr, "[^%.]+") do
        table.insert(parts, part)
    end
    local node = nil
    if parts[1] == "workspace" or parts[1] == "Workspace" then
        node = workspace
    elseif parts[1] == "game" or parts[1] == "Game" then
        node = game
    else
        -- empezar desde game por seguridad
        node = game
    end
    for i = 2, #parts do
        if not node then return nil end
        local childName = parts[i]
        -- usar FindFirstChild para evitar yields; si falta devolvemos nil
        local found = node:FindFirstChild(childName)
        if not found then
            -- intentar mirar también como propiedad directa (ej. "Speed" como propiedad)
            -- Si node tiene una propiedad con ese nombre, no podemos accederla por FindFirstChild
            -- retornamos el parent y la "propName" por si se trata de propiedad en vez de Value object
            return node, childName
        end
        node = found
    end
    return node
end

-- Intenta aplicar el valor apropiado al target (NumberValue, BoolValue, RemoteEvent, propiedad)
local function applyValueToTarget(targetObjOrParent, propNameOrNil, value)
    -- Si targetObjOrParent es nil -> nothing
    if not targetObjOrParent then
        return false, "Target not found"
    end

    -- Si recibimos (parent, propName) en vez de instancia, intentamos establecer propiedad del parent
    if propNameOrNil then
        local parent = targetObjOrParent
        local propName = propNameOrNil
        -- intentar si parent tiene miembro con ese nombre
        local success, err = pcall(function()
            -- Si existe como Instance child con ese nombre:
            local child = parent:FindFirstChild(propName)
            if child then
                -- Reintentar como instance
                if child:IsA("NumberValue") or child:IsA("IntValue") then
                    child.Value = value
                elseif child:IsA("BoolValue") then
                    child.Value = (value ~= 0)
                elseif child:IsA("RemoteEvent") then
                    child:FireServer(value)
                else
                    -- intentar asignar .Value si tiene
                    if child.Value ~= nil then
                        child.Value = value
                    end
                end
                return
            end

            -- Si no hay child con ese nombre, intentar asignar propiedad directamente (por ejemplo .WalkSpeed)
            -- esto puede fallar si la propiedad no existe o no es escribible
            if parent[propName] ~= nil then
                parent[propName] = value
                return
            end

            error("No child nor property named " .. propName)
        end)
        if success then
            return true
        else
            return false, err
        end
    end

    local inst = targetObjOrParent
    local success, err = pcall(function()
        if inst:IsA("NumberValue") or inst:IsA("IntValue") then
            inst.Value = value
        elseif inst:IsA("BoolValue") then
            inst.Value = (value ~= 0)
        elseif inst:IsA("RemoteEvent") then
            inst:FireServer(value)
        else
            -- intentar asignar .Value si existe
            if inst:FindFirstChild("Value") and (inst.Value ~= nil) then
                inst.Value = value
                return
            end
            -- intentar asignar propiedad Speed o similar
            if inst["Speed"] ~= nil then
                inst["Speed"] = value
                return
            end
            -- si es BasePart y queremos forzar velocidad no es recomendable;
            -- simplemente error si no encontramos nada para escribir
            error("No writable field found on instance: " .. inst.ClassName)
        end
    end)
    if success then
        return true
    else
        return false, err
    end
end

-- Coroutine worker para cada target
local function startWorker(t)
    if coroutines[t.key] then return end
    local co = coroutine.create(function()
        while enabled[t.key] do
            local resolved1, resolved2 = resolvePath(t.path)
            local valueNumber = tonumber(t.userValue) or defaultSpeedValue

            local ok, err
            if resolved2 then
                -- resolved1 es parent y resolved2 es propiedad/childName
                ok, err = applyValueToTarget(resolved1, resolved2, valueNumber)
            else
                ok, err = applyValueToTarget(resolved1, nil, valueNumber)
            end

            if not ok then
                -- Silenciosamente continuar; podría actualizar UI con el error
                -- print("AutoTrainSpeed: error applying to " .. t.label .. " -> " .. tostring(err))
            end

            -- Frecuencia: 0.3 segundos por defecto
            wait(0.3)
        end
    end)
    coroutines[t.key] = co
    coroutine.resume(co)
end

local function stopWorker(t)
    coroutines[t.key] = nil
    enabled[t.key] = false
end

-- Build UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTrainSpeedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 320, 0, 160)
mainFrame.Position = UDim2.new(0, 10, 0, 100)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 6)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Parent = mainFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 28)
title.BackgroundTransparency = 1
title.Text = "Auto Train Speed"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame
title.LayoutOrder = 1
title.Position = UDim2.new(0, 8, 0, 6)

-- function to create one row for a target
local function makeRow(t)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -12, 0, 36)
    row.BackgroundTransparency = 0.3
    row.BackgroundColor3 = Color3.fromRGB(50,50,50)
    row.Parent = mainFrame
    row.LayoutOrder = #mainFrame:GetChildren() + 1

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = t.label
    label.TextColor3 = Color3.fromRGB(240,240,240)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local txtBox = Instance.new("TextBox")
    txtBox.Size = UDim2.new(0.25, 0, 0.9, 0)
    txtBox.Position = UDim2.new(0.55, 6, 0.05, 0)
    txtBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
    txtBox.TextColor3 = Color3.fromRGB(0,0,0)
    txtBox.Text = tostring(defaultSpeedValue)
    txtBox.Font = Enum.Font.SourceSans
    txtBox.TextSize = 14
    txtBox.ClearTextOnFocus = false
    txtBox.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.17, 0, 0.9, 0)
    toggle.Position = UDim2.new(0.82, -6, 0.05, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(200,40,40)
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 14
    toggle.Text = "OFF"
    toggle.Parent = row

    -- status label (small)
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 14)
    status.Position = UDim2.new(0, 6, 1, -16)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 11
    status.Text = "Estado: Desconocido"
    status.Parent = row

    -- Interactividad
    toggle.MouseButton1Click:Connect(function()
        enabled[t.key] = not enabled[t.key]
        if enabled[t.key] then
            toggle.Text = "ON"
            toggle.BackgroundColor3 = Color3.fromRGB(40,160,40)
            -- store current value in target table
            t.userValue = txtBox.Text
            status.Text = "Estado: Activado"
            startWorker(t)
        else
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(200,40,40)
            status.Text = "Estado: Desactivado"
            stopWorker(t)
        end
    end)

    txtBox.FocusLost:Connect(function(enterPressed)
        t.userValue = txtBox.Text
    end)

    -- inicializamos el userValue
    t.userValue = txtBox.Text
end

-- Crear filas para cada objetivo
for _, t in ipairs(targets) do
    makeRow(t)
end

-- Agrega botón de cerrar/mostrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = mainFrame

local collapsed = false
local savedSize = mainFrame.Size
closeBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        mainFrame.Size = UDim2.new(0, 120, 0, 36)
        closeBtn.Text = ">"
    else
        mainFrame.Size = savedSize
        closeBtn.Text = "X"
    end
end)

-- Final: nota visible
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -10, 0, 18)
footer.BackgroundTransparency = 1
footer.Text = "Nota: si no funciona, el servidor controla la propiedad o se requiere otro método."
footer.TextColor3 = Color3.fromRGB(180,180,180)
footer.Font = Enum.Font.SourceSansItalic
footer.TextSize = 11
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = mainFrame

-- Garantizar limpieza al morir el personaje
player.CharacterAdded:Connect(function()
    -- opcional: si quieres detener al reaparecer, descomentar:
    -- for _, t in ipairs(targets) do enabled[t.key] = false end
end)

print("AutoTrainSpeed GUI loaded.")
