@import fr.redstom.khollendar.entity.User
@import java.util.List

@param List<User> users
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{
    List<User> sortedUsers = users.stream()
        .sorted((u1, u2) -> u1.username().compareToIgnoreCase(u2.username()))
        .toList();
}

@if(users.isEmpty())
    @template.components.ui.Alert(
        type = "warning",
        body = @`Aucun utilisateur disponible. Veuillez contacter l'administrateur.`
    )
@else
    @template.components.ui.Alert(
        type = "warning",
        body = @`Vous ne vous voyez pas dans la liste ? Contactez l'administrateur pour qu'il crée votre compte.`
    )

    <form action="/user-auth/select" method="post" class="space-y-6">
        <input type="hidden"
               name="${_csrf.getParameterName()}"
               value="${_csrf.getToken()}">

        <div class="form-field">
            <label for="userId">Sélectionner votre nom d'utilisateur</label>
            <select id="userId" name="userId" required>
                <option value="">-- Sélectionner un utilisateur --</option>
                @for(User user : sortedUsers)
                    <option value="${user.id()}">${user.username()}</option>
                @endfor
            </select>
        </div>

        <div class="pt-2">
            @template.components.ui.Button(
                type = "submit",
                variant = "primary",
                extraClasses = "w-full",
                content = @`Continuer`
            )
        </div>
    </form>
@endif
