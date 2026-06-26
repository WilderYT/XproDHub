-- ============================================================
-- DELTA SCRIPT – SIMULACIÓN DE 6 TECLAS PARA AUTO-FARM
-- Lista de teclas: A, X, Z, C, V, B (modifica según necesites)
-- ============================================================
local UIS = game:GetService("UserInputService")
local KEY_LIST = {
    Enum.KeyCode.A,
    Enum.KeyCode.X,
    Enum.KeyCode.Z,
    Enum.KeyCode.C,
    Enum.KeyCode.V,
    Enum.KeyCode.B
}
local KEY_NAMES = {}
for _, k in ipairs(KEY_LIST) do KEY_NAMES[k.Name] = true end

-- Sobrescritura de IsKeyDown para que siempre devuelva true
local oldIsKeyDown = UIS.IsKeyDown
UIS.IsKeyDown = function(self, keyCode)
    if KEY_NAMES[keyCode.Name] then return true end
    return oldIsKeyDown(self, keyCode)
end

-- Sobrescritura de la global isKeyDown (si existe)
if _G.isKeyDown then
    local oldGlobal = _G.isKeyDown
    _G.isKeyDown = function(key)
        if type(key) == "string" and KEY_NAMES[key:upper()] then
            return true
        end
        return oldGlobal(key)
    end
end

-- Bucle de simulación de pulsaciones (activa las habilidades constantemente)
spawn(function()
    while task.wait(0.12) do  -- ajusta el tiempo si quieres más o menos rapidez
        for _, key in ipairs(KEY_LIST) do
            keydown(key)
            task.wait(0.03)
            keyup(key)
            task.wait(0.02)
        end
    end
end)

print("[ACTIVADO] Simulación de 6 teclas para auto-farm.")
