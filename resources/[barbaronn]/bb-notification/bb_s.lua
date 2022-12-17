RegisterServerEvent('bb-notification')
AddEventHandler('bb-notification', function(txt)
    TriggerClientEvent('bb-notification', -1, txt)
end)