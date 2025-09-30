@param String username
@param String error

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Entrer votre code secret",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        @template.components.Card(
        title = "Connexion utilisateur",
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

            <form action="/user-auth/enter-code" method="post" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                @template.components.FormField(
                type = "password",
                id = "secretCode",
                name = "secretCode",
                label = "Code secret à 6 chiffres",
                pattern = "[0-9]{6}",
                maxlength = "6",
                inputmode = "numeric",
                required = true
                )

                <div class="pt-2">
                    @template.components.Button(
                    type = "submit",
                    variant = "primary",
                    extraClasses = "w-full",
                    content = @`Se connecter`
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
