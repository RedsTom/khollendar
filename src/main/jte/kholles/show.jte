@import fr.redstom.khollendar.entity.KholleSession
@import fr.redstom.khollendar.entity.KholleSlot
@import java.time.format.DateTimeFormatter
@import java.util.Locale

@param KholleSession session
@param org.springframework.security.web.csrf.CsrfToken _csrf

!{DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.FRENCH);}

@template.layout.MainLayout(
    title = "Détails de la session",
    _csrf = _csrf,
    content = @`
        <div class="container mx-auto p-4">
            <div class="bg-ctp-surface0 rounded-lg p-6">
                <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start mb-4">
                    <div>
                        <h1 class="text-3xl font-bold">${session.subject()}</h1>
                        @if(session.calculateDateRange().isPresent())
                            <p class="text-ctp-subtext0">
                                Du ${session.calculateDateRange().get().start().format(formatter)}
                                au ${session.calculateDateRange().get().end().format(formatter)}
                            </p>
                        @endif
                    </div>
                </div>

                <div class="mt-6">
                    <h2 class="text-2xl font-semibold mb-4">Horaires disponibles</h2>
                    @if(session.kholleSlots().isEmpty())
                        <p class="text-ctp-subtext0">Aucun horaire disponible pour cette session.</p>
                    @else
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            @for(KholleSlot slot : session.kholleSlots())
                                <div class="bg-ctp-surface1 p-4 rounded-lg flex justify-between items-center">
                                    <div>
                                        <p class="font-semibold">${slot.dateTime().format(DateTimeFormatter.ofPattern("EEEE d MMMM yyyy 'à' HH:mm", Locale.FRENCH))}</p>
                                    </div>
                                </div>
                            @endfor
                        </div>
                    @endif
                </div>
            </div>
        </div>
    `
)
