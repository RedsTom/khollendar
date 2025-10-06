@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleAssignment

@param KholleSession session
@param boolean hasAssignments

<!-- Boutons d'action -->
<div class="flex gap-2 flex-wrap">
    @if(hasAssignments)
        <a class="button primary" href="/kholles/${session.id()}/assignments">
            <i class="feather-icon icon-check-circle"></i>

            Voir les détails des affectations
        </a>
    @endif

    @if(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_OPEN)
        <a class="button primary" href="/user/login?redirectTo=/kholles/${session.id()}/preferences">
            <i class="feather-icon icon-user-plus"></i>

            Indiquer mes disponibilités
        </a>
    @else
        <button disabled class="button secondary">
            Inscriptions fermées
        </button>
    @endif
</div>

