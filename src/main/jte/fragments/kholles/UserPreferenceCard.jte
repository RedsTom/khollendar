@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.entity.UserPreference
@import fr.redstom.khollendar.entity.KholleSlot
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale

@param User user
@param List<UserPreference> preferences
@param List<KholleSlot> unavailableSlots = null

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

<div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
    <div class="flex items-center gap-2 mb-3">
        <i data-feather="user" class="w-5 h-5 text-ctp-blue"></i>
        <h3 class="text-lg font-semibold">${user.username()}</h3>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <!-- Préférences -->
        <div>
            <h4 class="text-sm font-medium text-ctp-subtext0 mb-2">Classement des préférences</h4>
            @if(preferences.isEmpty())
                <p class="text-sm text-ctp-subtext0">Aucune préférence renseignée</p>
            @else
                <ol class="space-y-1">
                    @for(UserPreference pref : preferences)
                        <li class="text-sm flex items-start gap-2">
                            <span class="inline-flex items-center justify-center w-5 h-5 rounded-full bg-ctp-blue text-ctp-base text-xs font-bold flex-shrink-0">
                                ${pref.preferenceRank()}
                            </span>
                            <span class="leading-5">
                                ${pref.slot().dateTime().format(formatter)}
                            </span>
                        </li>
                    @endfor
                </ol>
            @endif
        </div>

        <!-- Indisponibilités -->
        <div>
            <h4 class="text-sm font-medium text-ctp-subtext0 mb-2">Indisponibilités</h4>
            @if(unavailableSlots == null || unavailableSlots.isEmpty())
                <p class="text-sm text-ctp-subtext0">Aucune indisponibilité renseignée</p>
            @else
                <ul class="space-y-1">
                    @for(KholleSlot slot : unavailableSlots)
                        <li class="text-sm flex items-start gap-2">
                            <i data-feather="x" class="w-4 h-4 text-ctp-red flex-shrink-0 mt-0.5"></i>
                            <span class="leading-5">
                                ${slot.dateTime().format(formatter)}
                            </span>
                        </li>
                    @endfor
                </ul>
            @endif
        </div>
    </div>
</div>
