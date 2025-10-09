@import fr.redstom.khollendar.entity.User

@param User user

<div class="bg-ctp-surface0 rounded-lg p-4 border border-ctp-surface1">
    <div class="space-y-2">
        <div class="flex justify-between items-start">
            <div>
                <p class="text-xs text-ctp-subtext0">ID</p>
                <p class="font-medium">${user.id()}</p>
            </div>
            <div>
                @if(user.codeInitialized())
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-green/20 text-ctp-green">
                        Code initialisé
                    </span>
                @else
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-ctp-yellow/20 text-ctp-yellow">
                        Code non initialisé
                    </span>
                @endif
            </div>
        </div>
        <div>
            <p class="text-xs text-ctp-subtext0">Nom d'utilisateur</p>
            <p class="font-medium">${user.username()}</p>
        </div>
        <div class="flex gap-2 pt-2">
            @if(user.codeInitialized())
                <button class="button warning sm flex items-center gap-1 w-full justify-center flex-1"
                        hx-confirm="Êtes-vous sûr de vouloir réinitialiser le code de ${user.username()} ?"
                        hx-post="/admin/users/${user.id()}/reset-code">
                    <i class="fa-solid fa-key"></i>

                    Réinitialiser le code
                </button>
            @endif
            <button class="button danger sm flex-1 flex items-center gap-1 w-full justify-center"
                    hx-confirm="Êtes-vous sûr de vouloir supprimer l'utilisateur ${user.username()} ?"
                    hx-delete="/admin/users/${user.id()}">
                <i class="fa-solid fa-trash"></i>

                Supprimer
            </button>
        </div>
    </div>
</div>
