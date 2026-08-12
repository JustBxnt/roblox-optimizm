# 🎮 Roblox Optimization Script

Roblox game optimization script with FPS limiter, black overlay, RAM monitor, and auto-sell functionality.

## 🚀 Features

- ✅ **FPS Limiter** - Cap FPS to 2 for maximum resource saving
- ✅ **Black Overlay UI** - Dark screen overlay with real-time stats
- ✅ **RAM Monitor** - Display current memory usage
- ✅ **Sheckles Display** - Show in-game money with formatting
- ✅ **Auto-Sell Fruits** - Automatic fruit selling (GitHub method)
- ✅ **Daily Deals Checker** - Detect when daily deals are available
- ✅ **Timer** - Track elapsed time
- ✅ **RAM Auto Cleaner** - Automatic garbage collection every 15s
- ✅ **Extreme Optimization** - Remove textures, particles, lighting effects

## 📦 Installation

### Method 1: LoadString (Recommended)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
```

### Method 2: Copy & Paste

1. Copy the content of `sc_real.lua`
2. Paste into your executor
3. Execute

## 🎯 Game Support

Currently optimized for: **Growing A Garden 2**

### Auto-Sell Method

Uses GitHub proven method:
```lua
local Networking = require(ReplicatedStorage.SharedModules.Networking)
Networking.NPCS.SellAll:Fire()
```

With 2 fallback methods for maximum compatibility.

## ⚙️ Configuration

Edit the `CONFIG` table at the top of script:

```lua
local CONFIG = {
    TargetFPS              = 2,      -- Target FPS (1-60)
    ShowBlackOverlay      = true,   -- Show UI overlay
    ExtremeDestroy        = true,   -- Remove textures/particles
    AntiFallPlatform      = true,   -- Anti-fall platform
    DisableGameSounds     = true,   -- Mute game sounds
    DisableParticles      = true,   -- Remove particle effects
    DisableLightingEffects= true,   -- Remove lighting
    Disable3DRendering    = true,   -- Disable 3D rendering
    DisableCoreGui        = true,   -- Hide Roblox UI
    AutoCleanRAM          = true,   -- Auto garbage collection
    CleanRAMInterval      = 15      -- GC interval (seconds)
}
```

## 📊 UI Display

The overlay shows:
- **FPS**: Current frames per second
- **RAM**: Memory usage in MB
- **Sheckles**: In-game money
- **Daily Deals**: Status (READY/NOT READY)
- **Time**: Elapsed time (HH:MM:SS)
- **Sell Button**: Manual sell all fruits

## 🎨 UI Layout

```
┌─────────────────────────────┐
│ FPS : 2                     │
│ RAM : 420 MB                │
│ Sheckles : 12,450           │
│ Daily Deals : READY         │
│ ┌─────────────────────────┐ │
│ │   SELL ALL FRUITS       │ │
│ └─────────────────────────┘ │
│ Time: 01:23:45              │
└─────────────────────────────┘
```

## 🔧 Functions

### `getSheckles()`
Get current in-game money from leaderstats or Data folder.

### `formatNumber(n)`
Format numbers with comma separator (1234567 → 1,234,567).

### `checkDailyDeals()`
Check if daily deals are ready to claim.

### `sellFruits()`
Sell all fruits with 3-tier method:
1. **GitHub Method** (Primary)
2. **RemoteEvent Search** (Fallback)
3. **Tool-based** (Last Resort)

## 📈 Performance

**Before:**
- FPS: 60
- RAM: 1200 MB
- Textures: ✅ Enabled
- Particles: ✅ Enabled

**After:**
- FPS: 2 ✅
- RAM: 400 MB ✅
- Textures: ❌ Destroyed
- Particles: ❌ Destroyed

## ⚠️ Disclaimer

This script is for educational purposes only. Use at your own risk.

- ✅ **Safe features**: FPS limit, RAM monitor, UI overlay
- ⚠️ **Moderate risk**: Auto-sell (uses game API)
- ❌ **Not included**: Exploits, hacks, memory manipulation

## 🐛 Troubleshooting

### "Networking module not found"
- Game may have updated module path
- Use fallback methods (automatically attempted)

### "Sell not working"
- Ensure you have fruits in inventory
- Check if GitHub method is available (Test 7)
- Try manual sell button first

### "Low FPS even with limit"
- Wait 5-10 seconds for optimization to take effect
- Check if Disable3DRendering is enabled
- Ensure AutoCleanRAM is active

## 📚 Credits

- **Auto-Sell Method**: [Lutosys/opensrc](https://github.com/Lutosys/opensrc)
- **Optimization**: Custom implementation
- **UI Design**: Custom design

## 📝 Changelog

### v2.0 (Current)
- ✅ Added GitHub auto-sell method
- ✅ Added 3-tier selling system
- ✅ Improved daily deals detection
- ✅ Added draggable UI
- ✅ Enhanced error handling

### v1.0
- Initial release
- Basic optimization features

## 📞 Support

For issues or questions, open an issue on GitHub.

## 📄 License

MIT License - Free to use and modify.

---

**Last Updated:** 2026-08-12  
**Status:** ✅ Production Ready  
**Tested On:** Growing A Garden 2
