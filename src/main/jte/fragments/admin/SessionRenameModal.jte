@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session

<dialog id="rename-modal"
        class="rounded-lg shadow-xl max-w-md w-[calc(100%-1rem)] sm:w-full p-0 bg-transparent border-0 m-auto">
    <div class="bg-ctp-base rounded-lg p-6">
        <h2 class="text-xl font-bold text-ctp-text">Renommer la session</h2>
        <form hx-patch="/kholles/${session.id()}">
            <div class="mb-4">
                <label for="subject"
                       class="block text-sm font-medium text-ctp-text mb-2">
                    Nouveau nom de la session
                </label>
                <input type="text"
                       id="subject"
                       name="subject"
                       value="${session.subject()}"
                       required
                       class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface2 rounded-lg text-ctp-text focus:outline-none focus:ring-2 focus:ring-ctp-blue"/>
            </div>
            <div class="flex gap-2 justify-end">
                <button type="button"
                        id="cancel-rename"
                        class="button secondary">
                    Annuler
                </button>
                <button type="submit"
                        class="button primary">
                    Renommer
                </button>
            </div>
        </form>
    </div>
</dialog>

