name 'menu'
version '1.0.0'
description 'FiveUX menu module'

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

ui_page 'html/index.html'

client_scripts {
    'client/main.lua'
}
server_scripts {}
shared_scripts {}

dependencies {}