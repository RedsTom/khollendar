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
            <!-- Indicateur d'utilisateur connecté -->
            @template.components.UserHeader(username = currentUser.username())

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
                  action="/kholles/${session.id()}/preferences/save"
                  method="post">
                <input type="hidden"
                       name="${_csrf.getParameterName()}"
                       value="${_csrf.getToken()}">

                @template.components.Card(
                    title = "Étape 3 : Confirmation",
                    content = @`
                        <div class="flex items-center justify-between mb-4">
                            <p class="text-xl mb-0">
                                Vérifiez le récapitulatif de vos choix avant la validation finale.
                            </p>
                            @template.components.StepIndicator(currentStep = 3)
                        </div>

                        @template.components.Alert(
                            type = "warning",
                            body = @`
                                <b>Attention :</b> L'envoi de vos préférences est définitif.
                                Après validation, vous ne pourrez plus modifier vos choix pour cette khôlle.
                            `
                        )

                        <!-- Résumé des créneaux -->
                        <div class="mb-6">
                            <h3 class="text-lg font-semibold mb-3">Récapitulatif de vos choix :</h3>

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
                                                        <div class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-ctp-red/20 text-ctp-red">
                                                            <i class="h-3 w-3 mr-1" data-feather="x-circle"></i>
                                                            Indisponible
                                                        </div>
                                                    @else
                                                        !{
                                                            int rank = rankedSlots.indexOf(slot) + 1;
                                                            String rankDisplay = rank > 0 ? "Choix n°" + rank : "Non classé";
                                                            String bgColor = rank > 0 ? "bg-ctp-green/20" : "bg-ctp-yellow/20";
                                                            String textColor = rank > 0 ? "text-ctp-green" : "text-ctp-yellow";
                                                            String icon = rank > 0 ? "check-circle" : "alert-circle";
                                                        }
                                                        <div class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${bgColor} ${textColor}">
                                                            <i class="h-3 w-3 mr-1" data-feather="${icon}"></i>
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
                            @template.components.Button(
                                href = "/kholles/" + session.id() + "/preferences?step=2",
                                variant = "secondary",
                                content = @`
                                    <i data-feather="arrow-left" class="h-4 w-4 mr-2"></i>
                                    Retour
                                `
                            )

                            @template.components.Button(
                                type = "submit",
                                variant = "primary",
                                content = @`
                                    Confirmer mes choix
                                    <i data-feather="check" class="h-4 w-4 ml-2"></i>
                                `
                            )
                        </div>
                    `
                )
            </form>
        </div>
    `
)
