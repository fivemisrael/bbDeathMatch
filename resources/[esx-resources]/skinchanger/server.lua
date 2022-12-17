RegisterServerEvent("skinchanger:checkDonor")

local donorRole = "676150990638153769"

AddEventHandler("skinchanger:checkDonor", function()
	local donor = false
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
			PerformHttpRequest("https://discordapp.com/api/guilds/653253867768774656/members/"..string.sub(discord, 9), function(err, text, headers) 
				TriggerClientEvent("skinchanger:checkDonor", source, "check")
				if GetNumPlayerIdentifiers(source) > 0 then
					local member = json.decode(text)
					for a, b in ipairs(member.roles) do
						if donorRole == b then
							donor = true
						end
					end
					TriggerClientEvent("skinchanger:checkDonor", source, donor)
				end
			end, "GET", "", {["Content-type"] = "application/json", ["Authorization"] = "Bot NjIyMDYyNjIzMzY5OTg2MDUx.XnVRzQ.Eah6LlT7vSzUFjjdQ17YW5GHYBk"})
		end
	end	
end)