Citizen.CreateThread(function()
AddEventHandler('chatMessage', function(source, name, message)
	if GetPlayerIdentifiers(source)[1] ~= "steam:110000119f6d64d" then
  		PerformHttpRequest('https://discordapp.com/api/webhooks/724935286777315399/IvU8jfsajhtNb4pkhF5onwVTiBzYjKsjpFpStJomU3C07UHNYt6sj3p6nuXKv6vzpF_L', function(err, text, headers) end, 'POST', json.encode({username = name .. " | " .. GetPlayerIdentifiers(source)[1], content = message}), { ['Content-Type'] = 'application/json' })
  		end
	end)
end)

Citizen.CreateThread(function()
RegisterServerEvent('barbaronn:SendWebhookDiscordMsg')
AddEventHandler('barbaronn:SendWebhookDiscordMsg', function(discordURL, name, message)
	  PerformHttpRequest(discordURL, function(err, text, headers) end, 'POST', json.encode({username = name , content = message}), { ['Content-Type'] = 'application/json' })
	end)
end)