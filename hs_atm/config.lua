cfg = {

    police = 1,
    settings = {
        ['sprite'] = 171,
        ['color'] = 46
    },

    translations = {
        ["shoptitleitem"] = "Hack usb for ATM",
        ["description"] = "Buy for ",
        ["shoptitle"] = "USB SHOP",
        ["markertext"] = "[E] Buy USB for ATM ",
        ["qtargettext"] = "Hack ATM",
        ["nopolice"] = "They are not LSPD",
        ["successhacking"] = "Money has been credited to your bank ",
        ["failedhacking"] = "You failed, the system called LSPD at your location",
        ["needitem"] = "You need a USB item for ATM",

    },

    zones = {
        ["shop"] = vector3(1130.1906, -989.2850, 45.9679),

    },

    minigame = {
        ["level"] = 1,
        ["lives"] = 2,
        ["minutes"] = 2
    },

    money = {
        ["random"] = math.random(1000,10000), --math.random(min,max)
        ["price"] = 1001
    },

    item = {
        ["atm"] = "atmusb" --item 
    }


}
