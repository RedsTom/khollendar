@import fr.redstom.khollendar.entity.KholleSession
@import java.util.List

@param String title
@param String content
@param List<KholleSession> upcomingSessions

@template.layout.MainLayout(
title = "Accueil",
content = @`
    <div class="container mx-auto p-4">
        <div class="bg-slate-800 rounded-lg p-6 pl-0 mb-8">
            <h1 class="text-3xl font-bold mb-4">Bienvenue sur Khôlle'n'dar</h1>
            <p class="text-xl text-gray-300">Inscrivez-vous pour les khôlles à venir !</p>
        </div>

        <div class="bg-slate-700 rounded-lg p-6 mb-6">
            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center mb-4">
                <h2 class="text-2xl font-semibold">Prochaines sessions de khôlles</h2>
                <a href="/kholles" class="text-blue-400 hover:text-blue-300 flex items-center my-4 sm:my-0">
                    Voir toutes les sessions
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-1" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                </a>
            </div>

            @if(upcomingSessions == null || upcomingSessions.isEmpty())
                <p class="text-gray-400 py-4">Aucune session de khôlle à venir</p>
            @else
                <div class="space-y-4">
                    @for(KholleSession session : upcomingSessions)
                        @template.components.KholleSession(session = session)
                    @endfor
                </div>
            @endif
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-slate-700 rounded-lg p-6">
                <h2 class="text-xl font-semibold mb-3">Créer une nouvelle session</h2>
                <p class="text-gray-300 mb-4">Ajoutez une nouvelle session de khôlle pour vos étudiants</p>
                <a href="/kholles/create"
                   class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                    Créer une session
                </a>
            </div>

            <div class="bg-slate-700 rounded-lg p-6">
                <h2 class="text-xl font-semibold mb-3">Statistiques</h2>
                <p class="text-gray-300">Consultez les statistiques de participation aux khôlles</p>
                <p class="text-gray-400 mt-2 italic">Fonctionnalité à venir</p>
            </div>
        </div>
    </div>
`
)
