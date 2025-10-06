@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session
@param User currentUser
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Préférences verrouillées",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-6xl">
            <!-- Breadcrumb -->
            <div class="mb-4">
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
                        <span class="text-ctp-text">Préférences</span>
                    `
                )
            </div>

            <!-- Indicateur d'utilisateur connecté -->
            @template.components.layout.UserHeader(username = currentUser.username())

            <!-- En-tête -->
            <div class="mb-6">
                <h1 class="text-2xl sm:text-3xl font-bold mb-4 break-words">
                    Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
                </h1>
            </div>

            @template.components.ui.Card(
                title = "Préférences déjà soumises",
                content = @`
                    <div class="mb-6 text-center">
                        <div class="mx-auto mb-6 p-4 rounded-full bg-ctp-overlay0 inline-flex">
                            <i class="fa-solid fa-lock"></i>
                        </div>
                        <h2 class="text-xl font-bold mb-4 text-ctp-blue flex items-center justify-center gap-2">
                            <i class="fa-solid fa-circle-check"></i>

                            Vos préférences sont déjà enregistrées
                        </h2>
                        <p class="text-ctp-subtext0 mb-6">
                            Vous avez déjà soumis vos préférences pour cette séance de khôlle.
                            Une fois validées, les préférences ne peuvent plus être modifiées.
                        </p>
                    </div>

                    <div class="flex flex-col sm:flex-row justify-center gap-4 mt-8">
                        <a href="/kholles" class="button primary">
                            <i class="fa-solid fa-arrow-left"></i>

                            Retour à la liste des khôlles
                        </a>
                    </div>
                `
            )
        </div>
    `
)
