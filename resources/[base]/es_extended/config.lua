Config                      = {}
Config.Locale               = 'en'

Config.Accounts             = { 'bank', 'black_money' }
Config.AccountLabels        = { bank = _U('bank'), black_money = _U('black_money') }

Config.ShowDotAbovePlayer   = false
Config.DisableWantedLevel   = true
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)

Config.PaycheckInterval     = 30 * 60000
Config.MaxPlayers           = GetConvarInt('sv_maxclients', 255)

Config.EnableDebug          = false

Config.NotSocietyPayouts = { -- Edited by barbaroNN
	'construction',
	'electrician',
	'fisherman',
	'fueler',
	'garbage',
	'lumberjack',
	'miner',
	'scrap',
	'slaughterer',
	'suduh',
	'tailor',
	'taxi',
	'unemployed'
}