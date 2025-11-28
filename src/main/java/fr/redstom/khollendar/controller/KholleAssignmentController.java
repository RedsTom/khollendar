/*
 * Kholle'n'dar is a web application to manage oral interrogations planning
 * for French students.
 * Copyright (C) 2025 Tom BUTIN
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
  * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.crons.AffectationCron;
import fr.redstom.khollendar.entity.KholleAssignment;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.service.KholleAssignmentService;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.SessionService;
import jakarta.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/** Contrôleur pour la gestion des affectations de khôlles */
@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
@Slf4j
public class KholleAssignmentController {

    private final KholleAssignmentService assignmentService;
    private final KholleService kholleService;

    /** Affiche les affectations d'une session de khôlle */
    @GetMapping("/{id}/assignments")
    public String showAssignments(@PathVariable Long id, HttpSession httpSession, Model model, Principal principal) {
        Optional<KholleSession> sessionOpt = kholleService.getKholleSessionById(id);

        // Vérifier si la session existe
        if (sessionOpt.isEmpty()) {
            return "redirect:/kholles";
        }

        KholleSession session = sessionOpt.get();

        // Vérifier si les affectations existent
        if (!assignmentService.isSessionAssigned(id)) {
            return "redirect:/kholles/" + id;
        }

        // Récupérer toutes les affectations
        List<KholleAssignment> assignments = assignmentService.getSessionAssignments(session);

        // Vérifier si l'utilisateur est admin
        boolean isAdmin = principal != null && principal.getName().equals("admin");

        // === Calcul des statistiques ===

        // Distribution des rangs de préférence
        Map<Integer, Long> rankDistribution = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() != null)
                .collect(Collectors.groupingBy(KholleAssignment::obtainedPreferenceRank, Collectors.counting()));

        // Nombre d'affectations sans préférence
        long withoutPreferences = assignments.stream()
                .filter(a -> a.obtainedPreferenceRank() == null)
                .count();

        // Nombre d'élèves ayant eu leur premier choix
        long firstChoice = rankDistribution.getOrDefault(1, 0L);

        // Taux de satisfaction (élèves ayant eu leur premier choix / élèves avec préférence)
        long assignmentsWithPreferences = assignments.size() - withoutPreferences;
        double satisfactionRate =
                assignmentsWithPreferences == 0 ? 0 : (double) firstChoice / assignmentsWithPreferences * 100;

        model.addAttribute("session", session);

        model.addAttribute("assignments", assignments);
        model.addAttribute("rankDistribution", rankDistribution);
        model.addAttribute("totalAssignments", assignments.size());
        model.addAttribute("withoutPreferences", withoutPreferences);
        model.addAttribute("satisfactionRate", satisfactionRate);

        model.addAttribute("isAdmin", isAdmin);

        return "pages/kholles/assignments";
    }

    /** Déclenche manuellement l'affectation d'une session (admin uniquement) */
    @PostMapping("/{id}/assignments/trigger")
    @PreAuthorize("hasRole('ADMIN')")
    public String triggerAssignment(@PathVariable Long id) {
        try {
            log.info("Déclenchement manuel de l'affectation pour la session {}", id);

            // Vérifier que la session existe
            Optional<KholleSession> sessionOpt = kholleService.getKholleSessionById(id);
            if (sessionOpt.isEmpty()) {
                return "redirect:/kholles";
            }

            // Effectuer l'affectation
            assignmentService.assignStudentsToSlots(id);

            return "redirect:/kholles/" + id + "/assignments";

        } catch (IllegalStateException e) {
            log.error("Erreur lors de l'affectation manuelle de la session {}: {}", id, e.getMessage());
            return "redirect:/kholles/" + id;
        } catch (Exception e) {
            log.error("Erreur inattendue lors de l'affectation manuelle de la session {}", id, e);
            return "redirect:/kholles/" + id;
        }
    }
}
