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
    @SequenceGenerator(
            name = "user_preference_seq",
            sequenceName = "user_preference_seq",
            allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false)
    private KholleSession session;

    @ManyToOne(fetch = FetchType.LAZY)
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
    @Table(
            uniqueConstraints =
                    @UniqueConstraint(columnNames = {"user_id", "session_id", "slot_id"}))
    public static class UserPreferenceConstraints {}
}
