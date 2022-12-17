ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('bb-hud:getPlayerKD', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT * FROM bb_exp WHERE @identifier=identifier LIMIT 1', {
    ['@identifier'] = identifier
    }, function(result)
        if result[1] then
        	local pkd = ""
        	if string.len(tostring(result[1].kills / result[1].deaths)) > 2 then
        		pkd = tostring(result[1].kills / result[1].deaths)
        		pkd = string.sub(pkd, 1, 4) 
        	else
        		pkd = tostring(result[1].kills / result[1].deaths)
        	end
        	cb(pkd)
        else
        	cb('1.0')
        end
    end)
end)

	