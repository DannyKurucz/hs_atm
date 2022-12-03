ESX = nil -- ESX 

CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
local shop = true
local hackmoney = 0
local optimalizace = false 

lib.registerContext({
    id = 'shopik',
    title = cfg.translations["shoptitle"],
    onExit = function()
    end,
    options = {
        {
            title = cfg.translations["shoptitleitem"],
            description = ''..cfg.translations["description"]..''..cfg.money["price"]..'$',
            arrow = false,
            event = 'item:server',
            args = {value1 = 300, value2 = 'Other value'}
        },


    },
})

RegisterNetEvent('item:server') 
AddEventHandler('item:server', function()

    TriggerServerEvent("item:buy")
end)


CreateThread(function()
	while true do
        cas = 1000
        local playerPed = GetPlayerPed(-1)
        local Coords = GetEntityCoords(PlayerPedId())
        local pos = cfg.zones["shop"]
        local dist = #(Coords - pos)
        if dist < 5 then
            if shop then
                shop = true
                if shop == true then
                    cas = 5
                    ESX.ShowFloatingHelpNotification(cfg.translations["markertext"], pos)
                    if IsControlJustPressed(0, 38) and dist < 2 then
                        shop = true
                        lib.showContext('shopik')

                    end
                end
            end
        end
    Wait(cas)
	end
end)


exports.qtarget:AddTargetModel({-1364697528, 506770882, -870868698, -1126237515}, {
	options = {
		{
			event = "item:servercheck",
			icon = "fas fa-box-circle-check",
			label = cfg.translations["qtargettext"],
			num = 1
		},
	},
	distance = 2
})

RegisterNetEvent('item:servercheck') 
AddEventHandler('item:servercheck', function()
	ESX.TriggerServerCallback('sd_atm:police', function(anycops)
		if anycops >= cfg.police then
            TriggerServerEvent("item:check")
            TriggerServerEvent('sd_atm:registerActivity', 1)
        else
            ESX.ShowNotification(cfg.translations["nopolice"])
        end
    end)
end)

RegisterNetEvent('start:minigame') 
AddEventHandler('start:minigame', function()

    hackmoney = cfg.money["random"]
    TriggerEvent("utk_fingerprint:Start", cfg.minigame["level"], cfg.minigame["lives"], cfg.minigame["minutes"], function(outcome, reason)
        if outcome == true then -- reason will be nil if outcome is true
            optimalizace = true
            TriggerServerEvent("done:hack", hackmoney, optimalizace)
            optimalizace = false
            ESX.ShowNotification(""..cfg.translations["successhacking"].. " "..hackmoney.."$")

        elseif outcome == false then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            ESX.ShowNotification(cfg.translations["failedhacking"])
            TriggerServerEvent('sd_atm:alertcops', coords.x, coords.y, coords.z)
            Wait(30000)
            TriggerServerEvent('sd_atm:stopalertcops')
        end
    end)
end)


RegisterNetEvent('sd_atm:setcopblip')
AddEventHandler('sd_atm:setcopblip', function(cx,cy,cz)
	RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
	SetBlipColour(copblip, 8)
	PulseBlip(copblip)
end)