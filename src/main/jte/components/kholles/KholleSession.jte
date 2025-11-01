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
            !{String textStyle = isEnded ? "line-through text-ctp-subtext1" : "text-ctp-text";}
            <h3 class="text-lg font-medium flex-1 ${textStyle}">
                ${session.subject()}
            </h3>
            @template.components.badges.StatusBadge(status = session.status())
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
