local ESX      = exports['es_extended']:getSharedObject()
local bmxModel = `bmx`
local isBusy   = false
local spawnedBmx = nil 

----------------------------------------
--        CHARGEMENT DU MODÈLE        --
----------------------------------------

CreateThread(function()
    RequestModel(bmxModel)
    while not HasModelLoaded(bmxModel) do
        Wait(100)
    end
end)

----------------------------------------
--          TARGET GLOBAL             --
----------------------------------------

CreateThread(function()
    Wait(1000)

    exports.ox_target:addModel(bmxModel, {
        {
            name    = 'pickup_bmx_world',
            icon    = 'fa-solid fa-hand',
            label   = 'Ramasser le BMX',
            distance = 2.5,
            canInteract = function(entity)
                return not Entity(entity).state.bmx_player_spawned
            end,
            onSelect = function(data)
                PickupBmx(data.entity)
            end
        }
    })
end)

----------------------------------------
--           SPAWN DU BMX             --
----------------------------------------

RegisterNetEvent('bmx:spawn', function()
    if isBusy then
        ESX.ShowNotification('~r~Action déjà en cours')
        return
    end

    isBusy = true

    local ped     = PlayerPedId()
    local coords  = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local forward = GetEntityForwardVector(ped)

    local spawnCoords = vector3(
        coords.x + forward.x * 2.0,
        coords.y + forward.y * 2.0,
        coords.z
    )

    local vehicle = CreateVehicle(bmxModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)

    local timeout = 0
    while not DoesEntityExist(vehicle) and timeout < 50 do
        Wait(100)
        timeout = timeout + 1
    end

    if not DoesEntityExist(vehicle) then
        ESX.ShowNotification('~r~Impossible de spawner le BMX')
        isBusy = false
        return
    end

    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    Entity(vehicle).state:set('bmx_player_spawned', true, true)

    spawnedBmx = vehicle

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    TriggerServerEvent('bmx:spawned', netId)

    ESX.ShowNotification('~g~Vous avez sorti votre BMX')

    exports.ox_target:addLocalEntity(vehicle, {
        {
            name     = 'pickup_bmx_own',
            icon     = 'fa-solid fa-hand',
            label    = 'Ranger le BMX',
            onSelect = function(data)
                PickupBmx(data.entity)
            end
        }
    })

    isBusy = false
end)

RegisterNetEvent('bmx:cancelSpawn', function()
    if spawnedBmx and DoesEntityExist(spawnedBmx) then
        DeleteEntity(spawnedBmx)
        spawnedBmx = nil
    end
    ESX.ShowNotification('~r~Erreur : BMX annulé')
    isBusy = false
end)

----------------------------------------
--          RAMASSAGE DU BMX          --
----------------------------------------

function PickupBmx(entity)
    if not DoesEntityExist(entity) or isBusy then return end

    isBusy = true
    local ped = PlayerPedId()

    RequestAnimDict('pickup_object')
    while not HasAnimDictLoaded('pickup_object') do
        Wait(100)
    end

    TaskPlayAnim(ped, 'pickup_object', 'pickup_low', 8.0, -8.0, 1000, 0, 0, false, false, false)
    Wait(1000)

    if DoesEntityExist(entity) then
        local netId = NetworkGetNetworkIdFromEntity(entity)
        TriggerServerEvent('bmx:deleteEntity', netId)
        spawnedBmx = nil
    end

    isBusy = false
end

----------------------------------------
--          NETTOYAGE                 --
----------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    exports.ox_target:removeModel(bmxModel, 'pickup_bmx_world')
end)