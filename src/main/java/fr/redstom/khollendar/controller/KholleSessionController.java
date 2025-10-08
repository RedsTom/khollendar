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

import fr.redstom.khollendar.dto.KhollePatchDto;
import fr.redstom.khollendar.dto.KholleSessionCreationDto;
import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.service.*;
import fr.redstom.khollendar.utils.AuthUtils;
import java.util.*;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/** Contrôleur pour la gestion des sessions de khôlles */
@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
public class KholleSessionController {

    private final KholleService kholleService;
    private final PreferenceService preferenceService;
    private final SessionService sessionService;
    private final KholleSlotService kholleSlotService;
    private final UserService userService;
    private final KholleAssignmentService assignmentService;

    /** Liste toutes les sessions de khôlles */
    @GetMapping
    public String list(
            @RequestParam(defaultValue = "0") int previousPage,
            @RequestParam(defaultValue = "0") int upcomingPage,
            @RequestParam(defaultValue = "0") int allPage,
            Model model) {
        model.addAttribute("title", "Liste des sessions de khôlles");

        // Récupérer les données paginées via le service
        Page<KholleSession> previousSessions = kholleService.getPreviousKholleSessions(previousPage, 5);
        Page<KholleSession> upcomingSessions = kholleService.getUpcomingKholleSessions(upcomingPage, 5);
        Page<KholleSession> allSessions = kholleService.getAllKholleSessions(allPage, 10);

        // Ajouter les données au modèle
        model.addAttribute("previousSessions", previousSessions);
        model.addAttribute("upcomingSessions", upcomingSessions);
        model.addAttribute("allSessions", allSessions);
        model.addAttribute("previousPage", previousPage);
        model.addAttribute("upcomingPage", upcomingPage);
        model.addAttribute("allPage", allPage);

        return "pages/kholles/list";
    }

    /** Formulaire de création d'une nouvelle khôlle */
    @GetMapping("/create")
    public String createForm(Model model) {
        model.addAttribute("title", "Créer une session de khôlles");
        return "pages/kholles/create";
    }

    /** Traitement de la création d'une nouvelle khôlle */
    @PostMapping("/create")
    public String create(@ModelAttribute KholleSessionCreationDto dto) {
        kholleService.createKholle(dto);
        return "redirect:/kholles";
    }

    /** Affiche les détails d'une session de khôlle */
    @GetMapping("/{id}")
    public String show(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<KholleSession> sessionOpt = kholleService.getKholleSessionById(id);

        if (sessionOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Session de khôlle non trouvée");
            return "redirect:/kholles";
        }

        KholleSession session = sessionOpt.get();

        // Récupérer toutes les préférences des utilisateurs pour cette session
        Map<User, List<UserPreference>> userPreferences = kholleService.getAllUserPreferencesForSession(id);

        // Récupérer les créneaux indisponibles pour chaque utilisateur
        Map<User, List<KholleSlot>> userUnavailableSlots = new LinkedHashMap<>();
        for (User user : userPreferences.keySet()) {
            List<KholleSlot> unavailableSlots = kholleService.getUnavailableSlots(user.id(), id);
            userUnavailableSlots.put(user, unavailableSlots);
        }

        // Récupérer le nombre d'utilisateurs ayant enregistré leurs préférences
        long registeredUsersCount = kholleService.getRegisteredUsersCount(id);

        // Vérifier si l'utilisateur est admin
        boolean isAdmin = AuthUtils.admin();

        // Récupérer les affectations si elles existent
        List<KholleAssignment> assignments = assignmentService.getSessionAssignments(session);
        Map<Long, List<KholleAssignment>> assignmentsBySlot = new HashMap<>();

        if (!assignments.isEmpty()) {
            // Grouper par créneau
            assignmentsBySlot = assignments.stream()
                    .collect(Collectors.groupingBy(a -> a.slot().id()));
        }

        model.addAttribute("title", "Détails de la session de khôlle");
        model.addAttribute("session", session);
        model.addAttribute("userPreferences", userPreferences);
        model.addAttribute("userUnavailableSlots", userUnavailableSlots);
        model.addAttribute("registeredUsersCount", registeredUsersCount);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("assignments", assignments);
        model.addAttribute("assignmentsBySlot", assignmentsBySlot);

        return "pages/kholles/show";
    }

    /**
     * Suppression d'une session de khôlle (admin uniquement)
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            kholleService.deleteKholleSession(id);

            return ResponseEntity.status(HttpStatus.NO_CONTENT)
                    .header("HX-Redirect", "/kholles")
                    .build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    /**
     * Edition d'une session de khôlle (admin uniquement)
     */
    @PatchMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateSession(@PathVariable Long id, @ModelAttribute KhollePatchDto patch) {
        try {
            kholleService.edit(id, patch);

            return ResponseEntity.status(HttpStatus.NO_CONTENT)
                    .header("HX-Refresh", "true")
                    .build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
}
