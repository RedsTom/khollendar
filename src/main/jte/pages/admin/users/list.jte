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
            <div hx-trigger="load" hx-swap="outerHTML" hx-target="this" hx-get="/admin/users/paginated?page=0"></div>
        `)
    </div>
`)
