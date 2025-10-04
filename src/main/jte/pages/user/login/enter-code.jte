@param String username
@param String error
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Entrer votre code secret",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/user-auth/select" class="hover:text-ctp-blue transition-colors">
                            Connexion utilisateur
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Entrer le code</span>
                    `
                )
            </div>

            <div class="flex justify-center items-center min-h-[70vh] px-4">
                @template.components.UserCodeForm(
                    username = username,
                    error = error,
                    cardTitle = "Connexion utilisateur",
                    formAction = "/user-auth/enter-code",
                    inputLabel = "Code secret à 6 chiffres",
                    submitButtonText = "Se connecter",
                    _csrf = _csrf
                )
            </div>
        </div>
    `
)
