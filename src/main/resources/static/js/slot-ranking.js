let isAnimating = false;

function initializeSlotRanking() {
    const slotRanking = document.getElementById('slot-ranking');
    if (!slotRanking) return;

    attachEventListeners();
    updateButtonStates();
}

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

document.addEventListener('DOMContentLoaded', function () {
    if (typeof feather !== 'undefined') {
        feather.replace();
    }
    initializeSlotRanking();
});
let slotCount = 1;

function addSlot() {
    const container = document.getElementById('slots-container');
    const newSlot = document.createElement('div');
    newSlot.className = 'slot-input';

    newSlot.innerHTML = `
        <label for="slot-${slotCount}-time">Date et heure</label>
        <div class="flex gap-4">
            <input type="datetime-local" id="slot-${slotCount}-time" name="slots[${slotCount}].time" required class="flex-1">
            <button type="button" 
                    onclick="deleteSlot(this)"
                    class="delete-slot inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-red focus:ring-offset-2 focus:ring-offset-ctp-base px-2 py-2 sm:px-3 sm:py-2 text-xs sm:text-sm bg-ctp-red hover:bg-ctp-red/80 text-ctp-base border-0">
                <i data-feather="trash-2"></i>
            </button>
        </div>
    `;

    container.appendChild(newSlot);
    slotCount++;
    if (typeof feather !== 'undefined') {
        feather.replace();
    }
}

function deleteSlot(button) {
    const slotElement = button.closest('.slot-input');
    if (document.querySelectorAll('.slot-input').length > 1) {
        slotElement.remove();
        renumberSlots();
    } else {
        alert('Vous devez avoir au moins un créneau.');
    }
}

function renumberSlots() {
    const slots = document.querySelectorAll('.slot-input');
    slots.forEach((slot, index) => {
        const input = slot.querySelector('input[type="datetime-local"]');
        input.name = `slots[${index}].time`;
        input.id = `slot-${index}-time`;
        const label = slot.querySelector('label');
        if (label) {
            label.setAttribute('for', `slot-${index}-time`);
        }
    });
    slotCount = slots.length;
}

