@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.entity.UserPreference
@import fr.redstom.khollendar.entity.KholleAssignment
@import java.time.format.DateTimeFormatter
@import java.util.Locale
@import java.util.List
@import java.util.ArrayList
@import java.util.Comparator
@import java.util.Map
@import jakarta.servlet.http.HttpSession

@param KholleSession session
@param Map<User, List<UserPreference>> userPreferences
@param Map<User, List<KholleSlot>> userUnavailableSlots
@param long registeredUsersCount
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param HttpSession httpSession = null
@param boolean isAdmin = false
@param List<KholleAssignment> assignments = null
@param Map<Long, List<KholleAssignment>> assignmentsBySlot = null
@param KholleAssignment userAssignment = null

!{boolean userAuthenticated = httpSession != null && httpSession.getAttribute("selectedUserId") != null;}
!{boolean hasAssignments = assignments != null && !assignments.isEmpty();}

!{
    List<KholleSlot> sortedSlots = new ArrayList<>(session.kholleSlots());
    sortedSlots.sort(Comparator.comparing(KholleSlot::dateTime));
}

@template.layout.MainLayout(
    title = "Détails de la session",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-7xl">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">${session.subject()}</span>
                    `
                )
            </div>

            @template.components.ui.Card(
                content = @`
                    <!-- En-tête de la session -->
                    @template.fragments.kholles.SessionHeader(
                        session = session,
                        actionButtons = @`
                            @template.fragments.kholles.SessionActionButtons(
                                session = session,
                                userAuthenticated = userAuthenticated,
                                hasAssignments = hasAssignments
                            )
                        `
                    )

                    <!-- Section Actions administrateur -->
                    @if(isAdmin)
                        @template.fragments.admin.SessionActions(
                            session = session,
                            _csrf = _csrf
                        )
                    @endif

                    <!-- Section des horaires disponibles -->
                    @template.fragments.kholles.SessionSlots(
                        slots = sortedSlots
                    )

                    <!-- Section des affectations par créneau -->
                    @if(hasAssignments)
                        <div class="mb-8">
                            <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                                <i data-feather="check-circle" class="w-6 h-6"></i>
                                Affectations par créneau
                            </h2>

                            <!-- Alerte pour l'utilisateur connecté -->
                            @if(userAuthenticated && userAssignment != null)
                                @template.fragments.kholles.UserAssignmentAlert(
                                    assignment = userAssignment
                                )
                            @endif

                            <div class="space-y-4">
                                @for(KholleSlot slot : sortedSlots)
                                    !{List<KholleAssignment> slotAssignments = assignmentsBySlot.getOrDefault(slot.id(), List.of());}
                                    @if(!slotAssignments.isEmpty())
                                        @template.fragments.kholles.SlotAssignmentCard(
                                            slot = slot,
                                            assignments = slotAssignments
                                        )
                                    @endif
                                @endfor
                            </div>
                        </div>
                    @endif

                    <!-- Section des préférences des utilisateurs (admin uniquement) -->
                    @if(isAdmin)
                        <div class="mb-8">
                            <div class="flex flex-col gap-2 sm:flex-row sm:justify-between sm:items-center mb-4">
                                <h2 class="text-xl sm:text-2xl font-semibold text-ctp-blue flex items-center gap-2">
                                    <i data-feather="users" class="w-5 h-5 sm:w-6 sm:h-6"></i>
                                    Préférences des utilisateurs
                                </h2>
                                <div class="text-xs sm:text-sm text-ctp-subtext0 bg-ctp-surface1 px-3 py-1 rounded-full">
                                    ${registeredUsersCount} utilisateur${registeredUsersCount > 1 ? "s ont" : " a"}
                                    enregistré ${registeredUsersCount > 1 ? "leurs" : "ses"} préférences
                                </div>
                            </div>

                            @if(userPreferences.isEmpty())
                                <div class="bg-ctp-surface1 rounded-lg p-4 sm:p-6 text-center">
                                    <p class="text-ctp-subtext0">
                                        Aucune préférence n'a encore été enregistrée pour cette session.
                                    </p>
                                </div>
                            @else
                                <div class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4 sm:gap-6">
                                    @for(var userEntry : userPreferences.entrySet())
                                        !{
                                            User user = userEntry.getKey();
                                            List<UserPreference> preferences = userEntry.getValue();
                                            List<KholleSlot> unavailableSlots = userUnavailableSlots.get(user);
                                        }
                                        <div class="bg-ctp-surface1 rounded-lg p-3 sm:p-4 break-inside-avoid">
                                            <h3 class="text-base sm:text-lg font-semibold mb-3 text-ctp-blue break-words">
                                                ${user.username()}
                                            </h3>

                                            <!-- Préférences -->
                                            @if(!preferences.isEmpty())
                                                <div class="mb-3 sm:mb-4">
                                                    <h4 class="text-xs sm:text-sm font-medium text-ctp-green mb-2 flex items-center gap-1">
                                                        <span class="inline-block w-3 h-3 sm:w-4 sm:h-4">✓</span>
                                                        Préférences
                                                    </h4>
                                                    <div class="space-y-1 sm:space-y-2">
                                                        @for(UserPreference preference : preferences)
                                                            <div class="flex items-center gap-2 text-xs sm:text-sm">
                                                                <span class="inline-flex items-center justify-center w-5 h-5 sm:w-6 sm:h-6 rounded-full flex-shrink-0
                                                                    @if(preference.preferenceRank() == 1)
                                                                        bg-ctp-green text-ctp-base
                                                                    @elseif(preference.preferenceRank() == 2)
                                                                        bg-ctp-yellow text-ctp-base
                                                                    @elseif(preference.preferenceRank() == 3)
                                                                        bg-ctp-peach text-ctp-base
                                                                    @else
                                                                        bg-ctp-surface2 text-ctp-text
                                                                    @endif
                                                                    font-semibold text-xs">
                                                                    ${preference.preferenceRank()}
                                                                </span>
                                                                <span class="text-ctp-text leading-tight min-w-0 break-words">
                                                                    ${preference.slot().dateTime().format(DateTimeFormatter.ofPattern("dd/MM à HH:mm", Locale.FRENCH))}
                                                                </span>
                                                            </div>
                                                        @endfor
                                                    </div>
                                                </div>
                                            @endif

                                            <!-- Indisponibilités -->
                                            @if(unavailableSlots != null && !unavailableSlots.isEmpty())
                                                <div class="mb-2">
                                                    <h4 class="text-xs sm:text-sm font-medium text-ctp-red mb-2 flex items-center gap-1">
                                                        <span class="inline-block w-3 h-3 sm:w-4 sm:h-4">✗</span>
                                                        Indisponibilités
                                                    </h4>
                                                    <div class="space-y-1 sm:space-y-2">
                                                        @for(KholleSlot slot : unavailableSlots)
                                                            <div class="flex items-center gap-2 text-xs sm:text-sm">
                                                                <span class="inline-flex items-center justify-center w-5 h-5 sm:w-6 sm:h-6 rounded-full bg-ctp-red text-ctp-base font-semibold text-xs flex-shrink-0">
                                                                    ✗
                                                                </span>
                                                                <span class="text-ctp-subtext0 leading-tight min-w-0 break-words">
                                                                    ${slot.dateTime().format(DateTimeFormatter.ofPattern("dd/MM à HH:mm", Locale.FRENCH))}
                                                                </span>
                                                            </div>
                                                        @endfor
                                                    </div>
                                                </div>
                                            @endif

                                            @if(preferences.isEmpty() && (unavailableSlots == null || unavailableSlots.isEmpty()))
                                                <p class="text-ctp-subtext0 italic text-xs sm:text-sm">
                                                    Aucune préférence enregistrée.
                                                </p>
                                            @endif
                                        </div>
                                    @endfor
                                </div>
                            @endif
                        </div>
                    @endif
                `
            )
        </div>

        <script src="/js/dialog-manager.js"></script>
    `
)
