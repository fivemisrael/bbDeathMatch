ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

ESX.RegisterServerCallback("bb_exp:getPlayerXP", function(source, cb)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll('SELECT xp, lvl FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
    ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            cb(result[1].xp, result[1].lvl)
        else
            cb('NF', nil)
        end
    end)
end)

RegisterServerEvent('bb_exp:createDataForNewbies')
AddEventHandler('bb_exp:createDataForNewbies', function()
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    MySQL.Async.execute('INSERT INTO bb_exp (identifier) VALUES (@identifier)', {
        ['@identifier'] = identifier
    }, function(rowsChanged)
    end)
end)

RegisterServerEvent('bb_exp:editData')
AddEventHandler('bb_exp:editData', function(exp, level)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier
    MySQL.Async.execute('UPDATE bb_exp SET xp = @exp, lvl = @level WHERE identifier = @identifier', {
    	['@exp'] = exp,
    	['@level'] = level,
        ['@identifier'] = identifier
    }, function(rowsChanged)
    end)
end)

RegisterServerEvent('bb_exp:giveWeapon')
AddEventHandler('bb_exp:giveWeapon', function(ww)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    xPlayer.addWeapon(ww, 250)
end)

RegisterServerEvent('bb_exp:giveMoney')
AddEventHandler('bb_exp:giveMoney', function(ww)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(ww)
end)

RegisterServerEvent('bb_exp:removeXPForPlayer')
AddEventHandler('bb_exp:removeXPForPlayer', function(playerID, amount)
    if playerID == 'SOURCEE' then
        local _source = source
        playerID = _source
        TriggerClientEvent('bb_exp:removeXP', playerID, amount)
    else
        TriggerClientEvent('bb_exp:removeXP', playerID, amount)
    end
end)

RegisterServerEvent('bb_exp:addXPForPlayer')
AddEventHandler('bb_exp:addXPForPlayer', function(playerID, amount)
    TriggerClientEvent('bb_exp:addXP', playerID, amount)
end)