ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local xnWeapons = xnWeapons or {
    interiorIDs = {
        [153857] = true,
        [200961] = true,
		[140289] = {
			weaponRotationOffset = 135.0,
		},
        [180481] = true,
        [168193] = true,
        [164609] = {
			weaponRotationOffset = 150.0,
		},
        [175617] = true,
        [176385] = true,
		[178689] = true,
		[137729] = {
			additionalOffset = 			vec(8.3,-6.5,0.0),
			additionalCameraOffset = 	vec(8.3,-6.0,0.0),
			additionalCameraPoint = 	vec(1.0,-0.91,0.0),
			additionalWeaponOffset =	vec(0.0,0.5,0.0),
			weaponRotationOffset = 		-60.0,
		},
		[248065] = {
			additionalOffset = 			vec(-10.0,3.0,0.0),
			additionalCameraOffset = 	vec(-9.5,3.0,0.0),
			additionalCameraPoint = 	vec(-1.0,0.4,0.0),
			additionalWeaponOffset =	vec(0.4,0.0,0.0),
		},
    },
    closeMenuNextFrame = false,
    weaponClasses = {},
}
function IsAmmunationOpen()
	return (string.find(tostring(JayMenu.CurrentMenu() or ""), "xnweapons") or string.find(tostring(JayMenu.CurrentMenu() or ""), "xnw_"))
end

local globalWeaponTable = {
    {
        name = "Melee",
        { 'WEAPON_KNUCKLE', 'Knuckle Dusters' ,10000, 0, 0 },
        { 'WEAPON_SWITCHBLADE', 'Switchblade',10000, 0, 1  },
        { 'WEAPON_KNIFE', 'Knife',10000, 0, 0  },
        { 'WEAPON_NIGHTSTICK', 'Nightstick',10000, 0, 0  },
        { 'WEAPON_HAMMER', 'Hammer',10000, 0, 0  },
        { 'WEAPON_BAT', 'Katana',10000, 0, 1  },
        { 'WEAPON_GOLFCLUB', 'Golf Club',10000, 0, 0  },
        { 'WEAPON_CROWBAR', 'Knife',10000, 0, 0  },
        { 'WEAPON_HATCHET', 'Hatchet',10000, 0, 0  },
        { 'WEAPON_POOLCUE', 'Pool Cue',10000, 0, 0  },
        { 'WEAPON_WRENCH', 'Wrench',10000, 0, 0  },
        { 'WEAPON_FLASHLIGHT', 'Flashlight',10000, 0, 0  },
        { 'WEAPON_BOTTLE', 'Broken Bottle',10000, 0, 0  },
        { 'WEAPON_DAGGER', 'Bowie Knife',10000, 0, 0  },
        { 'WEAPON_MACHETE', 'Machete',10000, 0, 0  },
        { 'WEAPON_BATTLEAXE', 'Battle Axe',10000, 0, 0  },
        { 'WEAPON_BALL', 'Baseball',10, 0, 0  },
        { 'WEAPON_SNOWBALL', 'Snowball',10, 0, 0  },
    },
    {
        name = "Pistols",
        { 'WEAPON_PISTOL', 'Pistol', 40000, 1, 1},
        { 'WEAPON_PISTOL_MK2', 'Pistol MKII',60000, 1, 0 },
        { 'WEAPON_COMBATPISTOL', 'Combat Pistol' , 50000, 1, 0},
        { 'WEAPON_MACHINEPISTOL', 'Machine Pistol', 120000, 1, 0,},
        { 'WEAPON_APPISTOL', 'Automatic Pistol',120000, 1, 0 },
        { 'WEAPON_PISTOL50', 'Pistol .50',120000, 2, 0 },
        { 'WEAPON_REVOLVER', 'Revolver', 120000, 1, 0 },
        { 'WEAPON_REVOLVER_MK2', 'Revolver MKII', 130000, 2, 0 },
        { 'WEAPON_VINTAGEPISTOL', 'Vintage Pistol', 50000, 1, 0},
        { 'WEAPON_SNSPISTOL', 'SNS Pistol',20000, 0 , 0 },
        { 'WEAPON_SNSPISTOL_MK2', 'SNS Pistol MKII', 30000, 0, 0 },
        { 'WEAPON_MARKSMANPISTOL', 'Marksman Pistol',70000, 0, 0  },
        { 'WEAPON_HEAVYPISTOL', 'Heavy Pistol', 90000, 0, 0 },
        { 'WEAPON_DOUBLEACTION', 'Double-Action Revolver', 160000, 0, 0 },
    },
    {
        name = "SMGs",
        { 'WEAPON_MICROSMG', 'Micro SMG', 175000, 4, 0 },
        { 'WEAPON_SMG', 'SMG', 150000, 3, 0 },
        { 'WEAPON_SMG_MK2', 'SMG MKII', 150000, 4, 0 },
        { 'WEAPON_ASSAULTSMG', 'Assault SMG', 160000, 4, 0 },
        { 'WEAPON_MINISMG', 'Mini SMG', 175000, 4, 0 },
        { 'WEAPON_COMBATPDW', 'Combat PDW', 160000, 3, 0 },
    },
    {
        name = "MGs",
        { 'WEAPON_MG', 'MG', 160000, 3, 0 },
        { 'WEAPON_COMBATMG', 'Combat MG', 175000, 3, 0 },
        { 'WEAPON_COMBATMG_MK2', 'Combat MG MKII', 190000, 3, 0 },
        { 'WEAPON_GUSENBERG', 'Gusenberg', 160000, 3, 0 },
    },
    {
        name = "Shotguns",
        { 'WEAPON_PUMPSHOTGUN', 'Pump Shotgun', 180000, 5, 0 },
        { 'WEAPON_PUMPSHOTGUN_MK2', 'Pump Shotgun MKII', 190000, 5, 0 },
        { 'WEAPON_HEAVYSHOTGUN', 'Heavy Shotgun', 250000, 5, 0 },
        { 'WEAPON_SAWNOFFSHOTGUN', 'Sawn-off Shotgun',180000, 3, 0  },
        { 'WEAPON_ASSAULTSHOTGUN', 'Assault Shotgun',230000, 4, 0  },
        { 'WEAPON_BULLPUPSHOTGUN', 'Bullpup Shotgun', 210000, 4, 0},
        { 'WEAPON_AUTOSHOTGUN', 'Sweeper',  210000, 4, 0},
        { 'WEAPON_DBSHOTGUN', 'Double-Barreled Shotgun',  140000, 3, 0},
        { 'WEAPON_MUSKET', 'Musket', 300000, 5, 0 },
    },
    {
        name = "Assault Rifles",
        { 'WEAPON_ASSAULTRIFLE', 'Assault Rifle', 225000, 8, 0 },
        { 'WEAPON_ASSAULTRIFLE_MK2', 'Assault Rifle MKII', 250000, 9, 0 },
        { 'WEAPON_CARBINERIFLE', 'Carbine Rifle', 230000,  8, 0 },
        { 'WEAPON_CARBINERIFLE_MK2', 'Carbine Rifle MKII', 255000,  9, 0},
        { 'WEAPON_ADVANCEDRIFLE', 'Advanced Rifle',290000 ,  9, 0 },
        { 'WEAPON_COMPACTRIFLE', 'Compact Rifle', 195000, 7, 0 },
        { 'WEAPON_SPECIALCARBINE', 'Special Carbine', 300000, 9, 0  },
        { 'WEAPON_SPECIALCARBINE_MK2', 'Special Carbine MKII',325000 ,10, 0 },
        { 'WEAPON_BULLPUPRIFLE', 'Bullpup Rifle', 300000, 9, 0 },
        { 'WEAPON_BULLPUPRIFLE_MK2', 'Bullpup Rifle MKII', 325000, 10 , 0 },
    },
    {
        name = "Sniper Rifles",
        { 'WEAPON_SNIPERRIFLE', 'Sniper Rifle', 750000, 15, 0 },
        { 'WEAPON_HEAVYSNIPER', 'Heavy Sniper Rifle',850000, 16, 0 },
        { 'WEAPON_HEAVYSNIPER_MK2', 'Heavy Sniper Rifle MKII', 900000, 16, 0 },
        { 'WEAPON_MARKSMANRIFLE', 'Marksman Rifle', 1200000, 16, 0 },
        { 'WEAPON_MARKSMANRIFLE_MK2', 'Marksman Rifle MKII', 1250000, 17, 0 },
    },--[[
    {
        name = "Special Weapons",
        
        { 'WEAPON_COMPACTLAUNCHER', 'Compact Grenade Launcher' },
        { 'WEAPON_GRENADELAUNCHER', 'Grenade Launcher' },
        { 'WEAPON_RPG', 'RPG' },
        { 'WEAPON_HOMINGLAUNCHER', 'Homing Launcher' },
        { 'WEAPON_MINIGUN', 'Minigun' },
        { 'WEAPON_RAILGUN', 'Railgun' },
        
    },]]
    {
        name = "Throwables",
        { 'WEAPON_GRENADE', 'Frag Grenade',  150000,3, 0, {noTint = true}  },
        { 'WEAPON_STICKYBOMB', 'Sticky Bombs', 180000,5, 1, {noTint = true} },
        { 'WEAPON_SMOKEGRENADE', 'Smoke Grenade', 20000,0, 0 , {noTint = true}},
        --[[
        { 'WEAPON_BZGAS', 'BZ Gas', {noTint = true} , 250000,3, 0},
        ]]
        { 'WEAPON_MOLOTOV', 'Molotov Cocktail', 100000 ,4 ,0, {noTint = true} },
        { 'WEAPON_PIPEBOMB', 'Pipebomb' ,20000 ,2 ,0, {noTint = true} },
        { 'WEAPON_PROXMINE', 'Proximity Mine' ,100000 ,10 ,1, {noTint = true} },
    },
    {
        name = "Accessories",
        --[[
        { 'WEAPON_FIREEXTINGUISHER', 'Fire Extinguisher', {noAmmo = true, noTint = true} },
        { 'WEAPON_FIREWORK', 'Firework Launcher', {noTint = true} },
        { 'WEAPON_PETROLCAN', 'Jerry Can', {noTint = true} },
        { 'WEAPON_FLARE', 'Flare', {noTint = true} },
        ]]
		{ 'GADGET_PARACHUTE', 'Parachute', 10000, 0 , 0, {noPreview = true, noTint = true, noAmmo = true}},
    },
}

