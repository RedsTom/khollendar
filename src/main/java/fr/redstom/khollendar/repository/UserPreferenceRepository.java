package fr.redstom.khollendar.repository;

import fr.redstom.khollendar.entity.KholleSession;
import fr.redstom.khollendar.entity.User;
import fr.redstom.khollendar.entity.UserPreference;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserPreferenceRepository extends JpaRepository<UserPreference, Long> {

    /**
     * Trouve toutes les préférences d'un utilisateur pour une session donnée, ordonnées par rang de
     * préférence
     */
    List<UserPreference> findByUserAndSessionOrderByPreferenceRankAsc(
            User user, KholleSession session);

    /** Supprime toutes les préférences existantes d'un utilisateur pour une session */
    @Modifying
    @Query("DELETE FROM UserPreference up WHERE up.user = :user AND up.session = :session")
    void deleteByUserAndSession(@Param("user") User user, @Param("session") KholleSession session);

    /** Vérifie si un utilisateur a déjà enregistré ses préférences pour une session */
    boolean existsByUserAndSession(User user, KholleSession session);

    /**
     * Compte le nombre d'utilisateurs distincts ayant enregistré des préférences pour une session
     */
    @Query("SELECT COUNT(DISTINCT up.user) FROM UserPreference up WHERE up.session = :session")
    long countDistinctUsersBySession(@Param("session") KholleSession session);

    /**
     * Récupère toutes les préférences pour une session, triées par utilisateur puis par rang de
     * préférence
     */
    @Query(
            "SELECT up FROM UserPreference up WHERE up.session = :session ORDER BY up.user.id ASC,"
                    + " up.preferenceRank ASC")
    List<UserPreference> findBySessionOrderByUserIdAscPreferenceRankAsc(
            @Param("session") KholleSession session);
}
