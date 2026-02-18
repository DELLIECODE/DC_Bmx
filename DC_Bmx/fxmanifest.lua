fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'DC_BMX'
author 'AmeRiCanHD'
description 'Script BMX (ESX) avec ox_target et ox_inventory'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    -- '@ox_lib/init.lua', -- Garde seulement si tu utilises ox_lib dans le script
    'shared/config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependency 'es_extended'
dependency 'ox_target'
dependency 'ox_inventory'
