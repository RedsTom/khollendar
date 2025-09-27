@import fr.redstom.khollendar.entity.KholleSession
@import java.util.List

@param String title
@param String content
@param List<KholleSession> upcomingSessions

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Accueil",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="rounded-lg p-6 pl-0 mb-8">
            <h1 class="text-3xl font-bold mb-4">Bienvenue sur Khôlle'n'dar</h1>
            <p class="text-xl text-ctp-subtext0">Visualisez, planifiez et inscrivez-vous aux khôlles en toute simplicité !</p>
        </div>

        <div class="bg-ctp-surface0 rounded-lg p-6 mb-6">
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4">
                <h2 class="text-2xl font-semibold">Prochaines sessions de khôlles</h2>
                <a href="/kholles" class="text-ctp-blue hover:text-ctp-blue/80 flex items-center my-4 sm:my-0">
                    Voir toutes les sessions
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-1" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                </a>
            </div>

            @if(upcomingSessions == null || upcomingSessions.isEmpty())
                <p class="text-ctp-subtext0 py-4">Aucune session de khôlle à venir</p>
            @else
                <div class="space-y-4">
                    @for(KholleSession session : upcomingSessions)
                        @template.components.KholleSession(session = session)
                    @endfor
                </div>
            @endif
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-ctp-surface0 rounded-lg p-6">
                <h2 class="text-xl font-semibold mb-3">Créer une nouvelle session</h2>
                <p class="text-ctp-subtext0 mb-4">Ajoutez une nouvelle session de khôlle pour vos étudiants</p>
                <a href="/kholles/create"
                   class="inline-block bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base px-4 py-2 rounded-lg">
                    Créer une session
                </a>
            </div>

            <div class="bg-ctp-surface0 rounded-lg p-6">
                <h2 class="text-xl font-semibold mb-3">Voir son planning</h2>
                <p class="text-ctp-subtext0 mb-4">Consultez votre planning de khôlles personnel</p>
                <a href="/planning"
                   class="inline-block bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base px-4 py-2 rounded-lg">
                    Mon planning
                </a>
            </div>
        </div>
    </div>
`
)
