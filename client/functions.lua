local QBCore = exports['qb-core']:GetCoreObject()

---Mantiene la animación de reproducción
---@class Play
Play = {}

---Comprueba el sexo del peatón
---@return string
local function checkSex()
    local pedModel = GetEntityModel(PlayerPedId())
    for i = 1, #cfg.malePeds do
        if pedModel == GetHashKey(cfg.malePeds[i]) then
            return 'male'
        end
    end
    return 'female'
end

---Reproduce una animación
---@param dance table
---@param particle table
---@param prop table
---@param p table Promise
Play.Animation = function(dance, particle, prop, p)
    if dance then
        if cfg.animActive then
            Load.Cancel()
        end
        Load.Dict(dance.dict)
        if prop then
            Play.Prop(prop)
        end

        if particle then
            local nearbyPlayers = {}
            local players = GetActivePlayers()
            if #players > 1 then
                for i = 1, #players do
                    nearbyPlayers[i] = GetPlayerServerId(players[i])
                end
                cfg.ptfxOwner = true
                TriggerServerEvent('DP-Animations:syncParticles', particle, nearbyPlayers)
            else
                Play.Ptfx(PlayerPedId(), particle)
            end
        end

        local loop = cfg.animDuration
        local move = 1
        if cfg.animLoop and not cfg.animDisableLoop then
            loop = -1
        else
            if dance.duration then
                SetTimeout(dance.duration, function()
                    Load.Cancel()
                end)
            else
                SetTimeout(cfg.animDuration, function()
                    Load.Cancel()
                end)
            end
        end
        if cfg.animMovement and not cfg.animDisableMovement then
            move = 51
        end
        TaskPlayAnim(PlayerPedId(), dance.dict, dance.anim, 1.5, 1.5, loop, move, 0, false, false, false)
        RemoveAnimDict(dance.dict)
        cfg.animActive = true
        if p then
            p:resolve({
                passed = true
            })
        end
        return
    end
    p:reject({
        passed = false
    })
end

---Reproduce una escena
---@param scene table
---@param p table Promise
Play.Scene = function(scene, p)
    if scene then
        local sex = checkSex()
        if not scene.sex == 'both' and not (sex == scene.sex) then
            QBCore.Functions.Notify('El sexo no permite esta animación.', 'info', 5000)
        else
            if scene.sex == 'position' then
                local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
                TaskStartScenarioAtPosition(PlayerPedId(), scene.scene, coords.x, coords.y, coords.z,
                    GetEntityHeading(PlayerPedId()), 0, 1, false)
            else
                TaskStartScenarioInPlace(PlayerPedId(), scene.scene, 0, true)
            end
            cfg.sceneActive = true
            p:resolve({
                passed = true
            })
            return
        end
    end
    p:reject({
        passed = false
    })
end

---Reproduce una expresión
---@param expression table
---@param p table Promise
Play.Expression = function(expression, p)
    -- Usar pcall para json.encode para evitar errores si no está disponible
    local expression_data_str = "nil"
    if pcall(function()
        expression_data_str = json.encode(expression)
    end) then
        print(string.format("[functions.lua] Play.Expression called. Expression data received: %s", expression_data_str))
    else
        print(string.format("[functions.lua] Play.Expression called. Expression data received (no json.encode): %s",
            tostring(expression)))
    end

    if expression and expression.expression then
        -- Limpiar cualquier expresión facial inactiva anterior estableciéndola a un valor nulo o por defecto
        -- 'none' es una expresión conocida que suele resetear la cara.
        SetFacialIdleAnimOverride(PlayerPedId(), "none", 0)
        Citizen.Wait(10) -- Pequeño retraso para asegurar que la limpieza surta efecto

        print(string.format("[functions.lua] Attempting to set facial expression: %s with duration: %s",
            expression.expression, expression.duration or -1))

        -- Intentar establecer una expresión temporal primero, luego la anulación inactiva
        SetPedExpression(PlayerPedId(), expression.expression, 0.1) -- Tiempo de mezcla corto
        Citizen.Wait(50) -- Darle un momento para que se aplique

        -- Establecer la expresión facial inactiva
        SetFacialIdleAnimOverride(PlayerPedId(), expression.expression, expression.duration or -1)

        -- Si se especifica una duración, limpiar la expresión después de ese tiempo
        if expression.duration and expression.duration > 0 then
            SetTimeout(expression.duration, function()
                -- Volver a establecer a "none" para limpiar la expresión
                SetFacialIdleAnimOverride(PlayerPedId(), "none", 0)
                print(string.format("[functions.lua] Cleared facial expression after duration for: %s",
                    expression.expression))
            end)
        end

        p:resolve({
            passed = true
        })
        return
    end
    print("[functions.lua] Play.Expression received no valid expression data or expression name is missing.")
    p:reject({
        passed = false
    })
end

---Reproduce un estilo de caminata
---@param walk table
---@param p table Promise
Play.Walk = function(walk, p)
    if walk then
        Load.Walk(walk.style)
        SetPedMovementClipset(PlayerPedId(), walk.style, cfg.walkingTransition)
        RemoveAnimSet(walk.style)
        SetResourceKvp('savedWalk', walk.style) -- Guardar el estilo de caminata
        p:resolve({
            passed = true
        })
        return
    end
    p:reject({
        passed = false
    })
