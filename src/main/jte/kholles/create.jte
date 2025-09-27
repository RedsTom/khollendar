@import java.time.format.DateTimeFormatter

@param String title

@template.layout.MainLayout(
    title = title,
    content = @`
    <div class="container mx-auto p-4">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">${title}</h1>
            <p class="text-gray-300">Remplissez le formulaire ci-dessous pour créer une nouvelle session de khôlles.</p>
        </div>

        <form action="/kholles/create" method="post" class="bg-slate-700 p-6 rounded-lg max-w-3xl">
            <div class="mb-6">
                <label for="subject" class="block text-sm font-medium mb-2">Matière / Sujet</label>
                <input type="text" id="subject" name="subject" required
                       class="w-full p-2 bg-slate-800 border border-slate-600 rounded-md text-white focus:outline-none focus:border-blue-500"
                       placeholder="Ex: Mathématiques - Intégrales">
            </div>

            <div class="mb-6">
                <h3 class="text-lg font-medium mb-4">Créneaux horaires</h3>
                <div id="slots-container" class="space-y-4">
                    <div class="slot-input flex flex-col sm:flex-row gap-4">
                        <div class="flex-1">
                            <label class="block text-sm font-medium mb-2">Date et heure</label>
                            <label>
                                <input type="datetime-local" name="slots[0].time" required
                                       class="w-full p-2 bg-slate-800 border border-slate-600 rounded-md text-white focus:outline-none focus:border-blue-500">
                            </label>
                        </div>
                        <div class="flex items-end">
                            <button type="button" class="delete-slot bg-red-600 hover:bg-red-700 px-3 py-2 rounded-md" onclick="deleteSlot(this)">
                                <i data-feather="trash-2"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <button type="button" id="add-slot" class="mt-4 bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md flex items-center">
                    <i data-feather="plus" class="mr-2"></i>
                    Ajouter un créneau
                </button>
            </div>

            <div class="flex justify-between mt-8">
                <a href="/kholles" class="bg-slate-600 hover:bg-slate-500 text-white px-6 py-2 rounded-md">Annuler</a>
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-md">Créer la session</button>
            </div>
        </form>
    </div>

    @raw
    <script>
        let slotCount = 1;

        document.getElementById('add-slot').addEventListener('click', function() {
            const container = document.getElementById('slots-container');
            const newSlot = document.createElement('div');
            newSlot.className = 'slot-input flex flex-col sm:flex-row gap-4';

            newSlot.innerHTML = `
                <div class="flex-1">
                    <label class="block text-sm font-medium mb-2">Date et heure</label>
                    <input type="datetime-local" name="slots[${slotCount}].time" required
                           class="w-full p-2 bg-slate-800 border border-slate-600 rounded-md text-white focus:outline-none focus:border-blue-500">
                </div>
                <div class="flex items-end">
                    <button type="button" class="delete-slot bg-red-600 hover:bg-red-700 px-3 py-2 rounded-md" onclick="deleteSlot(this)">
                        <i data-feather="trash-2"></i>
                    </button>
                </div>
            `;

            container.appendChild(newSlot);
            slotCount++;
            feather.replace();
        });

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
`)
