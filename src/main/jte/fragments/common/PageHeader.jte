@param String title
@param String subtitle = null
@param gg.jte.Content action = null

<div class="mb-6">
    <div class="flex flex-col gap-4 sm:flex-row sm:justify-between sm:items-start">
        <div class="flex-1 min-w-0">
            <h1 class="text-2xl sm:text-3xl font-bold break-words">
                ${title}
            </h1>
            @if(subtitle != null)
                <p class="text-sm sm:text-base text-ctp-subtext0 mt-1">
                    ${subtitle}
                </p>
            @endif
        </div>
        @if(action != null)
            <div class="flex gap-2 flex-wrap">
                ${action}
            </div>
        @endif
    </div>
</div>
