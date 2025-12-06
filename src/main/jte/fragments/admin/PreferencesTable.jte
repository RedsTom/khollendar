@param fr.redstom.khollendar.entity.KholleSession session
@param java.util.List<fr.redstom.khollendar.dto.UserPreferenceSummary> groupedPreferences

<div class="hidden md:block overflow-x-auto" id="preferences-table">
    <table class="min-w-full">
        <thead class="bg-ctp-mantle">
            <tr>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Utilisateur
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Nombre de préférences
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Créneaux (IDs)
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Dates
                </th>
                <th class="py-3 px-4 text-left text-xs font-medium text-ctp-subtext0 uppercase tracking-wider">
                    Actions
                </th>
            </tr>
        </thead>
        <tbody class="divide-y divide-ctp-surface1">
            @for (fr.redstom.khollendar.dto.UserPreferenceSummary summary : groupedPreferences)
                @template.fragments.admin.KholleAssignemntsTableRow(summary = summary, sessionId = session.id())
            @endfor
        </tbody>
    </table>
</div>

