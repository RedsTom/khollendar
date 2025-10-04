@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session
@param CsrfToken _csrf

<div class="mb-8 p-4 bg-ctp-surface0/50 rounded-lg border border-ctp-surface2">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue">
        <i data-feather="settings" class="inline-block w-5 h-5 sm:w-6 sm:h-6 mr-2"></i>
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
                    class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-green focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-green hover:bg-ctp-green/80 text-ctp-base border-0">
                <i data-feather="zap" class="mr-2"></i>
                Déclencher l'affectation
            </button>
        </form>

        @if(session.status() != fr.redstom.khollendar.entity.KholleSessionStatus.RESULTS_AVAILABLE)
            <button type="button"
                    id="statusBtn"
                    class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0">
                <i data-feather="toggle-right" class="mr-2"></i>
                Changer le statut
            </button>
        @endif

        <button type="button"
                id="renameBtn"
                class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0">
            <i data-feather="edit-2" class="mr-2"></i>
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
                    class="inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-red focus:ring-offset-2 focus:ring-offset-ctp-base px-4 py-2 bg-ctp-red hover:bg-ctp-red/80 text-ctp-base border-0">
                <i data-feather="trash-2" class="mr-2"></i>
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

