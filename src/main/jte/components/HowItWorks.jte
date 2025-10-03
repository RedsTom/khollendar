@template.components.Card(
title = "Comment ça marche ?",
extraClasses = "mt-4",
content = @`
    <div class="relative flex flex-col gap-6">
        <div class="absolute h-[calc(100%-2rem)] w-0.5 bg-ctp-blue left-6 top-4"></div>

        <div class="flex items-center relative">
            <div class="h-12 w-12 rounded-full bg-ctp-blue flex items-center justify-center text-ctp-base font-bold z-10">
                1
            </div>
            <div class="ml-4 bg-ctp-mantle p-3 rounded-lg flex-1">
                <h3 class="font-medium text-ctp-text">Publication des sessions</h3>
                <p class="text-ctp-subtext0 text-sm mt-1">
                    Une session de khôlle est publiée avec différents créneaux horaires disponibles.
                </p>
            </div>
        </div>

        <div class="flex items-center relative">
            <div class="h-12 w-12 rounded-full bg-ctp-blue flex items-center justify-center text-ctp-base font-bold z-10">
                2
            </div>
            <div class="ml-4 bg-ctp-mantle p-3 rounded-lg flex-1">
                <h3 class="font-medium text-ctp-text">Choix des préférences</h3>
                <p class="text-ctp-subtext0 text-sm mt-1">
                    Vous avez jusqu'à <span class="font-medium">48 heures avant</span> le début des khôlles pour
                    indiquer vos préférences de créneaux et ceux où vous êtes indisponibles.
                </p>
            </div>
        </div>

        <div class="flex items-center relative">
            <div class="h-12 w-12 rounded-full bg-ctp-blue flex items-center justify-center text-ctp-base font-bold z-10">
                3
            </div>
            <div class="ml-4 bg-ctp-mantle p-3 rounded-lg flex-1">
                <h3 class="font-medium text-ctp-text">Optimisation des affectations</h3>
                <p class="text-ctp-subtext0 text-sm mt-1">
                    Un algorithme répartit les étudiants en minimisant les
                    insatisfactions et en respectant vos contraintes.
                </p>
            </div>
        </div>

        <div class="flex items-center relative">
            <div class="h-12 w-12 rounded-full bg-ctp-blue flex items-center justify-center text-ctp-base font-bold z-10">
                4
            </div>
            <div class="ml-4 bg-ctp-mantle p-3 rounded-lg flex-1">
                <h3 class="font-medium text-ctp-text">Publication des résultats</h3>
                <p class="text-ctp-subtext0 text-sm mt-1">
                    Les affectations définitives sont publiées <span class="font-medium">24 heures minimum</span> avant
                    le début de la première khôlle de la session.
                </p>
            </div>
        </div>
    </div>
`
)
