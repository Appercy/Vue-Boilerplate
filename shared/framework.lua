--[[
    Framework Detection and Unified Callback System
    Simple framework detection for ESX, QBCore, QBox with fallback to standalone
    
    @author: Your Name
    @version: 1.0
    @description: Auto-detects frameworks and provides unified callback system
--]]

Framework = {}
Framework.Type = nil     -- Current framework type: 'ESX', 'QB', 'QBX', or 'STANDALONE'
Framework.Object = nil   -- Framework object reference

--[[
    Detects which framework is currently running
    @return boolean - true if framework detected, false if standalone
--]]
function Framework.Detect()
    -- Check for ESX Legacy
    if GetResourceState('es_extended') == 'started' then
        Framework.Type = 'ESX'
        Framework.Object = exports['es_extended']:getSharedObject()
        print('^2[Framework] ESX Legacy detected^7')
        return true
    end
    
    -- Check for QBCore
    if GetResourceState('qb-core') == 'started' then
        Framework.Type = 'QB'
        Framework.Object = exports['qb-core']:GetCoreObject()
        print('^3[Framework] QBCore detected^7')
        return true
    end
    
    -- Check for QBox
    if GetResourceState('qbx_core') == 'started' then
        Framework.Type = 'QBX'
        Framework.Object = exports.qbx_core
        print('^4[Framework] QBox detected^7')
        return true
    end
    
    -- No framework found - use standalone mode
    Framework.Type = 'STANDALONE'
    print('^1[Framework] No framework detected - running standalone^7')
    return false
end

--[[
    Initialize framework detection on resource start
    Waits 1 second for other resources to load first
--]]
CreateThread(function()
    Wait(1000) -- Let other resources load first
    Framework.Detect()
    
    -- Trigger ready event for server-side callback registration
    if IsDuplicityVersion() then
        TriggerEvent('framework:ready')
        print("^2[Framework] Ready event triggered - Type: " .. (Framework.Type or "UNKNOWN") .. "^7")
    end
end)

--[[
    CLIENT-SIDE FUNCTIONS
    Only runs on client side (in-game players)
--]]
if not IsDuplicityVersion() then
    
    --[[
        Triggers a server callback and handles the response
        @param callbackName string - Name of the callback to trigger
        @param cb function - Callback function to handle response
        @param ... any - Additional arguments to pass to server
    --]]
    function Framework.TriggerCallback(callbackName, cb, ...)
        if Framework.Type == 'ESX' then
            Framework.Object.TriggerServerCallback(callbackName, cb, ...)
            
        elseif Framework.Type == 'QB' then
            Framework.Object.Functions.TriggerCallback(callbackName, cb, ...)
            
        elseif Framework.Type == 'QBX' then
            exports.qbx_core:TriggerCallback(callbackName, cb, ...)
            
        else
            -- Standalone mode - use fake client-side data
            local fakeData = Framework.GetStandaloneData()
            cb(fakeData)
        end
    end
    
    --[[
        Generates fake data for standalone mode testing
        @return table - Fake player and server data for testing
    --]]
    function Framework.GetStandaloneData()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        return {
            success = true,
            playerData = {
                name = GetPlayerName(PlayerId()),
                money = math.random(100, 5000),
                bank = math.random(1000, 50000),
                job = 'civilian',
                jobLabel = 'Civilian',
                grade = 0,
                identifier = 'standalone_' .. PlayerId(),
                coords = {
                    x = math.floor(coords.x),
                    y = math.floor(coords.y),
                    z = math.floor(coords.z)
                },
                health = GetEntityHealth(playerPed),
                framework = 'STANDALONE'
            },
            serverData = {
                serverName = "Standalone Server",
                onlinePlayers = math.random(5, 30),
                maxPlayers = 32,
                serverTime = os.date('%H:%M:%S'),
                framework = 'STANDALONE'
            },
            message = "Data from standalone mode (client-side)"
        }
    end
    
    --[[
        Gets current player coordinates
        @return table - Player coordinates {x, y, z}
    --]]
    function Framework.GetPlayerCoords()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        return {
            x = math.floor(coords.x),
            y = math.floor(coords.y),
            z = math.floor(coords.z)
        }
    end
    
end

