@param String title
@param String error
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = title,
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        <div class="w-full max-w-md">
            @template.components.Card(
            title = "Connexion administrateur",
            extraClasses = "shadow-lg",
            content = @`
                @if(error != null)
                    @template.components.Alert(
                    type = "error",
                    message = "Nom d'utilisateur ou mot de passe incorrect"
                    )
                @endif

                <form action="/login" method="post" class="space-y-6">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                    @template.components.FormField(
                    type = "text",
                    id = "username",
                    name = "username",
                    label = "Nom d'utilisateur",
                    required = true
                    )

                    @template.components.FormField(
                    type = "password",
                    id = "password",
                    name = "password",
                    label = "Mot de passe",
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
            `
            )
        </div>
    </div>
`)
