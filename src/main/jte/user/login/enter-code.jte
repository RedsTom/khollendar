@param String username
@param String error

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Entrer votre code secret",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        <div class="bg-ctp-base rounded-lg p-8 shadow-lg w-full max-w-md border border-ctp-surface0">
            <h2 class="text-2xl font-bold mb-6 text-ctp-text text-center">Connexion utilisateur</h2>

            @if (error != null)
                <div class="mb-4 p-3 bg-ctp-surface0 border border-ctp-red rounded-lg text-ctp-red text-sm flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zm-1 9a1 1 0 01-1-1v-4a1 1 0 112 0v4a1 1 0 01-1 1z" clip-rule="evenodd" />
                    </svg>
                    ${error}
                </div>
            @endif

            <div class="mb-4 p-3 bg-ctp-surface0 border border-ctp-blue rounded-lg text-ctp-blue text-sm flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                </svg>
                Utilisateur : ${username}
            </div>

            <form action="/user-auth/enter-code" method="post" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="space-y-2">
                    <label for="secretCode" class="block text-sm font-medium text-ctp-text">Code secret à 6 chiffres</label>
                    <input type="password" id="secretCode" name="secretCode"
                           pattern="[0-9]{6}" maxlength="6" inputmode="numeric" required
                           class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface1 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:border-ctp-blue text-ctp-text">
                </div>

                <div class="pt-2">
                    <button type="submit"
                            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-ctp-base bg-ctp-blue hover:bg-ctp-blue/80 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-ctp-blue transition duration-150 ease-in-out">
                        Se connecter
                    </button>
                </div>
            </form>

            <div class="mt-4 text-center">
                <a href="/user-auth/select" class="text-ctp-blue hover:text-ctp-blue/80 text-sm">
                    Retour à la sélection d'utilisateur
                </a>
            </div>
        </div>
    </div>
`)