local globalAttachmentTable = {  
	-- Putting these at the top makes them work properly as they need to be applied to the weapon first before other attachments
	{ "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_MICROSMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_SNIPERRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_PISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_PISTOL50_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_APPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_SMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },
	{ "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish", 5000, 0, 0  },

	{ "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0 },
	{ "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0 },
	{ "COMPONENT_MG_COMBATMG_LOWRIDER", "Lowrider Finish", 5000, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0},
	{ "COMPONENT_MG_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0 },
	{ "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0},
	{ "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", "Lowrider Finish", 5000, 0, 0},

	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_COMBATMG_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0},
	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_PISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_ASSAULTSHOTGUN_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_PISTOL50_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_COMBATPISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_APPISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_COMBATPDW_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_COMBATMG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_MG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_ASSAULTSMG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_GUSENBERG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_MICROSMG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_COMPACTRIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_HEAVYPISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_VINTAGEPISTOL_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_ADVANCEDRIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLE_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_SMG_CLIP_02", "Extended Magazine", 12500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_CLIP_02", "Extended Magazine", 12500, 0, 0 },

	{ "COMPONENT_SPECIALCARBINE_CLIP_03", "Drum Magazine", 35000, 0, 0 },
	{ "COMPONENT_COMPACTRIFLE_CLIP_03", "Drum Magazine", 35000, 0, 0  },
	{ "COMPONENT_COMBATPDW_CLIP_03", "Drum Magazine", 35000, 0, 0  },
	{ "COMPONENT_ASSAULTRIFLE_CLIP_03", "Drum Magazine", 35000, 0, 0  },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_03", "Drum Magazine", 35000, 0, 0  },
	{ "COMPONENT_CARBINERIFLE_CLIP_03", "Drum Magazine", 35000, 0, 0  },
	{ "COMPONENT_SMG_CLIP_03", "Drum Magazine", 35000, 0, 0  },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3  },

	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_PISTOL_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_PISTOL_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_PISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds", 5000, 0, 1 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE", "Explosive Rounds", 2500, 0, 3 },

	{ "COMPONENT_SNSPISTOL_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds", 5000, 0, 1 },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_REVOLVER_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds", 5000, 0, 1 },
	{ "COMPONENT_REVOLVER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_SMG_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0 },
	{ "COMPONENT_SMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_SMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_SMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0  },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0  },
	{ "COMPONENT_COMBATMG_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_TRACER", "Tracer Rounds", 5000, 0, 0  },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY", "Incendiary Rounds", 65000, 0, 2 },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },
	{ "COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds", 5000, 0, 1 },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },
	{ "COMPONENT_COMBATMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds", 2500, 0, 3 },

	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE", "Explosive Rounds", 500000, 25, 0 },

	{ "COMPONENT_AT_PI_FLSH_02", "Flashlight", 5000, 0, 0 },
	{ "COMPONENT_AT_AR_FLSH	", "Flashlight", 5000, 0, 0 },
	{ "COMPONENT_AT_PI_FLSH", "Flashlight", 5000, 0, 0 },
	{ "COMPONENT_AT_AR_FLSH", "Flashlight", 5000, 0, 0 },
	{ "COMPONENT_AT_PI_FLSH_03", "Flashlight", 5000, 0, 0 },

	{ "COMPONENT_AT_PI_SUPP", "Suppressor", 5000, 0, 0 },
	{ "COMPONENT_AT_PI_SUPP_02", "Suppressor", 5000, 0, 0 },
	{ "COMPONENT_AT_AR_SUPP", "Suppressor", 5000, 0, 0 },
	{ "COMPONENT_AT_AR_SUPP_02", "Suppressor", 5000, 0, 0 },
	{ "COMPONENT_AT_SR_SUPP", "Suppressor", 5000, 0, 0 },
	{ "COMPONENT_AT_SR_SUPP_03", "Suppressor", 5000, 0, 0 },

	{ "COMPONENT_AT_PI_COMP", "Compensator", 3000, 0, 0 },
	{ "COMPONENT_AT_PI_COMP_02", "Compensator", 3000, 0, 0 },
	{ "COMPONENT_AT_PI_COMP_03", "Compensator", 3000, 0, 0 },
	{ "COMPONENT_AT_MRFL_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_MRFL_BARREL_02", "Barrel Attachment 2", 1500, 0, 2 },
	{ "COMPONENT_AT_SR_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_BP_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_BP_BARREL_02", "Barrel Attachment 2" , 3000, 0, 0},
	{ "COMPONENT_AT_SC_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_SC_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_AR_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_SB_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_CR_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_MG_BARREL_01", "Barrel Attachment 1", 1500, 0, 2 },
	{ "COMPONENT_AT_MG_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_CR_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_SR_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_SB_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_AR_BARREL_02", "Barrel Attachment 2", 3000, 0, 0 },
	{ "COMPONENT_AT_MUZZLE_01", "Muzzle Attachment 1", 1000, 0, 1 },
	{ "COMPONENT_AT_MUZZLE_02", "Muzzle Attachment 2", 1000, 0, 1 },
	{ "COMPONENT_AT_MUZZLE_03", "Muzzle Attachment 3", 1500, 0, 2 },
	{ "COMPONENT_AT_MUZZLE_04", "Muzzle Attachment 4", 3000, 0, 0 },
	{ "COMPONENT_AT_MUZZLE_05", "Muzzle Attachment 5", 3000, 0, 0 },
	{ "COMPONENT_AT_MUZZLE_06", "Muzzle Attachment 6", 3000, 0, 0 },
	{ "COMPONENT_AT_MUZZLE_07", "Muzzle Attachment 7", 3000, 0, 0 },

	{ "COMPONENT_AT_AR_AFGRIP", "Grip", 3000, 0, 0 },
	{ "COMPONENT_AT_AR_AFGRIP_02", "Grip", 3000, 0, 0 },

	{ "COMPONENT_AT_PI_RAIL", "Holographic Sight", 7500, 0, 0 },
	{ "COMPONENT_AT_SCOPE_MACRO_MK2", "Holographic Sight", 7500, 0, 0 },
	{ "COMPONENT_AT_PI_RAIL_02", "Holographic Sight", 7500, 0, 0 },
	{ "COMPONENT_AT_SIGHTS_SMG", "Holographic Sight", 7500, 0, 0 },
	{ "COMPONENT_AT_SIGHTS", "Holographic Sight", 7500, 0, 0 },

	{ "COMPONENT_AT_SCOPE_SMALL", "Scope Small", 7500, 0, 0 },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope Small", 7500, 0, 0 },

	{ "COMPONENT_AT_SCOPE_MACRO_02", "Scope", 10000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope", 10000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_MACRO", "Scope", 10000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_MEDIUM", "Scope", 10000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope", 10000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_SMALL", "Scope", 10000, 0, 0 },

	{ "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2", "2x Scope", 15000, 0, 0 },
	{ "COMPONENT_AT_SCOPE_SMALL_MK2", "2x Scope", 15000, 0, 0 },

	{ "COMPONENT_AT_SCOPE_SMALL_SMG_MK2", "4x Scope", 7500, 0, 1 },
	{ "COMPONENT_AT_SCOPE_MEDIUM_MK2", "4x Scope", 7500, 0, 1 },

	{ "COMPONENT_AT_SCOPE_MAX", "Advanced Scope", 10000, 0, 3},
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope Large", 10000, 0, 2 },
	{ "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2", "Scope Large", 10000, 0, 2 },
	{ "COMPONENT_AT_SCOPE_LARGE_MK2", "8x Scope", 17500, 0, 0 },

	{ "COMPONENT_AT_SCOPE_NV", "Nightvision Scope", 25000, 0, 1 },
	{ "COMPONENT_AT_SCOPE_THERMAL", "Thermal Scope", 25000, 0, 1  },

	--{ "COMPONENT_KNUCKLE_VARMOD_PLAYER", "Default Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_LOVE", "Love Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_DOLLAR", "Dollar Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_VAGOS", "Vagos Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_HATE", "Hate Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_DIAMOND", "Diamond Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_PIMP", "Pimp Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_KING", "King Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_BALLAS", "Ballas Skin", 500, 0, 0 },
	{ "COMPONENT_KNUCKLE_VARMOD_BASE", "Base Skin", 500, 0, 0 },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR1", "Default Skin", 500, 0, 0 },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR2", "Variant 2 Skin", 500, 0, 0 },
	--{ "COMPONENT_SWITCHBLADE_VARMOD_BASE", "Base Skin" },

	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_10", "Camo 10", 2500, 0, 3 },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_08", "Camo 8", 2500, 0, 1  },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_10", "Camo 10", 2500, 0, 3 },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_10", "Camo 10", 2500, 0, 3 },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1  },

	{ "COMPONENT_REVOLVER_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_REVOLVER_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_REVOLVER_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },

	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },

	{ "COMPONENT_PISTOL_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO", "Camo 1", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_02", "Camo 2", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_03", "Camo 3" , 3500, 0, 0},
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03", "Camo 3", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04", "Camo 4", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_SMG_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_05", "Camo 5", 2500, 0 , 2 },
	{ "COMPONENT_PISTOL_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_06", "Camo 6", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_07", "Camo 7", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_07", "Camo 7" , 3500, 0, 0},
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_PISTOL_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_SMG_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08", "Camo 8", 2500, 0, 1 },
	{ "COMPONENT_PISTOL_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_COMBATMG_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_SMG_MK2_CAMO_09", "Camo 9", 3500, 0, 0 },
	{ "COMPONENT_PISTOL_MK2_CAMO_10", "Camo 10" , 2500, 0, 3 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_COMBATMG_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_SMG_MK2_CAMO_10", "Camo 10", 2500, 0, 3  },
	{ "COMPONENT_PISTOL_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
	{ "COMPONENT_SMG_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01", "American Camo" , 2500, 0, 1},
	{ "COMPONENT_COMBATMG_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01", "American Camo", 2500, 0, 1 },
}

local globalTintTable = {
	mk1 = {
		{ 1, "Green Tint", 1500, 0, 0 },
		{ 2, "Gold Tint", 2000, 0, 0 },
		{ 3, "Pink Tint", 1500, 0, 1 },
		{ 4, "Army Tint", 1500, 0, 0},
		{ 5, "LSPD Tint", 1500, 0, 2 },
		{ 6, "Orange Tint", 2000, 0, 0 },
		{ 7, "Platinum Tint", 1500, 0, 0 },
	},
	mk2 = {
		{ 1, "Classic Gray Tint", 3000, 0, 0 },
		{ 2, "Classic TwoTone Tint", 3000, 0, 0 },
		{ 3, "Classic White Tint", 2500, 0, 2 },
		{ 4, "Classic Beige Tint", 3000, 0, 0 },
		{ 5, "Classic Green Tint", 3000, 0, 0 },
		{ 6, "Classic Blue Tint", 2500, 0, 1 },
		{ 7, "Classic Earth Tint", 3000, 0, 0 },
		{ 8, "Classic Brown And Black Tint", 3000, 0, 0 },
		{ 9, "Red Contrast Tint", 2500, 0, 1 },
		{ 10, "Blue Contrast Tint", 3000, 0, 0 },
		{ 11, "Yellow Contrast Tint", 3000, 0, 0 },
		{ 12, "Orange Contrast Tint", 3000, 0, 0 },
		{ 13, "Bold Pink Tint", 2500, 0, 1 },
		{ 14, "Bold Purple And Yellow Tint", 3000, 0, 0 },
		{ 15, "Bold Orange Tint", 3000, 0, 0 },
		{ 16, "Bold Green And Purple Tint", 3000, 0, 0 },
		{ 17, "Bold Red Features Tint", 1500, 0, 3 },
		{ 18, "Bold Green Features Tint", 4500, 0, 0 },
		{ 19, "Bold Cyan Features Tint", 4500, 0, 0 },
		{ 20, "Bold Yellow Features Tint", 4500, 0, 0 },
		{ 21, "Bold Red And White Tint", 4500, 0, 0 },
		{ 22, "Bold Blue And White Tint", 4500, 0, 0 },
		{ 23, "Metallic Gold Tint", 4500, 0, 0 },
		{ 24, "Metallic Platinum Tint", 4500, 0, 0 },
		{ 25, "Metallic Gray And Lilac Tint", 3000, 0, 0 },
		{ 26, "Metallic Purple And Lime Tint", 3000, 0, 0 },
		{ 27, "Metallic Red Tint", 3000, 0, 0 },
		{ 28, "Metallic Green Tint", 3000, 0, 0 },
		{ 29, "Metallic Blue Tint", 3000, 0, 0 },
		{ 30, "Metallic White And Aqua Tint", 3000, 0, 0 },
		{ 31, "Metallic Red And Yellow", 2500, 0, 2 },
	}
}
for ci,wepTable in pairs(globalWeaponTable) do
    local className = wepTable.name
    xnWeapons.weaponClasses[ci] = {
        name = className,
        weapons = {},
    }
    local classWepTable = xnWeapons.weaponClasses[ci].weapons
	for wi,weaponObject in ipairs(wepTable) do
		if weaponObject[6] then
			classWepTable[wi] = weaponObject[6]
			classWepTable[wi].donator = weaponObject[5]
			classWepTable[wi].level = weaponObject[4]
			classWepTable[wi].price = weaponObject[3]
			classWepTable[wi].name = weaponObject[2]
			classWepTable[wi].model = weaponObject[1]
			classWepTable[wi].attachments = {}
		else
			classWepTable[wi] = {
				donator = weaponObject[5],
				level = weaponObject[4],
				price = weaponObject[3],
				name = weaponObject[2],
				model = weaponObject[1],
				attachments = {},
			}
		end
        local wep = classWepTable[wi]
        for _,attachmentObject in ipairs(globalAttachmentTable) do
            if DoesWeaponTakeWeaponComponent(weaponObject[1], attachmentObject[1]) then
                wep.attachments[#wep.attachments+1] = {
                	donator = attachmentObject[5],
                	level = attachmentObject[4],
                	price = attachmentObject[3],
                    name = attachmentObject[2],
                    model = attachmentObject[1]
                }
            end
        end
		wep.clipSize = wep.clipSize or GetWeaponClipSize(weaponObject[1])
		wep.isMK2 = wep.isMK2 or (string.find(weaponObject[1], "_MK2") ~= nil)
    end
end
-- We do this once so that we don't run like 500 tests a tick on weapons and all the information is easily available to the menu

for intID, interior in pairs(xnWeapons.interiorIDs) do
	local additionalOffset = vec(0,0,0)	
	if type(interior) == "table" then
		additionalOffset = interior.additionalOffset or additionalOffset
	end
	
	local locationCoords = GetOffsetFromInteriorInWorldCoords(intID, (1.0),4.7,1.0) + additionalOffset
end

-- Main logic/magic loop
Citizen.CreateThread(function()
    local radius = 1.0  
    local waitForPlayerToLeave = false

	while true do Citizen.Wait(1)
		if GetInteriorFromEntity(GetPlayerPed(-1)) ~= 0 and xnWeapons.interiorIDs[GetInteriorFromEntity(GetPlayerPed(-1))] then
			local interiorID = GetInteriorFromEntity(GetPlayerPed(-1))
			local additionalOffset = vec(0,0,0)
			if type(xnWeapons.interiorIDs[interiorID]) == "table" then
				additionalOffset = xnWeapons.interiorIDs[interiorID].additionalOffset or additionalOffset
			end

            for i = 1,3 do
                if not IsAmmunationOpen() then
                    if (Vdist2(GetOffsetFromInteriorInWorldCoords(interiorID, (2.0-i),6.0,1.0) + additionalOffset, GetEntityCoords(PlayerPedId()))^2 <= radius^2) then
                        if not waitForPlayerToLeave then
                            BeginTextCommandDisplayHelp("GS_BROWSE_W")
                                AddTextComponentSubstringPlayerName("~INPUT_CONTEXT~")
                            EndTextCommandDisplayHelp(0, 0, true, -1)
                            if IsControlJustReleased(0, 51) then
								SetPlayerControl(PlayerId(), false)

								local additionalCameraOffset = vec(0,0,0)
								local additionalCameraPoint = vec(0,0,0)
								if type(xnWeapons.interiorIDs[interiorID]) == "table" then
									additionalCameraOffset = xnWeapons.interiorIDs[interiorID].additionalCameraOffset or additionalCameraOffset
									additionalCameraPoint = xnWeapons.interiorIDs[interiorID].additionalCameraPoint or additionalCameraPoint
								end
								
								xnWeapons.currentMenuCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA")
								local cam = xnWeapons.currentMenuCamera
								SetCamCoord(cam, GetOffsetFromInteriorInWorldCoords(interiorID, 3.25,6.5,2.0) + additionalCameraOffset)
								PointCamAtCoord(cam, GetOffsetFromInteriorInWorldCoords(interiorID, 5.0,6.5,2.0) + additionalCameraOffset + additionalCameraPoint)

								SetCamActive(cam, true)
								RenderScriptCams(true, 1, 600, 300, 0)

								Citizen.Wait(600)

								JayMenu.OpenMenu("xnweapons")

								waitForPlayerToLeave = true
                            end
                        end
                    else
                        if waitForPlayerToLeave then waitForPlayerToLeave = false end
					end
				end
			end
			additionalOffset = nil
			interiorID = nil
		end
    end
end)

local function IsWeaponMK2(weaponModel)
    return string.find(weaponModel, "_MK2")
end
local function DoesPlayerOwnWeapon(weaponModel)
    return HasPedGotWeapon(GetPlayerPed(-1), weaponModel, 0)
end

local function DoesPlayerWeaponHaveComponent(weaponModel, componentModel)
    return (DoesPlayerOwnWeapon(weaponModel) and HasPedGotWeaponComponent(GetPlayerPed(-1), weaponModel, componentModel) or false)
end

local function IsPlayerWeaponTintActive(weaponModel, tint)
	return (tint == GetPedWeaponTintIndex(GetPlayerPed(-1), weaponModel))
end

Citizen.CreateThread(function()
	function CreateFakeWeaponObject(weapon, keepOldWeapon)
		if weapon.noPreview then
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = false
			return false 
		end

		local weaponWorldModel = GetWeapontypeModel(weapon.model)
		RequestModel(weaponWorldModel)
		while not HasModelLoaded(weaponWorldModel) do Citizen.Wait(0) end
		
		local interiorID = GetInteriorFromEntity(GetPlayerPed(-1))
		local rotationOffset = 0.0
		local additionalOffset = vec(0,0,0)
		local additionalWeaponOffset = vec(0,0,0)
		if type(xnWeapons.interiorIDs[interiorID]) == "table" then
			rotationOffset = xnWeapons.interiorIDs[interiorID].weaponRotationOffset or 0.0
			additionalOffset = xnWeapons.interiorIDs[interiorID].additionalOffset or additionalOffset
			additionalWeaponOffset = xnWeapons.interiorIDs[interiorID].additionalWeaponOffset or additionalWeaponOffset
		end
		local extraAdditionalWeaponOffset = weapon.offset or vec(0,0,0)

		local fakeWeaponCoords = (GetOffsetFromInteriorInWorldCoords(interiorID, 4.0,6.25,2.0) + additionalOffset) + additionalWeaponOffset + extraAdditionalWeaponOffset
		local fakeWeapon = CreateWeaponObject(weapon.model, weapon.clipSize*3, fakeWeaponCoords, true, 0.0)
		SetEntityAlpha(fakeWeapon, 0)
		SetEntityHeading(fakeWeapon, (GetCamRot(GetRenderingCam(), 1).z - 180)+rotationOffset)
		SetEntityCoordsNoOffset(fakeWeapon, fakeWeaponCoords)

		for i,attach in ipairs(weapon.attachments) do
			if DoesPlayerWeaponHaveComponent(weapon.model, attach.model) then
				GiveWeaponComponentToWeaponObject(fakeWeapon, attach.model)
			end
		end
		if DoesPlayerOwnWeapon(weapon.model) then SetWeaponObjectTintIndex(fakeWeapon, GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model)) end

		if not keepOldWeapon then
			SetEntityAlpha(fakeWeapon, 255)
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = fakeWeapon
		end

		return fakeWeapon
	end
end)

