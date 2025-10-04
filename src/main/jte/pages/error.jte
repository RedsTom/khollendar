@param String errorMessage
@param String errorDescription
@param Integer statusCode = null
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = "Erreur",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4 flex items-center justify-center min-h-[calc(100vh-200px)]">
            <div class="max-w-2xl w-full">
                <!-- Carte d'erreur -->
                <div class="bg-ctp-surface0 rounded-lg shadow-lg p-8 text-center">
                    <!-- Icône d'erreur -->
                    <div class="mb-6">
                        <div class="inline-flex items-center justify-center w-24 h-24 bg-ctp-red/20 rounded-full">
                            <svg class="w-12 h-12 text-ctp-red" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Code d'erreur -->
                    @if(statusCode != null)
                        <div class="mb-4">
                            <span class="inline-block px-4 py-2 bg-ctp-surface1 rounded-full text-ctp-red font-mono text-sm">
                                Erreur ${statusCode}
                            </span>
                        </div>
                    @endif

                    <!-- Message d'erreur -->
                    <h1 class="text-4xl font-bold text-ctp-text mb-4">
                        ${errorMessage}
                    </h1>

                    <!-- Description -->
                    <p class="text-lg text-ctp-subtext0 mb-8">
                        ${errorDescription}
                    </p>

                    <!-- Bouton de retour -->
                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <a href="/"
                           class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-ctp-blue hover:bg-ctp-blue/80 text-ctp-base font-semibold rounded-lg transition-colors duration-200">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                            </svg>
                            Retour à l'accueil
                        </a>

                        <button onclick="window.history.back()"
                                class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-ctp-surface1 hover:bg-ctp-surface2 text-ctp-text font-semibold rounded-lg transition-colors duration-200">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                            </svg>
                            Page précédente
                        </button>
                    </div>
                </div>

                <!-- Message d'aide supplémentaire -->
                <div class="mt-6 text-center">
                    <p class="text-sm text-ctp-subtext1">
                        Si le problème persiste, contactez l'administrateur du site.
                    </p>
                </div>
            </div>
        </div>
    `
)
