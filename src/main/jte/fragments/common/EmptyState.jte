@param String message
@param String linkText = null
@param String linkHref = null

<div class="p-4 sm:p-6 text-center bg-ctp-surface1 rounded-lg">
    <p class="text-base sm:text-xl text-ctp-subtext0 leading-relaxed">
        ${message}
        @if(linkText != null && linkHref != null)
            <a href="${linkHref}" class="text-ctp-blue underline hover:no-underline">
                ${linkText}
            </a>
        @endif
    </p>
</div>

