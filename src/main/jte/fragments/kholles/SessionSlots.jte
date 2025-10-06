@import fr.redstom.khollendar.entity.KholleSlot
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale

@param List<KholleSlot> slots
@param String title = "Horaires disponibles"

!{DateTimeFormatter detailedFormatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

<div class="mb-8">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
        <i class="fa-solid fa-clock"></i>

        ${title}
    </h2>
    @if(slots.isEmpty())
        <p class="text-ctp-subtext0">Aucun horaire disponible pour cette session.</p>
    @else
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 sm:gap-4">
            @for(KholleSlot slot : slots)
                <div class="bg-ctp-surface1 p-3 sm:p-4 rounded-lg">
                    <p class="font-semibold text-sm sm:text-base leading-tight">
                        ${slot.dateTime().format(detailedFormatter)}
                    </p>
                </div>
            @endfor
        </div>
    @endif
</div>
