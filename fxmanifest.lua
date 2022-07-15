fx_version 'cerulean'
games {'gta5'}

client_scripts{
    "libs/RMenu.lua",
    "libs/menu/RageUI.lua",
    "libs/menu/Menu.lua",
    "libs/menu/MenuController.lua",
    "libs/components/*.lua",
    "libs/menu/elements/*.lua",
    "libs/menu/items/*.lua",
    "libs/menu/panels/*.lua",
    "libs/menu/windows/*.lua",

    "config.lua",
    "client/*.lua",
}

server_scripts{
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server/*.lua",
}

--- Xed#188