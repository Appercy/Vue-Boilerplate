-- Server Tutorial Examples - DELETE THIS FILE to remove all examples
-- This file shows server-side examples for NUI communication

-- Example 1: Handle server data requests
RegisterNetEvent('requestServerData')
AddEventHandler('requestServerData', function()
    local source = source
    
    -- Example server data
    local serverData = {
        serverName = "Example Server",
        onlinePlayers = #GetPlayers(),
        serverTime = os.date("%H:%M:%S"),
        uptime = math.random(1000, 9999) -- Example uptime in minutes
    }
    
    -- Send data back to client
    TriggerClientEvent('receiveServerData', source, serverData)
    
    print("Server data sent to player " .. source)
end)

-- Example 2: Broadcast notification to all players
RegisterCommand('broadcastnotif', function(source, args, rawCommand)
    if source == 0 then -- Console only
        local message = table.concat(args, " ")
        if message and message ~= "" then
            TriggerClientEvent('showNotification', -1, message, "info")
            print("Broadcasted notification: " .. message)
        else
            print("Usage: broadcastnotif <message>")
        end
    end
end, true)

-- Example 3: Give money example (if using ESX)
RegisterNetEvent('giveMoney')
AddEventHandler('giveMoney', function(amount)
    local source = source
    -- local xPlayer = ESX.GetPlayerFromId(source) -- Uncomment if using ESX
    
    -- Example without framework
    print("Player " .. source .. " requested $" .. amount)
    
    -- With ESX:
    -- if xPlayer then
    --     xPlayer.addMoney(amount)
    --     TriggerClientEvent('showNotification', source, "You received $" .. amount, "success")
    -- end
    
    -- Without framework (just notification):
    TriggerClientEvent('showNotification', source, "You received $" .. amount .. " (example)", "success")
end)

-- Example 4: Player data request
RegisterNetEvent('requestPlayerData')
AddEventHandler('requestPlayerData', function()
    local source = source
    
    -- Example player data
    local playerData = {
        id = source,
        name = GetPlayerName(source),
        ping = GetPlayerPing(source),
        -- Add more data based on your framework
    }
    
    TriggerClientEvent('receivePlayerData', source, playerData)
end)

-- Example 5: Log NUI actions
RegisterNetEvent('logNUIAction')
AddEventHandler('logNUIAction', function(action, data)
    local source = source
    local playerName = GetPlayerName(source)
    
    print(string.format("[NUI LOG] Player %s (%d) performed action: %s", playerName, source, action))
    if data then
        print("Data: " .. json.encode(data))
    end
end)
