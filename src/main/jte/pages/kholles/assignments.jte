@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.KholleAssignment
@import java.time.format.DateTimeFormatter
@import java.util.Locale
@import java.util.List
@import java.util.Map
@import jakarta.servlet.http.HttpSession

@param KholleSession session
@param List<KholleAssignment> assignments
@param Map<Long, List<KholleAssignment>> assignmentsBySlot
@param KholleAssignment userAssignment = null
@param boolean isAdmin = false
@param Map<Integer, Long> rankDistribution
@param long withoutPreferences
@param double satisfactionRate
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param HttpSession httpSession = null

!{boolean userAuthenticated = httpSession != null && httpSession.getAttribute("selectedUserId") != null;}

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
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                            ${session.subject()}
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Affectations</span>
                    `
                )
                <h1 class="text-3xl font-bold text-ctp-text">
                    Affectations - ${session.subject()}
                </h1>
            </div>

            <!-- Alerte pour l'affectation de l'utilisateur -->
            @if(userAuthenticated && userAssignment != null)
                @template.components.ui.Alert(
                    type = userAssignment.obtainedPreferenceRank() != null && userAssignment.obtainedPreferenceRank() == 1 ? "success" : "info",
                    body = @`
                        @template.fragments.kholles.UserAssignmentAlert(
                            assignment = userAssignment
                        )
                    `
                )
            @elseif(userAuthenticated && userAssignment == null)
                @template.components.ui.Alert(
                    type = "warning",
                    body = @`
                        <p class="font-semibold">Vous n'avez pas d'affectation pour cette session.</p>
                        <p class="text-sm mt-1">Vous n'avez peut-être pas renseigné vos préférences.</p>
                    `
                )
            @endif

            <!-- Statistiques globales -->
            @template.components.ui.Card(
                content = @`
                    @template.fragments.kholles.AssignmentStatistics(
                        session = session,
                        totalAssignments = assignments.size(),
                        satisfactionRate = satisfactionRate,
                        withoutPreferences = withoutPreferences,
                        rankDistribution = rankDistribution
                    )
                `
            )

            <!-- Liste des affectations par créneau -->
            @template.components.ui.Card(
                content = @`
                    <h2 class="text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                        <i data-feather="users" class="w-6 h-6"></i>
                        Affectations par créneau
                    </h2>

                    <div class="space-y-4">
                        @for(Map.Entry<Long, List<KholleAssignment>> entry : assignmentsBySlot.entrySet())
                            !{KholleSlot slot = entry.getValue().get(0).slot();}
                            @template.fragments.kholles.SlotAssignmentCard(
                                slot = slot,
                                assignments = entry.getValue()
                            )
                        @endfor
                    </div>
                `
            )
        </div>
    `
)
