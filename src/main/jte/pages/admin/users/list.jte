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
                <i class="fa-solid fa-chevron-right"></i>
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
                            @template.fragments.admin.UserTableRow(user = user)
                        @endfor
                        </tbody>
                    </table>
                </div>

                <!-- Vue en cartes pour mobile -->
                <div class="md:hidden space-y-4">
                    @for(fr.redstom.khollendar.entity.User user : users.getContent())
                        @template.fragments.admin.UserCard(user = user)
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
        `)
    </div>
`)
