function initializeDialog(dialogId, openButtonId, closeButtonIds) {
    const dialog = document.getElementById(dialogId);
    const openBtn = document.getElementById(openButtonId);

    if (!dialog || !openBtn) return;

    openBtn.addEventListener('click', function () {
        dialog.showModal();
    });

    closeButtonIds.forEach(buttonId => {
        const closeBtn = document.getElementById(buttonId);
        if (closeBtn && dialog) {
            closeBtn.addEventListener('click', function () {
                dialog.close();
            });
        }
    });
}

document.addEventListener('DOMContentLoaded', function () {
    // Initialiser les dialogues selon la page
    const renameDialog = document.getElementById('renameModal');
    const statusDialog = document.getElementById('statusModal');

    if (renameDialog) {
        initializeDialog('renameModal', 'renameBtn', ['cancelRenameBtn']);
    }

    if (statusDialog) {
        initializeDialog('statusModal', 'statusBtn', ['closeStatusModal', 'cancelStatusBtn']);
    }

    // Remplacer les icônes Feather
    if (typeof feather !== 'undefined') {
        feather.replace();
    }
});

