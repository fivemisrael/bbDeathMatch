local currentNotifications = {}
local displayTime = 8000
local counter = 0

Citizen.CreateThread(function()
    local strin = ""

	while true do
		local currentTime, html = GetGameTimer(), ""
		html = html .. "<div style=\"position: absolute; left: -2px; margin-bottom:10px; bottom: 20%;\">"
		for k, v in pairs(currentNotifications) do
            html = html .. "<div style=\"margin-bottom:2px; text-shadow: 1px 0px 5px #000000FF, -1px 0px 0px #000000FF, 0px -1px 0px #000000FF, 0px 1px 5px #000000FF;text-align: left;color: #FFFFFF; background-image: url('https://cdn.discordapp.com/attachments/553260308475674688/712308352935526400/unknown.png'); background-size: 300px 135px; font-family:Heebo;font-size: 18px; padding-right: 300px; padding-bottom: 120px;\"><span style=\"position: absolute; margin-left: 10%; margin-top: 10%; font-size: 20px\">" .. v.title .. "</span><span style=\"position: absolute; margin-left: 10%; margin-top: 18%; font-size: 17px\">" .. v.strr .. "</span></div>"

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

RegisterNetEvent("bb-notification")
AddEventHandler("bb-notification", function(title, vv)
	currentNotifications[counter] = {title = title, strr = vv, time = GetGameTimer() + displayTime}
	counter = counter + 1
end)

