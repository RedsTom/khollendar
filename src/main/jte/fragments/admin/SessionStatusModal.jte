@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSessionStatus
@import org.springframework.security.web.csrf.CsrfToken

@param KholleSession session

<dialog id="status-modal"
        class="rounded-lg shadow-xl max-w-md w-[calc(100%-0.5rem)] sm:w-full p-0 bg-transparent border-0 m-auto">
    <div class="bg-ctp-base rounded-lg p-6">
        <h2 class="text-xl font-bold text-ctp-text">Changer le statut</h2>
        <form hx-patch="/kholles/${session.id()}">
            <div class="mb-4">
                <label class="block text-sm font-medium text-ctp-text mb-3">
                    Sélectionnez le nouveau statut
                </label>
                <div class="space-y-2">
                    <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                        <input type="radio"
                               name="status"
                               value="REGISTRATIONS_OPEN"
                               checked="${session.status() == KholleSessionStatus.REGISTRATIONS_OPEN}"
                               class="mr-3 text-ctp-green focus:ring-ctp-green flex-shrink-0"/>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-green/20 text-ctp-green border border-ctp-green/30">
                            Inscriptions ouvertes
                        </span>
                    </label>

                    <label class="flex items-center p-3 rounded-lg border border-ctp-surface2 hover:bg-ctp-surface1 cursor-pointer transition-colors">
                        <input type="radio"
                               name="status"
                               value="REGISTRATIONS_CLOSED"
                               checked="${session.status() == KholleSessionStatus.REGISTRATIONS_CLOSED}"
                               class="mr-3 text-ctp-red focus:ring-ctp-red flex-shrink-0"/>
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-red/20 text-ctp-red border border-ctp-red/30">
                            Inscriptions fermées
                        </span>
                    </label>
                </div>
            </div>
            <div class="flex gap-2 justify-end">
                <button type="button"
                        id="cancel-status"
                        class="button secondary">
                    Annuler
                </button>
                <button type="submit"
                        class="button primary">
                    Modifier
                </button>
            </div>
        </form>
    </div>
</dialog>

