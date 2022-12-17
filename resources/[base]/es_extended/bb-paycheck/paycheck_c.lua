ESX               = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('bb-paycheck:calcPayment')
AddEventHandler('bb-paycheck:calcPayment', function()
	ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(xp, lvl)
		local Money = 38000 + (2000 * lvl)
		if DonatorStatusID.Donator then
			if DonatorStatusID.dAgent then
				Money = Money * 1.1
			elseif DonatorStatusID.dHero then
				Money = Money * 1.3
			elseif DonatorStatusID.dSuper then
				Money = Money * 1.5
			end
		end

		TriggerServerEvent('bb-paycheck:sendPayment', Money)
	end)
end)