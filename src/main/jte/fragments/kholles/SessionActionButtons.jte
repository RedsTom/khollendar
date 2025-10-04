@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleAssignment

@param KholleSession session
@param boolean hasAssignments

<!-- Boutons d'action -->
<div class="flex gap-2 flex-wrap">
    @if(hasAssignments)
        @template.components.ui.Button(
            href = "/kholles/" + session.id() + "/assignments",
            variant = "primary",
            content = @`
                <i data-feather="check-circle" class="mr-2"></i>
                Voir les détails des affectations
            `
        )
    @endif

    @if(session.status() == fr.redstom.khollendar.entity.KholleSessionStatus.REGISTRATIONS_OPEN)
        @template.components.ui.Button(
            href = "/user-auth/select?redirectTo=/kholles/" + session.id() + "/preferences",
            variant = "primary",
            content = @`Indiquer mes disponibilités`
        )
    @else
        @template.components.ui.Button(
            variant = "secondary",
            disabled = true,
            content = @`Inscriptions fermées`
        )
    @endif
</div>

