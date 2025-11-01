@import fr.redstom.khollendar.entity.KholleSession
@import java.util.List
@import java.util.Map

@param KholleSession session
@param int totalAssignments
@param double satisfactionRate
@param long withoutPreferences
@param Map<Integer, Long> rankDistribution

!{int assignmentsWithPreferences = totalAssignments - (int) withoutPreferences;}

<h2 class="text-2xl font-semibold mb-4 text-ctp-blue flex items-center gap-2">
    <i class="fa-solid fa-bar-chart"></i>

    Statistiques d'affectation
</h2>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <!-- Taux de satisfaction -->
    <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
        <div class="text-ctp-subtext0 text-sm mb-1">Taux de satisfaction</div>
        <div class="text-3xl font-bold text-ctp-green">
            ${String.format("%.1f", satisfactionRate)}%
        </div>
        <div class="text-xs text-ctp-subtext0 mt-1">Premier choix obtenu</div>
    </div>

    <!-- Total d'étudiants -->
    <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
        <div class="text-ctp-subtext0 text-sm mb-1">Étudiants affectés</div>
        <div class="text-3xl font-bold text-ctp-blue">${totalAssignments}</div>
        <div class="text-xs text-ctp-subtext0 mt-1">
            Sur ${session.kholleSlots().size()} créneaux
        </div>
    </div>

    <!-- Affectations aléatoires -->
    <div class="bg-ctp-surface0/50 rounded-lg p-4 border border-ctp-surface2">
        <div class="text-ctp-subtext0 text-sm mb-1">Affectations aléatoires</div>
        <div class="text-3xl font-bold text-ctp-yellow">${withoutPreferences}</div>
        <div class="text-xs text-ctp-subtext0 mt-1">Sans préférence satisfaite</div>
    </div>
</div>

<!-- Distribution par rang de préférence -->
@if(!rankDistribution.isEmpty())
    <div class="mt-6 pt-6 border-t border-ctp-surface2">
        <h3 class="text-lg font-semibold mb-3 text-ctp-blue flex items-center gap-2">
            <i class="fa-solid fa-pie-chart"></i>

            Distribution par rang de préférence
        </h3>
        <div class="space-y-2">
            @for(Map.Entry<Integer, Long> entry : rankDistribution.entrySet().stream().sorted(Map.Entry.comparingByKey()).toList())
                !{int rank = entry.getKey();}
                !{long count = entry.getValue();}
                !{double percentage = assignmentsWithPreferences > 0 ? (double) count / assignmentsWithPreferences * 100 : 0;}
                <div>
                    <div class="flex justify-between text-sm mb-1">
                        <span class="text-ctp-text">Choix n°${rank}</span>
                        <span class="text-ctp-subtext0">
                            ${count} étudiant<span hidden="${count <= 1}">s</span> (${String.format("%.1f", percentage)}%)
                        </span>
                    </div>
                    <div class="w-full bg-ctp-surface0 rounded-full h-2">
                        !{
                        String bgColor = switch (rank) {
                            case 1 -> "bg-ctp-green";
                            case 2 -> "bg-ctp-blue";
                            case 3 -> "bg-ctp-yellow";
                            default -> "bg-ctp-overlay0";
                        };
                        }
                        <div class="h-2 rounded-full transition-all ${bgColor}" style="width: ${percentage}%"></div>
                    </div>
                </div>
            @endfor
        </div>
    </div>
@endif
