
ESX               = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 303) then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if IsPlayerDead(closestPlayer) and not IsPedInAnyVehicle(PlayerPedId(), false) then 
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    ESX.TriggerServerCallback('bb-inventory:canLootBody', function(canLoot)
                        while not canLoot do Wait(0) end
                        
                        if canLoot then
                            TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
                        end
                    end, GetPlayerServerId(closestPlayer))
                end
            end
        end
    end
end)