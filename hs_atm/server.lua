local activity = 0
local activitySource = 0

RegisterNetEvent("item:buy", function()
    local client = source
    local xPlayer = ESX.GetPlayerFromId(client)

	if xPlayer then
		local playerPed = GetPlayerPed(client)
		local playerCoords = GetEntityCoords(playerPed)
		local dist = #(cfg.zones["shop"] - playerCoords)

		if dist < 5 then
			xPlayer.removeMoney(cfg.money["price"])
			xPlayer.addInventoryItem(cfg.item["atm"], 1)
		end
	end
end)

RegisterNetEvent("item:check", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.getInventoryItem(cfg.item["atm"]).count > 0 then
        TriggerClientEvent("start:minigame", _source)
        xPlayer.removeInventoryItem(cfg.item["atm"], 1)
    else
        TriggerClientEvent('esx:showNotification', source, cfg.translations["needitem"])
    end
end)

RegisterNetEvent("done:hack", function()
    local client = source
    local xPlayer = ESX.GetPlayerFromId(client)

    if xPlayer then
		if client == activitySource then
			local money = cfg.money["random"]

			xPlayer.addAccountMoney('bank', money)
			xPlayer.showNotification(""..cfg.translations["successhacking"].. " "..hackmoney.."$")
		else
			-- MAYBE KICK?
		end
    end        
end)


lib.callback.register('sd_atm:police',function(source, cb)
    local anycops = 0

	for _, player in pairs(ESX.GetExtendedPlayers()) do
		if player.job.name == 'police' then
			anycops += 1
		end
	end

    return anycops
end)

RegisterNetEvent('sd_atm:registerActivity', function(value)
	activity = value

	if value == 1 then
		activitySource = source

		for _, player in pairs(ESX.GetExtendedPlayers()) do
			if player.job.name == 'police' then
				TriggerClientEvent('sd_atm:setcopnotification', player.source)
			end
		end
	else
		activitySource = 0
	end
end)

RegisterNetEvent('sd_atm:alertcops', function(cx,cy,cz)
	local client = source

	for _, player in pairs(ESX.GetExtendedPlayers()) do
		if player.job.name == 'police' then
			TriggerClientEvent('sd_atm:setcopblip', player.source, cx, cy, cz)
		end
	end
end)

RegisterNetEvent('sd_atm:stopalertcops', function()
	local client = source

	for _, player in pairs(ESX.GetExtendedPlayers()) do
		if player.job.name == 'police' then
			TriggerClientEvent('sd_atm:removecopblip', player.source)
		end
	end
end)

AddEventHandler('playerDropped', function()
	local client = source

	if client == activitySource then
		for _, player in pairs(ESX.GetExtendedPlayers()) do
			if player.job.name == 'police' then
				TriggerClientEvent('sd_atm:removecopblip', player.source)
			end
		end

		activity = 0
		activitySource = 0
	end
end)
