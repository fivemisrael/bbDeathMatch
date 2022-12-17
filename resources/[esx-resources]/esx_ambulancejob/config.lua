Config                            = {}

Config.ReviveReward               = 50  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = false -- enable anti-combat logging?
Config.Locale = 'en'

local second = 1000
local minute = 30 * second

Config.RespawnTimer          = 1.5 * minute  -- Time til respawn is available

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000