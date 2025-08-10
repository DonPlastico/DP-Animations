local QBCore = exports['qb-core']:GetCoreObject()
local currentlyPlaying = {}

-- #region Animaciones compartidas
RegisterNetEvent('DP-Animations:resolveAnimation', function(target, shared, accepted)
    local playerId<const> = source
    if type(shared) ~= "table" and tonumber(playerId) ~= tonumber(target) then
        return false
    end
    if playerId and target then
        if accepted then
            TriggerClientEvent('DP-Animations:requestShared', target, shared.first, target, true)
            -- CORRECCIÓN: Cambiado 'TriggerClientClientEvent' a 'TriggerClientEvent'
            TriggerClientEvent('DP-Animations:requestShared', playerId, shared.second, tonumber(playerId))
        else
            QBCore.Functions.Notify(source, 'El jugador rechazo su solicitud...', 'info', 5000)
            QBCore.Functions.Notify(source, 'Solicitud denegada', 'info', 5000)
        end
    end
end)

RegisterNetEvent('DP-Animations:awaitConfirmation', function(target, shared)
    local playerId<const> = source
    if playerId > 0 then
        if target and type(shared) == "table" then
            TriggerClientEvent('DP-Animations:awaitConfirmation', target, playerId, shared)
        end
    end
end)
-- #región final

-- #region Sincronización PTFX
RegisterNetEvent('DP-Animations:syncParticles', function(particles, nearbyPlayers)
    local playerId<const> = source
    if type(particles) ~= "table" or type(nearbyPlayers) ~= "table" then
        return false
    end
    if playerId > 0 then
        for i = 1, #nearbyPlayers do
            if nearbyPlayers[i] ~= playerId then
                TriggerClientEvent('DP-Animations:syncPlayerParticles', nearbyPlayers[i], playerId, particles)
            end
        end
    end
end)

RegisterNetEvent('DP-Animations:syncRemoval', function()
    local playerId<const> = source
    if playerId > 0 then
        local players = GetPlayers()
        if #players > 0 then
            for i = 1, #players do
                if players[i] ~= playerId then
                    TriggerClientEvent('DP-Animations:syncRemoval', players[i])
                end
            end
        end
    end
end)
-- #región final

-- #region Favoritos
-- Evento para alternar el estado de una animación como favorita
RegisterNetEvent('DP-Animations:toggleFavorite', function(animData, isFavorited)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        local identifier = Player.PlayerData.citizenid
        local nombre_animacion = animData.title
        local comando_animacion = animData.subtitle
        local tipo_animacion = animData.type

        if isFavorited then
            -- Añade la animación a la base de datos si no existe
            exports.oxmysql:execute(
                'INSERT INTO animaciones_favoritas (identifier, nombre_animacion, comando_animacion, tipo_animacion) VALUES (?, ?, ?, ?)',
                {identifier, nombre_animacion, comando_animacion, tipo_animacion}, function(result)
                    if result == 0 then -- Si no se insertó (ej. ya existía o error)
                        print(string.format(
                            '^1[DP-Animations]^0 ^3WARNING: No se pudo añadir la animación "%s" para el jugador %s. Puede que ya exista.^0',
                            nombre_animacion, identifier))
                    end
                    -- Después de la operación, envía la lista actualizada de favoritos al cliente
                    TriggerEvent('DP-Animations:fetchFavorites')
                end)
        else
            -- Elimina la animación de la base de datos
            exports.oxmysql:execute('DELETE FROM animaciones_favoritas WHERE identifier = ? AND comando_animacion = ?',
                {identifier, comando_animacion}, function(result)
                    if result == 0 then -- Si no se eliminó (ej. no existía o error)
                        print(string.format(
                            '^1[DP-Animations]^0 ^3WARNING: No se pudo eliminar la animación "%s" para el jugador %s. Puede que no exista.^0',
                            nombre_animacion, identifier))
                    end
                    -- Después de la operación, envía la lista actualizada de favoritos al cliente
                    TriggerEvent('DP-Animations:fetchFavorites')
                end)
        end
    end
end)

-- Nuevo evento para que el cliente solicite sus animaciones favoritas
RegisterNetEvent('DP-Animations:fetchFavorites', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        local identifier = Player.PlayerData.citizenid
        exports.oxmysql:fetch(
            'SELECT nombre_animacion, comando_animacion, tipo_animacion FROM animaciones_favoritas WHERE identifier = ?',
            {identifier}, function(result)
                local favorites = {}
                if result then
                    for _, v in ipairs(result) do
                        table.insert(favorites, {
                            title = v.nombre_animacion,
                            subtitle = v.comando_animacion,
                            type = v.tipo_animacion
                        })
                    end
                end
                TriggerClientEvent('DP-Animations:setFavorites', src, favorites)
            end)
    end
end)