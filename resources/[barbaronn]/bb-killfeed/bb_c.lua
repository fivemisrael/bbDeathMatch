local killDisplaying = {}
local displayTime = 8000
local counter = 0

Citizen.CreateThread(function()
    local strin = ""

	while true do
		local currentTime, html = GetGameTimer(), ""
		html = html .. "<div style=\"position: absolute; margin-top:10px; right: 2%;top: 10%;\">"
		for k, v in pairs(killDisplaying) do
            html = html .. "<div style=\"margin-top:2px; text-shadow: 1px 0px 5px #000000FF, -1px 0px 0px #000000FF, 0px -1px 0px #000000FF, 0px 1px 5px #000000FF;text-align: right;color: #FFFFFF;background: rgba(18, 18, 18, 0.8);border-radius:3px;padding-right: 5px;padding-left: 5px;padding-bottom: 0px; top: 1px; font-family:Heebo;font-size: 18px;\">" .. v.strr .. "</div>"

        	if v.time <= currentTime then
        		killDisplaying[k] = nil
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

RegisterNetEvent("bb-killfeed:ToggleDisplay")
AddEventHandler("bb-killfeed:ToggleDisplay", function(vv)
	killDisplaying[counter] = {strr = vv, time = GetGameTimer() + displayTime}
	counter = counter + 1
end)

