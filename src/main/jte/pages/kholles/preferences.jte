@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.User

@param KholleSession session
@param User currentUser
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Confirmation de mes préférences",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <!-- Breadcrumb -->
        <div class="mb-4">
            @template.components.navigation.Breadcrumb(
            content = @`
                <a href="/" class="hover:text-ctp-blue transition-colors">
                    Accueil
                </a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                    Sessions de khôlles
                </a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                    ${session.subject()}
                </a>
                <i class="fa-solid fa-chevron-right"></i>
                <span class="text-ctp-text">
                Indiquer mes préférences
            </span>
            `
            )
        </div>

        <!-- Indicateur d'utilisateur connecté -->
        @template.components.layout.UserHeader(username = currentUser.username())

        <div id="content"
             class="inline"

             hx-get="/kholles/${session.id()}/preferences/current-step"
             hx-trigger="load"
             hx-target="this"
             hx-swap="innerHTML transition:true">

            <!-- Contenu remplacé par htmx -->
        </div>

    </div>
`)
