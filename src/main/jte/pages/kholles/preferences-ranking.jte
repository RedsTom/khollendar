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
    <div class="container mx-auto p-4 max-w-6xl">
        <!-- Indicateur d'utilisateur connecté -->
        @template.components.Alert(
        type = "info",
        body = @`Vous êtes actuellement connecté en tant que <b>${currentUser.username()}</b>`
        )

        <!-- En-tête de la page -->
        <div class="rounded-lg mb-6">
            <h1 class="text-2xl sm:text-3xl font-bold mb-4 break-words">
                Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
            </h1>
            <p class="text-base sm:text-xl text-ctp-subtext0 leading-relaxed">
                Classez les créneaux disponibles par ordre de préférence.
            </p>
        </div>

        @template.components.Card(
        title = "Étape 2 : Classement par préférence",
        content = @`
            <!-- Indicateur d'étapes - visible uniquement sur desktop -->
            <div class="hidden lg:block flex-shrink-0 mb-6">
                <div class="flex items-center gap-2 text-sm text-ctp-subtext0">
                    <span class="text-ctp-subtext0">Étape 1</span>
                    <span class="w-6 sm:w-8 h-0.5 bg-ctp-blue"></span>
                    <span class="font-bold text-ctp-blue">Étape 2</span>
                    <span class="w-6 sm:w-8 h-0.5 bg-ctp-blue"></span>
                    <span class="text-ctp-subtext0">Étape 3</span>
                </div>
            </div>

            <!-- Instructions responsive -->
            @template.components.Alert(
            type = "info",
            body = @`
                <p class="leading-relaxed">
                    Utilisez les boutons <span class="px-1 py-0.5 bg-ctp-mantle rounded">▲</span> et <span
                            class="px-1 py-0.5 bg-ctp-mantle rounded">▼</span> pour réorganiser les créneaux selon vos
                    préférences. Le créneau en tête de liste sera considéré comme votre premier choix.
                </p>
            `
            )

            <!-- Contenu principal responsive -->
            <div class="mb-6">
                @if(availableSlots.isEmpty())
                    <div class="p-4 sm:p-6 text-center bg-ctp-surface1 rounded-lg">
                        <p class="text-base sm:text-xl text-ctp-subtext0 leading-relaxed">
                            Vous avez marqué tous les créneaux comme indisponibles.
                            <a href="/kholles/${session.id()}/preferences?step=1"
                               class="text-ctp-blue underline hover:no-underline">
                                Retourner à l'étape précédente
                            </a>
                        </p>
                    </div>
                @else
                    <form id="rankingForm" action="/kholles/${session.id()}/preferences/step2" method="post">
                        <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                        <!-- Liste de classement responsive -->
                        <ul id="slot-ranking" class="space-y-2 sm:space-y-3">
                            @for(int i = 0; i < availableSlots.size(); i++)
                                !{KholleSlot slot = availableSlots.get(i);}
                                !{var slotId = slot.id().toString();}

                                <li class="slot-item bg-ctp-surface1 rounded-lg p-3 sm:p-4 flex items-center justify-between gap-3"
                                    data-slot-id="${slotId}">
                                    <input type="hidden" name="ranked-slots" value="${slotId}"/>
                                    <div class="flex items-center gap-3 flex-1 min-w-0">
                                        <div class="rank-number flex-shrink-0 w-6 h-6 sm:w-8 sm:h-8 bg-ctp-blue text-ctp-base rounded-full flex items-center justify-center text-sm sm:text-base font-semibold">
                                            ${i + 1}
                                        </div>
                                        <span class="text-sm sm:text-base lg:text-lg font-medium leading-tight break-words min-w-0">${slot.dateTime().format(formatter)}</span>
                                    </div>
                                    <div class="flex items-center gap-1 flex-shrink-0">
                                        @template.components.Button(
                                        type = "button",
                                        variant = "minimal",
                                        extraClasses = "move-up p-1 sm:p-2 rounded hover:bg-ctp-surface2 transition-colors",
                                        content = @`<i class="h-3 w-3 sm:h-4 sm:w-4" data-feather="chevron-up"></i>`
                                        )

                                        @template.components.Button(
                                        type = "button",
                                        variant = "minimal",
                                        extraClasses = "move-down p-1 sm:p-2 rounded hover:bg-ctp-surface2 transition-colors",
                                        content = @`<i class="h-3 w-3 sm:h-4 sm:w-4" data-feather="chevron-down"></i>`
                                        )
                                    </div>
                                </li>
                            @endfor
                        </ul>

                        <!-- Boutons de navigation responsive -->
                        <div class="mt-6 flex flex-col sm:flex-row justify-between gap-3 sm:gap-4">
                            @template.components.Button(
                            href = "/kholles/" + session.id() + "/preferences?step=1",
                            variant = "secondary",
                            extraClasses = "w-full sm:w-auto",
                            content = @`
                                <i data-feather="arrow-left" class="h-4 w-4 mr-2"></i>
                                Retour
                            `
                            )

                            @template.components.Button(
                            type = "submit",
                            variant = "primary",
                            extraClasses = "w-full sm:w-auto",
                            content = @`
                                Suivant
                                <i data-feather="arrow-right" class="h-4 w-4 ml-2"></i>
                            `
                            )
                        </div>
                    </form>
                @endif
            </div>
        `
        )
    </div>

    @raw
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
            initializeSlotRanking();
        });

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
                if (isAnimating) return; // bloquer pendant l'anim principale

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
            if (!slotRanking) return;
            if (isAnimating) return;
            isAnimating = true;
            slotRanking.style.pointerEvents = 'none';

            const itemsBefore = Array.from(slotRanking.children);
            const oldRanks = new Map(itemsBefore.map((item, idx) => [item, idx + 1]));
            const firstRects = new Map(itemsBefore.map(item => [item, item.getBoundingClientRect()]));

            // Appliquer la modification (DOM)
            doReorder();
            updateAfterMove();

            const itemsAfter = Array.from(slotRanking.children);

            // FLIP animation
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

            // Marquer les rangs modifiés
            itemsAfter.forEach((item, idx) => {
                const oldRank = oldRanks.get(item);
                const newRank = idx + 1;
                if (oldRank !== undefined && oldRank !== newRank) {
                    const rankEl = item.querySelector('.rank-number');
                    if (rankEl) {
                        rankEl.classList.remove('rank-changed');
                        void rankEl.offsetWidth;
                        rankEl.classList.add('rank-changed');
                        // Suppression: pastille & outline retirés
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
            updateInputOrder();
            updateButtonStates();
        }

        function updateRankNumbers() {
            const slotItems = document.querySelectorAll('#slot-ranking .slot-item');
            slotItems.forEach((item, idx) => {
                const rankEl = item.querySelector('.rank-number');
                if (rankEl) rankEl.textContent = idx + 1;
            });
        }

        function updateInputOrder() {
            // Pas nécessaire : l'ordre des <li> reflète l'ordre soumis
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
    </script>
    @endraw
`
)
