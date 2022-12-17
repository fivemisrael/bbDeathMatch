resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'@bb-exp/config.lua',
	--'@bb-zone/bb_pvpzones.lua',
	--'@bb-zone/bb_greenzones.lua',
	'bb_c.lua',
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'bb_s.lua'
}