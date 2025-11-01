@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils

@param KholleSession session
@param User currentUser

<!-- En-tête -->
@template.fragments.kholles.preferences.PreferencesPageHeader(
    subject = @`Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>`,
    step = ""
)

@template.components.ui.Card(
    title = "Préférences déjà soumises",
    content = @`
        <div class="mb-6 text-center">
            <div class="mx-auto mb-6 p-4 rounded-full bg-ctp-overlay0 inline-flex">
                <i class="fa-solid fa-lock"></i>
            </div>
            <h2 class="text-xl font-bold mb-4 text-ctp-blue flex items-center justify-center gap-2">
                <i class="fa-solid fa-circle-check"></i>

                Vos préférences sont déjà enregistrées
            </h2>
            <p class="text-ctp-subtext0 mb-6">
                Vous avez déjà soumis vos préférences pour cette séance de khôlle.
                Une fois validées, les préférences ne peuvent plus être modifiées.
            </p>
        </div>

        <div class="flex flex-col sm:flex-row justify-center gap-4 mt-8">
            <a href="/kholles" class="button primary">
                <i class="fa-solid fa-arrow-left"></i>

                Retour à la liste des khôlles
            </a>
        </div>
    `
)
