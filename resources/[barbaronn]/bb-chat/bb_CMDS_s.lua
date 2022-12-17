ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	TriggerClientEvent('chat:addMessage', source, {
		template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
		args = { ".פקודה זו לא קיימת" }
	})
end)

RegisterCommand('police', function(source, args, rawCommand)
	-- If From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(3, 111, 252, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Police .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
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
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(3, 111, 252, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Police .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
	else
		TriggerClientEvent('chat:addMessage', source, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { ".אין לך גישה לבצע פעולה זו" }
		})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Police] " .. args .. "```" )
end, false)

RegisterCommand('court', function(source, args, rawCommand)
	-- From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(106, 189, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Court .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[court] " .. args .. "```" )
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
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(106, 189, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Court .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
	else
		TriggerClientEvent('chat:addMessage', source, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { ".אין לך גישה לבצע פעולה זו" }
		})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Court] " .. args .. "```" )
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
	-- From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(189, 0, 76, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Ems .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[EMS] " .. args .. "```" )
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
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(189, 0, 76, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.Ems .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
	else
		TriggerClientEvent('chat:addMessage', source, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { ".אין לך גישה לבצע פעולה זו" }
		})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[EMS] " .. args .. "```" )
end, false)

RegisterCommand('id', function(source, args, rawCommand)
	-- From Console
	if source == 0 then
		return
	end

    -- Permmisions Stuff
	TriggerClientEvent('chat:addMessage', source, {
		template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(66, 245, 194, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
		args = { "YOUR ID : " .. source }
	})
end, false)

RegisterCommand('staff', function(source, args, rawCommand)
	-- From Console
	if source == 0 then
		TriggerClientEvent('chat:addMessage', -1, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
		
		TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, "CONSOLE", "```[Staff] " .. args .. "```" )
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
			template = "<div style='font-size: calc(1.9vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;display: inline-block ;line-height: calc((1.9vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { args }
		})
	else
		TriggerClientEvent('chat:addMessage', source, {
			template = "<div style='font-size: calc(1.8vw / 1.77777) ;margin-top: 1px;margin-bottom:1px;;display: inline-block ;line-height: calc((1.85vw / 1.77777) * 1.2) ; background-color: rgba(255, 13, 0, 0.6) ; border-radius: 5px ;'><la style='padding: 5px;'><a style='margin-right: 7px;padding: 3px;'>{0}</a><img src='" .. Config.Images.System .. "' style='width:22px; padding-right: 5px; position:relative ; top: 3px;height:20px ;'></img></div>",
			args = { ".אין לך גישה לבצע פעולה זו" }
		})
	end
	
	-- Logs Stuff
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[Staff] " .. args .. "```" )
end, false)

--[[
RegisterCommand('ooc', function(source, args, rawCommand)
	-- Block from console
	if source==0 then return end

	-- Emojis Stuff
	args = table.concat(args, ' ')
	args = args:gsub("%:heart:", "❤️")
    args = args:gsub("%:smile:", "🙂")
    args = args:gsub("%:thinking:", "🤔")
    args = args:gsub("%:check:", "✅")
    args = args:gsub("%:hot:", "🥵")
    args = args:gsub("%:sad:", "😦")
	
	-- Send Message
	
	
	-- Logs
	TriggerEvent('barbaronn:SendWebhookDiscordMsg', Config.Logs, GetPlayerName(source) .. " | " .. GetPlayerIdentifiers(source)[1], "```[OOC] " .. args .. "```" )
end, false)]]


AddEventHandler('chatMessage', function(Source, Name, Msg)
    args = stringsplit(Msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
    else 

        Msg = Msg:gsub("%:heart:", "❤️")
    	Msg = Msg:gsub("%:smile:", "🙂")
    	Msg = Msg:gsub("%:thinking:", "🤔")
    	Msg = Msg:gsub("%:check:", "✅")
    	Msg = Msg:gsub("%:hot:", "🥵")
    	Msg = Msg:gsub("%:sad:", "😦")

		TriggerClientEvent('chatMessage', -1, Msg,  { 232, 232, 232 }, ("^*^g: ".. Name .." | ID " .. Source)  )
		local player = GetPlayerIdentifiers(Source)[1]  
    end
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		if Config.OnlyFirstname then
			return result[1].firstname
		else
			return ('%s %s'):format(result[1].firstname, result[1].lastname)
		end
	else
		return GetPlayerName(source)
	end
end