@import fr.redstom.khollendar.entity.KholleSessionStatus

@param KholleSessionStatus status

!{String colors = switch(status) {
    case REGISTRATIONS_OPEN -> "bg-ctp-green/20 text-ctp-green border border-ctp-green/30";
    case REGISTRATIONS_CLOSED -> "bg-ctp-red/20 text-ctp-red border border-ctp-red/30";
    case RESULTS_AVAILABLE -> "bg-ctp-blue/20 text-ctp-blue border border-ctp-blue/30";
};
}
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs sm:text-sm font-medium ${colors}">
    ${status.label()}
</span>

