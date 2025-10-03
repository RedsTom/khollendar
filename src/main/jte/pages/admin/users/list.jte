@param org.springframework.data.domain.Page<fr.redstom.khollendar.entity.User> users
@param int currentPage

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Gestion des utilisateurs",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="mb-6">
            <h1 class="text-2xl font-bold">Gestion des utilisateurs</h1>
            <p class="text-ctp-subtext0">Créez et gérez les utilisateurs de l'application.</p>
        </div>

        <!-- Formulaire d'ajout d'utilisateur -->
        @template.components.Card(
        title = "Ajouter un utilisateur",
        content = @`
            <form action="/admin/users" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="form-field">
                    <label for="username">Nom d'utilisateur</label>
                    <div class="flex gap-4">
                        <input type="text" id="username" name="username" placeholder="Ex: Jean Dupont" required autofocus class="flex-1">
                        @template.components.Button(
                        type = "submit",
                        variant = "primary",
                        content = @`Ajouter`
                        )
                    </div>
                </div>
            </form>
        `
        )

        <!-- Liste des utilisateurs -->
        @template.components.Card(
        title = "Liste des utilisateurs",
        content = @`
            @if(users.isEmpty())
                @template.components.Alert(
                type = "info",
                body = @`Aucun utilisateur disponible.`
                )
            @else
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-ctp-mantle">
                        <tr>
                            <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                                ID
                            </th>
                            <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                                Nom d'utilisateur
                            </th>
                            <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                                Code initialisé
                            </th>
                            <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                                Actions
                            </th>
                        </tr>
                        </thead>
                        <tbody class="divide-y divide-ctp-surface1">
                        @for(fr.redstom.khollendar.entity.User user : users.getContent())
                            <tr class="hover:bg-ctp-mantle/50">
                                <td class="py-2 px-4 text-sm">${user.id()}</td>
                                <td class="py-2 px-4 text-sm">${user.username()}</td>
                                <td class="py-2 px-4 text-sm">
                                    @if(user.codeInitialized())
                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                                                    Oui
                                                </span>
                                    @else
                                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-yellow/20 text-ctp-yellow">
                                                    Non
                                                </span>
                                    @endif
                                </td>
                                <td class="py-2 px-4 text-sm">
                                    <div class="flex gap-2">
                                        @if(user.codeInitialized())
                                            <form action="/admin/users/${user.id()}/reset-code" method="post">
                                                <input type="hidden" name="${_csrf.getParameterName()}"
                                                       value="${_csrf.getToken()}"/>
                                                @template.components.Button(
                                                type = "submit",
                                                variant = "warning",
                                                size = "xs",
                                                extraClasses = "flex items-center gap-1",
                                                onclick = "return confirm('Êtes-vous sûr de vouloir réinitialiser le code de ${user.username()} ?')",
                                                content = @`
                                                    <i data-feather="key" class="w-3 h-3"></i>
                                                    Réinitialiser code
                                                `
                                                )
                                            </form>
                                        @endif
                                        <form action="/admin/users/${user.id()}" method="post">
                                            <input type="hidden" name="_method" value="DELETE"/>
                                            <input type="hidden" name="${_csrf.getParameterName()}"
                                                   value="${_csrf.getToken()}"/>
                                            @template.components.Button(
                                            type = "submit",
                                            variant = "danger",
                                            size = "xs",
                                            extraClasses = "flex items-center gap-1",
                                            onclick = "return confirm('Êtes-vous sûr de vouloir supprimer l\\'utilisateur ${user.username()} ?')",
                                            content = @`
                                                <i data-feather="trash-2" class="w-3 h-3"></i>
                                                Supprimer
                                            `
                                            )
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @endfor
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                @if(users.getTotalPages() > 1)
                    <div class="mt-6">
                        @template.components.PaginatedView(
                        page = users,
                        paramName = "page",
                        currentPage = currentPage,
                        urlMaker = (page) -> "/admin/users?page=" + page
                        )
                    </div>
                @endif
            @endif
        `
        )
    </div>
`)
