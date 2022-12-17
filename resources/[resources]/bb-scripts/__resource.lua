resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'@es_extended/locale.lua',
	'client/afk_c.lua',
	'client/carlock_c.lua',
	'client/carpush_c.lua',
	'client/clothes_c.lua',
	'client/coords_c.lua',
	'client/loot_c.lua',
	'client/fingerpoint_c.lua',
	'client/veh_awards_c.lua',
	'client/flipveh_c.lua',
    'client/tpm_c.lua',
    'client/traffic_c.lua',
    'client/speedometerBase_c.lua',
    'client/dvAll_c.lua',
    'client/dvAllEntityiter_c.lua',
    'client/vsync_c.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/afk_s.lua',
	'server/carlock_s.lua',
	'server/discord_s.lua',
	'server/vsync_s.lua',
	'server/dvAll_s.lua',
	'server/tpm_s.lua'
}