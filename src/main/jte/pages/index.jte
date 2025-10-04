@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.utils.AuthUtils
@import java.util.List

@param String title
@param String content
@param List<KholleSession> upcomingSessions
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Accueil",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- En-tête de bienvenue -->
            <div class="rounded-lg mb-4">
                <h1 class="text-3xl font-bold mb-4">
                    Bienvenue sur Khôlle'n'dar
                </h1>
                <p class="text-xl text-ctp-subtext0">
                    Visualisez, planifiez et inscrivez-vous aux khôlles en toute simplicité
                    !
                </p>
            </div>

            <!-- Cartes d'action admin -->
            @if(AuthUtils.admin())
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    @template.components.Card(
                        title = "Créer une nouvelle session",
                        content = @`
                            <p class="text-ctp-subtext0 mb-4">
                                Ajoutez une nouvelle session de khôlle pour vos étudiants
                            </p>
                            @template.components.Button(
                                href = "/kholles/create",
                                variant = "primary",
                                content = @`Créer une session`
                            )
                        `
                    )

                    @template.components.Card(
                        title = "Gérer les utilisateurs",
                        content = @`
                            <p class="text-ctp-subtext0 mb-4">
                                Créez et gérez les utilisateurs de l'application
                            </p>
                            @template.components.Button(
                                href = "/admin/users",
                                variant = "primary",
                                content = @`Gérer les utilisateurs`
                            )
                        `
                    )
                </div>
            @endif

            <!-- Prochaines sessions -->
            @template.components.Card(
                title = "Prochaines sessions de khôlles",
                content = @`
                    @if(upcomingSessions == null || upcomingSessions.isEmpty())
                        <p class="text-ctp-subtext0 py-4">
                            Aucune session de khôlle à venir
                        </p>
                    @else
                        <div class="space-y-4">
                            @for(KholleSession session : upcomingSessions)
                                @template.components.KholleSession(session = session)
                            @endfor
                        </div>
                    @endif

                    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mt-4">
                        @template.components.Button(
                            href = "/kholles",
                            variant = "link",
                            extraClasses = "flex items-center my-4 sm:my-0",
                            content = @`
                                Voir toutes les sessions
                                <i data-feather="arrow-right" class="ml-1 w-4 h-4"></i>
                            `
                        )
                    </div>
                `
            )

            @template.components.HowItWorks()
        </div>
    `
)
