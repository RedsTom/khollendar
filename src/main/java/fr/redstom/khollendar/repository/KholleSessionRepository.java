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
package fr.redstom.khollendar.repository;

import fr.redstom.khollendar.entity.KholleSession;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface KholleSessionRepository
        extends CrudRepository<KholleSession, Long>, PagingAndSortingRepository<KholleSession, Long> {

    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime > ?1"
            + " GROUP BY ks ORDER BY MIN(slot.dateTime) ASC")
    List<KholleSession> findUpcomingKholleSessions(LocalDateTime now);

    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime > ?1"
            + " GROUP BY ks ORDER BY MIN(slot.dateTime) ASC")
    Page<KholleSession> findUpcomingKholleSessionsPaged(LocalDateTime now, Pageable pageable);

    @Query("SELECT ks FROM KholleSession ks JOIN ks.kholleSlots slot WHERE slot.dateTime < ?1"
            + " GROUP BY ks ORDER BY MAX(slot.dateTime) DESC")
    Page<KholleSession> findPreviousKholleSessions(LocalDateTime now, Pageable pageable);

    Optional<KholleSession> findKholleSessionById(Long id);
}