end

---Crea un/unos accesorios
---@param props table
Play.Prop = function(props)
    if props then
        if props.prop then
            Load.Model(props.prop)
            Load.PropCreation(PlayerPedId(), props.prop, props.propBone, props.propPlacement)
        end
        if props.propTwo then
            Load.Model(props.propTwo)
            Load.PropCreation(PlayerPedId(), props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
    end
end

---Crea un efecto de partículas
---@param ped number
---@param particles table
Play.Ptfx = function(ped, particles)
    if particles then
        Load.Ptfx(particles.asset)
        UseParticleFxAssetNextCall(particles.asset)
        local attachedProp
        for _, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(ped, v) then
                attachedProp = v
                break
            end
        end
        if not attachedProp and not cfg.ptfxEntitiesTwo[NetworkGetEntityOwner(ped)] and not cfg.ptfxOwner and ped ==
            PlayerPedId() then
            attachedProp = cfg.propsEntities[1] or cfg.propsEntities[2]
        end
        Load.PtfxCreation(ped, attachedProp or nil, particles.name, particles.asset, particles.placement, particles.rgb)
    end
end

---Intenta enviar evento al servidor para animación
---@param shared table
---@param p table
Play.Shared = function(shared, p)
    if shared then
        local closePed = Load.GetPlayer()
        if closePed then
            local targetId = NetworkGetEntityOwner(closePed)
            QBCore.Functions.Notify('Solicitud enviada a ' .. GetPlayerName(targetId), 'info', 5000)
            TriggerServerEvent('DP-Animations:awaitConfirmation', GetPlayerServerId(targetId), shared)
            p:resolve({
                passed = true,
                shared = true
            })
        end
    end
    p:resolve({
        passed = false,
        nearby = true
    })
end

---Creates a notifications
---@param type string
---@param message string
Play.Notification = function(message, type)
    QBCore.Functions.Notify(message, type, 5000)
end

---Reproduce animación compartida si se acepta
---@param shared table
---@param targetId number
---@param owner any
RegisterNetEvent('DP-Animations:requestShared', function(shared, targetId, owner)
    if type(shared) == "table" and targetId then
        if cfg.animActive or cfg.sceneActive then
            Load.Cancel()
        end
        Wait(350)

        local targetPlayer = Load.GetPlayer()
        if targetPlayer then
            SetTimeout(shared[4] or 3000, function()
                cfg.sharedActive = false
            end)
            cfg.sharedActive = true
            local ped = PlayerPedId()
            if not owner then
                local targetHeading = GetEntityHeading(targetPlayer)
                local targetCoords = GetOffsetFromEntityInWorldCoords(targetPlayer, 0.0, shared[3] + 0.0, 0.0)

                SetEntityHeading(ped, targetHeading - 180.1)
                SetEntityCoordsNoOffset(ped, targetCoords.x, targetCoords.y, targetCoords.z, 0)
            end

            Load.Dict(shared[1])
            TaskPlayAnim(PlayerPedId(), shared[1], shared[2], 2.0, 2.0, shared[4] or 3000, 1, 0, false, false, false)
            RemoveAnimDict(shared[1])
        end
    end
end)

---Carga la confirmación compartida para el objetivo
---@param target number
---@param shared table
RegisterNetEvent('DP-Animations:awaitConfirmation', function(target, shared)
    if not cfg.sharedActive then
        Load.Confirmation(target, shared)
    else
        TriggerServerEvent('DP-Animations:resolveAnimation', target, shared, false)
    end
end)

---Just notification function but for
---server to send to target
---@param type string
---@param message string
RegisterNetEvent('DP-Animations:notify', function(message, type)
    QBCore.Functions.Notify(message, type, 5000)
end)

exports('Play', function()
    return Play
end)

RegisterNetEvent('DP-Animations:syncPlayerParticles', function(syncPlayer, particle)
    local mainPed = GetPlayerPed(GetPlayerFromServerId(syncPlayer))
    if mainPed > 0 and type(particle) == "table" then
        Play.Ptfx(mainPed, particle)
    end
end)

RegisterNetEvent('DP-Animations:syncRemoval', function(syncPlayer)
    local targetParticles = cfg.ptfxEntitiesTwo[tonumber(syncPlayer)]
    if targetParticles then
        -- Si targetParticles es una tabla, iterar sobre ella para detener y eliminar cada efecto
        if type(targetParticles) == 'table' then
            for _, ptfxHandle in ipairs(targetParticles) do
                StopParticleFxLooped(ptfxHandle, 0)
                RemoveParticleFx(ptfxHandle, true)
            end
        else -- Si es un solo handle (como en tu versión original)
            StopParticleFxLooped(targetParticles, 0)
            RemoveParticleFx(targetParticles, true)
        end
        cfg.ptfxEntitiesTwo[syncPlayer] = nil
    end
end)
