@param String username
@param String error

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Définir votre code secret",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh] px-4">
        @template.components.UserCodeForm(
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
`)
