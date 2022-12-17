ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

local timer = 0
local TimerStarted, EventStarted = false, false
local EventZone, EventTimer = nil, 0

TriggerEvent('es:addGroupCommand', 'startpvpzone', 'superadmin', function(source, args, user)
	if not TimerStarted and not EventStarted then
		TimerStarted = true
		EventZone = nil
		timer = 600

		while timer > 0 do
			if timer == 600 then
				TriggerClientEvent('bb-notification', -1, "PvP Zone" ,"Event Starts In "  .. 10 .. " Minutes")
			elseif timer == 300 then
				TriggerClientEvent('bb-notification', -1, "PvP Zone" ,"Event Starts In "  .. 5 .. " Minutes")
			elseif timer == 120 then
				TriggerClientEvent('bb-notification', -1, "PvP Zone" ,"Event Starts In "  .. 2 .. " Minutes")
			elseif timer == 60 then
				TriggerClientEvent('bb-notification', -1, "PvP Zone" ,"Event Starts In "  .. 1 .. " Minutes")
			end
			timer = timer - 1
			Citizen.Wait(1000)
		end

		TimerStarted = false
		EventStarted = true

		local zones = {
			vector3(198.04, -934.96, 30.69),
			vector3(-1175.25, 62.0, 30.69),
			vector3(-1195.18, -1788.6, 30.69),
			vector3(1120.28, -544.51, 30.69),
			vector3(-1335.83, -3043.31, 13.94)
		}

		EventZone = zones[math.random(#zones)]
		EventTimer = 300
		TriggerClientEvent('bb-pvpzones:startEvent', -1, EventZone, EventTimer)
		while EventTimer > 0 do
			EventTimer = EventTimer - 1
			Citizen.Wait(1000)
		end

		EventStarted = false
	end
end)

RegisterServerEvent('bb-pvpzones:getCurrentStatus')
AddEventHandler('bb-pvpzones:getCurrentStatus', function()
	TriggerClientEvent('bb-pvpzones:eventStatus', -1, EventStarted)
end)