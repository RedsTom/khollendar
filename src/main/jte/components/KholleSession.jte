@import fr.redstom.khollendar.dto.DateRange
@import java.time.LocalDateTime
@import static fr.redstom.khollendar.utils.WordUtils.plural
@param fr.redstom.khollendar.entity.KholleSession session

!{boolean isEnded = session.calculateDateRange().map(DateRange::end).map(date -> date.isBefore(LocalDateTime.now())).orElse(false);}

<div class="bg-slate-800 p-3 rounded-lg">
    <h3 class="text-lg font-medium @if(isEnded) line-through text-slate-600 @endif">
        ${session.subject()}
    </h3>
    <div class="text-sm text-gray-300 mt-2">
        @if(session.calculateDateRange().isPresent())
            <p>
                Du ${session.calculateDateRange().get().start().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}
                au ${session.calculateDateRange().get().end().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}</p>
        @endif
        <p class="mt-1">${session.kholleSlots().size()} ${plural("créneau", "x", session.kholleSlots())} ${plural("programmé", session.kholleSlots())}</p>
    </div>
</div>
