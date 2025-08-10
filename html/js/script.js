import { createPanels, fetchNUI } from "./modules/fetch.js";
import { setDisplay } from "./modules/functions.js";

// Variable global para almacenar todas las animaciones cargadas de anims.json
let allAnims = [];
// Variable global para almacenar las animaciones favoritas
let favoriteAnims = [];

window.addEventListener('load', (e) => {
  window.addEventListener("message", (e) => {
    switch (e.data.action) {
      case 'panelStatus':
        if (e.data.panelStatus) {
          setDisplay('fadeIn');
        } else {
          setDisplay('fadeOut');
        }
        break;

      case 'findEmote':
        const panels = document.getElementsByClassName('anim');
        for (let i = 0; i < panels.length; i++) {
          let panelEmote = panels[i].childNodes[0].lastChild.textContent.split(" ")[1];
          if (panelEmote.toLowerCase() == e.data.name.toLowerCase()) {
            const animData = {
              dance: JSON.parse(panels[i].getAttribute('data-dances')),
              scene: JSON.parse(panels[i].getAttribute('data-scenarios')),
              expression: JSON.parse(panels[i].getAttribute('data-expressions')),
              walk: JSON.parse(panels[i].getAttribute('data-walks')),
              prop: JSON.parse(panels[i].getAttribute('data-props')),
              particle: JSON.parse(panels[i].getAttribute('data-particles')),
              shared: JSON.parse(panels[i].getAttribute('data-shared')),
              disableMovement: JSON.parse(panels[i].getAttribute('data-disableMovement')),
              disableLoop: JSON.parse(panels[i].getAttribute('data-disableLoop'))
            };

            fetchNUI('beginAnimation', animData).then((resp) => {
              if (resp.e == 'nearby') {
                fetchNUI('sendNotification', { type: 'info', message: 'Nadie cerca...' })
              } else {
                (resp.e)
                  ? fetchNUI('sendNotification', { type: 'success', message: '¡Animación ejecutada!' })
                  : fetchNUI('sendNotification', { type: 'error', message: '¡No se pudo cargar la animación!' });
              }
              return;
            });
            return;
          }
        }
        fetchNUI('sendNotification', { type: 'info', message: 'No se encontró la animación...' })
        break;

      case 'setFavorites':
        // Cuando recibimos las animaciones favoritas del servidor
        favoriteAnims = e.data.favorites;
        // Volvemos a crear los paneles para la categoría activa actual
        const currentActiveCategoryOnFavSet = document.querySelector('.sidebar.active').id;
        let animsToDisplayOnFavoriteSet = [];

        if (currentActiveCategoryOnFavSet === 'favorites') {
          animsToDisplayOnFavoriteSet = favoriteAnims;
        } else {
          animsToDisplayOnFavoriteSet = allAnims.filter(anim => anim.type === currentActiveCategoryOnFavSet);
        }
        createPanels(animsToDisplayOnFavoriteSet, favoriteAnims);
        break;

      default:
        console.log('Algo no se cargó correctamente al enviar un mensaje');
        break;
    }
  });

  // Escuchar el evento 'categoryChange' disparado desde functions.js
  window.addEventListener('categoryChange', (e) => {
    const categoryId = e.detail.categoryId;
    let animsToDisplay = [];

    if (categoryId === 'favorites') {
      animsToDisplay = favoriteAnims;
    } else if (categoryId === 'settings') {
      // No hacer nada, la lógica de settings ya se maneja en functions.js
      return;
    } else {
      // Filtrar animaciones por el tipo de la categoría seleccionada
      animsToDisplay = allAnims.filter(anim => anim.type === categoryId);
    }
    createPanels(animsToDisplay, favoriteAnims);
  });

  // Configuración inicial
  const animOpts = JSON.parse(localStorage.getItem('animOptions')) || [];
  if (animOpts.length === 0) {
    localStorage.setItem('animOptions', JSON.stringify([]));
  }

  const duration = localStorage.getItem("currentDuration");
  const cancel = localStorage.getItem("currentCancel");

  if (duration) {
    document.getElementById("set-duration").placeholder = duration;
  }
  if (cancel) {
    document.getElementById("set-cancel").placeholder = cancel;
  }
  fetchNUI("changeCfg", {
    type: "settings",
    duration: duration,
    cancel: cancel,
  });

  // Cargar todas las animaciones desde anims.json una vez
  fetch('../anims.json')
    .then((resp) => resp.json())
    .then((data) => {
      allAnims = data; // Guardamos todas las animaciones
      // Inicialmente, mostramos las danzas (o la categoría por defecto)
      const initialActiveCategoryElement = document.querySelector('.sidebar.active');
      const initialCategory = initialActiveCategoryElement ? initialActiveCategoryElement.id : 'dances';
      const filteredAnims = allAnims.filter(anim => anim.type === initialCategory);
      createPanels(filteredAnims, favoriteAnims); // Pasa la lista de favoritos vacía inicialmente

      // Luego, solicitamos los favoritos al servidor
      fetchNUI('fetchFavorites');
    })
    .catch((error) => console.error("Error al cargar anims.json:", error));
});
