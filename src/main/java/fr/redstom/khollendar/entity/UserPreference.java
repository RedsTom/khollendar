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

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "user_preferences")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder(toBuilder = true)
public class UserPreference {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_preference_seq")
    @SequenceGenerator(name = "user_preference_seq", sequenceName = "user_preference_seq", allocationSize = 1)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "session_id", nullable = false)
    private KholleSession session;

    @ManyToOne
    @JoinColumn(name = "slot_id", nullable = false)
    private KholleSlot slot;

    @Column(nullable = false)
    private Integer preferenceRank;

    /**
     * Indique si cette préférence représente une indisponibilité (true) ou une préférence positive
     * (false). Si isUnavailable = true, le créneau ne doit JAMAIS être attribué à cet utilisateur.
     */
    @Column(nullable = false)
    @Builder.Default
    private Boolean isUnavailable = false;

    // Index unique pour éviter les doublons user/session/slot
    @Table(uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "session_id", "slot_id"}))
    public static class UserPreferenceConstraints {}
}
