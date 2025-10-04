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
            <!-- Indicateur d'utilisateur connecté -->
            @template.components.UserHeader(username = currentUser.username())

            <!-- En-tête -->
            <div class="mb-6">
                <h1 class="text-2xl sm:text-3xl font-bold mb-4 break-words">
                    Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
                </h1>
            </div>

            @template.components.Card(
                title = "Préférences déjà soumises",
                content = @`
                    <div class="mb-6 text-center">
                        <div class="mx-auto mb-6 p-4 rounded-full bg-ctp-overlay0 inline-flex">
                            <i data-feather="lock" class="w-12 h-12 text-ctp-text"></i>
                        </div>
                        <h2 class="text-xl font-bold mb-4">Vos préférences sont déjà enregistrées</h2>
                        <p class="text-ctp-subtext0 mb-6">
                            Vous avez déjà soumis vos préférences pour cette séance de khôlle.
                            Une fois validées, les préférences ne peuvent plus être modifiées.
                        </p>
                    </div>

                    <div class="flex flex-col sm:flex-row justify-center gap-4 mt-8">
                        @template.components.Button(
                            href = "/kholles",
                            variant = "primary",
                            content = @`
                                <i data-feather="arrow-left" class="mr-2 w-4 h-4"></i>
                                Retour à la liste des khôlles
                            `
                        )
                    </div>
                `
            )
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
            });
        </script>
    `
)
