ESX             = nil
local ShopItems = {}

TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item', {}, function(shopResult)
		for i=1, #shopResult, 1 do
			if shopResult[i].name then
				if ShopItems[shopResult[i].store] == nil then
					ShopItems[shopResult[i].store] = {}
				end

				table.insert(ShopItems[shopResult[i].store], {
					label = shopResult[i].label,
					item  = shopResult[i].item,
					price = shopResult[i].price,
				})
			else
				print(('esx_shops: invalid item "%s" found!'):format(shopResult[i].item))
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_shops:requestDBItems', function(source, cb)
	cb(ShopItems)
end)

RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	amount = ESX.Math.Round(amount)

	-- is the player trying to exploit?
	if amount < 0 then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	-- get price
	local price = 0
	local itemLabel = ''

	for i=1, #ShopItems[zone], 1 do
		if ShopItems[zone][i].item == itemName then
			price = ShopItems[zone][i].price
			itemLabel = ShopItems[zone][i].label
			break
		end
	end

	price = price * amount

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(itemName, amount)
		TriggerClientEvent('notification', xPlayer.source, 'You bought ' .. amount .. 'x ' .. itemLabel .. ' for ' .. ESX.Math.GroupDigits(price) ..'$', 1)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('notification', xPlayer.source, 'You do not have enough money.', 2)
	end
end)

ESX.RegisterUsableItem('lightarm', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('lightarm', 1)
    TriggerClientEvent('esx-shops:lightarm', playerId)
end)

ESX.RegisterUsableItem('heavyarm', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('heavyarm', 1)
    TriggerClientEvent('esx-shops:heavyarm', playerId)
end)

ESX.RegisterUsableItem('medkit', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('medkit', 1)
    TriggerClientEvent('esx-shops:heal', playerId, 'medkit')
end)

ESX.RegisterUsableItem('clip', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('clip', 1)
    TriggerClientEvent('esx-shops:reload', playerId)
end)

RegisterServerEvent('giveAmmo')
AddEventHandler('giveAmmo', function(weaponName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addWeaponAmmo(weaponName, 35)
end)

ESX.RegisterUsableItem('firstaidkit', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('firstaidkit', 1)
    TriggerClientEvent('esx-shops:heal', playerId, 'firstaidkit')
end)

ESX.RegisterUsableItem('revivekit', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('revivekit', 1)
    TriggerClientEvent('rl-menu:revive', playerId)
end)


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

RegisterServerEvent('rl-menu:reviveEvent')
AddEventHandler('rl-menu:reviveEvent', function(target)
    TriggerClientEvent('rl-menu:reviveEvent', target)
end)