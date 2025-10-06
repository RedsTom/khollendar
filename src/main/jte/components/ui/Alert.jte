@param String type = "info"
@param String message = null
@param gg.jte.Content body = null
@param boolean dismissible = false

<%-- Définition des variantes de couleur et icônes --%>
!{var colorClasses = switch(type) {
    case "info" -> "bg-ctp-blue/10 border-ctp-blue text-ctp-blue";
    case "success" -> "bg-ctp-green/10 border-ctp-green text-ctp-green";
    case "warning" -> "bg-ctp-yellow/10 border-ctp-yellow text-ctp-yellow";
    case "danger", "error" -> "bg-ctp-red/10 border-ctp-red text-ctp-red";
    default -> "bg-ctp-blue/10 border-ctp-blue text-ctp-blue";
};}

!{var icon = switch(type) {
    case "info" -> "circle-info";
    case "success" -> "ciracle-check";
    case "warning" -> "triangle-exclamation";
    case "danger", "error" -> "circle-exclamation";
    default -> "circle-info";
};}

!{var baseClasses = "flex items-start gap-3 p-4 rounded-lg border-l-4 mb-4 " + colorClasses;}

<div class="${baseClasses}" role="alert">
    <%-- Icône --%>
    <div class="flex-shrink-0 mt-0.5">
        <i class="fa-solid fa-${icon}"></i>

    </div>

    <%-- Contenu --%>
    <div class="flex-1 text-ctp-text">
        @if(message != null)
            <p class="text-sm">${message}</p>
        @elseif(body != null)
            ${body}
        @endif
    </div>

    <%-- Bouton de fermeture --%>
    @if(dismissible)
        <button type="button"
                class="flex-shrink-0 text-ctp-subtext1 hover:text-ctp-text focus:outline-none"
                onclick="this.parentElement.remove()"
                aria-label="Fermer">
            <i class="fa-solid fa-xmark"></i>

        </button>
    @endif
</div>
