local idVisable = true
ESX = nil
Citizen.CreateThread(function()
  	while ESX == nil do
    	TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
    	Citizen.Wait(0)
  	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)



Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 32),
		uptime = '000000',
		playTime = '00h 00m'
	})
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({
		action  = 'updatePing',
		players = connectedPlayers
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

function UpdatePlayerTable(connectedPlayers)
	

	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers1)
		local formattedPlayerList = {}
		local players = 0
		for k,v in pairs(connectedPlayers1) do
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.level, v.name, v.id, v.kd, v.lbrank, v.prestige, v.cash, v.ping))
	
			players = players + 1
		end
		SendNUIMessage({
			action  = 'updatePlayerList',
			players = table.concat(formattedPlayerList)
		})

		SendNUIMessage({
			action = 'updatePlayerJobs',
			jobs   = {player_count = players}
		})
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 10) and IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)
		end
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({action  = 'close'})
			shouldDraw = false
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({action = 'toggle'})
end

--[[
Citizen.CreateThread(function()
    local animationState = false
    while true do
        Citizen.Wait(0)

        if shouldDraw then
            local nearbyPlayers = GetNeareastPlayers()
            for k, v in pairs(nearbyPlayers) do
                local x, y, z = table.unpack(v.coords)
                Draw3DText(x, y, z + 1.1, v.playerId)
            end
        end
    end
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8 * (1 / dist) * (1 / GetGameplayCamFov()) * 100

        SetTextScale(scale, scale)
        SetTextFont(2)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEdge(15, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


function GetNeareastPlayers()
	local playerPed = PlayerPedId()
	local playerlist = GetActivePlayers()

    local players_clean = {}
    local found_players = false

    for i = 1, #playerlist, 1 do
        found_players = true
        table.insert(players_clean, { playerName = GetPlayerName(playerlist[i]), playerId = GetPlayerServerId(playerlist[i]), coords = GetEntityCoords(GetPlayerPed(playerlist[i])) })
    end
    return players_clean
end]]