fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'DP-SCRIPTS'
description 'Menú de animaciones para QBCore por DP-SCRIPTS'
version '1.0.0'

-- Especifica la base de datos para el recurso
database 'animaciones_favoritas'

ui_page 'html/ui.html'

-- Carga de librerías compartidas
shared_scripts {'@ox_lib/init.lua'}
client_scripts {'cfg.lua', 'client/*.lua'}

server_scripts {'server/syncing.lua'} -- Incluye Insert.sql en los scripts del servidor

files {'html/ui.html', 'html/css/style.css', 'html/js/*.js', 'html/js/modules/*.js', 'anims.json'}

---- Loads all ytyp files for custom props to stream ---
---- You will need to add a data_file 'DLC_ITYP_REQUEST' for your own to work in game ---

data_file 'DLC_ITYP_REQUEST' 'stream/**/vedere_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/ultra_ringcase.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/taymckenzienz_rpemotes.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/samnick_prop_lighter01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/pnwsigns.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/pata_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/natty_props_lollipops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/knjgh_pizzas.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/kaykaymods_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/bzzz_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/bzzz_camp_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/brummie_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/apple_1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/rick_lightervile.ytyp'
