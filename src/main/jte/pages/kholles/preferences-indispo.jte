@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import fr.redstom.khollendar.utils.WordUtils
@import java.time.format.DateTimeFormatter
@import java.util.Comparator
@import java.util.List
@import java.util.Locale

@param KholleSession session
@param User currentUser
@param List<KholleSlot> slots
@param org.springframework.security.web.csrf.CsrfToken _csrf
@param List<Long> unavailableSlotIds = null

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}
!{List<KholleSlot> sortedSlots = slots.stream().sorted(Comparator.comparing(KholleSlot::dateTime)).toList();}

@template.layout.MainLayout(
title = "Mes disponibilités",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4 max-w-6xl">
        <!-- Indicateur d'utilisateur connecté -->
        @template.components.Alert(
        type = "info",
        message = "Vous êtes actuellement connecté en tant que <b>${currentUser.username()}</b>"
        )

        <!-- En-tête -->
        <div class="mb-6">
            <h1 class="text-2xl sm:text-3xl font-bold mb-4 break-words">
                Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
            </h1>
            <p class="text-base sm:text-xl text-ctp-subtext0 leading-relaxed">
                Indiquez vos disponibilités afin de vous affecter à la séance de khôlle qui vous convient le mieux.
            </p>
        </div>

        @template.components.Card(
        title = "Étape 1 : Mes indisponibilités",
        content = @`
            <form id="unavailabilityForm" action="/kholles/${session.id()}/preferences/step1" method="post">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

                <div class="mb-6">
                    <div class="w-full bg-ctp-surface1 rounded-full h-2 mb-4">
                        <div class="bg-ctp-blue h-2 rounded-full transition-all duration-300"
                             style="width: 33.33%"></div>
                    </div>
                    <p class="text-sm text-ctp-subtext0">Étape 1 sur 3</p>
                </div>

                <p class="text-ctp-text mb-6 text-sm sm:text-base">
                    <i data-feather="info" class="inline w-4 h-4 mr-2"></i>
                    Cochez les créneaux où vous n'êtes <strong>pas disponible</strong>.
                    Les créneaux non cochés seront considérés comme disponibles pour la suite.
                </p>

                @template.components.Alert(
                type = "warning",
                body = @`
                    <p>
                        <b>Attention :</b> Lorsque vous indiquez une indisponibilité, cela empêche le système de
                        vous affecter à une séance à ce créneau. Merci de n'indiquer que vos indisponibilités
                        réelles. Les indisponibilités possibles sont notamment :
                    </p>
                    <ul class="list-disc list-inside mt-2 mb-4">
                        <li>Vous avez un autre cours à ce créneau</li>
                        <li>Vous devez prendre un transport pour rentrer chez vous le week-end</li>
                        <li>Vous avez un rendez-vous</li>
                    </ul>
                    <p>
                        En revanche, n'indiquez pas comme indisponible un créneau où vous préférez ne pas avoir de
                        khôlle, mais où vous pourriez en avoir une si nécessaire. Pour cela, classez ce créneau en bas
                        de votre liste de préférences à l'étape suivante.
                    </p>
                `)

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
                    @for(KholleSlot slot : sortedSlots)
                        !{var slotId = slot.id().toString();}
                        !{var isUnavailable = unavailableSlotIds != null && unavailableSlotIds.contains(slot.id());}

                        <div class="time-slot-container select-none">
                            <input type="checkbox"
                                   id="slot-${slotId}"
                                   name="unavailable-slots"
                                   value="${slotId}"
                                   disabled="${isUnavailable}"
                                   class="hidden slot-checkbox">

                            <label for="slot-${slotId}"
                                   class="time-slot flex items-center p-4 rounded-lg border border-ctp-surface2 cursor-pointer transition-all duration-200 hover:bg-ctp-surface1 bg-ctp-base">
                                <div class="checkbox-custom mr-3 w-5 h-5 rounded-md border border-ctp-overlay0 flex items-center justify-center flex-shrink-0">
                                    <i class="check-icon text-white w-3 h-3" data-feather="x"></i>
                                </div>
                                <span class="slot-text text-sm font-medium leading-tight break-words text-ctp-text">
                                        ${WordUtils.capitalizeFirst(slot.dateTime().format(formatter))}
                                    </span>
                            </label>
                        </div>
                    @endfor
                </div>

                <div class="flex flex-col sm:flex-row justify-between gap-4">
                    @template.components.Button(
                    href = "/kholles",
                    variant = "secondary",
                    content = @`
                        <i data-feather="arrow-left" class="mr-2 w-4 h-4"></i>
                        Retour à la liste
                    `
                    )

                    @template.components.Button(
                    type = "submit",
                    variant = "primary",
                    content = @`
                        Continuer
                        <i data-feather="arrow-right" class="ml-2 w-4 h-4"></i>
                    `
                    )
                </div>
            </form>
        `
        )
    </div>

    <style>
        .time-slot-container .checkbox-custom .check-icon {
            opacity: 0;
        }

        .time-slot-container .slot-checkbox:checked + .time-slot {
            background-color: rgba(243, 139, 168, 0.15); /* ctp-red avec transparence */
            border-color: rgb(243, 139, 168); /* ctp-red */
        }

        .time-slot-container .slot-checkbox:checked + .time-slot .checkbox-custom {
            background-color: rgb(243, 139, 168); /* ctp-red */
            border-color: rgb(243, 139, 168); /* ctp-red */
        }

        .time-slot-container .slot-checkbox:checked + .time-slot .check-icon {
            opacity: 1;
        }

        .time-slot-container .slot-checkbox:checked + .time-slot .slot-text {
            color: rgb(243, 139, 168); /* ctp-red */
        }
    </style>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialiser les icônes Feather
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
        });
    </script>
`)
