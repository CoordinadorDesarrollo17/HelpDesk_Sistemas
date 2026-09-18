// Please see documentation at https://learn.microsoft.com/aspnet/core/client-side/bundling-and-minification
// for details on configuring this project to bundle and minify static web assets.

// Write your JavaScript code.

document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("sidebar");
    const backdrop = document.getElementById("sidebarBackdrop");
    const toggleBtn = document.getElementById("btnToggleSidebar");

    if (!sidebar || !backdrop || !toggleBtn) return;

    function abrirSidebar() {
        sidebar.classList.add("show");
        backdrop.classList.add("show");
    }

    function cerrarSidebar() {
        sidebar.classList.remove("show");
        backdrop.classList.remove("show");
    }

    toggleBtn.addEventListener("click", abrirSidebar);
    backdrop.addEventListener("click", cerrarSidebar);
});

// ============================================================
// SIDEBAR COLAPSADO ESCRITORIO
// ============================================================

document.addEventListener("DOMContentLoaded", function () {
    const btnColapsar = document.getElementById("btnColapsarSidebar");
    if (!btnColapsar) return;

    btnColapsar.addEventListener("click", function () {
        const colapsado = document.documentElement.getAttribute("data-sidebar") === "colapsado";
        if (colapsado) {
            document.documentElement.removeAttribute("data-sidebar");
            localStorage.setItem("sidebarColapsado", "false");
        } else {
            document.documentElement.setAttribute("data-sidebar", "colapsado");
            localStorage.setItem("sidebarColapsado", "true");
        }
    });
});

// ============================================================
// MODO OSCURO
// ============================================================

document.addEventListener("DOMContentLoaded", function () {
    const btnToggleTema = document.getElementById("btnToggleTema");
    const iconoTema = document.getElementById("iconoTema");

    function actualizarIcono(tema) {
        if (!iconoTema) return;
        iconoTema.className = tema === "dark" ? "bi bi-sun" : "bi bi-moon-stars";
    }

    actualizarIcono(document.documentElement.getAttribute("data-bs-theme"));

    if (!btnToggleTema) return;

    btnToggleTema.addEventListener("click", function () {
        const actual = document.documentElement.getAttribute("data-bs-theme") === "dark" ? "dark" : "light";
        const nuevo = actual === "dark" ? "light" : "dark";

        document.documentElement.setAttribute("data-bs-theme", nuevo);
        localStorage.setItem("tema", nuevo);
        actualizarIcono(nuevo);
    });
});
