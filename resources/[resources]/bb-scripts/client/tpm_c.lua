local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)
            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                        break
                    end
                    Citizen.Wait(5)
                end
                TriggerEvent('notification', 'Teleported', 1)
            else
                TriggerEvent('notification', "Please place your waypoint.", 2)
            end
        else
            TriggerEvent('notification', "You do not have rights to do this.", 2)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        N_0x4757f00bc6323cfe(-1553120962, 0.0) 
        RestorePlayerStamina(PlayerId(), 1.0)
        RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
        RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
        RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
        Wait(0)
    end
end)