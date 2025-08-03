fx_version("cerulean")
game("gta5")
lua54("yes")
author("Appercy")
description("Appercy Vue Boilerplate")
version("1.0.0")

client_scripts({
	"client/**/*",
})

server_scripts({
	"@oxmysql/lib/MySQL.lua",
	"server/**/*",
})

shared_scripts({
	-- "@ox_lib/init.lua",
	"shared/**/*",
})

ui_page({
	"html/dist/index.html",
})

files({
	"html/dist/**",
})

