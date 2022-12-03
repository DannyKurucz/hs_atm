ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)


local activity = 0
local activitySource = 0

RegisterNetEvent("item:buy")
AddEventHandler("item:buy", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(cfg.money["price"])
    xPlayer.addInventoryItem(cfg.item["atm"], 1)

end)

RegisterNetEvent("item:check")
AddEventHandler("item:check", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem(cfg.item["atm"]).count > 0 then
        TriggerClientEvent("start:minigame", _source)
        xPlayer.removeInventoryItem(cfg.item["atm"], 1)
    else
        TriggerClientEvent('esx:showNotification', source, cfg.translations["needitem"])
    end
end)
RegisterNetEvent("done:hack")
AddEventHandler("done:hack", function(hackmoney, optimalizace)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if optimalizace == true then    
        xPlayer.addAccountMoney('bank', hackmoney)

    else
    	xPlayer.kick("Kaboom")
    end        
end)
ESX.RegisterServerCallback('sd_atm:police',function(source, cb)
    local anycops = 0
    local playerList = ESX.GetPlayers()
    for i=1, #playerList, 1 do
      local _source = playerList[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
      local playerjob = xPlayer.job.name
      if playerjob == 'police' then
        anycops = anycops + 1
      end
    end
    cb(anycops)
end)
ESX.RegisterServerCallback('sd_atm:isActive',function(source, cb)
    cb(activity)
end)
RegisterServerEvent('sd_atm:registerActivity')
AddEventHandler('sd_atm:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('sd_atm:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

RegisterServerEvent('sd_atm:alertcops')
AddEventHandler('sd_atm:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('sd_atm:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('sd_atm:stopalertcops')
AddEventHandler('sd_atm:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('sd_atm:removecopblip', xPlayers[i])
		end
	end
end)

AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('sd_atm:removecopblip', xPlayers[i])
			end
		end
		activity = 0
		activitySource = 0
	end
end)
