RegisterServerEvent('bb-killfeed:ToggleDisplayEveryone')
AddEventHandler('bb-killfeed:ToggleDisplayEveryone', function(txt)
    TriggerClientEvent('bb-killfeed:ToggleDisplay', -1, txt)
end)