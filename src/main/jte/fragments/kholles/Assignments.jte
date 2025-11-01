@import java.util.*
@import java.util.List
@import java.util.Map
@import java.util.Comparator
@import java.util.stream.Collectors
@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.KholleAssignment

@param KholleSession session
@param List<KholleAssignment> assignments

!{boolean hasAssignments = assignments != null && !assignments.isEmpty();}

!{
    List<KholleSlot> sortedSlots = new ArrayList<>(session.kholleSlots());
    sortedSlots.sort(Comparator.comparing(KholleSlot::dateTime));
    
    Map<Long, List<KholleAssignment>> assignmentsBySlot = new java.util.HashMap<>();
    if (!assignments.isEmpty()) {
        // Grouper par créneau
        assignmentsBySlot = assignments.stream()
                .collect(Collectors.groupingBy(a -> a.slot().id()));
    }
}

<div class="mb-8">
    <h2 class="text-xl sm:text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
        <i class="fa-solid fa-calendar"></i>
        Affectations par créneau
    </h2>

    @if(hasAssignments)
        <div class="space-y-4">
            @for(KholleSlot slot : sortedSlots)
                !{List<KholleAssignment> slotAssignments = assignmentsBySlot.getOrDefault(slot.id(), List.of());}
                @if(!slotAssignments.isEmpty())
                    @template.fragments.kholles.SlotAssignmentCard(
                        slot = slot,
                        assignments = slotAssignments
                    )
                @endif
            @endfor
        </div>
    @else
        <div class="bg-ctp-surface1 rounded-lg p-4 sm:p-6 text-center">
            <p class="text-ctp-subtext0">
                Aucune affectation n'a encore été réalisée pour cette session.<br/>
                Les affectations sont réalisées environ deux jours avant le début de la première khôlle.
            </p>
        </div>
    @endif
</div>

