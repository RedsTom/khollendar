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
            <!-- Breadcrumb -->
            <div class="mb-4">
                @template.components.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                            ${session.subject()}
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Classement des préférences</span>
                    `
                )
            </div>

            <!-- Indicateur d'utilisateur connecté -->
            @template.components.UserHeader(username = currentUser.username())

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
                    <!-- Indicateur d'étapes -->
                    @template.components.StepIndicator(currentStep = 2)

                    <!-- Instructions -->
                    @template.components.Alert(
                        type = "info",
                        body = @`
                            <p class="leading-relaxed">
                                Utilisez les boutons <span class="px-1 py-0.5 bg-ctp-mantle rounded">▲</span> et
                                <span class="px-1 py-0.5 bg-ctp-mantle rounded">▼</span> pour réorganiser les créneaux selon vos
                                préférences. Le créneau en tête de liste sera considéré comme votre premier choix.
                            </p>
                        `
                    )

                    <!-- Contenu principal -->
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
                            <form id="rankingForm"
                                  action="/kholles/${session.id()}/preferences/step2"
                                  method="post">
                                <input type="hidden"
                                       name="${_csrf.getParameterName()}"
                                       value="${_csrf.getToken()}">

                                <!-- Liste de classement -->
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
                                                <span class="text-sm sm:text-base lg:text-lg font-medium leading-tight break-words min-w-0">
                                                    ${slot.dateTime().format(formatter)}
                                                </span>
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

                                <!-- Boutons de navigation -->
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

        <script src="/js/slot-ranking.js"></script>
    `
)
