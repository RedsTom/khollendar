@import fr.redstom.khollesmanager.entity.KholleSession
@import org.springframework.data.domain.Page

@param String title
@param Page<KholleSession> upcomingSessions
@param Page<KholleSession> previousSessions
@param Page<KholleSession> allSessions
@param int previousPage
@param int upcomingPage
@param int allPage

@template.layout.MainLayout(
title = title,
content = @`
    <div class="container mx-auto p-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">${title}</h1>
            <a href="/kholles/create"
               class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center">
                <i data-feather="plus" class="mr-2"></i>
                Créer une session
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <div class="bg-slate-700 p-4 rounded-lg">
                <h2 class="text-xl font-semibold mb-4">Sessions de khôlles passées</h2>
                @if(previousSessions.isEmpty())
                    <p class="text-gray-400">Aucune session de khôlles passée</p>
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

            <div class="bg-slate-700 p-4 rounded-lg">
                <h2 class="text-xl font-semibold mb-4">Sessions de khôlles à venir</h2>
                @if(upcomingSessions.isEmpty())
                    <p class="text-gray-400">Aucune session de khôlles à venir</p>
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

        <div class="bg-slate-700 p-4 rounded-lg">
            <h2 class="text-xl font-semibold mb-4">Toutes les sessions de khôlles</h2>
            @if(allSessions.isEmpty())
                <p class="text-gray-400">Aucune session de khôlles</p>
            @else
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-4">
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

            // Ajouter les gestionnaires d'événements à tous les liens de pagination
            document.querySelectorAll('a.scroll-preserve').forEach(link => {
                link.addEventListener('click', function(e) {
                    // Sauvegarder la position actuelle du défilement
                    localStorage.setItem('scrollPosition', window.pageYOffset);
                });
            });
        });
    </script>
`
)
