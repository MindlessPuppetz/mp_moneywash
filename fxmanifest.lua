fx_version 'adamant'
game 'gta5'
lua54 'yes'

description 'Free, open source money wash'
author 'MindlessPuppetz'
version '1.3'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}
