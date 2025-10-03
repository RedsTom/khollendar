@param String username
@param String error

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Définir votre code secret",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        @template.components.Card(
        title = "Définir votre code secret",
        extraClasses = "w-full max-w-md shadow-lg",
        content = @`
            @if (error != null)
                @template.components.Alert(
                type = "error",
                body = @`${error}`
                )
            @endif

            @template.components.Alert(
            type = "info",
            body = @`Utilisateur : <b>${username}</b>`
            )

            @template.components.Alert(
            type = "warning",
            body = @`C'est votre première connexion. Veuillez définir un code secret à 6 chiffres.`
            )

            <form action="/user-auth/initialize-code" method="post" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="form-field">
                    <label for="secretCode">Code secret (6 chiffres)</label>
                    <input type="password" id="secretCode" name="secretCode" pattern="[0-9]{6}" maxlength="6" inputmode="numeric" required>
                    <p class="help-text">Votre code doit être composé de 6 chiffres uniquement.</p>
                </div>

                <div class="pt-2">
                    @template.components.Button(
                    type = "submit",
                    variant = "primary",
                    extraClasses = "w-full",
                    content = @`Définir mon code`
                    )
                </div>
            </form>

            <div class="mt-4 text-center">
                @template.components.Button(
                href = "/user-auth/select",
                variant = "link",
                size = "sm",
                content = @`Retour à la sélection d'utilisateur`
                )
            </div>
        `
        )
    </div>
`)
