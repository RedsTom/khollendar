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
import fr.redstom.khollendar.dto.KholleUnavailabilitiesDto;
import fr.redstom.khollendar.service.PreferenceService;
import fr.redstom.khollendar.service.SessionService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
            // Vérifier si l'utilisateur a déjà soumis ses préférences
            if (preferenceService.hasSubmittedPreferences(userId, kholleId)) {
                // Si oui, rediriger vers la page des préférences verrouillées
                return preferenceService.prepareLockedPreferencesView(model, kholleId, userId);
            }

            // Récupérer ou créer les préférences dans la session
            KhollePreferencesDto preferences = sessionService.getPreferences(session, kholleId);

            // Dispatcher vers la bonne méthode selon l'étape
            return switch (preferences.step()) {
                case 1 -> {
                    preferenceService.prepareUnavailabilityForm(
                            model, kholleId, userId, preferences.unavailableSlotIds());

                    yield "pages/kholles/preferences-indispo";
                }
                case 2 -> {
                    preferenceService.prepareRankingForm(
                            model, kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds());

                    yield "pages/kholles/preferences-ranking";
                }
                case 3 -> {
                    preferenceService.prepareConfirmationForm(
                            kholleId, userId, preferences.unavailableSlotIds(), preferences.rankedSlotIds(), model);
                    yield "pages/kholles/preferences-confirm";
                }

                default -> "redirect:/kholles/" + kholleId + "/preferences?step=1";
            };
        } catch (IllegalArgumentException e) {
            return "redirect:/kholles";
        }
    }

    /** Traitement de la soumission des indisponibilités (étape 1) */
    @PostMapping("/unavailabilities")
    public String saveUnavailabilities(
            @PathVariable Long kholleId,
            @ModelAttribute KholleUnavailabilitiesDto unavailabilities,
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
                .withUnavailableSlots(unavailabilities.unavailableSlotIds())
                .nextStep();
        sessionService.savePreferences(session, preferences);

        return "redirect:/kholles/" + kholleId + "/preferences";
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

        return "redirect:/kholles/" + kholleId + "/preferences";
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

        return "redirect:/kholles/" + kholleId + "/preferences";
    }
}
