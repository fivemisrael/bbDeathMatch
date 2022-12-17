Citizen.CreateThread(function()
    for a,b in ipairs(Config.Categories) do
        for k,v in ipairs(b.Locations) do
            local blip = AddBlipForCoord(v)
            SetBlipSprite(blip, b.Sprite)
            SetBlipColour(blip, b.Color)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(b.Display)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

Citizen.CreateThread(function()
    local cc = 1
    local lst = 0
    for k,v in ipairs(Config.Zones.Locations) do
        
        local blip
        if cc == 1 then
            blip = AddBlipForRadius(v, 2515.1)
            SetBlipSprite (blip, 10)
        elseif cc >= 2 and cc <= 5 then
            blip = AddBlipForRadius(v, 2545.1)
            SetBlipSprite (blip, 5)
        elseif cc >= 6 and cc <= 31 then
            if cc == 6 then
                lst = 2567.1
            end
            blip = AddBlipForRadius(v, lst)
            SetBlipSprite (blip, 10)
            lst = lst + 50
        elseif cc >= 31 and cc <= 50 then
            blip = AddBlipForRadius(v, 900.0)
            SetBlipSprite (blip, 5)
        end
        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, 58)
        SetBlipAlpha (blip, 255)
        
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Zones.Display)
        EndTextCommandSetBlipName(blip)
        cc = cc + 1
    end
end)