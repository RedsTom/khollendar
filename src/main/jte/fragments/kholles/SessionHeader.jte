@import fr.redstom.khollendar.entity.KholleSession
@import java.time.format.DateTimeFormatter
@import java.util.Locale
@import gg.jte.Content

@param KholleSession session
@param Content actionButtons = null

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);}

<div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-start mb-6">
    <div class="flex-1 min-w-0">
        <div class="flex flex-wrap items-center gap-3 mb-2">
            <h1 class="text-2xl sm:text-3xl font-bold break-words">
                ${session.subject()}
            </h1>
            @template.components.badges.StatusBadge(status = session.status())
        </div>
        @if(session.calculateDateRange().isPresent())
            <p class="text-sm sm:text-base text-ctp-subtext0 mt-1">
                Du ${session.calculateDateRange().get().start().format(formatter)}
                au ${session.calculateDateRange().get().end().format(formatter)}
            </p>
        @endif
    </div>

    @if(actionButtons != null)
        <div class="flex gap-2 flex-wrap">
            ${actionButtons}
        </div>
    @endif
</div>

