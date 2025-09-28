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
        <div class="mb-4 sm:mb-6 p-3 sm:p-4 bg-ctp-surface0 border border-ctp-blue rounded-lg text-ctp-blue text-sm sm:text-base flex items-center">
            <i class="h-4 w-4 sm:h-5 sm:w-5 mr-3 sm:mr-4 text-ctp-blue flex-shrink-0" data-feather="user"></i>
            <span class="break-words">
                Vous êtes actuellement connecté en tant que <b>${currentUser.username()}</b>
            </span>
        </div>

        <!-- En-tête de la page -->
        <div class="rounded-lg mb-6">
            <h1 class="text-2xl sm:text-3xl font-bold mb-4 break-words">
                Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
            </h1>
            <p class="text-base sm:text-xl text-ctp-subtext0 leading-relaxed">
                Indiquez vos disponibilités afin de vous affecter à la séance de khôlle qui vous convient le mieux.
            </p>
        </div>

        <form id="unavailabilityForm" action="/kholles/${session.id()}/preferences/step1" method="post">
            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

            <div class="bg-ctp-surface0 rounded-lg p-4 sm:p-6">
                <!-- En-tête avec indicateur de progrès -->
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6 gap-4">
                    <div class="flex-1 min-w-0">
                        <h2 class="text-xl sm:text-2xl font-semibold mb-2 break-words">
                            Étape 1 : Mes indisponibilités
                        </h2>
                        <p class="text-base sm:text-lg text-ctp-subtext0 leading-relaxed">
                            Indiquez les créneaux horaires où vous n'êtes pas disponible pour cette khôlle.
                        </p>
                    </div>
                    <!-- Indicateur d'étapes - visible uniquement sur desktop -->
                    <div class="hidden lg:block flex-shrink-0">
                        <div class="flex items-center gap-2 text-sm text-ctp-subtext0">
                            <span class="font-bold text-ctp-blue">Étape 1</span>
                            <span class="w-6 sm:w-8 h-0.5 bg-ctp-blue"></span>
                            <span>Étape 2</span>
                            <span class="w-6 sm:w-8 h-0.5 bg-ctp-overlay0"></span>
                            <span>Étape 3</span>
                        </div>
                    </div>
                </div>

                <!-- Avertissement responsive -->
                <div class="mb-6 p-3 sm:p-4 bg-ctp-yellow/20 border border-ctp-yellow rounded-lg text-ctp-yellow text-sm sm:text-base">
                    <div class="flex items-start gap-3 sm:gap-4">
                        <i class="h-4 w-4 sm:h-5 sm:w-5 mt-0.5 text-ctp-yellow flex-shrink-0" data-feather="alert-triangle"></i>
                        <div class="flex-1 min-w-0">
                            <p class="leading-relaxed">
                                <b>Attention :</b> les indisponibilités ne doivent pas être mises à la légère. En effet,
                                elles empêchent complètement le système de vous affecter à un créneau durant ces périodes.
                            </p>
                            <p class="mt-2 leading-relaxed">
                                Il est donc important de ne signaler que les indisponibilités réelles, c'est-à-dire dans les cas suivants :
                            </p>
                            <ul class="list-disc list-inside mt-2 space-y-1 leading-relaxed">
                                <li>Vous avez un empêchement majeur (examen, rendez-vous important, etc.)</li>
                                <li>Vous avez déjà un autre cours à ce moment</li>
                                <li>Vous devez prendre un transport (train, avion, car, etc.) pour rentrer chez vous le week-end</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Grille de créneaux responsive -->
                <fieldset>
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-3 sm:gap-4">
                        @for(KholleSlot slot : sortedSlots)
                            !{boolean isUnavailable = unavailableSlotIds != null && unavailableSlotIds.contains(slot.id());}
                            <div class="time-slot-container select-none">
                                <input type="checkbox" id="slot-${slot.id()}" name="unavailable-slots" value="${slot.id()}"
                                       class="hidden slot-checkbox" checked="${isUnavailable}">
                                <label for="slot-${slot.id()}"
                                       class="time-slot flex items-center p-3 sm:p-4 rounded-lg border border-ctp-surface2 cursor-pointer transition-all duration-200 hover:bg-ctp-surface1 h-full">
                                    <div class="checkbox-custom mr-3 w-5 h-5 sm:w-6 sm:h-6 rounded-md border border-ctp-overlay0 flex items-center justify-center flex-shrink-0">
                                        <i class="check-icon text-white w-3 h-3 sm:w-4 sm:h-4" data-feather="x"></i>
                                    </div>
                                    <span class="slot-text text-sm sm:text-base lg:text-lg font-medium leading-tight break-words min-w-0">${slot.dateTime().format(formatter)}</span>
                                </label>
                            </div>
                        @endfor
                    </div>
                </fieldset>

                <!-- Bouton de navigation responsive -->
                <div class="mt-6 flex justify-end">
                    <button type="submit"
                            class="w-full sm:w-auto px-4 sm:px-6 py-2 sm:py-3 bg-ctp-blue text-ctp-base font-medium rounded-lg hover:bg-ctp-blue/80 transition-colors flex items-center justify-center gap-2">
                        Suivant
                        <i data-feather="arrow-right" class="h-4 w-4"></i>
                    </button>
                </div>
            </div>
        </form>
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
            opacity: 100;
        }

        .time-slot-container .slot-checkbox:checked + .time-slot .slot-text {
            color: rgb(243, 139, 168); /* ctp-red */
        }
    </style>
`
)
