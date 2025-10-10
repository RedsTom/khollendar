package fr.redstom.khollendar.crons;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import fr.redstom.khollendar.service.KholleAssignmentService;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

/**
 * Service de planification automatique des affectations de khôlles. Exécute un cron quotidien pour
 * affecter les étudiants aux créneaux des sessions commençant dans moins de 48h.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class AffectationCron {

    private final KholleSessionRepository sessionRepository;
    private final KholleAssignmentService assignmentService;

    /**
     * Tâche planifiée exécutée tous les jours à 2h du matin. Affecte automatiquement les étudiants
     * aux créneaux des sessions qui commencent dans moins de 48h et qui n'ont pas encore été
     * affectées.
     */
    @Scheduled(cron = "0 0 2 * * *") // Tous les jours à 2h
    public void assignUpcomingSessions() {
        log.info("=== Début de la tâche planifiée d'affectation des sessions ===");

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime in72hours = now.plusHours(72);

        // Récupération de toutes les sessions à venir
        List<KholleSession> upcomingSessions = sessionRepository.findUpcomingKholleSessions(now);

        int processedCount = 0;
        int skippedCount = 0;
        int errorCount = 0;

        for (KholleSession session : upcomingSessions) {
            try {
                // Vérifier si la session commence dans moins de 72h
                Optional<LocalDateTime> firstSlotDate =
                        session.kholleSlots().stream()
                                .map(KholleSlot::dateTime)
                                .min(LocalDateTime::compareTo);

                if (firstSlotDate.isEmpty()) {
                    log.warn("Session {} n'a aucun créneau, ignorée", session.id());
                    skippedCount++;
                    continue;
                }

                if (firstSlotDate.get().isAfter(in72hours)) {
                    // La session commence dans plus de 48h, on passe
                    log.debug(
                            "Session {} commence le {}, trop loin dans le futur",
                            session.id(),
                            firstSlotDate.get());
                    continue;
                }

                // Vérifier si la session a déjà été affectée
                if (assignmentService.isSessionAssigned(session.id())) {
                    log.debug("Session {} déjà affectée, ignorée", session.id());
                    skippedCount++;
                    continue;
                }

                // Effectuer l'affectation
                log.info(
                        "Affectation de la session {} ({}), premier créneau le {}",
                        session.id(),
                        session.subject(),
                        firstSlotDate.get());

                assignmentService.assignStudentsToSlots(session.id());
                processedCount++;

                log.info("Session {} affectée avec succès", session.id());

            } catch (Exception e) {
                errorCount++;
                log.error(
                        "Erreur lors de l'affectation de la session {}: {}",
                        session.id(),
                        e.getMessage(),
                        e);
            }
        }

        log.info("=== Fin de la tâche planifiée d'affectation ===");
        log.info(
                "Sessions traitées: {}, ignorées: {}, erreurs: {}",
                processedCount,
                skippedCount,
                errorCount);
    }

    /**
     * Méthode manuelle pour déclencher l'affectation immédiatement (utile pour les tests ou
     * l'administration)
     */
    public void triggerManualAssignment() {
        log.info("Déclenchement manuel de l'affectation");
        assignUpcomingSessions();
    }
}
