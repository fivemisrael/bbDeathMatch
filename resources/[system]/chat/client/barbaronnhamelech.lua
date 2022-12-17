RegisterNetEvent('bb_chat:id')
AddEventHandler('bb_chat:id', function(source, pname)
  local target = GetPlayerFromServerId(source)

  local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
  local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)
  

  if target == source then
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message" style="background-color: rgba(0, 255, 94, 0.75);">{0}\'s is ID {1}</div>',
        args = { pname, source }
    })
  elseif GetDistanceBetweenCoords(sourceCoords, targetCoords, true) < 20.0 then
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message" style="background-color: rgba(0, 255, 94, 0.75);">{0}\'s is ID {1}</div>',
        args = { pname, source}
    })
  end
end)

