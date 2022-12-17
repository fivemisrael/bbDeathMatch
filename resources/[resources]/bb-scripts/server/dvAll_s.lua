RegisterCommand('dvallveh', function(source, args, rawCommand) TriggerClientEvent("wld:delallveh", -1) end, true)

Citizen.CreateThread(function()
	while true do
		TriggerClientEvent("wld:delallveh", -1)
		Wait(300000)
	end
end)