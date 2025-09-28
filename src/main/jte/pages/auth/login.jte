@param String title
@param String error
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = title,
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        <div class="bg-ctp-base rounded-lg p-8 shadow-lg w-full max-w-md border border-ctp-surface0">
            <h2 class="text-2xl font-bold mb-6 text-ctp-text text-center">Connexion administrateur</h2>

            @if(error != null)
                <div class="mb-4 p-3 bg-ctp-surface0 border border-ctp-red rounded-lg text-ctp-red text-sm flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 text-ctp-red" viewBox="0 0 20 20"
                         fill="currentColor">
                        <path fill-rule="evenodd"
                              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"
                              clip-rule="evenodd"/>
                    </svg>
                    Nom d'utilisateur ou mot de passe incorrect
                </div>
            @endif

            <form action="/login" method="post" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                <div class="space-y-2">
                    <label for="username" class="block text-sm font-medium text-ctp-text">Nom d'utilisateur</label>
                    <input type="text" id="username" name="username"
                           class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface1 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:border-ctp-blue text-ctp-text"
                           required>
                </div>

                <div class="space-y-2">
                    <label for="password" class="block text-sm font-medium text-ctp-text">Mot de passe</label>
                    <input type="password" id="password" name="password"
                           class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface1 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:border-ctp-blue text-ctp-text"
                           required>
                </div>

                <div class="pt-2">
                    <button type="submit"
                            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-ctp-base bg-ctp-blue hover:bg-ctp-blue/80 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-ctp-blue transition duration-150 ease-in-out">
                        Se connecter
                    </button>
                </div>
            </form>
        </div>
    </div>
`)
