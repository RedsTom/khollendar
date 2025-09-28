@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale

@param KholleSession session
@param User currentUser
@param List<KholleSlot> slots
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
title = "Mes disponibilités",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="bg-ctp-surface0 rounded-lg p-6">
            <!-- En-tête et navigation -->
            <div class="mb-6">
                <a href="/kholles/${session.id()}" class="text-ctp-blue hover:underline flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 mr-1">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
                    </svg>
                    Retour à la session
                </a>
            </div>

            <!-- Titre et description -->
            <h1 class="text-3xl font-bold mb-2">${session.subject()}</h1>
            <p class="text-ctp-subtext0 mb-6">Indiquer mes disponibilités pour cette khôlle</p>

            <!-- Informations utilisateur -->
            <div class="mb-6 p-3 bg-ctp-surface1 border border-ctp-blue rounded-lg text-ctp-blue text-sm flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 mr-2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                </svg>
                Connecté en tant que : <span class="font-medium ml-1">${currentUser.username()}</span>
            </div>

            <form action="/kholles/${session.id()}/preferences" method="POST" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                <!-- Instructions -->
                <div class="mb-6">
                    <h2 class="text-2xl font-semibold mb-2">Classez vos préférences</h2>
                    <p class="text-ctp-subtext0 mb-2">Classez les créneaux par ordre de préférence (1 = créneau préféré)</p>
                    <p class="text-ctp-subtext1">Ou marquez-vous comme indisponible pour certains créneaux</p>

                    <!-- Bouton de réinitialisation global -->
                    <div class="mt-3">
                        <button type="button"
                                id="reset-all-button"
                                class="px-4 py-2 bg-ctp-surface2 hover:bg-ctp-surface1 text-ctp-text border border-ctp-overlay0 rounded-lg flex items-center text-sm"
                                onclick="resetAllSlots()">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 mr-1 text-ctp-blue">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99" />
                            </svg>
                            Réinitialiser toutes les sélections
                        </button>
                    </div>

                    <!-- Compteur de disponibilités restantes -->
                    <div class="mt-4 p-3 bg-ctp-surface1 rounded-lg text-ctp-text0">
                        <div id="remaining-choices" class="text-sm font-medium"></div>
                    </div>
                </div>

                <!-- Liste des créneaux -->
                <div class="space-y-4" id="slots-container">
                    @for(KholleSlot slot : slots)
                        <div class="flex flex-col sm:flex-row sm:items-center gap-4 p-4 bg-ctp-surface2 rounded-lg slot-item" data-slot-id="${slot.id()}">
                            <!-- Date et heure du créneau -->
                            <div class="flex-grow">
                                <p class="font-medium">${slot.dateTime().format(formatter)}</p>
                            </div>

                            <!-- Options de préférence -->
                            <div class="flex gap-2 mt-2 sm:mt-0">
                                <div class="inline-flex items-center rounded-md shadow-sm" role="group">
                                    <!-- Option indisponible (X) -->
                                    <label class="relative inline-flex items-center">
                                        <input type="radio"
                                               name="slot_${slot.id()}"
                                               value="unavailable"
                                               class="hidden peer unavailable-option"
                                               data-slot-id="${slot.id()}"
                                               onchange="updateSlotStatus(this)">
                                        <span class="px-4 py-2 text-sm font-medium bg-ctp-surface0 text-ctp-text hover:bg-ctp-overlay0 border border-ctp-overlay0 rounded-l-lg cursor-pointer peer-checked:bg-ctp-red peer-checked:text-white peer-checked:border-ctp-red">
                                            <i data-feather="x-circle" class="w-5 h-5"></i>
                                        </span>
                                    </label>

                                    <!-- Options de préférence (1 à N) -->
                                    @for(int index = 1; index <= slots.size(); index++)
                                        !{boolean isLast = index == slots.size();}
                                        <label class="relative inline-flex items-center preference-label" data-preference="${index}">
                                            <input type="radio"
                                                   name="slot_${slot.id()}"
                                                   value="${index}"
                                                   class="hidden peer preference-option"
                                                   data-slot-id="${slot.id()}"
                                                   data-preference="${index}"
                                                   onchange="updateSlotStatus(this)">
                                            <span class="px-4 py-2 text-sm font-medium bg-ctp-surface0 text-ctp-text hover:bg-ctp-overlay0 border border-ctp-overlay0 border-l-0 @if(!isLast)@else rounded-r-lg @endif cursor-pointer peer-checked:bg-ctp-blue peer-checked:text-ctp-base peer-checked:border-ctp-blue preference-display">
                                                ${index}
                                            </span>
                                        </label>
                                    @endfor
                                </div>
                            </div>
                        </div>
                    @endfor
                </div>

                <!-- Bouton de soumission -->
                <div class="flex justify-end pt-4 border-t border-ctp-surface1">
                    <button type="submit"
                            id="submit-button"
                            class="px-6 py-3 bg-ctp-blue text-ctp-base font-medium rounded-md transition-colors flex items-center disabled:bg-ctp-overlay0 disabled:text-ctp-subtext0 disabled:cursor-not-allowed"
                            disabled>
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 mr-2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Enregistrer mes disponibilités
                    </button>
                </div>
            </form>
        </div>
    </div>

    @raw
    <script>
        /**
         * Module de gestion des disponibilités pour les khôlles
         */
        const PreferencesManager = (function() {
            // État global
            const state = {
                previousSelections: {},   // Mémoriser les sélections précédentes par créneau
                stats: {                  // Statistiques globales
                    unavailableCount: 0,
                    selectedPreferences: 0,
                    totalSlots: 0,
                    remainingSlots: 0
                }
            };

            /**
             * Initialise le gestionnaire de préférences
             */
            function init() {
                // Récupérer l'état initial des sélections
                document.querySelectorAll('.preference-option:checked').forEach(input => {
                    state.previousSelections[input.dataset.slotId] = input.value;
                });

                document.querySelectorAll('.unavailable-option:checked').forEach(input => {
                    state.previousSelections[input.dataset.slotId] = 'unavailable';
                });

                // Ajouter les écouteurs d'événements
                document.querySelectorAll('.unavailable-option, .preference-option').forEach(input => {
                    input.addEventListener('change', () => handleSlotChange(input));
                });

                // Initialiser l'interface
                updateStats();
                applyAllRestrictions();
                updateUI();
            }

            /**
             * Gère le changement d'état d'un créneau
             */
            function handleSlotChange(radioInput) {
                const slotId = radioInput.dataset.slotId;
                const oldPreference = state.previousSelections[slotId];
                const newPreference = radioInput.value;
                const isUnavailable = radioInput.classList.contains('unavailable-option');

                // Libérer l'ancienne préférence si nécessaire
                if (oldPreference && oldPreference !== 'unavailable' && oldPreference !== newPreference) {
                    togglePreferenceAvailability(oldPreference, true);
                }

                // Enregistrer la nouvelle sélection
                state.previousSelections[slotId] = isUnavailable ? 'unavailable' : newPreference;

                // Si c'est une préférence (et non "indisponible"), la rendre indisponible ailleurs
                if (!isUnavailable) {
                    togglePreferenceAvailability(newPreference, false, slotId);
                }

                // Mettre à jour l'interface
                updateStats();
                applyAllRestrictions();
                updateUI();
            }

            /**
             * Active ou désactive une préférence dans tous les créneaux
             * @param {string} preference - La valeur de préférence
             * @param {boolean} enable - True pour activer, false pour désactiver
             * @param {string} [exceptSlotId] - ID du créneau à exclure
             */
            function togglePreferenceAvailability(preference, enable, exceptSlotId = null) {
                document.querySelectorAll(`.preference-option[data-preference="${preference}"]`).forEach(input => {
                    if (exceptSlotId && input.dataset.slotId === exceptSlotId) return;

                    // Ne pas activer si cette préférence doit rester désactivée à cause des indisponibilités
                    if (enable && shouldBeDisabledDueToUnavailability(preference)) return;

                    // Ne pas modifier l'état si l'option est déjà sélectionnée
                    if (input.checked) return;

                    // Modifier l'état de l'option
                    const label = input.closest('.preference-label');
                    input.disabled = !enable;

                    if (enable) {
                        label.classList.remove('opacity-50', 'cursor-not-allowed');
                        const display = label.querySelector('.preference-display');
                        display.classList.remove('bg-ctp-overlay0', 'text-ctp-subtext0');
                        display.classList.add('hover:bg-ctp-overlay0');
                    } else {
                        label.classList.add('opacity-50', 'cursor-not-allowed');
                        const display = label.querySelector('.preference-display');
                        display.classList.add('bg-ctp-overlay0', 'text-ctp-subtext0');
                        display.classList.remove('hover:bg-ctp-overlay0');
                    }
                });
            }

            /**
             * Vérifie si une préférence devrait être désactivée à cause des indisponibilités
             */
            function shouldBeDisabledDueToUnavailability(preference) {
                const { unavailableCount, totalSlots } = state.stats;
                return parseInt(preference) > totalSlots - unavailableCount;
            }

            /**
             * Efface la sélection d'un créneau
             */
            function clearSlot(slotId) {
                // Récupérer l'ancienne sélection
                const oldPreference = state.previousSelections[slotId];

                // Si c'était une préférence, la rendre disponible ailleurs
                if (oldPreference && oldPreference !== 'unavailable') {
                    togglePreferenceAvailability(oldPreference, true);
                }

                // Supprimer du suivi des sélections
                delete state.previousSelections[slotId];

                // Décocher tous les radios de ce créneau
                document.querySelectorAll(`input[name="slot_${slotId}"]`).forEach(radio => {
                    radio.checked = false;
                });

                // Mettre à jour l'interface
                updateStats();
                applyAllRestrictions();
                updateUI();
            }

            /**
             * Efface toutes les sélections de tous les créneaux
             */
            function clearAllSlots() {
                // Récupérer tous les IDs de créneaux
                const slotIds = Array.from(document.querySelectorAll('.slot-item')).map(el => el.dataset.slotId);

                // Effacer chaque créneau
                slotIds.forEach(slotId => clearSlot(slotId));

                // Réinitialiser l'état
                state.previousSelections = {};

                // Mettre à jour l'interface
                updateStats();
                applyAllRestrictions();
                updateUI();
            }

            /**
             * Met à jour les statistiques globales
             */
            function updateStats() {
                state.stats.unavailableCount = document.querySelectorAll('.unavailable-option:checked').length;
                state.stats.selectedPreferences = document.querySelectorAll('.preference-option:checked').length;
                state.stats.totalSlots = document.querySelectorAll('.slot-item').length;
                state.stats.remainingSlots = state.stats.totalSlots - state.stats.unavailableCount - state.stats.selectedPreferences;

                // Stockage des stats comme attributs de données pour faciliter le débogage
                const container = document.getElementById('slots-container');
                if (container) {
                    container.dataset.unavailableCount = state.stats.unavailableCount;
                    container.dataset.selectedPreferences = state.stats.selectedPreferences;
                    container.dataset.remainingSlots = state.stats.remainingSlots;
                }
            }

            /**
             * Applique toutes les restrictions en fonction de l'état actuel
             */
            function applyAllRestrictions() {
                // Réinitialiser d'abord toutes les options
                resetAllOptions();

                // Appliquer les restrictions pour chaque préférence sélectionnée
                document.querySelectorAll('.preference-option:checked').forEach(input => {
                    const preference = input.value;
                    const slotId = input.dataset.slotId;
                    togglePreferenceAvailability(preference, false, slotId);
                });

                // Appliquer les restrictions dues aux indisponibilités
                applyUnavailabilityRestrictions();
            }

            /**
             * Réinitialise toutes les options à leur état par défaut (activées)
             */
            function resetAllOptions() {
                document.querySelectorAll('.preference-option').forEach(input => {
                    if (!input.checked) {
                        input.disabled = false;
                        const label = input.closest('.preference-label');
                        label.classList.remove('opacity-50', 'cursor-not-allowed');
                        const display = label.querySelector('.preference-display');
                        display.classList.remove('bg-ctp-overlay0', 'text-ctp-subtext0');
                        display.classList.add('hover:bg-ctp-overlay0');
                    }
                });
            }

            /**
             * Applique les restrictions liées aux indisponibilités
             */
            function applyUnavailabilityRestrictions() {
                const { unavailableCount, totalSlots } = state.stats;

                if (unavailableCount > 0) {
                    // Pour chaque niveau de préférence
                    for (let i = 1; i <= totalSlots; i++) {
                        // Si ce niveau est supérieur au nombre de créneaux disponibles
                        if (i > totalSlots - unavailableCount) {
                            // Désactiver cette préférence partout si elle n'est pas déjà sélectionnée
                            document.querySelectorAll(`.preference-option[data-preference="${i}"]:not(:checked)`).forEach(input => {
                                input.disabled = true;
                                const label = input.closest('.preference-label');
                                label.classList.add('opacity-50', 'cursor-not-allowed');
                                const display = label.querySelector('.preference-display');
                                display.classList.add('bg-ctp-overlay0', 'text-ctp-subtext0');
                                display.classList.remove('hover:bg-ctp-overlay0');
                            });
                        }
                    }
                }
            }

            /**
             * Met à jour les éléments visuels de l'interface
             */
            function updateUI() {
                updateRemainingChoicesDisplay();
                updateSubmitButtonState();
            }

            /**
             * Met à jour l'affichage du nombre de choix restants
             */
            function updateRemainingChoicesDisplay() {
                const remainingChoices = document.getElementById('remaining-choices');
                if (!remainingChoices) return;

                if (state.stats.remainingSlots > 0) {
                    remainingChoices.innerHTML = `
                        <div class="flex gap-1 items-center">
                            <i data-feather="info" class="w-5 h-5 mr-2 text-ctp-blue"></i>
                            Il vous reste <strong>${state.stats.remainingSlots}</strong> créneau(x) à configurer
                        </div>`;
                } else {
                    remainingChoices.innerHTML = `
                        <div class="flex gap-1 items-center">
                            <i data-feather="check-circle" class="w-5 h-5 mr-2 text-ctp-green"></i>
                            Tous les créneaux sont configurés !
                        </div>`;
                }

                feather.replace();
            }

            /**
             * Active ou désactive le bouton de soumission
             */
            function updateSubmitButtonState() {
                const submitButton = document.getElementById('submit-button');
                if (!submitButton) return;

                const enabled = state.stats.remainingSlots === 0;
                submitButton.disabled = !enabled;

                if (enabled) {
                    submitButton.classList.add('hover:bg-ctp-sapphire');
                    submitButton.title = "Envoyer mes disponibilités";
                } else {
                    submitButton.classList.remove('hover:bg-ctp-sapphire');
                    submitButton.title = "Veuillez configurer tous les créneaux avant de soumettre";
                }
            }

            // API publique
            return {
                init,
                clearSlot,
                clearAllSlots,
                getStats: () => ({ ...state.stats })
            };
        })();

        // Initialiser au chargement de la page
        document.addEventListener('DOMContentLoaded', PreferencesManager.init);

        // Exposer la fonction de clear pour les boutons
        function clearSlotSelection(slotId) {
            PreferencesManager.clearSlot(slotId);
        }

        // Exposer la fonction de réinitialisation globale
        function resetAllSlots() {
            if(confirm("Êtes-vous sûr de vouloir réinitialiser toutes vos sélections ?")) {
                PreferencesManager.clearAllSlots();
            }
        }

        // Exposer la fonction de mise à jour pour les inputs radio
        function updateSlotStatus(radioInput) {
            PreferencesManager.handleSlotChange(radioInput);
        }
    </script>
    @endraw
`
)
