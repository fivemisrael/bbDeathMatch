RegisterServerEvent('bb-paycheck:sendPayment')
AddEventHandler('bb-paycheck:sendPayment', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addAccountMoney('bank', amount)
	TriggerClientEvent('bb-notification', _source, "Your Salary Is Here!" ,"You just recived " .. amount .. "$ to your bank account.")
end)