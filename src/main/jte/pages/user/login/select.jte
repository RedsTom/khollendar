@param java.util.List<fr.redstom.khollendar.entity.User> users
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{
    java.util.List<fr.redstom.khollendar.entity.User> sortedUsers = users.stream()
        .sorted((u1, u2) -> u1.username().compareToIgnoreCase(u2.username()))
        .toList();
}

@template.layout.MainLayout(
    title = "Connexion utilisateur",
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
                        <span class="text-ctp-text">Connexion utilisateur</span>
                    `
                )
            </div>

            <div class="flex justify-center items-center min-h-[70vh] px-4">
                @template.components.Card(
                    title = "Connexion utilisateur",
                    extraClasses = "w-full max-w-md shadow-lg",
                    content = @`
                        @if(users.isEmpty())
                            @template.components.Alert(
                                type = "warning",
                                body = @`Aucun utilisateur disponible. Veuillez contacter l'administrateur.`
                            )
                        @else
                            @template.components.Alert(
                                type = "warning",
                                body = @`Vous ne vous voyez pas dans la liste ? Contactez l'administrateur pour qu'il crée votre compte.`
                            )

                            <form action="/user-auth/select" method="post" class="space-y-6">
                                <input type="hidden"
                                       name="${_csrf.getParameterName()}"
                                       value="${_csrf.getToken()}">

                                <div class="form-field">
                                    <label for="userId">Sélectionner votre nom d'utilisateur</label>
                                    <select id="userId" name="userId" required>
                                        <option value="">-- Sélectionner un utilisateur --</option>
                                        @for(fr.redstom.khollendar.entity.User user : sortedUsers)
                                            <option value="${user.id()}">${user.username()}</option>
                                        @endfor
                                    </select>
                                </div>

                                <div class="pt-2">
                                    @template.components.Button(
                                        type = "submit",
                                        variant = "primary",
                                        extraClasses = "w-full",
                                        content = @`Continuer`
                                    )
                                </div>
                            </form>
                        @endif
                    `
                )
            </div>
        </div>
    `
)
