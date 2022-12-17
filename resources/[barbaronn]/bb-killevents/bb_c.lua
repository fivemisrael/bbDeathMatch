ESX               = nil
killstrike = 0
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('baseevents:onPlayerDied', function()
	TriggerServerEvent('bb-scoreboard:reloadScores')
	TriggerServerEvent('bb-killevents:playerDied')
end)

AddEventHandler('baseevents:onPlayerKilled', function(KillerType, DeathData)
	TriggerServerEvent('bb-scoreboard:reloadScores')
	TriggerServerEvent('bb-killevents:playerKilled', KillerType, DeathData)
end)

RegisterNetEvent('bb_exp:heal')
AddEventHandler('bb_exp:heal', function()
	ped = GetPlayerPed(-1)
	local health = GetEntityHealth(ped)
	nhealth = health + 50
	SetEntityHealth(ped, nhealth)
end)

RegisterNetEvent('bb_exp:resetKillstrike')
AddEventHandler('bb_exp:resetKillstrike', function()
	killstrike = 0
end)

RegisterNetEvent('bb_exp:addKillstrike')
AddEventHandler('bb_exp:addKillstrike', function()
	killstrike = killstrike + 1

	if killstrike == 1 then
		TriggerServerEvent('bb_exp:giveMoney', 4000)
	elseif killstrike == 2 then
		TriggerServerEvent('bb_exp:giveMoney', 6000)
	elseif killstrike == 3 then
		TriggerServerEvent('bb_exp:giveMoney', 8000)
	elseif killstrike >= 4 then
		TriggerServerEvent('bb_exp:giveMoney', 10000)
	end
end)