local currentTempWeapon = false
local tempWeaponLocked = false
local function SetTempWeapon(weapon)		
	if (not currentTempWeapon and weapon) or currentTempWeapon ~= weapon.model then
		currentTempWeapon = weapon
		if weapon == false then
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
		else
			if not tempWeaponLocked then
				tempWeaponLocked = true
				Citizen.CreateThread(function()
					CreateFakeWeaponObject(weapon)
					currentTempWeapon = weapon.model
					tempWeaponLocked = false
				end)
			end
		end
	end
end

local currentTempWeaponConfig = {
	component = false,
	tint = false,
}

local function SetTempWeaponConfig(weapon, component, tint)
	Citizen.CreateThread(function()
		if currentTempWeaponConfig.component ~= component or currentTempWeaponConfig.tint ~= tint then
			currentTempWeaponConfig = {
				component = component,
				tint = tint,
			}
			local fakeWeapon = CreateFakeWeaponObject(weapon, true)
			Citizen.Wait(30)
			if currentTempWeaponConfig.component then
				local attachWorldModel = GetWeaponComponentTypeModel(currentTempWeaponConfig.component)
				RequestModel(attachWorldModel)
				while not HasModelLoaded(attachWorldModel) do Citizen.Wait(0) end
				GiveWeaponComponentToWeaponObject(fakeWeapon, currentTempWeaponConfig.component)
			end
			if currentTempWeaponConfig.tint then
				SetWeaponObjectTintIndex(fakeWeapon, currentTempWeaponConfig.tint)
			else
				SetWeaponObjectTintIndex(fakeWeapon, GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model))
			end
			
			-- Wait until we have assigned all the attachments and shit before we actually override the current weapon preview
			SetEntityAlpha(fakeWeapon, 255)
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			xnWeapons.fakeWeaponObject = fakeWeapon
		end
	end)
