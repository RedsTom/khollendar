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
            <p class="text-ctp-subtext0">Remplissez le formulaire ci-dessous pour créer une nouvelle session de
                khôlles.</p>
        </div>

        @template.components.Card(
        content = @`
            <form action="/kholles/create" method="post" class="max-w-3xl">
                <div class="form-field">
                    <label for="subject">Matière / Sujet</label>
                    <input type="text" id="subject" name="subject" placeholder="Ex: Mathématiques - Intégrales" required>
                </div>

                <div class="mb-6">
                    <h3 class="text-lg font-medium mb-4">Créneaux horaires</h3>
                    <div id="slots-container" class="space-y-4">
                        <div class="slot-input">
                            <label for="slot-0-time">Date et heure</label>
                            <div class="flex gap-4">
                                <input type="datetime-local" id="slot-0-time" name="slots[0].time" required class="flex-1">
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
            const container   = document.getElementById('slots-container');
            const newSlot     = document.createElement('div');
            newSlot.className = 'slot-input';

            newSlot.innerHTML = `
                <div class="slot-input">
                    <label for="slot-0-time">Date et heure</label>
                    <div class="flex gap-4">
                        <input type="datetime-local" id="slot-0-time" name="slots[0].time" required class="flex-1">
                            @endraw
                            @template.components.Button(
                                type = "button",
                                variant = "danger",
                                size = "sm",
                                onclick = "deleteSlot(this)",
                                extraClasses = "delete-slot",
                                content = @`<i data-feather="trash-2"></i>`
                            )
                            @raw
                    </div>
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
                input.name  = `slots[${index}].time`;
            });
            slotCount = slots.length;
        }
    </script>
    @endraw
`
)