--[[
    SERVER-SIDE FUNCTIONS
    Only runs on server side
--]]
if IsDuplicityVersion() then
    
    -- Queue to store callbacks until framework is ready
    Framework.CallbackQueue = {}
    
    --[[
        Registers a server callback with proper framework compatibility
        @param callbackName string - Name of the callback
        @param callbackFunc function - Function to call (source, cb, ...)
    --]]
    function Framework.RegisterCallback(callbackName, callbackFunc)
        -- If framework not ready yet, queue it
        if not Framework.Type then
            print("^5[Framework] Queueing callback: " .. callbackName .. "^7")
            table.insert(Framework.CallbackQueue, {name = callbackName, callback = callbackFunc})
            return
        end
        
        -- Register based on framework type
        if Framework.Type == 'ESX' then
            -- ESX: callback signature is (source, cb, ...)
            Framework.Object.RegisterServerCallback(callbackName, callbackFunc)
            print("^2[Framework] Registered ESX callback: " .. callbackName .. "^7")
            
        elseif Framework.Type == 'QB' then
            -- QB: callback signature is (source, cb, ...)
            Framework.Object.Functions.CreateCallback(callbackName, callbackFunc)
            print("^3[Framework] Registered QB callback: " .. callbackName .. "^7")
            
        elseif Framework.Type == 'QBX' then
            -- QBX: callback signature is (source, cb, ...)
            exports.qbx_core:CreateCallback(callbackName, callbackFunc)
            print("^4[Framework] Registered QBX callback: " .. callbackName .. "^7")
            
        else
            -- Standalone mode - just log it
            print("^1[Framework] Registered standalone callback: " .. callbackName .. "^7")
        end
    end
    
    --[[
        Process all queued callbacks when framework becomes ready
    --]]
    AddEventHandler('framework:ready', function()
        print("^2[Framework] Processing " .. #Framework.CallbackQueue .. " queued callbacks^7")
        
        for _, callbackData in ipairs(Framework.CallbackQueue) do
            Framework.RegisterCallback(callbackData.name, callbackData.callback)
        end
        
        Framework.CallbackQueue = {} -- Clear the queue
    end)
    
    --[[
        Gets player data from the appropriate framework
        @param source number - Player server ID
        @return table|nil - Player data or nil if not found
    --]]
    function Framework.GetPlayerDataServer(source)
        if Framework.Type == 'ESX' then
            local xPlayer = Framework.Object.GetPlayerFromId(source)
            if xPlayer then
                return {
                    name = xPlayer.getName(),
                    money = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                    job = xPlayer.job.name,
                    jobLabel = xPlayer.job.label,
                    grade = xPlayer.job.grade,
                    identifier = xPlayer.identifier,
                    framework = 'ESX'
                }
            end
            
        elseif Framework.Type == 'QB' then
            local player = Framework.Object.Functions.GetPlayer(source)
            if player then
                return {
                    name = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
                    money = player.PlayerData.money.cash,
                    bank = player.PlayerData.money.bank,
                    job = player.PlayerData.job.name,
                    jobLabel = player.PlayerData.job.label,
                    grade = player.PlayerData.job.grade.level,
                    identifier = player.PlayerData.citizenid,
                    framework = 'QB'
                }
            end
            
        elseif Framework.Type == 'QBX' then
            local player = exports.qbx_core:GetPlayer(source)
            if player then
                return {
                    name = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
                    money = player.PlayerData.money.cash,
                    bank = player.PlayerData.money.bank,
                    job = player.PlayerData.job.name,
                    jobLabel = player.PlayerData.job.label,
                    grade = player.PlayerData.job.grade.level,
                    identifier = player.PlayerData.citizenid,
                    framework = 'QBX'
                }
            end
            
        else
            -- Standalone fallback - fake data
            return {
                name = GetPlayerName(source),
                money = math.random(100, 5000),
                bank = math.random(1000, 50000),
                job = 'civilian',
                jobLabel = 'Civilian',
                grade = 0,
                identifier = 'standalone_' .. source,
                framework = 'STANDALONE'
            }
        end
        
        return nil
    end
    
    --[[
        Gets basic server information
        @return table - Server info (name, players, time, etc.)
    --]]
    function Framework.GetServerInfo()
        local playerCount = #GetPlayers()
        return {
            serverName = GetConvar('sv_hostname', 'FiveM Server'),
            onlinePlayers = playerCount,
            maxPlayers = GetConvarInt('sv_maxclients', 32),
            serverTime = os.date('%H:%M:%S'),
            framework = Framework.Type or 'STANDALONE'
        }
    end
    
    --[[
        Heals a player using framework-specific methods
        @param source number - Player server ID
        @return boolean - Success status
    --]]
    function Framework.HealPlayerServer(source)
        -- All frameworks trigger client event for healing
        TriggerClientEvent('framework:healPlayer', source)
        return true
    end
    
end

return Framework
