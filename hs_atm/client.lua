lib.registerContext(
    {
        id = 'shopik',
        title = cfg.translations["shoptitle"],
        options = {
            {
                title = cfg.translations["shoptitleitem"],
                description = cfg.translations["description"] .. '' .. cfg.money["price"] .. '$',
                serverEvent = "item:buy"
            },
        },
    }
)

local point = lib.points.new(cfg.zones["shop"], 2)
local isTextShow = false

function point:onEnter()
    if not isTextShow then
        lib.showTextUI(cfg.translations["markertext"])

        isTextShow = true
    end
end

function point:onExit()
    if isTextShow then
        lib.hideTextUI()

        isTextShow = false
    end
end

function point:nearby()
    if IsControlJustPressed(0, 38) then
        lib.showContext('shopik')
    end
end

exports.qtarget:AddTargetModel({-1364697528, 506770882, -870868698, -1126237515}, {
	options = {
		{
			icon = "fas fa-box-circle-check",
			label = cfg.translations["qtargettext"],
            action = function()
                lib.callback('sd_atm:police', false, function(anycops)
                    if anycops >= cfg.police then
                        TriggerServerEvent("item:check")
                        TriggerServerEvent('sd_atm:registerActivity', 1)
                    else
                        ESX.ShowNotification(cfg.translations["nopolice"])
                    end
                end)
            end
		},
	},
	distance = 2
})

RegisterNetEvent('start:minigame', function()
    TriggerEvent("utk_fingerprint:Start", cfg.minigame["level"], cfg.minigame["lives"], cfg.minigame["minutes"], function(outcome, reason)
        if outcome == true then
            TriggerServerEvent("done:hack")
        elseif outcome == false then
            local coords = GetEntityCoords(cache.ped)

            ESX.ShowNotification(cfg.translations["failedhacking"])

            TriggerServerEvent('sd_atm:alertcops', coords.x, coords.y, coords.z)
            Wait(30000)
            TriggerServerEvent('sd_atm:stopalertcops')
        end
    end)
end)

local copblip = nil

RegisterNetEvent('sd_atm:setcopblip', function(cx,cy,cz)
	if DoesBlipExist(copblip) then
        RemoveBlip(copblip)
    end

    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
	SetBlipColour(copblip, 8)
	PulseBlip(copblip)
end)