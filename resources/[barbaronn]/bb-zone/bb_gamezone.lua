ESX = nil
local PlayerData		= {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

local notifIn = false
local notifOut = false
local closestZone = 1
local dropsEnabled = false
local eddd

local zones = {
	vector3(-136.69, -1510.62, 33.59)
}


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		local i = 0
		for _, location in pairs(zones) do
			i = i + 1
			dist = Vdist(location, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		
		Citizen.Wait(15000)
	end
end)

local tpzz
Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
		eddd = dist

		if dist <= 2494.5 then 
			if not notifIn then	
				tpzz = 'j'
				TriggerEvent('bb-gamezone:Display')
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				tpzz = 'l'
				TriggerEvent('bb-gamezone:Display')
				notifOut = true
				notifIn = false

			end
		end
		--[[
		if notifIn then
			DisableControlAction(0, 140, true)
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisableControlAction(1, 45, true) -- disable R Key
			DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      		DisableControlAction(0, 106, true) -- Disable in-game mouse controls
		end]]
	end
end)


RegisterNetEvent('bb-gamezone:Display')
AddEventHandler('bb-gamezone:Display', function()
	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	if tpzz == 'j' then
		local a = 250
		while a > 0 do
			a = a - 1
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			BeginTextComponent("STRING")
			AddTextComponentString("~g~Entered Zone")
			EndTextComponent()
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			HideHudAndRadarThisFrame()
			Citizen.Wait(0)
		end
	elseif tpzz == 'l' then
		local a = 7
		local active = true
		Citizen.CreateThread(function()
			while a > 0 do
				a = a - 1
				Citizen.Wait(1000)

				if tpzz == 'j' then
					a = 0
				end
			end
			active = false
		end)

		while active do
			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			BeginTextComponent("STRING")
			AddTextComponentString("~r~You Left The Zone, Time Left " .. a .. " Seconds")
			EndTextComponent()
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			HideHudAndRadarThisFrame()
			Citizen.Wait(0)
		end

		if a == 0 and tpzz == 'l' then
			ped = GetPlayerPed(-1)
			local health = GetEntityHealth(ped)
			print(health)
			while health > 0 do
				health = health - 10
				SetEntityHealth(ped, health)
				Wait(1000)
			end
		end
	end
end)

local coordsVisible = false
function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5
			DrawGenericText(("DIST : %s | TPZZ : %s"):format(eddd, tpzz))
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

RegisterCommand("dist", function()
    ToggleCoords()
end)