Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()

function RegisterServerCallback(...)
    if Config.Framework == "esx" then
        Framework.RegisterServerCallback(...)
    else
        Framework.Functions.CreateCallback(...)
    end
end

function GetPlayerLicense(source)
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local license = GetPlayerIdentifier(source, i)

        if string.sub(license, 1, 7) == "license" then
            return license
        end
    end
end

function GetOwnedStations()
    local file = LoadResourceFile(GetCurrentResourceName(), 'database.json')
    local data = json.decode(file)

    return data
end

function GetMyStations(source)
    local file = LoadResourceFile(GetCurrentResourceName(), 'database.json')
    local data = json.decode(file)
    local stations = {}
    local license = GetPlayerLicense(source)
    
    for k, v in pairs(data) do
        for _, employee in pairs(v.employees) do
            if employee.license == license then
                table.insert(stations, v)
            end
        end
    end

    return stations
end

function table.copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[table.copy(k)] = table.copy(v) end
    return res
end