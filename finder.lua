-- Leaked by collin full source
 
--CONFIG
getgenv().webhook = "https://discord.com/api/webhooks/1406303704931500185/4OUN86Y9YcLV1djaQ0sY61ZVLQdW6oHl6L1ylQrWAIEFt45uWNUJ_3t3Tbz0Aem5I__U"
getgenv().websiteEndpoint = nil
 
-- Allowed place IDs
local allowedPlaceIds = {
    [96342491571673] = true, -- New Players Server
    [109983668079237] = true -- Normal
}
 
getgenv().TargetPetNames = {
    "Graipuss Medussi",
    "La Grande Combinasion", "Garama and Madundung", "Sammyni Spyderini",
    "Pot Hotspot",
    "Nuclearo Dinossauro",  
    "Chicleteira Bicicleteira", "Los Combinasionas", "Dragon Cannelloni",
    "Unclito Samito",
 
}
 
-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
 
-- PRIVATE SERVER CHECK (works for VIP + Reserved)
local function isPrivateServer()
    return (game.PrivateServerId and game.PrivateServerId ~= "")
        or (game.VIPServerId and game.VIPServerId ~= "")
end
 
local function buildJoinLink(placeId, jobId)
    return string.format(
        "https://chillihub1.github.io/chillihub-joiner/?placeId=%d&gameInstanceId=%s",
        placeId,
        jobId
    )
end
 
-- KICK CHECKS
if isPrivateServer() then
    LocalPlayer:Kick("Kicked because in private server")
    return
elseif not allowedPlaceIds[game.PlaceId] then
    local joinLink = buildJoinLink(game.PlaceId, game.JobId)
    LocalPlayer:Kick("Kicked because wrong game\nClick to join server:\n" .. joinLink)
    return
end
 
-- WEBHOOK SEND
local function sendWebhook(foundPets, jobId)
    local petCounts = {}
    for _, pet in ipairs(foundPets) do
        petCounts[pet] = (petCounts[pet] or 0) + 1
    end
 
    local formattedPets = {}
    for petName, count in pairs(petCounts) do
        table.insert(formattedPets, petName .. (count > 1 and " x" .. count or ""))
    end
 
    local joinLink = buildJoinLink(game.PlaceId, jobId)
 
    local embedData = {
        username = "Leaked by collin gng",
        embeds = { {
            title = "🐾 Pet(s) Found!",
            description = "**Pet(s):**\n" .. table.concat(formattedPets, "\n"),
            color = 65280,
            fields = {
                {
                    name = "Players",
                    value = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers),
                    inline = true
                },
                {
                    name = "Job ID",
                    value = jobId,
                    inline = true
                },
                {
                    name = "Join Link",
                    value = string.format("[Click to join server](%s)", joinLink),
                    inline = false
                }
            },
            footer = { text = "Leaked by collin gng" },
            timestamp = DateTime.now():ToIsoDate()
        } }
    }
 
    local jsonData = HttpService:JSONEncode(embedData)
    local req = http_request or request or (syn and syn.request)
    if req then
        local success, err = pcall(function()
            req({
                Url = getgenv().webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end)
        if success then
            print("✅ Webhook sent")
        else
            warn("❌ Webhook failed:", err)
        end
    else
        warn("❌ No HTTP request function available")
    end
end
 
-- PET CHECK
local function checkForPets()
    local found = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local nameLower = string.lower(obj.Name)
            for _, target in pairs(getgenv().TargetPetNames) do
                if string.find(nameLower, string.lower(target)) then
                    table.insert(found, obj.Name)
                    break
                end
            end
        end
    end
    return found
end
 
-- MAIN LOOP
task.spawn(function()
    while true do
        local petsFound = checkForPets()
        if #petsFound > 0 then
            print("✅ Pets found:", table.concat(petsFound, ", "))
            sendWebhook(petsFound, game.JobId)
        else
            print("🔍 No pets found")
        end
        task.wait(15)
    end
end)
