-- Server Hop REAL con lista manual + ESP Brainrots PREMIUM/GOD

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PLACE_ID = game.PlaceId

local SECRET_BRAINROTS = {
    ["La Vacca Saturno Saturnita"] = true, ["Chimpanzini Spiderini"] = true,
    -- ... (el resto de tus brainrots)
    ["Noobini Pizzanini"] = true
}

local SERVER_IDS = {
    -- Pega aquí tus serverIds (JobId), ejemplo:
    "943d0288-1254-48b0-bc00-8044f5f2e278",
    "dee8f823-37ec-4d3a-846f-37c99aa51060",
    -- Agrega más si quieres
}

local IS_HOPPING = false
local espObjects = {}

-- UI switch ON/OFF
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.1, 0, 0.1, 0)
button.Text = "Server Hop: OFF"
button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true

local function clearESP()
    for _, v in ipairs(espObjects) do
        if v and v.Parent then v:Destroy() end
    end
    espObjects = {}
end

local function getAdorneePart(obj)
    if obj:IsA("BasePart") then return obj
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart end
        for _, part in ipairs(obj:GetChildren()) do
            if part:IsA("BasePart") then return part end
        end
    end
    return nil
end

local function createESP(brainrotName)
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == brainrotName or v.Name:find(brainrotName) then
            local adornee = getAdorneePart(v)
            if adornee then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "BrainrotESP"
                box.Adornee = adornee
                box.Size = adornee.Size * 0.6
                box.Color3 = Color3.fromRGB(0, 255, 100)
                box.Transparency = 0.4
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = adornee
                table.insert(espObjects, box)

                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0,160,0,40)
                billboard.Adornee = adornee
                billboard.AlwaysOnTop = true
                billboard.Name = "BrainrotESPLabel"
                billboard.Parent = adornee

                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1,0,1,0)
                text.BackgroundTransparency = 1
                text.Text = "🧠 " .. brainrotName
                text.TextColor3 = Color3.fromRGB(0,255,100)
                text.TextStrokeTransparency = 0.2
                text.Font = Enum.Font.SourceSansBold
                text.TextScaled = true

                table.insert(espObjects, billboard)
            end
        end
    end
end

local function scanCurrentServer()
    local found = {}
    local eventsFolder = LocalPlayer.PlayerGui:FindFirstChild("ActiveEvents")
    if eventsFolder and eventsFolder:FindFirstChild("ActiveEvents") then
        local activeEvents = eventsFolder.ActiveEvents:GetChildren()
        for _, eventObj in ipairs(activeEvents) do
            if SECRET_BRAINROTS[eventObj.Name] then
                table.insert(found, eventObj.Name)
            end
        end
    end
    return found
end

local function espAllBrainrots(brainrotList)
    clearESP()
    for _, name in ipairs(brainrotList) do
        createESP(name)
    end
end

local function hopLoop()
    print("🧠 Iniciando Server Hop manual por serverIds...")
    for _,serverId in ipairs(SERVER_IDS) do
        if not IS_HOPPING then
            print("⏹ Server Hop detenido por usuario.")
            clearESP()
            return
        end
        print("🌎 Saltando a server: " .. serverId)
        TeleportService:TeleportToPlaceInstance(PLACE_ID, serverId, LocalPlayer)
        wait(10)
        local found = scanCurrentServer()
        if #found > 0 then
            print("🎉 Brainrot PREMIUM/GOD encontrado:")
            for _, name in ipairs(found) do
                print("   • " .. name)
            end
            espAllBrainrots(found)
            print("✅ Te quedaste en este server. ESP ACTIVADO.")
            IS_HOPPING = false
            button.Text = "Server Hop: OFF"
            button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
            break
        else
            clearESP()
        end
        wait(1)
    end
    print("🧠 Fin del Server Hop manual.")
end

button.MouseButton1Click:Connect(function()
    IS_HOPPING = not IS_HOPPING
    if IS_HOPPING then
        button.Text = "Server Hop: ON"
        button.BackgroundColor3 = Color3.new(0,0.6,0)
        print("🟢 Server Hop manual ACTIVADO")
        hopLoop()
    else
        button.Text = "Server Hop: OFF"
        button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
        clearESP()
        print("🔴 Server Hop manual DESACTIVADO")
    end
end)

print("✅ Script listo. Modifica la lista SERVER_IDS para recorrer servers reales y buscar brainrots con ESP.")
