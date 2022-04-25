fx_version 'cerulean'
game 'gta5'

author 'zXn'
description 'Recycle products selling system'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
	'locales/*.lua'
}

client_scripts {
    'client/cl_main.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
}

server_scripts {
    'server/version_check.lua',
    'server/sv_main.lua',
}