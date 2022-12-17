----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

--- Config ---
notWhitelisted = "[RealisticLifeDM] You cant join the server yet, Make sure you recived your beta on https://discord.gg/PC4KkM5." -- Message displayed when they are not whitelist with the role
noDiscord = "[RealisticLifeDM] You must have Discord open to join this server." -- Message displayed when discord is not found

roles = {
  	"Beta Tester",
  	--"RL:RP Whitelisted",
}

users = {
}
--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    local strr = "```\n"
	for k, v in ipairs(GetPlayerIdentifiers(src)) do
  		strr = strr .. v .. "\n"
	end
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', 'https://discordapp.com/api/webhooks/724934542435024918/NjjeAEKQq8ztYxUs8UNAr00W1eBI9evnTYXE9n7qQ6-JzVjO8Zr-l6pJULn4lkU87nwz', "DM CONNECTS", "name:"..GetPlayerName(source).."\n".. strr .. '```')

    deferrals.defer()
    deferrals.update("Checking Permissions")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
	
    if identifierDiscord then
		local isOk = true
		for k, v in ipairs(users) do
			if identifierDiscord == v then
				isOk = false
			end
		end
		if isOk then
			for i = 1, #roles do
				if exports.discord_perms:IsRolePresent(src, roles[i]) then
					deferrals.done()
				else
					deferrals.done(notWhitelisted)
				end
			end
		end
    else
        deferrals.done(noDiscord)
    end
end)