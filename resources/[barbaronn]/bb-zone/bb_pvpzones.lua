ESX = nil
local PlayerData		= {}
EventActive = false

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end

    while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
    TriggerServerEvent('bb-pvpzones:getCurrentStatus')
end)

local notifIn = false
local notifOut = false
local EventZone, EventTimer = nil, 0
local blip = nil

RegisterNetEvent('bb-pvpzones:startEvent')
AddEventHandler('bb-pvpzones:startEvent', function(eventZone, eventTimer)
	DisplayNativePvP('started', '')
	EventActive = true
	EventZone = eventZone
	EventTimer = eventTimer

	blip = AddBlipForRadius(eventZone, 200.0)
	SetBlipSprite (blip, 9)
	SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 58)
    SetBlipAlpha (blip, 128)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('PvP Zone')
    EndTextCommandSetBlipName(blip)

	Citizen.CreateThread(function()
		while EventTimer > 0 do
			EventTimer = EventTimer - 1
			Wait(1000)
		end
		RemoveBlip(blip)
	end)
	EventActive = false
end)

AddEventHandler('onResourceStop', function(resourceName)
  	if (GetCurrentResourceName() == resourceName) then
		RemoveBlip(blip)
  	end
end)

--[[
Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
		
		if dist <= 40.0 then 
			if not notifIn then	
				
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then

				notifOut = true
				notifIn = false
			end
		end
	end
end)]]

function DisplayNativePvP(typ, txt)
	local a = 150
	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

	while a > 0 do
		a = a - 1
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		BeginTextComponent("STRING")
		if typ == 'timer' then
			AddTextComponentString("~y~PvP Zone In " .. txt .. " Minutes")
		elseif typ == 'started' then
			AddTextComponentString("~p~PvP Zone Just Started")
		end
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)
	end
end