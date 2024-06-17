Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()

function GetClosestPump(ped)
    local closestPump = nil
    local closestDistance = nil
    local coords = GetEntityCoords(ped)
    local pumpCoords = nil

    if not ClosestStation then return end

    for k, v in pairs(Config.PumpProps) do
        local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, v, false, false, false)

        if object ~= 0 then
            pumpCoords = GetEntityCoords(object)
            local distance = #(coords - pumpCoords)

            if closestDistance == nil or distance < closestDistance then
                closestDistance = distance
                closestPump = object
            end
        end
    end

    return pumpCoords
end

function GetClosestVehicleToPed(ped) 
    local pool = GetGamePool("CVehicle")
    local pedCoords = GetEntityCoords(ped)

    for _, veh in pairs(pool) do
        local vehCoords = GetEntityCoords(veh)
        
        if #(pedCoords - vehCoords) < 4.0 then
            return {coords = vehCoords, veh = veh}
        end
    end

    return false
end

function GetClosestStation()
    local closestStation = nil
    local closestDistance = nil
    local coords = GetEntityCoords(PlayerPedId())

    for station, data in pairs(Stations) do
        local distance = #(coords - data.Coords.Blip)

        ClosestStationDist = distance

        if closestDistance == nil or distance < closestDistance then
            closestDistance = distance
            closestStation = data
        end
    end

    return closestStation
end

function TriggerServerCallback(...)
    if Config.Framework == "esx" then
        Framework.TriggerServerCallback(...)
    else
        Framework.Functions.TriggerCallback(...)
    end
end

function IsMyStation(ClosestStation) 
    if next(MyStations) and ClosestStation then
        for k, v in pairs(MyStations) do
            if v.owner == ClosestStation.owner then
                return true
            end
        end
    end

    return false
end

function DrawText3D(text, x, y, z, scaleX, scaleY) 
    local onScreen = World3dToScreen2d(x, y, z)
	
    if onScreen then		
        local px,py,pz=table.unpack(GetGameplayCamCoords())
        local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
        local scale = (1/dist)*20
        local fov = (1/GetGameplayCamFov())*100
        local scale = scale*fov
    
        SetTextScale(scaleX*scale, scaleY*scale)
        SetTextCentre(1)
        SetTextProportional(1)
        SetTextOutline()
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        SetDrawOrigin(x, y, z)
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

function GetFreeSpotFromStation(station)
    for k, v in pairs(station.VehicleSpawnCoords) do
        local isBusy = IsPositionOccupied(v.x, v.y, v.z, 3, false, true, false, false, false, false, false)
        
        if not isBusy then
            return v
        end
    end

    return false
end

function CreateOrderCar(order)
    local spot = GetFreeSpotFromStation(ClosestStation)

    if spot then
        RequestModel(order.hash)

        while not HasModelLoaded(order.hash) do
            Wait(100)
        end

        CenterBlip = AddBlipForCoord(Config.FuelCenter.Coords)
        
        ClearGpsMultiRoute()
        StartGpsMultiRoute(6, true, true)
        AddPointToGpsMultiRoute(Config.FuelCenter.Coords.x, Config.FuelCenter.Coords.y, Config.FuelCenter.Coords.z)
        SetGpsMultiRouteRender(true)

        return CreateVehicle(order.hash, spot.x, spot.y, spot.z, spot.w, true, false)
    else
        Config.Notify("No free spot to spawn a vehicle", "error", 3500)
        
        Order = {}
        OrderAccepted = false
        return false
    end
end

function CreateBlip(coords, i)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas Station")
	EndTextCommandSetBlipName(blip)

	return blip
end

function LoadAnimDict(dict)
	if HasAnimDictLoaded(dict) then return end
	RequestAnimDict(dict)

	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end
end