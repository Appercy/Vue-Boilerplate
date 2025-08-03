-- Shared Configuration for NUI Boilerplate
Config = {}

-- Debug mode (set to false in production)
Config.Debug = true

-- UI Settings
Config.UI = {
    -- Default keybind to open UI (can be changed)
    defaultKey = "F1",
    
    -- Animation settings
    animationDuration = 300, -- ms
    
    -- Sound settings
    enableSounds = true,
}

-- Example settings (remove if not needed)
Config.Examples = {
    -- Enable tutorial examples
    enabled = true,
    
    -- Example commands prefix
    commandPrefix = "",
    
    -- Example vehicle models for spawning
    vehicles = {
        "adder",
        "zentorno", 
        "t20",
        "vacca"
    }
}

-- Framework detection (uncomment what you use)
-- Config.Framework = "esx" -- ESX
-- Config.Framework = "qb" -- QBCore  
-- Config.Framework = "standalone" -- No framework
Config.Framework = "standalone"