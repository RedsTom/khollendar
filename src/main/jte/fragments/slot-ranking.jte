@import fr.redstom.khollendar.entity.KholleSlot
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale
@import org.springframework.security.web.csrf.CsrfToken

@param List<KholleSlot> availableSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

<ul id="slot-ranking" class="space-y-2">
    @for(int i = 0; i < availableSlots.size(); i++)
        !{KholleSlot slot = availableSlots.get(i);}
        !{Long sessionId = slot.session().id();}
        !{Long slotId = slot.id();}
        !{boolean isFirst = (i == 0);}
        !{boolean isLast = (i == availableSlots.size() - 1);}

        <li class="slot-item bg-ctp-surface1 rounded-lg p-4 flex items-center justify-between" data-slot-id="${slotId}" data-rank="${i + 1}">
            <input type="hidden" name="ranked-slots" value="${slotId}" />
            <div class="flex items-center">
                <div class="flex-shrink-0 w-8 h-8 bg-ctp-blue text-ctp-base rounded-full flex items-center justify-center mr-3">
                    ${i + 1}
                </div>
                <span class="text-lg font-medium">${slot.dateTime().format(formatter)}</span>
            </div>
            <div class="flex items-center gap-1">
                <form action="/kholles/${sessionId}/reorder-slot" method="post">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />
                    <input type="hidden" name="slotId" value="${slotId}">
                    <input type="hidden" name="direction" value="up">
                    <button type="submit" class="p-2 rounded hover:bg-ctp-surface2 transition-colors" disabled="${isFirst}">
                        <i class="h-5 w-5 ${isFirst ? "text-ctp-overlay0" : "text-ctp-text"}" data-feather="chevron-up"></i>
                    </button>
                </form>

                <form action="/kholles/${sessionId}/reorder-slot" method="post">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}" />
                    <input type="hidden" name="slotId" value="${slotId}">
                    <input type="hidden" name="direction" value="down">
                    <button type="submit" class="p-2 rounded hover:bg-ctp-surface2 transition-colors" disabled="${isLast}">
                        <i class="h-5 w-5 ${isLast ? "text-ctp-overlay0" : "text-ctp-text"}" data-feather="chevron-down"></i>
                    </button>
                </form>
            </div>
        </li>
    @endfor
</ul>
