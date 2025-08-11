<p align="center">
<h1 align="center">Sistema de Animaciones para FiveM (QBCore)</h1>

<img width="960" height="auto" align="center" alt="DP-Animations Logo" src="Images (Can Remove it if u want)/IMAGE.png" />

</p>

<div align="center">

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Script-important)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/QBCore-Framework-success)](<[https://qbcore-framework.github.io/qb-docs/](https://github.com/qbcore-framework)>)

</div>

<h2 align="center"> 📝 Descripción General</h2>
DP-Animaciones es un sistema avanzado de "ANIMACIONES" diseñado para servidores de FiveM que utilizan el framework QBCore. Este script permite a los jugadores acceder y usar una gran variedad de animaciones a través de comandos y una interfaz NUI.

<details>
<summary><h2 align="center">¿Qué es y qué hace?</h2></summary>
- Permite a los jugadores ejecutar animaciones personalizadas.<br>
- Incluye un sistema de sincronización para animaciones entre jugadores.<br>
- Gestión de animaciones a través de una base de datos.<br>

</details>
<details>
<summary><h2 align="center">¿Cómo funciona?</h2></summary>
- Usa la interfaz NUI para mostrar un menú de animaciones.<br>
- Sincroniza las animaciones entre jugadores cercanos a través de eventos de servidor.<br>
- Las animaciones se pueden agregar fácilmente a través del archivo de configuración anims.json.<br>

</details>
<details>
<summary><h2 align="center">¿Qué te permite?</h2></summary>
✅ Acceso a una lista de animaciones personalizables.<br>
✅ Interfaz de usuario NUI para una mejor experiencia.<br>
✅ Sincronización de animaciones entre jugadores.<br>
✅ Persistencia de datos mediante Insert.sql y anims.json.<br>
✅ Configuración flexible de comandos y animaciones.<br>
✅ Notificaciones personalizables.<br>
✅ Guardar animaciones como favoritas.<br>

</details>
<br><br>
<h2 align="center"> 🚀 Instalación</h2>

<details>
<summary><h2 align="center">Requisitos previos</h2></summary>
- Servidor FiveM con QBCore instalado.<br>
- MySQL configurado (oxmysql).<br>

</details>
<details>
<summary><h2 align="center">Pasos de instalación</h2></summary>
1. **Descargar el script** desde el repositorio oficial.<br>
2. **Colocar la carpeta** en tu servidor con el nombre exacto `DP-Animations`.<br>
   - ⚠️ El nombre debe ser exactamente este para evitar problemas.<br>
3. **Configuración de la Base de Datos**.<br>
Abre el archivo Insert.sql.<br>
Copia y pega el contenido en tu base de datos MySQL y ejecútalo para crear la tabla de animaciones.
(Asegúrate de que tu servidor tenga acceso a la base de datos configurada para oxmysql.).<br>

</details>
<br><br>
<h2 align="center"> ⚙️ Dependencias</h2>
El script requiere las siguientes dependencias (deben estar instaladas y configuradas):
<details>
<summary><h2 align="center"> 📦 Requisitos del Sistema</h2></summary>

| Recurso                                                                          | Descripción                   | Enlace                                                    |
| -------------------------------------------------------------------------------- | ----------------------------- | --------------------------------------------------------- |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=Q" alt="QB"> qb-core     | Framework principal           | [🔗 GitHub](https://github.com/qbcore-framework/qb-core)  |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=O" alt="OX"> oxmysql     | Conexión MySQL avanzada       | [🔗 GitHub](https://github.com/overextended/oxmysql)      |

<div style="margin-top: 15px; background-color: #f8f9fa; padding: 10px; border-radius: 5px; border-left: 4px solid #6c757d;">
<strong> 💡 Nota:</strong> Todos los recursos deben estar en el <code>server.cfg</code> y cargarse antes de DP-Animations.
</div>

</details>
<details>
<summary><h2 align="center">Orden recomendado en server.cfg</h2></summary>
```cfg.<br>
   ensure oxmysql<br>
   ensure qb-core<br>
   ensure DP-Animaciones<br>
  
</details>
<div class="alert alert-warning" style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 10px; margin: 15px 0; border-radius: 5px;">
 <strong> ⚠️ Nota importante:</strong>
   El script utiliza eventos del servidor para la sincronización de animaciones. Asegúrate de que ningún otro script entre en conflicto con los eventos definidos.
</div>

</details>
<br><br>
<h2 align="center"> 📂 Estructura de Archivos</h2>

<details>
<summary><h2 align="center"> 🖥️ Mostrar estructura completa y descripción</h2></summary>

DP-Animations/<br>
├── fxmanifest.lua<br>
├── anims.json<br>
├── cfg.lua<br>
├── cfg.lua<br>
├── Insert.sql<br>
├── README.md<br>
├── stream/<br>
│     └── Todos sus archivos de animaciones y props<br>
├── client/<br>
│     ├── functions.lua<br>
│     └── nui.lua<br>
│     └── request.lua<br>
├── html/<br>
│     ├── css/<br>
│     │    └── style.css<br>
│     ├── js/<br>
│     │    ├── modules/<br>
│     │    │     ├── fetch.js<br>
│     │    │     └── functions.js<br>
│     │    ├── listeners.js<br>
│     │    └── script.js<br>
│     └── ui.html<br>
└── server/<br>
    └── syncing.lua<br>

</div>

| Archivo                    | Función Principal                   | Dependencias      |
| -------------------------- | ----------------------------------- | ----------------- |
| **fxmanifest.lua**         | Configuración principal del recurso | qb-core, oxmysql |
| **clients/functions.lua**  | Funciones del lado del cliente para animaciones | qb-core |
| **clients/nui.lua**        | Lógica de la interfaz NUI del cliente | - |
| **clients/request.lua**    | Lógica para solicitar animaciones y datos | - |
| **servers/syncing.lua**    | Lógica del servidor para sincronizar animaciones | qb-core |
| **anims.json**             | Archivo de configuración de animaciones | - |
| **cfg.lua**                | Configuración principal del script | - |
| **Insert.sql**             | Archivo SQL para la configuración inicial de la DB | - |

> ** 💡 Datos Técnicos:** La estructura está optimizada para consumo mínimo de recursos (0.01ms) y máxima compatibilidad con QBCore.

</details>
<br><br>
<h2 align="center">🛠️ Configuración (cfg.lua y anims.json)</h2>
Los archivos cfg.lua y anims.json te permiten personalizar el script según tus necesidades.

<details>
<summary><h2 align="center">⚙️ Mostrar configuración</h2></summary>

<h3>anims.json</h3>
<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/anims.png" />

<h3>cfg.lua</h3>
<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/cfg.png" />

| Archivo           | Función Principal                                                                                                                                                                                                                           |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **cfg.lua**   | Define las configuraciones principales del script, como los permisos, los comandos y las notificaciones. |
| **anims.json**      | Contiene todos los datos de las animaciones, sus nombres, diccionarios y banderas. Puedes editar este archivo para añadir, modificar o eliminar animaciones.                                                                                                                    |

</details>
<br><br>
<h2 align="center"> 🎮 Comandos</h2>
Aquí tienes una lista de los comandos disponibles en DP-Animaciones.

<details>
<summary><h2 align="center"> 👤 Jugadores</h2></summary>

| Comando   | Descripción              |
| --------- | ------------------------ |
| **/animaciones** | Menú de gestión de peds. |
| **/e** | Reproducir una animación por comando. |

</details>
<br><br>
<h2 align="center"> 🖼️ Vistas Previas</h2>
Aquí tienes una lista de las vistas previas de tu script.

<details>
<p align="center">
<summary><h2 align="center">Interfaz de Usuario NUI</h2></summary>

<img width="277" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/dances.png" />

<img width="277" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/scenes.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Favoritas + SQL</h2></summary>

<img width="277" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/favorites.png" />

<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/localhost.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Ajustes</h2></summary>

<img width="277" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/ajustes.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Video Demostrativo</h2></summary>

<a href="https://youtu.be/o8tCNLDl1ZA">
<img width="959" height="auto" alt="Video Demostrativo" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://img.youtube.com/vi/o8tCNLDl1ZA/maxresdefault.jpg" />
</a>

</p>
</details>
<br><br>
<h2 align="center"> 🔮 Posibles Mejoras Futuras</h2>
El DP-Animations es un script robusto, pero siempre hay espacio para mejoras y nuevas funcionalidades. Aquí hay algunas ideas que es muy probable que en futuro no muy lejano, yo mismo las realice y os actualice el script con las nuevas funciones.

<details>
<summary><h2 align="center">🚧 En desarrollo</h2></summary>

| IDEA                               | EXPLICACIÓN                                                                                                                                                                                                                  |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tienda de animaciónes**          | Integrar un sistema donde los jugadores puedan comprar nuevas animaciones con dinero. (Items/Moneda Custom/Moneda como cash-bank-black_money-crypto/Moneda real a traves de patreon/vips/donativos/paypal ETC...)            |
| **Eventos personalizados**         | Añadir eventos que permitan a otros scripts interactuar con el sistema de peds (ej. un script de trabajo que asigne automáticamente una ped de trabajo al iniciar sesión).                                                   |
| **Soporte multi-framework**        | Aunque actualmente está centrado en QBCore, se podría considerar la compatibilidad con otros frameworks como ESX. (En proceso. Pronto actualización con frameworks de QBCORE / ESX / OLD QBCORE / OLD ESX / VRP / QBOX / OX) |

</details>

Autor: DP-Scripts<br>
Versión: 1.0.0
