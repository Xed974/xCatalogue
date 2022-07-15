ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local resultCategoriesS = {}
RegisterNetEvent('xCatalogue:select_categories')
AddEventHandler('xCatalogue:select_categories', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT * FROM vehicle_categories", {}, function(result)
        if (result) then
            resultCategoriesS = result
            TriggerClientEvent('xCatalogue:result_categories', source, resultCategoriesS)
        end
    end)
end)

local resultCarS = {}
RegisterNetEvent('xCatalogue:select_car')
AddEventHandler('xCatalogue:select_car', function(name)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE category = '"..name.."'", {}, function(result)
        if (result) then
            resultCarS = result
            TriggerClientEvent('xCatalogue:result_car', source, resultCarS)
        end
    end)
end)

--- Xed#1188