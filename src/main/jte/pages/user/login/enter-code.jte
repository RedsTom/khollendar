@param String username
@param String error

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Entrer votre code secret",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh] px-4">
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
`)
