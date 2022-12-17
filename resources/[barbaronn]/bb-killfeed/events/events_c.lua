local killstrike = 0

Citizen.CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon, killer2
	local _source = source
    local playerPed = PlayerPedId()

	while true do
		Citizen.Wait(0)
		if IsEntityDead(PlayerPedId()) then
			Citizen.Wait(1000)
			local PedKiller = GetPedSourceOfDeath(playerPed)
			DeathCauseHash = GetPedCauseOfDeath(playerPed)
			Weapon = WeaponNames[tostring(DeathCauseHash)]

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			
			local strr = "<div style=\"margin-bottom: 5px; display: block;\"><b><span style=\"color: lightblue\">" .. GetPlayerName(Killer) .. "</span> <img src='"
--[[
			if (Killer == PlayerId()) then
				--strr = strr .. EConfig.Logos.murdered
				strr = strr .. EConfig.Logos.riddled
				DeathReason = 'committed suicide'
			elseif (Killer == nil) then
				--strr = strr .. EConfig.Logos.murdered
				strr = strr .. EConfig.Logos.riddled
				DeathReason = 'died'
			else]]
				while not Killer do
					Wait(0)
				end
				if IsMelee(DeathCauseHash) then
					DeathReason = 'ss'
					strr = strr .. EConfig.Logos.murdered
				elseif IsTorch(DeathCauseHash) then
					DeathReason = 'torched'
					strr = strr .. EConfig.Logos.torched
				elseif IsKnife(DeathCauseHash) then
					DeathReason = 'knifed'
					strr = strr .. EConfig.Logos.knifed
				elseif IsPistol(DeathCauseHash) then
					DeathReason = 'pistoled'
					strr = strr .. EConfig.Logos.pistoled
				elseif IsSub(DeathCauseHash) then
					DeathReason = 'riddled'
					strr = strr .. EConfig.Logos.riddled
				elseif IsRifle(DeathCauseHash) then
					DeathReason = 'rifled'
					strr = strr .. EConfig.Logos.rifled
				elseif IsLight(DeathCauseHash) then
					DeathReason = 'machine gunned'
					strr = strr .. EConfig.Logos.riddled
				elseif IsShotgun(DeathCauseHash) then
					DeathReason = 'pulverized'
					strr = strr .. EConfig.Logos.pulverized
				elseif IsSniper(DeathCauseHash) then
					DeathReason = 'sniped'
					strr = strr .. EConfig.Logos.sniped
				elseif IsHeavy(DeathCauseHash) then
					DeathReason = 'obliterated'

					strr = strr .. EConfig.Logos.minigun
				elseif IsMinigun(DeathCauseHash) then
					DeathReason = 'shredded'
					strr = strr .. EConfig.Logos.minigun
				elseif IsBomb(DeathCauseHash) then
					DeathReason = 'bombed'
					strr = strr .. EConfig.Logos.bombed
				elseif IsVeh(DeathCauseHash) then
					DeathReason = 'mowed over'
					strr = strr .. EConfig.Logos.murdered
				elseif IsVK(DeathCauseHash) then
					DeathReason = 'flattened'
					strr = strr .. EConfig.Logos.murdered
				elseif (Killer == PlayerId() or Killer == nil) then
					--strr = strr .. EConfig.Logos.murdered
					strr = strr .. EConfig.Logos.riddled
					DeathReason = 'committed suicide'
				else
					DeathReason = 'killed'
					strr = strr .. EConfig.Logos.murdered
				end
			--end
			strr = strr .. "' style=\"position: absulote; margin-top: 2px; height: 23px; margin-bottom: -5px\"> <span style=\"color: orange\">".. GetPlayerName(PlayerId()) .."</span></b></div>"
			
			if DeathReason == 'committed suicide' or DeathReason == 'died' then
				TriggerServerEvent('bb-killfeed:ToggleDisplayEveryone', GetPlayerName(PlayerId()) ..' Committed Suicide.')
			else
				TriggerServerEvent('bb-killfeed:ToggleDisplayEveryone', strr)
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)


function IsMelee(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsTorch(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsKnife(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsPistol(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSub(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsRifle(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsLight(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsShotgun(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsSniper(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsHeavy(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsMinigun(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsBomb(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVeh(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

function IsVK(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

