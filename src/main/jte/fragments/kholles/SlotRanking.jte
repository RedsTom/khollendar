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

            <div class="flex flex-row gap-2">
                <button type="button" class="move-up-btn w-10 h-10 text-lg flex items-center justify-center rounded-full hover:bg-ctp-surface0 text-ctp-subtext0 hover:text-ctp-text transition-colors" title="Monter">
                    <i class="fa-solid fa-chevron-up"></i>
                </button>
                <button type="button" class="move-down-btn w-10 h-10 text-lg flex items-center justify-center rounded-full hover:bg-ctp-surface0 text-ctp-subtext0 hover:text-ctp-text transition-colors" title="Descendre">
                    <i class="fa-solid fa-chevron-down"></i>
                </button>
            </div>
        </li>
    @endfor
</ul>
