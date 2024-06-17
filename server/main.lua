RegisterServerCallback('codev_fuelstations:server:getStationData', function(source, cb)
    local stations = table.copy(Config.Stations)
    local ownedStations = GetOwnedStations()

    for k, v in pairs(stations) do
        for _, ownedStation in pairs(ownedStations) do
            if ownedStation.station.Name == k then
                v.owner = ownedStation.owner
                v.orders = ownedStation.orders
                v.employees = ownedStation.employees
                v.balance = ownedStation.balance
                v.fuel = ownedStation.fuel
                v.vehicles = ownedStation.vehicles
                v.Capacity = ownedStation.station.Capacity
                v.DefaultPrice = ownedStation.station.DefaultPrice
            end
        end
    end

    cb({
        stations = stations,
        myStations = GetMyStations(source)
    })
end)

RegisterServerEvent("codev_fuelstations:server:buyStation", function(station)
    local src = source
    local stationOwner = station.owner

    if stationOwner == nil then
        local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(source) or Framework.Functions.GetPlayer(source)
        local cash = Config.Framework == "esx" and xPlayer.getMoney() or xPlayer.PlayerData.money.cash
        local bank = Config.Framework == "esx" and xPlayer.getAccount("bank").money or xPlayer.PlayerData.money.bank
        local license = GetPlayerLicense(source)

        if cash >= station.Price then
            if Config.Framework == "esx" then
                xPlayer.removeMoney(station.Price)
            else
                xPlayer.Functions.RemoveMoney("cash", station.Price)
            end

            local ownedStations = GetOwnedStations()
            local playerName = Config.Framework == "esx" and xPlayer.getName() or xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname

            table.insert(ownedStations, {
                station = station,
                owner = license,
                orders = {},
                balance = 0,
                fuel = station.StartFuel,
                vehicles = {},
                employees = {
                    [license] = {
                        license = license,
                        name = playerName,
                        rank = "boss",
                        orders = 0,
                    }
                }
            })

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You bought a fuel station", "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
        elseif bank >= station.Price then
            if Config.Framework == "esx" then
                xPlayer.removeAccountMoney("bank", station.Price)
            else
                xPlayer.Functions.RemoveMoney("bank", station.Price)
            end

            local ownedStations = GetOwnedStations()
            local playerName = Config.Framework == "esx" and xPlayer.getName() or xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname

            table.insert(ownedStations, {
                station = station,
                owner = license,
                orders = {},
                balance = 0,
                fuel = station.StartFuel,
                employees = {
                    [license] = {
                        license = license,
                        name = playerName,
                        rank = "boss",
                        orders = 0,
                        id = 1
                    }
                }
            })

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You bought a fuel station", "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
        else
            TriggerClientEvent("codev_fuelstations:notify", src, "Error", "Not enough money", "error", 5000)
        end
    else
        TriggerClientEvent("codev_fuelstations:notify", src, "Error", "Station is already owned", "error", 5000)
    end
end)

RegisterServerEvent("codev_fuelstations:server:sellStation", function(station)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            local license = GetPlayerLicense(src)
            if v.owner ~= license then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You are not the owner of this station", "error", 5000)
                return
            end
            
            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            local price = math.floor(v.station.Price / 2) + math.floor(v.balance)

            if Config.Framework == "esx" then
                xPlayer.addMoney(price)
            else
                xPlayer.Functions.AddMoney("cash", price)
            end

            table.remove(ownedStations, k)
            break
        end
    end

    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You sold your fuel station", "success", 5000)
    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
end)

RegisterServerEvent("codev_fuelstations:server:savePrice", function(station, price)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            v.station.DefaultPrice = price
            break
        end
    end

    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You saved the price", "success", 5000)
    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
end)

RegisterServerCallback("codev_fuelstations:server:withdraw", function(src, cb, station, price)
    local stationName = station.Name
    local ownedStations = GetOwnedStations()

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            if v.balance < price then
                price = v.balance
            end

            if v.balance >= price then
                v.balance = v.balance - price
                local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
                if Config.Framework == "esx" then
                    xPlayer.addMoney(price)
                else
                    xPlayer.Functions.AddMoney("cash", price)
                end

                cb(v.balance)

                break
            end
        end
    end

    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You withdrew $"..price, "success", 5000)
    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
end)

