package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.repository.KholleAssignmentRepository;
import fr.redstom.khollendar.repository.KholleSessionRepository;
import fr.redstom.khollendar.repository.UserPreferenceRepository;
import fr.redstom.khollendar.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Service gérant l'affectation automatique des étudiants aux créneaux de khôlle.
 * Utilise un algorithme de max-min fairness pour minimiser la déception maximale.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class KholleAssignmentService {

    private final KholleSessionRepository sessionRepository;
    private final UserPreferenceRepository preferenceRepository;
    private final KholleAssignmentRepository assignmentRepository;
    private final UserRepository userRepository;
    private final Random random = new Random();

    /**
     * Affecte tous les étudiants aux créneaux d'une session selon leurs préférences.
     * Applique un algorithme de max-min fairness pour minimiser la déception maximale.
     *
     * @param sessionId L'identifiant de la session
     * @return Une map associant chaque étudiant au créneau qui lui a été attribué
     * @throws IllegalArgumentException Si la session n'existe pas
     * @throws IllegalStateException Si la session n'a pas de créneaux
     */
    @Transactional
    public Map<User, KholleSlot> assignStudentsToSlots(Long sessionId) {
        log.info("Début de l'affectation pour la session {}", sessionId);

        // Récupération de la session
        KholleSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Session non trouvée : " + sessionId));

        List<KholleSlot> slots = session.kholleSlots();
        if (slots == null || slots.isEmpty()) {
            throw new IllegalStateException("Aucun créneau disponible pour cette session");
        }

        // Suppression des anciennes affectations si elles existent
        assignmentRepository.deleteBySession(session);

        // Récupération de toutes les préférences pour cette session
        List<UserPreference> allPreferences = preferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session);

        // Groupement des préférences par utilisateur
        Map<User, List<UserPreference>> preferencesByUser = allPreferences.stream()
                .collect(Collectors.groupingBy(UserPreference::user));

        // Récupération de TOUS les utilisateurs de l'application
        List<User> allUsers = userRepository.findAll();
        Set<User> allUsersSet = new HashSet<>(allUsers);

        // Calcul de la capacité moyenne par créneau basée sur TOUS les utilisateurs
        int totalStudents = allUsersSet.size();
        int numberOfSlots = slots.size();
        int averageCapacity = (int) Math.ceil((double) totalStudents / numberOfSlots);

        log.info("Session {}: {} étudiants à affecter sur {} créneaux (capacité moyenne: {})",
                sessionId, totalStudents, numberOfSlots, averageCapacity);
        log.info("  - {} étudiants avec préférences", preferencesByUser.size());
        log.info("  - {} étudiants sans préférences", totalStudents - preferencesByUser.size());

        // Application de l'algorithme d'affectation
        Map<User, KholleSlot> assignments = performMaxMinFairnessAssignment(
                allUsersSet, preferencesByUser, slots, averageCapacity);

        // Sauvegarde des affectations en base
        LocalDateTime now = LocalDateTime.now();
        List<KholleAssignment> assignmentEntities = assignments.entrySet().stream()
                .map(entry -> {
                    User user = entry.getKey();
                    KholleSlot slot = entry.getValue();

                    // Détermination du rang de préférence obtenu
                    Integer obtainedRank = null;
                    List<UserPreference> userPrefs = preferencesByUser.get(user);
                    if (userPrefs != null) {
                        obtainedRank = userPrefs.stream()
                                .filter(pref -> pref.slot().id().equals(slot.id()))
                                .map(UserPreference::preferenceRank)
                                .findFirst()
                                .orElse(null);
                    }

                    return KholleAssignment.builder()
                            .user(user)
                            .session(session)
                            .slot(slot)
                            .assignedAt(now)
                            .obtainedPreferenceRank(obtainedRank)
                            .build();
                })
                .collect(Collectors.toList());

        assignmentRepository.saveAll(assignmentEntities);

        // Changer le statut de la session vers RESULTS_AVAILABLE après affectation
        KholleSession updatedSession = session.toBuilder()
                .status(KholleSessionStatus.RESULTS_AVAILABLE)
                .build();
        sessionRepository.save(updatedSession);

        log.info("Affectation terminée pour la session {}. {} affectations créées.", sessionId, assignments.size());
        logAssignmentStatistics(assignmentEntities);

        return assignments;
    }

    /**
     * Algorithme d'affectation basé sur max-min fairness.
     * À chaque tour, on affecte les étudiants selon leur meilleur choix disponible,
     * en respectant les contraintes de capacité.
     */
    private Map<User, KholleSlot> performMaxMinFairnessAssignment(
            Set<User> users,
            Map<User, List<UserPreference>> preferencesByUser,
            List<KholleSlot> slots,
            int averageCapacity) {

        Map<User, KholleSlot> assignments = new HashMap<>();
        Map<KholleSlot, Integer> slotCapacities = new HashMap<>();

        // Initialisation des capacités (moyenne ± 1)
        for (KholleSlot slot : slots) {
            slotCapacities.put(slot, averageCapacity);
        }

        Set<User> unassignedUsers = new HashSet<>(users);
        int currentPreferenceRank = 1;
        int maxPreferenceRank = preferencesByUser.values().stream()
                .mapToInt(List::size)
                .max()
                .orElse(0);

        // Affectation par rang de préférence croissant (max-min fairness)
        while (!unassignedUsers.isEmpty() && currentPreferenceRank <= maxPreferenceRank) {
            int currentRank = currentPreferenceRank;

            // Collecte des étudiants voulant leur n-ième choix
            Map<KholleSlot, List<User>> candidatesBySlot = new HashMap<>();

            for (User user : unassignedUsers) {
                List<UserPreference> prefs = preferencesByUser.get(user);
                if (prefs != null && prefs.size() >= currentRank) {
                    UserPreference preference = prefs.get(currentRank - 1);
                    KholleSlot desiredSlot = preference.slot();

                    // Vérifier que le créneau a encore de la capacité
                    if (slotCapacities.getOrDefault(desiredSlot, 0) > 0) {
                        candidatesBySlot.computeIfAbsent(desiredSlot, k -> new ArrayList<>()).add(user);
                    }
                }
            }

            // Affectation des étudiants pour ce rang
            for (Map.Entry<KholleSlot, List<User>> entry : candidatesBySlot.entrySet()) {
                KholleSlot slot = entry.getKey();
                List<User> candidates = entry.getValue();
                int availableCapacity = slotCapacities.get(slot);

                if (candidates.size() <= availableCapacity) {
                    // Tout le monde peut être affecté
                    for (User user : candidates) {
                        assignments.put(user, slot);
                        unassignedUsers.remove(user);
                    }
                    slotCapacities.put(slot, availableCapacity - candidates.size());
                } else {
                    // Tirage aléatoire pour départager
                    Collections.shuffle(candidates, random);
                    List<User> selectedUsers = candidates.subList(0, availableCapacity);

                    for (User user : selectedUsers) {
                        assignments.put(user, slot);
                        unassignedUsers.remove(user);
                    }
                    slotCapacities.put(slot, 0);
                }
            }

            currentPreferenceRank++;
        }

        // Affectation aléatoire des étudiants restants (sans préférences satisfaites)
        if (!unassignedUsers.isEmpty()) {
            List<User> remainingUsers = new ArrayList<>(unassignedUsers);
            Collections.shuffle(remainingUsers, random);

            for (User user : remainingUsers) {
                // Trouver un créneau avec de la capacité
                KholleSlot availableSlot = slotCapacities.entrySet().stream()
                        .filter(e -> e.getValue() > 0)
                        .max(Comparator.comparingInt(Map.Entry::getValue))
                        .map(Map.Entry::getKey)
                        .orElseGet(() -> {
                            // Si tous les créneaux sont pleins, choisir celui avec le moins d'étudiants
                            return slots.get(random.nextInt(slots.size()));
                        });

                assignments.put(user, availableSlot);
                slotCapacities.merge(availableSlot, -1, Integer::sum);
            }
        }

        return assignments;
    }

    /**
     * Affiche les statistiques d'affectation dans les logs
     */
    private void logAssignmentStatistics(List<KholleAssignment> assignments) {
        Map<Integer, Long> rankDistribution = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() != null)
                .collect(Collectors.groupingBy(
                        KholleAssignment::obtainedPreferenceRank,
                        Collectors.counting()
                ));

        long withoutPreferences = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() == null)
                .count();

        log.info("Statistiques d'affectation:");
        rankDistribution.entrySet().stream()
                .sorted(Map.Entry.comparingByKey())
                .forEach(entry -> log.info("  - Choix #{}: {} étudiants", entry.getKey(), entry.getValue()));

        if (withoutPreferences > 0) {
            log.info("  - Sans préférence satisfaite: {} étudiants", withoutPreferences);
        }

        // Calcul du taux de satisfaction
        long firstChoice = rankDistribution.getOrDefault(1, 0L);
        double satisfactionRate = (double) firstChoice / assignments.size() * 100;
        log.info("Taux de satisfaction (1er choix): {}%", String.format("%.1f", satisfactionRate));
    }

    /**
     * Récupère l'affectation d'un utilisateur pour une session
     */
    public Optional<KholleAssignment> getAssignment(Long userId, Long sessionId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé : " + userId));

        KholleSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Session non trouvée : " + sessionId));

        return assignmentRepository.findByUserAndSession(user, session);
    }

    /**
     * Récupère toutes les affectations d'une session
     */
    public List<KholleAssignment> getSessionAssignments(Long sessionId) {
        KholleSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Session non trouvée : " + sessionId));

        return assignmentRepository.findBySession(session);
    }

    /**
     * Vérifie si les affectations ont été effectuées pour une session
     */
    public boolean isSessionAssigned(Long sessionId) {
        KholleSession session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new IllegalArgumentException("Session non trouvée : " + sessionId));

        return !assignmentRepository.findBySession(session).isEmpty();
    }
}
