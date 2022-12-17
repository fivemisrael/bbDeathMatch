RegisterServerEvent('bb-html')
AddEventHandler('bb-html', function(txt)
    TriggerClientEvent('bb-html:client', -1, txt)
end)