@import fr.redstom.khollendar.entity.KholleAssignment
@import java.time.format.DateTimeFormatter
@import java.util.Locale

@param KholleAssignment assignment

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH'h'mm", Locale.FRENCH);}

<div class="mb-4 p-4 rounded-lg border-2 @if(assignment.obtainedPreferenceRank() != null && assignment.obtainedPreferenceRank() == 1) border-ctp-green bg-ctp-green/10 @else border-ctp-blue bg-ctp-blue/10 @endif">
    <div class="flex items-start gap-3">
        <i data-feather="calendar"
           class="w-5 h-5 mt-0.5 flex-shrink-0 @if(assignment.obtainedPreferenceRank() != null && assignment.obtainedPreferenceRank() == 1) text-ctp-green @else text-ctp-blue @endif"></i>
        <div class="flex-1">
            <h3 class="font-semibold text-lg mb-1">Votre créneau affecté</h3>
            <p class="text-base mb-2">
                <strong>${assignment.slot().dateTime().format(formatter)}</strong>
            </p>
            @if(assignment.obtainedPreferenceRank() != null)
                @if(assignment.obtainedPreferenceRank() == 1)
                    <p class="text-sm text-ctp-green">
                        🎉 Vous avez obtenu votre <strong>premier choix</strong> !
                    </p>
                @else
                    <p class="text-sm">
                        Vous avez obtenu votre <strong>choix n°${assignment.obtainedPreferenceRank()}</strong>
                    </p>
                @endif
            @else
                <p class="text-sm text-ctp-subtext0">
                    Affectation aléatoire (aucune préférence renseignée ou satisfaite)
                </p>
            @endif
        </div>
    </div>
</div>

