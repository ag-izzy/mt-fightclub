local QBCore = exports['qb-core']:GetCoreObject()
local Poly = PolyZone:Create({
    vector2(-48.554237365723, -1284.91796875),
    vector2(-52.986343383789, -1284.8696289062),
    vector2(-52.98511505127, -1280.3149414062),
    vector2(-48.464508056641, -1280.3884277344)
  }, {
    name="figth-zone",
    --minZ = 29.225456237793,
    --maxZ = 29.429374694824
  })

local function ProcurarMorto()
    listen = true
    CreateThread(function()
        while listen do
                TriggerEvent('hospital:client:FigthClubRevive')
            Wait(1)
            end
    end)
end

CreateThread(function()
    Poly:onPlayerInOut(function(isPointInside)
        if isPointInside then
            ProcurarMorto()
        else
            listen = false
        end
    end)
end)

CreateThread(function()
    RequestModel(Config.Locations['PedModel'])
      while not HasModelLoaded(Config.Locations['PedModel']) do
      Wait(1)
    end
    figthPed = CreatePed(2, Config.Locations['PedModel'], Config.Locations['PedLoc'], false, false)
    SetPedFleeAttributes(figthPed, 0, 0)
    SetPedDiesWhenInjured(figthPed, false)
    TaskStartScenarioInPlace(figthPed, "missheistdockssetup1clipboard@base", 0, true)
    SetPedKeepTask(figthPed, true)
    SetBlockingOfNonTemporaryEvents(figthPed, true)
    SetEntityInvincible(figthPed, true)
    FreezeEntityPosition(figthPed, true)
  
    exports['qb-target']:AddBoxZone("figthPed", Config.Locations['TargetLoc'], 1, 1, {
        name="figthPed",
        heading=0,
        debugpoly = false,
    }, {
        options = {
            {
                event = "mt-figthclub:client:TeleportarPlayer",
                icon = "fas fa-dumbbell",
                label = "Start game",
            },
            {
                event = "mt-figthclub:client:RetirarPlayer",
                icon = "fas fa-dumbbell",
                label = "Stop game",
            }
        },
        distance = 2.5
    })
        
    local blip = AddBlipForCoord(Config.Locations['TargetLoc'])
    
    SetBlipSprite (blip, 88)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 10)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Figth Club')
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('mt-figthclub:client:TeleportarPlayer', function()
    SetEntityCoords(PlayerPedId(), Config.Locations['RingueLoc'])
end)

RegisterNetEvent('mt-figthclub:client:RetirarPlayer', function()
    SetEntityCoords(PlayerPedId(), Config.Locations['TargetLoc'])
end)