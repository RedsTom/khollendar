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

import fr.redstom.khollendar.entity.KholleAssignment;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.entity.User;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface KholleAssignmentRepository extends JpaRepository<KholleAssignment, Long> {

    /** Trouve l'affectation d'un utilisateur pour une session donnée */
    Optional<KholleAssignment> findByUserAndSession(User user, KholleSession session);

    /** Trouve toutes les affectations d'une session */
    List<KholleAssignment> findBySession(KholleSession session);

    /** Trouve toutes les affectations d'un créneau */
    List<KholleAssignment> findBySlot(KholleSlot slot);

    /** Compte le nombre d'étudiants affectés à un créneau */
    long countBySlot(KholleSlot slot);

    /** Supprime toutes les affectations d'une session */
    @Modifying
    @Query("DELETE FROM KholleAssignment ka WHERE ka.session = :session")
    void deleteBySession(@Param("session") KholleSession session);

    /** Vérifie si un utilisateur a déjà une affectation pour une session */
    boolean existsByUserAndSession(User user, KholleSession session);
}
