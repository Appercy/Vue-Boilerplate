--[[
    Main Client Script
    Handles NUI communication and client-side events
    
    @author: Your Name
    @description: Core NUI functionality using unified callback system
--]]

--[[
    Test command to open the NUI
    Usage: /testui
--]]
RegisterCommand('testui', function()
    print("^2[NUI-Boilerplate] Opening test UI^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end, false)

--[[
    Debug command to open the debug page
    Usage: /debugui
--]]
RegisterCommand('debugui', function()
    print("^2[NUI-Boilerplate] Opening debug UI^7")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end, false)

--[[
    NUI Callbacks - Handle communication between Vue frontend and Lua backend
--]]

--[[
    Closes the NUI interface
--]]
RegisterNUICallback('closeUI', function(data, cb)
    print("^2[NUI-Boilerplate] Closing UI^7")
    SetNuiFocus(false, false)
    cb('ok')
end)

--[[
    Gets all player and server data
    Uses the unified callback system to work with any framework
--]]
RegisterNUICallback('getData', function(data, cb)
    print("^3[NUI-Boilerplate] Getting data from server^7")
    
    Framework.TriggerCallback('nui:getAllData', function(result)
        print("^2[NUI-Boilerplate] Received data from server^7")
        
        if result.success then
            -- Update player data in UI
            if result.playerData then
                SendNUIMessage({
                    action = "updatePlayerData",
                    data = result.playerData
                })
            end
            
            -- Update server data in UI
            if result.serverData then
                SendNUIMessage({
                    action = "updateServerData", 
                    data = result.serverData
                })
            end
            
            -- Show success message
            SendNUIMessage({
                action = "showNotification",
                message = result.message,
                type = "success"
            })
        end
        
        cb(result)
    end)
end)

--[[
    Heals the player using framework-specific methods
--]]
RegisterNUICallback('healPlayer', function(data, cb)
    print("^3[NUI-Boilerplate] Requesting player heal^7")
    
    Framework.TriggerCallback('nui:healPlayer', function(result)
        print("^2[NUI-Boilerplate] Received heal response^7")
        
        -- Show notification in UI
        SendNUIMessage({
            action = "showNotification",
            message = result.message,
            type = result.success and "success" or "error"
        })
        
        cb(result)
    end)
end)

--[[
    Spawns a vehicle for the player
--]]
RegisterNUICallback('spawnVehicle', function(data, cb)
    local model = data.model or "adder"
    print("^3[NUI-Boilerplate] Requesting vehicle spawn: " .. model .. "^7")
    
    Framework.TriggerCallback('nui:spawnVehicle', function(result)
        print("^2[NUI-Boilerplate] Received spawn response^7")
        
        -- Show notification in UI
        SendNUIMessage({
            action = "showNotification",
            message = result.message,
            type = result.success and "success" or "error"
        })
        
        cb(result)
    end, model)
end)

--[[
    Client Event Handlers - Handle events from server
--]]

--[[
    Heals the player to full health
--]]
RegisterNetEvent('framework:healPlayer')
AddEventHandler('framework:healPlayer', function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, 200)
    print("^2[NUI-Boilerplate] Player healed to full health^7")
end)

--[[
    Spawns a vehicle next to the player
    @param model string - Vehicle model to spawn
--]]
RegisterNetEvent('framework:spawnVehicle')
AddEventHandler('framework:spawnVehicle', function(model)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    print("^1[NUI-Boilerplate] Spawning vehicle: " .. model .. "^7")
    
    -- Load the vehicle model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    
    -- Spawn vehicle next to player
    local vehicle = CreateVehicle(model, playerCoords.x + 3.0, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    
    -- Clean up model from memory
    SetModelAsNoLongerNeeded(model)
    
    print("^2[NUI-Boilerplate] Vehicle spawned successfully^7")
end)