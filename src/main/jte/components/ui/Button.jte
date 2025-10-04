@param String type = "button"
@param String variant = "primary"
@param String size = "md"
@param String href = ""
@param String onclick = ""
@param boolean disabled = false
@param String extraClasses = ""
@param gg.jte.Content content

<%-- Définition des variantes de couleur --%>
!{var colorClasses = switch(variant) {
    case "primary" -> "bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base";
    case "secondary" -> "bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text border border-ctp-overlay0";
    case "success" -> "bg-ctp-green hover:bg-ctp-green/80 text-ctp-base";
    case "danger" -> "bg-ctp-red hover:bg-ctp-red/80 text-ctp-base";
    case "warning" -> "bg-ctp-yellow hover:bg-ctp-yellow/80 text-ctp-base";
    default -> "bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base";
};}

<%-- Définition des tailles --%>
!{var sizeClasses = switch(size) {
    case "sm" -> "px-3 py-1.5 text-sm";
    case "md" -> "px-4 py-2";
    case "lg" -> "px-6 py-3 text-lg";
    default -> "px-4 py-2";
};}

!{var baseClasses = "inline-flex items-center justify-center font-medium rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:ring-offset-2 focus:ring-offset-ctp-base";}
!{var finalClasses = baseClasses + " " + colorClasses + " " + sizeClasses + " " + extraClasses + (disabled ? " opacity-50 cursor-not-allowed" : "");}

@if(!href.isEmpty())
    @if(disabled)
        <span class="${finalClasses}" style="pointer-events: none;">${content}</span>
    @else
        <a href="${href}" class="${finalClasses}">${content}</a>
    @endif
@else
    @if(type.equals("submit"))
        @if(disabled)
            <button type="submit" disabled class="${finalClasses}">${content}</button>
        @else
            @if(!onclick.isEmpty())
                <button type="submit" onclick="${onclick}" class="${finalClasses}">${content}</button>
            @else
                <button type="submit" class="${finalClasses}">${content}</button>
            @endif
        @endif
    @else
        @if(disabled)
            <button type="button" disabled class="${finalClasses}">${content}</button>
        @else
            @if(!onclick.isEmpty())
                <button type="button" onclick="${onclick}" class="${finalClasses}">${content}</button>
            @else
                <button type="button" class="${finalClasses}">${content}</button>
            @endif
        @endif
    @endif
@endif
