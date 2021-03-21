fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'FiveUX Framework'
version '1.0.0'
description 'FiveM framework written from scratch by Thymon Arens'
author 'ThymonA'
url 'https://github.com/ThymonA/fiveux/'

ui_page 'html/fiveux.html'
ui_page_preload 'yes'

server_scripts {
	'modules/__boot__/functions/functions.lua',
    'modules/__boot__/functions/string.lua',
    'modules/__boot__/module/constants.lua',
	'modules/__boot__/module/cache.lua',
    'modules/__boot__/module/config.lua',
    'modules/__boot__/module/debug.lua',
    'modules/__boot__/module/translations.lua',
    'modules/__boot__/module/modules.lua',
    'modules/__boot__/module/env.lua',
    'modules/__boot__/module/boot.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'modules/__boot__/functions/functions.lua',
    'modules/__boot__/functions/string.lua',
    'modules/__boot__/module/constants.lua',
	'modules/__boot__/module/cache.lua',
    'modules/__boot__/module/config.lua',
    'modules/__boot__/module/debug.lua',
    'modules/__boot__/module/translations.lua',
    'modules/__boot__/module/modules.lua',
    'modules/__boot__/module/ui.lua',
    'modules/__boot__/module/env.lua',
    'modules/__boot__/module/boot.lua'
}

files {
    'html/fiveux.html',
    'html/assets/js/*.js',
    'html/assets/css/*.css',
    'configs/**/shared.config.lua',
	'configs/**/client.config.lua',
    'modules/categories.json',
    'modules/**/modules.json',
    'modules/**/**/module.json',
    'modules/**/shared/*.lua',
    'modules/**/client/*.lua',
    'modules/**/translations/*.json',
    'modules/**/html/assets/**/*.*',
    'modules/**/html/assets/**/*',
    'modules/**/html/assets/*.*',
    'modules/**/html/assets/*',
    'modules/**/html/**/*.*',
    'modules/**/html/**/*',
    'modules/**/html/*.*',
    'modules/**/html/*'
}

dependencies {
	'fivem-mysql',
    'menuv'
}
