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
        <!-- En-tête responsive -->
        <div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-center mb-6">
            <h1 class="text-2xl sm:text-3xl font-bold break-words">${title}</h1>
            <a href="/kholles/create"
               class="inline-flex items-center justify-center w-full sm:w-auto bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base px-4 py-2 rounded-lg font-medium transition-colors">
                <i data-feather="plus" class="mr-2 w-4 h-4 sm:w-5 sm:h-5"></i>
                Créer une session
            </a>
        </div>

        <!-- Grille responsive pour les sessions passées et à venir -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 mb-8">
            <!-- Sessions passées -->
            <div class="bg-ctp-surface0 p-4 sm:p-6 rounded-lg">
                <h2 class="text-lg sm:text-xl font-semibold mb-4">Sessions de khôlles passées</h2>
                @if(previousSessions.isEmpty())
                    <p class="text-ctp-subtext0 text-sm sm:text-base">Aucune session de khôlles passée</p>
                @else
                    <div class="space-y-3 mb-4">
                        @for(KholleSession session : previousSessions.getContent())
                            @template.components.KholleSession(session = session)
                        @endfor
                    </div>

                    <!-- Pagination pour les sessions passées -->
                    @template.components.PaginatedView(
                        page = previousSessions,
                        currentPage = previousPage,
                        urlMaker = (newPage) -> "?previousPage=" + newPage + "&upcomingPage=" + upcomingPage + "&allPage=" + allPage,
                        paramName = "previousPage"
                    )
                @endif
            </div>

            <!-- Sessions à venir -->
            <div class="bg-ctp-surface0 p-4 sm:p-6 rounded-lg">
                <h2 class="text-lg sm:text-xl font-semibold mb-4">Sessions de khôlles à venir</h2>
                @if(upcomingSessions.isEmpty())
                    <p class="text-ctp-subtext0 text-sm sm:text-base">Aucune session de khôlles à venir</p>
                @else
                    <div class="space-y-3 mb-4">
                        @for(KholleSession session : upcomingSessions.getContent())
                            @template.components.KholleSession(session = session)
                        @endfor
                    </div>

                    <!-- Pagination pour les sessions à venir -->
                    @template.components.PaginatedView(
                        page = upcomingSessions,
                        currentPage = upcomingPage,
                        urlMaker = (newPage) -> "?previousPage=" + previousPage + "&upcomingPage=" + newPage + "&allPage=" + allPage,
                        paramName = "upcomingPage"
                    )
                @endif
            </div>
        </div>

        <!-- Toutes les sessions -->
        <div class="bg-ctp-surface0 p-4 sm:p-6 rounded-lg">
            <h2 class="text-lg sm:text-xl font-semibold mb-4">Toutes les sessions de khôlles</h2>
            @if(allSessions.isEmpty())
                <p class="text-ctp-subtext0 text-sm sm:text-base">Aucune session de khôlles</p>
            @else
                <div class="space-y-3 mb-4">
                    @for(KholleSession session : allSessions.getContent())
                        @template.components.KholleSession(session = session)
                    @endfor
                </div>

                <!-- Pagination pour toutes les sessions -->
                @template.components.PaginatedView(
                    page = allSessions,
                    currentPage = allPage,
                    urlMaker = (newPage) -> "?previousPage=" + previousPage + "&upcomingPage=" + upcomingPage + "&allPage=" + newPage,
                    paramName = "allPage"
                )
            @endif
        </div>
    </div>

    <script>
        // Script pour préserver la position de défilement lors des changements de page
        document.addEventListener('DOMContentLoaded', function() {
            // Restaurer la position de défilement si elle existe
            const scrollPosition = localStorage.getItem('scrollPosition');
            if (scrollPosition) {
                window.scrollTo(0, parseInt(scrollPosition));
                // Effacer après utilisation
                localStorage.removeItem('scrollPosition');
            }

            // Sauvegarder la position avant navigation
            const paginationLinks = document.querySelectorAll('a[href*="Page="]');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function() {
                    localStorage.setItem('scrollPosition', window.scrollY.toString());
                });
            });
        });
    </script>
`
)
