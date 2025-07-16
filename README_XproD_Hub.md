# XproD Hub - Sistema Mejorado de Entrenamiento

## 🚀 Nuevas Características Añadidas

### ⚔️ Train Sword Optimizado
- **Clicks soportables**: Delays de 0.3s base con variación aleatoria (0-0.05s)
- **Sistema anti-detección**: Variaciones aleatorias para evitar patrones detectables
- **Auto-ajuste de lag**: Se adapta automáticamente si detecta lag en el juego
- **FireServer seguro**: Uso de `pcall()` para manejar errores sin crashear

### 🏃 Speed & Agility Training Completos
- **Funciones implementadas**: Ahora Speed y Agility training funcionan completamente
- **Delays optimizados**: 0.35s base con variación aleatoria para ser naturales
- **Sistema inteligente**: Se ajusta según el rendimiento del juego

### 🔧 Mejoras Técnicas

#### Sistema Anti-Lag
```lua
local function getOptimalDelay(baseDelay)
    -- Detecta lag y ajusta delays automáticamente
    -- Si hay lag > 0.1s, aumenta el delay para evitar sobrecarga
end
```

#### Control de Concurrencia
```lua
local activeLoops = {}
-- Evita múltiples loops del mismo tipo ejecutándose simultáneamente
-- Previene sobrecargas y conflictos
```

#### Clicks Seguros
```lua
local function trainSword()
    pcall(function()
        Remote.SwordTrainingEvent:FireServer()
        Remote.SwordPopUpEvent:FireServer()
    end)
end
```

### 🛡️ Sistema Anti-AFK Mejorado
- **Movimientos sutiles**: Movimiento de 0.1 studs cada 60 segundos
- **Indetectable**: Cambios mínimos de posición que no llaman la atención
- **Inteligente**: Solo se activa cuando es necesario

## 📖 Instrucciones de Uso

### 1. Carga del Script
```lua
loadstring(game:HttpGet("tu_url_del_script"))()
```

### 2. Configuración Train Sword
1. **Equipa tu espada**: Ve al menú Swords y equipa la espada que quieres usar
2. **Activa Train Sword**: Usa el switch en la GUI
3. **¡Automático!**: El script comenzará a hacer clicks cada 0.3-0.35s

### 3. Configuraciones Recomendadas

#### Para Máxima Seguridad:
- ✅ Train Sword: ON
- ✅ Anti-AFK: ON  
- ❌ Bring Bandits: OFF (puede llamar atención)

#### Para Farmeo Rápido:
- ✅ Train Sword: ON
- ✅ Auto Farm Bandit: ON
- ✅ Bring Bandits: ON

## ⚡ Características de Seguridad

### Delays Optimizados
| Función | Delay Base | Variación | Total |
|---------|------------|-----------|-------|
| Train Sword | 0.30s | 0-0.05s | 0.30-0.35s |
| Train Speed | 0.35s | 0-0.10s | 0.35-0.45s |
| Train Agility | 0.35s | 0-0.10s | 0.35-0.45s |
| Attack Bandit | 0.25s | 0-0.05s | 0.25-0.30s |

### Sistema de Protección
- **Error Handling**: `pcall()` en todas las funciones críticas
- **Detección de Lag**: Ajusta velocidad automáticamente
- **Variación Aleatoria**: Evita patrones detectables
- **Control de Loops**: Previene sobrecargas

## 🎯 Ventajas del Sistema Mejorado

1. **Más Natural**: Los delays variables imitan el comportamiento humano
2. **Mejor Rendimiento**: Se adapta al lag del servidor
3. **Mayor Seguridad**: Menos probabilidad de detección
4. **Más Estable**: Manejo de errores robusto
5. **Optimizado**: No consume recursos innecesarios

## 🔄 Monitoreo del Sistema

El script incluye notificaciones que te informan:
- ✅ Cuando se carga correctamente
- ⚔️ Estado del Train Sword
- 🎯 Ajustes automáticos de lag
- 🔄 Estado del Anti-AFK

## 📝 Notas Importantes

1. **Equipa tu espada manualmente** al menos una vez antes de activar Train Sword
2. **El script auto-equipa** la espada solo después de respawn/muerte
3. **Los delays son seguros** para Roblox, pero siempre usa con moderación
4. **El sistema se auto-optimiza** según el rendimiento de tu dispositivo

## 🆘 Solución de Problemas

### Si Train Sword no funciona:
1. Verifica que tienes una espada equipada
2. Asegúrate de estar en el área de entrenamiento
3. Revisa que el switch esté activado

### Si hay lag:
- El sistema se ajustará automáticamente
- Los delays aumentarán para compensar
- Se mostrará en la consola: "Sistema anti-lag activado"

---

**¡Disfruta del farmeo automatizado y seguro!** 🎮⚔️