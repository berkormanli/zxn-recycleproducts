local Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

local QBCore = exports['qb-core']:GetCoreObject()
isLoggedIn = false

local sellItemsSet = false
local sellPrice = {}

------------ Local Functions ------------

local function GetSellingPrice()
	local p = promise.new()
	QBCore.Functions.TriggerCallback('zxn-recycleproducts:server:getSellPrice', function(result)
		p:resolve(result)
	end)
	return Citizen.Await(p)
end

local function SellItemsThread()
	CreateThread(function()
		while sellItemsSet do
            if IsControlJustPressed(0, Keys[Config.InteractionKey]) then
				sellPrice = GetSellingPrice()
                exports['qb-core']:KeyPressed(Keys[Config.InteractionKey])
				TriggerEvent("zxn-recycleproducts:client:SatılacakItemler", sellPrice)
			end
            Wait(1)
		end
	end)
end

local function SetupTargetZone(ped)
	local modelDimensions = GetModelDimensions(GetEntityModel(ped)) * 2.2
	local frontCoords = GetEntityCoords(ped) - (GetEntityForwardVector(ped) * modelDimensions.y)

	if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = "client",
                    event = "zxn-recycleproducts:client:SatılacakItemler",
                    label = Lang:t('info.SellItems'),
					action = function()
						local set = GetSellingPrice()
						TriggerEvent("zxn-recycleproducts:client:SatılacakItemler", set)
					end,
					canInteract = function()
						if GetSellingPrice() ~= 0 then 
							return true 
						end
						return false
					end
                },
            },
            distance = 2.0
        })
	else
		local pedZone = BoxZone:Create(frontCoords, 1.5, 1.5, {
			name = "recyclePedZone",
			heading = Config.Location.h,
			debugPoly = false,
			minZ = frontCoords.z - 1.0,
			maxZ = frontCoords.z + 1.0
		})

		pedZone:onPlayerInOut(function (isPointInside)
			if isPointInside then
				if not sellItemsSet then
					sellPrice = GetSellingPrice()
					sellItemsSet = true
				end
				SellItemsThread()
				exports['qb-core']:DrawText('['..Keys[Config.InteractionKey]..'] ' .. Lang:t('info.SellItems'), 'left')
			else
				sellPrice = {}
				sellItemsSet = false
				exports['qb-core']:HideText()
			end
		end)

		Config.PedZone = {
			created = true,
			zone = pedZone
		}
	end
end

------------ Blip Creation ------------

Citizen.CreateThread(function()
	Citizen.Wait(1)
	Config.Blip = AddBlipForCoord(Config.Location.x, Config.Location.y)
	SetBlipSprite(Config.Blip, 467)
	SetBlipScale(Config.Blip, 0.70)
	SetBlipColour(Config.Blip, 33)
	SetBlipDisplay(Config.Blip, 4)
	SetBlipAsShortRange(Config.Blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang:t("info.BlipName"))
	EndTextCommandSetBlipName(Config.Blip)
end)

------------ NPC Creation ------------

Citizen.CreateThread(function()
	Citizen.Wait(1)

	RequestModel(GetHashKey(Config.PedModel))
	while not HasModelLoaded(GetHashKey(Config.PedModel)) do
		Wait(1)
	end

	Config.Ped = CreatePed(0, Config.PedModel, Config.Location.x, Config.Location.y, Config.Location.z - 1.0,  Config.Location.h, false, true)
	SetEntityHeading(Config.Ped, Config.Location.h)
	FreezeEntityPosition(Config.Ped, true)
	SetEntityInvincible(Config.Ped, true)
	SetBlockingOfNonTemporaryEvents(Config.Ped, true)

	SetModelAsNoLongerNeeded(GetHashKey(Config.PedModel))

	SetupTargetZone(Config.Ped)
end)

RegisterNetEvent('zxn-recycleproducts:client:SatılacakItemler')
AddEventHandler('zxn-recycleproducts:client:SatılacakItemler', function(set)
	print(json.encode(set))
	local menu = {}

	menu[#menu+1] = {
		header = Lang:t("menuInfo.SellHeader"),
		isMenuHeader = true
	}

    for k, v in pairs(set) do
		menu[#menu+1] = {
			header = v[1].label,
			txt = Lang:t("menuInfo.TotalSellPrice", {value = v[2]}),
			params = {
				event = 'zxn-recycleproducts:client:ItemHandle',
				args = {
					index = k,
					item = v
				}
			}
		}
    end

	menu[#menu+1] = {
		header = Lang:t("menuInfo.CloseMenu"),
		params = {
			event = "qb-menu:client:closeMenu",
		}
	}
	
	exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('zxn-recycleproducts:client:ItemHandle')
AddEventHandler('zxn-recycleproducts:client:ItemHandle', function(args)
    TriggerServerEvent('zxn-recycleproducts:server:SellItem', args.item[1])
	TriggerServerEvent('zxn-recycleproducts:server:GiveMoney', args.item[2])
	if not Config.UseTarget then
		table.remove(sellPrice, args[1])
	end
end)