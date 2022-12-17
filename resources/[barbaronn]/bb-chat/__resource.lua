resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'BarBaroNNsChat'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'bb_CMDS_cfg.lua',
    'bb_CMDS_s.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'bb_CMDS_cfg.lua',
    'bb_CMDS_c.lua'
}

files {
    'style/shadow.js',
    'style/style.css'
}


chat_theme 'gtao' {
    styleSheet = 'style/style.css',
    script = 'style/shadow.js',
    msgTemplates = {
     default = '<b>{0}</b><span>{1}</span>' 
 	}
}