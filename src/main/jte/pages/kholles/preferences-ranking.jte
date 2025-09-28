@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import java.time.format.DateTimeFormatter
@import java.util.Comparator
@import java.util.List
@import java.util.Locale

@param KholleSession session
@param User currentUser
@param List<KholleSlot> availableSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
title = "Mes préférences",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="mb-4 p-3 bg-ctp-surface0 border border-ctp-blue rounded-lg text-ctp-blue text-sm flex items-center">
            <i class="h-5 w-5 mr-4 text-ctp-blue" data-feather="user"></i>
            <span>
                Vous êtes actuellement connectés en tant que <b>${currentUser.username()}</b>
            </span>
        </div>

        <div class="rounded-lg mb-4">
            <h1 class="text-3xl font-bold mb-4">
                Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
            </h1>
            <p class="text-xl text-ctp-subtext0">
                Classez les créneaux disponibles par ordre de préférence.
            </p>
        </div>

        <div class="bg-ctp-surface0 rounded-lg p-6">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h2 class="text-2xl font-semibold mb-2">
                        Étape 2 : Classement par préférence
                    </h2>
                    <p class="text-xl mb-4">
                        Réorganisez les créneaux ci-dessous par ordre de préférence (du plus au moins préféré).
                    </p>
                </div>
                <div class="hidden md:block">
                    <div class="flex items-center gap-2 text-sm text-ctp-subtext0">
                        <span class="text-ctp-subtext0">Étape 1</span>
                        <span class="w-8 h-0.5 bg-ctp-blue"></span>
                        <span class="font-bold text-ctp-blue">Étape 2</span>
                        <span class="w-8 h-0.5 bg-ctp-blue"></span>
                        <span class="text-ctp-subtext0">Étape 3</span>
                    </div>
                </div>
            </div>

            <div class="mb-6 p-3 bg-ctp-blue/20 border border-ctp-blue rounded-lg text-ctp-blue text-sm flex items-center">
                <i class="h-5 w-5 mr-4 text-ctp-blue" data-feather="info"></i>
                <p>
                    Utilisez les boutons <span class="px-1 py-0.5 bg-ctp-mantle rounded">▲</span> et <span class="px-1 py-0.5 bg-ctp-mantle rounded">▼</span> pour réorganiser les créneaux selon vos préférences. Le créneau en tête de liste sera considéré comme votre premier choix.
                </p>
            </div>

            <div class="mb-6">
                @if(availableSlots.isEmpty())
                    <div class="p-6 text-center bg-ctp-surface1 rounded-lg">
                        <p class="text-xl text-ctp-subtext0">
                            Vous avez marqué tous les créneaux comme indisponibles.
                            <a href="/kholles/${session.id()}/preferences?step=1" class="text-ctp-blue underline">
                                Retourner à l'étape précédente
                            </a>
                        </p>
                    </div>
                @else
                    <form id="rankingForm" action="/kholles/${session.id()}/preferences/step2" method="post">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                        <ul id="slot-ranking" class="space-y-2">
                            @for(int i = 0; i < availableSlots.size(); i++)
                                !{KholleSlot slot = availableSlots.get(i);}

                                <li class="slot-item bg-ctp-surface1 rounded-lg p-4 flex items-center justify-between" data-slot-id="${slot.id()}">
                                    <input type="hidden" name="ranked-slots" value="${slot.id()}" />
                                    <div class="flex items-center">
                                        <div class="rank-number flex-shrink-0 w-8 h-8 bg-ctp-blue text-ctp-base rounded-full flex items-center justify-center mr-3">
                                            ${i + 1}
                                        </div>
                                        <span class="text-lg font-medium">${slot.dateTime().format(formatter)}</span>
                                    </div>
                                    <div class="flex items-center gap-1">
                                        <button type="button" class="move-up p-2 rounded hover:bg-ctp-surface2 transition-colors">
                                            <i class="h-5 w-5" data-feather="chevron-up"></i>
                                        </button>
                                        <button type="button" class="move-down p-2 rounded hover:bg-ctp-surface2 transition-colors">
                                            <i class="h-5 w-5" data-feather="chevron-down"></i>
                                        </button>
                                    </div>
                                </li>
                            @endfor
                        </ul>

                        <div class="mt-6 flex justify-between">
                            <a href="/kholles/${session.id()}/preferences?step=1"
                               class="px-6 py-3 border border-ctp-blue text-ctp-blue font-medium rounded-lg hover:bg-ctp-blue/10 transition-colors flex items-center gap-2">
                                <i data-feather="arrow-left" class="h-4 w-4"></i>
                                Retour
                            </a>
                            <button type="submit"
                                    class="px-6 py-3 bg-ctp-green text-ctp-base font-medium rounded-lg hover:bg-ctp-green/80 transition-colors flex items-center gap-2">
                                Suivant
                                <i data-feather="arrow-right" class="h-4 w-4"></i>
                            </button>
                        </div>
                    </form>
                @endif
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof feather !== 'undefined') {
                feather.replace();
            }

            // Initialiser le système de classement
            initializeSlotRanking();
        });

        function initializeSlotRanking() {
            const slotRanking = document.getElementById('slot-ranking');
            if (!slotRanking) return;

            // Ajouter les gestionnaires d'événements
            attachEventListeners();

            // Mettre à jour l'état initial des boutons
            updateButtonStates();
        }

        function attachEventListeners() {
            const slotRanking = document.getElementById('slot-ranking');

            // Utiliser la délégation d'événements pour gérer les clics
            slotRanking.addEventListener('click', function(event) {
                const button = event.target.closest('button');
                if (!button) return;

                // Ne rien faire si le bouton est désactivé
                if (button.classList.contains('disabled')) return;

                if (button.classList.contains('move-up')) {
                    moveSlotUp(button);
                } else if (button.classList.contains('move-down')) {
                    moveSlotDown(button);
                }
            });
        }

        function moveSlotUp(button) {
            const listItem = button.closest('li');
            const prevItem = listItem.previousElementSibling;

            if (prevItem) {
                const slotRanking = document.getElementById('slot-ranking');
                slotRanking.insertBefore(listItem, prevItem);

                // Mettre à jour l'interface après le déplacement
                updateAfterMove();
            }
        }

        function moveSlotDown(button) {
            const listItem = button.closest('li');
            const nextItem = listItem.nextElementSibling;

            if (nextItem) {
                const slotRanking = document.getElementById('slot-ranking');
                slotRanking.insertBefore(nextItem, listItem);

                // Mettre à jour l'interface après le déplacement
                updateAfterMove();
            }
        }

        function updateAfterMove() {
            updateRankNumbers();
            updateInputOrder();
            updateButtonStates();
        }

        // Mettre à jour les numéros de rang affichés
        function updateRankNumbers() {
            const listItems = document.querySelectorAll('#slot-ranking .slot-item');

            listItems.forEach((item, index) => {
                const rankNumber = item.querySelector('.rank-number');
                if (rankNumber) {
                    rankNumber.textContent = index + 1;
                }
            });
        }

        // Mettre à jour l'ordre des inputs cachés pour la soumission du formulaire
        function updateInputOrder() {
            const form = document.getElementById('rankingForm');
            if (!form) return;

            // Supprimer tous les anciens inputs de classement
            const oldInputs = form.querySelectorAll('input[name="ranked-slots"]');
            oldInputs.forEach(input => input.remove());

            // Ajouter les nouveaux inputs dans le nouvel ordre
            const listItems = document.querySelectorAll('#slot-ranking .slot-item');
            listItems.forEach(item => {
                const slotId = item.getAttribute('data-slot-id');
                if (slotId) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'ranked-slots';
                    input.value = slotId;
                    form.appendChild(input);
                }
            });
        }

        // Mettre à jour l'état des boutons (actif/désactivé)
        function updateButtonStates() {
            const listItems = document.querySelectorAll('#slot-ranking .slot-item');
            const totalItems = listItems.length;

            listItems.forEach((item, index) => {
                const upButton = item.querySelector('.move-up');
                const downButton = item.querySelector('.move-down');
                const upIcon = upButton.querySelector('i');
                const downIcon = downButton.querySelector('i');

                // Réinitialiser tous les styles
                resetButtonStyles(upButton, upIcon);
                resetButtonStyles(downButton, downIcon);

                // Premier élément - désactiver le bouton "monter"
                if (index === 0) {
                    disableButton(upButton, upIcon);
                }

                // Dernier élément - désactiver le bouton "descendre"
                if (index === totalItems - 1) {
                    disableButton(downButton, downIcon);
                }
            });
        }

        function resetButtonStyles(button, icon) {
            button.classList.remove('disabled', 'opacity-50', 'cursor-not-allowed');
            button.classList.add('hover:bg-ctp-surface2');
            if (icon) {
                icon.classList.remove('text-ctp-overlay0');
                icon.classList.add('text-ctp-text');
            }
        }

        function disableButton(button, icon) {
            button.classList.add('disabled', 'opacity-50', 'cursor-not-allowed');
            button.classList.remove('hover:bg-ctp-surface2');
            if (icon) {
                icon.classList.remove('text-ctp-text');
                icon.classList.add('text-ctp-overlay0');
            }
        }
    </script>
`
)
