@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.entity.UserPreference
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

!{boolean userAuthenticated = httpSession != null && httpSession.getAttribute("selectedUserId") != null;}
!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
title = "Détails de la session",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4 max-w-7xl">
        @template.components.Card(
        content = @`
            <!-- En-tête de la session -->
            <div class="flex flex-col gap-4 lg:flex-row lg:justify-between lg:items-start mb-6">
                <div class="flex-1 min-w-0">
                    <h1 class="text-2xl sm:text-3xl font-bold break-words">${session.subject()}</h1>
                    @if(session.calculateDateRange().isPresent())
                        <p class="text-sm sm:text-base text-ctp-subtext0 mt-1">
                            Du ${session.calculateDateRange().get().start().format(formatter)}
                            au ${session.calculateDateRange().get().end().format(formatter)}
                        </p>
                    @endif
                </div>

                <div class="flex gap-2 flex-wrap">
                    @if(userAuthenticated)
                        @template.components.Button(
                        href = "/kholles/" + session.id() + "/preferences",
                        variant = "primary",
                        extraClasses = "w-full md:w-auto",
                        content = @`Indiquer mes disponibilités`
                        )
                    @else
                        @template.components.Button(
                        href = "/user-auth/select?redirectTo=/kholles/" + session.id() + "/preferences",
                        variant = "primary",
                        extraClasses = "w-full md:w-auto",
                        content = @`Indiquer mes disponibilités`
                        )
                    @endif

                    @if(isAdmin)
                        <button type="button" id="renameBtn"
                                class="w-full md:w-auto inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0">
                            <i data-feather="edit-2" class="mr-2"></i>
                            Renommer
                        </button>

                        <form action="/kholles/${session.id()}/delete" method="post"
                              onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette session de khôlles ? Cette action est irréversible.');"
                              class="inline w-full md:w-auto">
                            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>
                            @template.components.Button(
                            type = "submit",
                            variant = "danger",
                            extraClasses = "w-full md:w-auto",
                            content = @`
                                <i data-feather="trash-2" class="mr-2"></i>
                                Supprimer la session
                            `
                            )
                        </form>
                    @endif
                </div>
            </div>

            <!-- Modal de renommage -->
            @if(isAdmin)
                <style>
                    #renameModal {
                        margin: auto;
                    }
                    #renameModal::backdrop {
                        background-color: rgba(0, 0, 0, 0.3);
                    }
                </style>
                <dialog id="renameModal" class="rounded-lg shadow-xl max-w-md w-[calc(100%-1rem)] sm:w-full p-0 bg-transparent border-0">
                    <div class="bg-ctp-base rounded-lg p-6">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xl font-bold text-ctp-text">Renommer la session</h2>
                        </div>
                        <form action="/kholles/${session.id()}/rename" method="post">
                            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>
                            <div class="mb-4">
                                <label for="newSubject" class="block text-sm font-medium text-ctp-text mb-2">
                                    Nouveau nom de la session
                                </label>
                                <input
                                    type="text"
                                    id="newSubject"
                                    name="newSubject"
                                    value="${session.subject()}"
                                    required
                                    class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface2 rounded-lg text-ctp-text focus:outline-none focus:ring-2 focus:ring-ctp-blue"
                                />
                            </div>
                            <div class="flex gap-2 justify-end">
                                <button
                                    type="button"
                                    id="cancelRenameBtn"
                                    class="px-4 py-2 bg-ctp-surface0 text-ctp-text rounded-lg hover:bg-ctp-surface1 transition-colors">
                                    Annuler
                                </button>
                                <button
                                    type="submit"
                                    class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-lg hover:bg-ctp-sapphire transition-colors">
                                    Renommer
                                </button>
                            </div>
                        </form>
                    </div>
                </dialog>

                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        const renameBtn = document.getElementById('renameBtn');
                        const renameModal = document.getElementById('renameModal');
                        const closeBtn = document.getElementById('closeRenameModal');
                        const cancelBtn = document.getElementById('cancelRenameBtn');

                        if (renameBtn && renameModal) {
                            renameBtn.addEventListener('click', function() {
                                renameModal.showModal();
                            });
                        }

                        if (closeBtn && renameModal) {
                            closeBtn.addEventListener('click', function() {
                                renameModal.close();
                            });
                        }

                        if (cancelBtn && renameModal) {
                            cancelBtn.addEventListener('click', function() {
                                renameModal.close();
                            });
                        }
                    });
                </script>
            @endif

            <!-- Section des horaires disponibles -->
            <div class="mb-8">
                <h2 class="text-xl sm:text-2xl font-semibold mb-4">Horaires disponibles</h2>
                @if(session.kholleSlots().isEmpty())
                    <p class="text-ctp-subtext0">Aucun horaire disponible pour cette session.</p>
                @else
                    !{
                                List<KholleSlot> sortedSlots = new ArrayList<>(session.kholleSlots());
                                sortedSlots.sort(Comparator.comparing(KholleSlot::dateTime));
                            }
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 sm:gap-4">
                        @for(KholleSlot slot : sortedSlots)
                            <div class="bg-ctp-surface1 p-3 sm:p-4 rounded-lg">
                                <p class="font-semibold text-sm sm:text-base leading-tight">
                                    ${slot.dateTime().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH))}
                                </p>
                            </div>
                        @endfor
                    </div>
                @endif
            </div>

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
                        <p class="text-ctp-subtext0">Aucune préférence n'a encore été enregistrée pour cette
                            session.</p>
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
                                    <p class="text-ctp-subtext0 italic text-xs sm:text-sm">Aucune préférence
                                        enregistrée.</p>
                                @endif
                            </div>
                        @endfor
                    </div>
                @endif
            </div>
        `
        )
    </div>
`
)
