@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSessionStatus

@param KholleSession session

<div class="mb-8 p-4 bg-ctp-surface0/50 rounded-lg border border-ctp-surface2">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue">
        <i class="fa-solid fa-cogs"></i>

        Actions administrateur
    </h2>
    <div class="flex gap-2 flex-wrap">
        <!-- Bouton pour déclencher l'affectation -->
        <button hx-post="/kholles/${session.id()}/assignments/trigger"
                hx-confirm="Êtes-vous sûr de vouloir déclencher l'affectation pour cette session ? Les affectations existantes seront écrasées."
                class="button success">
            <i class="fa-solid fa-bolt-lightning"></i>

            Déclencher l'affectation
        </button>

        @if(session.status() != KholleSessionStatus.RESULTS_AVAILABLE)
            <button type="button"
                    id="status-btn"
                    class="button secondary">
                @if (session.status() == KholleSessionStatus.REGISTRATIONS_OPEN)
                    <i class="fa-solid fa-toggle-on"></i>
                @else
                    <i class="fa-solid fa-toggle-off"></i>
                @endif

                Changer le statut
            </button>
        @endif

        <button type="button"
                id="rename-btn"
                class="button secondary">
            <i class="fa-solid fa-edit"></i>

            Renommer
        </button>

        <button hx-delete="/kholles/${session.id()}"
                hx-confirm="Êtes-vous sûr de vouloir supprimer cette session de khôlles ? Cette action est irréversible."
                class="button danger">
            <i class="fa-solid fa-trash"></i>

            Supprimer la session
        </button>
    </div>
</div>

@template.fragments.admin.SessionRenameModal(session = session)
@template.fragments.admin.SessionStatusModal(session = session)

