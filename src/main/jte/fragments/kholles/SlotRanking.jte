@import fr.redstom.khollendar.entity.KholleSlot
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale
@import org.springframework.security.web.csrf.CsrfToken

@param List<KholleSlot> availableSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

<ul id="slot-ranking" class="space-y-2 sm:space-y-3">
    @for(int i = 0; i < availableSlots.size(); i++)
        !{KholleSlot slot = availableSlots.get(i);}
        !{var slotId = slot.id().toString();}

        <li class="slot-item bg-ctp-surface1 rounded-lg p-3 sm:p-4 flex items-center justify-between gap-3"
            data-slot-id="${slotId}">

            <input type="hidden" name="ranked-slots" value="${slotId}"/>

            <div class="flex items-center gap-2 sm:gap-3 flex-1 min-w-0">
                <div class="rank-number flex-shrink-0 w-7 h-7 sm:w-8 sm:h-8 bg-ctp-blue text-ctp-base rounded-full flex items-center justify-center font-semibold text-sm sm:text-base">
                    ${i + 1}
                </div>
                <span class="text-sm sm:text-lg font-medium text-ctp-text leading-tight break-words">
                    ${slot.dateTime().format(formatter)}
                </span>
            </div>

            <div class="flex items-center gap-1 flex-shrink-0">
                <button type="button"
                        class="move-up p-1 sm:p-2 rounded hover:bg-ctp-surface2 transition-colors"
                        aria-label="Déplacer vers le haut">
                    <i class="h-4 w-4 sm:h-5 sm:w-5" data-feather="chevron-up"></i>
                </button>

                <button type="button"
                        class="move-down p-1 sm:p-2 rounded hover:bg-ctp-surface2 transition-colors"
                        aria-label="Déplacer vers le bas">
                    <i class="h-4 w-4 sm:h-5 sm:w-5" data-feather="chevron-down"></i>
                </button>
            </div>
        </li>
    @endfor
</ul>

<style>
    .rank-changed {
        animation: pulse-rank 0.4s cubic-bezier(.33,1,.68,1);
    }

    @keyframes pulse-rank {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.15); }
    }

    .slot-item {
        transition: transform 0.38s cubic-bezier(.33,1,.68,1);
    }
</style>
