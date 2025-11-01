htmx.onLoad((content) => {
    console.log("Initializing dragging");

    const rankingFormElements = content.querySelectorAll("#rankingForm > *");
    if(rankingFormElements.length === 0) return;

    rankingFormElements.forEach((element, index) => {
        const sortableInstance = Sortable.create(element, {
            ghostClass: 'sortable-ghost',
            dragClass: 'sortable-drag',
            handle: '.drag-handle',
            onStart: function (evt) {

            },
            onEnd: function (evt) {
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
        })
    });
})