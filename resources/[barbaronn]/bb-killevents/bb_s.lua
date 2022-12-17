ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

RegisterServerEvent('bb-killevents:playerDied')
AddEventHandler('bb-killevents:playerDied', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- EXP STUFF
    TriggerClientEvent('bb_exp:removeXP', _source, 1)
    -- K/D STUFF
    MySQL.Async.fetchAll('SELECT deaths FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local currentDeaths = result[1].deaths
            local newDeaths = currentDeaths + 1
            MySQL.Async.execute('UPDATE bb_exp SET deaths = @newkills WHERE identifier = @identifier', {
                ['@newkills'] = newDeaths,
                ['@identifier'] = xPlayer.identifier
            }, function(rowsChanged)
            end)
        end
    end)

    -- KILLSTRIKE / MONEY STUFF
    TriggerClientEvent('bb_exp:resetKillstrike', _source)
end)

RegisterServerEvent('bb-killevents:playerKilled')
AddEventHandler('bb-killevents:playerKilled', function(KillerID, DeathData)
    local _source, killer = source, KillerID
    local xPlayer, xKiller  = ESX.GetPlayerFromId(_source), ESX.GetPlayerFromId(killer)

    -- EXP STUFF
    TriggerClientEvent('bb_exp:removeXP', _source, 1)
    TriggerClientEvent('bb_exp:addXP', killer, 2)

    -- K/D STUFF
    MySQL.Async.fetchAll('SELECT kills FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
        ['@identifier'] = xKiller.identifier
    }, function(result)
        if result[1] then
            local currentKills = result[1].kills
            local newKills = currentKills + 1
            MySQL.Async.execute('UPDATE bb_exp SET kills = @newkills WHERE identifier = @identifier', {
                ['@newkills'] = newKills,
                ['@identifier'] = xKiller.identifier
            }, function(rowsChanged)
            end)
        end
    end)

    MySQL.Async.fetchAll('SELECT deaths FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local currentDeaths = result[1].deaths
            local newDeaths = currentDeaths + 1
            MySQL.Async.execute('UPDATE bb_exp SET deaths = @newkills WHERE identifier = @identifier', {
                ['@newkills'] = newDeaths,
                ['@identifier'] = xPlayer.identifier
            }, function(rowsChanged)
            end)
        end
    end)

    -- KILLSTRIKE / MONEY STUFF
    TriggerClientEvent('bb_exp:addKillstrike', killer)
    TriggerClientEvent('bb_exp:resetKillstrike', _source)
    TriggerClientEvent('bb_exp:heal', killer)
end)