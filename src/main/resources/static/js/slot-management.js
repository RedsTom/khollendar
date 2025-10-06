let slotCount = 0;

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
                    class="delete-slot button danger">
                <i class="feather-icon icon-trash-2"></i>
            </button>
        </div>
    `;

    const el = container.appendChild(newSlot);
    slotCount++;

    if(slotCount > 1) {
        el.querySelector('input').focus();
    }

    if (typeof feather !== 'undefined') {
        feather.replace();
    }

    // Ajouter les event listeners pour les raccourcis clavier
    const input = el.querySelector('input[type="datetime-local"]');
    attachKeyboardShortcuts(input);

    return el;
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

function attachKeyboardShortcuts(input) {
    input.addEventListener('keydown', function(e) {
        // Shift+Enter : Créer un nouveau créneau et le focus
        if (e.key === 'Enter' && e.shiftKey) {
            e.preventDefault();
            addSlot();
            return;
        }

        // Ctrl+Enter : Soumettre le formulaire avec validation
        if (e.key === 'Enter' && e.ctrlKey) {
            e.preventDefault();
            const form = input.closest('form');
            if (form) {
                // Utiliser requestSubmit() au lieu de submit() pour déclencher la validation HTML5
                if (form.requestSubmit) {
                    form.requestSubmit();
                } else {
                    // Fallback pour les navigateurs plus anciens
                    if (form.checkValidity()) {
                        form.submit();
                    } else {
                        form.reportValidity();
                    }
                }
            }
            return;
        }

        // Enter seul : Passer au champ suivant
        if (e.key === 'Enter' && !e.shiftKey && !e.ctrlKey) {
            e.preventDefault();
            const allInputs = Array.from(document.querySelectorAll('#slots-container input[type="datetime-local"]'));
            const currentIndex = allInputs.indexOf(input);

            if (currentIndex < allInputs.length - 1) {
                // Passer au prochain input
                allInputs[currentIndex + 1].focus();
            } else {
                // Si c'est le dernier, créer un nouveau créneau
                addSlot();
            }
        }
    });
}

// Initialiser avec un créneau par défaut
addSlot();