RegisterServerCallback("codev_fuelstations:server:deposit", function(src, cb, station, price)
    local stationName = station.Name
    local ownedStations = GetOwnedStations()

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            local cash = Config.Framework == "esx" and xPlayer.getMoney() or xPlayer.PlayerData.money.cash
            local bank = Config.Framework == "esx" and xPlayer.getAccount("bank").money or xPlayer.PlayerData.money.bank

            if cash < price or bank < price then
                price = math.min(cash, bank)
            end

            if cash >= price then
                if Config.Framework == "esx" then
                    xPlayer.removeMoney(price)
                else
                    xPlayer.Functions.RemoveMoney("cash", price)
                end

                v.balance = v.balance + price
                cb(v.balance)

                break
            elseif bank >= price then
                if Config.Framework == "esx" then
                    xPlayer.removeAccountMoney("bank", price)
                else
                    xPlayer.Functions.RemoveMoney("bank", price)
                end

                v.balance = v.balance + price
                cb(v.balance)
            
                break
            end
        end
    end

    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You deposited $"..price, "success", 5000)
    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
end)

RegisterServerCallback("codev_fuelstations:server:inviteEmployee", function(src, cb, ClosestStation, id)
    local stationName = ClosestStation.Name
    local ownedStations = GetOwnedStations()
    local id = tonumber(id)
    local license = GetPlayerLicense(id)

    if license == nil then
        TriggerClientEvent("codev_fuelstations:notify", src, "Error", "This player is not online", "error", 5000)
        cb(false)
        return
    end

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            for _, employee in pairs(v.employees) do
                if employee.license == license then
                    TriggerClientEvent("codev_fuelstations:notify", src, "Error", "This player is already an employee", "error", 5000)
                    cb(false)
                    return
                end
            end

            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(id) or Framework.Functions.GetPlayer(id)
            local playerName = Config.Framework == "esx" and xPlayer.getName() or xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname

            v.employees[license] = {
                license = license,
                name = playerName,
                rank = "employee",
                orders = 0,
                id = #v.employees + 1
            }

            local senderName = Config.Framework == "esx" and Framework.GetPlayerFromId(src).getName() or Framework.Functions.GetPlayer(src).PlayerData.charinfo.firstname.." "..Framework.Functions.GetPlayer(src).PlayerData.charinfo.lastname
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You invited "..playerName.." to your fuel station", "success", 5000)
            TriggerClientEvent("codev_fuelstations:sendInvite", id, ClosestStation, senderName)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)

            cb(true)
            break
        end
    end
end)

RegisterServerEvent("codev_fuelstations:server:joinStation", function (station)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            v.employees[license] = {
                license = license,
                name = Config.Framework == "esx" and Framework.GetPlayerFromId(src).getName() or Framework.Functions.GetPlayer(src).PlayerData.charinfo.firstname.." "..Framework.Functions.GetPlayer(source).PlayerData.charinfo.lastname,
                rank = "employee",
                orders = 0,
            }

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You joined to a fuel station", "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
            break
        end
    end
end)

RegisterServerEvent("codev_fuelstations:server:buyVehicle", function (station, vehicleName)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)
    local vehicle = Config.Vehicles[vehicleName]

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            if v.owner ~= license then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You are not the owner of this station", "error", 5000)
                return
            end

            if v.vehicles[vehicleName] ~= nil then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You already have this vehicle", "error", 5000)
                return
            end

            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            local cash = Config.Framework == "esx" and xPlayer.getMoney() or xPlayer.PlayerData.money.cash
            local bank = Config.Framework == "esx" and xPlayer.getAccount("bank").money or xPlayer.PlayerData.money.bank

            if cash >= vehicle.Price then
                if Config.Framework == "esx" then
                    xPlayer.removeMoney(vehicle.Price)
                else
                    xPlayer.Functions.RemoveMoney("cash", vehicle.Price)
                end

                v.vehicles[vehicleName] = {
                    Name = vehicleName,
                    imgName = vehicle.imgName,
                    Capacity = vehicle.Capacity,
                }

                SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
                TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You bought a "..vehicleName, "success", 5000)
                TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
                break
            elseif bank >= vehicle.Price then
                if Config.Framework == "esx" then
                    xPlayer.removeAccountMoney("bank", vehicle.Price)
                else
                    xPlayer.Functions.RemoveMoney("bank", vehicle.Price)
                end

                v.vehicles[vehicleName] = {
                    Name = vehicleName,
                    imgName = vehicle.imgName,
                    Capacity = vehicle.Capacity,
                    fuel = vehicle.Capacity,
                }

                SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
                TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You bought a "..vehicleName, "success", 5000)
                TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
                break
            else
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "Not enough money", "error", 5000)
                break
            end
        end
    end
end)

