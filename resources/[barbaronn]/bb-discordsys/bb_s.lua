RegisterServerEvent("bb_discordsys:checkPlayer")
AddEventHandler("bb_discordsys:checkPlayer", function()
    local donor = ""
    local num = 0
    local num2 = GetNumPlayerIdentifiers(source)
    local source = source
    if GetNumPlayerIdentifiers(source) > 0 then
        local discord = nil
        while num < num2 and not discord do
            local a = GetPlayerIdentifier(source, num)
            if string.find(a, "discord") then discord = a end
            num = num+1
        end
        if not discord then
            TriggerClientEvent("skinchanger:checkDonor", source, false)
        else
            PerformHttpRequest("https://discordapp.com/api/guilds/632516303428780042/members/"..string.sub(discord, 9), function(err, text, headers) 
                if GetNumPlayerIdentifiers(source) > 0 then
                    local member = json.decode(text)
                    local name, dec = "", ""
                    for k, v in pairs(member.user) do
                        if k == "username" then
                            name = v
                        elseif k == "discriminator" then
                            dec = tostring(v)
                        end
                    end
                    donor = name .. "#" .. tostring(dec)
                    TriggerClientEvent("bb_discordsys:savePlayer", source, donor)
                end
            end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot NzExNTkxNTEyNTEyNzkwNTY5.XsFPQg.sfN1Um9mOdauWjgHMWDSQjAXRR4"})
        end
    end 
end)