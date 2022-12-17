ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('rl-menu:checkItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)
    if items ~= nil then
    	if tonumber(items.count) > 0 then
            xPlayer.removeInventoryItem(item, 1)
    		cb(true)
    	else
    		cb(false)
    	end
    else
    	cb(false)
    end
end)

ESX.RegisterServerCallback('rl-menu:checkMoney', function(source, cb, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    if money ~= nil then
        if money > count then
            xPlayer.removeMoney(count)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterServerEvent('rl-menu:ems:medsys')
AddEventHandler('rl-menu:ems:medsys', function(closestPlayer)
	local src = source
	TriggerClientEvent('medSystem:send', closestPlayer, src)
end)

RegisterServerEvent('rl-menu:drag')
AddEventHandler('rl-menu:drag', function(closestPlayer)
	TriggerClientEvent('rl-menu:client:drag', closestPlayer, source)
end)


RegisterServerEvent('rl-menu:reviveEvent')
AddEventHandler('rl-menu:reviveEvent', function(target)
    TriggerClientEvent('rl-menu:reviveEvent', target)
end)