@import org.springframework.data.domain.Page
@import java.util.function.Function

@param Page<?> page
@param int currentPage
@param Function<Integer, String> urlMaker
@param String paramName

<div class="flex justify-between items-center mt-4">
    <div class="text-sm text-gray-400">
        Page ${currentPage + 1} sur ${page.getTotalPages() == 0 ? 1 : page.getTotalPages()}
    </div>
    <div class="flex space-x-2">
        @if(page.hasPrevious())
            <a href="${urlMaker.apply(currentPage - 1)}"
               class="px-3 py-1 bg-slate-600 hover:bg-slate-500 rounded text-sm scroll-preserve">
                Précédent
            </a>
        @else
            <span class="px-3 py-1 bg-slate-800 text-slate-500 rounded text-sm cursor-not-allowed">
                Précédent
            </span>
        @endif

        @if(page.hasNext())
            <a href="${urlMaker.apply(currentPage + 1)}"
               class="px-3 py-1 bg-slate-600 hover:bg-slate-500 rounded text-sm scroll-preserve">
                Suivant
            </a>
        @else
            <span class="px-3 py-1 bg-slate-800 text-slate-500 rounded text-sm cursor-not-allowed">
                Suivant
            </span>
        @endif
    </div>
</div>
