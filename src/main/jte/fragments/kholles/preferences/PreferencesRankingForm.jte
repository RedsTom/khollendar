@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import java.util.List

@param KholleSession session
@param User currentUser
@param List<KholleSlot> availableSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

<!-- En-tête de la page -->
@template.fragments.kholles.preferences.PreferencesPageHeader(
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
                        <span class="hidden sm:inline">
                            Utilisez l'icône <i class="fa-solid fa-grip-lines"></i> pour glisser-déposer et réorganiser
                            les créneaux selon vos préférences.
                        </span>
                <span class="sm:hidden">
                            Maintenez et glissez les créneaux pour les réorganiser selon vos préférences.
                        </span>
                Le créneau en tête de liste sera considéré comme votre premier choix.
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
                      hx-post="/kholles/${session.id()}/preferences/ranking">
                    <!-- Liste de classement -->
                    @template.fragments.kholles.SlotRanking(
                    availableSlots = availableSlots,
                    _csrf = _csrf
                    )
                </form>

                <!-- Boutons de navigation -->
                <div class="flex flex-col sm:flex-row justify-between gap-4 mt-6">
                    <button hx-post="/kholles/${session.id()}/preferences/previous" class="button secondary" disabled>
                        <i class="fa-solid fa-arrow-left"></i>
                        Retour
                    </button>
                    <button type="submit" form="rankingForm" class="button primary" disabled>
                        Continuer
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            @endif
        </div>
    `
)

<script src="/js/slot-ranking.js"></script>

