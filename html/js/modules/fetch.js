const resourceName = window.GetParentResourceName ? GetParentResourceName() : 'anims';

export const fetchNUI = async (cbname, data) => {
  const options = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: JSON.stringify(data)
  };
  try {

    const resp = await fetch(`https://${resourceName}/${cbname}`, options);

    // Check if the response is OK before trying to parse JSON
    if (!resp.ok) {
      const errorText = await resp.text();
      console.error(`[NUI Fetch] Server responded with an error for ${cbname}: ${resp.status} ${resp.statusText} - ${errorText}`);
      // Throw an error to be caught by the calling function's .catch()
      throw new Error(`NUI fetch failed: ${resp.status} ${resp.statusText}`);
    }

    return await resp.json();
  } catch (error) {
    console.error(`[NUI Fetch] Error in fetchNUI for callback "${cbname}":`, error);
    // Re-throw the error so it can be handled by the calling code (e.g., .then().catch())
    throw error;
  }
};

const setText = (elem, text) => (elem.textContent = text);

// Modificamos createPanels para aceptar la lista de favoritos
export const createPanels = (panelData, favoriteAnims = []) => {
  const main = document.getElementById("anims-holder");
  // Limpiar paneles existentes antes de añadir nuevos
  main.innerHTML = '';

  // Si no hay datos de panel y no estamos en la categoría de favoritos, mostrar un placeholder
  if (!panelData || panelData.length === 0) {
    const placeholder = document.createElement("div");
    placeholder.classList.add("placeholder-container");
    placeholder.innerHTML = `
      <span class="placeholder-title">No hay animaciones en esta sección</span>
      <span class="placeholder-description">Dile a un administrador que añada animaciones para verlas aquí</span>
    `;
    main.appendChild(placeholder);
    return; // Salir de la función si no hay datos
  }

  panelData.forEach((panel) => {
    // Asegurarse de que el panel y su tipo existan
    if (panel && panel.type) {
      const block = document.createElement("div");
      const textBlock = document.createElement("div");
      const title = document.createElement("span");
      const subtitle = document.createElement("span");
      const favorite = document.createElement("span"); // Elemento para la estrella

      block.classList.add("anim", panel.type);

      // Usar el identificador original para el bloque
      block.id =
        (panel.dances && panel.dances.dict) ||
        (panel.scenarios && panel.scenarios.scene) ||
        (panel.expressions && panel.expressions.expression) ||
        (panel.walks && panel.walks.style);
      
      // Establecer atributos de datos para todas las propiedades de la animación, restaurando las propiedades originales
      block.setAttribute(
        "data-dances",
        panel.dances
          ? JSON.stringify({
              dict: panel.dances.dict,
              anim: panel.dances.anim,
              blendIn: panel.dances.blendIn,
              blendOut: panel.dances.blendOut,
              duration: panel.dances.duration,
              flag: panel.dances.flag,
              playbackRate: panel.dances.playbackRate,
              startDelay: panel.dances.startDelay,
            })
          : null
      );
      block.setAttribute(
        "data-scenarios",
        panel.scenarios
          ? JSON.stringify({
              sex: panel.scenarios.sex,
              scene: panel.scenarios.scene,
              duration: panel.scenarios.duration,
              forceExit: panel.scenarios.forceExit,
            })
          : null
      );
      block.setAttribute(
        "data-expressions",
        panel.expressions
          ? JSON.stringify({
              expression: panel.expressions.expression,
              duration: panel.expressions.duration,
            })
          : null
      );
      block.setAttribute(
        "data-walks",
        panel.walks ? JSON.stringify({ style: panel.walks.style }) : null
      );
      block.setAttribute(
        "data-props",
        panel.props
          ? JSON.stringify({
              prop: panel.props.prop,
              bone: panel.props.bone,
              x: panel.props.x,
              y: panel.props.y,
              z: panel.props.z,
              rx: panel.props.rx,
              ry: panel.props.ry,
              rz: panel.props.rz,
              anim: panel.props.anim,
              dict: panel.props.dict,
              propBone: panel.props.propBone,
              propPlacement: panel.props.propPlacement,
              propTwo: panel.props.propTwo || false,
              propTwoBone: panel.props.propTwoBone || false,
              propTwoPlacement: panel.props.propTwoPlacement || false,
            })
          : null
      );
      block.setAttribute(
        "data-particles",
        panel.particles
          ? JSON.stringify({
              asset: panel.particles.asset,
              name: panel.particles.name,
              bone: panel.particles.bone,
              x: panel.particles.x,
              y: panel.particles.y,
              z: panel.particles.z,
              rx: panel.particles.rx,
              ry: panel.particles.ry,
              rz: panel.particles.rz,
              scale: panel.particles.scale,
              placement: panel.particles.placement,
              rgb: panel.particles.rgb,
            })
          : null
      );
      block.setAttribute(
        "data-shared",
        panel.shared
          ? JSON.stringify({
              first: panel.shared.first,
              second: panel.shared.second,
            })
          : null
      );
      block.setAttribute("data-disableMovement", panel.disableMovement || false);
      block.setAttribute("data-disableLoop", panel.disableLoop || false);

      // Event listener para el bloque de animación (excluyendo clics en la estrella)
      block.addEventListener("click", (e) => {
        // Si el clic no fue en la estrella, procede con la animación
        if (!e.target.classList.contains('favorite-star')) {
          fetchNUI("beginAnimation", {
            dance: JSON.parse(block.getAttribute("data-dances")),
            scene: JSON.parse(block.getAttribute("data-scenarios")),
            expression: JSON.parse(block.getAttribute("data-expressions")),
            walk: JSON.parse(block.getAttribute("data-walks")),
            prop: JSON.parse(block.getAttribute("data-props")),
            particle: JSON.parse(block.getAttribute("data-particles")),
            shared: JSON.parse(block.getAttribute("data-shared")),
            disableMovement: JSON.parse(block.getAttribute("data-disableMovement")),
            disableLoop: JSON.parse(block.getAttribute("data-disableLoop")),
          }).then((resp) => {
            if (resp.e == 'nearby') {
              fetchNUI('sendNotification', { type: 'info', message: 'Nadie cerca...' });
            } else {
              (resp.e)
                ? fetchNUI("sendNotification", {
                  type: "success",
                  message: "¡Comenzó la animación!",
                })
                : fetchNUI("sendNotification", {
                  type: "error",
                  message: "¡No se pudo cargar la animación!",
                });
            }
            return;
          });
          block.classList.add("pop");
          setTimeout(() => {
            block.classList.remove("pop");
          }, 300);
        }
      });

      title.classList.add("anim-title");
      subtitle.classList.add("anim-subtitle");

      setText(title, panel.title);
      setText(subtitle, panel.subtitle);

      textBlock.append(title, subtitle);
      textBlock.classList.add("text-block"); // Añadir clase para el bloque de texto

      // Configurar la estrella
      favorite.classList.add("material-icons", "favorite-star");

      // Comprobar si la animación está en la lista de favoritos recibida
      // Se compara por 'subtitle' que debería ser único para cada animación
      const isFavorited = favoriteAnims.some(fav => fav.subtitle === panel.subtitle);
      favorite.textContent = isFavorited ? 'star' : 'star_outline';
      favorite.classList.add(isFavorited ? 'favorited' : 'not-favorited');

      // Añadir evento de click a la estrella
      favorite.addEventListener("click", (e) => {
        e.stopPropagation(); // Evitar que el clic en la estrella active la animación del bloque
        handleFavoriteClick(e.target, panel); // Pasar el elemento de la estrella y los datos del panel
      });

      block.append(textBlock, favorite); // Añadir el bloque de texto y la estrella al bloque principal
      main.appendChild(block);
    }
  });
};

// Nueva función para manejar el clic en la estrella
const handleFavoriteClick = (starElement, panelData) => {
  const isCurrentlyFavorited = starElement.classList.contains('favorited');
  const newFavoriteStatus = !isCurrentlyFavorited;

  starElement.classList.toggle('favorited', newFavoriteStatus);
  starElement.classList.toggle('not-favorited', !newFavoriteStatus);
  starElement.textContent = newFavoriteStatus ? 'star' : 'star_outline';

  // Envía la información al servidor
  fetchNUI("toggleFavorite", {
    animData: {
      title: panelData.title,
      subtitle: panelData.subtitle,
      type: panelData.type,
      // Incluye todas las propiedades de la animación que necesitas guardar en la DB
      dances: panelData.dances,
      scenarios: panelData.scenarios,
      expressions: panelData.expressions,
      walks: panelData.walks,
      props: panelData.props,
      particles: panelData.particles,
      shared: panelData.shared,
      disableMovement: panelData.disableMovement,
      disableLoop: panelData.disableLoop,
    },
    isFavorited: newFavoriteStatus
  });
};
