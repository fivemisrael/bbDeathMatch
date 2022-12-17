--[[
    Made by BarBaroNN#0006.
    All rights reserved.
]]--

ESX               = nil
local timedoutVehicles = {}
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SpawnVehicle(vehicle, plate)
	local playerPed = PlayerPedId()
	local playerPosition = GetEntityCoords(playerPed)
	local radius = 45.
	local z = 1500.
	local tryCount = 0
	local spawnPoint
	while true do
		Citizen.Wait(0)

		local diff = { r = radius * math.sqrt(GetRandomFloatInRange(0.0, 1.0)), theta = GetRandomFloatInRange(0.0, 1.0) * 2 * math.pi }
		local xDiff = diff.r * math.cos(diff.theta)
		if xDiff >= 0 then
			xDiff = math.max(radius, xDiff)
		else
			xDiff = math.min(-radius, xDiff)
		end

		local yDiff = diff.r * math.sin(diff.theta)
		if yDiff >= 0 then
			yDiff = math.max(radius, yDiff)
		else
			yDiff = math.min(-radius, yDiff)
		end

		local x = playerPosition.x + xDiff
		local y = playerPosition.y + yDiff

		local _, groundZ = GetGroundZFor_3dCoord(x, y, z)
		local validCoords, coords = GetSafeCoordForPed(x, y, groundZ + 1., false, 16)

		if validCoords then
			for _, i in ipairs(GetActivePlayers()) do
				if i ~= PlayerId() then
					local ped = GetPlayerPed(i)

					if DoesEntityExist(ped) then
						local pedCoords = GetEntityCoords(ped)
						if Vdist(coords.x, coords.y, coords.z, pedCoords.x, pedCoords.y, pedCoords.z) < 50. then
							validCoords = false
							break
						end
					end
				end
			end
		end

		if validCoords then
			spawnPoint = { }
			spawnPoint.x, spawnPoint.y, spawnPoint.z = coords.x, coords.y, coords.z
		else
			if tryCount ~= 120 then
				tryCount = tryCount + 1
			else
				radius = radius + 25.
				tryCount = 0
			end
		end

		if spawnPoint then
			break
		end
	end

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = spawnPoint.x,
		y = spawnPoint.y,
		z = spawnPoint.z + 1
	},  100.0, 
	function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		TriggerEvent('notification', 'Vehicle Spawned.', 1, 5000)
		TriggerEvent('bb-garage:timeOutVehicle', callback_vehicle, plate)
	end)
	
	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

function GarageMenu()
	ESX.UI.Menu.CloseAll()
	local elems = {}
	table.insert(elems, {label = 'Available Vehicles:'})

	ESX.TriggerServerCallback('bb-garage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			TriggerEvent('notification', 'You dont own any Cars!', 2, 3000)
		else
			for _,v in pairs(ownedCars) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName  = GetLabelText(aheadVehName)
				local plate        = v.plate
				local labelvehicle
				
				if v.stored then
					labelvehicle = plate..' | '..vehicleName
				else
					labelvehicle = plate..' | '..vehicleName
				end
					
				table.insert(elems, {label = labelvehicle, value = v})
			end
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
			title    = 'Your Vehicles',
			align    = 'left',
			elements = elems
		}, function(data, menu)
			local newplate = string.gsub(data.current.value.plate, ' ', '')
			if timedoutVehicles[newplate] ~= true then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
			else
				TriggerEvent('notification', 'Your car is already on use. You cant take it out atm.', 2, 2500)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('bb-garage:timeOutVehicle')
AddEventHandler('bb-garage:timeOutVehicle', function(vehicle, plate)
	local newplate = string.gsub(plate, ' ', '')
	while DoesEntityExist(vehicle) do
		timedoutVehicles[newplate] = true
		local ownVehicle = AddBlipForEntity(vehicle)
		SetBlipSprite(ownVehicle, 225)
		SetBlipColour(ownVehicle, 2)
		SetBlipScale(ownVehicle, 0.7)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Own Vehicle')
		EndTextCommandSetBlipName(ownVehicle)
		Wait(5000)
		RemoveBlip(ownVehicle)
	end
	Wait(10000)
	timedoutVehicles[newplate] = false
end)

Citizen.CreateThread(function()
  	while true do
  		Citizen.Wait(0)
        if IsControlJustReleased(0, 170) then
            GarageMenu()
        end
    end
end)