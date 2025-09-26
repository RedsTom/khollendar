package fr.redstom.khollesmanager.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity

@Table(name = "kholle_slot")

@NoArgsConstructor
@AllArgsConstructor

@Getter
@Builder(toBuilder = true)
public class KholleSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "kholle_slot_seq")
    @SequenceGenerator(name = "kholle_slot_seq", sequenceName = "kholle_slot_seq", allocationSize = 1)
    private Long id;

    @Column
    private LocalDateTime dateTime;

    @ManyToOne
    private KholleGroup group;
}
