CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false
local doSync = true

Citizen.CreateThread(function()
    while true do
        if doSync then
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Citizen.Wait(15000)
            end
            Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
            SetBlackout(blackout)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        else
            Citizen.Wait(100)
        end
    end
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime            
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)

        if doSync then
            NetworkOverrideClockTime(hour, minute, 0)
        end
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then blink = false end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent('vSync:notify')
AddEventHandler('vSync:notify', function(message, blink)
    ShowNotification(message, blink)
end)

RegisterNetEvent('vSync:toggle')
AddEventHandler('vSync:toggle', function(enable)
    if enable == nil then enable = not doSync; end
    doSync = enable
end)

-- OneSync Vehicle Shitty Spawns Supress
Citizen.CreateThread(function()
    while true do
        Wait(0)
        SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
        SetVehicleModelIsSuppressed(GetHashKey("dump"), true)
        SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
        SetVehicleModelIsSuppressed(GetHashKey("biff"), true)
    end
end)

local WaitTime = 100
local onlinePlayers = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        onlinePlayers = #GetActivePlayers() 
    end
end)

DensityMultiplier = 1.0
playerMultiplier = 0
robbing = false

fuckingonesync = {
    [1] = { ["x"] = 1822.8262939453, ["y"] = 2248.7468261719, ["z"] = 53.709140777588}, 
    [2] = { ["x"] = 1704.5872802734, ["y"] = 3506.8410644531, ["z"] = 36.429180145264},
    [3] = { ["x"] = 1726.2159423828, ["y"] = 2536.3801269531, ["z"] = 45.564891815186}, 
    [4] = { ["x"] = 148.81317138672, ["y"] = 6529.986328125, ["z"] = 31.715270996094}, 
    [5] = { ["x"] = -383.93887329102, ["y"] = 5997.466796875, ["z"] = 31.456497192383},
    [6] = { ["x"] = 2062.81640625, ["y"] = 3721.5895996094, ["z"] = 33.070247650146},
    [7] = { ["x"] = -216.88275146484, ["y"] = 6320.8959960938, ["z"] = 31.454381942749},
    [8] = { ["x"] = -3100.7924804688, ["y"] = 1186.4498291016, ["z"] = 20.33984375},
    [9] = { ["x"] = -2704.9948730469, ["y"] = 2305.4291992188, ["z"] = 18.006093978882},
    [10] =  { ['x'] = -551.43, ['y'] = 271.11, ['z'] = 82.97 },
    [11] =  { ['x'] = 534.99, ['y'] = -3105.27, ['z'] = 34.56 },
    [12] =  { ['x'] = 2396.26,['y'] = 3112.3,['z'] = 48.15 },
    [13] = { ['x'] = 189.742 ,['y'] = -930.015 ,['z'] = 30.687 }, 
    [14] = { ['x'] = -94.372 ,['y'] = -722.368 ,['z'] = 43.894 },
}

function checkBadAreas()
    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
    local aids = 9999.0
    local returninfo = false
    for i = 1, #fuckingonesync do
        local distance = GetDistanceBetweenCoords(fuckingonesync[i]["x"],fuckingonesync[i]["y"],fuckingonesync[i]["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if distance < 350.0 and aids > distance then
            aids = distance
            returninfo = true
        end
    end
    return returninfo
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1000)

        WalkingMultiplier = string.format("%.2f", ((80 - (onlinePlayers - 0))/260)) 
        DrivingMultiplier = string.format("%.2f", ((80 - (onlinePlayers - 0))/750)) 

        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local driving = false
        local playerPed = GetPlayerPed(-1)
        local currentVehicle = GetVehiclePedIsIn(playerPed, false)
        local inveh = IsPedInAnyVehicle(playerPed, true)

        if inveh then
            local driverPed = GetPedInVehicleSeat(currentVehicle, -1)

            if GetPlayerPed(-1) == driverPed then
                driving = true
            else
                driving = false
            end
        end

        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local aids = checkBadAreas()
        
        if plyCoords["z"] < -25 or aids then
            if driving then
                DensityMultiplier = DrivingMultiplier 
            else
                DensityMultiplier = 0.0 
            end
        else
            DensityMultiplier = WalkingMultiplier
        end
    end

end)

isAllowedToSpawn = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(958.76,-141.4, 74.51, GetEntityCoords(GetPlayerPed(-1))) > 200.0 and driving then
            SetPedDensityMultiplierThisFrame(0.0)
        else
            SetPedDensityMultiplierThisFrame(DensityMultiplier)
        end
            SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetParkedVehicleDensityMultiplierThisFrame(0.1)
            SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
            SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
    end
end)