Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(710505642917363803) --This is the Application ID (Replace this with you own)
		SetDiscordRichPresenceAsset('6bdec6215f8903') --Here you will have to put the image name for the "large" icon.
        SetDiscordRichPresenceAssetText('Join RealisticLifeDM Today! https://discord.gg/6yRKv74') --Here you can add hover text for the "large" icon.
        Citizen.Wait(35000) --It updates every one minute just in case.
	end
end)