DonatorStatusID = {}

RegisterNetEvent("bb_donatorsys:savePlayer")
AddEventHandler("bb_donatorsys:savePlayer", function(donor)
    DonatorStatusID = donor
end)

CreateThread(function()
    TriggerServerEvent("bb_donatorsys:checkPlayer")
end)

RegisterCommand('refreshdonor', function()
    TriggerServerEvent("bb_donatorsys:checkPlayer")
end)

RegisterCommand('donorstatus', function()
    for k, v in pairs(DonatorStatusID) do
    	strr = k .. " : " .. tostring(v)
    	print(strr)
    end
end)