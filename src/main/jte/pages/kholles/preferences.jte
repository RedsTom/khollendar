@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import fr.redstom.khollendar.entity.User
@import java.time.format.DateTimeFormatter
@import java.util.List
@import java.util.Locale
@import java.util.Map

@param KholleSession session
@param User currentUser
@param List<KholleSlot> slots
@param Map<String, String> slotPreferences
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
title = "Mes disponibilités",
_csrf = _csrf,
content = @`
    <div class="container mx-auto p-4">
        <div class="bg-ctp-surface0 rounded-lg p-6">
            <div class="mb-6">
                <a href="/kholles/${session.id()}" class="text-ctp-blue hover:underline">
                    &larr; Retour à la session
                </a>
            </div>

            <h1 class="text-3xl font-bold mb-2">${session.subject()}</h1>
            <p class="text-ctp-subtext0 mb-6">Indiquer mes disponibilités pour cette khôlle</p>

            <div class="bg-ctp-surface1 p-4 rounded-lg mb-6">
                <h2 class="text-xl font-semibold mb-2">Utilisateur connecté</h2>
                <p>Vous êtes connecté en tant que : <span class="font-medium">${currentUser.username()}</span></p>
            </div>

            <form action="/kholles/${session.id()}/preferences" method="POST" class="space-y-6">
                <input type="hidden" name="${_csrf.getParameterName()}" value="${_csrf.getToken()}"/>

                <div>
                    <h2 class="text-2xl font-semibold mb-4">Classez vos préférences</h2>
                    <p class="text-ctp-subtext0 mb-4">Classez les créneaux par ordre de préférence (1 = créneau
                        préféré)</p>

                    <div class="space-y-4">
                        @for(KholleSlot slot : slots)
                            <div class="flex items-center gap-4 p-4 bg-ctp-surface2 rounded-lg">
                                <div class="flex-grow">
                                    <p class="font-medium">${slot.dateTime().format(formatter)}</p>
                                </div>
                                <div>
                                    <label>
                                        <select name="preference_${slot.id()}"
                                                class="bg-ctp-base border border-ctp-overlay0 rounded-md px-3 py-2">
                                            <option value="">Pas de préférence</option>
                                            @for(int index = 1; index <= slots.size(); index++)
                                                @if(slotPreferences != null && slotPreferences.containsKey("preference_" + slot.id()) && slotPreferences.get("preference_" + slot.id()).equals(String.valueOf(index)))
                                                    <option value="${index}" selected>${index}</option>
                                                @else
                                                    <option value="${index}">${index}</option>
                                                @endif
                                            @endfor
                                        </select>
                                    </label>
                                </div>
                            </div>
                        @endfor
                    </div>
                </div>

                <div>
                    <h2 class="text-2xl font-semibold mb-4">Créneaux indisponibles</h2>
                    <p class="text-ctp-subtext0 mb-4">Indiquez les créneaux où vous ne pouvez pas être présent</p>

                    <div class="space-y-4">
                        @for(KholleSlot slot : slots)
                            <div class="flex items-center gap-4 p-4 bg-ctp-surface2 rounded-lg">
                                <div class="flex-grow">
                                    <p class="font-medium">${slot.dateTime().format(formatter)}</p>
                                </div>
                                <div>
                                    <label class="inline-flex items-center cursor-pointer">
                                        @if(slotPreferences != null && slotPreferences.containsKey("unavailable_" + slot.id()))
                                            <input type="checkbox" name="unavailable_${slot.id()}" class="sr-only peer" checked>
                                        @else
                                            <input type="checkbox" name="unavailable_${slot.id()}" class="sr-only peer">
                                        @endif
                                        <div class="relative w-11 h-6 bg-ctp-overlay0 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-ctp-red"></div>
                                        <span class="ml-3 text-sm font-medium">Indisponible</span>
                                    </label>
                                </div>
                            </div>
                        @endfor
                    </div>
                </div>

                <div class="flex justify-end">
                    <button type="submit"
                            class="px-6 py-3 bg-ctp-blue text-white font-medium rounded-md hover:bg-ctp-sapphire transition-colors">
                        Enregistrer mes disponibilités
                    </button>
                </div>
            </form>
        </div>
    </div>
`
)
