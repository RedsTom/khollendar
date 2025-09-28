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
    <div class="container mx-auto p-4">
        <div class="mb-4 p-3 bg-ctp-surface0 border border-ctp-blue rounded-lg text-ctp-blue text-sm flex items-center">
            <i class="h-5 w-5 mr-4 text-ctp-blue" data-feather="user"></i>
            <span>
                Vous êtes actuellement connectés en tant que <b>${currentUser.username()}</b>
            </span>
        </div>

        <div class="rounded-lg mb-4">
            <h1 class="text-3xl font-bold mb-4">
                Khôlle ${WordUtils.definiteArticle(session.subject(), "de", "d'")}<b>${session.subject()}</b>
            </h1>
            <p class="text-xl text-ctp-subtext0">
                Indiquez vos disponibilités afin de vous affecter à la séance de khôlle qui vous convient le mieux.
            </p>
        </div>

        <form id="unavailabilityForm" action="/kholles/${session.id()}/preferences/step1" method="post">
            <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}">

            <div class="bg-ctp-surface0 rounded-lg p-6">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h2 class="text-2xl font-semibold mb-2">
                            Étape 1 : Mes indisponibilités
                        </h2>
                        <p class="text-xl mb-4">
                            Indiquez les créneaux horaires où vous n'êtes pas disponible pour cette khôlle.
                        </p>
                    </div>
                    <div class="hidden md:block">
                        <div class="flex items-center gap-2 text-sm text-ctp-subtext0">
                            <span class="font-bold text-ctp-blue">Étape 1</span>
                            <span class="w-8 h-0.5 bg-ctp-blue"></span>
                            <span>Étape 2</span>
                            <span class="w-8 h-0.5 bg-ctp-overlay0"></span>
                            <span>Étape 3</span>
                        </div>
                    </div>
                </div>

                <div class="mb-6 p-3 bg-ctp-yellow/20 border border-ctp-yellow rounded-lg text-ctp-yellow text-sm flex items-center">
                    <i class="h-5 w-5 mr-4 text-ctp-yellow" data-feather="alert-triangle"></i>
                    <div class="flex-col">
                        <p>
                            <b>Attention :</b> les indisponibilités ne doivent pas être mises à la légère. En effet,
                            elles
                            empêchent
                            complètement le système de vous affecter à un créneau durant ces périodes.<br/>
                            Il est donc important de ne signaler que les indisponibilités réelles, c'est-à-dire dans les
                            cas suivants :
                        </p>
                        <ul class="list-disc list-inside mt-2">
                            <li>Vous avez un empêchement majeur (examen, rendez-vous important, etc.)</li>
                            <li>Vous avez déjà un autre cours à ce moment</li>
                            <li>Vous devez prendre un transport (train, avion, car, etc.) pour rentrer chez vous le
                                week-end
                            </li>
                        </ul>
                    </div>
                </div>

                <fieldset>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        @for(KholleSlot slot : sortedSlots)
                            !{boolean isUnavailable = unavailableSlotIds != null && unavailableSlotIds.contains(slot.id());}
                            <div class="time-slot-container select-none">
                                <input type="checkbox" id="slot-${slot.id()}" name="unavailable-slots" value="${slot.id()}"
                                       class="hidden slot-checkbox" checked="${isUnavailable}">
                                <label for="slot-${slot.id()}"
                                       class="time-slot flex items-center p-3 rounded-lg border border-ctp-surface2 cursor-pointer transition-all duration-200 hover:bg-ctp-surface1 h-full">
                                    <div class="checkbox-custom mr-3 w-6 h-6 rounded-md border border-ctp-overlay0 flex items-center justify-center">
                                        <i class="check-icon text-white" data-feather="x"></i>
                                    </div>
                                    <span class="slot-text text-lg font-medium">${slot.dateTime().format(formatter)}</span>
                                </label>
                            </div>
                        @endfor
                    </div>
                </fieldset>

                <div class="mt-6 flex justify-end">
                    <button type="submit"
                            class="px-6 py-3 bg-ctp-blue text-ctp-base font-medium rounded-lg hover:bg-ctp-blue/80 transition-colors flex items-center gap-2">
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
