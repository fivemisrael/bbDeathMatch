ESX = nil
local isWhileLoot = {}

TriggerEvent(
	"esx:getShbbobsfcioraredObjbbobsfciorect",
	function(obj)
		ESX = obj
	end
)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if targetXPlayer ~= nil then
		cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
	else
		cb(nil)
	end
end)

ESX.RegisterServerCallback('bb-inventory:canLootBody', function(source, cb, player)
	local _source = source
	local target = player

	if isWhileLoot[target] == nil or isWhileLoot[target] == _source then
		isWhileLoot[target] = _source
		cb(true)
		return
	else
		TriggerClientEvent('notification', _source, 'Someone is already looted this body.', 2)
		cb(false)
	end
end)

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler( "esx_inventoryhud:tradePlayerItem", function(from, target, type, itemName, itemCount)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	
	if type == "item_standard" then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
			else
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)
			end
		end
	elseif type == "item_money" then
		if sourceXPlayer.getMoney() >= itemCount then
			if itemCount == 0 then
				targetXPlayer.addMoney(sourceXPlayer.getMoney())
				sourceXPlayer.removeMoney(sourceXPlayer.getMoney())
			end
			targetXPlayer.addMoney(itemCount)
			sourceXPlayer.removeMoney(itemCount)
		end
	elseif type == "item_account" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)
		end
	elseif type == "item_weapon" then
		if not targetXPlayer.hasWeapon(itemName) then
			print(itemName)
			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)
			TriggerClientEvent('bb-invenoty:tradeWeaponsG', target)
			TriggerClientEvent('bb-ambulance:isbeingrobbed', _source, itemName)
		end
	end
end)

RegisterServerEvent("esx_inventoryhud:removeFromAlreadyLooted")
AddEventHandler("esx_inventoryhud:removeFromAlreadyLooted", function()
	local _source = source
	isWhileLoot[_source] = nil
end)

RegisterCommand(
	"openinventory",
	function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, "inventory.openinventory") then
			local target = tonumber(args[1])
			local targetXPlayer = ESX.GetPlayerFromId(target)

			if targetXPlayer ~= nil then
				TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source, target, targetXPlayer.name)
			else
				TriggerClientEvent("chatMessage", source, "^1" .. _U("no_player"))
			end
		else
			TriggerClientEvent("chatMessage", source, "^1" .. _U("no_permissions"))
		end
	end
)