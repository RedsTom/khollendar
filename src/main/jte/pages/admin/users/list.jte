@param org.springframework.data.domain.Page<fr.redstom.khollendar.entity.User> users
@param int currentPage
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Gestion des utilisateurs",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-6xl">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Gestion des utilisateurs</span>
                    `
                )
            </div>

            <!-- En-tête -->
            @template.fragments.common.PageHeader(
                title = "Gestion des utilisateurs",
                subtitle = "Créez et gérez les utilisateurs de l'application."
            )

            <!-- Formulaire d'ajout d'utilisateur -->
            @template.components.ui.Card(
                title = "Ajouter un utilisateur",
                content = @`
                    @template.fragments.admin.UserManagementForm(_csrf = _csrf)
                `
            )

            <!-- Liste des utilisateurs -->
            @template.components.ui.Card(
                title = "Liste des utilisateurs",
                content = @`
                    @if(users.isEmpty())
                        @template.components.ui.Alert(
                            type = "info",
                            body = @`Aucun utilisateur disponible.`
                        )
                    @else
                        <!-- Vue en tableau pour les écrans moyens et grands -->
                        <div class="hidden md:block overflow-x-auto">
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
                                        @template.fragments.admin.UserTableRow(
                                            user = user,
                                            _csrf = _csrf
                                        )
                                    @endfor
                                </tbody>
                            </table>
                        </div>

                        <!-- Vue en cartes pour mobile -->
                        <div class="md:hidden space-y-4">
                            @for(fr.redstom.khollendar.entity.User user : users.getContent())
                                <div class="bg-ctp-surface0 rounded-lg p-4 border border-ctp-surface1">
                                    <div class="space-y-2">
                                        <div class="flex justify-between items-start">
                                            <div>
                                                <p class="text-xs text-ctp-subtext0">ID</p>
                                                <p class="font-medium">${user.id()}</p>
                                            </div>
                                            <div>
                                                @if(user.codeInitialized())
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                                                        Code initialisé
                                                    </span>
                                                @else
                                                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-yellow/20 text-ctp-yellow">
                                                        Code non initialisé
                                                    </span>
                                                @endif
                                            </div>
                                        </div>
                                        <div>
                                            <p class="text-xs text-ctp-subtext0">Nom d'utilisateur</p>
                                            <p class="font-medium">${user.username()}</p>
                                        </div>
                                        <div class="flex gap-2 pt-2">
                                            @if(user.codeInitialized())
                                                <form action="/admin/users/${user.id()}/reset-code"
                                                      method="post"
                                                      class="flex-1">
                                                    <input type="hidden"
                                                           name="${_csrf.getParameterName()}"
                                                           value="${_csrf.getToken()}"/>
                                                    @template.components.ui.Button(
                                                        type = "submit",
                                                        variant = "warning",
                                                        size = "xs",
                                                        extraClasses = "flex items-center gap-1 w-full justify-center",
                                                        onclick = "return confirm('Êtes-vous sûr de vouloir réinitialiser le code de ${user.username()} ?')",
                                                        content = @`
                                                            <i data-feather="key" class="w-3 h-3"></i>
                                                            Réinitialiser
                                                        `
                                                    )
                                                </form>
                                            @endif
                                            <form action="/admin/users/${user.id()}" method="post" class="flex-1">
                                                <input type="hidden" name="_method" value="DELETE"/>
                                                <input type="hidden"
                                                       name="${_csrf.getParameterName()}"
                                                       value="${_csrf.getToken()}"/>
                                                @template.components.ui.Button(
                                                    type = "submit",
                                                    variant = "danger",
                                                    size = "xs",
                                                    extraClasses = "flex items-center gap-1 w-full justify-center",
                                                    onclick = "return confirm('Êtes-vous sûr de vouloir supprimer l\\'utilisateur ${user.username()} ?')",
                                                    content = @`
                                                        <i data-feather="trash-2" class="w-3 h-3"></i>
                                                        Supprimer
                                                    `
                                                )
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            @endfor
                        </div>

                        @if(users.getTotalPages() > 1)
                            @template.components.navigation.PaginatedView(
                                page = users,
                                currentPage = currentPage,
                                urlMaker = (newPage) -> "?page=" + newPage,
                                paramName = "page"
                            )
                        @endif
                    @endif
                `
            )
        </div>
    `
)
