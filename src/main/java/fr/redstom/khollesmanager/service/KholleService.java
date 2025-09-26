package fr.redstom.khollesmanager.service;

import fr.redstom.khollesmanager.dto.KholleCreationDto;
import fr.redstom.khollesmanager.dto.KholleGroupCreationDto;
import fr.redstom.khollesmanager.entity.KholleGroup;
import fr.redstom.khollesmanager.entity.KholleSlot;
import fr.redstom.khollesmanager.repository.KholleGroupRepository;
import fr.redstom.khollesmanager.repository.KholleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class KholleService {

    private final KholleRepository kholleRepository;
    private final KholleGroupRepository kholleGroupRepository;


    public KholleGroup createKholle(KholleGroupCreationDto dto) {
        List<KholleSlot> slots = new ArrayList<>();

        KholleGroup group = KholleGroup.builder()
                .kholleSlots(slots)
                .subject(dto.subject())
                .build();

        for (KholleCreationDto slot : dto.slots()) {
            slots.add(KholleSlot.builder()
                    .group(group)
                    .dateTime(slot.time())
                    .build()
            );
        }

        kholleRepository.saveAll(slots);
        return kholleGroupRepository.save(group);
    }

}
