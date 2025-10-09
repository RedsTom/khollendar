@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import java.time.format.DateTimeFormatter
@import java.util.Comparator
@import java.util.List
@import java.util.Locale
@import java.util.Set

@param KholleSession session
@param User currentUser
@param List<KholleSlot> rankedSlots
@param Set<KholleSlot> unavailableSlots
@param List<KholleSlot> allSlots
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
    title = "Confirmation de mes préférences",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <!-- Breadcrumb -->
            <div class="mb-4">
                @template.components.navigation.Breadcrumb(
                    content = @`
                        <a href="/" class="hover:text-ctp-blue transition-colors">
                            Accueil
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <a href="/kholles" class="hover:text-ctp-blue transition-colors">
                            Sessions de khôlles
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <a href="/kholles/${session.id()}" class="hover:text-ctp-blue transition-colors">
                            ${session.subject()}
                        </a>
                        <i class="fa-solid fa-chevron-right"></i>
                        <span class="text-ctp-text">Confirmation</span>
                    `
                )
            </div>

            <!-- Indicateur d'utilisateur connecté -->
            @template.components.layout.UserHeader(username = currentUser.username())

            <!-- En-tête -->
            <div class="rounded-lg mb-4">
                <h1 class="text-3xl font-bold mb-4">
                    Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
                </h1>
                <p class="text-xl text-ctp-subtext0">
                    Veuillez confirmer vos choix avant l'envoi définitif.
                </p>
            </div>

            <form id="confirmForm"
                  hx-post="/kholles/${session.id()}/preferences/confirm">
                @template.components.ui.Card(
                    title = "Étape 3 : Confirmation",
                    content = @`
                        <!-- Barre de progression -->
                        @template.components.layout.ProgressBar(currentStep = 3, totalSteps = 3)

                        @template.components.ui.Alert(
                            type = "warning",
                            body = @`
                                <b>Attention :</b> L'envoi de vos préférences est définitif.
                                Après validation, vous ne pourrez plus modifier vos choix pour cette khôlle.
                            `
                        )

                        <!-- Résumé des créneaux -->
                        <div class="mb-6">
                            <h3 class="text-lg font-semibold mb-3 text-ctp-blue flex items-center gap-2">
                                <i class="fa-solid fa-list"></i>
                                Récapitulatif de vos choix :
                            </h3>

                            <div class="overflow-hidden rounded-lg border border-ctp-surface2 mb-6">
                                <table class="w-full">
                                    <thead class="bg-ctp-surface1 border-b border-ctp-surface2">
                                        <tr>
                                            <th class="px-4 py-3 text-left text-sm font-medium">Créneau</th>
                                            <th class="px-4 py-3 text-left text-sm font-medium">Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-ctp-surface2">
                                        @for(KholleSlot slot : allSlots)
                                            <tr class="bg-ctp-base">
                                                <td class="px-4 py-3">
                                                    ${slot.dateTime().format(formatter)}
                                                </td>
                                                <td class="px-4 py-3">
                                                    @if(unavailableSlots.contains(slot))
                                                        <div class="inline-flex gap-1 items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-red/20 text-ctp-red">
                                                            <i class="fa-solid fa-circle-xmark"></i>
                                                            Indisponible
                                                        </div>
                                                    @else
                                                        !{
                                                            int rank = rankedSlots.indexOf(slot) + 1;
                                                            String rankDisplay = rank > 0 ? "Choix n°" + rank : "Non classé";
                                                            String bgColor = rank > 0 ? "bg-ctp-green/20" : "bg-ctp-yellow/20";
                                                            String textColor = rank > 0 ? "text-ctp-green" : "text-ctp-yellow";
                                                            String icon = rank > 0 ? "circle-check" : "circle-exclamation";
                                                        }
                                                        <div class="inline-flex gap-1 items-center px-2 py-1 rounded-full text-xs font-medium ${bgColor} ${textColor}">
                                                            <i class="fa-solid fa-${icon}"></i>
                                                            ${rankDisplay}
                                                        </div>
                                                    @endif
                                                </td>
                                            </tr>
                                        @endfor
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Boutons d'action -->
                        <div class="mt-6 flex flex-col sm:flex-row justify-between gap-4">
                            <button hx-post="/kholles/${session.id()}/preferences/previous" class="button secondary">
                                <i class="fa-solid fa-arrow-left"></i>
                                Retour
                            </button>

                            <button type="submit" class="button primary">
                                Confirmer mes choix
                                <i class="fa-solid fa-check"></i>
                            </button>
                        </div>
                    `
                )
            </form>
        </div>
    `
)
