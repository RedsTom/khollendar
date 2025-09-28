@param String title = ""
@param String extraClasses = ""
@param gg.jte.Content content

!{var cardClasses = "bg-ctp-surface0 rounded-lg border border-ctp-surface1 overflow-hidden " + extraClasses;}

<div class="${cardClasses}">
    @if(!title.isEmpty())
        <div class="px-6 py-4 border-b border-ctp-surface1">
            <h3 class="text-lg font-semibold text-ctp-text">${title}</h3>
        </div>
    @endif
    <div class="p-6">
        ${content}
    </div>
</div>
