@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import java.util.List

@param KholleSession session
@param User currentUser
@param List<KholleSlot> availableSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Mes préférences",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-6xl">
            <!-- Breadcrumb -->
            <div class="mb-4">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i class="feather-icon icon-chevron-right"></i>
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i class="feather-icon icon-chevron-right"></i>
                        <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                            ${session.subject()}
                        </a>
                        <i class="feather-icon icon-chevron-right"></i>
                        <span class="text-ctp-text">Classement des préférences</span>
                    `
                )
            </div>

            <!-- Indicateur d'utilisateur connecté -->
            @template.fragments.common.UserIndicator(username = currentUser.username())

            <!-- En-tête de la page -->
            @template.fragments.kholles.PreferencesPageHeader(
                subject = @`Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>`,
                step = "Classez les créneaux disponibles par ordre de préférence."
            )

            @template.components.ui.Card(
                title = "Étape 2 : Classement par préférence",
                content = @`
                    <!-- Barre de progression -->
                    @template.components.layout.ProgressBar(currentStep = 2, totalSteps = 3)

                    <!-- Instructions -->
                    @template.components.ui.Alert(
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
                            @template.fragments.common.EmptyState(
                                message = "Vous avez marqué tous les créneaux comme indisponibles.",
                                linkText = "Retourner à l'étape précédente",
                                linkHref = "/kholles/${session.id()}/preferences?step=1"
                            )
                        @else
                            <form id="rankingForm"
                                  action="/kholles/${session.id()}/preferences/step2"
                                  method="post">
                                <input type="hidden"
                                       name="${_csrf.getParameterName()}"
                                       value="${_csrf.getToken()}">

                                <!-- Liste de classement -->
                                @template.fragments.kholles.SlotRanking(
                                    availableSlots = availableSlots,
                                    _csrf = _csrf
                                )

                                <!-- Boutons de navigation -->
                                <div class="flex flex-col sm:flex-row justify-between gap-4 mt-6">
                                    <a href="/kholles/${session.id()}/preferences?step=1" class="button secondary">
                                        <i class="feather-icon icon-arrow-left"></i>
                                        Retour
                                    </a>

                                    <button type="submit" class="button primary">
                                        Continuer
                                        <i class="feather-icon icon-arrow-right"></i>
                                    </button>
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
