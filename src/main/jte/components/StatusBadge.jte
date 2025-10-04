@import fr.redstom.khollendar.entity.KholleSessionStatus

@param KholleSessionStatus status

<span class="inline-flex items-center px-3 py-1 rounded-full text-xs sm:text-sm font-medium
    @if(status == KholleSessionStatus.REGISTRATIONS_OPEN)
        bg-ctp-green/20 text-ctp-green border border-ctp-green/30
    @elseif(status == KholleSessionStatus.REGISTRATIONS_CLOSED)
        bg-ctp-red/20 text-ctp-red border border-ctp-red/30
    @else
        bg-ctp-blue/20 text-ctp-blue border border-ctp-blue/30
    @endif
">
    ${status.getLabel()}
</span>

