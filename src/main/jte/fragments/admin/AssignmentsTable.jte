@import java.time.format.DateTimeFormatter

@param fr.redstom.khollendar.entity.KholleSession session
@param java.util.List<fr.redstom.khollendar.entity.KholleAssignment> assignments
@param java.util.Map<Long, java.util.List<fr.redstom.khollendar.entity.KholleAssignment>> assignmentsBySlot

!{var dateTimeFormatter = DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy 'à' HH:mm", java.util.Locale.FRENCH);}

<div class="hidden md:block overflow-x-auto" id="assignments-table">
    <table class="min-w-full">
        <thead class="bg-ctp-mantle">
            <tr>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Utilisateur
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Rang obtenu
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Actions
                </th>
            </tr>
        </thead>
        <tbody class="divide-y divide-ctp-surface1">
            @for(var entry : assignmentsBySlot.entrySet())
                !{
                    var slotId = entry.getKey();
                    var slotAssignments = entry.getValue();
                    // Récupérer le slot depuis la première affectation
                    var slot = slotAssignments.get(0).slot();
                }
                <!-- Séparateur de créneau -->
                <tr class="bg-ctp-surface0">
                    <td colspan="3" class="py-3 px-4">
                        <div class="flex items-center gap-2">
                            <i class="fa-solid fa-clock text-ctp-blue"></i>
                            <span class="font-semibold text-ctp-text text-lg">
                                ${dateTimeFormatter.format(slot.dateTime())}
                            </span>
                            <span class="text-ctp-subtext0 text-sm ml-2">
                                (${slotAssignments.size()} affectation${slotAssignments.size() > 1 ? "s" : ""})
                            </span>
                        </div>
                    </td>
                </tr>
                <!-- Affectations pour ce créneau -->
                @for (fr.redstom.khollendar.entity.KholleAssignment assignment : slotAssignments)
                    @template.fragments.admin.AssignmentTableRow(
                        assignment = assignment,
                        sessionId = session.id()
                    )
                @endfor
            @endfor
        </tbody>
    </table>
</div>
