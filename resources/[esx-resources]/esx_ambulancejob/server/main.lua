ESX = nil
local playersHealing = {}

TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:rebbobsfciorvive')
AddEventHandler('esx_ambulancejob:rebbobsfciorvive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		xPlayer.addMoney(Config.ReviveReward)
		TriggerClientEvent('esx_ambulancejob:rebbobsfciorvive', target)
	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
		
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ambulancejob:remademoney')
AddEventHandler('esx_ambulancejob:remademoney', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney((xPlayer.getMoney()/3))
end)

--[[
TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local cash = xPlayer.getMoney()
	local black = xPlayer.getAccount('black_money').money
	PerformHttpRequest('https://discordapp.com/api/webhooks/709282115736436796/VutCoe6uNl78EZ9u25gY2Ojg3to9HPCXBoBge8Y20pQqH5zPsgtyp2jHshsh3p6Y75y1', function(err, text, headers) end, 'POST', json.encode({username = "LostCash Log", content = "__**" .. GetPlayerName(source) .. "**__ Lost **" .. cash .. "** **cash.** "}), { ['Content-Type'] = 'application/json' })
	PerformHttpRequest('https://discordapp.com/api/webhooks/709282115736436796/VutCoe6uNl78EZ9u25gY2Ojg3to9HPCXBoBge8Y20pQqH5zPsgtyp2jHshsh3p6Y75y1', function(err, text, headers) end, 'POST', json.encode({username = "LostCash Log", content = "__**" .. GetPlayerName(source) .. "**__ Lost **" .. black .. "** **BlackCash.** "}), { ['Content-Type'] = 'application/json' })
	
	
	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
				local list = xPlayer.inventory[i].name
				local amount = xPlayer.inventory[i].count
				PerformHttpRequest('https://discordapp.com/api/webhooks/709282115736436796/VutCoe6uNl78EZ9u25gY2Ojg3to9HPCXBoBge8Y20pQqH5zPsgtyp2jHshsh3p6Y75y1', function(err, text, headers) end, 'POST', json.encode({username = "LostInventory Log", content = "__**" .. GetPlayerName(source) .. "**__ Lost **" .. list .. "** Amount : **" .. amount .. "** **[Items]** "}), { ['Content-Type'] = 'application/json' })
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
			local weapon = xPlayer.loadout[i].name
			PerformHttpRequest('https://discordapp.com/api/webhooks/709282115736436796/VutCoe6uNl78EZ9u25gY2Ojg3to9HPCXBoBge8Y20pQqH5zPsgtyp2jHshsh3p6Y75y1', function(err, text, headers) end, 'POST', json.encode({username = "LostLoadout Log", content = "__**" .. GetPlayerName(source) .. "**__ Lost **" .. weapon .. "** **[Weapon]** "}), { ['Content-Type'] = 'application/json' })
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medkit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medkit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	elseif (itemName ~= 'bandage' and itemName ~= 'medkit' and itemName ~= 'firstaid' and itemName ~= 'aspirin') then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.weight ~= -1 then
		count = xItem.weight - xItem.count
	end

	if xItem.count < xItem.weight then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)]]

TriggerEvent('es:addGroupCommand', 'revive', 'superadmin', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ambulancejob:rebbobsfciorvive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ambulancejob:rebbobsfciorvive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(isDead) ~= 'boolean' then
		print(('esx_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)