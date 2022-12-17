fx_version 'adamant'
game 'gta5'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
  	'bb_s.lua',
}
client_script 'bb_c.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/listener.js'
}
