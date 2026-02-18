local ESX = exports['es_extended']:getSharedObject()

local playerBmx = {}

----------------------------------------
--         ITEM UTILISABLE            --
----------------------------------------

ESX.RegisterUsableItem('bmx', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if playerBmx[source] then
        xPlayer.showNotification('~o~Vous avez déjà un BMX sorti')
        return
    end

    local item = exports.ox_inventory:GetItem(source, 'bmx', nil, false)
    if not item or item.count < 1 then
        xPlayer.showNotification('~r~Vous ne possédez pas de BMX')
        return
    end

    TriggerClientEvent('bmx:spawn', source)
end)

----------------------------------------
--          BMX SORTI                 --
----------------------------------------

RegisterNetEvent('bmx:spawned', function(netId)
    local source  = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local success = exports.ox_inventory:RemoveItem(source, 'bmx', 1)
    if not success then
        TriggerClientEvent('bmx:cancelSpawn', source)
        return
    end

    playerBmx[source] = netId
end)

----------------------------------------
--          BMX RAMASSÉ               --
----------------------------------------

RegisterNetEvent('bmx:deleteEntity', function(netId)
    local source = source

    if playerBmx[source] ~= netId then
        return
    end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    playerBmx[source] = nil

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local success = exports.ox_inventory:AddItem(source, 'bmx', 1)
    if success then
        xPlayer.showNotification('~g~Vous avez rangé votre BMX')
    else
        xPlayer.showNotification('~r~Inventaire plein, le BMX a été supprimé')
    end
end)

----------------------------------------
--         DÉCONNEXION                --
----------------------------------------

AddEventHandler('playerDropped', function()
    local source = source
    if not playerBmx[source] then return end

    local entity = NetworkGetEntityFromNetworkId(playerBmx[source])
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    playerBmx[source] = nil
end)

----------------------------------------
--          DÉMARRAGE                 --
----------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print('^2[DC_BMX] Script démarré^0')
end)