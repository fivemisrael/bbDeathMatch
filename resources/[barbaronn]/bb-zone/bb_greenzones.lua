ESX = nil
local PlayerData		= {}
isInGreenZone = false

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
end)

local zones = {
	-- CLOTHES
	[1] = {
		Dist = 7.0,
		Locations = {
			vector3(72.3, -1399.1, 28.4),
			vector3(-703.8, -152.3, 36.4),
			vector3(-167.9, -299.0, 38.7),
			vector3(428.7, -800.1, 28.5),
			vector3(-829.4, -1073.7, 10.3),
			vector3(-1447.8, -242.5, 48.8),
			vector3(11.6, 6514.2, 30.9),
			vector3(123.6, -219.4, 53.6),
			vector3(1696.3, 4829.3, 41.1),
			vector3(618.1, 2759.6, 41.1),
			vector3(1190.6, 2713.4, 37.2),
			vector3(-1193.4, -772.3, 16.3),
			vector3(-3172.5, 1048.1, 19.9),
			vector3(-1108.4, 2708.9, 18.1)
		}
	},

	-- Weapon Shops
	[2] = {
		Dist = 15.0,
		Locations = {
			vector3(-662.1, -935.3, 20.8),
			vector3(810.2, -2157.3, 28.6),
			vector3(1693.4, 3759.5, 33.7),
			vector3(-330.2, 6083.8, 30.4),
			vector3(252.3, -50.0, 68.9),
			vector3(17.14, -1116.89, 28.8),
			vector3(2567.6, 294.3, 107.7),
			vector3(-1117.5, 2698.6, 17.5),
			vector3(842.4, -1033.4, 27.1)
		}
	},

	-- Banks
	[3] = {
		Dist = 15.0,
		Locations = {
			vector3(150.266, -1040.203, 29.374),
			vector3(-1212.980, 330.841, 37.787),
			vector3(-2962.582, 482.627, 15.703),
			vector3(314.187, 278.621, 54.170),
			vector3(-351.534, 49.529, 49.042),
			vector3(241.727, 220.706, 106.286),
			vector3(-113.12, 6470.16, 31.63),
			vector3(1176.0833740234,2706.3386230469,37.157722473145)
		}
	},

	-- Garages
	[4] = {
		Dist = 20.0,
		Locations = {
			vector3(229.700, -800.1149, 29.5722),
			vector3(401.77, -1337.07, 31.34),
			vector3(642.8, 193.89, 96.14),
			vector3(359.51, 275.88, 103.21),
			vector3(615.67, 96.08,  92.37),
			vector3(-335.19, 285.28,  85.76),
			vector3(277.91, 76.25,  94.36),
			vector3(-784.72, -2025.49,  8.87),
			vector3(-668.61, -2020.36,  8.39),
			vector3(-617.15, -2225.46,  6.01),
			vector3(-1072.23, -1391.73, 4.42),
			vector3(-472.18, -778.1,  30.56),
			vector3(292.48, -334.69,  43.92),
			vector3(495.35, -67.98,  77.69),
			vector3(75.26, 19.58, 69.16),
			vector3(-73.48, -2018.14, 17.02),
			vector3(-41.41, -2106.78, 16.7),
			vector3(-164.61, -2133.14, 16.7),
			vector3(-212.37, -1325.48, 30.58)
		}
	},

	-- Vehicleshop
	[5] = {
		Dist = 20.0,
		Locations = {
			vector3(-45.32, -1098.38, 26.42)
		}
	},

	-- Shops
	[6] = {
		Dist = 15.0,
		Locations = {
			vector3(1135.808, -982.281,  45.415),
			vector3(-1222.915,-906.983,  11.326),
			vector3(-1487.553,-379.107,  39.163),
			vector3(127.830,  -1284.796, 28.280),
			vector3(-1393.409,-606.624,  29.319),
			vector3(-559.906, 287.093,   81.176),
			vector3(-48.519,  -1757.514, 28.421),
			vector3(1163.373, -323.801,  68.205),
			vector3(-707.501, -914.260,  18.215)
		}
	}
}

local notifIn, notifOut = false, false
local closestCategorey, closestLocation, closestDists = '', 1, 0.0
local showalert = false

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		local i, j = 0, 0
		for name, categories in pairs(zones) do
			i = 0
			j = j + 1
			for _, location in pairs(categories.Locations) do
				i = i + 1
				dist = Vdist(location, x, y, z)
				if dist < minDistance then
					minDistance = dist
					closestCategorey = j
					closestLocation = i
					closestDists = categories.Dist
				end
			end
		end
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	while true do
		for _, bank in pairs(zones[3].Locations) do
			DrawMarker(1, bank.x, bank.y, bank.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0, 30.0, 5.0, 127, 20, 249, 100, false, true, 2, false, nil, nil, false)
		end
		for _, bank in pairs(zones[2].Locations) do
			DrawMarker(1, bank.x, bank.y, bank.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 30.0, 30.0, 5.0, 127, 20, 249, 100, false, true, 2, false, nil, nil, false)
		end
		Wait(0)
	end
end)

local cruise = false
Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestCategorey].Locations[closestLocation].x, zones[closestCategorey].Locations[closestLocation].y, zones[closestCategorey].Locations[closestLocation].z, x, y, z)
		
		if dist <= closestDists then 
			if not notifIn then	
				NetworkSetFriendlyFireOption(false)
				ClearPlayerWantedLevel(PlayerId())
				SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
				SetEntityAlpha(player, 128)
				isInGreenZone = true
				
				if not showalert then
					showalert = true
					TriggerEvent('bb-html:client', 'greenzoneIn')
					--DisplayNative('j')
				end

				notifIn = true
				notifOut = false
				if closestCategorey == 2 or closestCategorey == 3 then
					if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
						if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)['y'] > 0 then
							Citizen.CreateThread(function()
								cruise = true
								while cruise do
									if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
										local cruiseVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
										if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (2.0) then
											SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0)
										end
									end
									Wait(25)
								end
							end)
						end
					end
				end

			end
		else
			if not notifOut then
				NetworkSetFriendlyFireOption(true)
				SetEntityAlpha(player, 255)
				isInGreenZone = false
				
				if showalert then
					showalert = false
					--DisplayNative('l')
					TriggerEvent('bb-html:client', 'greenzoneOut')
					cruise = false
				end
				notifOut = true
				notifIn = false
			end
		end
	
		if notifIn then
			
			DisableControlAction(0, 140, true)
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisableControlAction(1, 45, true) -- disable R Key
			DisablePlayerFiring( player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
      		DisableControlAction(0, 106, true) -- Disable in-game mouse controls
      		DisableControlAction(2, 25, true) -- Disable in-game mouse controls
      		SetPlayerCanDoDriveBy(PlayerId(), false)
		end

		if notifOut then
			SetPlayerCanDoDriveBy(PlayerId(), true)
		end
	end
end)
