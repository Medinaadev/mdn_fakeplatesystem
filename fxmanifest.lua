shared_script '@k/sh.lua'
fx_version 'cerulean'
games { 'gta5' }
author 'Medinaa#7364'

discord 'https://discord.gg/2xzPmyCmsj'
description 'ESX Fake Plate System'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    'shared/main.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
}

ui_page 'html/ui.html'

files {
    'html/*.html',
    'html/css/*.css',
    'html/js/*.js',
}

dependencies {
    'mdn_progressbar', -- https://github.com/MedinaYT/mdn_progressbar (Donwload it from my github)
}