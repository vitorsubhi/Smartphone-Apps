fx_version 'adamant'
game 'gta5'

files {
  '**/**/*'
}

client_scripts {
	"@vrp/lib/utils.lua",
  'client-side/**/*.lua',
  'shared/**/*.lua'
}

server_scripts {
	"@vrp/lib/vehicles.lua",
	"@vrp/lib/utils.lua",
  'server-side/**/*.lua',
  'shared/**/*.lua'
}