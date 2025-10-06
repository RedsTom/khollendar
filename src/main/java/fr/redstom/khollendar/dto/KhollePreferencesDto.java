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
package fr.redstom.khollendar.dto;

import java.util.ArrayList;
import java.util.List;

/** Data Transfer Object pour gérer les préférences utilisateur sur une session de khôlle */
public record KhollePreferencesDto(
        Long kholleSessionId, List<Long> unavailableSlotIds, List<Long> rankedSlotIds, int step) {
    /** Constructeur avec valeurs par défaut */
    public KhollePreferencesDto(Long kholleSessionId) {
        this(kholleSessionId, new ArrayList<>(), new ArrayList<>(), 1);
    }

    /** Avance à l'étape suivante */
    public KhollePreferencesDto nextStep() {
        return new KhollePreferencesDto(kholleSessionId, unavailableSlotIds, rankedSlotIds, step + 1);
    }

    /** Revient à l'étape précédente */
    public KhollePreferencesDto previousStep() {
        return new KhollePreferencesDto(kholleSessionId, unavailableSlotIds, rankedSlotIds, Math.max(1, step - 1));
    }

    /** Met à jour les créneaux indisponibles */
    public KhollePreferencesDto withUnavailableSlots(List<Long> newUnavailableSlotIds) {
        return new KhollePreferencesDto(
                kholleSessionId,
                newUnavailableSlotIds != null ? newUnavailableSlotIds : new ArrayList<>(),
                rankedSlotIds,
                step);
    }

    /** Met à jour les créneaux classés par préférence */
    public KhollePreferencesDto withRankedSlots(List<Long> newRankedSlotIds) {
        return new KhollePreferencesDto(
                kholleSessionId,
                unavailableSlotIds,
                newRankedSlotIds != null ? newRankedSlotIds : new ArrayList<>(),
                step);
    }
}
