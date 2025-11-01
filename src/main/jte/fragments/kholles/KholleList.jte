@import fr.redstom.khollendar.entity.KholleSession
@import org.springframework.data.domain.Page

@param String title
@param Page<KholleSession> page
@param int type

<div id="${type}-kholle-list" class="flex flex-col h-full">
    @if(page.isEmpty())
        <p class="text-ctp-subtext0 text-sm sm:text-base">
            Aucune session de khôlles trouvée
        </p>
    @else
        <div class="space-y-3 mb-4">
            @for(KholleSession session : page.getContent())
                @template.components.kholles.KholleSession(session = session)
            @endfor
        </div>

        <div class="flex-1"></div>

        @template.components.navigation.PaginatedView(
            page = page,
            urlMaker = (newPage) -> "/kholles/paginated?type=" + type + "&page=" + newPage,
            target = "${type}-kholle-list"
        )
    @endif
</div>