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

import fr.redstom.khollendar.dto.DateRange;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "kholle_sessions")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder(toBuilder = true)
public class KholleSession {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_session_seq")
    @SequenceGenerator(name = "kholle_session_seq", sequenceName = "kholle_session_seq", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String subject;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private KholleSessionStatus status = KholleSessionStatus.REGISTRATIONS_OPEN;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL, fetch = FetchType.EAGER, orphanRemoval = true)
    private List<KholleSlot> kholleSlots;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserPreference> userPreferences;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<KholleAssignment> assignments;

    /**
     * Calcule la plage de dates couverte par tous les KholleSlot de cette session.
     *
     * @return Un objet contenant la date de début et de fin, ou null si aucun slot n'est présent
     */
    public Optional<DateRange> calculateDateRange() {
        if (kholleSlots == null || kholleSlots.isEmpty()) {
            return Optional.empty();
        }

        LocalDateTime minDate = kholleSlots.stream()
                .map(KholleSlot::dateTime)
                .min(LocalDateTime::compareTo)
                .orElse(null);

        LocalDateTime maxDate = kholleSlots.stream()
                .map(KholleSlot::dateTime)
                .max(LocalDateTime::compareTo)
                .orElse(null);

        return Optional.of(new DateRange(minDate, maxDate));
    }
}
