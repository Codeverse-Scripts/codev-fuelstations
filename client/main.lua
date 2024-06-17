ClosestStation = nil
ClosestStationDist = nil
ClosestPump = nil
PedCoords = nil
Stations = Config.Stations
MyStations = nil
Order = {}
OrderAccepted = false
FuelLoaded = 0
CanStartLoading = false
CenterBlip = nil
VehLoaded = false
BackCoords = nil
Blips = {}
RefuelingVehicle = false
VehFuel = 0
ClosestVehicle = nil
Cash = 0

RegisterNetEvent("codev_fuelstations:client:startOrder", function(order)
    Order = order
    OrderAccepted = true
end)

RegisterNetEvent("codev_fuelstations:client:sendPlayerMoney", function(data)
    Cash = data
end)

RegisterNetEvent("codev_fuelstations:client:updateStations", function()
    TriggerServerCallback("codev_fuelstations:server:getStationData", function(data)
        Stations = data.stations
        MyStations = data.myStations
    end)
end)

CreateThread(function()
    for k, station in pairs(Config.Stations) do
        table.insert(Blips, CreateBlip(station.Coords.Blip, k))
    end

    while true do
        TriggerServerCallback("codev_fuelstations:server:getStationData", function(data)
            Stations = data.stations
            MyStations = data.myStations
        end)

        Wait(3000)
    end
end)

CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)
        
        if Stations ~= nil then
            local ped = PlayerPedId()
            PedCoords = GetEntityCoords(ped)
            ClosestPump = GetClosestPump(ped)
            ClosestStation = GetClosestStation(ClosestPump)

            if ClosestPump then
                local pumpDist = #(PedCoords - ClosestPump)
                ClosestVehicle = GetClosestVehicleToPed(ped)

                if pumpDist < 4.0 then
                    sleep = 1

                    if ClosestVehicle and not RefuelingVehicle and not IsPedInAnyVehicle(ped, false) then
                        VehFuel = Config.FuelExports["GetFuel"](ClosestVehicle.veh)
                        if ClosestStationDist < 20 then
                            if VehFuel < 95 then
                                DrawText3D("[E] Start Refueling ($" .. ClosestStation.DefaultPrice .. ") \n".."Fuel: %"..math.round(VehFuel), ClosestVehicle.coords.x, ClosestVehicle.coords.y, ClosestVehicle.coords.z + 0.6, 0.05, 0.05)
    
                                if IsControlJustReleased(0, 38) then
                                    TriggerServerEvent("codev_fuelstations:server:getPlayerMoney")
                                    Wait(300)
                                    RefuelingVehicle = true
                                    TaskTurnPedToFaceEntity(ped, ClosestStation.veh, 1000)
                                    LoadAnimDict("timetable@gardener@filling_can")
                                    TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, false, false, false)
                                end
                            else
                                DrawText3D("Tank is full", ClosestVehicle.coords.x, ClosestVehicle.coords.y, ClosestVehicle.coords.z + 0.6, 0.05, 0.05)
                            end
                        end
                    end
                else
                    sleep = 1000
                end
            else
                sleep = 1000
            end
        end	
    end
end)