end

local function GiveWeapon(weaponhash, weaponammo)
    GiveWeaponToPed(GetPlayerPed(-1), weaponhash, weaponammo, false, true)
	SetPedAmmoByType(GetPlayerPed(-1), GetPedAmmoTypeFromWeapon_2(GetPlayerPed(-1), weaponhash), weaponammo)
end

local function GiveAmmo(weaponHash, ammo)
    AddAmmoToPed(GetPlayerPed(-1), weaponHash, ammo)
end

local function GiveMaxAmmo(weaponHash)
	local gotMaxAmmo, maxAmmo = GetMaxAmmo(GetPlayerPed(-1), weaponHash)
	if not gotMaxAmmo then maxAmmo = 99999 end
	SetAmmoInClip(GetPlayerPed(-1), weaponHash, GetWeaponClipSize(weaponHash))
    AddAmmoToPed(GetPlayerPed(-1), weaponHash, maxAmmo) 
end

local function RemoveWeapon(weaponhash)
    RemoveWeaponFromPed(GetPlayerPed(-1), weaponhash)
end

local function GiveComponent(weaponname, componentname, weapon)
	GiveWeaponComponentToPed(GetPlayerPed(-1), weaponname, componentname)
	CreateFakeWeaponObject(weapon)
end

local function RemoveComponent(weaponname, componentname, weapon)
	RemoveWeaponComponentFromPed(GetPlayerPed(-1), weaponname, componentname)
	CreateFakeWeaponObject(weapon)
