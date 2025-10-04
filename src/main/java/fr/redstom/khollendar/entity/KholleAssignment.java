package fr.redstom.khollendar.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(
        name = "kholle_assignments",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "session_id"}))
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder(toBuilder = true)
public class KholleAssignment {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_assignment_seq")
    @SequenceGenerator(
            name = "kholle_assignment_seq",
            sequenceName = "kholle_assignment_seq",
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
    private LocalDateTime assignedAt;

    /**
     * Rang de préférence obtenu (1 = premier choix, 2 = deuxième choix, etc.) Null si l'étudiant
     * n'avait pas de préférences
     */
    @Column private Integer obtainedPreferenceRank;
}
