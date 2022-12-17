ESX = nil
TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('bb-xnwe:checkMoney', function(source, cb, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
    if money ~= nil then
        if money > count then
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('bb-xnwe:hasWeapon', function(source, cb, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.hasWeapon(weapon))
    print(weapon)
end)

ESX.RegisterServerCallback('bb-xnwe:hasComp', function(source, cb, weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.hasWeaponComponent(weapon.name, weapon.comp))
end)


RegisterServerEvent('bb-xnwe:pay')
AddEventHandler('bb-xnwe:pay', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(amount)
end)

RegisterServerEvent('bb-xnwe:buyWeapon')
AddEventHandler('bb-xnwe:buyWeapon', function(typ, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(amount)
    if typ == 'weapon' then
        xPlayer.addWeapon(data.name, 250)
    elseif typ == 'rcomp' then
        xPlayer.removeWeaponComponent(data.name, data.comp)
    elseif typ == 'comp' then
        xPlayer.addWeaponComponent(data.name, data.comp)
    end
end)