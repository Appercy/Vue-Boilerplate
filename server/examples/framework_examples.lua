--[[
    Server Callback Examples
    Shows how to register server callbacks that work with all frameworks
    
    @author: Your Name
    @description: Example callbacks for NUI communication
--]]

-- Wait for framework to initialize before registering callbacks
AddEventHandler('framework:ready', function()
    print("^2[NUI-Boilerplate] Framework ready - registering callbacks^7")
    
    --[[
        Gets all player and server data
        @param source number - Player ID who requested data
        @param cb function - Callback to return data
    --]]
    Framework.RegisterCallback('nui:getAllData', function(source, cb)
        print("^3[NUI-Boilerplate] Player " .. source .. " requested data^7")
        
        -- Get player data from framework
        local playerData = Framework.GetPlayerDataServer(source)
        
        -- Add extra info if player exists
        if playerData then
            local playerPed = GetPlayerPed(source)
            if playerPed > 0 then
                local coords = GetEntityCoords(playerPed)
                playerData.coords = {
                    x = math.floor(coords.x),
                    y = math.floor(coords.y), 
                    z = math.floor(coords.z)
                }
                playerData.health = GetEntityHealth(playerPed)
            end
        end
        
        -- Get server info
        local serverData = Framework.GetServerInfo()
        
        -- Send response back to client
        local response = {
            success = true,
            playerData = playerData,
            serverData = serverData,
            message = "Data from " .. (Framework.Type or "standalone") .. " framework"
        }
        
        print("^2[NUI-Boilerplate] Sending data using: " .. (Framework.Type or "standalone") .. "^7")
        cb(response)
    end)

    --[[
        Heals the requesting player
        @param source number - Player ID to heal
        @param cb function - Callback to confirm healing
    --]]
    Framework.RegisterCallback('nui:healPlayer', function(source, cb)
        print("^3[NUI-Boilerplate] Player " .. source .. " requested heal^7")
        
        local success = Framework.HealPlayerServer(source)
        
        cb({
            success = success,
            message = success and "Player healed!" or "Failed to heal player"
        })
    end)

    --[[
        Spawns a vehicle for the requesting player
        @param source number - Player ID requesting vehicle
        @param cb function - Callback to confirm spawn
        @param model string - Vehicle model to spawn
    --]]
    Framework.RegisterCallback('nui:spawnVehicle', function(source, cb, model)
        local vehicleModel = model or "adder"
        print("^3[NUI-Boilerplate] Player " .. source .. " requested vehicle: " .. vehicleModel .. "^7")
        
        -- Tell client to spawn the vehicle
        TriggerClientEvent('framework:spawnVehicle', source, vehicleModel)
        
        cb({
            success = true,
            message = "Spawning " .. vehicleModel .. "..."
        })
    end)
end)

--[[
    Test command to check framework detection
    Usage: /testframework
--]]
RegisterCommand('testframework', function(source, args, rawCommand)
    if source == 0 then 
        -- Console command
        print("^2[NUI-Boilerplate] Framework Test^7")
        print("^3Type: " .. (Framework.Type or "Unknown") .. "^7")
        print("^3Server: " .. json.encode(Framework.GetServerInfo()) .. "^7")
    else
        -- Player command  
        local playerData = Framework.GetPlayerDataServer(source)
        if playerData then
            print("^2[NUI-Boilerplate] Player " .. source .. " data: " .. json.encode(playerData) .. "^7")
        end
    end
end, true)
