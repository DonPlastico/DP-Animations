import { fetchNUI } from "./fetch.js";

export const changeClass = target => {
  const allSidebarButtons = document.querySelectorAll(".menu-container .sidebar");
  allSidebarButtons.forEach((btn) => {
    btn.style.color = "white";
    btn.classList.remove("pop");
  });
  for (let i = 0; i < allSidebarButtons.length; i++) {
    allSidebarButtons[i].classList.remove('active');
  }
  target.classList.add('active');

  target.classList.add('pop');
  setTimeout(() => {
    target.classList.remove('pop');
  }, 500);

  const mainContainer = document.querySelector(".compact-ui");
  const animsContainer = document.getElementById("anims-holder");
  const settingsContainer = document.querySelector(".settings-container");
  const controlsContainer = document.querySelector(".controls-container");

  const existingPlaceholder = animsContainer.querySelector(".placeholder-container");
  if (existingPlaceholder) {
    animsContainer.removeChild(existingPlaceholder);
  }

  let currentSettingsStatus = JSON.parse(localStorage.getItem('settingsPanelLastState')) || false;

  if (target.id === "settings") {
    if (!currentSettingsStatus) {
      settingsContainer.style.display = "flex";
      settingsContainer.classList.add("fadeIn");
      currentSettingsStatus = true;
    } else {
      settingsContainer.classList.add("fadeOut");
      setTimeout(() => {
        settingsContainer.style.display = "none";
        settingsContainer.classList.remove("fadeOut");
      }, 300);
      currentSettingsStatus = false;
    }
    localStorage.setItem('settingsPanelLastState', JSON.stringify(currentSettingsStatus));
    animsContainer.style.display = 'none'; // Ocultar animaciones cuando los ajustes están abiertos
  } else {
    // Si no es la pestaña de ajustes, asegúrate de que el contenedor de animaciones sea visible
    animsContainer.style.display = 'grid'; // O 'block' o 'flex' según tu CSS
    // Ocultar el contenedor de ajustes si estaba visible
    if (currentSettingsStatus) {
      settingsContainer.classList.add("fadeOut");
      setTimeout(() => {
        settingsContainer.style.display = "none";
        settingsContainer.classList.remove("fadeOut");
      }, 300);
      localStorage.setItem('settingsPanelLastState', JSON.stringify(false));
    }

    // Disparar un evento personalizado cuando se cambia la categoría
    const categoryChangeEvent = new CustomEvent('categoryChange', {
      detail: {
        categoryId: target.id
      }
    });
    window.dispatchEvent(categoryChangeEvent);
  }
};

export const getStatus = (elem) => {
  let savedOpts = JSON.parse(localStorage.getItem('animOptions')) || [];
  if (savedOpts.includes(elem.id)) {
    const index = savedOpts.indexOf(elem.id);
    if (index > -1) {
      savedOpts.splice(index, 1);
      fetchNUI('changeCfg', { type: elem.id, state: true });
      localStorage.setItem('animOptions', JSON.stringify(savedOpts));
      elem.classList.remove('active');
      return false;
    }
  }

  savedOpts.push(elem.id);
  fetchNUI('changeCfg', { type: elem.id, state: false });
  localStorage.setItem('animOptions', JSON.stringify(savedOpts));
  elem.classList.add('active');
  return true;
}

export const setDisplay = (animType, showSettingsPanel = false) => {
  const mainContainer = document.querySelector('.compact-ui');
  const settingsContainer = document.querySelector('.settings-container');
  const controlsContainer = document.querySelector('.controls-container');

  if (animType == 'fadeIn') {
    mainContainer.style.display = 'flex';
    controlsContainer.style.display = 'flex';
    mainContainer.classList.add(animType);
    controlsContainer.classList.add(animType);

    if (showSettingsPanel) {
      settingsContainer.style.display = 'flex';
      settingsContainer.classList.add(animType);
    }
  } else if (animType == 'fadeOut') {
    mainContainer.classList.add(animType);
    settingsContainer.classList.add(animType);
    controlsContainer.classList.add(animType);
  }

  setTimeout(() => {
    if (animType != 'fadeIn') {
      mainContainer.style.display = 'none';
      settingsContainer.style.display = 'none';
      controlsContainer.style.display = 'none';
    }
    mainContainer.classList.remove(animType);
    settingsContainer.classList.remove(animType);
    controlsContainer.classList.remove(animType);
  }, 300);
}
