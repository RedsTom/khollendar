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
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "kholle_assignments", uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "session_id"}))
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder(toBuilder = true)
public class KholleAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_assignment_seq")
    @SequenceGenerator(name = "kholle_assignment_seq", sequenceName = "kholle_assignment_seq", allocationSize = 1)
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
    private LocalDateTime assignedAt;

    /**
     * Rang de préférence obtenu (1 = premier choix, 2 = deuxième choix, etc.) Null si l'étudiant
     * n'avait pas de préférences
     */
    @Column
    private Integer obtainedPreferenceRank;
}
