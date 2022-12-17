DiscordName = ""

RegisterNetEvent("bb_discordsys:savePlayer")
AddEventHandler("bb_discordsys:savePlayer", function(discname)
    DiscordName = discname
end)

CreateThread(function()
    TriggerServerEvent("bb_discordsys:checkPlayer")
end)

RegisterCommand('refreshname', function()
    TriggerServerEvent("bb_discordsys:checkPlayer")
end)

RegisterCommand('discordname', function()
    print(DiscordName)
end)

RegisterCommand('msg', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	TriggerServerEvent('bb-chat:sendOocGlobally', DiscordName, msg)
end, false)