--[[
    FX Manifest - Resource Configuration
    
    @author: Your Name
    @description: Vue NUI Boilerplate with Framework Integration
    @version: 1.0.0
--]]

fx_version("cerulean")
game("gta5")
lua54("yes")

-- Resource Information
author("Appercy")
description("NUI Boilerplate - Clean, Simple, Framework-Integrated")
version("1.0.0")

-- Client Scripts (runs on player's game)
client_scripts({
	"client/**/*", -- All files in client folder
})

-- Server Scripts (runs on server)
server_scripts({
	"@oxmysql/lib/MySQL.lua", -- MySQL library (optional)
	"server/**/*", -- All files in server folder
})

-- Shared Scripts (runs on both client and server)
shared_scripts({
	-- "@ox_lib/init.lua", -- Uncomment if using ox_lib
	"shared/**/*", -- All files in shared folder
})

-- NUI Configuration
ui_page({
	"html/dist/index.html", -- Built Vue app
})

-- NUI Files
files({
	"html/dist/**", -- All built Vue files
})

