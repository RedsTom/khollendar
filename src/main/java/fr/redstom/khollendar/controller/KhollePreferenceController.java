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

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.service.KholleService;
import fr.redstom.khollendar.service.PreferenceService;
import fr.redstom.khollendar.service.SessionService;
import fr.redstom.khollendar.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpServerErrorException;

@Controller
@RequestMapping("/kholles/{kholleId}/preferences")
@RequiredArgsConstructor
public class KhollePreferenceController {
    private final SessionService sessionService;
    private final PreferenceService preferenceService;
    private final KholleService kholleService;
    private final UserService userService;

    /**
     * Formulaire de gestion des préférences pour une khôlle (entrée principale) Utilise un
     * paramètre d'étape pour naviguer entre les différentes vues
     */
    @GetMapping
    public String showPreferences(
            @PathVariable Long kholleId, HttpServletRequest request, HttpSession session, Model model) {

        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            sessionService.setRedirectAfterLogin(session, request.getRequestURI());
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        try {
            KholleSession kholleSession = kholleService
                    .getKholleSessionById(kholleId)
                    .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

            User user = userService
                    .getUserById(userId)
                    .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));

            model.addAttribute("session", kholleSession);
            model.addAttribute("currentUser", user);

            return "pages/kholles/preferences";
        } catch (IllegalArgumentException e) {
            return "redirect:/kholles";
        }
    }

    @GetMapping("/current-step")
    @PreAuthorize("#hxRequest == 'true'")
    public String getCurrentStepTemplate(
            @PathVariable Long kholleId,
            @RequestHeader("HX-Request") String hxRequest,
            HttpSession session,
            Model model) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Vérifier si l'utilisateur a déjà soumis ses préférences
        if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
            return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
        }

        // Récupérer les préférences dans la session
        KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);

        // Retourner le template correspondant à l'étape actuelle
        return switch (preferences.step()) {
            case 2 ->
                preferenceService.prepareRankingForm(
                        model, kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds());
            case 3 ->
                preferenceService.prepareConfirmationForm(
                        kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds(), model);
            default ->
                preferenceService.prepareUnavailabilityForm(model, kholleId, userId, preferences.unavailableSlotIds());
        };
    }

    /** Traitement de la soumission des indisponibilités (étape 1) */
    @PostMapping("/unavailabilities")
    public String saveUnavailabilities(
            @PathVariable Long kholleId,
            @RequestParam(name = "unavailable-slots", required = false) List<Long> unavailableSlots,
            Model model,
            HttpSession session) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            sessionService.setRedirectAfterLogin(session, "/kholles/" + kholleId + "/preferences");
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Vérifier si l'utilisateur a déjà soumis ses préférences
        if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
            return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
        }

        // Récupérer et mettre à jour les préférences
        KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);
        preferences = preferences
                .withUnavailableSlots(unavailableSlots)
                .nextStep();
        sessionService.savePreferences(session, preferences);

        return preferenceService.prepareRankingForm(
                model, kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds());
    }

    /** Traitement de la soumission du classement des préférences (étape 2) */
    @PostMapping("/ranking")
    public String processStep2(
            @PathVariable Long kholleId,
            @RequestParam(value = "ranked-slots", required = false) List<Long> rankedSlots,
            HttpSession session,
            Model model) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            sessionService.setRedirectAfterLogin(session, "/kholles/" + kholleId + "/preferences");
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Vérifier si l'utilisateur a déjà soumis ses préférences
        if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
            return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
        }

        // Récupérer et mettre à jour les préférences
        KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);
        preferences = preferences.withRankedSlots(rankedSlots).nextStep();
        sessionService.savePreferences(session, preferences);

        return preferenceService.prepareConfirmationForm(
                kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds(), model);
    }

    /** Finalisation et enregistrement des préférences (étape 3) */
    @PostMapping("/confirm")
    public String savePreferences(@PathVariable Long kholleId, HttpSession session, Model model) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Vérifier si l'utilisateur a déjà soumis ses préférences
        if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
            return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
        }

        // Récupérer les préférences stockées
        KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);

        try {
            // Enregistrer les préférences
            preferenceService.savePreferences(
                    userId, kholleId, preferences.unavailableSlotIds(), preferences.rankedSlotIds());

            // Réinitialiser complètement la session utilisateur
            sessionService.clearUserSession(session);
        } catch (Exception e) {
            throw new HttpServerErrorException(HttpStatus.INTERNAL_SERVER_ERROR, e.getMessage());
        }

        return "redirect:/kholles/" + kholleId;
    }

    @PostMapping("/previous")
    public String goToPreviousStep(@PathVariable Long kholleId, HttpSession session, Model model) {
        // Vérifier si l'utilisateur est authentifié
        if (!sessionService.isUserAuthenticated(session)) {
            return "redirect:/user/login";
        }

        Long userId = sessionService.getCurrentUserId(session);

        // Vérifier si l'utilisateur a déjà soumis ses préférences
        if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
            return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
        }

        // Récupérer et mettre à jour les préférences
        KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);
        preferences = preferences.previousStep();
        sessionService.savePreferences(session, preferences);

        return getCurrentStepTemplate(kholleId, "true", session, model);
    }
}
