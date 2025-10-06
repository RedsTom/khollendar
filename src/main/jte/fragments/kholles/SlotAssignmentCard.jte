@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.KholleAssignment
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale

@param KholleSlot slot
@param List<KholleAssignment> assignments

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH);}

<div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-3 pb-3 border-b border-ctp-surface2">
        <div>
            <h3 class="text-lg font-semibold text-ctp-text flex items-center gap-2">
                <i class="feather-icon icon-calendar"></i>

                ${slot.dateTime().format(formatter)}
            </h3>
        </div>
        <div class="text-sm text-ctp-subtext0">
            ${assignments.size()} étudiant<span hidden="${assignments.size() <= 1}">s</span>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
        @for(KholleAssignment assignment : assignments)
            <div class="bg-ctp-surface1 rounded-lg p-3 border border-ctp-surface2">
                <div class="flex items-start justify-between gap-2">
                    <div class="flex-1 min-w-0">
                        <p class="font-medium text-ctp-text truncate">
                            ${assignment.user().username()}
                        </p>
                        @if(assignment.obtainedPreferenceRank() != null)
                            <p class="text-xs text-ctp-subtext0 mt-1">
                                @if(assignment.obtainedPreferenceRank() == 1)
                                    <span class="text-ctp-green">✓ 1er choix</span>
                                @else
                                    Choix n°${assignment.obtainedPreferenceRank()}
                                @endif
                            </p>
                        @else
                            <p class="text-xs text-ctp-yellow mt-1">
                                Aléatoire
                            </p>
                        @endif
                    </div>
                </div>
            </div>
        @endfor
    </div>
</div>
