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
                            <h2 class="text-xl sm:text-2xl font-semibold mb-4">
                                Préférences des utilisateurs
                            </h2>
                            <p class="text-ctp-subtext0 mb-4">
                                ${registeredUsersCount} utilisateur${registeredUsersCount > 1 ? "s ont" : " a"} renseigné leurs préférences.
                            </p>

                            @if(userPreferences.isEmpty())
                                <p class="text-ctp-subtext0">Aucune préférence renseignée pour cette session.</p>
                            @else
                                <div class="space-y-4">
                                    @for(Map.Entry<User, List<UserPreference>> entry : userPreferences.entrySet())
                                        @template.fragments.kholles.UserPreferenceCard(
                                            user = entry.getKey(),
                                            preferences = entry.getValue(),
                                            unavailableSlots = userUnavailableSlots.get(entry.getKey())
                                        )
                                    @endfor
                                </div>
                            @endif
                        </div>
                    @endif
                `
            )
        </div>

        <script>
            // Script pour les modaux
            const renameBtn = document.getElementById('renameBtn');
            const renameModal = document.getElementById('renameModal');
            const cancelRenameBtn = document.getElementById('cancelRenameBtn');

            if (renameBtn && renameModal) {
                renameBtn.addEventListener('click', () => {
                    renameModal.showModal();
                });
                cancelRenameBtn.addEventListener('click', () => {
                    renameModal.close();
                });
            }

            const statusBtn = document.getElementById('statusBtn');
            const statusModal = document.getElementById('statusModal');
            const cancelStatusBtn = document.getElementById('cancelStatusBtn');
            const closeStatusModal = document.getElementById('closeStatusModal');

            if (statusBtn && statusModal) {
                statusBtn.addEventListener('click', () => {
                    statusModal.showModal();
                });
                cancelStatusBtn.addEventListener('click', () => {
                    statusModal.close();
                });
                closeStatusModal.addEventListener('click', () => {
                    statusModal.close();
                });
            }

            feather.replace();
        </script>
    `
)
