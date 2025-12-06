@param org.springframework.security.web.csrf.CsrfToken _csrf
@param fr.redstom.khollendar.entity.KholleSession session
@param java.util.List<fr.redstom.khollendar.dto.UserPreferenceSummary> groupedPreferences

@template.layout.MainLayout(
title = "Préférences des utilisateurs",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4 max-w-6xl">
    <div class="mb-6">
        @template.components.navigation.Breadcrumb(
        content = @`
            <a href="/" class="hover:text-ctp-blue transition-colors">
                Accueil
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                Sessions de khôlles
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                ${session.subject()}
            </a>
            <i class="fa-solid fa-chevron-right"></i>
            <span class="text-ctp-text">Gestion des préférences</span>
        `
        )
    </div>


    @template.components.ui.Card(
    content = @`
        @template.fragments.kholles.SessionHeader(
            session = session,
            actionButtons = @``
        )


        <!-- Vue en tableau pour les écrans moyens et grands -->
        <div class="hidden md:block overflow-x-auto" id="preferences-table">
            <table class="min-w-full">
                <thead class="bg-ctp-mantle">
                    <tr>
                        <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                            Utilisateur
                        </th>
                        <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                            Nombre de préférences
                        </th>
                        <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                            Créneaux (IDs)
                        </th>
                        <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                            Dates
                        </th>
                        <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                            Actions
                        </th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-ctp-surface1">
                    @for (fr.redstom.khollendar.dto.UserPreferenceSummary summary : groupedPreferences)
                        @template.fragments.admin.KholleAssignemntsTableRow(summary = summary, sessionId = session.id())
                    @endfor
                </tbody>
            </table>
        </div>
    `)
    </div>
`)