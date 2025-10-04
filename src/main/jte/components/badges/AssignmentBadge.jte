@param Integer preferenceRank

@if(preferenceRank != null)
    <span class="flex-shrink-0 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium
        @if(preferenceRank == 1)
            bg-ctp-green/20 text-ctp-green
        @elseif(preferenceRank == 2)
            bg-ctp-blue/20 text-ctp-blue
        @elseif(preferenceRank == 3)
            bg-ctp-yellow/20 text-ctp-yellow
        @else
            bg-ctp-overlay0/20 text-ctp-overlay2
        @endif
    ">
        Choix ${preferenceRank}
    </span>
@else
    <span class="flex-shrink-0 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-overlay0/20 text-ctp-overlay2">
        Aléatoire
    </span>
@endif