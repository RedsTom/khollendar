@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session
@param CsrfToken _csrf

<dialog id="statusModal"
        class="rounded-lg shadow-xl max-w-md w-[calc(100%-0.5rem)] sm:w-full p-0 bg-transparent border-0">
    <div class="bg-ctp-base rounded-lg p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold text-ctp-text">Changer le statut</h2>
            <button id="closeStatusModal"
                    type="button"
                    class="text-ctp-subtext0 hover:text-ctp-text">
                <i data-feather="x"></i>
            </button>
        </div>
        <form action="/kholles/${session.id()}/status" method="post">
            <input type="hidden"
                   name="${_csrf.getParameterName()}"
                   value="${_csrf.getToken()}"/>
            <div class="mb-4">
                <label class="block text-sm font-medium text-ctp-text mb-3">
                    Sélectionnez le nouveau statut
                </label>
                <div class="space-y-2">
                    <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                        <input type="radio"
                               name="status"
                               value="REGISTRATIONS_OPEN"
                               class="mr-3 text-ctp-green focus:ring-ctp-green flex-shrink-0"/>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-green/20 text-ctp-green border border-ctp-green/30">
                            Inscriptions ouvertes
                        </span>
                    </label>

                    <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                        <input type="radio"
                               name="status"
                               value="REGISTRATIONS_CLOSED"
                               class="mr-3 text-ctp-red focus:ring-ctp-red flex-shrink-0"/>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-red/20 text-ctp-red border border-ctp-red/30">
                            Inscriptions fermées
                        </span>
                    </label>
                </div>
            </div>
            <div class="flex gap-2 justify-end">
                <button type="button"
                        id="cancelStatusBtn"
                        class="px-4 py-2 bg-ctp-surface0 text-ctp-text rounded-lg hover:bg-ctp-surface1 transition-colors">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-lg hover:bg-ctp-sapphire transition-colors">
                    Modifier
                </button>
            </div>
        </form>
    </div>
</dialog>