CreateThread(function()
    local sleep = 500

    while true do
        Wait(sleep)

        if RefuelingVehicle then
            sleep = 1
            local missingFuel = 100 - VehFuel
            DrawText3D("Press [E] to cancel. ".. math.floor(VehFuel).."% \n Price: $"..math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestVehicle.coords.x, ClosestVehicle.coords.y, ClosestVehicle.coords.z + 0.6, 0.05, 0.05)

            if ClosestStation.owner ~= nil then
                if FuelLoaded < ClosestStation.fuel then
                    if Cash > math.floor(ClosestStation.DefaultPrice*FuelLoaded) then
                        if VehFuel < 100 then
                            VehFuel = VehFuel + 0.05
                            FuelLoaded = FuelLoaded + 0.05
            
                            DisableControlAction(0, 21, true)
                            DisableControlAction(0, 22, true)
                            DisableControlAction(0, 23, true)
                            DisableControlAction(0, 24, true)
                            DisableControlAction(0, 25, true)
                            DisableControlAction(0, 30, true)
                            DisableControlAction(0, 31, true)
                            DisableControlAction(0, 32, true)
                            DisableControlAction(0, 33, true)
                            DisableControlAction(0, 34, true)
                            DisableControlAction(0, 35, true)
                            DisableControlAction(0, 36, true)
                            DisableControlAction(0, 63, true)
                            DisableControlAction(0, 64, true)
                            DisableControlAction(0, 71, true)
                            DisableControlAction(0, 72, true)
                            
                            if IsControlJustReleased(0, 38) then
                                Config.FuelExports["SetFuel"](ClosestVehicle.veh, tonumber(VehFuel))
                                Wait(100)
                                TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                                RefuelingVehicle = false
                                FuelLoaded = 0
                                VehFuel = 0
                                sleep = 500
                                ClearPedTasks(PlayerPedId())
                            end
                        else
                            Config.FuelExports["SetFuel"](ClosestVehicle.veh, 100)
                            TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                            RefuelingVehicle = false
                            FuelLoaded = 0
                            VehFuel = 0
                            sleep = 500
                            ClearPedTasks(PlayerPedId())
                        end
                    else
                        Config.FuelExports["SetFuel"](ClosestVehicle.veh, tonumber(VehFuel))
                        TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                        RefuelingVehicle = false
                        FuelLoaded = 0
                        VehFuel = 0
                        sleep = 500
                        ClearPedTasks(PlayerPedId())
                        Config.Notify("You don't have enough money", "Fuel Stations", "error", 5000)
                    end
                else
                    Config.FuelExports["SetFuel"](ClosestVehicle.veh, tonumber(VehFuel))
                    TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                    RefuelingVehicle = false
                    FuelLoaded = 0
                    VehFuel = 0
                    sleep = 500
                    ClearPedTasks(PlayerPedId())
                    Config.Notify("This station is out of fuel", "Fuel Stations", "error", 5000)
                end
            else
                if Cash > math.floor(ClosestStation.DefaultPrice*FuelLoaded) then
                    if VehFuel < 100 then
                        VehFuel = VehFuel + 0.05
                        FuelLoaded = FuelLoaded + 0.05
        
                        DisableControlAction(0, 21, true)
                        DisableControlAction(0, 22, true)
                        DisableControlAction(0, 23, true)
                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 25, true)
                        DisableControlAction(0, 30, true)
                        DisableControlAction(0, 31, true)
                        DisableControlAction(0, 32, true)
                        DisableControlAction(0, 33, true)
                        DisableControlAction(0, 34, true)
                        DisableControlAction(0, 35, true)
                        DisableControlAction(0, 36, true)
                        DisableControlAction(0, 63, true)
                        DisableControlAction(0, 64, true)
                        DisableControlAction(0, 71, true)
                        DisableControlAction(0, 72, true)
                        
                        if IsControlJustReleased(0, 38) then
                            Config.FuelExports["SetFuel"](ClosestVehicle.veh, tonumber(VehFuel))
                            Wait(100)
                            TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                            RefuelingVehicle = false
                            FuelLoaded = 0
                            VehFuel = 0
                            sleep = 500
                            ClearPedTasks(PlayerPedId())
                        end
                    else
                        Config.FuelExports["SetFuel"](ClosestVehicle.veh, 100)
                        TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                        RefuelingVehicle = false
                        FuelLoaded = 0
                        VehFuel = 0
                        sleep = 500
                        ClearPedTasks(PlayerPedId())
                    end
                else
                    Config.FuelExports["SetFuel"](ClosestVehicle.veh, tonumber(VehFuel))
                    TriggerServerEvent("codev_fuelstations:server:pay", math.floor(ClosestStation.DefaultPrice*FuelLoaded), ClosestStation, FuelLoaded)
                    RefuelingVehicle = false
                    FuelLoaded = 0
                    VehFuel = 0
                    sleep = 500
                    ClearPedTasks(PlayerPedId())
                    Config.Notify("You don't have enough money", "Fuel Stations", "error", 5000)
                end
            end
        end
    end
end)

CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)

       if ClosestStation ~= nil then
            local stationDist = #(PedCoords - ClosestStation.Coords.Blip)
            local stationManagementCoords = ClosestStation.Coords.Management
            local managementCoordsDist = #(PedCoords - stationManagementCoords)

            if stationDist < 50.0 then
                sleep = 0

                if ClosestStation.owner == nil then
                    DrawMarker(29, stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 255, false, true, 2, false, false, false, false)

                    if managementCoordsDist < 1.5 then
                        DrawText3D("[E] Purchase station ($" .. ClosestStation.Price .. ")", stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z + 0.6, 0.05, 0.05)

                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent("codev_fuelstations:server:buyStation", ClosestStation)
                        end
                    end
                else
                    if IsMyStation(ClosestStation) then
                        DrawMarker(21, stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 255, false, true, 2, false, false, false, false)
                        
                        if managementCoordsDist < 1.5 then
                            DrawText3D("[E] Manage station", stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z + 0.6, 0.05, 0.05)
                            if IsControlJustPressed(0, 38) then
                                SetNuiFocus(true, true)
                                local isOwner = false
                                local myLicense = nil
                                
                                for _, station in pairs(MyStations) do
                                    if station.owner == ClosestStation.owner then
                                        isOwner = true
                                        myLicense = station.owner
                                    end
                                end

                                SendNUIMessage({
                                    action = "open",
                                    station = ClosestStation,
                                    isOwner = isOwner,
                                    myLicense = myLicense,
                                    cfgVehicles = Config.Vehicles
                                })
                            end
                        end
                    else
                        if managementCoordsDist < 1.5 then 
                            DrawText3D("This station is owned", stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z + 0.6, 0.05, 0.05)
                        end

                        DrawMarker(29, stationManagementCoords.x, stationManagementCoords.y, stationManagementCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 255, 0, 0, 255, false, true, 2, false, false, false, false)
                    end
                end
            else
                sleep = 1000
            end
        end
    end
end)

RegisterNetEvent("codev_fuelstations:notify", function(title, msg, type, length)
    Config.Notify(msg, title, type, length)
end)

RegisterNetEvent("codev_fuelstations:sendInvite", function(station, senderName)
    Config.Notify(senderName .. " has invited you to join " .. station.Name, "Fuel Stations", "success", 5000)
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "sendInvite",
        station = station,
        senderName = senderName
    })
end)

RegisterNuiCallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("sellStation", function()
    TriggerServerEvent("codev_fuelstations:server:sellStation", ClosestStation)
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("inviteEmployee", function(id, cb)
    TriggerServerCallback("codev_fuelstations:server:inviteEmployee", function (data)
        cb(data)
    end, ClosestStation, id)
end)

RegisterNuiCallback("savePrice", function(price)
    TriggerServerEvent("codev_fuelstations:server:savePrice", ClosestStation, price)
end)

RegisterNuiCallback("withdraw", function(price, cb)
    TriggerServerCallback("codev_fuelstations:server:withdraw", function(data)
        cb(data)
    end, ClosestStation, price)
end)

RegisterNuiCallback("deposit", function(price, cb)
    TriggerServerCallback("codev_fuelstations:server:deposit", function(data)
        cb(data)
    end, ClosestStation, price)
end)

RegisterNuiCallback("acceptInvite", function(invitedStation)
    TriggerServerEvent("codev_fuelstations:server:joinStation", invitedStation)
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("rejectInvite", function()
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("buyVehicle", function(vehicle)
    SetNuiFocus(false, false)
    TriggerServerEvent("codev_fuelstations:server:buyVehicle", ClosestStation, vehicle)
end)

RegisterNuiCallback("sellVehicle", function(vehicle)
    SetNuiFocus(false, false)
    TriggerServerEvent("codev_fuelstations:server:sellVehicle", ClosestStation, vehicle)
end)

RegisterNuiCallback("fireEmployee", function(license)
    SetNuiFocus(false, false)
    TriggerServerEvent("codev_fuelstations:server:fireEmployee", ClosestStation, license)
end)

RegisterNuiCallback("createOrder", function(vehicleName)
    SetNuiFocus(false, false)
    TriggerServerEvent("codev_fuelstations:server:createOrder", ClosestStation, vehicleName)
end)

RegisterNuiCallback("claimOrder", function(orderId)
    SetNuiFocus(false, false)
    local order = nil

    if ClosestStation.orders == nil then
        return
    end

    if OrderAccepted then
        Config.Notify("You already have an order", "Fuel Stations", "error", 5000)
        return
    end

    for _, o in pairs(ClosestStation.orders) do
        if o.id == orderId then
            order = o
        end
    end
    
    local veh = CreateOrderCar(order)
    if veh then
        if Config.Framework == "qb" then
            TriggerEvent("vehiclekeys:client:SetOwner", Framework.Functions.GetPlate(veh))
        end

        Config.Notify("Your order is ready to be claimed", "Fuel Stations", "success", 5000)
        BackCoords = GetEntityCoords(veh)
        TriggerServerEvent("codev_fuelstations:server:claimOrder", ClosestStation, orderId)
    else
        Config.Notify("Your order is ready to be claimed, but there is no space for your vehicle", "Fuel Stations", "error", 5000)
    end
end)

CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)

        if OrderAccepted and not CanStartLoading and not VehLoaded then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local centerDist = #(pedCoords - Config.FuelCenter.Coords)

            if centerDist < 50.0 and centerDist > 3 then
                sleep = 0
                DrawMarker(29, Config.FuelCenter.Coords.x, Config.FuelCenter.Coords.y, Config.FuelCenter.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipColor, 0, 0, 255, false, true, 2, false, false, false, false)
                DrawText3D("Refuel vehicle", Config.FuelCenter.Coords.x, Config.FuelCenter.Coords.y, Config.FuelCenter.Coords.z + 0.6, 0.08, 0.08)
            elseif centerDist < 3 then
                sleep = 0
                DrawMarker(29, Config.FuelCenter.Coords.x, Config.FuelCenter.Coords.y, Config.FuelCenter.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipColor, 0, 0, 255, false, true, 2, false, false, false, false)
                DrawText3D("[E] Refuel vehicle", Config.FuelCenter.Coords.x, Config.FuelCenter.Coords.y, Config.FuelCenter.Coords.z + 0.6, 0.08, 0.08)

                if IsControlJustPressed(0, 38) then
                    CanStartLoading = true
                end
            end
        end
    end
end)

CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)

        if CanStartLoading and not VehLoaded then
            sleep = 1
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local maxFuel = Order.vehicle.Capacity
            local missingFuel = maxFuel - FuelLoaded
            FuelLoaded = FuelLoaded + 0.1
            DrawText3D("Press [E] to cancel. Fuel: "..math.round(FuelLoaded).."/"..Order.vehicle.Capacity, pedCoords.x, pedCoords.y, pedCoords.z + 2, 0.08, 0.08)
            
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 63, true)
            DisableControlAction(0, 64, true)
            DisableControlAction(0, 71, true)
            DisableControlAction(0, 72, true)
            
            if FuelLoaded >= maxFuel or IsControlJustPressed(0, 38) then
                RemoveBlip(CenterBlip)

                ClearGpsMultiRoute()
                StartGpsMultiRoute(6, true, true)
                AddPointToGpsMultiRoute(BackCoords.x, BackCoords.y, BackCoords.z)
                SetGpsMultiRouteRender(true)

                VehLoaded = true
                CanStartLoading = false
                Config.Notify("Your vehicle is refueled", "Fuel Stations", "success", 5000)
            end
        end
    end
