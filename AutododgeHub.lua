-- Server Hop REAL + ESP Brainrots PREMIUM/GOD
-- Cambia entre servidores públicos buscando brainrots automáticamente

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PLACE_ID = game.PlaceId

local SECRET_BRAINROTS = {
    ["La Vacca Saturno Saturnita"] = true,
    ["Chimpanzini Spiderini"] = true,
    ["Los Tralaleritos"] = true,
    ["Las Tralaleritas"] = true,
    ["Las Vaquitas Saturnitas"] = true,
    ["Graipuss Medussi"] = true,
    ["Chicleteira Bicicleteira"] = true,
    ["La Grande Combinasion"] = true,
    ["Nuclearo Dinossauro"] = true,
    ["Garama and Madundung"] = true,
    ["Lucky Block Torrtuginni Dragonfrutini"] = true,
    ["Pot Hotspot"] = true,
    ["Cocofanto Elefanto"] = true,
    ["Girafa Celestre"] = true,
    ["Gattatino Neonino"] = true,
    ["Matteo"] = true,
    ["Tralalero Tralala"] = true,
    ["Los Crocodillitos"] = true,
    ["Espresso Signora"] = true,
    ["Odin Din Din Dun"] = true,
    ["Statutino Libertino"] = true,
    ["Trenostruzzo Turbo 3000"] = true,
    ["Ballerino Lololo"] = true,
    ["Piccione Macchina"] = true,
    ["Orcalero Orcala"] = true,
    ["Noobini Pizzanini"] = true
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

-- Limpia ESP
local function clearESP()
    for _, v in ipairs(espObjects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    espObjects = {}
end

-- Devuelve la Part principal de un Model o la Part directamente
local function getAdorneePart(obj)
    if obj:IsA("BasePart") then
        return obj
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart end
        for _, part in ipairs(obj:GetChildren()) do
            if part:IsA("BasePart") then
                return part
            end
        end
    end
    return nil
end

-- ESP visual
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

-- Scan server actual
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

-- ESP masivo
local function espAllBrainrots(brainrotList)
    clearESP()
    for _, name in ipairs(brainrotList) do
        createESP(name)
    end
end

-- Obtiene servidores públicos (API Roblox, requiere HttpGet permitido)
local function getServerList()
    local url = "https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?sortOrder=Desc&limit=100"
    local success, servers = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if not success then
        print("❌ Tu executor NO permite HttpGet. Solo rejoin.")
        return nil
    end
    local decoded = HttpService:JSONDecode(servers)
    local ids = {}
    for _,server in pairs(decoded.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            table.insert(ids, server.id)
        end
    end
    return ids
end

-- Server hop REAL loop
local function hopLoop()
    print("🧠 Iniciando Server Hop Brainrots PREMIUM REAL...")
    local serverList = getServerList()
    if not serverList or #serverList == 0 then
        print("❌ No hay serverIds disponibles. Server hop automático NO disponible, solo rejoin.")
        return
    end
    for _,serverId in ipairs(serverList) do
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
            print("🎉 Brainrot PREMIUM encontrado:")
            for _, name in ipairs(found) do
                print("   • " .. name)
            end
            espAllBrainrots(found)
            print("✅ Te quedaste en este server. ESP ACTIVADO.")
            IS_HOPPING = false
            button.Text = "Server Hop: OFF"
            button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
            return
        else
            clearESP()
        end
        wait(1)
    end
    print("🧠 Fin del Server Hop REAL.")
end

-- Botón ON/OFF
button.MouseButton1Click:Connect(function()
    IS_HOPPING = not IS_HOPPING
    if IS_HOPPING then
        button.Text = "Server Hop: ON"
        button.BackgroundColor3 = Color3.new(0,0.6,0)
        print("🟢 Server Hop REAL ACTIVADO")
        hopLoop()
    else
        button.Text = "Server Hop: OFF"
        button.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
        clearESP()
        print("🔴 Server Hop REAL DESACTIVADO")
    end
end)

print("✅ Script REAL listo. Toca el botón para activar/desactivar el Server Hop REAL automático. El ESP marcará los brainrots premium/god cuando los encuentre.")
