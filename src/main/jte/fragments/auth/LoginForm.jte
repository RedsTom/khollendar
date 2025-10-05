@import org.springframework.security.web.csrf.CsrfToken

@param CsrfToken _csrf
@param boolean error = false

@if(error)
    @template.components.ui.Alert(
        type = "error",
        message = "Nom d'utilisateur ou mot de passe incorrect"
    )
@endif

<form action="/login" method="post" class="space-y-6">
    <input type="hidden"
           name="${_csrf.getParameterName()}"
           value="${_csrf.getToken()}"/>

    <div class="form-field">
        <label for="username">Nom d'utilisateur</label>
        <input type="text"
               id="username"
               name="username"
               required>
    </div>

    <div class="form-field">
        <label for="password">Mot de passe</label>
        <input type="password"
               id="password"
               name="password"
               required>
    </div>

    <div class="pt-2">
        <button type="submit" class="button primary w-full">
            Se connecter
        </button>
    </div>
</form>

