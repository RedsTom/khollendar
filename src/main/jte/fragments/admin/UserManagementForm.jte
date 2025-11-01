@import org.springframework.security.web.csrf.CsrfToken

@param CsrfToken _csrf

<form hx-post="/admin/users?page=0"
      hx-target="#user-list"
      hx-on::after-request="if(event.detail.successful) this.reset()">
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
            <button type="submit" class="button primary w-full sm:w-auto">
                Ajouter
            </button>
        </div>
    </div>
</form>

