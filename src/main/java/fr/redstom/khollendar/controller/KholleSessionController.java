package fr.redstom.khollendar.controller;

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import fr.redstom.khollendar.dto.KholleSessionCreationDto;import fr.redstom.khollendar.entity.*;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.KholleSlotService;
import fr.redstom.khollendar.service.PreferenceService;
import fr.redstom.khollendar.service.SessionService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

/**
 * Contrôleur pour la gestion des sessions de khôlles
 */
@Controller
@RequestMapping("/kholles")
@RequiredArgsConstructor
public class KholleSessionController {

    private final KholleService kholleService;
    private final PreferenceService preferenceService;
    private final SessionService sessionService;
    private final KholleSlotService kholleSlotService;

    /**
     * Liste toutes les sessions de khôlles
     */
    @GetMapping
    public String list(
            @RequestParam(defaultValue = "0") int previousPage,
            @RequestParam(defaultValue = "0") int upcomingPage,
            @RequestParam(defaultValue = "0") int allPage,
            CsrfToken csrf,
            Model model
    ) {
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
        model.addAttribute("_csrf", csrf);

        return "pages/kholles/list";
    }

    /**
     * Formulaire de création d'une nouvelle khôlle
     */
    @GetMapping("/create")
    public String createForm(CsrfToken csrf, Model model) {
        model.addAttribute("title", "Créer une session de khôlles");
        model.addAttribute("_csrf", csrf);
        return "pages/kholles/create";
    }

    /**
     * Traitement de la création d'une nouvelle khôlle
     */
    @PostMapping("/create")
    public String create(@ModelAttribute KholleSessionCreationDto dto) {
        kholleService.createKholle(dto);
        return "redirect:/kholles";
    }

    /**
     * Affiche les détails d'une session de khôlle
     */
    @GetMapping("/{id}")
    public String show(@PathVariable Long id, CsrfToken csrf, Model model, RedirectAttributes redirectAttributes) {
        Optional<KholleSession> session = kholleService.getKholleSessionById(id);

        if (session.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Session de khôlle non trouvée");
            return "redirect:/kholles";
        }

        KholleSession kholleSession = session.get();

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

        model.addAttribute("title", "Détails de la session de khôlle");
        model.addAttribute("session", kholleSession);
        model.addAttribute("userPreferences", userPreferences);
        model.addAttribute("userUnavailableSlots", userUnavailableSlots);
        model.addAttribute("registeredUsersCount", registeredUsersCount);
        model.addAttribute("_csrf", csrf);
        return "pages/kholles/show";
    }

    /**
     * Formulaire de gestion des préférences pour une khôlle (entrée principale)
     * Utilise un paramètre d'étape pour naviguer entre les différentes vues
     */
    @GetMapping("/{id}/preferences")
    public String preferences(
            @PathVariable Long id,
            @RequestParam(value = "step", defaultValue = "1") int step,
            HttpSession session,
            HttpServletRequest request,
            CsrfToken csrf,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            sessionService.setRedirectAfterLogin(session, request.getRequestURI());
            return "redirect:/user-auth/select";
        }

        Long userId = sessionService.getCurrentUserId(session);

        try {
            // Récupérer ou créer les préférences dans la session
            KhollePreferencesDto preferences = sessionService.getPreferences(session, id);

            // Mettre à jour l'étape si elle diffère
            if (preferences.step() != step) {
                preferences = new KhollePreferencesDto(id,
                    preferences.unavailableSlotIds(),
                    preferences.rankedSlotIds(),
                    step);
                sessionService.savePreferences(session, preferences);
            }

            // Dispatcher vers la bonne méthode selon l'étape
            switch (step) {
                case 1:
                    preferenceService.prepareUnavailabilityForm(id, userId, model, preferences.unavailableSlotIds());
                    model.addAttribute("_csrf", csrf);
                    return "pages/kholles/preferences-indispo";

                case 2:
                    preferenceService.prepareRankingForm(id, userId,
                        preferences.unavailableSlotIds(),
                        preferences.rankedSlotIds(),
                        model);
                    model.addAttribute("_csrf", csrf);
                    return "pages/kholles/preferences-ranking";

                case 3:
                    preferenceService.prepareConfirmationForm(id, userId,
                        preferences.unavailableSlotIds(),
                        preferences.rankedSlotIds(),
                        model);
                    model.addAttribute("_csrf", csrf);
                    return "pages/kholles/preferences-confirm";

                default:
                    return "redirect:/kholles/" + id + "/preferences?step=1";
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/kholles";
        }
    }

    /**
     * Traitement de la soumission des indisponibilités (étape 1)
     */
    @PostMapping("/{id}/preferences/step1")
    public String processStep1(
            @PathVariable Long id,
            @RequestParam(value = "unavailable-slots", required = false) List<Long> unavailableSlots,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user-auth/select";
        }

        // Récupérer et mettre à jour les préférences
        KhollePreferencesDto preferences = sessionService.getPreferences(session, id);
        preferences = preferences.withUnavailableSlots(unavailableSlots).nextStep();
        sessionService.savePreferences(session, preferences);

        return "redirect:/kholles/" + id + "/preferences?step=2";
    }

    /**
     * Traitement de la soumission du classement des préférences (étape 2)
     */
    @PostMapping("/{id}/preferences/step2")
    public String processStep2(
            @PathVariable Long id,
            @RequestParam(value = "ranked-slots", required = false) List<Long> rankedSlots,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user-auth/select";
        }

        // Récupérer et mettre à jour les préférences
        KhollePreferencesDto preferences = sessionService.getPreferences(session, id);
        preferences = preferences.withRankedSlots(rankedSlots).nextStep();
        sessionService.savePreferences(session, preferences);

        return "redirect:/kholles/" + id + "/preferences?step=3";
    }

    /**
     * Finalisation et enregistrement des préférences (étape 3)
     */
    @PostMapping("/{id}/preferences/save")
    public String savePreferences(
            @PathVariable Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user-auth/select";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Récupérer les préférences stockées
        KhollePreferencesDto preferences = sessionService.getPreferences(session, id);

        try {
            // Enregistrer les préférences
            preferenceService.savePreferences(userId, id,
                preferences.unavailableSlotIds(),
                preferences.rankedSlotIds());

            // Nettoyer la session
            sessionService.clearPreferences(session);

            redirectAttributes.addFlashAttribute("success", "Vos préférences ont été enregistrées avec succès!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement des préférences: " + e.getMessage());
        }

        return "redirect:/kholles/" + id;
    }

    /**
     * Gestion des mouvements de créneaux avec des redirections standard
     */
    @PostMapping("/{id}/reorder-slot")
    public String reorderSlot(
            @PathVariable Long id,
            @RequestParam("slotId") Long slotId,
            @RequestParam("direction") String direction,
            HttpSession session,
            RedirectAttributes redirectAttributes
    ) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user-auth/select";
        }

        // Log pour déboguer
        System.out.println("Réorganisation de slot: sessionId=" + id + ", slotId=" + slotId + ", direction=" + direction);

        // Utiliser le service pour réordonner les slots
        boolean success = kholleSlotService.reorderSlot(id, slotId, direction, session, null);

        if (!success) {
            redirectAttributes.addFlashAttribute("error", "Impossible de réorganiser les créneaux");
        }

        // Rediriger vers la page de préférences avec l'étape de classement
        return "redirect:/kholles/" + id + "/preferences?step=2";
    }
}
