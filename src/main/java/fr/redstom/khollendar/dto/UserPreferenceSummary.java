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

import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.entity.UserPreference;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Résumé des préférences d'un utilisateur pour une session
 */
public record UserPreferenceSummary(
    User user,
    List<UserPreference> preferences
) {
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final int MAX_DISPLAY_ITEMS = 3;

    /**
     * Retourne une chaîne représentant les IDs des créneaux préférés
     * Format: "1, 3, 5" ou "1, 3, 5, ..." si plus de MAX_DISPLAY_ITEMS
     */
    public String getSlotIdsDisplay() {
        List<Long> slotIds = preferences.stream()
                .map(pref -> pref.slot().id())
                .limit(MAX_DISPLAY_ITEMS + 1)
                .toList();

        if (slotIds.size() > MAX_DISPLAY_ITEMS) {
            String firstIds = slotIds.stream()
                    .limit(MAX_DISPLAY_ITEMS)
                    .map(String::valueOf)
                    .collect(Collectors.joining(", "));
            return firstIds + ", ...";
        }

        return slotIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(", "));
    }

    /**
     * Retourne une chaîne représentant les dates des créneaux préférés
     * Format: "01/01/2024 10:00, 02/01/2024 14:00, ..." si plus de MAX_DISPLAY_ITEMS
     */
    public String getDatesDisplay() {
        List<LocalDateTime> dates = preferences.stream()
                .map(pref -> pref.slot().dateTime())
                .sorted()
                .limit(MAX_DISPLAY_ITEMS + 1)
                .toList();

        if (dates.size() > MAX_DISPLAY_ITEMS) {
            String firstDates = dates.stream()
                    .limit(MAX_DISPLAY_ITEMS)
                    .map(DATE_TIME_FORMATTER::format)
                    .collect(Collectors.joining(", "));
            return firstDates + ", ...";
        }

        return dates.stream()
                .map(DATE_TIME_FORMATTER::format)
                .collect(Collectors.joining(", "));
    }

    /**
     * Retourne le nombre total de préférences
     */
    public int getTotalPreferences() {
        return preferences.size();
    }

    /**
     * Retourne le nombre de préférences positives (hors indisponibilités)
     */
    public long getPositivePreferencesCount() {
        return preferences.stream()
                .filter(pref -> !pref.isUnavailable())
                .count();
    }

    /**
     * Retourne le nombre d'indisponibilités
     */
    public long getUnavailabilitiesCount() {
        return preferences.stream()
                .filter(UserPreference::isUnavailable)
                .count();
    }
}

