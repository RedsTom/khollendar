@param String username
@param String error = null
@param String cardTitle
@param String formAction
@param String inputLabel
@param String inputHelpText = null
@param String submitButtonText
@param String warningMessage = null
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.components.ui.Card(
    title = cardTitle,
    extraClasses = "w-full max-w-md shadow-lg",
    content = @`
        @if (error != null)
            @template.components.ui.Alert(
                type = "error",
                body = @`${error}`
            )
        @endif

        @if(warningMessage != null)
            @template.components.ui.Alert(
                type = "warning",
                body = @`${warningMessage}`
            )
        @endif

        <!-- Avatar et nom d'utilisateur -->
        <div class="flex flex-col items-center mb-6">
            <div class="w-20 h-20 rounded-full bg-gradient-to-br from-ctp-blue to-ctp-mauve flex items-center justify-center mb-3 shadow-lg">
                <i class="feather-icon icon-user"></i>

            </div>
            <p class="text-lg font-semibold text-ctp-text">${username}</p>
        </div>

        <form hx-post="${formAction}"
              hx-target="closest #form-container"
              hx-swap="innerHTML"
              class="space-y-6">
            <div class="form-field">
                <label for="secretCode">${inputLabel}</label>
                <input type="password" id="secretCode" name="secretCode" pattern="[0-9]{6}" maxlength="6" inputmode="numeric" required autofocus>
                @if(inputHelpText != null)
                    <p class="help-text">${inputHelpText}</p>
                @endif
            </div>

            <div class="pt-2">
                <button type="submit" class="button primary w-full">
                    ${submitButtonText}
                </button>
            </div>
        </form>

        <div class="mt-6 pt-4 border-t border-ctp-surface1">
            <a href="/user/login" class="flex items-center justify-center gap-2 text-sm text-ctp-subtext0 hover:text-ctp-text transition-colors">
                <i class="feather-icon icon-arrow-left"></i>

                <span>Retour à la sélection d'utilisateur</span>
            </a>
        </div>
    `)
