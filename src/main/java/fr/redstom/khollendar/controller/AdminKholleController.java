package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.AssignmentSummary;
import fr.redstom.khollendar.dto.SlotWithPreferenceDto;
import fr.redstom.khollendar.dto.UserPreferenceSummary;
import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.repository.KholleAssignmentRepository;
import fr.redstom.khollendar.repository.UserPreferenceRepository;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.PreferenceService;
import fr.redstom.khollendar.service.UserService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatusCode;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpServerErrorException;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/kholles/{kholleId}")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminKholleController {

    private final KholleService kholleService;
    private final PreferenceService preferenceService;
    private final UserService userService;
    private final UserPreferenceRepository userPreferenceRepository;
    private final KholleAssignmentRepository kholleAssignmentRepository;

    @GetMapping("/preferences")
    public String preferences(
            @PathVariable Long kholleId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        List<UserPreference> preferences = userPreferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session);
        List<UserPreferenceSummary> groupedPreferences = preferenceService.groupPreferencesByUser(preferences);

        model.addAttribute("sessionId", kholleId);
        model.addAttribute("session", session);
        model.addAttribute("groupedPreferences", groupedPreferences);

        return "pages/admin/kholles/preferences";
    }

    @DeleteMapping("/preferences/user/{userId}")
    @Transactional
    public String deleteUserPreferences(
            @PathVariable Long kholleId,
            @PathVariable Long userId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        User user = userService.getUserById(userId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        userPreferenceRepository.deleteByUserAndSession(user, session);

        // Recharger les préférences mises à jour depuis la base de données
        List<UserPreference> preferences = userPreferenceRepository.findBySessionOrderByUserIdAscPreferenceRankAsc(session);
        List<UserPreferenceSummary> groupedPreferences = preferenceService.groupPreferencesByUser(preferences);

        model.addAttribute("session", session);
        model.addAttribute("groupedPreferences", groupedPreferences);

        return "fragments/admin/PreferencesTable";
    }

    @GetMapping("/assignments")
    public String assignments(
            @PathVariable Long kholleId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        List<KholleAssignment> assignments = kholleAssignmentRepository.findBySessionOrderByIdAsc(session);

        // Trier les affectations par date/heure de créneau
        List<KholleAssignment> sortedAssignments = assignments.stream()
                .sorted(Comparator.comparing(a -> a.slot().dateTime()))
                .collect(Collectors.toList());

        // Grouper les affectations par créneau (slot ID) et trier
        Map<Long, List<KholleAssignment>> assignmentsBySlot = sortedAssignments.stream()
                .collect(Collectors.groupingBy(
                        a -> a.slot().id(),
                        java.util.LinkedHashMap::new,
                        Collectors.toList()
                ));

        model.addAttribute("sessionId", kholleId);
        model.addAttribute("session", session);
        model.addAttribute("assignments", sortedAssignments);
        model.addAttribute("assignmentsBySlot", assignmentsBySlot);

        return "pages/admin/kholles/assignments";
    }

    @DeleteMapping("/assignments/{assignmentId}")
    @Transactional
    public String deleteAssignment(
            @PathVariable Long kholleId,
            @PathVariable Long assignmentId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        KholleAssignment assignment = kholleAssignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        kholleAssignmentRepository.delete(assignment);

        // Recharger les affectations mises à jour depuis la base de données
        List<KholleAssignment> assignments = kholleAssignmentRepository.findBySessionOrderByIdAsc(session);

        // Trier et grouper par créneau
        List<KholleAssignment> sortedAssignments = assignments.stream()
                .sorted(Comparator.comparing(a -> a.slot().dateTime()))
                .collect(Collectors.toList());

        Map<Long, List<KholleAssignment>> assignmentsBySlot = sortedAssignments.stream()
                .collect(Collectors.groupingBy(
                        a -> a.slot().id(),
                        java.util.LinkedHashMap::new,
                        Collectors.toList()
                ));

        model.addAttribute("session", session);
        model.addAttribute("assignments", sortedAssignments);
        model.addAttribute("assignmentsBySlot", assignmentsBySlot);

        return "fragments/admin/AssignmentsTable";
    }

    @GetMapping("/assignments/{assignmentId}/edit")
    public String getEditAssignmentModal(
            @PathVariable Long kholleId,
            @PathVariable Long assignmentId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        KholleAssignment assignment = kholleAssignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        // Récupérer toutes les préférences de l'utilisateur pour cette session
        List<UserPreference> userPreferences = userPreferenceRepository
                .findByUserAndSessionOrderByPreferenceRankAsc(assignment.user(), session);

        // Créer un map des préférences par slot
        Map<Long, UserPreference> preferencesBySlot = userPreferences.stream()
                .collect(Collectors.toMap(pref -> pref.slot().id(), pref -> pref));

        // Créer la liste des créneaux avec les rangs de préférence
        List<SlotWithPreferenceDto> slotsWithPreferences = session.kholleSlots().stream()
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .map(slot -> {
                    UserPreference pref = preferencesBySlot.get(slot.id());
                    return new SlotWithPreferenceDto(
                            slot,
                            pref != null ? pref.preferenceRank() : null,
                            pref != null ? pref.isUnavailable() : false
                    );
                })
                .collect(Collectors.toList());

        model.addAttribute("session", session);
        model.addAttribute("assignment", assignment);
        model.addAttribute("slotsWithPreferences", slotsWithPreferences);

        return "fragments/admin/EditAssignmentModal";
    }

    @PutMapping("/assignments/{assignmentId}")
    @Transactional
    public String updateAssignment(
            @PathVariable Long kholleId,
            @PathVariable Long assignmentId,
            @RequestParam Long newSlotId,
            Model model
    ) {
        KholleSession session = kholleService.getKholleSessionById(kholleId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        KholleAssignment assignment = kholleAssignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        // Trouver le nouveau créneau
        KholleSlot newSlot = session.kholleSlots().stream()
                .filter(slot -> slot.id().equals(newSlotId))
                .findFirst()
                .orElseThrow(() -> new HttpServerErrorException(HttpStatusCode.valueOf(404)));

        // Récupérer les préférences de l'utilisateur pour calculer le nouveau rang
        List<UserPreference> userPreferences = userPreferenceRepository
                .findByUserAndSessionOrderByPreferenceRankAsc(assignment.user(), session);

        Integer newPreferenceRank = userPreferences.stream()
                .filter(pref -> pref.slot().id().equals(newSlotId))
                .map(UserPreference::preferenceRank)
                .findFirst()
                .orElse(null);

        // Créer une nouvelle affectation avec les nouvelles valeurs
        KholleAssignment updatedAssignment = assignment.toBuilder()
                .slot(newSlot)
                .obtainedPreferenceRank(newPreferenceRank)
                .assignedAt(LocalDateTime.now())
                .build();

        kholleAssignmentRepository.save(updatedAssignment);

        // Recharger les données pour le tableau
        List<KholleAssignment> assignments = kholleAssignmentRepository.findBySessionOrderByIdAsc(session);

        // Trier et grouper par créneau
        List<KholleAssignment> sortedAssignments = assignments.stream()
                .sorted(Comparator.comparing(a -> a.slot().dateTime()))
                .collect(Collectors.toList());

        Map<Long, List<KholleAssignment>> assignmentsBySlot = sortedAssignments.stream()
                .collect(Collectors.groupingBy(
                        a -> a.slot().id(),
                        java.util.LinkedHashMap::new,
                        Collectors.toList()
                ));

        model.addAttribute("session", session);
        model.addAttribute("assignments", sortedAssignments);
        model.addAttribute("assignmentsBySlot", assignmentsBySlot);

        return "fragments/admin/AssignmentsTable";
    }

}
