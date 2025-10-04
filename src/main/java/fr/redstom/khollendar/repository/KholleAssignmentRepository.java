package fr.redstom.khollendar.repository;

import fr.redstom.khollendar.entity.KholleAssignment;
import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.KholleSlot;
import fr.redstom.khollendar.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface KholleAssignmentRepository extends JpaRepository<KholleAssignment, Long> {

    /**
     * Trouve l'affectation d'un utilisateur pour une session donnée
     */
    Optional<KholleAssignment> findByUserAndSession(User user, KholleSession session);

    /**
     * Trouve toutes les affectations d'une session
     */
    List<KholleAssignment> findBySession(KholleSession session);

    /**
     * Trouve toutes les affectations d'un créneau
     */
    List<KholleAssignment> findBySlot(KholleSlot slot);

    /**
     * Compte le nombre d'étudiants affectés à un créneau
     */
    long countBySlot(KholleSlot slot);

    /**
     * Supprime toutes les affectations d'une session
     */
    @Modifying
    @Query("DELETE FROM KholleAssignment ka WHERE ka.session = :session")
    void deleteBySession(@Param("session") KholleSession session);

    /**
     * Vérifie si un utilisateur a déjà une affectation pour une session
     */
    boolean existsByUserAndSession(User user, KholleSession session);
}

