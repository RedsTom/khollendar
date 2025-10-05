@import org.springframework.security.web.csrf.CsrfToken

@param CsrfToken _csrf
@param String title
@param boolean error

@template.layout.MainLayout(
    title = title,
    _csrf = _csrf,
    content = @`
        <div class="flex justify-center items-center min-h-[80vh] px-4">
            <div class="w-full max-w-md">
                @template.components.ui.Card(
                    title = "Connexion administrateur",
                    extraClasses = "shadow-lg",
                    content = @`
                        @template.fragments.auth.LoginForm(
                            _csrf = _csrf,
                            error = error
                        )
                    `)
            </div>
        </div>
    `)
