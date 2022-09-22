fx_version 'adamant'
game 'gta5'

name "smartphone-app"
description "Additional Smartphone App compatible with JesterOS and Alternative vRP."
version "1.1"
url "https://github.com/vitorsubhi/Smartphone-Apps"
author "vitorsubhi"

files {
  '**/**/*'
}

shared_scripts {
	"@vrp/lib/vehicles.lua",
	"@vrp/lib/utils.lua",
	"shared/**/**/*.lua"
}

client_scripts {
	"client-side/**/*.lua"
}

server_scripts {
	"server-side/**/*.lua"
}