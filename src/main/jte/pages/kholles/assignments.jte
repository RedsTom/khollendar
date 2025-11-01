@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleAssignment
@import org.springframework.security.web.csrf.CsrfToken
@import java.util.List
@import java.util.Map

@param KholleSession session

@param List<KholleAssignment> assignments
@param Map<Integer, Long> rankDistribution
@param int totalAssignments
@param long withoutPreferences
@param double satisfactionRate

@param boolean isAdmin = false
@param CsrfToken _csrf

@template.layout.MainLayout(
    title = "Affectations - " + session.subject(),
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-7xl">
            <!-- En-tête avec breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                            ${session.subject()}
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <span class="text-ctp-text">Affectations</span>
                    `
                )
                <h1 class="text-3xl font-bold text-ctp-text">
                    Affectations - ${session.subject()}
                </h1>
            </div>

            <!-- Statistiques globales -->
            @template.components.ui.Card(
                content = @`
                    @template.fragments.kholles.AssignmentStatistics(
                        session = session,
                        totalAssignments = totalAssignments,
                        satisfactionRate = satisfactionRate,
                        withoutPreferences = withoutPreferences,
                        rankDistribution = rankDistribution
                    )
                `
            )

            <!-- Liste des affectations par créneau -->
            @template.components.ui.Card(
                content = @`
                    @template.fragments.kholles.Assignments(
                        session = session,
                        assignments = assignments
                    )
                `
            )

            <!-- Actions administrateur -->
            @if(isAdmin)
                @template.components.ui.Card(
                content = @`
                    <h2 class="text-xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                        <i class="fa-solid fa-cogs"></i>
                        Actions administrateur
                    </h2>
                    <div class="flex gap-3 flex-wrap">
                        <button hx-post="/kholles/${session.id()}/assignments/trigger"
                                hx-confirm="Êtes-vous sûr de vouloir recalculer les affectations ? Cela supprimera les affectations actuelles."
                                class="button warning">
                            <i class="fa-solid fa-refresh"></i>
                            Recalculer les affectations
                        </button>
                    </div>
                `
                )
            @endif
        </div>
    `
)
