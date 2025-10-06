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

import fr.redstom.khollendar.dto.KhollePreferencesDto;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * Service de gestion des créneaux de khôlles Gère le réordonnancement des préférences utilisateur
 * pour les créneaux
 */
@Service
@RequiredArgsConstructor
public class KholleSlotService {

    private final KholleService kholleService;
    private final SessionService sessionService;

    /**
     * Réordonne un créneau dans la liste des préférences de l'utilisateur
     *
     * @param sessionId ID de la session de khôlle
     * @param slotId ID du créneau à déplacer
     * @param direction Direction ("up" ou "down")
     * @param httpSession Session HTTP pour récupérer/stocker les préférences
     * @param model Modèle pour la vue (peut être null si utilisé avec redirection)
     * @return true si la réorganisation a réussi, false sinon
     */
    public boolean reorderSlot(Long sessionId, Long slotId, String direction, HttpSession httpSession, Model model) {
        if (slotId == null || direction == null) {
            return false;
        }

        Long userId = sessionService.getCurrentUserId(httpSession);
        if (userId == null) {
            return false;
        }

        KhollePreferencesDto preferences = sessionService.getPreferences(httpSession, sessionId);
        if (preferences == null) {
            return false;
        }

        boolean moveUp = "up".equalsIgnoreCase(direction);

        try {
            List<KholleSlot> reorderedSlots =
                    doReorderSlots(sessionId, preferences.unavailableSlotIds(), slotId, moveUp);

            if (model != null) {
                model.addAttribute("availableSlots", reorderedSlots);
            }

            // Mettre à jour les préférences dans la session
            List<Long> newOrder = reorderedSlots.stream().map(KholleSlot::id).collect(Collectors.toList());
            KhollePreferencesDto updatedPrefs = preferences.withRankedSlots(newOrder);
            sessionService.savePreferences(httpSession, updatedPrefs);

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Effectue le réordonnancement des créneaux disponibles
     *
     * @param kholleId ID de la session de khôlle
     * @param unavailableSlotIds IDs des créneaux indisponibles
     * @param slotIdToMove ID du créneau à déplacer
     * @param moveUp true pour monter, false pour descendre
     * @return Liste des créneaux réordonnés
     */
    private List<KholleSlot> doReorderSlots(
            Long kholleId, List<Long> unavailableSlotIds, Long slotIdToMove, boolean moveUp) {
        KholleSession kholleSession = kholleService
                .getKholleSessionById(kholleId)
                .orElseThrow(() -> new IllegalArgumentException("Session de khôlle non trouvée"));

        List<KholleSlot> allSlots = new ArrayList<>(kholleSession.kholleSlots());
        List<Long> finalUnavailableSlots = unavailableSlotIds != null ? unavailableSlotIds : new ArrayList<>();

        // Filtrer les créneaux disponibles et les trier par date
        List<KholleSlot> availableSlots = allSlots.stream()
                .filter(slot -> !finalUnavailableSlots.contains(slot.id()))
                .sorted(Comparator.comparing(KholleSlot::dateTime))
                .collect(Collectors.toList());

        // Trouver l'index du créneau à déplacer
        int currentIndex = -1;
        for (int i = 0; i < availableSlots.size(); i++) {
            if (availableSlots.get(i).id().equals(slotIdToMove)) {
                currentIndex = i;
                break;
            }
        }

        // Échanger les positions si possible
        if (moveUp && currentIndex > 0) {
            Collections.swap(availableSlots, currentIndex, currentIndex - 1);
        } else if (!moveUp && currentIndex >= 0 && currentIndex < availableSlots.size() - 1) {
            Collections.swap(availableSlots, currentIndex, currentIndex + 1);
        }

        return availableSlots;
    }
}
