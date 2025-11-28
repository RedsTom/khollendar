(function () {
    console.log("Slot ranking script loaded");

    function updateRanks() {
        const slotRankingList = document.getElementById("slot-ranking");
        if (!slotRankingList) return;

        const slotItems = slotRankingList.querySelectorAll('.slot-item');
        slotItems.forEach((item, idx) => {
            const rankEl = item.querySelector('.rank-number');
            if (rankEl) rankEl.textContent = idx + 1;

            // Update button states
            const upBtn = item.querySelector('.move-up-btn');
            const downBtn = item.querySelector('.move-down-btn');

            if (upBtn) {
                const isFirst = idx === 0;
                upBtn.disabled = isFirst;
                upBtn.style.opacity = isFirst ? '0.3' : '1';
                upBtn.style.cursor = isFirst ? 'not-allowed' : 'pointer';
            }
            if (downBtn) {
                const isLast = idx === slotItems.length - 1;
                downBtn.disabled = isLast;
                downBtn.style.opacity = isLast ? '0.3' : '1';
                downBtn.style.cursor = isLast ? 'not-allowed' : 'pointer';
            }
        });

        // Enable navigation buttons
        const submitButton = document.querySelector('button[form="rankingForm"]');
        const backButton = document.querySelector('button[hx-post*="/previous"]');

        if (submitButton) submitButton.disabled = false;
        if (backButton) backButton.disabled = false;
    }

    function animateSwap(item, sibling) {
        // 1. First: Get starting positions
        const itemRect = item.getBoundingClientRect();
        const siblingRect = sibling.getBoundingClientRect();

        // 2. State Change: Swap in DOM
        // (This is done by the caller, but we need to know the direction to apply transforms correctly)
        // Actually, let's do the swap inside this function to control the timing perfectly.
        // But the caller logic is slightly different for up/down.
        // Let's just return the rects and let the caller swap, then we call a 'play' function.
    }

    // Global click listener for delegation
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('button');
        if (!btn) return;

        if (btn.classList.contains('move-up-btn')) {
            e.preventDefault();
            const item = btn.closest('.slot-item');
            if (!item) return;

            const prev = item.previousElementSibling;
            if (prev) {
                // FLIP Animation
                const itemFirst = item.getBoundingClientRect().top;
                const prevFirst = prev.getBoundingClientRect().top;

                item.parentNode.insertBefore(item, prev);

                const itemLast = item.getBoundingClientRect().top;
                const prevLast = prev.getBoundingClientRect().top;

                const itemDelta = itemFirst - itemLast;
                const prevDelta = prevFirst - prevLast;

                item.animate([
                    { transform: `translateY(${itemDelta}px)` },
                    { transform: 'translateY(0)' }
                ], { duration: 300, easing: 'ease-out' });

                prev.animate([
                    { transform: `translateY(${prevDelta}px)` },
                    { transform: 'translateY(0)' }
                ], { duration: 300, easing: 'ease-out' });

                updateRanks();
            }
        } else if (btn.classList.contains('move-down-btn')) {
            e.preventDefault();
            const item = btn.closest('.slot-item');
            if (!item) return;

            const next = item.nextElementSibling;
            if (next) {
                // FLIP Animation
                const itemFirst = item.getBoundingClientRect().top;
                const nextFirst = next.getBoundingClientRect().top;

                item.parentNode.insertBefore(next, item);

                const itemLast = item.getBoundingClientRect().top;
                const nextLast = next.getBoundingClientRect().top;

                const itemDelta = itemFirst - itemLast;
                const nextDelta = nextFirst - nextLast;

                item.animate([
                    { transform: `translateY(${itemDelta}px)` },
                    { transform: 'translateY(0)' }
                ], { duration: 300, easing: 'ease-out' });

                next.animate([
                    { transform: `translateY(${nextDelta}px)` },
                    { transform: 'translateY(0)' }
                ], { duration: 300, easing: 'ease-out' });

                updateRanks();
            }
        }
    });

    // Initialize on load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', updateRanks);
    } else {
        updateRanks();
    }

    // Re-initialize on HTMX swaps
    if (typeof htmx !== 'undefined') {
        htmx.onLoad(function (content) {
            updateRanks();
        });
    }
})();