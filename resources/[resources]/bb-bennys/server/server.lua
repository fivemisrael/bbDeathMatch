ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
local Vehicles = nil

local tbl = {
[1] = {locked = false, player = nil},
[2] = {locked = false, player = nil},
[3] = {locked = false, player = nil},
[4] = {locked = false, player = nil},
[5] = {locked = false, player = nil},
[6] = {locked = false, player = nil},
}

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	mymoney = tonumber(button.price)
	if button.price then -- check if button have price
		if button.price < xPlayer.getMoney() then
			TriggerClientEvent("LSC:buttonSelected", source,name, button, true)
			xPlayer.removeMoney(button.price)
			TriggerClientEvent('LSC:installMod', _source)
		else
			TriggerClientEvent("LSC:buttonSelected", source,name, button, false)
			TriggerClientEvent('LSC:cancelInstallMod', _source)
		end
	end
end)

RegisterServerEvent('LSC:refreshOwnedVehicle')
AddEventHandler('LSC:refreshOwnedVehicle', function(myCar)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = myCar.plate
    }, function(result)
        if result[1] then
            local vehicle = json.decode(result[1].vehicle)

            if vehicle.model == myCar.model then

                MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
                    {
                        ['@plate'] = myCar.plate,
                        ['@vehicle'] = json.encode(myCar)
                    })

            else
				print(('esx_lscustom: %s attempted to upgrade an vehicle with model mismatch!'):format(xPlayer.identifier))
			end
        end
    end)
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end)