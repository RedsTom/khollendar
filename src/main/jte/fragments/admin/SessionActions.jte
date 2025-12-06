@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSessionStatus

@param KholleSession session

<div class="mb-8 p-4 bg-ctp-surface0/50 rounded-lg border border-ctp-surface2">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue">
        <i class="fa-solid fa-cogs"></i>

        Actions administrateur
    </h2>
    <div class="flex flex-col gap-4">
        <div class="flex flex-col gap-2">
            <span class="text-ctp-subtext1 font-bold text-lg">
                Actions
            </span>

            <div class="flex flex-wrap gap-2">
                <button hx-post="/kholles/${session.id()}/assignments/trigger"
                        hx-confirm="Êtes-vous sûr de vouloir déclencher l'affectation pour cette session ? Les affectations existantes seront écrasées."
                        class="button success">
                    <i class="fa-solid fa-bolt-lightning"></i>

                    Déclencher l'affectation
                </button>

                <button hx-delete="/kholles/${session.id()}"
                        hx-confirm="Êtes-vous sûr de vouloir supprimer cette session de khôlles ? Cette action est irréversible."
                        class="button danger">
                    <i class="fa-solid fa-trash"></i>
                    Supprimer la session
                </button>
            </div>
        </div>

        <div class="flex flex-col gap-2">
            <span class="text-ctp-subtext1 font-bold text-lg">
                Gestion des inscriptions
            </span>

            <div class="flex flex-wrap gap-2">
                @if(session.status() == KholleSessionStatus.RESULTS_AVAILABLE)
                    <a class="button secondary" href="/admin/kholles/${session.id()}/assignments">
                        <i class="fa-solid fa-clipboard-list"></i>
                        Gérer les affectations
                    </a>
                @else
                    <a class="button secondary" href="/admin/kholles/${session.id()}/preferences">
                        <i class="fa-solid fa-users"></i>
                        Gérer les préférences
                    </a>
                @endif
            </div>
        </div>

        <div class="flex flex-col gap-2">
            <span class="text-ctp-subtext1 font-bold text-lg">
                Propriétés
            </span>

            <div class="flex flex-wrap gap-2">
                <button type="button"
                        id="rename-btn"
                        class="button secondary">
                    <i class="fa-solid fa-edit"></i>

                    Renommer
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
            </div>
        </div>
    </div>
</div>

@template.fragments.admin.SessionRenameModal(session = session)
@template.fragments.admin.SessionStatusModal(session = session)

