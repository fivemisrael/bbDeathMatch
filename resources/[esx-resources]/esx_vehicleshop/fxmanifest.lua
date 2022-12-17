fx_version 'adamant'

game 'gta5'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@bb-donatorsys/bb_c.lua',
	'@es_extended/locale.lua',
	'en.lua',
	'config.lua',
	'client/utils.lua',
	'client/main.lua'
}

dependency 'es_extended'

export 'GeneratePlate'