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
