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
    initializeDialog('rename-modal', 'rename-btn', ['cancel-rename']);
    initializeDialog('status-modal', 'status-btn', ['cancel-status']);
});

