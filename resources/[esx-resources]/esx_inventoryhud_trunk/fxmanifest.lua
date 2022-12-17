fx_version 'adamant'

games { 'gta5' }

server_scripts {
  "@async/async.lua",
  "@mysql-async/lib/MySQL.lua",
  "@es_extended/locale.lua",
  "locales/en.lua",
  "locales/cs.lua",
  "locales/fr.lua",
  "config.lua",
  "server/classes/c_trunk.lua",
  "server/trunk.lua",
  "server/esx_trunk-sv.lua"
}

client_scripts {
  "@es_extended/locale.lua",
  "locales/en.lua",
  "locales/cs.lua",
  "locales/fr.lua",
  "config.lua",
  "client/esx_trunk-cl.lua"
}