fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rsg-spawn'
version '2.0.6'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    'server/versionchecker.lua'
}

dependencies {
    'rsg-core',
    'ox_lib',
}

ui_page 'html/index.html'


files {
    'locales/*.json',
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/fonts/crock.ttf', 
    'html/img/*.jpg'            
}

lua54 'yes'
