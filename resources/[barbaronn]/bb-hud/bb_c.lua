ESX = nil
local voice = {default = 5.0, shout = 12.0, whisper = 1.0, current = 0, level = nil}
local pvpZoneEnabled, isGreenZone, currentLevel, currentXP, currentMaxXP, playerKD, hasBounty = "", false, 0, 0, 0, 0, false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterFontFile('bahnschrift')
fontId = RegisterFontId('bahnschrift')

AddEventHandler('onClientMapStart', function()
	if voice.current == 0 then
		NetworkSetTalkerProximity(voice.default)
	elseif voice.current == 1 then
		NetworkSetTalkerProximity(voice.shout)
	elseif voice.current == 2 then
		NetworkSetTalkerProximity(voice.whisper)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		-- EXP STUFF
		ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
        	currentLevel = level
        	currentXP = exp
        	currentMaxXP = GetMaxFromLevel(level)
    	end)

    	if EventActive then
    		pvpZoneEnabled = "~g~Enabled"
    	else
    		pvpZoneEnabled = "~r~Disabled"
    	end

    	if isInGreenZone then
    		isGreenZone = "~g~Active"
    	else
    		isGreenZone = "~r~Disabled"
    	end

    	ESX.TriggerServerCallback('bb-hud:getPlayerKD', function(kd)
        	playerKD = kd
    	end)
    	
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		Citizen.Wait(0)
		
		if IsControlJustPressed(1, 74) and IsControlPressed(1, 21) then
			voice.current = (voice.current + 1) % 3
			if voice.current == 0 then
				NetworkSetTalkerProximity(voice.default)
				voice.level = "Normal"
			elseif voice.current == 1 then
				NetworkSetTalkerProximity(voice.shout)
				voice.level = "Shout"
			elseif voice.current == 2 then
				NetworkSetTalkerProximity(voice.whisper)
				voice.level = "Whisper"
			end
		end

		if voice.current == 0 then
			voice.level = "Normal"
		elseif voice.current == 1 then
			voice.level = "Shout"
		elseif voice.current == 2 then
			voice.level = "Whisper"
		end
		drawTxt(0.005, 0.59, 0.2, true, '~p~Voice Mode: ' .. voice.level, 185, 185, 185, 255)
		drawTxt(0.005, 0.6, 0.2, true, '~p~Playing On RealisticLifeDM', 185, 185, 185, 255)
		--drawTxt(0.175, 1.490, 0.4, false, '~s~PvP Zone: ~g~' .. pvpZoneEnabled .. ' ~s~| Green Zone: ~r~' .. isGreenZone, 185, 185, 185, 255)

		drawTxt(0.165, 1.466, 0.5, false, 'K/D: ~p~' .. playerKD .. '~s~', 185, 185, 185, 255)
		drawTxt(0.165, 1.442, 0.5, false, '~s~ID: ~p~' .. GetPlayerServerId(PlayerId()) .. ' ~s~', 185, 185, 185, 255)
		drawTxt(0.165, 1.490, 0.5, false, '~s~Level: ~p~' .. currentLevel .. '~s~', 185, 185, 185, 255)
		drawTxt(0.165, 1.518, 0.5, false, '~s~XP: ~p~' ..currentXP .. '/' .. currentMaxXP .. '~s~', 185, 185, 185, 255)

	end
end)

function drawTxt(x, y, s, ss , text, red, green, blue, alpha)
	SetTextFont(1)--fontId)
	SetTextProportional(1)
	SetTextScale(s, s)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	if ss then
		SetTextEdge(1, 0, 0, 0, 255)
	end
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y - 1 / 2 - 0.065)
end

function GetMaxFromLevel(lvl)
    return Config.Levels[tonumber(lvl) + 1]
end