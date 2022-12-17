--[[
    Made by BarBaroNN#0006.
    All rights reserved.
]]--

ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('bb-garage:getOwnedCars', function(source, cb)
    local ownedCars = {}
    
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
        ['@owner']  = GetPlayerIdentifiers(source)[1],
        ['@Type']   = 'car',
        ['@job']    = ''
    }, function(data)
        for _,v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
        end
        cb(ownedCars)
    end)
end)