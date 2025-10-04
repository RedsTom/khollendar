@import fr.redstom.khollendar.dto.DateRange
@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.utils.WordUtils
@import java.time.LocalDateTime
@import java.time.format.DateTimeFormatter

@param KholleSession session

!{boolean isEnded = session.calculateDateRange().map(DateRange::end).map(date -> date.isBefore(LocalDateTime.now())).orElse(false);}

<a href="/kholles/${session.id()}" class="block hover:opacity-90 transition-opacity">
    @template.components.ui.Card(
    extraClasses = "hover:border-ctp-blue",
    content = @`
        <div class="flex justify-between items-start gap-3 mb-2">
            <h3 class="text-lg font-medium @if(isEnded) line-through text-ctp-subtext1 @else text-ctp-text @endif flex-1">
                ${session.subject()}
            </h3>
            <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium flex-shrink-0
                @if(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_OPEN)
                    bg-ctp-green/20 text-ctp-green border border-ctp-green/30
                @elseif(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_CLOSED)
                    bg-ctp-red/20 text-ctp-red border border-ctp-red/30
                @else
                    bg-ctp-blue/20 text-ctp-blue border border-ctp-blue/30
                @endif
            ">
                ${session.status().getLabel()}
            </span>
        </div>
        <div class="text-sm text-ctp-subtext0">
            @if(session.calculateDateRange().isPresent())
                <p>
                    Du ${session.calculateDateRange().get().start().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}
                    au ${session.calculateDateRange().get().end().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}
                </p>
            @endif
            <p class="mt-1">${session.kholleSlots().size()} ${WordUtils.plural("créneau", "x", session.kholleSlots())} ${WordUtils.plural("programmé", "s", session.kholleSlots())}</p>
        </div>
    `
    )
</a>
