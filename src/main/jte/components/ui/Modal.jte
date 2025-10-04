@param String id
@param String title
@param String size = "md"
@param gg.jte.Content content
@param gg.jte.Content footer = null

<%-- Définition des tailles de modal --%>
!{var sizeClasses = switch(size) {
    case "sm" -> "max-w-md";
    case "md" -> "max-w-lg";
    case "lg" -> "max-w-2xl";
    case "xl" -> "max-w-4xl";
    default -> "max-w-lg";
};}

!{var modalClasses = "inline-block align-bottom bg-ctp-base rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle " + sizeClasses + " sm:w-full";}
!{var titleId = id + "-title";}

<div id="${id}" class="fixed inset-0 z-50 overflow-y-auto hidden" aria-labelledby="${titleId}" role="dialog"
     aria-modal="true">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Overlay -->
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" onclick="closeModal('${id}')"></div>

        <!-- Spacer pour centrer verticalement -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <!-- Modal -->
        <div class="${modalClasses}">
            <!-- En-tête -->
            <div class="bg-ctp-surface0 px-4 py-3 sm:px-6 border-b border-ctp-surface1">
                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-medium text-ctp-text" id="${titleId}">
                        ${title}
                    </h3>
                    <button type="button" class="text-ctp-subtext1 hover:text-ctp-text focus:outline-none"
                            onclick="closeModal('${id}')">
                        <i data-feather="x" class="w-5 h-5"></i>
                    </button>
                </div>
            </div>

            <!-- Contenu -->
            <div class="bg-ctp-base px-4 pt-5 pb-4 sm:p-6">
                ${content}
            </div>

            <!-- Pied de page -->
            @if(footer != null)
                <div class="bg-ctp-surface0 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-ctp-surface1">
                    ${footer}
                </div>
            @endif
        </div>
    </div>
</div>

<script>
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
        document.body.classList.add('overflow-hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
        document.body.classList.remove('overflow-hidden');
    }
</script>
