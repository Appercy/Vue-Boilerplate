# FiveM NUI Boilerplate with Framework Integration

A **clean and modern** FiveM NUI boilerplate using **Vue 3**, **TailwindCSS**, and **Vue Router** with **automatic framework detection** and unified data access.

## ✨ Features

- 🎯 **Clean & Modern**: Beautiful TailwindCSS styling
- 🧩 **Modular Design**: Easy to remove demo components for clean slate
- 🔄 **Vue Router**: Optional routing system (easily removable)
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **TailwindCSS**: Utility-first CSS framework included
- 🔧 **Hot Reload**: Development server with live updates
- 📚 **Beginner Friendly**: Comprehensive documentation and examples
- 🏗️ **Framework Integration**: Auto-detects ESX/QBCore/QBox with unified callback system
- 🔒 **Production Ready**: Optimized build process and proper focus management

## 🏗️ Framework Integration

This boilerplate includes **automatic framework detection** and **unified callback system** for popular FiveM frameworks:

### Supported Frameworks
- **✅ ESX Legacy** - Automatically detected and integrated
- **✅ QBCore** - Seamless integration with QB callback system
- **✅ QBox (QBX)** - Full compatibility with QBox callback system
- **✅ Standalone** - Works without any framework as fallback

### Framework Features
- **🔍 Auto-Detection**: Automatically detects your framework on startup
- **🔗 Unified Callbacks**: Uses proper framework callback systems (ESX.TriggerServerCallback, QB.TriggerCallback, etc.)
- **📊 Real Data**: Get actual player money, jobs, and data from your framework database
- **🔐 Server-Side Security**: All data requests go through secure server-side callbacks
- **⚡ Optimized**: Single "Get Data" button retrieves both player and server data

### Demo Components
- **📊 Dashboard**: Shows player data, server info, and framework detection
- **⚙️ Settings**: Simple UI scale adjustment (0.8x - 1.5x) with localStorage persistence
- **🎮 Actions**: Heal player and spawn vehicle examples
- **📝 F8 Console Export**: Settings export to FiveM console (not browser console)

### Example Usage
```lua
-- Client-side: Get all data using framework callbacks
Framework.TriggerCallback('nui:getAllData', function(result)
    -- result.playerData contains real framework data
    -- result.serverData contains server information
end)

-- Server-side: Unified data access
local playerData = Framework.GetPlayerDataServer(source)
-- Works with ESX, QB, QBX automatically
```

## 🚀 Quick Start

### 1. Installation
1. Download/clone this repository to your FiveM resources folder
2. Navigate to the `html` folder
3. Install dependencies:
   ```bash
   npm install
   ```

### 2. Development
Start the development server for hot reload:
```bash
npm run dev
```
Visit `http://localhost:5173` to see your UI in the browser.

### 3. Build for Production
Build the optimized version for FiveM:
```bash
npm run build
```

### 4. Start Resource
Write in your Server Console
```
start 'NUI-Boilerplate'

## 🎮 Available Commands

### Main Commands
- `/opennui` or `/ui` - Open the main NUI interface
- `/dashboard` - Open UI directly to Dashboard tab
- `/settings` - Open UI directly to Settings tab
- `/closenui` - Close the NUI interface

### Testing Commands  
- `/senddata` - Send test player data to UI (for testing)
- `/sendserver` - Send test server data to UI (for testing)
- `/notify [message] [type]` - Show notification (types: success, error, info)
- `/testframework` - Test framework detection (server command)
- `/nuihelp` - Show all available commands

**Note:** The main functionality (Get Data, Heal Player, Spawn Vehicle) uses the buttons in the UI and works with your framework automatically!

## 🔧 Framework System Details

### Auto-Detection Process
The system automatically detects your framework on resource start:

```lua
-- ESX Detection
if GetResourceState('es_extended') == 'started' then
    Framework.Type = 'ESX'
    Framework.Object = exports['es_extended']:getSharedObject()

-- QBCore Detection  
elseif GetResourceState('qb-core') == 'started' then
    Framework.Type = 'QB'
    Framework.Object = exports['qb-core']:GetCoreObject()

-- QBox Detection
elseif GetResourceState('qbx_core') == 'started' then
    Framework.Type = 'QBX'
    Framework.Object = exports.qbx_core
    
-- Standalone Fallback
else
    Framework.Type = 'STANDALONE'
end
```

### Unified Callback System
Instead of different callback methods for each framework, use the unified system:

```lua
-- Client-side callback trigger
Framework.TriggerCallback('callbackName', function(result)
    -- Handle result
end, arg1, arg2)

