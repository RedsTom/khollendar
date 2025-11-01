@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.utils.AuthUtils
@import java.util.List

@param String title
@param List<KholleSession> upcomingSessions
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Accueil",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- En-tête de bienvenue -->
            @template.fragments.common.WelcomeSection(
                title = "Bienvenue sur Khôlle'n'dar",
                description = "Visualisez, planifiez et inscrivez-vous aux khôlles en toute simplicité !"
            )

            <!-- Cartes d'action admin -->
            @if(AuthUtils.admin())
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    @template.components.ui.Card(
                        title = "Créer une nouvelle session",
                        content = @`
                            <p class="text-ctp-subtext0 mb-4">
                                Ajoutez une nouvelle session de khôlle pour vos étudiants
                            </p>
                            <a href="/kholles/create" class="button primary">
                                Créer une session
                            </a>
                        `
                    )

                    @template.components.ui.Card(
                        title = "Gérer les utilisateurs",
                        content = @`
                            <p class="text-ctp-subtext0 mb-4">
                                Créez et gérez les utilisateurs de l'application
                            </p>
                            <a href="/admin/users" class="button primary">
                                Gérer les utilisateurs
                            </a>
                        `
                    )
                </div>
            @endif

            <!-- Prochaines sessions -->
            @template.components.ui.Card(
                title = "Prochaines sessions de khôlles",
                content = @`
                    @if(upcomingSessions == null || upcomingSessions.isEmpty())
                        @template.fragments.common.EmptyState(
                            message = "Aucune session de khôlle à venir"
                        )
                    @else
                        <div class="space-y-4">
                            @for(KholleSession session : upcomingSessions)
                                @template.components.kholles.KholleSession(session = session)
                            @endfor
                        </div>
                    @endif

                    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mt-4">
                        <a href="/kholles" class="button flex items-center gap-1 my-4 sm:my-0">
                            Voir toutes les sessions
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                `
            )

            @template.components.content.HowItWorks()
        </div>
    `
)
