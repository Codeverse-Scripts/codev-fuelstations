fx_version 'cerulean'
game 'gta5'
author 'atiysu'
lua54 'yes'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/utils.lua',
    'client/main.lua',
}

server_scripts {
    'server/utils.lua',
    'server/main.lua',
}

ui_page 'ui/index.html'

files {
    'ui/**/*.*',
    'ui/*.*',
    'database.json'
}
 
escrow_ignore{
    'client/*.*',
    'server/*.*',
    'config.lua',
}
dependency '/assetpacks'