RegisterServerEvent("codev_fuelstations:server:sellVehicle", function (station, vehicleName)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            if v.owner ~= license then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You are not the owner of this station", "error", 5000)
                return
            end

            if v.vehicles[vehicleName] == nil then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You don't have this vehicle", "error", 5000)
                return
            end

            local vehicle = Config.Vehicles[vehicleName]
            local price = math.floor(vehicle.Price / 2)

            v.vehicles[vehicleName] = nil

            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            if Config.Framework == "esx" then
                xPlayer.addMoney(price)
            else
                xPlayer.Functions.AddMoney("cash", price)
            end

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You sold your "..vehicleName, "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
            break
        end
    end
end)

RegisterNetEvent("codev_fuelstations:server:fireEmployee", function(station, license)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local myLicense = GetPlayerLicense(src)
    local license = license

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            if v.owner ~= myLicense then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You are not the owner of this station", "error", 5000)
                return
            end

            if v.employees[license] == nil then
                TriggerClientEvent("codev_fuelstations:notify", src, "Error", "This player is not an employee", "error", 5000)
                return
            end

            v.employees[license] = nil

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You fired this employee", "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
            break
        end
    end
end)

RegisterNetEvent("codev_fuelstations:server:createOrder", function(station, vehicleName)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            local newId = v.orders[#v.orders] and v.orders[#v.orders].id + 1 or 1
            table.insert(v.orders, {
                id = newId,
                creator = license,
                creatorName = Config.Framework == "esx" and Framework.GetPlayerFromId(src).getName() or Framework.Functions.GetPlayer(src).PlayerData.charinfo.firstname.." "..Framework.Functions.GetPlayer(source).PlayerData.charinfo.lastname,
                vehicle = v.vehicles[vehicleName],
                hash = Config.Vehicles[vehicleName].carHash,
                accepted = false,
                acceptedBy = nil
            })

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You successfully created an order", "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
            break
        end
    end
end)

RegisterNetEvent("codev_fuelstations:server:claimOrder", function(station, orderId)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)
    local orderId = tonumber(orderId)

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            for _, order in pairs(v.orders) do
                if order.id == (orderId) then
                    if order.accepted then
                        TriggerClientEvent("codev_fuelstations:notify", src, "Error", "This order is already claimed", "error", 5000)
                        return
                    end

                    order.accepted = true
                    order.acceptedBy = license

                    TriggerClientEvent("codev_fuelstations:client:startOrder", src, order)
                    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
                    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You claimed this order", "success", 5000)
                    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("codev_fuelstations:server:finishOrder", function(station, fuel, order)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)
    local orderId = tonumber(order.id)

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            for _, order in pairs(v.orders) do
                if order.id == (orderId) then
                    if order.acceptedBy ~= license then
                        TriggerClientEvent("codev_fuelstations:notify", src, "Error", "You are not the owner of this order", "error", 5000)
                        return
                    end

                    local price = math.floor(fuel * v.station.DefaultPrice)
                    local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
                    
                    if Config.Framework == "esx" then
                        xPlayer.addMoney(price)
                    else
                        xPlayer.Functions.AddMoney("cash", price)
                    end

                    v.fuel = v.fuel + fuel

                    if v.fuel > v.station.Capacity then
                        v.fuel = v.station.Capacity
                    end

                    v.orders[order.id] = nil

                    SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
                    TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You finished this order", "success", 5000)
                    TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent("codev_fuelstations:server:getPlayerMoney", function()
    local src = source
    local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
    local cash = Config.Framework == "esx" and xPlayer.getMoney() or xPlayer.PlayerData.money.cash
    TriggerClientEvent("codev_fuelstations:client:sendPlayerMoney", src, cash)
end)

RegisterNetEvent("codev_fuelstations:server:pay", function(price, station, fuel)
    local src = source
    local stationName = station.Name
    local ownedStations = GetOwnedStations()
    local license = GetPlayerLicense(src)
    local found = false

    for k, v in pairs(ownedStations) do
        if v.station.Name == stationName then
            v.balance = v.balance + price
            v.fuel = v.fuel - fuel
            
            if v.fuel < 0 then
                v.fuel = 0
            end

            found = true

            local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            
            if Config.Framework == "esx" then
                xPlayer.removeMoney(price)
            else
                xPlayer.Functions.RemoveMoney("cash", price)
            end

            SaveResourceFile(GetCurrentResourceName(), 'database.json', json.encode(ownedStations), -1)
            TriggerClientEvent("codev_fuelstations:notify", src, "Success", "You paid $"..price, "success", 5000)
            TriggerClientEvent("codev_fuelstations:client:updateStations", -1)
            break
        end
    end

    if not found then
        local xPlayer = Config.Framework == "esx" and Framework.GetPlayerFromId(src) or Framework.Functions.GetPlayer(src)
            
        if Config.Framework == "esx" then
            xPlayer.removeMoney(price)
        else
            xPlayer.Functions.RemoveMoney("cash", price)
        end
    end
end)