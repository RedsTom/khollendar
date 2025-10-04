package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.crons.AffectationCron;
import fr.redstom.khollendar.entity.KholleAssignment;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.service.KholleAssignmentService;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.SessionService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Contrôleur pour la gestion des affectations de khôlles
 */
@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
@Slf4j
public class KholleAssignmentController {

    private final KholleAssignmentService assignmentService;
    private final AffectationCron schedulerService;
    private final KholleService kholleService;
    private final SessionService sessionService;

    /**
     * Affiche les affectations d'une session de khôlle
     */
    @GetMapping("/{id}/assignments")
    public String showAssignments(
            @PathVariable Long id,
            CsrfToken csrf,
            HttpSession httpSession,
            Model model,
            RedirectAttributes redirectAttributes,
            java.security.Principal principal
    ) {
        Optional<KholleSession> sessionOpt = kholleService.getKholleSessionById(id);

        if (sessionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Session de khôlle non trouvée");
            return "redirect:/kholles";
        }

        KholleSession session = sessionOpt.get();

        // Vérifier si les affectations existent
        if (!assignmentService.isSessionAssigned(id)) {
            redirectAttributes.addFlashAttribute("error", "Aucune affectation n'a encore été effectuée pour cette session");
            return "redirect:/kholles/" + id;
        }

        // Récupérer toutes les affectations
        List<KholleAssignment> assignments = assignmentService.getSessionAssignments(id);

        // Grouper les affectations par créneau
        Map<Long, List<KholleAssignment>> assignmentsBySlot = assignments.stream()
                .collect(Collectors.groupingBy(a -> a.slot().id()));

        // Vérifier si l'utilisateur actuel a une affectation
        KholleAssignment userAssignment = null;
        if (sessionService.isUserAuthenticated(httpSession)) {
            Long userId = sessionService.getCurrentUserId(httpSession);
            userAssignment = assignments.stream()
                    .filter(a -> a.user().id().equals(userId))
                    .findFirst()
                    .orElse(null);
        }

        // Vérifier si l'utilisateur est admin
        boolean isAdmin = principal != null && principal.getName().equals("admin");

        // Calculer les statistiques
        Map<Integer, Long> rankDistribution = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() != null)
                .collect(Collectors.groupingBy(
                        KholleAssignment::obtainedPreferenceRank,
                        Collectors.counting()
                ));

        long withoutPreferences = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() == null)
                .count();

        long firstChoice = rankDistribution.getOrDefault(1, 0L);
        double satisfactionRate = assignments.isEmpty() ? 0 : (double) firstChoice / assignments.size() * 100;

        model.addAttribute("title", "Affectations - " + session.subject());
        model.addAttribute("session", session);
        model.addAttribute("assignments", assignments);
        model.addAttribute("assignmentsBySlot", assignmentsBySlot);
        model.addAttribute("userAssignment", userAssignment);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("rankDistribution", rankDistribution);
        model.addAttribute("withoutPreferences", withoutPreferences);
        model.addAttribute("satisfactionRate", satisfactionRate);
        model.addAttribute("_csrf", csrf);
        model.addAttribute("httpSession", httpSession);

        return "pages/kholles/assignments";
    }

    /**
     * Déclenche manuellement l'affectation d'une session (admin uniquement)
     */
    @PostMapping("/{id}/assignments/trigger")
    @PreAuthorize("hasRole('ADMIN')")
    public String triggerAssignment(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes
    ) {
        try {
            log.info("Déclenchement manuel de l'affectation pour la session {}", id);

            // Vérifier que la session existe
            Optional<KholleSession> sessionOpt = kholleService.getKholleSessionById(id);
            if (sessionOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Session de khôlle non trouvée");
                return "redirect:/kholles";
            }

            // Effectuer l'affectation
            assignmentService.assignStudentsToSlots(id);

            redirectAttributes.addFlashAttribute("success", "Affectation effectuée avec succès");
            return "redirect:/kholles/" + id + "/assignments";

        } catch (IllegalStateException e) {
            log.error("Erreur lors de l'affectation manuelle de la session {}: {}", id, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Erreur : " + e.getMessage());
            return "redirect:/kholles/" + id;
        } catch (Exception e) {
            log.error("Erreur inattendue lors de l'affectation manuelle de la session {}", id, e);
            redirectAttributes.addFlashAttribute("error", "Erreur inattendue lors de l'affectation");
            return "redirect:/kholles/" + id;
        }
    }

    /**
     * Déclenche manuellement l'affectation pour toutes les sessions éligibles (admin uniquement)
     */
    @PostMapping("/assignments/trigger-all")
    @PreAuthorize("hasRole('ADMIN')")
    public String triggerAllAssignments(RedirectAttributes redirectAttributes) {
        try {
            log.info("Déclenchement manuel de l'affectation pour toutes les sessions éligibles");
            schedulerService.triggerManualAssignment();
            redirectAttributes.addFlashAttribute("success", "Affectations déclenchées avec succès pour toutes les sessions éligibles");
        } catch (Exception e) {
            log.error("Erreur lors du déclenchement manuel de toutes les affectations", e);
            redirectAttributes.addFlashAttribute("error", "Erreur lors du déclenchement des affectations");
        }
        return "redirect:/kholles";
    }
}
