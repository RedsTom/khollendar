@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.data.domain.Page

@param String title
@param Page<KholleSession> upcomingSessions
@param Page<KholleSession> previousSessions
@param Page<KholleSession> allSessions
@param int previousPage
@param int upcomingPage
@param int allPage
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = title,
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4 max-w-7xl">
        <!-- En-tête -->
        <div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-center mb-6">
            <h1 class="text-2xl sm:text-3xl font-bold break-words">${title}</h1>
            @template.components.Button(
                href = "/kholles/create",
                variant = "primary",
                extraClasses = "w-full sm:w-auto",
                content = @`
                    <i data-feather="plus" class="mr-2 w-4 h-4 sm:w-5 sm:h-5"></i>
                    Créer une session
                `
            )
        </div>

        <!-- Grille responsive pour les sessions -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 mb-8">
            <!-- Sessions passées -->
            @template.components.Card(
                title = "Sessions de khôlles passées",
                content = @`
                    @if(previousSessions.isEmpty())
                        <p class="text-ctp-subtext0 text-sm sm:text-base">Aucune session de khôlles passée</p>
                    @else
                        <div class="space-y-3 mb-4">
                            @for(KholleSession session : previousSessions.getContent())
                                @template.components.KholleSession(session = session)
                            @endfor
                        </div>

                        @template.components.PaginatedView(
                            page = previousSessions,
                            currentPage = previousPage,
                            urlMaker = (newPage) -> "?previousPage=" + newPage + "&upcomingPage=" + upcomingPage + "&allPage=" + allPage,
                            paramName = "previousPage"
                        )
                    @endif
                `
            )

            <!-- Sessions à venir -->
            @template.components.Card(
                title = "Sessions de khôlles à venir",
                content = @`
                    @if(upcomingSessions.isEmpty())
                        <p class="text-ctp-subtext0 text-sm sm:text-base">Aucune session de khôlles programmée</p>
                    @else
                        <div class="space-y-3 mb-4">
                            @for(KholleSession session : upcomingSessions.getContent())
                                @template.components.KholleSession(session = session)
                            @endfor
                        </div>

                        @template.components.PaginatedView(
                            page = upcomingSessions,
                            currentPage = upcomingPage,
                            urlMaker = (newPage) -> "?previousPage=" + previousPage + "&upcomingPage=" + newPage + "&allPage=" + allPage,
                            paramName = "upcomingPage"
                        )
                    @endif
                `
            )
        </div>

        <!-- Toutes les sessions -->
        @template.components.Card(
            title = "Toutes les sessions de khôlles",
            content = @`
                @if(allSessions.isEmpty())
                    <p class="text-ctp-subtext0">Aucune session de khôlles créée</p>
                @else
                    <div class="space-y-3 mb-4">
                        @for(KholleSession session : allSessions.getContent())
                            @template.components.KholleSession(session = session)
                        @endfor
                    </div>

                    @template.components.PaginatedView(
                        page = allSessions,
                        currentPage = allPage,
                        urlMaker = (newPage) -> "?previousPage=" + previousPage + "&upcomingPage=" + upcomingPage + "&allPage=" + newPage,
                        paramName = "allPage"
                    )
                @endif
            `
        )
    </div>
`
)
