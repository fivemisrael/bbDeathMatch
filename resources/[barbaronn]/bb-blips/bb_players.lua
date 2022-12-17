local isRadarExtended = false

Citizen.CreateThread(function()
    local blips = {}
    local currentPlayer = PlayerId()
    while true do
        Wait(1)
        if IsControlJustPressed( 0, 19 ) then
            if not isRadarExtended then
                SetRadarBigmapEnabled( true, false )
                isRadarExtended = true
                Citizen.CreateThread(function()
                    run = true
                    while run do
                        for i = 0, 500 do
                            Wait(1)
                            if not isRadarExtended then
                                run = false
                                break
                            end
                        end

                        SetRadarBigmapEnabled( false, false )
                        isRadarExtended = false
                    end
                end)
            else
                SetRadarBigmapEnabled( false, false )
                isRadarExtended = false
            end
        end

        
        Wait(10)
        for player = 0, 31 do
            if player ~= currentPlayer and NetworkIsPlayerActive(player) then
                local playerPed = GetPlayerPed(player)
                local playerName = GetPlayerName(player)
        
                RemoveBlip(blips[player])
        		
                local new_blip = AddBlipForEntity(playerPed)
                SetBlipNameToPlayerName(new_blip, player)
                if IsPlayerDead(player) then
                	SetBlipColour(new_blip, 1)
                	SetBlipAsShortRange(new_blip, true)
                else
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        SetBlipSprite(blip, 225)
                    end
                	SetBlipColour(new_blip, 0)
                	SetBlipAsShortRange(new_blip, false)
                end
                SetBlipCategory(new_blip, 2)
                SetBlipScale(new_blip, 0.6)
        
                Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
                blips[player] = new_blip
            end
        end
    end
end)