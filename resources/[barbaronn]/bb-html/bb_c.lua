local currentNotifications = {}
local displayTime = 5500
local counter = 0
local gz = ""

Citizen.CreateThread(function()
    local strin = ""

	while true do
		local currentTime, html = GetGameTimer(), ""
        html = ""
		html = html .. "<div style=\"position: absolute; left: 25px; margin-bottom:10px; bottom: 20%;\">"
		for k, v in pairs(currentNotifications) do
            if v.typ == "greenzoneIn" then
                html = html .. "<div style=\"margin-bottom:2px; background-image: url('https://cdn.discordapp.com/attachments/644631964774694942/724605620082180136/bardmgreenzone.gif'); background-size: 275px 56px; padding-right: 275px; background-repeat: no-repeat; padding-bottom: 47px;\"></div>"
            elseif v.typ == "greenzoneOut" then
                html = html .. "<div style=\"margin-bottom:2px; background-image: url('https://cdn.discordapp.com/attachments/644631964774694942/724605620975566889/bardmredzone.gif'); background-size: 275px 56px; padding-right: 275px; background-repeat: no-repeat; padding-bottom: 47px;\"></div>"
            end
            if v.time <= currentTime then
                currentNotifications[k] = nil
                counter = counter - 1
            end
        end
        html = html .. "</div>"

        if strin ~= html then
            SendNUIMessage({
                type = true,
                html = html
            })
            strin = html
        end
        
		Wait(0)
    end
end)

RegisterNetEvent("bb-html:client")
AddEventHandler("bb-html:client", function(ttt)
    if gz ~= ttt then
	    currentNotifications[counter] = {typ = ttt, time = GetGameTimer() + displayTime}
        counter = counter + 1
        gz = ttt
    end
end)

