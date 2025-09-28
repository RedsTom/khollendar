@param String type = "info"
@param String message
@param boolean dismissible = false

<%-- Définition des styles selon le type d'alerte --%>
!{var alertClasses = switch(type) {
    case "success" -> "bg-ctp-green/10 border-ctp-green text-ctp-green";
    case "error", "danger" -> "bg-ctp-red/10 border-ctp-red text-ctp-red";
    case "warning" -> "bg-ctp-yellow/10 border-ctp-yellow text-ctp-yellow";
    case "info" -> "bg-ctp-blue/10 border-ctp-blue text-ctp-blue";
    default -> "bg-ctp-blue/10 border-ctp-blue text-ctp-blue";
};}

!{var containerClasses = "flex items-start p-4 mb-4 border-l-4 rounded-r-md " + alertClasses;}

<div class="${containerClasses}" role="alert">
    @if(type.equals("success"))
        <i data-feather="check-circle" class="flex-shrink-0 w-5 h-5 mr-3 mt-0.5"></i>
    @elseif(type.equals("error") || type.equals("danger"))
        <i data-feather="alert-circle" class="flex-shrink-0 w-5 h-5 mr-3 mt-0.5"></i>
    @elseif(type.equals("warning"))
        <i data-feather="alert-triangle" class="flex-shrink-0 w-5 h-5 mr-3 mt-0.5"></i>
    @else
        <i data-feather="info" class="flex-shrink-0 w-5 h-5 mr-3 mt-0.5"></i>
    @endif
    <div class="flex-1">
        <p class="text-sm font-medium">${message}</p>
    </div>

    @if(dismissible)
        <button type="button" class="flex-shrink-0 ml-3 -mr-1 -mt-1 p-1 rounded-md hover:bg-black/5" onclick="this.parentElement.remove()">
            <i data-feather="x" class="w-4 h-4"></i>
        </button>
    @endif
</div>
