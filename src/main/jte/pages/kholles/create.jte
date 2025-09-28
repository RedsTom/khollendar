@import java.time.format.DateTimeFormatter

@param String title
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = title,
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">${title}</h1>
            <p class="text-ctp-subtext0">Remplissez le formulaire ci-dessous pour créer une nouvelle session de khôlles.</p>
        </div>

        @template.components.Card(
            content = @`
                <form action="/kholles/create" method="post" class="max-w-3xl">
                    @template.components.FormField(
                        id = "subject",
                        name = "subject",
                        label = "Matière / Sujet",
                        placeholder = "Ex: Mathématiques - Intégrales",
                        required = true
                    )

                    <div class="mb-6">
                        <h3 class="text-lg font-medium mb-4">Créneaux horaires</h3>
                        <div id="slots-container" class="space-y-4">
                            <div class="slot-input flex flex-col sm:flex-row gap-4">
                                <div class="flex-1">
                                    <label class="block text-sm font-medium mb-2">Date et heure</label>
                                    <input type="datetime-local" name="slots[0].time" required
                                           class="w-full p-2 bg-ctp-base border border-ctp-surface1 rounded-md text-ctp-text focus:outline-none focus:border-ctp-blue">
                                </div>
                                <div class="flex items-end">
                                    @template.components.Button(
                                        type = "button",
                                        variant = "danger",
                                        size = "sm",
                                        onclick = "deleteSlot(this)",
                                        extraClasses = "delete-slot",
                                        content = @`<i data-feather="trash-2"></i>`
                                    )
                                </div>
                            </div>
                        </div>

                        @template.components.Button(
                            type = "button",
                            variant = "success",
                            extraClasses = "mt-4",
                            onclick = "addSlot()",
                            content = @`
                                <i data-feather="plus" class="mr-2"></i>
                                Ajouter un créneau
                            `
                        )
                    </div>

                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                    <div class="flex justify-end">
                        @template.components.Button(
                            type = "submit",
                            variant = "primary",
                            size = "lg",
                            content = @`Créer la session`
                        )
                    </div>
                </form>
            `
        )
    </div>

    @raw
    <script>
        let slotCount = 1;

        function addSlot() {
            const container = document.getElementById('slots-container');
            const newSlot = document.createElement('div');
            newSlot.className = 'slot-input flex flex-col sm:flex-row gap-4';

            newSlot.innerHTML = `
                <div class="flex-1">
                    <label class="block text-sm font-medium mb-2">Date et heure</label>
                    <input type="datetime-local" name="slots[${slotCount}].time" required
                           class="w-full p-2 bg-ctp-base border border-ctp-surface1 rounded-md text-ctp-text focus:outline-none focus:border-ctp-blue">
                </div>
                <div class="flex items-end">
                    <button type="button" class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base bg-ctp-red hover:bg-ctp-red/80 text-ctp-base px-3 py-1.5 text-sm delete-slot" onclick="deleteSlot(this)">
                        <i data-feather="trash-2"></i>
                    </button>
                </div>
            `;

            container.appendChild(newSlot);
            slotCount++;
            feather.replace();
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
            });
            slotCount = slots.length;
        }
    </script>
    @endraw
`
)