-- Server-side callback registration
Framework.RegisterCallback('callbackName', function(source, arg1, arg2)
    -- Process request
    return result
end)
```

### Data Mapping
The system automatically maps framework data to a unified format:

| Framework | Player Data Source | Unified Output |
|-----------|-------------------|----------------|
| **ESX** | `xPlayer.getName()`, `xPlayer.getMoney()` | `{name, money, bank, job, jobLabel, grade, identifier}` |
| **QBCore** | `player.PlayerData.charinfo`, `player.PlayerData.money` | Same unified format |
| **QBox** | `player.PlayerData` (QBX format) | Same unified format |
| **Standalone** | Generated fallback data | Same unified format |

## 🚫 Want to Remove Vue Router?

This boilerplate **includes Vue Router by default** for demonstration purposes, but many simple FiveM UIs don't need routing complexity.

### Quick Router Removal:
1. **Delete router files**:
   ```bash
   rm -rf html/src/router/
   rm html/src/components/examples/
   ```

2. **Update `main.js`**:
   ```javascript
   import './assets/base.css'
   import { createApp } from 'vue'
   import App from './App.vue'
   
   createApp(App).mount('#app')
   ```

3. **Remove router from `MainDemo.vue`**:
   - Delete the navigation section
   - Delete `<router-view />` and `<router-link>` components

4. **Update `package.json`** (remove router dependency):
   ```bash
   npm uninstall vue-router
   ```

## 🧹 Getting a Clean Slate

### Method 1: Remove Demo Components
1. **Delete the demo file**: `rm html/src/components/MainDemo.vue`
2. **Uncomment the clean template** in `App.vue`
3. **Remove demo imports** from `App.vue`

### Method 2: Start Fresh
Replace the content of `MainDemo.vue` with your own components.

## 📁 Project Structure

```
NUI-Boilerplate/
├── fxmanifest.lua                 # FiveM resource manifest
├── README.md                      # This file
├── client/
│   ├── client.lua                 # Main client logic with unified callbacks
│   └── examples/
│       └── tutorial_examples.lua  # Example commands (delete to remove)
├── server/
│   └── examples/
│       └── framework_examples.lua # Server-side framework callbacks
├── shared/
│   ├── config.lua                 # Configuration
│   └── framework.lua              # Framework detection and unified system
└── html/
    ├── package.json               # NPM dependencies
    ├── vite.config.js             # Vite configuration
    ├── tailwind.config.js         # TailwindCSS configuration
    ├── dist/                      # Built files (auto-generated)
    └── src/
        ├── App.vue                # Main Vue app
        ├── main.js                # Vue app entry point
        ├── components/
        │   ├── MainDemo.vue          # Main demo component (delete to remove)
        │   ├── SimpleExample.vue     # Simple example component
        │   └── examples/             # Router example components
        │       ├── Dashboard.vue     # Dashboard route example  
        │       └── Settings.vue      # Settings route (UI scale only)
        ├── router/
        │   └── index.js           # Vue Router setup (delete if not needed)
        └── assets/
            └── base.css           # TailwindCSS imports
```

## 🔧 Customization

### TailwindCSS Configuration
Edit `html/tailwind.config.js` to customize your design system:

```javascript
module.exports = {
  content: ['./index.html', './src/**/*.{vue,js}'],
  theme: {
    extend: {
      colors: {
        primary: '#your-color',
      }
    }
  }
}
```

### Vue Configuration  
Edit `html/vite.config.js` for build customization:

```javascript
export default defineConfig({
  plugins: [vue()],
  base: './',
  build: {
    outDir: 'dist',
    assetsDir: 'assets'
  }
})
```

## 🐛 Troubleshooting

### Issue: "Network response was not ok" errors
**Solution**: 
1. Restart the resource: `restart NUI-Boilerplate`
2. Check FiveM console for Lua errors
3. Verify framework detection with `/frameworkinfo`

### Issue: UI not opening
**Solution**:
1. Check `html/dist/index.html` exists (run `npm run build`)
2. Verify resource is started in FiveM
3. Try `/ui` or `/opennui` command

### Issue: Framework not detected
**Solution**:
1. Ensure your framework resource is started before this resource
2. Check framework resource names match (es_extended, qb-core, qbx_core)
3. Look for colored detection messages in console

### Issue: Buttons not working
**Solution**:
1. Check browser console (F8) for JavaScript errors
2. Verify NUI callbacks are registered (check Lua console)
3. Ensure resource name matches between Vue and Lua

### Expected Console Output (when working):
**Vue side:**
```
Get Data button clicked - using unified callback system
Sending request to: https://NUI-Boilerplate/getData
Response status: 200 OK
Response text: {"success":true,"message":"Data retrieved using ESX framework"}
```

**Lua side:**
```
[Framework] ESX Legacy detected
[NUI-Boilerplate] GetData callback triggered - using framework callbacks
[NUI-Boilerplate] Received unified data from server
```

## 🤝 Contributing

Feel free to submit issues, suggestions, or pull requests to improve this boilerplate!

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**🎯 Ready to build amazing FiveM UIs!**
