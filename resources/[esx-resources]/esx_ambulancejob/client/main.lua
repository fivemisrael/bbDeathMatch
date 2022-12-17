Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local firstSpawn, PlayerLoaded = true, false
local isbeingrobbed, removedstuff = false, {}

isDead = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('playerSpawned', function()
	isDead = false

	if firstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		firstSpawn = false

		
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
			if shouldDie then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end

				--TriggerEvent('bb-xnwe:removeAllWeapons')
				print('Removed All Weapons')
			end
		end)
	end

	TriggerServerEvent('esx_inventoryhud:removeFromAlreadyLooted')

    bbexpConfig = {
		{
			min = 0,
			max = 6,
			we = 'WEAPON_SNSPISTOL'
		},
		{
			min = 7,
			max = 12,
			we = 'WEAPON_PISTOL'
		},
		{
			min = 13,
			max = 20,
			we = 'WEAPON_HEAVYPISTOL'
		},

		{
			min = 21,
			max = 25,
			we = 'WEAPON_MICROSMG'
		},
		
	}

	ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
		plyData = ESX.GetPlayerData()
        for k, v in pairs(bbexpConfig) do
        	if tonumber(level) <= v.max and tonumber(level) >= v.min then
        		TriggerServerEvent('bb_exp:giveWeapon', v.we)
        		--GiveWeapon(v.we, 250)
        		break
        	end
        end
    end)

	local player = GetPlayerPed(-1)
	local timer = 7
	Citizen.CreateThread(function()
		SetEntityAlpha(player, 128)
		SetPlayerInvincible(player, true)
		while timer > 0 do
			timer = timer - 1
			Wait(1000)
		end
		SetEntityAlpha(player, 255)
		SetPlayerInvincible(player, false)
	end)
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['F10'], true)
			EnableControlAction(0, Keys['PAGEUP'], true)
			EnableControlAction(0, Keys['M'], true)
			EnableControlAction(0, Keys['Z'], true)
			EnableControlAction(0, Keys['Q'], true)		
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	StartDeathTimer()
	--StartDistressSignal()

	StartScreenEffect('DeathFailOut', 0, 0)
	
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medkit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()
		local ped = GetPlayerPed(-1)

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
	
			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			TriggerEvent('mythic_hospital:client:RemoveBleed', playerPed)
			TriggerEvent('mythic_hospital:client:ResetLimbs', playerPed)
			ESX.ShowNotification(_U('used_medkit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			TriggerEvent('mythic_hospital:client:RemoveBleed', playerPed)
			TriggerEvent('mythic_hospital:client:ResetLimbs', playerPed)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)


function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end


function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.RespawnTimer / 1000)

	Citizen.CreateThread(function()
		isbeingrobbed = false
		removedstuff = {}
		TriggerServerEvent('esx_ambulancejob:remademoney')
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld
		local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
		
		PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)

			PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
			BeginTextComponent("STRING")
			AddTextComponentString("~p~" .. _U('respawn_available_in', secondsToClock(earlySpawnTimer)))
			EndTextComponent()
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			HideHudAndRadarThisFrame()
		end

		StopScreenEffect("DeathFailOut")
		if isDead then
			TriggerEvent('esx_ambulancejob:rebbobsfciorvive')
		end
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:rebbobsfciorvive')
AddEventHandler('esx_ambulancejob:rebbobsfciorvive', function()
	local playerPed = PlayerPedId()
	local ped = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local playerPosition = GetEntityCoords(playerPed)
		local radius = 100.
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

		local midPoint = vector3(-136.69, -1510.62, 33.59)
		local spPoint = vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z)
		local isInZone = (#(spPoint - midPoint) < 2494.5)
		if isInZone then
			ESX.SetPlayerData('lastPosition', spawnPoint)
			TriggerServerEvent('esx:updateLastPosition', spawnPoint)
			RespawnPed(playerPed, spawnPoint, 0.0)
		else
			local garageRespawns = {
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
				vector3(-73.48, -2018.14, 19.02),
				vector3(-41.41, -2106.78, 16.7),
				vector3(-164.61, -2133.14, 16.7),
			}

			local newSpawnPoint = garageRespawns[math.random(#garageRespawns)]
			local spPoint = {}
			spPoint.x, spPoint.y, spPoint.z = newSpawnPoint.x, newSpawnPoint.y
			ESX.SetPlayerData('lastPosition', spPoint)
			TriggerServerEvent('esx:updateLastPosition', spPoint)
			RespawnPed(playerPed, newSpawnPoint, 0.0)
		end
		--[[
		ESX.SetPlayerData('lastPosition', spawnPoint)
		TriggerServerEvent('esx:updateLastPosition', spawnPoint)
		RespawnPed(playerPed, spawnPoint, 0.0)]]

		TriggerEvent('bb-xnwe:deleteWeapons', removedstuff)
		isbeingrobbed = false
		removedstuff = {}
		--TriggerEvent('bb-xnwe:removeAllWeapons')
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

-- main variables
local cam = nil
local isDead = false
local angleY = 0.0
local angleZ = 0.0

--------------------------------------------------
---------------------- LOOP ----------------------
--------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        -- process cam controls if cam exists and player is dead
        if (cam and isDead) then
            ProcessCamControls()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        if (not isDead and NetworkIsPlayerActive(PlayerId()) and IsPedFatallyInjured(PlayerPedId())) then
            isDead = true
            
            StartDeathCam()
        elseif (isDead and NetworkIsPlayerActive(PlayerId()) and not IsPedFatallyInjured(PlayerPedId())) then
            isDead = false
            
            EndDeathCam()
        end
    end
end)

--------------------------------------------------
------------------- FUNCTIONS --------------------
--------------------------------------------------

-- initialize camera
function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

-- destroy camera
function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    
    cam = nil
end

-- process camera controls
function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- disable 1st person as the 1st person camera can cause some glitches
    DisableFirstPersonCamThisFrame()
    
    -- calculate new position
    local newPos = ProcessNewPosition()

    -- focus cam area
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    
    -- set coords of cam
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    
    -- set rotation
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
        
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX 
    angleY = angleY + mouseY 
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (1.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (1.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (1.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 1.5
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 1.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }  
    return pos
end

RegisterNetEvent('bb-ambulance:isbeingrobbed')
AddEventHandler('bb-ambulance:isbeingrobbed', function(weaponname)
	isbeingrobbed = true
	table.insert(removedstuff, weaponname)
end)