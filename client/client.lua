local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('rsg-spawn:client:setupSpawnUI', function(cData, new)
    if new == false then
        TriggerEvent('rsg-spawn:client:existingplayer')
        exports.weathersync:setSyncEnabled(true)
    else
        TriggerEvent('rsg-spawn:client:newplayer')
    end
end)

RegisterNetEvent('rsg-spawn:client:existingplayer', function()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local isJailed = PlayerData.metadata["injail"]
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid
    local randomIndex = math.random(1, #Config.RandomTips)
    local randomTip = Config.RandomTips[randomIndex]
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname .. ' ' .. lastname,
        locale('cl_lang_1') .. citizenid, locale('cl_lang_2') .. ' ' .. randomTip)
    Wait(10000)

    DoScreenFadeOut(1000)
    exports['rsg-appearance']:ApplySkin()

    -- set player health
    local currentHealth = PlayerData.metadata["health"]
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, currentHealth)
    SetEntityCoords(playerPed, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
    SetEntityHeading(playerPed, PlayerData.position.w)
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)

    if Config.AutoDualWield then
        Wait(2000)
        TriggerEvent('rsg-weapons:client:AutoDualWield')
    end

    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
end)

local function OpenNUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "OPEN_SPAWN_MENU",
        locations = Config.SpawnLocations
    })
end

local function SpawnChar(coords)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local citizenid = PlayerData.citizenid
    local randomIndex = math.random(1, #Config.RandomTips)
    local randomTip = Config.RandomTips[randomIndex]
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 1122662550, 347053089, 0, firstname .. ' ' .. lastname,
        locale('cl_lang_1') .. citizenid, locale('cl_lang_2') .. ' ' .. randomTip)
    Wait(10000)
    DoScreenFadeOut(1000)

    exports['rsg-appearance']:ApplySkin()
    local ped = PlayerPedId()

    SetEntityCoordsNoOffset(ped, coords, true, true, true)
    SetEntityHeading(ped, coords.w)
    FreezeEntityPosition(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    if Config.AutoDualWield then
        Wait(2000)
        TriggerEvent('rsg-weapons:client:AutoDualWield')
    end
    ShutdownLoadingScreen()
    ExecuteCommand('revive')
    DoScreenFadeIn(1000)
    TriggerServerEvent('RSGCore:Server:OnPlayerLoaded')
    TriggerEvent('RSGCore:Client:OnPlayerLoaded')
end

RegisterNUICallback('spawnSelected', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "CLOSE_MENU" })

    local chosenId = data.locationId

    for _, loc in pairs(Config.SpawnLocations) do
        if loc.id == chosenId then
            SpawnChar(loc.coords)
            break
        end
    end

    cb('ok')
end)


RegisterNetEvent('rsg-spawn:client:newplayer', function()
    if not Config.SelectLocations then
        SpawnChar(Config.SpawnLocation.coords)
    else
        OpenNUI()
    end
end)

local function getFirstVector(value)
    if type(value) == 'table' then
        return value[1]
    end

    return value
end

-- Checks configured bad spawn areas and moves the player to the matching safe location.
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    local spawnChecks = Config.SpawnChecks
    if not spawnChecks then
        return
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if Config.Debug then
        print('Checking spawn: ' .. tostring(playerCoords))
    end

    for checkName, check in pairs(spawnChecks) do
        local radius = check.Radius or check.radius or 200
        local moveTo = getFirstVector(check.moveTo)

        if moveTo then
            for _, badSpawn in ipairs(check.badSpawn or {}) do
                if #(playerCoords - badSpawn) < radius then
                    if Config.Debug then
                        print(('Bad spawn matched: %s'):format(checkName))
                    end
                    SetEntityCoords(playerPed, moveTo.x, moveTo.y, moveTo.z, 0, 0, 0, false)
                    return
                end
            end
        end
    end
end)
