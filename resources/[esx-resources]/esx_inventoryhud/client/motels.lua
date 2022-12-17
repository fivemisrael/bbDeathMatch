local hotelOwner = nil
local hotelMotel = nil
local hotelRoom = nil

RegisterNetEvent("esx_inventoryhud:openMotelsInventory")
AddEventHandler("esx_inventoryhud:openMotelsInventory", function(data, owner, motel, room)
 setPropertyMotelData(data, owner, motel, room)
 hotelOwner = owner
 hotelMotel = motel
 hotelRoom = room
 openMotelInventory()
end)

function refreshPropertyMotelInventory()
 ESX.TriggerServerCallback("pw-motels:getPropertyInventory", function(inventory)
  setPropertyMotelData(inventory)
 end, hotelOwner, hotelMotel, hotelRoom)
end

function setPropertyMotelData(data)
    items = {}
    SendNUIMessage({action = "setInfoText",text = "Motel Inventory"})

    local blackMoney = data.blackMoney
    local propertyItems = data.items
    local propertyWeapons = data.weapons

    if blackMoney > 0 then
        accountData = {label = _U("black_money"),count = blackMoney,type = "item_account",name = "black_money",usable = false,rare = false,limit = -1,canRemove = false}
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                items,
                {
                    label = ESX.GetWeaponLabel(weapon.name),
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
            )
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openMotelInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "motels"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoMotel",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("pw-motels:putItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, count, hotelMotel, hotelRoom)
        end

        Wait(150)
        refreshPropertyMotelInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromMotel",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TriggerServerEvent("pw-motels:getItem", ESX.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number), hotelMotel, hotelRoom)
        end

        Wait(150)
        refreshPropertyMotelInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)
