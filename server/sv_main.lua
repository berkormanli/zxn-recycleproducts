local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject')
AddEventHandler('QBCore:Server:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

QBCore.Functions.CreateCallback('zxn-recycleproducts:server:getSellPrice', function(source, cb)
    local retval = {}
    local Player = QBCore.Functions.GetPlayer(source)
    
    for item, price in pairs(Config.ItemList) do
        local item = Player.Functions.GetItemByName(item)
        if item then
            retval[#retval+1] = {
                item,
                item.amount * price
            }
        end
    end
    cb(retval)
end)

RegisterServerEvent('zxn-recycleproducts:server:SellItem')
AddEventHandler('zxn-recycleproducts:server:SellItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem(item.name, item.amount) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.RecycledSomeItems'))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], "remove")
    end
end)

RegisterServerEvent('zxn-recycleproducts:server:GiveMoney')
AddEventHandler('zxn-recycleproducts:server:GiveMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', tonumber(amount))
end)