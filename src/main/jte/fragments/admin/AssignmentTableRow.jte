@import fr.redstom.khollendar.entity.KholleAssignment

@param KholleAssignment assignment
@param Long sessionId

<tr class="hover:bg-ctp-mantle/50">
    <td class="py-2 px-4 text-sm font-medium">
        ${assignment.user().username()}
    </td>
    <td class="py-2 px-4 text-sm">
        @if(assignment.obtainedPreferenceRank() != null)
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                Choix n°${assignment.obtainedPreferenceRank()}
            </span>
        @else
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-yellow/20 text-ctp-yellow">
                Non spécifié
            </span>
        @endif
    </td>
    <td class="py-2 px-4 text-sm">
        <button class="button secondary sm flex items-center gap-1"
                hx-get="/admin/kholles/${sessionId}/assignments/${assignment.id()}/edit"
                hx-target="#edit-assignment-modal"
                hx-swap="innerHTML">
            <i class="fa-solid fa-edit"></i>
            Modifier
        </button>
    </td>
</tr>