end)

CreateThread(function()
    local sleep = 1000

    while true do
        Wait(sleep)

        if VehLoaded then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local dist = #(pedCoords - BackCoords)

            if dist < 50.0 and dist > 3 then
                sleep = 1
                DrawMarker(29, BackCoords.x, BackCoords.y, BackCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipColor, 0, 0, 255, false, true, 2, false, false, false, false)
                DrawText3D("Return vehicle", BackCoords.x, BackCoords.y, BackCoords.z + 0.6, 0.08, 0.08)
            elseif dist < 3 then
                sleep = 1
                DrawMarker(29, BackCoords.x, BackCoords.y, BackCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipScale, Config.FuelCenter.BlipColor, 0, 0, 255, false, true, 2, false, false, false, false)
                DrawText3D("[E] Return vehicle", BackCoords.x, BackCoords.y, BackCoords.z + 0.6, 0.08, 0.08)
                
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("codev_fuelstations:server:finishOrder", ClosestStation, FuelLoaded, Order)
                    VehLoaded = false
                    CanStartLoading = false
                    Order = {}
                    OrderAccepted = false
                    FuelLoaded = 0
                    BackCoords = nil
                    ClearGpsMultiRoute()
                    DeleteVehicle(GetVehiclePedIsIn(ped, false))
                    Config.Notify("Your vehicle has been returned", "Fuel Stations", "success", 5000)
                end
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for _, blip in pairs(Blips) do
            RemoveBlip(blip)
        end
    end
end)

-- nozle = CreateObject(GetHashKey("prop_cs_fuel_nozle"), 0, 0, 0, true, true, true)
-- AttachEntityToEntity(nozle, ped, GetPedBoneIndex(ped, 0x49D9), 0.1, 0.02, 0.02, 90.0, 40.0, 170.0, true, true, false, true, 1, true)