ESX = nil
TriggerEvent(
  "esx:getShbbobsfcioraredObjbbobsfciorect",
  function(obj)
    ESX = obj
  end
)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
		}
	else
		return nil
	end
end

--[[ COMMANDS ]]--

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

--[[AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	TriggerClientEvent('chat:addMessage', -1, {
    	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> Command does not exists</div>',
    	args = {}
    })
end)]]--

--[[
RegisterCommand('ooc', function(source, args, rawCommand)
	local msg = rawCommand:sub(4)
	local name = getIdentity(source)
	fal = name.firstname .. "  " .. name.lastname

	TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message" style="background-color: rgba(0, 213, 255, 0.75);"><b>{0}</b> {1} <b>| OOC</b></div>',
        args = { fal, msg}
    })
end, false)]]

RegisterServerEvent('bb-chat:sendOocGlobally')
AddEventHandler('bb-chat:sendOocGlobally', function(playername, msg)
	local name = playername

	TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message" style="background-color: rgba(0, 213, 255, 0.75);"><b>{0}</b> {1}</div>',
        args = { name, msg}
    })
end)

RegisterCommand('police', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(52, 67, 235, 0.75);">{0} <b>משטרת ישראל</b> <img src=' .. Config.Images.Police .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img></div>',
        	args = { args }
    	})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[Police] " .. args .. "```" )
		return
	end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")

    -- Permmisions Stuff
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job ~= nil and xPlayer.job.name == 'police' or xPlayer.getPermissions() > 1 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(52, 67, 235, 0.75);"><b>משטרת ישראל</b> {0}<img src=' .. Config.Images.Police .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img></div>',
        	args = { args }
    	})
	else
		TriggerClientEvent('chat:addMessage', source, {
        	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> You are not a police officer</div>',
        	args = {}
    	})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(255, 0, 21, 0.75);">{0} <b>מגן דוד-אדום</b> <img src=' .. Config.Images.Ems .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img></div>',
        	args = { args }
    	})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[Police] " .. args .. "```" )
		return
	end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")

    -- Permmisions Stuff
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job ~= nil and xPlayer.job.name == 'ambulance' or xPlayer.getPermissions() > 1 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(255, 0, 21, 0.75);"><b>מגן דוד-אדום</b> {0}<img src=' .. Config.Images.Ems .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img></div>',
        	args = { args }
    	})
	else
		TriggerClientEvent('chat:addMessage', source, {
        	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> You are not an EMS employer</div>',
        	args = {}
    	})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)

RegisterCommand('court', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(153, 71, 0, 0.75);">{0} <b>בית המשפט</b> <img src=' .. Config.Images.Court .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img></div>',
        	args = { args }
    	})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[Police] " .. args .. "```" )
		return
	end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")

    -- Permmisions Stuff
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job ~= nil and xPlayer.job.name == 'judge' or xPlayer.getPermissions() > 1 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(153, 71, 0, 0.75);"><b>בית המשפט</b> {0}<img src=' .. Config.Images.Court .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img></div>',
        	args = { args }
    	})
	else
		TriggerClientEvent('chat:addMessage', source, {
        	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> You are not an court employer</div>',
        	args = {}
    	})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)

RegisterCommand('court', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(153, 71, 0, 0.75);">{0} <b>בית המשפט</b> <img src=' .. Config.Images.Court .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img></div>',
        	args = { args }
    	})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[Police] " .. args .. "```" )
		return
	end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")

    -- Permmisions Stuff
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job ~= nil and xPlayer.job.name == 'court' or xPlayer.getPermissions() > 1 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(153, 71, 0, 0.75);"><b>בית המשפט</b> {0}<img src=' .. Config.Images.Court .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img></div>',
        	args = { args }
    	})
	else
		TriggerClientEvent('chat:addMessage', source, {
        	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> You are not an court employer</div>',
        	args = {}
    	})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)


RegisterCommand('id', function(source, args, rawCommand)
	if source == 0 then
		return
	end

	TriggerClientEvent('bb_chat:id', -1, source, GetPlayerName(source))
end, false)

RegisterCommand('staff', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(255, 210, 10, 0.75);"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img><b>ADMIN</b> {0}</div>',
        	args = { args }
    	})
		
		return
	end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")

    -- Permmisions Stuff
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getPermissions() > 1 then
		TriggerClientEvent('chat:addMessage', -1, {
        	template = '<div class="chat-message" style="background-color: rgba(255, 210, 10, 0.75);"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;"></img><b>ADMIN</b> {0}</div>',
        	args = { args }
    	})
	else
		TriggerClientEvent('chat:addMessage', source, {
        	template = '<div class="chat-message" style="background-color: rgba(66, 66, 66, 0.75); color: white;"><img src=' .. Config.Images.System .. ' style="width:22px; padding-right: 5px; position:relative ; top: 5px;height:20px ;"></img><b>ADMIN</b> You are not a staff member</div>',
        	args = {}
    	})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)
