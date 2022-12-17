Config                            = {}
Config.DrawDistance               = 35.0
Config.MarkerColor                = {r = 144, g = 252, b = 3}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 70

Config.Locale                     = 'en'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {

	ShopEntering = {
		Pos   = vector3(-42.88, -1104.42, 26.42),
		Size    = { x = 0.5, y = 0.5, z = 0.3 },
		Type  = 20
	},

	ShopInside = {
		Pos     = vector3(-45.76,-1097.57,26.42),
		Size    = {x = 0.701, y = 1.0001, z = 0.3001},
		Heading = 243.77,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(224.737,-1082.982,29.163),
		Size    = {x = 0.701, y = 1.0001, z = 0.3001},
		Heading = 357.431,
		Type    = -1
	},

	BossActions = {
		Pos   = vector3(249.346,-1093.12,29.418),
		Size    = { x = 0.5, y = 0.5, z = 0.3 },
		Type  = 20
	},

	GiveBackVehicle = {
		Pos   = vector3(0.0, 0.0, 0.0),
		Size    = { x = 0.5, y = 0.5, z = 0.3 },
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	ResellVehicle = {
		Pos   = vector3(-52.218,-1687.79,29.034),
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Type  = 36
	}
}

Config.ShowroomVehicles = {
	audi = {
		model = 'audirs6tk',
		price = 2750000,
		Pos = 	{x = -47.44, y = -1101.96, z = 26.22},
		heading = 301.42
	},

	m8 = {
		model = 'bmwm8',
		price = 3525000,
		Pos = 	{x = -42.04, y = -1094.36, z = 26.22},
		heading = 71.33
	}

}