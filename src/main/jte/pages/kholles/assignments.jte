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
!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy 'à' HH'h'mm", Locale.FRENCH);}

@template.layout.MainLayout(
    title = "Affectations - " + session.subject(),
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-7xl">
            <!-- En-tête avec breadcrumb -->
            <div class="mb-6">
                @template.components.Breadcrumb(
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
                @template.components.Alert(
                    type = userAssignment.obtainedPreferenceRank() != null && userAssignment.obtainedPreferenceRank() == 1 ? "success" : "info",
                    body = @`
                        <div>
                            <h3 class="font-semibold text-lg mb-1">Votre créneau affecté</h3>
                            <p class="text-base">
                                <i data-feather="calendar" class="inline-block w-5 h-5 mr-1"></i>
                                <strong>${userAssignment.slot().dateTime().format(formatter)}</strong>
                            </p>
                            @if(userAssignment.obtainedPreferenceRank() != null)
                                <p class="text-sm mt-2">
                                    @if(userAssignment.obtainedPreferenceRank() == 1)
                                        🎉 Vous avez obtenu votre <strong>premier choix</strong> !
                                    @else
                                        Vous avez obtenu votre <strong>choix n°${userAssignment.obtainedPreferenceRank()}</strong>
                                    @endif
                                </p>
                            @else
                                <p class="text-sm mt-2 text-ctp-subtext0">
                                    Affectation aléatoire (aucune préférence renseignée ou satisfaite)
                                </p>
                            @endif
                        </div>
                    `
                )
            @elseif(userAuthenticated && userAssignment == null)
                @template.components.Alert(
                    type = "warning",
                    body = @`
                        <p class="font-semibold">Vous n'avez pas d'affectation pour cette session.</p>
                        <p class="text-sm mt-1">Vous n'avez peut-être pas renseigné vos préférences.</p>
                    `
                )
            @endif

            <!-- Statistiques globales -->
            @template.components.Card(
                content = @`
                    <h2 class="text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                        <i data-feather="bar-chart-2" class="w-6 h-6"></i>
                        Statistiques d'affectation
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <!-- Taux de satisfaction -->
                        <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
                            <div class="text-ctp-subtext0 text-sm mb-1">Taux de satisfaction</div>
                            <div class="text-3xl font-bold text-ctp-green">
                                ${String.format("%.1f", satisfactionRate)}%
                            </div>
                            <div class="text-xs text-ctp-subtext0 mt-1">Premier choix obtenu</div>
                        </div>

                        <!-- Total d'étudiants -->
                        <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
                            <div class="text-ctp-subtext0 text-sm mb-1">Étudiants affectés</div>
                            <div class="text-3xl font-bold text-ctp-blue">${assignments.size()}</div>
                            <div class="text-xs text-ctp-subtext0 mt-1">
                                Sur ${session.kholleSlots().size()} créneaux
                            </div>
                        </div>

                        <!-- Affectations aléatoires -->
                        <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
                            <div class="text-ctp-subtext0 text-sm mb-1">Affectations aléatoires</div>
                            <div class="text-3xl font-bold text-ctp-yellow">${withoutPreferences}</div>
                            <div class="text-xs text-ctp-subtext0 mt-1">Sans préférence satisfaite</div>
                        </div>
                    </div>

                    <!-- Distribution par rang de préférence -->
                    @if(!rankDistribution.isEmpty())
                        <div class="mt-6 pt-6 border-t border-ctp-surface2">
                            <h3 class="text-lg font-semibold mb-3 text-ctp-text">
                                Distribution par rang de préférence
                            </h3>
                            <div class="space-y-2">
                                @for(Map.Entry<Integer, Long> entry : rankDistribution.entrySet().stream().sorted(Map.Entry.comparingByKey()).toList())
                                    !{int rank = entry.getKey();}
                                    !{long count = entry.getValue();}
                                    !{double percentage = (double) count / assignments.size() * 100;}
                                    <div>
                                        <div class="flex justify-between text-sm mb-1">
                                            <span class="text-ctp-text">Choix n°${rank}</span>
                                            <span class="text-ctp-subtext0">
                                                ${count} étudiant${count > 1 ? "s" : ""} (${String.format("%.1f", percentage)}%)
                                            </span>
                                        </div>
                                        <div class="w-full bg-ctp-surface0 rounded-full h-2">
                                            <div class="h-2 rounded-full transition-all
                                                @if(rank == 1) bg-ctp-green
                                                @elseif(rank == 2) bg-ctp-blue
                                                @elseif(rank == 3) bg-ctp-yellow
                                                @else bg-ctp-overlay0
                                                @endif
                                            " style="width: ${percentage}%"></div>
                                        </div>
                                    </div>
                                @endfor
                            </div>
                        </div>
                    @endif
                `
            )

            <!-- Affectations par créneau -->
            <div class="mt-6">
                <h2 class="text-2xl font-semibold mb-4 text-ctp-text flex items-center gap-2">
                    <i data-feather="users" class="w-6 h-6"></i>
                    Affectations par créneau
                </h2>

                <div class="space-y-4">
                    @for(KholleSlot slot : session.kholleSlots().stream().sorted((a, b) -> a.dateTime().compareTo(b.dateTime())).toList())
                        !{List<KholleAssignment> slotAssignments = assignmentsBySlot.getOrDefault(slot.id(), List.of());}
                        @template.components.Card(
                            content = @`
                                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4 pb-4 border-b border-ctp-surface2">
                                    <div>
                                        <h3 class="text-xl font-semibold text-ctp-blue flex items-center gap-2">
                                            <i data-feather="clock" class="w-5 h-5"></i>
                                            ${slot.dateTime().format(formatter)}
                                        </h3>
                                        <p class="text-sm text-ctp-subtext0 mt-1">
                                            ${slotAssignments.size()} étudiant${slotAssignments.size() > 1 ? "s" : ""} affecté${slotAssignments.size() > 1 ? "s" : ""}
                                        </p>
                                    </div>
                                    @if(userAssignment != null && userAssignment.slot().id().equals(slot.id()))
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-ctp-green/20 text-ctp-green border border-ctp-green/30">
                                            <i data-feather="check-circle" class="w-4 h-4 mr-1"></i>
                                            Votre créneau
                                        </span>
                                    @endif
                                </div>

                                @if(slotAssignments.isEmpty())
                                    <p class="text-ctp-subtext0 italic text-center py-4">
                                        Aucun étudiant affecté à ce créneau
                                    </p>
                                @else
                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                                        @for(KholleAssignment assignment : slotAssignments.stream().sorted((a, b) -> a.user().username().compareToIgnoreCase(b.user().username())).toList())
                                            <div class="bg-ctp-surface0/50 rounded-lg p-3 border border-ctp-surface2 flex items-center justify-between">
                                                <div class="flex items-center gap-2 min-w-0">
                                                    <i data-feather="user" class="w-4 h-4 text-ctp-blue flex-shrink-0"></i>
                                                    <span class="font-medium text-ctp-text truncate">
                                                        ${assignment.user().username()}
                                                    </span>
                                                </div>
                                                @template.components.AssignmentBadge(
                                                    preferenceRank = assignment.obtainedPreferenceRank(),
                                                )
                                            </div>
                                        @endfor
                                    </div>
                                @endif
                            `
                        )
                    @endfor
                </div>
            </div>

            <!-- Actions administrateur -->
            @if(isAdmin)
                <div class="mt-6">
                    @template.components.Card(
                        content = @`
                            <h2 class="text-xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                                <i data-feather="settings" class="w-5 h-5"></i>
                                Actions administrateur
                            </h2>
                            <div class="flex gap-3 flex-wrap">
                                <form method="post"
                                      action="/kholles/${session.id()}/assignments/trigger"
                                      class="inline">
                                    <input type="hidden"
                                           name="${_csrf.getParameterName()}"
                                           value="${_csrf.getToken()}"/>
                                    <button type="submit"
                                            onclick="return confirm('Êtes-vous sûr de vouloir recalculer les affectations ? Cela supprimera les affectations actuelles.');"
                                            class="inline-flex items-center px-4 py-2 bg-ctp-yellow hover:bg-ctp-yellow/80 text-ctp-base rounded-lg font-medium transition-colors">
                                        <i data-feather="refresh-cw" class="w-4 h-4 mr-2"></i>
                                        Recalculer les affectations
                                    </button>
                                </form>
                            </div>
                        `
                    )
                </div>
            @endif
        </div>
    `
)
