@param java.util.List<fr.redstom.khollendar.entity.User> users

@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
title = "Connexion utilisateur",
_csrf = _csrf,
content = @`
    <div class="flex justify-center items-center min-h-[80vh]">
        <div class="bg-ctp-base rounded-lg p-8 shadow-lg w-full max-w-md border border-ctp-surface0">
            <h2 class="text-2xl font-bold mb-6 text-ctp-text text-center">Connexion utilisateur</h2>

            @if(users.isEmpty())
                <div class="p-3 bg-ctp-surface0 border border-ctp-yellow rounded-lg text-ctp-text text-sm">
                    <div class="flex items-center">
                        <i class="h-5 w-5 mr-4 text-ctp-yellow" data-feather="info"></i>
                        <span>Aucun utilisateur disponible. Veuillez contacter l'administrateur.</span>
                    </div>
                </div>
            @else
                <div class="mb-6 p-3 bg-ctp-surface0 border border-ctp-yellow rounded-lg text-ctp-text text-sm">
                    <div class="flex items-center">
                        <i class="h-5 w-5 mr-4 text-ctp-yellow" data-feather="info"></i>
                        <span>
                            Vous ne vous voyez pas dans la liste ? Contactez l'administrateur pour qu'il crée votre compte.
                        </span>
                    </div>
                </div>

                <form action="/user-auth/select" method="post" class="space-y-6">
                    <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                    <div class="space-y-2">
                        <label for="userId" class="block text-sm font-medium text-ctp-text">
                            Sélectionner votre nom d'utilisateur
                        </label>
                        <select class="w-full px-3 py-2 bg-ctp-surface0 border border-ctp-surface1 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-ctp-blue focus:border-ctp-blue text-ctp-text"
                                id="userId" name="userId" required>
                            <option value="">-- Sélectionner un utilisateur --</option>
                            @for(fr.redstom.khollendar.entity.User user : users)
                                <option value="${user.id()}">${user.username()}</option>
                            @endfor
                        </select>
                    </div>

                    <div class="pt-2">
                        <button type="submit"
                                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-ctp-base bg-ctp-blue hover:bg-ctp-blue/80 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-ctp-blue transition duration-150 ease-in-out">
                            Continuer
                        </button>
                    </div>
                </form>
            @endif
        </div>
    </div>
`)
