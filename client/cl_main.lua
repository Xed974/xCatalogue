ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local function TestCar()

    local test = true
    local result = (Catalogue.TimeTest * 60)

    while test do
        result = result - 1
        print(result)

        while IsPedInAnyVehicle(PlayerPedId()) == false do
            DeleteEntity(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
            ESX.Game.Teleport(PlayerPedId(), Catalogue.Position.SpwanCar, function()end)
            ESX.ShowNotification("~r~Vous êtes descendu du véhicule.")
            FreezeEntityPosition(PlayerPedId(), false)
            test = false
            break
        end
        if result == 0 then
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
            ESX.Game.Teleport(PlayerPedId(), Catalogue.Position.SpwanCar, function()end)
            ESX.ShowNotification("~r~Test terminé.")
            FreezeEntityPosition(PlayerPedId(), false)
            test = false
            break
        end
        Wait(1000)
    end
end

local resultCategoriesC = {}
RegisterNetEvent('xCatalogue:result_categories')
AddEventHandler('xCatalogue:result_categories', function(resultCategoriesS) resultCategoriesC = resultCategoriesS end)

local resultCarC = {}
RegisterNetEvent('xCatalogue:result_car')
AddEventHandler('xCatalogue:result_car', function(resultCarS) resultCarC = resultCarS end)

local entity = nil
local open = false
local mainMenu = RageUI.CreateMenu("Catalogue", "Interaction", nil, nil, "root_cause5", Catalogue.Menu.Banniere)
local sub_menu1 = RageUI.CreateSubMenu(mainMenu, "Catalogue", "Interaction")
local sub_menu2 = RageUI.CreateSubMenu(sub_menu1, "Catalogue", "Interaction")
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    FreezeEntityPosition(PlayerPedId(), false)
    if DoesEntityExist(entity) then DeleteEntity(entity) end
end
sub_menu1.Closed = function() if DoesEntityExist(entity) then DeleteEntity(entity) end end sub_menu2.Closed = function() DeleteEntity(entity) end

local function MenuCatalogue()
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    for _,v in pairs(resultCategoriesC) do
                        RageUI.Button(v.label, nil, {RightBadge = RageUI.BadgeStyle.Car}, true, {
                            onSelected = function() TriggerServerEvent('xCatalogue:select_car', v.name) end
                        }, sub_menu1)
                    end
                end)
                RageUI.IsVisible(sub_menu1, function()
                    for _,v in pairs(resultCarC) do
                        RageUI.Button(("~%s~→~s~ %s"):format(Catalogue.Menu.Couleur, v.name), nil, {RightLabel = ("~g~%s$~s~"):format(v.price)}, true, {
                            onActive = function()
                                car = GetHashKey(v.model)
                            end,
                            onSelected = function()
                                if DoesEntityExist(entity) then DeleteEntity(entity) end
                                ESX.Game.SpawnLocalVehicle(v.model, Catalogue.Position.SpwanCar, Catalogue.Position.Heading, function(vehicle)
                                    FreezeEntityPosition(vehicle, true)
                                    SetEntityInvincible(vehicle, true)
                                    SetVehicleDoorsLocked(vehicle, 2)
                                    SetVehicleDirtLevel(vehicle, 0)
                                    entity = vehicle
                                end)
                            end
                        }, sub_menu2)
                    end
                end)
                RageUI.IsVisible(sub_menu2, function()
                    RageUI.Button(("Tester le véhicule (~r~%smin~s~)"):format(Catalogue.TimeTest), nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            DeleteEntity(entity)
                            ESX.Game.SpawnVehicle(car, Catalogue.Position.SpwanCarForTest, Catalogue.Position.HeadingForTest, function(vehicle)
                                SetVehicleFuelLevel(vehicle, 60.0)
                                SetVehicleDirtLevel(vehicle, 0)
                                SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                TestCar()
                            end)
                            RageUI.CloseAll()
                            ESX.ShowNotification("Pensez à bien vous attachez !")
                        end
                    })
                    RageUI.Line()
                    RageUI.StatisticPanel((GetVehicleModelEstimatedMaxSpeed(car)/60), "Vitesse maximal")
                    RageUI.StatisticPanel((GetVehicleModelMaxBraking(car)/4), "Freinage")
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        for k in pairs(Catalogue.Position.Menu) do
            local pos = Catalogue.Position.Menu
            local pPos = GetEntityCoords(PlayerPedId())
            local dst = Vdist(pPos.x, pPos.y, pPos.z, pos[k].x, pos[k].y, pos[k].z)

            if dst <= Catalogue.MarkerDistance then
                wait = 0
                DrawMarker(Catalogue.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Catalogue.MarkerSizeLargeur, Catalogue.MarkerSizeEpaisseur, Catalogue.MarkerSizeHauteur, Catalogue.MarkerColorR, Catalogue.MarkerColorG, Catalogue.MarkerColorB, Catalogue.MarkerOpacite, Catalogue.MarkerSaute, true, p19, Catalogue.MarkerTourne)
            end
            if dst <= 1.0 then
                wait = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour voir le catalogue.")
                if IsControlJustPressed(1, 51) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    TriggerServerEvent('xCatalogue:select_categories')
                    MenuCatalogue()
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

--- Xed#1188
