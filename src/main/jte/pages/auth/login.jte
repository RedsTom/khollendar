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

                    <div class="form-field">
                        <label for="username">Nom d'utilisateur</label>
                        <input type="text" id="username" name="username" required>
                    </div>

                    <div class="form-field">
                        <label for="password">Mot de passe</label>
                        <input type="password" id="password" name="password" required>
                    </div>

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
