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
package fr.redstom.khollendar.entity;

/** Énumération représentant les différents états possibles d'une session de khôlle */
public enum KholleSessionStatus {
    /** Les inscriptions sont ouvertes, les utilisateurs peuvent enregistrer leurs préférences */
    REGISTRATIONS_OPEN("Inscriptions ouvertes"),

    /**
     * Les inscriptions sont fermées, les utilisateurs ne peuvent plus modifier leurs préférences
     */
    REGISTRATIONS_CLOSED("Inscriptions fermées"),

    /** Les résultats sont disponibles, les affectations ont été effectuées */
    RESULTS_AVAILABLE("Résultats disponibles");

    private final String label;

    KholleSessionStatus(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
