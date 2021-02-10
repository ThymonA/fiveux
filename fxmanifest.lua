fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'FiveUX Framework'
version '1.0.0'
description 'FiveM framework written from scratch by Thymon Arens'
author 'ThymonA'
url 'https://github.com/ThymonA/fiveux/'

server_scripts {
	'modules/__boot__/functions/functions.lua',
    'modules/__boot__/functions/string.lua',
	'modules/__boot__/module/cache.lua',
    'modules/__boot__/module/config.lua',
    'modules/__boot__/module/debug.lua',
    'modules/__boot__/module/modules.lua',
    'modules/__boot__/module/env.lua',
    'modules/__boot__/module/boot.lua'
}

client_scripts {
    'modules/__boot__/functions/functions.lua',
    'modules/__boot__/functions/string.lua',
	'modules/__boot__/module/cache.lua',
    'modules/__boot__/module/config.lua',
    'modules/__boot__/module/debug.lua',
    'modules/__boot__/module/modules.lua',
    'modules/__boot__/module/env.lua',
    'modules/__boot__/module/boot.lua'
}

files {
    'configs/**/shared.config.lua',
	'configs/**/client.config.lua',
    'modules/categories.json',
    'modules/**/modules.json',
    'modules/**/**/module.json',
    'modules/**/shared/*.lua',
    'modules/**/client/*.lua'
}

dependencies {
	'fivem-mysql'
}
