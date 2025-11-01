@param String title
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = title,
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 max-w-7xl">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <span class="text-ctp-text">Sessions de khôlles</span>
                    `
                )
            </div>

            <!-- En-tête -->
            @template.fragments.common.PageHeader(
                title = title,
                action = @`
                    <a href="/kholles/create" class="button primary w-full sm:w-auto">
                        <i class="fa-solid fa-plus"></i>
                        Créer une session
                    </a>
                `
            )

            <!-- Grille responsive pour les sessions -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 mb-8">
                <!-- Sessions passées -->
                @template.components.ui.Card(
                    title = "Sessions de khôlles passées",
                    content = @`
                        <div hx-trigger="load" hx-swap="outerHTML" hx-target="this" hx-get="/kholles/paginated?type=1&page=0"></div>
                    `
                )

                <!-- Sessions à venir -->
                @template.components.ui.Card(
                    title = "Sessions de khôlles à venir",
                    content = @`
                        <div hx-trigger="load" hx-swap="outerHTML" hx-target="this" hx-get="/kholles/paginated?type=2&page=0"></div>
                    `
                )
            </div>

            <!-- Toutes les sessions -->
            @template.components.ui.Card(
                title = "Toutes les sessions de khôlles",
                content = @`
                <div hx-trigger="load" hx-swap="outerHTML" hx-target="this" hx-get="/kholles/paginated?type=0&page=0"></div>
                `
            )
        </div>
    `
)
