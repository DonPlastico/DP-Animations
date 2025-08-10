local QBCore = exports['qb-core']:GetCoreObject()

-- #region Funciones
---Comienza la animación dependiendo del tipo de datos
---@param data table Animation Data
---@param p string Promise
local function animType(data, p)
    if data then
        if data.disableMovement then
            cfg.animDisableMovement = true
        end
        if data.disableLoop then
            cfg.animDisableLoop = true
        end
        if data.dance then
            Play.Animation(data.dance, data.particle, data.prop, p)
        elseif data.scene then
            Play.Scene(data.scene, p)
        elseif data.expression then
            Play.Expression(data.expression, p)
        elseif data.walk then
            Play.Walk(data.walk, p)
        elseif data.shared then
            Play.Shared(data.shared, p)
        end
    end
end

---Comienza el hilo de cancelación de claves
local function enableCancel()
    CreateThread(function()
        while cfg.animActive or cfg.sceneActive do
            if IsControlJustPressed(0, cfg.cancelKey) then
                Load.Cancel()
                break
            end
            Wait(10)
        end
    end)
end

---Encuentra un gesto mediante un comando
---@param emoteName table
local function findEmote(emoteName)
    if emoteName then
        local name = emoteName:upper()
        SendNUIMessage({
            action = 'findEmote',
            name = name
        })
    end
end

---Devuelve el estilo de caminata actual guardado en kvp
---@return string
local function getWalkingStyle(cb)
    local savedWalk = GetResourceKvpString('walkingStyle')
    if savedWalk and savedWalk ~= '' then
        cb({
            passed = true,
            walk = savedWalk
        })
    else
        cb({
            passed = false
        })
    end
end
-- #región final

-- #region Devoluciones de llamadas NUI
RegisterNUICallback('changeCfg', function(data, cb)
    if data then
        if data.type == 'movement' then
            cfg.animMovement = not data.state
            SetResourceKvp('movement', tostring(cfg.animMovement)) -- Guardar en KVP
        elseif data.type == 'loop' then
            cfg.animLoop = not data.state
            SetResourceKvp('loop', tostring(cfg.animLoop)) -- Guardar en KVP
        elseif data.type == 'settings' then
            cfg.animDuration = tonumber(data.duration) or cfg.animDuration
            cfg.cancelKey = tonumber(data.cancel) or cfg.cancelKey
            SetResourceKvpInt('animDuration', cfg.animDuration) -- Guardar en KVP
            SetResourceKvpInt('cancelKey', cfg.cancelKey) -- Guardar en KVP
        end
    end
    cb({})
end)

RegisterNUICallback('cancelAnimation', function(_, cb)
    Load.Cancel()
    cb({})
end)

RegisterNUICallback('removeProps', function(_, cb)
    Load.PropRemoval('global')
    cb({})
end)

RegisterNUICallback('exitPanel', function(_, cb)
    if cfg.panelStatus then
        cfg.panelStatus = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'panelStatus',
            panelStatus = cfg.panelStatus
        })
    end
    cb({})
end)

RegisterNUICallback('sendNotification', function(data, cb)
    if data then
        QBCore.Functions.Notify(data.message, data.type, 5000)
    end
    cb({})
end)

RegisterNUICallback('fetchStorage', function(data, cb)
    if data then
        for _, v in pairs(data) do
            if v == 'loop' then
                cfg.animLoop = true
            elseif v == 'movement' then
                cfg.animMovement = true
            end
        end
        local savedWalk = GetResourceKvpString('walkingStyle') -- Usar 'walkingStyle' como clave
        if savedWalk and savedWalk ~= '' then -- Si alguien tiene una mejor implementación que funcione con multichar, por favor compártala.
            local p = promise.new()
            Wait(cfg.waitBeforeWalk)
            Play.Walk({
                style = savedWalk
            }, p)
            local result = Citizen.Await(p)
            if result.passed then
                QBCore.Functions.Notify('Restablecer el antiguo estilo de caminata', 'info', 5000)
            end
        end
    end
    cb({})
end)

RegisterNUICallback('beginAnimation', function(data, cb)
    Load.Cancel()
    local animState = promise.new()
    animType(data, animState)
    local result = Citizen.Await(animState)
    if result.passed then
        if not result.shared then
            enableCancel()
        end
        cb({
            e = true
        })
        return
    end
    if result.nearby then
        cb({
            e = 'nearby'
        })
        return
    end
    cb({
        e = false
    })
end)

-- Callback NUI para alternar el favorito de una animación
RegisterNUICallback('toggleFavorite', function(data, cb)
    if data and data.animData then
        -- Envía los datos de la animación y el estado de favorito al servidor
        TriggerServerEvent('DP-Animations:toggleFavorite', data.animData, data.isFavorited)
    end
    cb({}) -- Siempre envía una respuesta al frontend
end)

-- Nuevo callback NUI para solicitar favoritos al servidor
RegisterNUICallback('fetchFavorites', function(data, cb)
    TriggerServerEvent('DP-Animations:fetchFavorites')
    cb({})
end)
-- #región final

-- Comandos de región
RegisterCommand(cfg.commandName, function()
    cfg.panelStatus = not cfg.panelStatus
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'panelStatus',
        panelStatus = cfg.panelStatus
    })
end)

RegisterCommand(cfg.commandNameEmote, function(_, args)
    if args and args[1] then
        return findEmote(args[1])
    end
    QBCore.Functions.Notify('No hay nombre de emoticon establecido...', 'info', 5000)
end)

if cfg.keyActive then
    RegisterKeyMapping(cfg.commandName, cfg.keySuggestion, 'keyboard', cfg.keyLetter)
end
-- #región final

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() == name then
        Load.Cancel()
    end
end)

-- Al iniciar el script, solicita las animaciones favoritas al servidor
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('DP-Animations:fetchFavorites')
    end
end)

-- Recibe las animaciones favoritas del servidor y las envía a la NUI
RegisterNetEvent('DP-Animations:setFavorites', function(favorites)
    SendNUIMessage({
        action = 'setFavorites',
        favorites = favorites
    })
end)

exports('PlayEmote', findEmote)
exports('GetWalkingStyle', getWalkingStyle)
