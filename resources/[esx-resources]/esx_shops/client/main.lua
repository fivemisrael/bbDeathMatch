ESX = nil
local hasAlreadyEnteredMarker, lastZone
local currentAction, currentActionMsg, currentActionData = nil, nil, {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_shops:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

function OpenShopMenu(zone)
	local elements = {}
	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label      = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('shop_item', ESX.Math.GroupDigits(item.price))),
			itemLabel = item.label,
			item       = item.item,
			price      = item.price,

			-- menu properties
			value      = 1,
			type       = 'slider',
			min        = 1,
			max        = 100
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = _U('shop'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('shop_confirm', data.current.value, data.current.itemLabel, ESX.Math.GroupDigits(data.current.price * data.current.value)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				TriggerServerEvent('esx_shops:buyItem', data.current.item, data.current.value, zone)
			end

			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()

		currentAction     = 'shop_menu'
		currentActionMsg  = _U('press_menu')
		currentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	currentAction     = 'shop_menu'
	currentActionMsg  = _U('press_menu')
	currentActionData = {zone = zone}
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	currentAction = nil
	ESX.UI.Menu.CloseAll()
end)


-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, false

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				local distance = GetDistanceBetweenCoords(playerCoords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z + 1.0, true)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false

					if distance < Config.Size.x then
						isInMarker  = true
						currentZone = k
						lastZone    = k
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction then
			ESX.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) then
				if currentAction == 'shop_menu' then
					OpenShopMenu(currentActionData.zone)
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx-shops:reload')
AddEventHandler('esx-shops:reload', function()
	local playerPed = GetPlayerPed(-1)
	ClearPedTasks(playerPed)
	TaskReloadWeapon(playerPed)
	local found, currentWeapon = GetCurrentPedWeapon(playerPed, true)
	print(currentWeapon)
	local pedAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon)
	local newAmmo = pedAmmo + 29
	local found, maxAmmo = GetMaxAmmo(playerPed, currentWeapon)
	if newAmmo < maxAmmo then
		SetPedAmmo(playerPed, currentWeapon, newAmmo)
	end
end)

RegisterNetEvent('esx-shops:lightarm')
AddEventHandler('esx-shops:lightarm', function()
	local ped = PlayerPedId()

	local timer = 25000
	if DonatorStatusID.Donator then
		timer = 7000
	elseif DonatorStatusID.Nitrobooster then
		timer = 20000
	end

	local finished = exports["bb-taskbar"]:taskBar(timer, "Setting Up Armor")
    SetPedArmour(ped, 70)
end)

RegisterNetEvent('esx-shops:heavyarm')
AddEventHandler('esx-shops:heavyarm', function()
	local ped = PlayerPedId()

	local timer = 25000
	if DonatorStatusID.Donator then
		timer = 7000
	elseif DonatorStatusID.Nitrobooster then
		timer = 20000
	end

	local finished = exports["bb-taskbar"]:taskBar(timer, "Setting Up Armor")
    SetPedArmour(ped, 150)
end)

RegisterNetEvent('esx-shops:heal')
AddEventHandler('esx-shops:heal', function(typ)
	local ped = PlayerPedId()
	
	if typ == "medkit" then
		local finished = exports["bb-taskbar"]:taskBar(16000, "Healing Yourself")
    	SetEntityHealth(ped, 250)
    else
    	local health = GetEntityHealth(ped)
    	local finished = exports["bb-taskbar"]:taskBar(12000, "Healing Yourself")
    	SetEntityHealth(ped, health + 70)
    end
end)

RegisterNetEvent('rl-menu:revive')
AddEventHandler('rl-menu:revive', function()
    local src = source
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 5.0 then
        TriggerEvent('bb-notification', "Revive System" ,"No players nearby.")
    else
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        
        if IsPedDeadOrDying(closestPlayerPed, 1) then
            local playerPed = PlayerPedId()
            TriggerEvent('bb-notification', "Revive System" ,"Started Revive The Player.")
            
            local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
            
            local Timer, TimerType = 0, 0
            if DonatorStatusID.Donator then
                Timer = 7
                TimerType = 1
            elseif DonatorStatusID.Nitrobooster then
                Timer = 15
                TimerType = 2
            else
                Timer = 25
                TimerType = 0
            end
        
            Citizen.CreateThread(function()
                while Timer > 0 do
                    if TimerType == 0 then
                        drawTxt(0.415, 1.35, '~b~[Regular] ~s~Reviving In ~b~'.. Timer .. ' ~sSeconds', 185, 185, 185, 255)
                    elseif TimerType == 1 then
                        drawTxt(0.415, 1.35, '~r~[Donator] ~s~Reviving In ~r~'.. Timer .. ' ~sSeconds', 185, 185, 185, 255)
                    elseif TimerType == 2 then
                        drawTxt(0.415, 1.35, '~p~[NitroBooster] ~s~Reviving In ~p~'.. Timer .. ' ~sSeconds', 185, 185, 185, 255)
                    end
                    Wait(0)
                end
            end)
        
            while Timer > 0 do
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
                Timer = Timer - 1
                Wait(900)
            end
            
            TriggerServerEvent('rl-menu:reviveEvent', GetPlayerServerId(closestPlayer))
            TriggerEvent('bb-notification', "Revive System" ,"You revived " .. GetPlayerName(closestPlayer) .. " successfully.")
        else
            TriggerEvent('bb-notification', "Revive System" ,"That player is not conscious.")
        end
    end
end) 

RegisterNetEvent('rl-menu:reviveEvent')
AddEventHandler('rl-menu:reviveEvent', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    Citizen.CreateThread(function()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(50)
        end
        local formattedCoords = {
            x = ESX.Math.Round(coords.x, 1),
            y = ESX.Math.Round(coords.y, 1),
            z = ESX.Math.Round(coords.z, 1)
        }

        ESX.SetPlayerData('lastPosition', formattedCoords)
        TriggerServerEvent('esx:updateLastPosition', formattedCoords)
        RespawnPed(playerPed, formattedCoords, 0.0)

        StopScreenEffect('DeathFailOut')
        DoScreenFadeIn(800)
    end)
end)

function drawTxt(x, y, text, red, green, blue, alpha)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextScale(0.4, 0.4)
    SetTextColour(red, green, blue, alpha)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y - 1 / 2 - 0.065)
end

function RespawnPed(ped, coords, heading)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
    ClearPedBloodDamage(ped)

    ESX.UI.Menu.CloseAll()
end