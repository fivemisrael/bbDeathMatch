local DonatorRoles = {
    "711344765588865025",
    "711345000536866849",
    "711345103318548563"
}

local dAgent = "711344765588865025"
local dHero = "711345000536866849"
local dSuper = "711345103318548563"

local NitroBooster = {
    "633947315425509386"
}

local BetaTester = {
    "710930690685796502"
}

local Perstige = {
    "711590359469391953"
}

RegisterServerEvent("bb_donatorsys:checkPlayer")
AddEventHandler("bb_donatorsys:checkPlayer", function()
    local donor = {Donator = false, Nitrobooster = false, BetaTester = false, Perstige = false, dAgent = false, dHero = false, dSuper = false}
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
                TriggerClientEvent("skinchanger:checkDonor", source, "check")
                if GetNumPlayerIdentifiers(source) > 0 then
                    local member = json.decode(text)
                    for a, b in ipairs(member.roles) do
                        for _, roleid in pairs(DonatorRoles) do
                            if b == roleid then
                                donor.Donator = true
                            end
                        end
                        for _, roleid in pairs(NitroBooster) do
                            if b == roleid then
                                donor.Nitrobooster = true
                            end
                        end
                        for _, roleid in pairs(BetaTester) do
                            if b == roleid then
                                donor.BetaTester = true
                            end
                        end
                        for _, roleid in pairs(Perstige) do
                            if b == roleid then
                                donor.Perstige = true
                            end
                        end

                        if b == dAgent then
                            donor.dAgent = true
                        elseif b == dSuper then
                            donor.dSuper = true
                        elseif b == dHero then
                            donor.dHero = true
                        end
                    end
                    TriggerClientEvent("bb_donatorsys:savePlayer", source, donor)
                end
            end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot NzExNTkxNTEyNTEyNzkwNTY5.XsFPQg.sfN1Um9mOdauWjgHMWDSQjAXRR4"})
        end
    end 
end)