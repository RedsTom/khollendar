@import java.util.List
@import fr.redstom.khollendar.entity.User
@import org.springframework.security.web.csrf.CsrfToken

@param List<User> users
@param CsrfToken _csrf

@template.layout.MainLayout(
title = "Connexion utilisateur",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <!-- Breadcrumb -->
        <div class="mb-6">
            @template.components.navigation.Breadcrumb(content = @`
                <a href="/" class="hover:text-ctp-blue transition-colors">
                    Accueil
                </a>
                <i data-feather="chevron-right" class="w-4 h-4"></i>
                <span class="text-ctp-text">Connexion utilisateur</span>
            `)
        </div>

        <div class="flex justify-center items-center min-h-[70vh] px-4">
            <div
                    id="form-container"
                    class="w-full flex items-center justify-center"
                    hx-on::afterSwap="feather.replace()"
            >
                @template.fragments.auth.UserSelectionForm(users = users, _csrf = _csrf)
            </div>
        </div>
    </div>
`
)
