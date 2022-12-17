local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["-"] = 84,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

Config = {}

Config.CheckOwnership = false -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = true -- If true, police will be able to search players' trunks.

Config.Locale = 'en'

Config.OpenKey = Keys["G"]

-- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- If you are using esx_avanced_inventory SqlBased weight for your items
Config.WeightSqlBased = false

-- Default weight for an item:
-- weight == 0 : The item do not affect character inventory weight
-- weight > 0 : The item cost place on inventory
-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 10

Config.localWeight = {
    pAmmo = 300,
    mgAmmo = 350,
    sgAmmo = 450,
    arAmmo = 550,
    lockpick = 2000,
    tunerchip = 3000,
    silencieux = 400,
    grip = 500,
    yusuf = 350,
    flashlight = 1000,
    radio = 1600,
    phone = 2500,
    wool = 1000,
    clothe = 750,
    fabric = 750,
    scrap = 1000,
    milkcan = 1500,
    weedburn = 1,
    cokeburn = 1,
    methburn = 1,
    drugbags = 200,
    rolpaper = 200,
    oxycutter = 7500,
    rccar = 800,
    handcuffs = 1000,
    binoculars = 1000,
    HeavyArmor = 2750,
    hqscale = 1000,
    coke1g = 400,
    meth1g = 400,
    joint2g = 800,
    weed4g = 1600,
    crack = 2000,
    coke10g = 4000,
    meth10g = 4000,
    weed20g = 8000,
    cokebrick = 10000,
    weedbrick = 10000,
    methbrick = 10000,
    repairkit = 3000,
    WEAPON_SMG = 2500,
    WEAPON_SNIPERRIFLE = 15000,
    WEAPON_HEAVYSNIPER = 21000,
    WEAPON_HEAVYSNIPER_MK2 = 25000,
    WEAPON_MARKSMANRIFLE = 15000,
    WEAPON_MARKSMANRIFLE_MK2 = 18000,
    WEAPON_RPG = 50000,
    WEAPON_GRENADELAUNCHER = 35000,
    WEAPON_GRENADELAUNCHER_SMOKE = 40000,
    WEAPON_MINIGUN = 45000,
    WEAPON_FIREWORK = 30000,
    WEAPON_RAILGUN = 25000,
    WEAPON_HOMINGLAUNCHER = 55000,
    WEAPON_COMPACTLAUNCHER = 35000,
    WEAPON_GRENADE = 1000,
    WEAPON_BZGAS = 1000,
    WEAPON_MOLOTOV = 800,
    WEAPON_STICKYBOMB = 800,
    WEAPON_PROXMINE = 1250,
    WEAPON_SNOWBALL = 50,
    WEAPON_PIPEBOMB = 1000,
    WEAPON_SMOKEGRENADE = 1000,
    WEAPON_FLARE = 300,
    WEAPON_PETROLCAN = 1500,
    WEAPON_FIREEXTINGUISHER = 5000,
    WEAPON_NIGHTSTICK = 1000,
    WEAPON_STUNGUN = 800,
    WEAPON_HAMMER = 100,
    WEAPON_MACHETE = 2000,
    WEAPON_DAGGER = 200,
    WEAPON_FLASHLIGHT = 150,
    WEAPON_BAT = 500,
    WEAPON_BATTLEAXE = 3000,
    WEAPON_WRENCH = 5000,
    WEAPON_GOLFCLUB = 500,
    WEAPON_FLAREGUN = 800,
    WEAPON_HATCHET = 250,
    WEAPON_KNUCKLE = 1000,
    WEAPON_CROWBAR = 2000,
    WEAPON_BOTTLE = 50,
    WEAPON_BALL = 25,
    WEAPON_POOLCUE = 100,
    WEAPON_KNIFE = 100,
    WEAPON_SWITCHBLADE = 250,
    WEAPON_STONE_HATCHET = 4500,
    WEAPON_STICKYBOMB = 1500,
    WEAPON_SPECIALCARBINE = 10000,
    WEAPON_SPECIALCARBINE_MK2 = 12500,
    WEAPON_BULLPUPRIFLE = 8000,
    WEAPON_BULLPUPRIFLE_MK2 = 9500,
    WEAPON_MG = 20000,
    WEAPON_COMBATMG = 25000,
    WEAPON_COMBATMG_MK2 = 30000,
    WEAPON_GUSENBERG = 10000,
    WEAPON_ASSAULTRIFLE = 10000,
    WEAPON_ASSAULTRIFLE_MK2 = 12500,  
    WEAPON_COMPACTRIFLE = 5000,
    WEAPON_COMBATPDW = 2500,
    WEAPON_SAWNOFFSHOTGUN = 6000,
    WEAPON_STICKYBOMB = 1500,
    WEAPON_MICROSMG = 2500,
    WEAPON_MINISMG = 2000,
    WEAPON_MACHINEPISTOL = 2500,
    WEAPON_HEAVYPISTOL = 2000,
    WEAPON_PISTOL50 = 2750,
    WEAPON_VINTAGEPISTOL = 1800,
    WEAPON_MARKSMANPISTOL = 3000,
    WEAPON_REVOLVER = 4250,
    WEAPON_REVOLVER_MK2 = 4000,
    WEAPON_DOUBLEACTION = 3000,
    WEAPON_SMG_MK2 = 3500,
    WEAPON_ASSAULTSMG = 4000,
    WEAPON_PUMPSHOTGUN = 4250,
    WEAPON_PUMPSHOTGUN_MK2 = 4500,
    WEAPON_ASSAULTSHOTGUN = 6000,
    WEAPON_BULLPUPSHOTGUN = 5000,
    WEAPON_MUSKET = 8000,
    WEAPON_HEAVYSHOTGUN = 6000,
    WEAPON_APPISTOL = 2000,
    WEAPON_CARBINERIFLE = 10000,
    WEAPON_CARBINERIFLE_MK2 = 12000,
    WEAPON_FLASHLIGHT = 400,
    WEAPON_PISTOL = 1200,
    WEAPON_PISTOL_MK2 = 1750,
    WEAPON_SNSPISTOL = 800,
    WEAPON_SNSPISTOL_MK2 = 1000,
    WEAPON_COMBATPISTOL = 1500
}

Config.VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 50000, --Sedan
    [2] = 55000, --SUV
    [3] = 52500, --Coupes
    [4] = 50000, --Muscle
    [5] = 45000, --Sports Classics
    [6] = 45000, --Sports
    [7] = 25000, --Super
    [8] = 5000, --Motorcycles
    [9] = 75000, --Off-road
    [10] = 80000, --Industrial
    [11] = 65000, --Utility
    [12] = 80000, --Vans
    [13] = 0, --Cycles
    [14] = 35000, --Boats
    [15] = 20000, --Helicopters
    [16] = 0, --Planes
    [17] = 35000, --Service
    [18] = 75000, --Emergency
    [19] = 0, --Military
    [20] = 125000, --Commercial
    [21] = 0 --Trains
}

Config.VehiclePlate = {
    taxi = "TAXI",
    police = "RLPD",
    ambulance = "EMS",
    mechanic = "MECHANIC"
}