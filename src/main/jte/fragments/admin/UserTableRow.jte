@import fr.redstom.khollendar.entity.User
@import org.springframework.security.web.csrf.CsrfToken

@param User user

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
        <div class="flex gap-2">
            @if(user.codeInitialized())
                <form action="/admin/users/${user.id()}/reset-code"
                      method="post">
                    <button type="submit" class="button warning sm flex items-center gap-1"
                            onclick="return confirm('Êtes-vous sûr de vouloir réinitialiser le code de ${user.username()} ?')">
                        <i data-feather="key" class="w-3 h-3"></i>
                        Réinitialiser code
                    </button>
                </form>
            @endif
            <button class="button danger sm flex items-center gap-1"
                    hx-confirm="Êtes-vous sûr de vouloir supprimer l'utilisateur ${user.username()} ?"
                    hx-delete="/admin/users/${user.id()}">
                <i data-feather="trash-2" class="w-3 h-3"></i>
                Supprimer
            </button>
        </div>
    </td>
</tr>

