@param Integer preferenceRank

!{
String colors = switch(preferenceRank) {
    case 1 -> "bg-ctp-green/20 text-ctp-green";
    case 2 -> "bg-ctp-blue/20 text-ctp-blue";
    case 3 -> "bg-ctp-yellow/20 text-ctp-yellow";
    default -> "bg-ctp-overlay0/20 text-ctp-overlay2";
};
}

@if(preferenceRank != null)
    <span class="flex-shrink-0 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${colors}">
        Choix ${preferenceRank}
    </span>
@else
    <span class="flex-shrink-0 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-overlay0/20 text-ctp-overlay2">
        Aléatoire
    </span>
@endif