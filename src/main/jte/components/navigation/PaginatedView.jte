@import org.springframework.data.domain.Page
@import java.util.function.Function

@param Page<?> page
@param int currentPage
@param Function<Integer, String> urlMaker
@param String paramName

<div class="flex justify-between items-center mt-4">
    <div class="text-sm text-ctp-subtext0">
        Page ${currentPage + 1} sur ${page.getTotalPages() == 0 ? 1 : page.getTotalPages()}
    </div>
    <div class="flex space-x-2">
        @if(page.hasPrevious())
            <a href="${urlMaker.apply(currentPage - 1)}"
               class="px-3 py-1 bg-ctp-surface1 hover:bg-ctp-surface2 rounded text-sm scroll-preserve">
                Précédent
            </a>
        @else
            <span class="px-3 py-1 bg-ctp-crust text-ctp-subtext0 rounded text-sm cursor-not-allowed">
                Précédent
            </span>
        @endif

        @if(page.hasNext())
            <a href="${urlMaker.apply(currentPage + 1)}"
               class="px-3 py-1 bg-ctp-surface1 hover:bg-ctp-surface2 rounded text-sm scroll-preserve">
                Suivant
            </a>
        @else
            <span class="px-3 py-1 bg-ctp-crust text-ctp-subtext0 rounded text-sm cursor-not-allowed">
                Suivant
            </span>
        @endif
    </div>
</div>
