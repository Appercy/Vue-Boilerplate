--[[
    Tutorial Commands and Examples
    Shows how to use the NUI system with different commands
    
    @author: Your Name
    @description: DELETE THIS FILE to remove all tutorial examples
--]]

--[[
    Main command to open the NUI interface
    Usage: /opennui or /ui
--]]
RegisterCommand('opennui', function()
    print("^2[NUI-Boilerplate] Opening main NUI interface^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end, false)

-- Alternative command name
RegisterCommand('ui', function()
    print("^2[NUI-Boilerplate] Opening UI^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end, false)

--[[
    Command to open UI and navigate to Dashboard tab
    Usage: /dashboard
--]]
RegisterCommand('dashboard', function()
    print("^2[NUI-Boilerplate] Opening Dashboard^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
    
    -- Small delay then navigate to dashboard
    Wait(100)
    SendNUIMessage({
        action = "navigateTo",
        route = "/"
    })
end, false)

--[[
    Command to open UI and navigate to Settings tab
    Usage: /settings
--]]
RegisterCommand('settings', function()
    print("^2[NUI-Boilerplate] Opening Settings^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
    
    -- Small delay then navigate to settings
    Wait(100)
    SendNUIMessage({
        action = "navigateTo",
        route = "/settings"
    })
end, false)

--[[
    Example: Send player data to NUI manually (for testing)
    Usage: /senddata
--]]
RegisterCommand('senddata', function()
    print("^2[NUI-Boilerplate] Manually sending player data to NUI^7")
    
    -- Get current player info
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Create fake player data for testing
    local testPlayerData = {
        name = GetPlayerName(PlayerId()),
        money = math.random(1000, 10000),
        bank = math.random(5000, 50000),
        job = "Police Officer",
        jobLabel = "LSPD",
        grade = 3,
        coords = {
            x = math.floor(coords.x),
            y = math.floor(coords.y),
            z = math.floor(coords.z)
        },
        health = GetEntityHealth(playerPed),
        framework = "TEST"
    }
    
    -- Send to NUI
    SendNUIMessage({
        action = "updatePlayerData",
        data = testPlayerData
    })
    
    print("^2[NUI-Boilerplate] Test player data sent to NUI^7")
end, false)

--[[
    Example: Test server data update
    Usage: /sendserver
--]]
RegisterCommand('sendserver', function()
    print("^2[NUI-Boilerplate] Sending test server data to NUI^7")
    
    local testServerData = {
        serverName = "Test Server",
        onlinePlayers = math.random(10, 64),
        maxPlayers = 64,
        serverTime = os.date('%H:%M:%S'),
        framework = "TEST"
    }
    
    SendNUIMessage({
        action = "updateServerData",
        data = testServerData
    })
    
    print("^2[NUI-Boilerplate] Test server data sent to NUI^7")
end, false)

--[[
    Example: Show notification in UI
    Usage: /notify [message] [type]
    Types: success, error, info
--]]
RegisterCommand('notify', function(source, args, rawCommand)
    local message = table.concat(args, " ", 1) or "Test notification"
    local notifType = args[#args] -- Last argument as type
    
    -- Check if last word is a valid type
    if notifType ~= "success" and notifType ~= "error" and notifType ~= "info" then
        notifType = "info"
    else
        -- Remove type from message
        message = table.concat(args, " ", 1, #args - 1)
    end
    
    print("^2[NUI-Boilerplate] Sending notification: " .. message .. " (type: " .. notifType .. ")^7")
    
    SendNUIMessage({
        action = "showNotification",
        message = message,
        type = notifType
    })
end, false)

--[[
    Example: Close NUI from command
    Usage: /closenui
--]]
RegisterCommand('closenui', function()
    print("^2[NUI-Boilerplate] Closing NUI from command^7")
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hide"
    })
end, false)

--[[
    Debug: Print all available commands
    Usage: /nuihelp
--]]
RegisterCommand('nuihelp', function()
    print("^2[NUI-Boilerplate] Available Commands:^7")
    print("^3/opennui^7 or ^3/ui^7 - Open the main NUI interface")
    print("^3/dashboard^7 - Open UI to Dashboard tab")  
    print("^3/settings^7 - Open UI to Settings tab")
    print("^3/senddata^7 - Send test player data to UI")
    print("^3/sendserver^7 - Send test server data to UI")
    print("^3/notify [message] [type]^7 - Show notification (types: success, error, info)")
    print("^3/closenui^7 - Close the NUI interface")
    print("^3/testframework^7 - Test framework detection (server command)")
    print("^3/nuihelp^7 - Show this help message")
    print("^1Note:^7 The main functionality uses the buttons in the UI!")
end, false)

--[[
    Print helpful information when resource starts
--]]
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(2000) -- Wait for framework detection
        print("^2======================================^7")
        print("^2[NUI-Boilerplate] Tutorial Examples Loaded^7")
        print("^3Framework Detected: " .. (Framework.Type or "None") .. "^7")
        print("^3Type ^3/nuihelp^7 for available commands")
        print("^1DELETE client/examples/tutorial_examples.lua to remove examples^7")
        print("^2======================================^7")
    end
end)
