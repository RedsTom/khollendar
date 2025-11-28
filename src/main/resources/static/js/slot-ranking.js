htmx.onLoad((content) => {
    const slotRankingList = content.querySelector("#slot-ranking");
    if(!slotRankingList) return;

    // Détecter si l'appareil est tactile
    const isTouchDevice = ('ontouchstart' in window) ||
                         (navigator.maxTouchPoints > 0) ||
                         (navigator.msMaxTouchPoints > 0);

    // Configuration de base pour SortableJS
    const sortableConfig = {
        animation: 150,
        ghostClass: 'sortable-ghost',
        dragClass: 'sortable-drag',
        // Désactiver le handle sur mobile pour permettre le drag sur toute la carte
        handle: isTouchDevice ? null : '.drag-handle',
        // Options pour améliorer le support tactile
        forceFallback: true,
        fallbackTolerance: 3,
        touchStartThreshold: 5,
        // Empêcher la sélection de texte pendant le drag
        preventOnFilter: false,
        onStart: function (evt) {
            // Ajouter une classe pour le feedback visuel
            evt.item.classList.add('dragging');
        },
        onEnd: function (evt) {
            // Retirer la classe de feedback
            evt.item.classList.remove('dragging');

            const slotItems = document.querySelectorAll('#slot-ranking .slot-item');

            const oldRanks = new Map();
            slotItems.forEach((item, idx) => {
                const rankEl = item.querySelector('.rank-number');
                oldRanks.set(item, rankEl ? Number(rankEl.textContent) : undefined);
                if (rankEl) rankEl.textContent = idx + 1;
            });

            slotItems.forEach((item, idx) => {
                const oldRank = oldRanks.get(item);
                const newRank = idx + 1;
                if (oldRank !== undefined && oldRank !== newRank) {
                    const rankEl = item.querySelector('.rank-number');
                    if (!rankEl) {
                        return;
                    }

                    rankEl.animate([
                        {
                            transform: 'scale(1.15)',
                        },
                        {
                            transform: 'scale(1)',
                        }
                    ], {
                        duration: 400,
                        easing: 'cubic-bezier(.33,1,.68,1)',
                    })
                }
            });
        }
    };

    const sortableInstance = Sortable.create(slotRankingList, sortableConfig);

    // Activer les boutons de navigation une fois que le drag-and-drop est initialisé
    const submitButton = document.querySelector('button[form="rankingForm"]');
    const backButton = document.querySelector('button[hx-post*="/previous"]');

    if (submitButton) submitButton.disabled = false;
    if (backButton) backButton.disabled = false;
})