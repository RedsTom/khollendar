@import fr.redstom.khollendar.entity.User

@param User user
@param int page = 0

<tr class="hover:bg-ctp-mantle/50">
    <td class="py-2 px-4 text-sm">${user.id()}</td>
    <td class="py-2 px-4 text-sm">${user.username()}</td>
    <td class="py-2 px-4 text-sm">
        @if(user.codeInitialized())
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                Oui
            </span>
        @else
            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-yellow/20 text-ctp-yellow">
                Non
            </span>
        @endif
    </td>
    <td class="py-2 px-4 text-sm">
        <div class="grid grid-cols-2 gap-2">
            @if(user.codeInitialized())
                <button class="button warning sm flex items-center gap-1"
                        hx-target="#user-list"
                        hx-confirm="Êtes-vous sûr de vouloir réinitialiser le code de ${user.username()} ?"
                        hx-post="/admin/users/${user.id()}/reset-code?page=${page}">
                    <i class="fa-solid fa-key"></i>

                    Réinitialiser le code
                </button>
            @endif
            <button class="button danger sm flex items-center gap-1 col-start-2"
                    hx-target="#user-list"
                    hx-confirm="Êtes-vous sûr de vouloir supprimer l'utilisateur ${user.username()} ?"
                    hx-delete="/admin/users/${user.id()}?page=${page}">
                <i class="fa-solid fa-trash"></i>

                Supprimer
            </button>
        </div>
    </td>
</tr>

