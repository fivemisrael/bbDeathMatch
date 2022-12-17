ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

local connectedPlayers = {}

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	AddPlayerToScoreboard(xPlayer, true)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(45000)
		UpdatePing()
		AddPlayersToScoreboard()
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	AddPlayersToScoreboard()
end)

function getPlayerLevel(xPlayer)
	
    MySQL.Async.fetchAll('SELECT lvl FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
    ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            return result[1].lvl
        else
        	return 0
        end
    end)
end

function getPlayerKD(xPlayer)
	local identifier = xPlayer.identifier
    
end

function getPlayerlbrank(xPlayer)
	local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT identifier FROM bb_exp ORDER BY lvl DESC', {},
    function(result)
    	local counter = 1
        for v = 1, #result do
        	if result[v].identifier == identifier then
        		return v
        	end
        end
        return ''
    end)
end

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].ping = GetPlayerPing(playerId)
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].name = Sanitize(xPlayer.getName())
	connectedPlayers[playerId].level = 0
	connectedPlayers[playerId].kd = "1.0"
	connectedPlayers[playerId].prestige = 0
	connectedPlayers[playerId].lbrank= 0

	connectedPlayers[playerId].cash = xPlayer.getMoney() .. '$'
	connectedPlayers[playerId].job = xPlayer.job.name

	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll('SELECT * FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
    ['@identifier'] = identifier
    }, function(result)
        if result[1] then
        	connectedPlayers[playerId].level = result[1].lvl
        	local pkd = ""
        	if string.len(tostring(result[1].kills / result[1].deaths)) > 2 then
        		pkd = tostring(result[1].kills / result[1].deaths)
        		pkd = string.sub(pkd, 1, 4) 
        	else
        		pkd = tostring(result[1].kills / result[1].deaths)
        	end

        	connectedPlayers[playerId].kd = pkd
        	connectedPlayers[playerId].prestige = result[1].prestige
        	connectedPlayers[playerId].lbrank = 0
        	
        end
    end)
end

Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
		SetConvarServerInfo('Uptime', uptime)


		TriggerClientEvent('uptime:tick', -1, uptime)
		TriggerEvent('uptime:tick', uptime)
	end
end)

RegisterServerEvent('bb-scoreboard:reloadScores')
AddEventHandler('bb-scoreboard:reloadScores', function()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, true)
	end
end)

function AddPlayersToScoreboard()
	local players = ESX.GetPlayers()

	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
		AddPlayerToScoreboard(xPlayer, false)
	end

	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
	end

	TriggerClientEvent('esx_scoreboard:updatePing', -1, connectedPlayers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