end

local function SetPlayerWeaponTint(weaponname, tint, weapon)
	SetPedWeaponTintIndex(GetPlayerPed(-1), weaponname, tint)
	CreateFakeWeaponObject(weapon)
end

-- Weapon Saving
local weaponsCanSave = false -- prevent weapons from saving before they are loaded
Citizen.CreateThread(function()
	while GetIsLoadingScreenActive() and not PlayerPedId() do Citizen.Wait(0) end

	if GetConvar("xnw_enableWeaponSaving", true) then
		local loadedWeapons = json.decode(GetResourceKvpString("xnAmmunation:weapons") or "[]")
		for i,weapon in ipairs(loadedWeapons) do
			GiveWeaponToPed(GetPlayerPed(-1), weapon.model, 0, false, true)
			for i,attach in ipairs(weapon.attachments) do
				GiveWeaponComponentToPed(GetPlayerPed(-1), weapon.model, attach.model)
			end
			SetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model, weapon.tint)
			GiveAmmo(weapon.model, weapon.ammo)
		end
		SetPedCurrentWeaponVisible(PlayerPedId(), false, true)
		weaponsCanSave = true
	end
end)
local function SaveWeapons()
	if GetConvar("xnw_enableWeaponSaving", true) then
		local currentWeapons = {}

		for i,class in ipairs(xnWeapons.weaponClasses) do
			for i,weapon in ipairs(class.weapons) do
				if DoesPlayerOwnWeapon(weapon.model) then -- Construct weapons for saving
					local savedweapon = {
						model = weapon.model,
						tint = GetPedWeaponTintIndex(GetPlayerPed(-1), weapon.model),
						ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon.model),
						attachments = {},
					}
					for i,attach in ipairs(weapon.attachments) do
						if DoesPlayerWeaponHaveComponent(weapon.model, attach.model) then
							savedweapon.attachments[#savedweapon.attachments+1] = attach
						end
					end
					currentWeapons[#currentWeapons+1] = savedweapon
				end
			end
		end
		SetResourceKvp("xnAmmunation:weapons", json.encode(currentWeapons))
	end
end
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if weaponsCanSave then
			SaveWeapons()
		end
	end
end)

local function ReleaseWeaponModels()
	for ci,wepTable in pairs(globalWeaponTable) do
		for wi,weaponObject in ipairs(wepTable) do
			if weaponObject[1] and HasModelLoaded(GetWeapontypeModel(weaponObject[1])) then
				SetModelAsNoLongerNeeded(GetWeapontypeModel(weaponObject[1]))
				--print("released "..GetWeapontypeModel(weaponObject[1]))
			end
		end
	end
end


Citizen.CreateThread(function()
    JayMenu.CreateMenu("xnweapons", "Ammunation", function()
		SetPlayerControl(PlayerId(), true)
		SetCamActive(cam, false)
		RenderScriptCams(false, 1, 600, 300, 300)
		if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
		SetPedDropsWeaponsWhenDead(GetPlayerPed(-1), false)
		SaveWeapons() -- Once they exit the store, save their inventory
		ReleaseWeaponModels()
        return true
    end)
	JayMenu.SetSubTitle('xnweapons', "Weapons")

	JayMenu.CreateSubMenu("xnweapons_removeall_confirm","xnweapons","Are you sure?")

    for i,class in ipairs(xnWeapons.weaponClasses) do -- Create all menus for all weapons programatically
		JayMenu.CreateSubMenu("xnw_"..class.name, "xnweapons", class.name, function() 
			if DoesEntityExist(xnWeapons.fakeWeaponObject) then DeleteObject(xnWeapons.fakeWeaponObject) end
			return true
		end)

        for i,weapon in ipairs(class.weapons) do
			JayMenu.CreateSubMenu("xnw_"..class.name.."_"..weapon.model, "xnw_"..class.name, weapon.name, function() 
				SetTempWeaponConfig(weapon, false, false)
				return true
			end)
        end
	end
	
	while true do Citizen.Wait(0)
		if IsAmmunationOpen() then
			if JayMenu.IsMenuOpened('xnweapons') then
				for i,class in ipairs(xnWeapons.weaponClasses) do
					JayMenu.MenuButton(class.name, "xnw_"..class.name)
				end
				JayMenu.Display()
			elseif JayMenu.IsMenuOpened('xnweapons_removeall_confirm') then
				if JayMenu.Button("No") then JayMenu.SwitchMenu("xnweapons")
				elseif JayMenu.Button("~r~Yes") then
					for i,class in ipairs(xnWeapons.weaponClasses) do
						for i,weapon in ipairs(class.weapons) do
							if DoesPlayerOwnWeapon(weapon.model) then
								RemoveWeapon(weapon.model)
							end
						end
					end
					SaveWeapons()
					JayMenu.SwitchMenu("xnweapons")
				end
				JayMenu.Display()
			end

			for i,class in ipairs(xnWeapons.weaponClasses) do
				if JayMenu.IsMenuOpened("xnw_"..class.name) then
					for i,weapon in ipairs(class.weapons) do
						if DoesPlayerOwnWeapon(weapon.model) then -- If they have the weapon take them to the customisation menu, else let them buy it...
							local clicked, hovered = JayMenu.SpriteMenuButton(weapon.name, "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b", "xnw_"..class.name.."_"..weapon.model)
							if clicked then
								--SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
								CreateFakeWeaponObject(weapon)
							elseif hovered then
								SetTempWeapon(weapon)
							end
						else
							local strr = '~g~' .. weapon.price .. '$'
							if weapon.level ~= 0 then
								strr = strr .. '~w~ | ~b~Req. Level '.. weapon.level
							end
							if weapon.donator ~= 0 then
								if weapon.donator == 1 then
									strr = strr .. '~w~ | ~r~Donators'
								elseif weapon.donator == 2 then
									strr = strr .. '~w~ | ~p~Nitro Boosters'
								elseif weapon.donator == 3 then
									strr = strr .. '~w~ | ~o~Prestige'
								end
							end
							local clicked, hovered = JayMenu.Button(weapon.name, strr)
							if clicked then
								ESX.TriggerServerCallback('bb-xnwe:checkMoney', function(hasMoney)
									if hasMoney then
										ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
											if level >= weapon.level then

												if weapon.donator ~= 0 then
													if weapon.donator == 1 then
														if DonatorStatusID.Donator then
															TriggerServerEvent('bb-xnwe:pay', weapon.price)
															GiveWeapon(weapon.model, 250)
															TriggerServerEvent('bb-xnwe:buyWeapon', 'weapon', {name = weapon.model})
															CreateFakeWeaponObject(weapon)
															JayMenu.SwitchMenu("xnw_"..class.name.."_"..weapon.model)
														else
															TriggerEvent('notification', 'Consider donating us at www.realistic-life.co.il', 2)
														end
													elseif weapon.donator == 2 then
														if DonatorStatusID.Nitrobooster then
															TriggerServerEvent('bb-xnwe:pay', weapon.price)
															GiveWeapon(weapon.model, 250)
															TriggerServerEvent('bb-xnwe:buyWeapon', 'weapon', {name = weapon.model})
															SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
															CreateFakeWeaponObject(weapon)
															JayMenu.SwitchMenu("xnw_"..class.name.."_"..weapon.model)
														else
															TriggerEvent('notification', 'Consider boosting us at discord.gg/EwZJjK', 2)
														end
													elseif weapon.donator == 3 then
														if DonatorStatusID.Prestige then
															TriggerServerEvent('bb-xnwe:pay', weapon.price)
															GiveWeapon(weapon.model, 250)
															TriggerServerEvent('bb-xnwe:buyWeapon', 'weapon', {name = weapon.model})
															SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
															CreateFakeWeaponObject(weapon)
															JayMenu.SwitchMenu("xnw_"..class.name.."_"..weapon.model)
														else
															TriggerEvent('notification', 'You didn\'t reach prestige yet', 2)
														end
													end
												else
													TriggerServerEvent('bb-xnwe:pay', weapon.price)
													GiveWeapon(weapon.model, 250)
													TriggerServerEvent('bb-xnwe:buyWeapon', 'weapon', {name = weapon.model})
													SetCurrentPedWeapon(GetPlayerPed(-1), weapon.model, true)
													CreateFakeWeaponObject(weapon)
													JayMenu.SwitchMenu("xnw_"..class.name.."_"..weapon.model)
												end
											else
												TriggerEvent('notification', 'Your level is too low', 2)
											end
										end)
									else
										TriggerEvent('notification', 'You don\'t have enough money', 2)
									end
								end, weapon.price)
								
							elseif hovered then
								SetTempWeapon(weapon)
							end
						end
					end
					JayMenu.Display()
				end
				for i,weapon in ipairs(class.weapons) do
					if JayMenu.IsMenuOpened("xnw_"..class.name.."_"..weapon.model) then
						--[[
						# AMMO STUFF - MOVED TO TOOLSHOP
						if not weapon.noAmmo then
							if JayMenu.Button(weapon.clipSize.."x Rounds", '~b~' .. weapon.price * 0.05 .. '$') then
								ESX.TriggerServerCallback('bb-xnwe:checkMoney', function(hasMoney)
									if hasMoney then
										TriggerServerEvent('bb-xnwe:pay',  weapon.price * 0.05)
										GiveAmmo(weapon.model, weapon.clipSize)
									else
										TriggerEvent('notification', 'You don\'t have enough money', 2)
									end
								end, tonumber(weapon.price * 0.05))
							end
							if JayMenu.Button("Fill Ammo", '~b~' .. weapon.price * 0.45 .. '$') then
								ESX.TriggerServerCallback('bb-xnwe:checkMoney', function(hasMoney)
									if hasMoney then
										TriggerServerEvent('bb-xnwe:pay',  weapon.price * 0.45)
										GiveMaxAmmo(weapon.model)
									else
										TriggerEvent('notification', 'You don\'t have enough money', 2)
									end
								end, tonumber(weapon.price * 0.45))
							end
						end]]

						for i,attachment in ipairs(weapon.attachments) do			
							if DoesPlayerWeaponHaveComponent(weapon.model, attachment.model) then -- If equipped show the gun icon, else show a tick because they "own" the attachment already
								local clicked, hovered = JayMenu.SpriteButton(attachment.name, "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b")
								if clicked then
									RemoveComponent(weapon.model, attachment.model, weapon)
								elseif hovered then
									SetTempWeaponConfig(weapon, false, false)
								end
							else
								local strr = '~g~' .. attachment.price .. '$'
								if attachment.level ~= 0 then
									strr = strr .. '~w~ | ~b~Req. Level '.. attachment.level
								end
								
								if attachment.donator ~= 0 then
									if attachment.donator == 1 then
										strr = strr .. '~w~ | ~r~Donators'
									elseif attachment.donator == 2 then
										strr = strr .. '~w~ | ~p~Nitro Boosters'
									elseif attachment.donator == 3 then
										strr = strr .. '~w~ | ~o~Prestige'
									end
								end
								local clicked, hovered = JayMenu.Button(attachment.name, strr)
								if clicked then
									ESX.TriggerServerCallback('bb-xnwe:checkMoney', function(hasMoney)
										if hasMoney then
											ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
												if level >= attachment.level then
													if attachment.donator ~= 0 then
														if attachment.donator == 1 then
															if DonatorStatusID.Donator then
																TriggerServerEvent('bb-xnwe:pay', attachment.price)
																TriggerServerEvent('bb-xnwe:buyWeapon', 'comp', {name = weapon.model, comp = attachment.model})
																GiveComponent(weapon.model, attachment.model, weapon)
															else
																TriggerEvent('notification', 'Consider donating us at www.realistic-life.co.il', 2)
															end
														elseif attachment.donator == 2 then
															if DonatorStatusID.Nitrobooster then
																TriggerServerEvent('bb-xnwe:pay', attachment.price)
																TriggerServerEvent('bb-xnwe:buyWeapon', 'comp', {name = weapon.model, comp = attachment.model})
																GiveComponent(weapon.model, attachment.model, weapon)
															else
																TriggerEvent('notification', 'Consider boosting us at discord.gg/EwZJjK', 2)
															end
														elseif attachment.donator == 3 then
															if DonatorStatusID.Prestige then
																TriggerServerEvent('bb-xnwe:pay', attachment.price)
																TriggerServerEvent('bb-xnwe:buyWeapon', 'comp', {name = weapon.model, comp = attachment.model})
																GiveComponent(weapon.model, attachment.model, weapon)
															else
																TriggerEvent('notification', 'You didn\'t reach prestige yet', 2)
															end
														end
													else
														TriggerServerEvent('bb-xnwe:pay', attachment.price)
														TriggerServerEvent('bb-xnwe:buyWeapon', 'comp', {name = weapon.model, comp = attachment.model})
														GiveComponent(weapon.model, attachment.model, weapon)
													end
												else
													TriggerEvent('notification', 'Your level is too low', 2)
												end
											end)
										else
											TriggerEvent('notification', 'You don\'t have enough money', 2)
										end
									end, attachment.price)
								elseif hovered then
									SetTempWeaponConfig(weapon, attachment.model, false)
								end
							end
						end
						if not weapon.noTint then
							for i,tint in ipairs((weapon.isMK2 and globalTintTable.mk2 or globalTintTable.mk1)) do
								if IsPlayerWeaponTintActive(weapon.model, tint[1]) then -- If equipped show the gun icon, else show a tick because they "own" the attachment already
									local clicked, hovered = JayMenu.SpriteButton(tint[2], "commonmenu", "shop_gunclub_icon_a", "shop_gunclub_icon_b")
									if clicked then
										SetPlayerWeaponTint(weapon.model, 0, weapon)
									elseif hovered then
										SetTempWeaponConfig(weapon, false, tint[1])
									end
								else
									local strr = '~g~' .. tint[3] .. '$'
									if tint[4] ~= 0 then
										strr = strr .. '~w~ | ~b~Req. Level '.. tint[4]
									end
                                    if tint[5] ~= 0 then
                                        if tint[5] == 1 then
                                            strr = strr .. '~w~ | ~r~Donators'
                                        elseif tint[5] == 2 then
                                            strr = strr .. '~w~ | ~p~Nitro Boosters'
                                        elseif tint[5] == 3 then
                                            strr = strr .. '~w~ | ~o~Prestige'
                                        end
                                    end
                                    local clicked, hovered = JayMenu.Button(tint[2], strr)
									if clicked then
										ESX.TriggerServerCallback('bb-xnwe:checkMoney', function(hasMoney)
											if hasMoney then
												ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
													if level >= tint[4] then
														if tint[5] ~= 0 then
															if tint[5] == 1 then
																if DonatorStatusID.Donator then
																	TriggerServerEvent('bb-xnwe:pay', tint[3])
																	SetPlayerWeaponTint(weapon.model, tint[1], weapon)
																else
																	TriggerEvent('notification', 'Consider donating us at www.realistic-life.co.il', 2)
																end
															elseif tint[5] == 2 then
																if DonatorStatusID.Nitrobooster then
																	TriggerServerEvent('bb-xnwe:pay', tint[3])
																	SetPlayerWeaponTint(weapon.model, tint[1], weapon)
																else
																	TriggerEvent('notification', 'Consider boosting us at discord.gg/EwZJjK', 2)
																end
															elseif tint[5] == 3 then
																if DonatorStatusID.Prestige then
																	TriggerServerEvent('bb-xnwe:pay', tint[3])
																	SetPlayerWeaponTint(weapon.model, tint[1], weapon)
																else
																	TriggerEvent('notification', 'You didn\'t reach prestige yet', 2)
																end
															end
														else
															TriggerServerEvent('bb-xnwe:pay', tint[3])
															SetPlayerWeaponTint(weapon.model, tint[1], weapon)
														end
														
													else
														TriggerEvent('notification', 'Your level is too low', 2)
													end
												end)
											else
												TriggerEvent('notification', 'You don\'t have enough money', 2)
											end
										end, tint[3])
									elseif hovered then
										SetTempWeaponConfig(weapon, false, tint[1])
									end
								end
							end
						end
						JayMenu.Display()
						DisplayAmmoThisFrame(true)
					end
				end
			end

			if xnWeapons.closeMenuNextFrame then
				xnWeapons.closeMenuNextFrame = false
				JayMenu.CloseMenu()
			end
		end
    end
end)

SetPlayerControl(PlayerId(), true)
RenderScriptCams(false, 0, 0, 0, 0)

RegisterNetEvent('bb-xnwe:removeAllWeapons')
AddEventHandler('bb-xnwe:removeAllWeapons', function()
	for i,class in ipairs(xnWeapons.weaponClasses) do
		for i,weapon in ipairs(class.weapons) do
			if DoesPlayerOwnWeapon(weapon.model) then
				RemoveWeapon(weapon.model)
			end
		end
	end
	SaveWeapons()
end)

RegisterNetEvent('bb-xnwe:deleteWeapons')
AddEventHandler('bb-xnwe:deleteWeapons', function(we)
	for _, weapon in pairs(we) do
		RemoveWeapon(weapon)
	end
	SaveWeapons()
end)