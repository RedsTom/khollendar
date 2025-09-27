package fr.redstom.khollesmanager.dto;

import lombok.Builder;
import lombok.NonNull;

import java.util.Arrays;

@Builder
public record KholleSessionCreationDto(
        String subject,
        KholleCreationDto... slots
) {
    @Override
    @NonNull
    public String toString() {
        return "KholleSessionCreationDto{" +
               "subject='" + subject + '\'' +
               ", slots=" + Arrays.toString(slots) +
               '}';
    }
}
