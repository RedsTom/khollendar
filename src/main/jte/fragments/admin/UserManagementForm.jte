@import org.springframework.security.web.csrf.CsrfToken

@param CsrfToken _csrf

<form action="/admin/users" method="post">
    <input type="hidden"
           name="${_csrf.getParameterName()}"
           value="${_csrf.getToken()}">

    <div class="form-field">
        <label for="username">Nom d'utilisateur</label>
        <div class="flex flex-col sm:flex-row gap-4">
            <input type="text"
                   id="username"
                   name="username"
                   placeholder="Ex: Jean Dupont"
                   required
                   autofocus
                   class="flex-1">
            @template.components.ui.Button(
                type = "submit",
                variant = "primary",
                extraClasses = "w-full sm:w-auto",
                content = @`Ajouter`
            )
        </div>
    </div>
</form>

