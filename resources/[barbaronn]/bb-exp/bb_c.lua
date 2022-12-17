
ESX               = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Citizen.Wait(500)
    ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
        if exp == 'NF' then
            TriggerServerEvent('bb_exp:createDataForNewbies')
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(0, 20) then
            ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
                CreateRankBar(1, GetMaxFromLevel(level), exp, exp, level, false)
            end)
        end
    end
end)

RegisterNetEvent('bb_exp:addXP')
AddEventHandler('bb_exp:addXP', function(expp)
    ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
        local newXP = exp + expp
        print(newXP)
        if GetMaxFromLevel(level) < newXP then
            CreateRankBar(1, GetMaxFromLevel(level), exp, GetMaxFromLevel(level), level, false)
            CreateRankBar(1, GetMaxFromLevel(level + 1), 0, 1, level + 1, false)
            TriggerServerEvent('bb_exp:editData', 0, level + 1)

            Citizen.CreateThread(function()
                html = '<span style=\"position: absolute; left: 35%;top: 120px;\"><img \" width=\"550px\" src=\"levelup.png\"></img></span>'
                a = 800
                while a > 0 do
                    SendNUIMessage({
                        type = true,
                        html = html
                    })
                    a = a - 1
                    Citizen.Wait(0)
                    print(a)
                end
                SendNUIMessage({
                    type = true,
                    html = ""
                })
            end)
        else
            CreateRankBar(1, GetMaxFromLevel(level), exp, newXP, level, false)
            TriggerServerEvent('bb_exp:editData', newXP, level)
        end
    end)
end)

RegisterNetEvent('bb_exp:removeXP')
AddEventHandler('bb_exp:removeXP', function(expp)
    ESX.TriggerServerCallback('bb_exp:getPlayerXP', function(exp, level)
        local newXP = exp - expp
        if newXP <= 0 and level ~= 0 then
            newXP = GetMaxFromLevel(level - 1) - expp
            CreateRankBar(1, GetMaxFromLevel(level), exp, GetMaxFromLevel(level), level, true)
            CreateRankBar(1, GetMaxFromLevel(level - 1), exp, newXP, level - 1, true)
            TriggerServerEvent('bb_exp:editData', GetMaxFromLevel(level-1) - expp, level - 1)
        else
            CreateRankBar(1, GetMaxFromLevel(level), exp, newXP, level, true)
            TriggerServerEvent('bb_exp:editData', newXP, level)
        end
    end)
end)

function GetMaxFromLevel(lvl)
    return Config.Levels[tonumber(lvl) + 1]
end

function CreateRankBar(StartLimit, EndLimit, PreviousXP, CurrentXP, CurrentLevel, TakingAwayXP)
    RankBarColor = 116 
    if TakingAwayXP then
        RankBarColor = 6
    end
    
    if not HasHudScaleformLoaded(19) then
        RequestHudScaleform(19)
        while not HasHudScaleformLoaded(19) do
            Wait(1)
        end
    end

    BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
    PushScaleformMovieFunctionParameterInt(RankBarColor)
    EndScaleformMovieMethodReturn()
    
    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
    PushScaleformMovieFunctionParameterInt(StartLimit)
    PushScaleformMovieFunctionParameterInt(EndLimit)
    PushScaleformMovieFunctionParameterInt(PreviousXP)
    PushScaleformMovieFunctionParameterInt(CurrentXP)
    PushScaleformMovieFunctionParameterInt(CurrentLevel)
    PushScaleformMovieFunctionParameterInt(100)
    EndScaleformMovieMethodReturn()
end