fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'FiveUX Framework'
version '1.0.0'
description 'FiveM framework written by Thymon Arens and licensed under GNU General Public License'
author 'ThymonA'
url 'https://github.com/ThymonA/fiveux/'

license [[
    FiveUX Framework Copyright (C) 2021 Thymon Arens

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>
]]

files {
    'configurations/**/shared.config.lua',
    'configurations/**/client.config.lua',
    'shared/translations/*.lua',
    'modules/fxmodules.lua',
    'modules/**/fxcategory.lua',
    'modules/**/fxmodule.lua',
    'modules/**/client/*.lua',
    'modules/**/shared/*.lua',
    'modules/**/translations/*.lua',
    'modules/**/client/**/*.lua',
    'modules/**/shared/**/*.lua',
    'modules/**/**/fxmodule.lua',
    'modules/**/**/client/*.lua',
    'modules/**/**/shared/*.lua',
    'modules/**/**/translations/*.lua',
    'modules/**/**/client/**/*.lua',
    'modules/**/**/shared/**/*.lua'
}

client_scripts {
    'shared/constants.lua',
    'shared/functions.lua',
    'shared/bootable.lua',
    'shared/main.client.lua'
}

server_scripts {
    'shared/constants.lua',
    'shared/functions.lua',
    'shared/bootable.lua'
}

dependencies {
    'fivem-mysql'
}