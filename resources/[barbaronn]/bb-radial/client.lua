ESX               = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterFontFile('bahnschrift')
fontId = RegisterFontId('bahnschrift')

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Menu state
local showMenu = false

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local MAX_MENU_ITEMS = 9

-- Main thread
Citizen.CreateThread(function()
    local keyBind = "F1"
    while true do
        Citizen.Wait(0)
        if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) and showMenu then
            showMenu = false
            SetNuiFocus(false, false)
        end
        if IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) then
            showMenu = true
            local enabledMenus = {}
            for _, menuConfig in ipairs(rootMenuConfig) do
                if menuConfig:enableMenu() then
                    local dataElements = {}
                    local hasSubMenus = false
                    if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                        hasSubMenus = true
                        local previousMenu = dataElements
                        local currentElement = {}
                        for i = 1, #menuConfig.subMenus do
                            if newSubMenus[menuConfig.subMenus[i]] ~= nil and newSubMenus[menuConfig.subMenus[i]].enableMenu ~= nil and not newSubMenus[menuConfig.subMenus[i]]:enableMenu() then
                                else
                                currentElement[#currentElement+1] = newSubMenus[menuConfig.subMenus[i]]
                                currentElement[#currentElement].id = menuConfig.subMenus[i]
                                currentElement[#currentElement].enableMenu = nil
    
                                if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                                    previousMenu[MAX_MENU_ITEMS + 1] = {
                                        id = "_more",
                                        title = "More",
                                        icon = "#more",
                                        items = currentElement
                                    }
                                    previousMenu = currentElement
                                    currentElement = {}
                                end
                            end
                        end
                        if #currentElement > 0 then
                            previousMenu[MAX_MENU_ITEMS + 1] = {
                                id = "_more",
                                title = "More",
                                icon = "#more",
                                items = currentElement
                            }
                        end
                        dataElements = dataElements[MAX_MENU_ITEMS + 1].items

                    end
                    enabledMenus[#enabledMenus+1] = {
                        id = menuConfig.id,
                        title = menuConfig.displayName,
                        functionName = menuConfig.functionName,
                        icon = menuConfig.icon,
                    }
                    if hasSubMenus then
                        enabledMenus[#enabledMenus].items = dataElements
                    end
                end
            end
            SendNUIMessage({
                state = "show",
                resourceName = GetCurrentResourceName(),
                data = enabledMenus,
                menuKeyBind = keyBind
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)

            -- Play sound
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)


            while showMenu == true do Citizen.Wait(100) end
            Citizen.Wait(100)
            while IsControlPressed(1, keybindControls[keyBind]) and GetLastInputMethod(2) do Citizen.Wait(100) end
        end
    end
end)
-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })
    -- Play sound
   --  PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('triggerAction', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        state = 'destroy'
    })

    -- Play sound
    -- PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Run command
    --ExecuteCommand(data.action)
    TriggerEvent(data.action, data.parameters)

    -- Send ACK to callback function
    cb('ok')
end)

RegisterNetEvent("menu:menuexit")
AddEventHandler("menu:menuexit", function()
    showMenu = false
    SetNuiFocus(false, false)
end)

RegisterNetEvent('rl-menu:vehicle:toggleMenu')
AddEventHandler('rl-menu:vehicle:toggleMenu', function()
    exports['carcontrol']:OpenUI()
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
            
            ESX.TriggerServerCallback('rl-menu:checkItem', function(hasrevivekit)
                if hasrevivekit then
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
                    TriggerEvent('bb-notification', "Revive System" ,"You dont have revive kit.")
                end
            end, 'revivekit')
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