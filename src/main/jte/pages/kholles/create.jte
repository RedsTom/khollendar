@import java.time.format.DateTimeFormatter

@param String title
@param org.springframework.security.web.csrf.CsrfToken _csrf

@template.layout.MainLayout(
    title = title,
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- Breadcrumb -->
            <div class="mb-6">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i data-feather="chevron-right" class="w-4 h-4"></i>
                        <span class="text-ctp-text">Créer une session</span>
                    `
                )
            </div>

            <!-- En-tête -->
            <div class="mb-6">
                <h1 class="text-2xl font-bold">${title}</h1>
                <p class="text-ctp-subtext0">
                    Remplissez le formulaire ci-dessous pour créer une nouvelle session de khôlles.
                </p>
            </div>

            @template.components.ui.Card(
                content = @`
                    <form action="/kholles/create" method="post" class="max-w-3xl">
                        <div class="form-field">
                            <label for="subject">Matière / Sujet</label>
                            <input type="text"
                                   id="subject"
                                   name="subject"
                                   placeholder="Ex: Mathématiques - Intégrales"
                                   required
                                   autofocus>
                        </div>

                        <div class="mb-6">
                            <h3 class="text-lg font-medium mb-4 text-ctp-blue flex items-center gap-2">
                                <i data-feather="clock" class="w-5 h-5"></i>
                                Créneaux horaires
                            </h3>
                            <div id="slots-container" class="space-y-4">
                                <!-- Les créneaux seront ajoutés ici -->
                            </div>

                            <button class="button success mt-4" onclick="addSlot()">
                                <i data-feather="plus" class="mr-2"></i>
                                Ajouter un créneau
                            </button>
                        </div>

                        <input type="hidden"
                               name="${_csrf.getParameterName()}"
                               value="${_csrf.getToken()}"/>

                        <div class="flex justify-end">
                            <button type="submit" class="button primary lg">
                                Créer la session
                            </button>
                        </div>
                    </form>
                `
            )
        </div>

        <script src="/js/slot-management.js"></script>
    `
)
