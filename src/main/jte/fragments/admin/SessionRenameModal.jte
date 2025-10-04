@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session
@param CsrfToken _csrf

<dialog id="renameModal"
        class="rounded-lg shadow-xl max-w-md w-[calc(100%-1rem)] sm:w-full p-0 bg-transparent border-0">
    <div class="bg-ctp-base rounded-lg p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold text-ctp-text">Renommer la session</h2>
        </div>
        <form action="/kholles/${session.id()}/rename" method="post">
            <input type="hidden"
                   name="${_csrf.getParameterName()}"
                   value="${_csrf.getToken()}"/>
            <div class="mb-4">
                <label for="newSubject"
                       class="block text-sm font-medium text-ctp-text mb-2">
                    Nouveau nom de la session
                </label>
                <input type="text"
                       id="newSubject"
                       name="newSubject"
                       value="${session.subject()}"
                       required
                       class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface2 rounded-lg text-ctp-text focus:outline-none focus:ring-2 focus:ring-ctp-blue"/>
            </div>
            <div class="flex gap-2 justify-end">
                <button type="button"
                        id="cancelRenameBtn"
                        class="px-4 py-2 bg-ctp-surface0 text-ctp-text rounded-lg hover:bg-ctp-surface1 transition-colors">
                    Annuler
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-ctp-blue text-ctp-base rounded-lg hover:bg-ctp-sapphire transition-colors">
                    Renommer
                </button>
            </div>
        </form>
    </div>
</dialog>

