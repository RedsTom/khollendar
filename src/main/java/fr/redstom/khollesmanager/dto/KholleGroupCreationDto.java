package fr.redstom.khollesmanager.dto;

import lombok.Builder;
import lombok.experimental.SuperBuilder;

@Builder
public record KholleGroupCreationDto(
        String subject,
        KholleCreationDto... slots
) {
}
