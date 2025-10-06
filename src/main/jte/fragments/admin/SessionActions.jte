@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session
@param CsrfToken _csrf

<div class="mb-8 p-4 bg-ctp-surface0/50 rounded-lg border border-ctp-surface2">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue">
        <i class="feather-icon icon-settings"></i>

        Actions administrateur
    </h2>
    <div class="flex gap-2 flex-wrap">
        <!-- Bouton pour déclencher l'affectation -->
        <form action="/kholles/${session.id()}/assignments/trigger"
              method="post"
              class="inline"
              onsubmit="return confirm('Êtes-vous sûr de vouloir déclencher l\'affectation pour cette session ? Les affectations existantes seront écrasées.');">
            <input type="hidden"
                   name="${_csrf.getParameterName()}"
                   value="${_csrf.getToken()}"/>
            <button type="submit"
                    class="button success">
                <i class="feather-icon icon-zap"></i>

                Déclencher l'affectation
            </button>
        </form>

        @if(session.status() != fr.redstom.khollendar.entity.KholleSessionStatus.RESULTS_AVAILABLE)
            <button type="button"
                    id="statusBtn"
                    class="button secondary">
                <i class="feather-icon icon-toggle-right"></i>

                Changer le statut
            </button>
        @endif

        <button type="button"
                id="renameBtn"
                class="button secondary">
            <i class="feather-icon icon-edit-2"></i>

            Renommer
        </button>

        <form action="/kholles/${session.id()}/delete"
              method="post"
              onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cette session de khôlles ? Cette action est irréversible.');"
              class="inline">
            <input type="hidden"
                   name="${_csrf.getParameterName()}"
                   value="${_csrf.getToken()}"/>
            <button type="submit"
                    class="button danger">
                <i class="feather-icon icon-trash-2"></i>

                Supprimer la session
            </button>
        </form>
    </div>
</div>

<style>
    #renameModal {
        margin: auto;
    }
    #renameModal::backdrop {
        background-color: rgba(0, 0, 0, 0.3);
    }
    #statusModal {
        margin: auto;
    }
    #statusModal::backdrop {
        background-color: rgba(0, 0, 0, 0.3);
    }
</style>

@template.fragments.admin.SessionRenameModal(session = session, _csrf = _csrf)
@template.fragments.admin.SessionStatusModal(session = session, _csrf = _csrf)

