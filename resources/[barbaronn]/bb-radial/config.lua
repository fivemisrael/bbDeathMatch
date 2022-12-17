ESX               = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShbbobsfcioraredObjbbobsfciorect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)


local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}


rootMenuConfig =  {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "general:revive" }
    },

    {
        id = "accessories",
        displayName = "Accessories",
        icon = "#accessories",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "accessories:mask", "accessories:glasses", "accessories:helmet", "accessories:ears" }
    },

    {
        id = "crews",
        displayName = "Crew",
        icon = "#fa-skull",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "crews:create", "crews:delete" }
    }
}

newSubMenus = {
    ['general:revive'] = {
        title = "החייאה",
        icon = "#ems-revive",
        functionName = "rl-menu:revive"
    },

    ['crews:create'] = {
        title = "פתח",
        icon = "#ems-revive",
        functionName = "bb-crews:createNCrew"
    },

    ['crews:delete'] = {
        title = "מחק",
        icon = "#ems-revive",
        functionName = "bb-crews:deleteNCrew"
    },

    ['general:search'] = {
        title = "חיפוש",
        icon = "#general-search",
        enableMenu = function()
            local Data = ESX.GetPlayerData()
            return (not isDead and Data.job ~= nil and Data.job.name ~= "ambulance" and Data.job.name ~= "police" and not IsPedInAnyVehicle(ped, true))
        end,
        functionName = "rl-menu:thief",
        functionParameters =  { "search" }
    },

    --------------------------------------

	["mechanic:bill"] = {
        title = "דוח",
        icon = "#ems-bill",
        functionName = "rl-menu:mechanic",
        functionParameters =  { "billing" }
    },

    ["mechanic:lookupvehicle"] = {
        title = "חפש-לוחית",
        icon = "#general-search",
        functionName = "rl-menu:police:lookupvehicle"
    },

    ["mechanic:hijack"] = {
        title = "פרוץ",
        icon = "#mechanic-hijack",
        functionName = "rl-menu:mechanic",
        functionParameters =  { "hijack_vehicle" }
    },

    ["mechanic:repair"] = {
        title = "תקן",
        icon = "#mechanic-repair",
        functionName = "rl-menu:mechanic",
        functionParameters =  { "fix_vehicle" }
    },

    ["mechanic:wash"] = {
        title = "נקה",
        icon = "#mechanic-wash",
        functionName = "rl-menu:mechanic",
        functionParameters =  { "clean_vehicle" }
    },

    ["mechanic:impound"] = {
        title = "עקל",
        icon = "#mechanic-impound",
        functionName = "rl-menu:impound"
    },

    ["mechanic:flatbed"] = {
        title = "גרור",
        icon = "#mechanic-flatbed",
        functionName = "rl-menu:mechanic",
        functionParameters =  { "dep_vehicle" }
    },

    --------------------------------------

    ["emotes:smoke"] = {
        title = "לעשן",
        icon = "#emotes-smoke",
        functionName = 'rl-menu:dpemotes:cmd',
        functionParameters =  { "emote" ,"smoke" }
    },

    ["emotes:lean"] = {
        title = "להישען",
        icon = "#emotes-lean",
        functionName = 'rl-menu:dpemotes:cmd',
        functionParameters =  { "emote" ,"lean" }
    },

    ["emotes:sitchair"] = {
        title = "לשבת",
        icon = "#emotes-sitchair",
        functionName = 'rl-menu:dpemotes:cmd',
        functionParameters =  { "emote" ,"sitchair" }
    },

    ["emotes:dance"] = {
        title = "לרקוד",
        icon = "#emotes-dance",
        functionName = 'rl-menu:dpemotes:cmd',
        functionParameters =  { "dance" ,"dance" }
    },
   
    ["emotes:surr"] = {
        title = "היכנס",
        icon = "#emotes-surr",
        functionName = 'rl-menu:dpemotes:cmd',
        functionParameters =  { "emote" , "surrender" }
    },

    ["emotes:menu"] = {
        title = "תפריט",
        icon = "#emotes-menu",
        functionName = 'rl-menu:dpemotes:menu'
    },

    --------------------------------------

    ['vehicle:giveKeys'] = {
        title = "מפתחות",
        icon = "#vehicle-givekeys",
        functionName = "rlrp-hotw:giveKeysEvent"
    },

    ['vehicle:callMechanic'] = {
        title = "מוסכניק",
        icon = "#vehicle-callmec",
        functionName = "rl-menu:general:callmechanic"
    },

    ['vehicle:sell'] = {
        title = "מכור",
        icon = "#vehicle-sell",
        functionName = "rl-menu:sellvehicle"
    },

    ['vehicle:engine'] = {
        title = "התנע",
        icon = "#vehicle-engine",
        functionName = "rl-menu:hotwire:openOwner"
    },

    ['vehicle:search'] = {
        title = "חפש",
        icon = "#vehicle-search",
        enableMenu = function()
            local Data = ESX.GetPlayerData()
            return (not isDead and Data.job ~= nil and Data.job.name ~= "ambulance" and Data.job.name ~= "police")
        end,
        functionName = "rl-menu:hotwire",
        functionParameters =  { "search" }
    },

    ['vehicle:hotwire'] = {
        title = "פרוץ מנוע",
        icon = "#vehicle-hotw",
        enableMenu = function()
            local Data = ESX.GetPlayerData()
            return (not isDead and Data.job ~= nil and Data.job.name ~= "ambulance" and Data.job.name ~= "police")
        end,
        functionName = "rl-menu:hotwire",
        functionParameters =  { "hotw" }
    },

    --------------------------------------

    ['police:search'] = {
        title = "חפש",
        icon = "#police-search",
        functionName = "disc-inventoryhud:search"
    },

    ['police:impound'] = {
        title = "עקל",
        icon = "#mechanic-impound",
        functionName = "rl-menu:impound"
    },

    ['police:jail'] = {
        title = "כליאה",
        icon = "#police-jail",
        functionName = "8F442C176A8F422A93DE2AA8FE009FCB:openJailMenu"
    },

    ['police:bill'] = {
        title = "דוח",
        icon = "#ems-bill",
        functionName = "rl-menu:police",
        functionParameters =  { "bill" }
    },

    ['police:bills'] = {
        title = "קנסות",
        icon = "#police-bills",
        functionName = "rl-menu:police",
        functionParameters =  { "bills" }
    },

    ['police:cuff'] = {
        title = "אזוק",
        icon = "#police-cuff",
        functionName = "rl-menu:handcuff"
    },

    ['police:uncuff'] = {
        title = "שחרר-אזיקה",
        icon = "#police-uncuff",
        functionName = "rl-menu:unhandcuff"
    },

    ['police:mdt'] = {
        title = "מסוף",
        icon = "#police-mdt",
        functionName = "rl-menu:police:mdt"
    },

    ['police:putinvehicle'] = {
        title = "פעולות-רכב",
        icon = "#ems-putinveh",
        functionName = "rl-menu:police",
        functionParameters =  { "vio" }
    },

    ['police:drag'] = {
        title = "גרור",
        icon = "#police-drag",
        functionName = "rl-menu:police",
        functionParameters =  { "drag" }
    },

    --------------------------------------

	['news:boom'] = {
        title = "בום-מיק",
        icon = "#news-boom",
        functionName = "Mic:ToggleBMic"
    },

    ['news:cam'] = {
        title = "מצלמה",
        icon = "#news-cam",
        functionName = "Cam:ToggleCam"
    },

    ['news:mic'] = {
        title = "מיקרופון",
        icon = "#news-mic",
        functionName = "Mic:ToggleMic"
    },

    --------------------------------------

    ["accessories:mask"] = {
        title = "מסיכה",
        icon = "#accessories-mask",
        functionName = 'esx_accessories:SetUnsetAccessory',
        functionParameters =  { "Mask" }
    },

    ["accessories:glasses"] = {
        title = "משקפיים",
        icon = "#accessories-glasses",
        functionName = 'esx_accessories:SetUnsetAccessory',
        functionParameters =  { "Glasses" }
    },

    ["accessories:helmet"] = {
        title = "כובע",
        icon = "#accessories-helmet",
        functionName = 'esx_accessories:SetUnsetAccessory',
        functionParameters =  { "Helmet" }
    },

    ["accessories:ears"] = {
        title = "אוזניים",
        icon = "#accessories-ears",
        functionName = 'esx_accessories:SetUnsetAccessory',
        functionParameters =  { "Ears" }
    },

    --------------------------------------

    ['ems:bill'] = {
        title = "דוח",
        icon = "#ems-bill",
        functionName = "rl-menu:ems",
        functionParameters =  { "bill" }
    },

    ['ems:revive'] = {
        title = "החייה",
        icon = "#ems-revive",
        functionName = "rl-menu:ems",
        functionParameters =  { "revive" }
    },

    ['ems:heal'] = {
        title = "רפא",
        icon = "#ems-heal",
        functionName = "rl-menu:ems",
        functionParameters =  { "heal" }
    },

    ['ems:drag'] = {
        title = "גרור",
        icon = "#ems-drag",
        functionName = "Carry:Event"
    },

    ['ems:med'] = {
        title = "בדוק דופק",
        icon = "#ems-heal",
        functionName = "rl-menu:ems",
        functionParameters =  { "medsystem" }
    },

    ['ems:putinvehicle'] = {
        title = "הכנס לרכב",
        icon = "#ems-putinveh",
        functionName = "rl-menu:ems",
        functionParameters =  { "piv" }
    }
}

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)


function GetPlayers()
    local players = {}

    for i = 0, 128 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end