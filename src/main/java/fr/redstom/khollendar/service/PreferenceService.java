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
package fr.redstom.khollendar.service;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.repository.UserPreferenceRepository;
import java.util.*;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * Service responsable de la gestion des préférences des utilisateurs pour les khôlles Prépare les
 * données pour les différentes étapes du processus de sélection des préférences
 */
@Service
@RequiredArgsConstructor
public class PreferenceService {

    private final KholleService kholleService;
    private final UserService userService;
    private final UserPreferenceRepository userPreferenceRepository;

    /**
     * Prépare les données pour le formulaire d'indisponibilités (étape 1)
     *
     * @param kholleId ID de la session de khôlle
     * @param userId ID de l'utilisateur
     * @param model Modèle Spring MVC
     * @param unavailableSlotIds Liste des créneaux indisponibles présélectionnés
     */
    public void prepareUnavailabilityForm(Model model, Long kholleId, Long userId, List<Long> unavailableSlotIds) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService
                .getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> slots = new ArrayList<>(kholleSession.kholleSlots());

        model.addAttribute("title", "Mes disponibilités pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("slots", slots);
        model.addAttribute("currentUser", user);
        model.addAttribute("unavailableSlotIds", unavailableSlotIds);
    }

    /**
     * Prépare les données pour le formulaire de classement des préférences (étape 2)
     *
     * @param kholleId ID de la session de khôlle
     * @param userId ID de l'utilisateur
     * @param unavailableSlotIds Liste des créneaux indisponibles
     * @param rankedSlotIds Liste des créneaux classés (ordre de préférence précédent)
     * @param model Modèle Spring MVC
     */
    public void prepareRankingForm(
            Model model, Long kholleId, Long userId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService
                .getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> slots = new ArrayList<>(kholleSession.kholleSlots());

        // Filtrer pour ne garder que les créneaux disponibles
        List<Long> finalUnavailableSlots = unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>();
        List<KholleSlot> availableSlots = slots.stream()
                .filter(slot -> !finalUnavailableSlots.contains(slot.id()))
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .collect(Collectors.toList());

        // Réorganiser selon le classement précédent s'il existe
        if (rankedSlotIds != null && !rankedSlotIds.isEmpty()) {
            availableSlots.sort(Comparator.comparing(slot -> {
                int index = rankedSlotIds.indexOf(slot.id());
                return index >= 0 ? index : Integer.MAX_VALUE;
            }));
        }

        model.addAttribute("title", "Classement de mes préférences pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("availableSlots", availableSlots);
        model.addAttribute("currentUser", user);
    }

    /**
     * Prépare les données pour la page de confirmation des préférences (étape 3)
     *
     * @param kholleId ID de la session de khôlle
     * @param userId ID de l'utilisateur
     * @param unavailableSlotIds Liste des créneaux indisponibles
     * @param rankedSlotIds Liste des créneaux classés par ordre de préférence
     * @param model Modèle Spring MVC
     */
    public void prepareConfirmationForm(
            Long kholleId, Long userId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds, Model model) {
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));

        KholleSession kholleSession = kholleService
                .getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> allSlots = new ArrayList<>(kholleSession.kholleSlots());
        allSlots.sort(Comparator.comparing(KholleSlot::dateTime));

        // Convertir les IDs en objets KholleSlot
        Set<KholleSlot> unavailableSlots = allSlots.stream()
                .filter(slot -> unavailableSlotIds != null && unavailableSlotIds.contains(slot.id()))
                .collect(Collectors.toSet());

        List<KholleSlot> rankedSlotsObjects = Optional.ofNullable(rankedSlotIds).orElse(new ArrayList<>()).stream()
                .map(slotId -> allSlots.stream()
                        .filter(s -> s.id().equals(slotId))
                        .findFirst()
                        .orElse(null))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        model.addAttribute("title", "Confirmation des préférences pour " + kholleSession.subject());
        model.addAttribute("session", kholleSession);
        model.addAttribute("currentUser", user);
        model.addAttribute("rankedSlots", rankedSlotsObjects);
        model.addAttribute("unavailableSlots", unavailableSlots);
        model.addAttribute("allSlots", allSlots);
    }

    /** Enregistre les préférences utilisateur pour une khôlle */
    public void savePreferences(Long userId, Long kholleId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds) {
        // Déléguer l'enregistrement au KholleService
        kholleService.savePreferences(
                userId,
                kholleId,
                unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>(),
                rankedSlotIds != null ? rankedSlotIds : new ArrayList<>());
    }

    /**
     * Vérifie si l'utilisateur a déjà soumis ses préférences pour une session de khôlle donnée
     *
     * @param userId L'ID de l'utilisateur
     * @param kholleId L'ID de la session de khôlle
     * @return true si l'utilisateur a déjà soumis ses préférences, false sinon
     */
    public boolean hasSubmittedPreferences(Long userId, Long kholleId) {
        User user = userService.getUserById(userId).orElse(null);
        KholleSession session = kholleService.getKholleSessionById(kholleId).orElse(null);

        if (user == null || session == null) {
            return false;
        }

        // Vérifie si des préférences existent pour cet utilisateur et cette session
        return userPreferenceRepository.existsByUserAndSession(user, session);
    }

    public String prepareLockedPreferencesView(Model model, Long kholleId, Long userId) {
        KholleSession kholleSession = kholleService
                .getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));
        User user = userService
                .getUserById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Utilisateur non trouvé"));

        model.addAttribute("session", kholleSession);
        model.addAttribute("currentUser", user);

        return "pages/kholles/preferences-locked";
    }
}
