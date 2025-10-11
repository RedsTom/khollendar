if(typeof isAnimating === 'undefined') var isAnimating;

isAnimating = false;

function attachEventListeners() {
    const slotRanking = document.getElementById('slot-ranking');
    slotRanking.addEventListener('click', function (event) {
        const button = event.target.closest('button');
        if (!button) return;
        if (button.classList.contains('disabled')) return;
        if (isAnimating) return;

        if (button.classList.contains('move-up')) {
            const slotItem = button.closest('.slot-item');
            const prevItem = slotItem?.previousElementSibling;
            if (!prevItem) return;
            animateReorder(() => {
                slotRanking.insertBefore(slotItem, prevItem);
            });
        } else if (button.classList.contains('move-down')) {
            const slotItem = button.closest('.slot-item');
            const nextItem = slotItem?.nextElementSibling;
            if (!nextItem) return;
            animateReorder(() => {
                slotRanking.insertBefore(nextItem, slotItem);
            });
        }
    });
}

function animateReorder(doReorder) {
    const slotRanking = document.getElementById('slot-ranking');
    if (!slotRanking || isAnimating) return;

    isAnimating = true;
    slotRanking.style.pointerEvents = 'none';

    const itemsBefore = Array.from(slotRanking.children);
    const oldRanks = new Map(itemsBefore.map((item, idx) => [item, idx + 1]));
    const firstRects = new Map(itemsBefore.map(item => [item, item.getBoundingClientRect()]));

    doReorder();
    updateAfterMove();

    const itemsAfter = Array.from(slotRanking.children);

    itemsAfter.forEach(item => {
        const first = firstRects.get(item);
        if (!first) return;
        const last = item.getBoundingClientRect();
        const deltaY = first.top - last.top;
        if (deltaY !== 0) {
            item.style.transform = `translateY(${deltaY}px)`;
            item.style.transition = 'transform 0s';
            requestAnimationFrame(() => {
                item.style.transition = 'transform 380ms cubic-bezier(.33,1,.68,1)';
                item.style.transform = '';
            });
        }
    });

    itemsAfter.forEach((item, idx) => {
        const oldRank = oldRanks.get(item);
        const newRank = idx + 1;
        if (oldRank !== undefined && oldRank !== newRank) {
            const rankEl = item.querySelector('.rank-number');
            if (rankEl) {
                rankEl.classList.remove('rank-changed');
                void rankEl.offsetWidth;
                rankEl.classList.add('rank-changed');
            }
        }
    });

    setTimeout(() => {
        isAnimating = false;
        slotRanking.style.pointerEvents = '';
    }, 420);
}

function updateAfterMove() {
    updateRankNumbers();
    updateButtonStates();
}

function updateRankNumbers() {
    const slotItems = document.querySelectorAll('#slot-ranking .slot-item');
    slotItems.forEach((item, idx) => {
        const rankEl = item.querySelector('.rank-number');
        if (rankEl) rankEl.textContent = idx + 1;
    });
}

function updateButtonStates() {
    const items = document.querySelectorAll('#slot-ranking .slot-item');
    const total = items.length;
    items.forEach((item, idx) => {
        const upBtn = item.querySelector('.move-up');
        const downBtn = item.querySelector('.move-down');
        styleButton(upBtn, false);
        styleButton(downBtn, false);
        if (idx === 0) styleButton(upBtn, true);
        if (idx === total - 1) styleButton(downBtn, true);
    });
}

function styleButton(btn, disabled) {
    if (!btn) return;
    btn.classList.toggle('disabled', disabled);
    btn.classList.toggle('opacity-50', disabled);
    btn.classList.toggle('cursor-not-allowed', disabled);

    if (disabled) {
        btn.classList.remove('hover:bg-ctp-surface2');
        btn.setAttribute('tabindex', '-1');
        btn.setAttribute('aria-disabled', 'true');
    } else {
        btn.classList.add('hover:bg-ctp-surface2');
        btn.removeAttribute('tabindex');
        btn.removeAttribute('aria-disabled');
    }

    const icon = btn.querySelector('i');
    if (icon) {
        icon.classList.toggle('text-ctp-overlay0', disabled);
        icon.classList.toggle('text-ctp-text', !disabled);
    }
}

console.log("Initializing slot ranking...");

if(typeof slotRanking === "undefined") var slotRanking;
slotRanking = document.getElementById('slot-ranking');

if (slotRanking) {
    attachEventListeners();
    updateButtonStates();
}