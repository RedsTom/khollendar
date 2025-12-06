@import fr.redstom.khollendar.dto.UserPreferenceSummary

@param UserPreferenceSummary summary
@param Long sessionId

<tr class="hover:bg-ctp-mantle/50">
    <td class="py-2 px-4 text-sm font-medium">
        ${summary.user().username()}
    </td>
    <td class="py-2 px-4 text-sm">
        <div class="flex items-center gap-2">
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-blue/20 text-ctp-blue">
                ${summary.getTotalPreferences()} total
            </span>
            @if(summary.getPositivePreferencesCount() > 0)
                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                    ${summary.getPositivePreferencesCount()} préf.
                </span>
            @endif
            @if(summary.getUnavailabilitiesCount() > 0)
                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-red/20 text-ctp-red">
                    ${summary.getUnavailabilitiesCount()} indispo.
                </span>
            @endif
        </div>
    </td>
    <td class="py-2 px-4 text-sm text-ctp-subtext0">
        ${summary.getSlotIdsDisplay()}
    </td>
    <td class="py-2 px-4 text-sm text-ctp-subtext0">
        ${summary.getDatesDisplay()}
    </td>
    <td class="py-2 px-4 text-sm">
        <button class="button danger sm flex items-center gap-1"
                hx-delete="/admin/kholles/${sessionId}/preferences/user/${summary.user().id()}"
                hx-target="#preferences-table"
                hx-confirm="Êtes-vous sûr de vouloir supprimer toutes les préférences de ${summary.user().username()} pour cette session ?">
            <i class="fa-solid fa-trash"></i>
            Supprimer
        </button>
    </td>
</tr>
