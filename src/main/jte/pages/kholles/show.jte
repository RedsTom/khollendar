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

!{boolean userAuthenticated = httpSession != null && httpSession.getAttribute("selectedUserId") != null;}
!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
    title = "Détails de la session",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <div class="bg-ctp-surface0 rounded-lg p-6">
                <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start mb-4">
                    <div>
                        <h1 class="text-3xl font-bold">${session.subject()}</h1>
                        @if(session.calculateDateRange().isPresent())
                            <p class="text-ctp-subtext0">
                                Du ${session.calculateDateRange().get().start().format(formatter)}
                                au ${session.calculateDateRange().get().end().format(formatter)}
                            </p>
                        @endif
                    </div>

                    <div class="mt-4 sm:mt-0">
                        @if(userAuthenticated)
                            <a href="/kholles/${session.id()}/preferences" class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-md hover:bg-ctp-sapphire transition-colors">
                                Indiquer mes disponibilités
                            </a>
                        @else
                            <a href="/user-auth/select?redirectTo=/kholles/${session.id()}/preferences" class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-md hover:bg-ctp-sapphire transition-colors">
                                Indiquer mes disponibilités
                            </a>
                        @endif
                    </div>
                </div>

                <div class="mt-6">
                    <h2 class="text-2xl font-semibold mb-4">Horaires disponibles</h2>
                    @if(session.kholleSlots().isEmpty())
                        <p class="text-ctp-subtext0">Aucun horaire disponible pour cette session.</p>
                    @else
                        !{
                            List<KholleSlot> sortedSlots = new ArrayList<>(session.kholleSlots());
                            sortedSlots.sort(Comparator.comparing(KholleSlot::dateTime));
                        }
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            @for(KholleSlot slot : sortedSlots)
                                <div class="bg-ctp-surface1 p-4 rounded-lg flex justify-between items-center">
                                    <div>
                                        <p class="font-semibold">${slot.dateTime().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH))}</p>
                                    </div>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>

                <!-- Section des préférences des utilisateurs -->
                <div class="mt-8">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-2xl font-semibold">Préférences des utilisateurs</h2>
                        <div class="text-sm text-ctp-subtext0">
                            ${registeredUsersCount} utilisateur${registeredUsersCount > 1 ? "s ont" : " a"} enregistré ${registeredUsersCount > 1 ? "leurs" : "ses"} préférences
                        </div>
                    </div>

                    @if(userPreferences.isEmpty())
                        <div class="bg-ctp-surface1 rounded-lg p-6 text-center">
                            <p class="text-ctp-subtext0">Aucune préférence n'a encore été enregistrée pour cette session.</p>
                        </div>
                    @else
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            @for(var userEntry : userPreferences.entrySet())
                                !{
                                    User user = userEntry.getKey();
                                    List<UserPreference> preferences = userEntry.getValue();
                                    List<KholleSlot> unavailableSlots = userUnavailableSlots.get(user);
                                }
                                <div class="bg-ctp-surface1 rounded-lg p-4">
                                    <h3 class="text-lg font-semibold mb-3 text-ctp-blue">
                                        ${user.username()}
                                    </h3>

                                    <!-- Préférences -->
                                    @if(!preferences.isEmpty())
                                        <div class="mb-4">
                                            <h4 class="text-sm font-medium text-ctp-green mb-2">✓ Préférences</h4>
                                            <div class="space-y-1">
                                                @for(UserPreference preference : preferences)
                                                    <div class="flex items-center gap-2 text-sm">
                                                        <span class="inline-flex items-center justify-center w-6 h-6 rounded-full
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
                                                        <span class="text-ctp-text">
                                                            ${preference.slot().dateTime().format(DateTimeFormatter.ofPattern("dd/MM à HH:mm", Locale.FRENCH))}
                                                        </span>
                                                    </div>
                                                @endfor
                                            </div>
                                        </div>
                                    @endif

                                    <!-- Indisponibilités -->
                                    @if(unavailableSlots != null && !unavailableSlots.isEmpty())
                                        <div>
                                            <h4 class="text-sm font-medium text-ctp-red mb-2">✗ Indisponibilités</h4>
                                            <div class="space-y-1">
                                                @for(KholleSlot slot : unavailableSlots)
                                                    <div class="flex items-center gap-2 text-sm">
                                                        <span class="inline-flex items-center justify-center w-6 h-6 rounded-full bg-ctp-red text-ctp-base font-semibold text-xs">
                                                            ✗
                                                        </span>
                                                        <span class="text-ctp-subtext0">
                                                            ${slot.dateTime().format(DateTimeFormatter.ofPattern("dd/MM à HH:mm", Locale.FRENCH))}
                                                        </span>
                                                    </div>
                                                @endfor
                                            </div>
                                        </div>
                                    @endif

                                    @if(preferences.isEmpty() && (unavailableSlots == null || unavailableSlots.isEmpty()))
                                        <p class="text-ctp-subtext0 italic text-sm">Aucune préférence enregistrée.</p>
                                    @endif
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
    `
)
