package fr.redstom.khollesmanager.entity;

import fr.redstom.khollesmanager.dto.DateRange;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Entity

@Table(name = "kholle_groups")

@NoArgsConstructor
@AllArgsConstructor

@Getter
@Builder(toBuilder = true)
public class KholleGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_group_seq")
    @SequenceGenerator(name = "kholle_group_seq", sequenceName = "kholle_group_seq", allocationSize = 1)
    private Long id;

    @Column(nullable = false)
    private String subject;

    @OneToMany
    private List<KholleSlot> kholleSlots;

    /**
     * Calcule la plage de dates couverte par tous les KholleSlot de ce groupe.
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

        if (minDate == null || maxDate == null) {
            return Optional.empty();
        }

        return Optional.of(new DateRange(minDate, maxDate));
    }
}
