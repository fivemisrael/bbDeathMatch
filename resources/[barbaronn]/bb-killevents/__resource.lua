resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script 'bb_c.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
  	'bb_s.lua',
}


files {
	"bb_index.html",
	"bb_js.js"
}

ui_page {
	'bb_index.html',
}
