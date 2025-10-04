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
!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);}
!{DateTimeFormatter detailedFormatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

!{
    List<KholleSlot> sortedSlots = new ArrayList<>(session.kholleSlots());
    sortedSlots.sort(Comparator.comparing(KholleSlot::dateTime));
}

@template.layout.MainLayout(
    title = "Détails de la session",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-7xl">
            @template.components.Card(
                content = @`
                    <!-- En-tête de la session -->
                    <div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-start mb-6">
                        <div class="flex-1 min-w-0">
                            <div class="flex flex-wrap items-center gap-3 mb-2">
                                <h1 class="text-2xl sm:text-3xl font-bold break-words">
                                    ${session.subject()}
                                </h1>
                                @template.components.StatusBadge(status = session.status())
                            </div>
                            @if(session.calculateDateRange().isPresent())
                                <p class="text-sm sm:text-base text-ctp-subtext0 mt-1">
                                    Du ${session.calculateDateRange().get().start().format(formatter)}
                                    au ${session.calculateDateRange().get().end().format(formatter)}
                                </p>
                            @endif
                        </div>

                        <!-- Boutons d'action -->
                        <div class="flex gap-2 flex-wrap">
                            @if(hasAssignments)
                                @template.components.Button(
                                    href = "/kholles/" + session.id() + "/assignments",
                                    variant = "primary",
                                    content = @`
                                        <i data-feather="check-circle" class="mr-2"></i>
                                        Voir les détails des affectations
                                    `
                                )
                            @endif

                            @if(userAuthenticated)
                                @if(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_OPEN)
                                    @template.components.Button(
                                        href = "/kholles/" + session.id() + "/preferences",
                                        variant = "primary",
                                        content = @`Indiquer mes disponibilités`
                                    )
                                @else
                                    @template.components.Button(
                                        variant = "secondary",
                                        disabled = true,
                                        content = @`Inscriptions fermées`
                                    )
                                @endif
                            @else
                                @if(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_OPEN)
                                    @template.components.Button(
                                        href = "/user-auth/select?redirectTo=/kholles/" + session.id() + "/preferences",
                                        variant = "primary",
                                        content = @`Indiquer mes disponibilités`
                                    )
                                @else
                                    @template.components.Button(
                                        variant = "secondary",
                                        disabled = true,
                                        content = @`Inscriptions fermées`
                                    )
                                @endif
                            @endif
                        </div>
                    </div>

                    <!-- Section Actions administrateur -->
                    @if(isAdmin)
                        <div class="mb-8 p-4 bg-ctp-surface0/50 rounded-lg border border-ctp-surface2">
                            <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue">
                                <i data-feather="settings" class="inline-block w-5 h-5 sm:w-6 sm:h-6 mr-2"></i>
                                Actions administrateur
                            </h2>
                            <div class="flex gap-2 flex-wrap">
                                <!-- Bouton pour déclencher l'affectation -->
                                <form action="/kholles/${session.id()}/assignments/trigger"
                                      method="post"
                                      class="inline"
                                      onsubmit="return confirm('Êtes-vous sûr de vouloir déclencher l\'affectation pour cette session ? Les affectations existantes seront écrasées.');">
                                    <input type="hidden"
                                           name="${_csrf.getParameterName()}"
                                           value="${_csrf.getToken()}"/>
                                    <button type="submit"
                                            class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-green focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-green hover:bg-ctp-green/80 text-ctp-base border-0">
                                        <i data-feather="zap" class="mr-2"></i>
                                        Déclencher l'affectation
                                    </button>
                                </form>

                                @if(session.status() != fr.redstom.khollendar.entity.KholleSessionStatus.RESULTS_AVAILABLE)
                                    <button type="button"
                                            id="statusBtn"
                                            class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0">
                                        <i data-feather="toggle-right" class="mr-2"></i>
                                        Changer le statut
                                    </button>
                                @endif

                                <button type="button"
                                        id="renameBtn"
                                        class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0">
                                    <i data-feather="edit-2" class="mr-2"></i>
                                    Renommer
                                </button>

                                <form action="/kholles/${session.id()}/delete"
                                      method="post"
                                      onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette session de khôlles ? Cette action est irréversible.');"
                                      class="inline">
                                    <input type="hidden"
                                           name="${_csrf.getParameterName()}"
                                           value="${_csrf.getToken()}"/>
                                    <button type="submit"
                                            class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-red focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-red hover:bg-ctp-red/80 text-ctp-base border-0">
                                        <i data-feather="trash-2" class="mr-2"></i>
                                        Supprimer la session
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Modal de renommage -->
                        <style>
                            #renameModal {
                                margin: auto;
                            }
                            #renameModal::backdrop {
                                background-color: rgba(0, 0, 0, 0.3);
                            }
                            #statusModal {
                                margin: auto;
                            }
                            #statusModal::backdrop {
                                background-color: rgba(0, 0, 0, 0.3);
                            }
                        </style>

                        <dialog id="renameModal"
                                class="rounded-lg shadow-xl max-w-md w-[calc(100%-1rem)] sm:w-full p-0 bg-transparent border-0">
                            <div class="bg-ctp-base rounded-lg p-6">
                                <div class="flex justify-between items-center mb-4">
                                    <h2 class="text-xl font-bold text-ctp-text">Renommer la session</h2>
                                </div>
                                <form action="/kholles/${session.id()}/rename" method="post">
                                    <input type="hidden"
                                           name="${_csrf.getParameterName()}"
                                           value="${_csrf.getToken()}"/>
                                    <div class="mb-4">
                                        <label for="newSubject"
                                               class="block text-sm font-medium text-ctp-text mb-2">
                                            Nouveau nom de la session
                                        </label>
                                        <input type="text"
                                               id="newSubject"
                                               name="newSubject"
                                               value="${session.subject()}"
                                               required
                                               class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface2 rounded-lg text-ctp-text focus:outline-none focus:ring-2 focus:ring-ctp-blue"/>
                                    </div>
                                    <div class="flex gap-2 justify-end">
                                        <button type="button"
                                                id="cancelRenameBtn"
                                                class="px-4 py-2 bg-ctp-surface0 text-ctp-text rounded-lg hover:bg-ctp-surface1 transition-colors">
                                            Annuler
                                        </button>
                                        <button type="submit"
                                                class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-lg hover:bg-ctp-sapphire transition-colors">
                                            Renommer
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </dialog>

                        <!-- Modal de changement de statut -->
                        <dialog id="statusModal"
                                class="rounded-lg shadow-xl max-w-md w-[calc(100%-0.5rem)] sm:w-full p-0 bg-transparent border-0">
                            <div class="bg-ctp-base rounded-lg p-6">
                                <div class="flex justify-between items-center mb-4">
                                    <h2 class="text-xl font-bold text-ctp-text">Changer le statut</h2>
                                    <button id="closeStatusModal"
                                            type="button"
                                            class="text-ctp-subtext0 hover:text-ctp-text">
                                        <i data-feather="x"></i>
                                    </button>
                                </div>
                                <form action="/kholles/${session.id()}/status" method="post">
                                    <input type="hidden"
                                           name="${_csrf.getParameterName()}"
                                           value="${_csrf.getToken()}"/>
                                    <div class="mb-4">
                                        <label class="block text-sm font-medium text-ctp-text mb-3">
                                            Sélectionnez le nouveau statut
                                        </label>
                                        <div class="space-y-2">
                                            <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                                                <input type="radio"
                                                       name="status"
                                                       value="REGISTRATIONS_OPEN"
                                                       class="mr-3 text-ctp-green focus:ring-ctp-green flex-shrink-0"/>
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-green/20 text-ctp-green border border-ctp-green/30">
                                                    Inscriptions ouvertes
                                                </span>
                                            </label>

                                            <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                                                <input type="radio"
                                                       name="status"
                                                       value="REGISTRATIONS_CLOSED"
                                                       class="mr-3 text-ctp-red focus:ring-ctp-red flex-shrink-0"/>
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-red/20 text-ctp-red border border-ctp-red/30">
                                                    Inscriptions fermées
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="flex gap-2 justify-end">
                                        <button type="button"
                                                id="cancelStatusBtn"
                                                class="px-4 py-2 bg-ctp-surface0 text-ctp-text rounded-lg hover:bg-ctp-surface1 transition-colors">
                                            Annuler
                                        </button>
                                        <button type="submit"
                                                class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-lg hover:bg-ctp-sapphire transition-colors">
                                            Modifier
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </dialog>
                    @endif

                    <!-- Section des horaires disponibles -->
                    <div class="mb-8">
                        <h2 class="text-xl sm:text-2xl font-semibold mb-4">Horaires disponibles</h2>
                        @if(session.kholleSlots().isEmpty())
                            <p class="text-ctp-subtext0">Aucun horaire disponible pour cette session.</p>
                        @else
                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 sm:gap-4">
                                @for(KholleSlot slot : sortedSlots)
                                    <div class="bg-ctp-surface1 p-3 sm:p-4 rounded-lg">
                                        <p class="font-semibold text-sm sm:text-base leading-tight">
                                            ${slot.dateTime().format(detailedFormatter)}
                                        </p>
                                    </div>
                                @endfor
                            </div>
                        @endif
                    </div>

                    <!-- Section des affectations par créneau -->
                    @if(hasAssignments)
                        <div class="mb-8">
                            <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
                                <i data-feather="check-circle" class="w-6 h-6"></i>
                                Affectations par créneau
                            </h2>

                            <!-- Alerte pour l'utilisateur connecté -->
                            @if(userAuthenticated && userAssignment != null)
                                <div class="mb-4 p-4 rounded-lg border-2 @if(userAssignment.obtainedPreferenceRank() != null && userAssignment.obtainedPreferenceRank() == 1) border-ctp-green bg-ctp-green/10 @else border-ctp-blue bg-ctp-blue/10 @endif">
                                    <div class="flex items-start gap-3">
                                        <i data-feather="calendar"
                                           class="w-5 h-5 mt-0.5 flex-shrink-0 @if(userAssignment.obtainedPreferenceRank() != null && userAssignment.obtainedPreferenceRank() == 1) text-ctp-green @else text-ctp-blue @endif"></i>
                                        <div class="flex-1">
                                            <h3 class="font-semibold text-lg mb-1">Votre créneau affecté</h3>
                                            <p class="text-base mb-2">
                                                <strong>${userAssignment.slot().dateTime().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH))}</strong>
                                            </p>
                                            @if(userAssignment.obtainedPreferenceRank() != null)
                                                @if(userAssignment.obtainedPreferenceRank() == 1)
                                                    <p class="text-sm text-ctp-green">
                                                        🎉 Vous avez obtenu votre <strong>premier choix</strong> !
                                                    </p>
                                                @else
                                                    <p class="text-sm">
                                                        Vous avez obtenu votre <strong>choix n°${userAssignment.obtainedPreferenceRank()}</strong>
                                                    </p>
                                                @endif
                                            @else
                                                <p class="text-sm text-ctp-subtext0">
                                                    Affectation aléatoire (aucune préférence renseignée ou satisfaite)
                                                </p>
                                            @endif
                                        </div>
                                    </div>
                                </div>
                            @endif

                            <div class="space-y-4">
                                @for(KholleSlot slot : sortedSlots)
                                    !{List<KholleAssignment> slotAssignments = assignmentsBySlot.getOrDefault(slot.id(), List.of());}
                                    @if(!slotAssignments.isEmpty())
                                        <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
                                            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-3 pb-3 border-b border-ctp-surface2">
                                                <div>
                                                    <h3 class="text-lg font-semibold text-ctp-text flex items-center gap-2">
                                                        <i data-feather="clock" class="w-5 h-5"></i>
                                                        ${slot.dateTime().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH))}
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

                                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-2">
                                                @for(KholleAssignment assignment : slotAssignments.stream().sorted((a, b) -> a.user().username().compareTo(b.user().username())).toList())
                                                    <div class="bg-ctp-base rounded-lg p-3 border border-ctp-surface1 flex items-center justify-between gap-2">
                                                        <div class="flex items-center gap-2 min-w-0 flex-1">
                                                            <i data-feather="user" class="w-4 h-4 text-ctp-blue flex-shrink-0"></i>
                                                            <span class="font-medium text-ctp-text truncate">
                                                                ${assignment.user().username()}
                                                            </span>
                                                        </div>
                                                        @template.components.AssignmentBadge(
                                                            preferenceRank = assignment.obtainedPreferenceRank()
                                                        )
                                                    </div>
                                                @endfor
                                            </div>
                                        </div>
                                    @endif
                                @endfor
                            </div>
                        </div>
                    @endif

                    <!-- Section des préférences des utilisateurs -->
                    <div>
                        <div class="flex flex-col gap-2 sm:flex-row sm:justify-between sm:items-center mb-4">
                            <h2 class="text-xl sm:text-2xl font-semibold">Préférences des utilisateurs</h2>
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
                `
            )
        </div>

        <script src="/js/dialog-manager.js"></script>
    `
)
