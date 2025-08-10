import { changeClass, getStatus } from "./modules/functions.js";
import { fetchNUI } from "./modules/fetch.js";

const doc = document;

doc.getElementById("dances").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("shared").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("walks").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("expressions").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("scenarios").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("props").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("adult").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("weapon").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("pet").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("favorites").addEventListener("click", (e) => changeClass(e.target));
doc.getElementById("settings").addEventListener("click", (e) => changeClass(e.target));

doc.addEventListener("keyup", (e) => {
    if (e.key == "Escape") {
        fetchNUI("exitPanel");
    }
});

doc.getElementById("search-bar").addEventListener("input", (e) => {
    let input = e.target.value.toUpperCase();
    const panels = doc.getElementsByClassName("anim");
    for (let i = 0; i < panels.length; i++) {
        let text = panels[i].getElementsByTagName("div")[0].firstChild;
        let val = text.textContent || text.innerText;
        if (val.toUpperCase().indexOf(input) > -1) {
            panels[i].style.display = "";
        } else {
            text = panels[i].getElementsByTagName("div")[0].lastChild;
            val = text.textContent || text.innerText;
            if (val.toUpperCase().indexOf(input) > -1) {
                panels[i].style.display = "";
            } else {
                panels[i].style.display = "none";
            }
        }
    }
});

['cancel', 'delete'].forEach(id => {
    document.getElementById(id).addEventListener('click', e => {
        e.target.classList.add('pop');
        setTimeout(() => {
            e.target.classList.remove('pop');
        }, 300);

        if (id === 'cancel') {
            fetchNUI('cancelAnimation');
        } else if (id === 'delete') {
            fetchNUI('removeProps');
        }
    });
});

['movement', 'loop'].forEach(id => {
    document.getElementById(id).addEventListener('click', e => {
        e.target.classList.toggle('active');
        e.target.classList.add('pop');
        setTimeout(() => {
            e.target.classList.remove('pop');
        }, 300);

        getStatus(e.target);
    });
});

document.addEventListener('DOMContentLoaded', () => {
    const savedOpts = JSON.parse(localStorage.getItem('animOptions')) || [];
    savedOpts.forEach(opt => {
        if (['movement', 'loop'].includes(opt)) {
            const elem = document.getElementById(opt);
            if (elem) elem.classList.add('active');
        }
    });
});

doc.getElementById("save-settings").addEventListener("click", () => {
    const duration = doc.getElementById("set-duration");
    const cancel = doc.getElementById("set-cancel");

    if (duration.value) {
        localStorage.setItem("currentDuration", duration.value);
        duration.placeholder = duration.value;
    }

    if (cancel.value) {
        localStorage.setItem("currentCancel", cancel.value);
        cancel.placeholder = cancel.value;
    }
    fetchNUI("changeCfg", {
        type: "settings",
        duration: duration.value,
        cancel: cancel.value,
    });

    duration.value = "";
    cancel.value = "";
});

doc.getElementById("reset-duration").addEventListener("click", (_) => {
    localStorage.setItem("currentDuration", 1500);
    doc.getElementById("set-duration").placeholder = 1500;
    fetchNUI("changeCfg", { type: "settings", duration: 1500 });
});

doc.getElementById("reset-cancel").addEventListener("click", (_) => {
    localStorage.setItem("currentCancel", 73);
    doc.getElementById("set-cancel").placeholder = 73;
    fetchNUI("changeCfg", { type: "settings", cancel: 73 });
});
