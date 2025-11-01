@import fr.redstom.khollendar.entity.User
@import org.springframework.data.domain.Page

@param Page<User> users

<div id="user-list" class="flex flex-col h-full">
    @if(users.isEmpty())
        @template.components.ui.Alert(
        type = "info",
        body = @`Aucun utilisateur disponible.`
        )
    @else
        <!-- Vue en tableau pour les écrans moyens et grands -->
        <div class="hidden md:block overflow-x-auto">
            <table class="min-w-full">
                <thead class="bg-ctp-mantle">
                <tr>
                    <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                        ID
                    </th>
                    <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                        Nom d'utilisateur
                    </th>
                    <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                        Code initialisé
                    </th>
                    <th class="py-3 px-4 text-left text-sm font-medium text-ctp-text border-b border-ctp-surface1">
                        Actions
                    </th>
                </tr>
                </thead>
                <tbody class="divide-y divide-ctp-surface1">
                @for(fr.redstom.khollendar.entity.User user : users.getContent())
                    @template.fragments.admin.UserTableRow(user = user, page = users.getNumber())
                @endfor
                </tbody>
            </table>
        </div>

        <!-- Vue en cartes pour mobile -->
        <div class="md:hidden space-y-4">
            @for(fr.redstom.khollendar.entity.User user : users.getContent())
                @template.fragments.admin.UserCard(user = user, page = users.getNumber())
            @endfor
        </div>

        @if(users.getTotalPages() > 1)
            @template.components.navigation.PaginatedView(
                page = users,
                urlMaker = (newPage) -> "/admin/users/paginated?page=" + newPage,
                target = "user-list"
            )
        @endif
    @endif
</div>