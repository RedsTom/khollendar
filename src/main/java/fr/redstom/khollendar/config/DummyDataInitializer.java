package fr.redstom.khollendar.config;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Classe permettant de générer des données de test pour l'application
 */
@Configuration
@RequiredArgsConstructor
public class DummyDataInitializer {

    private final KholleSessionRepository kholleSessionRepository;
    private final Random random = new Random();

    private final String[] SUBJECTS = {
        "Mathématiques", "Physique", "Chimie", "Informatique", "Biologie",
        "Français", "Philosophie", "Histoire", "Géographie", "Anglais",
        "Espagnol", "Allemand", "Économie", "Droit", "Sciences politiques"
    };

    /**
     * Génère et insère des données de test dans la base de données
     */
    @Bean
    @Profile("!prod && false") // N'exécute pas en production
    public CommandLineRunner initData() {
        return args -> {
            // Vérifier si des données existent déjà
            if (kholleSessionRepository.count() > 0) {
                System.out.println("Des données existent déjà dans la base - Initialisation ignorée");
                return;
            }

            System.out.println("Initialisation des données de test...");

            // Générer des sessions passées (il y a quelques jours/semaines)
            generatePastSessions(10);

            // Générer des sessions à venir (dans les prochains jours/semaines)
            generateUpcomingSessions(15);

            System.out.println("Initialisation terminée : " + kholleSessionRepository.count() + " sessions créées");
        };
    }

    /**
     * Génère des sessions de khôlles passées
     */
    private void generatePastSessions(int count) {
        for (int i = 0; i < count; i++) {
            // Date de base: entre 1 et 60 jours dans le passé
            LocalDateTime baseDate = LocalDateTime.now()
                    .minusDays(random.nextInt(60) + 1)
                    .truncatedTo(ChronoUnit.HOURS);

            createKholleSession(baseDate, true);
        }
    }

    /**
     * Génère des sessions de khôlles à venir
     */
    private void generateUpcomingSessions(int count) {
        for (int i = 0; i < count; i++) {
            // Date de base: entre 1 et 30 jours dans le futur
            LocalDateTime baseDate = LocalDateTime.now()
                    .plusDays(random.nextInt(30) + 1)
                    .truncatedTo(ChronoUnit.HOURS);

            createKholleSession(baseDate, false);
        }
    }

    /**
     * Crée une session de khôlles avec des créneaux
     */
    private void createKholleSession(LocalDateTime baseDate, boolean isPast) {
        String subject = SUBJECTS[random.nextInt(SUBJECTS.length)];

        // Créer une session vide d'abord
        KholleSession session = KholleSession.builder()
                .subject(subject)
                .kholleSlots(new ArrayList<>())
                .build();

        // Sauvegarder pour obtenir un ID
        session = kholleSessionRepository.save(session);

        // Nombre de créneaux: entre 3 et 8
        int slotCount = random.nextInt(6) + 3;
        List<KholleSlot> slots = new ArrayList<>();

        // Générer des créneaux autour de la date de base
        for (int i = 0; i < slotCount; i++) {
            LocalDateTime slotDateTime;

            if (isPast) {
                // Pour les sessions passées, générer des dates autour de la date de base
                slotDateTime = baseDate.plusHours(random.nextInt(48) - 24);
            } else {
                // Pour les sessions futures, générer des dates après la date de base
                slotDateTime = baseDate.plusHours(random.nextInt(48));
            }

            // Ajuster l'heure pour qu'elle soit entre 8h et 18h
            slotDateTime = slotDateTime
                    .withHour(8 + random.nextInt(10))
                    .withMinute(random.nextInt(4) * 15); // minutes: 0, 15, 30, 45

            KholleSlot slot = KholleSlot.builder()
                    .dateTime(slotDateTime)
                    .session(session)
                    .build();

            slots.add(slot);
        }

        // Mettre à jour la session avec ses créneaux
        session = session.toBuilder()
                .kholleSlots(slots)
                .build();

        kholleSessionRepository.save(session);
    }
}
