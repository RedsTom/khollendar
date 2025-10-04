@param String username
@param String error
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Définir votre code secret",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/user-auth/select" class="hover:text-ctp-blue transition-colors">
                            Connexion utilisateur
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Définir le code</span>
                    `
                )
            </div>

            <div class="flex justify-center items-center min-h-[70vh] px-4">
                @template.components.forms.UserCodeForm(
                    username = username,
                    error = error,
                    cardTitle = "Définir votre code secret",
                    formAction = "/user-auth/initialize-code",
                    inputLabel = "Code secret (6 chiffres)",
                    inputHelpText = "Votre code doit être composé de 6 chiffres uniquement.",
                    submitButtonText = "Définir mon code",
                    warningMessage = "C'est votre première connexion. Veuillez définir un code secret à 6 chiffres.",
                    _csrf = _csrf
                )
            </div>
        </div>
    `
)
