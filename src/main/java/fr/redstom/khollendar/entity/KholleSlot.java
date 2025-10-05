package fr.redstom.khollendar.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;
import lombok.*;

@Entity
@Table(name = "kholle_slot")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Builder(toBuilder = true)
public class KholleSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_slot_seq")
    @SequenceGenerator(
            name = "kholle_slot_seq",
            sequenceName = "kholle_slot_seq",
            allocationSize = 1)
    private Long id;

    @Column private LocalDateTime dateTime;

    @ManyToOne
    @JoinColumn(name = "session_id", nullable = false)
    private KholleSession session;

    @OneToMany(mappedBy = "slot", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserPreference> userPreferences;

    @OneToMany(mappedBy = "slot", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<KholleAssignment> assignments;
}
