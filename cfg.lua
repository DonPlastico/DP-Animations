cfg = {
    commandName = 'animaciones', -- Abrir el panel de animaciones
    commandSuggestion = 'Abra el panel de gestos', -- Abrir la sugerencia del panel de animaciones
    commandNameEmote = 'e', -- Reproducir una animación por comando
    commandNameSuggestion = 'Reproducir una animación por comando', -- Reproducir una animación mediante sugerencia de comando
    keyActive = true, -- Utilice la llave para abrir el panel
    keyLetter = 'F3', -- ¿Qué tecla para abrir el panel si cfg.keyActive es verdadero?
    keySuggestion = 'OAbra el panel de gestos con una tecla', -- Sugerencia sobre la asignación de teclas
    walkingTransition = 0.5,

    acceptKey = 38, -- Tecla para aceptar animación compartida
    denyKey = 182, -- Tecla para rechazar animación compartida
    waitBeforeWalk = 5000, -- Espere antes de volver al estilo de caminata (si alguien tiene un método mejor, haga una solicitud de extracción porque los multicaracteres son una molestia)

    -- No tocar
    panelStatus = false,

    animActive = false,
    animDuration = 1500, -- Puedes cambiar esto pero te recomiendo no hacerlo.
    animLoop = false,
    animMovement = false,
    animDisableMovement = false,
    animDisableLoop = false,

    sceneActive = false,

    propActive = false,
    propsEntities = {},

    ptfxOwner = false,
    ptfxActive = false,
    ptfxEntities = {},
    ptfxEntitiesTwo = {},

    malePeds = {"mp_m_freemode_01"},

    sharedActive = false,

    cancelKey = 73
}
