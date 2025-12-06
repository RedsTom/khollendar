@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleAssignment
@import fr.redstom.khollendar.dto.SlotWithPreferenceDto
@import java.time.format.DateTimeFormatter

@param KholleSession session
@param KholleAssignment assignment
@param java.util.List<SlotWithPreferenceDto> slotsWithPreferences

!{var formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");}

<div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50" id="modal-backdrop">
    <div class="bg-ctp-base rounded-lg shadow-xl max-w-2xl w-full m-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-bold text-ctp-text">
                    Modifier l'affectation de ${assignment.user().username()}
                </h2>
                <button onclick="document.getElementById('edit-assignment-modal').innerHTML = ''"
                        class="text-ctp-subtext0 hover:text-ctp-text">
                    <i class="fa-solid fa-times text-xl"></i>
                </button>
            </div>

            <div class="mb-4">
                <p class="text-ctp-subtext1">
                    Créneau actuel : <span class="font-semibold text-ctp-text">${formatter.format(assignment.slot().dateTime())}</span>
                </p>
                @if(assignment.obtainedPreferenceRank() != null)
                    <p class="text-ctp-subtext1">
                        Rang actuel : <span class="font-semibold text-ctp-green">Choix n°${assignment.obtainedPreferenceRank()}</span>
                    </p>
                @else
                    <p class="text-ctp-subtext1">
                        Rang actuel : <span class="font-semibold text-ctp-yellow">Non spécifié</span>
                    </p>
                @endif
            </div>

            <form hx-put="/admin/kholles/${session.id()}/assignments/${assignment.id()}"
                  hx-target="#assignments-table"
                  hx-on::after-request="document.getElementById('edit-assignment-modal').innerHTML = ''">

                <div class="mb-4">
                    <label class="block text-ctp-text font-medium mb-2">
                        Nouveau créneau
                    </label>
                    <select name="newSlotId"
                            class="w-full bg-ctp-surface0 border border-ctp-surface2 rounded px-3 py-2 text-ctp-text focus:outline-none focus:border-ctp-blue"
                            required>
                        @for(SlotWithPreferenceDto slotDto : slotsWithPreferences)
                            <option value="${slotDto.slot().id()}"
                                    selected="${slotDto.slot().id().equals(assignment.slot().id())}">
                                ${slotDto.getDisplayText()}
                            </option>
                        @endfor
                    </select>
                    <p class="text-ctp-subtext0 text-sm mt-2">
                        Les créneaux sont affichés avec leur rang de préférence pour cet utilisateur
                    </p>
                </div>

                <div class="flex gap-2 justify-end">
                    <button type="button"
                            onclick="document.getElementById('edit-assignment-modal').innerHTML = ''"
                            class="button secondary">
                        Annuler
                    </button>
                    <button type="submit" class="button primary">
                        <i class="fa-solid fa-save"></i>
                        Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

